/// Mirrors `src/utils/config.js` and `src/utils/rider.js` of the website.
class Site {
  Site._();

  static const String name = 'City Delivery Services';

  // Same defaults as the website's SITE config (VITE_* env vars override them there).
  static const String email = String.fromEnvironment(
    'CONTACT_EMAIL',
    defaultValue: 'citydeliveryservicesofficial@gmail.com',
  );
  static const String phone = String.fromEnvironment(
    'CONTACT_PHONE',
    defaultValue: '8189800888',
  );
  static const String address = String.fromEnvironment(
    'BUSINESS_ADDRESS',
    defaultValue: 'Head office: No. 7, Thendral Nagar, Sathuvachari, Vellore, 632009 — Above Citywash Building',
  );

  /// Empty values are hidden in the UI, exactly like the website.
  static const Map<String, String> social = {
    'Instagram': String.fromEnvironment('SOCIAL_INSTAGRAM'),
    'Facebook': String.fromEnvironment('SOCIAL_FACEBOOK'),
    'X': String.fromEnvironment('SOCIAL_X'),
    'WhatsApp': String.fromEnvironment('SOCIAL_WHATSAPP'),
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
