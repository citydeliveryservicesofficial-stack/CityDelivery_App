import 'package:flutter/material.dart';

import '../core/utils/helpers.dart';
import '../data/services/api_exception.dart';
import '../data/services/api_service.dart';

/// State for the Contact form (src/pages/Contact.jsx).
class ContactProvider extends ChangeNotifier {
  ContactProvider(this._api);

  final ApiService _api;

  final name = TextEditingController();
  final email = TextEditingController();
  final subject = TextEditingController();
  final message = TextEditingController();

  Map<String, String> errors = {};
  bool sending = false;
  String done = '';
  String formError = '';

  void clearError(String k) {
    if (errors.containsKey(k)) {
      errors.remove(k);
      notifyListeners();
    }
  }

  void clearDone() {
    done = '';
    notifyListeners();
  }

  Future<void> submit() async {
    if (sending) return;
    final er = <String, String>{};
    if (name.text.trim().length < 2) er['name'] = 'Please enter your name.';
    if (!kEmailRegex.hasMatch(email.text.trim()))
      er['email'] = 'Please enter a valid email address.';
    if (message.text.trim().length < 10)
      er['message'] = 'Please write at least 10 characters.';
    errors = er;
    if (er.isNotEmpty) {
      notifyListeners();
      return;
    }

    sending = true;
    formError = '';
    notifyListeners();
    try {
      done = await _api.submitContactMessage({
        'name': name.text.trim(),
        'email': email.text.trim(),
        'subject': subject.text.trim(),
        'message': message.text.trim(),
        'website': '', // honeypot
      });
      name.clear();
      email.clear();
      subject.clear();
      message.clear();
    } on ApiException catch (err) {
      errors = Map.of(err.fieldErrors);
      formError = err.message;
    } catch (_) {
      formError = 'Something went wrong. Please try again.';
    } finally {
      sending = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    subject.dispose();
    message.dispose();
    super.dispose();
  }
}
