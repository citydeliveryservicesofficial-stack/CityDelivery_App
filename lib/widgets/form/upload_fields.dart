import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/upload_file.dart';
import 'form_widgets.dart';

enum _Source { camera, gallery, files }

/// Result of a pick attempt: either a file or a validation message (same texts as the website).
class PickOutcome {
  const PickOutcome({this.file, this.error});
  final UploadFile? file;
  final String? error;
}

Future<_Source?> _chooseSource(
  BuildContext context, {
  required bool allowFiles,
}) {
  return showModalBottomSheet<_Source>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            _SourceTile(
              icon: LucideIcons.camera,
              label: 'Take a photo',
              onTap: () => Navigator.pop(ctx, _Source.camera),
            ),
            _SourceTile(
              icon: LucideIcons.image,
              label: 'Choose from gallery',
              onTap: () => Navigator.pop(ctx, _Source.gallery),
            ),
            if (allowFiles)
              _SourceTile(
                icon: LucideIcons.fileText,
                label: 'Choose a file (PDF or image)',
                onTap: () => Navigator.pop(ctx, _Source.files),
              ),
          ],
        ),
      ),
    ),
  );
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.yellow,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: AppColors.dark),
      ),
      title: Text(
        label,
        style: AppText.body(size: 15, weight: FontWeight.w700),
      ),
    );
  }
}

/// Opens the picker sheet and validates type/size like ImageUpload.jsx / DocumentUpload.jsx.
Future<PickOutcome?> pickUpload(
  BuildContext context, {
  required bool allowPdf,
  required bool allowFilesOption,
}) async {
  final source = await _chooseSource(context, allowFiles: allowFilesOption);
  if (source == null) return null;

  String? path;
  String? name;
  try {
    if (source == _Source.files) {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowPdf
            ? const ['jpg', 'jpeg', 'png', 'webp', 'pdf']
            : const ['jpg', 'jpeg', 'png', 'webp'],
      );
      if (res == null || res.files.isEmpty) return null;
      path = res.files.single.path;
      name = res.files.single.name;
    } else {
      final x = await ImagePicker().pickImage(
        source: source == _Source.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: 2400,
        imageQuality: 88,
      );
      if (x == null) return null;
      path = x.path;
      name = x.name;
    }
  } catch (_) {
    return const PickOutcome(
      error: 'We could not open that file. Please try again.',
    );
  }
  if (path == null)
    return const PickOutcome(
      error: 'We could not open that file. Please try again.',
    );

  final mime = UploadFile.mimeFromName(name ?? path);
  final okMime =
      kAllowedImageMimes.contains(mime) ||
      (allowPdf && mime == 'application/pdf');
  if (!okMime) {
    return PickOutcome(
      error: allowPdf
          ? 'Please choose a JPG, PNG, WebP or PDF file.'
          : 'Please choose a JPG, PNG or WebP image.',
    );
  }
  final size = await File(path).length();
  if (size > kMaxImageBytes) {
    return PickOutcome(
      error: allowPdf
          ? 'That file is larger than 5 MB. Please choose a smaller one.'
          : 'That image is larger than 5 MB. Please choose a smaller one.',
    );
  }
  return PickOutcome(
    file: UploadFile(
      path: path,
      name: name ?? path.split('/').last,
      size: size,
      mimeType: mime,
    ),
  );
}

/// Shared look for the "tap to upload" zone and the selected-file card.
class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.file,
    required this.onPick,
    required this.onRemove,
    required this.title,
    required this.subtitle,
    required this.previewSize,
    this.error,
    this.compact = false,
  });

  final UploadFile? file;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final String title;
  final String subtitle;
  final double previewSize;
  final String? error;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x0D000000)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: file!.isImage
                  ? Image.file(
                      File(file!.path),
                      width: previewSize,
                      height: previewSize,
                      fit: BoxFit.cover,
                      cacheWidth: 300,
                      errorBuilder: (_, __, ___) => _filePlaceholder(),
                    )
                  : _filePlaceholder(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(size: 15, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${(file!.size / 1024).toStringAsFixed(0)} KB — ready to upload',
                    style: AppText.body(size: 13, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Semantics(
              button: true,
              label: 'Remove file',
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.dark,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.x,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: onPick,
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: error != null
              ? AppColors.red500
              : AppColors.yellowDeep.withValues(alpha: 0.6),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: compact ? 22 : 30,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                width: compact ? 44 : 48,
                height: compact ? 44 : 48,
                decoration: const BoxDecoration(
                  color: AppColors.yellow,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  compact ? LucideIcons.uploadCloud : LucideIcons.imagePlus,
                  size: 21,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppText.body(size: 15, weight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppText.body(size: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filePlaceholder() => Container(
    width: previewSize,
    height: previewSize,
    color: AppColors.light,
    child: const Icon(LucideIcons.fileText, size: 24, color: AppColors.green),
  );
}

/// Product image (ImageUpload.jsx): JPG/PNG/WebP up to 5 MB, optional.
class ImageUploadField extends StatefulWidget {
  const ImageUploadField({
    super.key,
    required this.file,
    required this.onChanged,
    this.error,
  });
  final UploadFile? file;
  final ValueChanged<UploadFile?> onChanged;
  final String? error;

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  String _local = '';

  Future<void> _pick() async {
    final out = await pickUpload(
      context,
      allowPdf: false,
      allowFilesOption: false,
    );
    if (out == null || !mounted) return;
    setState(() => _local = out.error ?? '');
    if (out.file != null) widget.onChanged(out.file);
  }

  @override
  Widget build(BuildContext context) {
    final shown = _local.isNotEmpty ? _local : widget.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _UploadBox(
          file: widget.file,
          onPick: _pick,
          onRemove: () {
            setState(() => _local = '');
            widget.onChanged(null);
          },
          title: 'Tap to upload a photo',
          subtitle: 'JPG, PNG or WebP · up to 5 MB',
          previewSize: 96,
          error: shown,
        ),
        if (shown != null && shown.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              shown,
              style: AppText.body(
                size: 14,
                weight: FontWeight.w600,
                color: AppColors.red600,
              ),
            ),
          ),
      ],
    );
  }
}

/// Rider document slot (DocumentUpload.jsx): JPG/PNG/WebP/PDF up to 5 MB.
class DocumentUploadField extends StatefulWidget {
  const DocumentUploadField({
    super.key,
    required this.label,
    required this.hint,
    required this.file,
    required this.onChanged,
    this.required = false,
    this.imageOnly = false,
    this.error,
  });

  final String label;
  final String hint;
  final UploadFile? file;
  final ValueChanged<UploadFile?> onChanged;
  final bool required;
  final bool imageOnly;
  final String? error;

  @override
  State<DocumentUploadField> createState() => _DocumentUploadFieldState();
}

class _DocumentUploadFieldState extends State<DocumentUploadField> {
  String _local = '';

  Future<void> _pick() async {
    final out = await pickUpload(
      context,
      allowPdf: !widget.imageOnly,
      allowFilesOption: true,
    );
    if (out == null || !mounted) return;
    setState(() => _local = out.error ?? '');
    if (out.file != null) widget.onChanged(out.file);
  }

  @override
  Widget build(BuildContext context) {
    final shown = _local.isNotEmpty ? _local : widget.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: AppText.body(
              size: 14,
              weight: FontWeight.w700,
              color: AppColors.dark,
            ),
            children: [
              TextSpan(text: widget.label),
              if (widget.required)
                TextSpan(
                  text: ' *',
                  style: AppText.body(
                    size: 14,
                    weight: FontWeight.w700,
                    color: AppColors.red600,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          widget.hint,
          style: AppText.body(size: 12, color: AppColors.muted),
        ),
        const SizedBox(height: 8),
        _UploadBox(
          file: widget.file,
          onPick: _pick,
          onRemove: () {
            setState(() => _local = '');
            widget.onChanged(null);
          },
          title: 'Choose file or take a photo',
          subtitle: widget.imageOnly
              ? 'JPG, PNG or WebP · up to 5 MB'
              : 'JPG, PNG, WebP or PDF · up to 5 MB',
          previewSize: 64,
          error: shown,
          compact: true,
        ),
        if (shown != null && shown.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              shown,
              style: AppText.body(
                size: 14,
                weight: FontWeight.w600,
                color: AppColors.red600,
              ),
            ),
          ),
      ],
    );
  }
}
