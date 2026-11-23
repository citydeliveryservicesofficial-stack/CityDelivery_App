import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Mirrors `src/utils/config.js` and `src/utils/rider.js` of the website.
class Site {
  Site._();

  static const String name = 'City Delivery Services';

  static const _defineContactEmail = String.fromEnvironment('CONTACT_EMAIL');
  static const _defineContactPhone = String.fromEnvironment('CONTACT_PHONE');
  static const _defineBusinessAddress = String.fromEnvironment('BUSINESS_ADDRESS');
  static const _defineSocialInstagram = String.fromEnvironment('SOCIAL_INSTAGRAM');
  static const _defineSocialFacebook = String.fromEnvironment('SOCIAL_FACEBOOK');
  static const _defineSocialX = String.fromEnvironment('SOCIAL_X');
  static const _defineSocialWhatsapp = String.fromEnvironment('SOCIAL_WHATSAPP');

  static String _env(String defined, String key, [String fallback = '']) {
    if (defined.isNotEmpty) return defined;
    final loaded = dotenv.env[key];
    if (loaded != null && loaded.isNotEmpty) return loaded;
    return fallback;
  }

  static String get email => _env(
        _defineContactEmail,
        'CONTACT_EMAIL',
        'citydeliveryservicesofficial@gmail.com',
      );
  static String get phone =>
      _env(_defineContactPhone, 'CONTACT_PHONE', '8189800888');
  static String get address => _env(
        _defineBusinessAddress,
        'BUSINESS_ADDRESS',
        'Head office: No. 7, Thendral Nagar, Sathuvachari, Vellore, 632009 — Above Citywash Building',
      );

  /// Empty values are hidden in the UI, exactly like the website.
  static Map<String, String> get social => {
        'Instagram': _env(_defineSocialInstagram, 'SOCIAL_INSTAGRAM'),
        'Facebook': _env(_defineSocialFacebook, 'SOCIAL_FACEBOOK'),
        'X': _env(_defineSocialX, 'SOCIAL_X'),
        'WhatsApp': _env(_defineSocialWhatsapp, 'SOCIAL_WHATSAPP'),
      };

  static const String websiteUrl = 'https://www.citydeliveryservices.com';
}

const List<String> kCategories = [
  'Groceries',
  'Fashion & Apparel',
  'Electronics',
  'Home & Kitchen',
  'Health & Beauty',
  'Books & Stationery',
  'Gifts',
  'Other',
];

const int kMaxImageBytes = 5 * 1024 * 1024;
const List<String> kAllowedImageMimes = [
  'image/jpeg',
  'image/png',
  'image/webp',
];
const String kProhibitedItemsPolicyVersion = '2026-11-20';

class NavLink {
  final String route;
  final String label;
  const NavLink(this.route, this.label);
}

const List<NavLink> kNavLinks = [
  NavLink('/', 'Home'),
  NavLink('/how-it-works', 'How it works'),
  NavLink('/about', 'About'),
  NavLink('/contact', 'Contact'),
];

// ---- Rider constants (src/utils/rider.js) ----
const List<String> kRiderStatuses = [
  'Submitted',
  'Under Review',
  'Additional Documents Required',
  'Approved',
  'Rejected',
  'Inactive',
];
const List<String> kRiderWorkTypes = ['Full Time', 'Part Time', 'Flexible'];
const List<String> kRiderVehicleTypes = [
  'Motorcycle',
  'Scooter',
  'Electric Bike',
  'Three Wheeler',
  'Mini Truck',
];
const List<String> kRiderGenders = [
  'Male',
  'Female',
  'Other',
  'Prefer not to say',
];
const List<String> kRiderAvailabilityDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
const List<String> kRiderSteps = [
  'Personal details',
  'Address',
  'Driving & vehicle',
  'Work preferences',
  'Verification & payment',
  'Documents',
];

class RiderDocSpec {
  final String key;
  final String label;
  final String hint;
  final bool imageOnly;

  /// null => always shown. Otherwise one of: ownsVehicle, insurance, aadhaar.
  final String? when;
  const RiderDocSpec(
    this.key,
    this.label,
    this.hint, {
    this.imageOnly = false,
    this.when,
  });
}

const List<RiderDocSpec> kRiderDocuments = [
  RiderDocSpec(
    'profilePhoto',
    'Profile photo',
    'A clear recent photo of yourself.',
    imageOnly: true,
  ),
  RiderDocSpec(
    'licenceFront',
    'Driving licence — front',
    'Plain, readable scan or photo.',
  ),
  RiderDocSpec(
    'licenceBack',
    'Driving licence — back',
    'Plain, readable scan or photo.',
  ),
  RiderDocSpec(
    'vehicleRcFront',
    'Vehicle RC — front',
    'Required if you own a vehicle.',
    when: 'ownsVehicle',
  ),
  RiderDocSpec(
    'vehicleRcBack',
    'Vehicle RC — back',
    'Required if you own a vehicle.',
    when: 'ownsVehicle',
  ),
  RiderDocSpec(
    'vehiclePhoto',
    'Vehicle photo',
    'Show the full vehicle and number plate.',
    imageOnly: true,
    when: 'ownsVehicle',
  ),
  RiderDocSpec(
    'insuranceDocument',
    'Insurance proof',
    'Required if insurance is enabled or marked available.',
    when: 'insurance',
  ),
  RiderDocSpec(
    'aadhaarDocument',
    'Aadhaar proof',
    'Only if requested or provided.',
    when: 'aadhaar',
  ),
  RiderDocSpec(
    'panDocument',
    'PAN proof',
    'PAN card or proof showing your PAN.',
  ),
  RiderDocSpec(
    'cancelledCheque',
    'Cancelled cheque / passbook',
    'Optional bank proof.',
  ),
  RiderDocSpec(
    'additionalDocument1',
    'Additional document 1',
    'Only if requested.',
  ),
  RiderDocSpec(
    'additionalDocument2',
    'Additional document 2',
    'Only if requested.',
  ),
];
