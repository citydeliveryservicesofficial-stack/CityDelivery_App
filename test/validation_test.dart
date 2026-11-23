import 'package:flutter_test/flutter_test.dart';

import 'package:city_delivery_services/core/utils/helpers.dart';

void main() {
  test('email regex matches website rule', () {
    expect(kEmailRegex.hasMatch('a@b.co'), isTrue);
    expect(kEmailRegex.hasMatch('a@b'), isFalse);
  });

  test('phone validation', () {
    expect(isValidPhone('+91 98765 43210'), isTrue);
    expect(isValidPhone('123'), isFalse);
  });

  test('submission key looks like a uuid', () {
    expect(
      newSubmissionKey(),
      matches(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
  });
}
