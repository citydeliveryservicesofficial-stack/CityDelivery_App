/// Mirrors `src/utils/gallery.js`: eight gallery items (Gal1..Gal8 in order) with their captions/details.
class GalleryItem {
  const GalleryItem({
    required this.index,
    required this.slug,
    required this.asset,
    required this.title,
    required this.text,
    required this.category,
    required this.description,
    required this.highlights,
  });

  final int index; // 1-based
  final String slug;
  final String asset;
  final String title;
  final String text;
  final String category;
  final String description;
  final List<String> highlights;
}

const List<GalleryItem> kGalleryItems = [
  GalleryItem(
    index: 1,
    slug: 'doorstep-delivery',
    asset: 'assets/images/gallery/gal1.webp',
    title: 'Doorstep delivery',
    text: 'Right to your door, hassle free',
    category: 'Doorstep service',
    description: 'You share the product and store, then add the address where it should reach. Our team reviews the request, confirms the details with you and keeps the conversation personal from start to finish.',
    highlights: [
      'Request-based service — submitting does not place an automatic order',
      'Tell us the store and the exact product you need',
      'We contact you directly to confirm availability and next steps',
      'Keep the Request ID shown on your confirmation screen',
    ],
  ),
  GalleryItem(
    index: 2,
    slug: 'groceries-daily-needs',
    asset: 'assets/images/gallery/gal2.webp',
    title: 'Groceries & daily needs',
    text: 'Fresh picks from your favourite store',
    category: 'Everyday essentials',
    description: 'Whether it is a weekly shop or one missing item, tell us the store and the products you need. Add a photo if the exact brand matters, and our team will work from the details you provide.',
    highlights: [
      'Name more than one product in a single request',
      'Attach an optional JPG, PNG or WebP photo up to 5 MB',
      'Choose the store you already trust',
      'Availability, price and timing are confirmed with you first',
    ],
  ),
  GalleryItem(
    index: 3,
    slug: 'medicines-health',
    asset: 'assets/images/gallery/gal3.webp',
    title: 'Medicines & health',
    text: 'When you need it most',
    category: 'Health & pharmacy',
    description: 'Share the medicine, the pharmacy and your delivery details. We review the request and speak with you directly to confirm what is available before anything is arranged.',
    highlights: [
      'Mention the exact product and the store it comes from',
      'Add a photo of the pack if it helps identify the item',
      'Our team confirms availability with you first',
      'Clear communication at every step of your request',
    ],
  ),
  GalleryItem(
    index: 4,
    slug: 'gifts-surprises',
    asset: 'assets/images/gallery/gal4.webp',
    title: 'Gifts & surprises',
    text: 'Delivered with a smile',
    category: 'Gifts',
    description: 'Pick the gift and the store, add where it should go, and let us know any delivery notes. We handle the request personally so the surprise stays on your terms.',
    highlights: [
      'Choose any store and any product',
      'Add delivery notes in the request form',
      'Receive a confirmation email with your Request ID',
      'A team member follows up with the next steps',
    ],
  ),
  GalleryItem(
    index: 5,
    slug: 'shoes-fashion',
    asset: 'assets/images/gallery/gal5.webp',
    title: 'Shoes & fashion',
    text: 'Any store, any product',
    category: 'Fashion & apparel',
    description: 'Found the pair online or in a store? Share the store, size and product details. We work from your request and confirm the specifics with you before proceeding.',
    highlights: [
      'Include size, colour and store in your request',
      'An optional product photo helps us identify the item',
      'No account or app is needed to submit a request',
      'We confirm the details with you personally',
    ],
  ),
  GalleryItem(
    index: 6,
    slug: 'electronics-gadgets',
    asset: 'assets/images/gallery/gal6.webp',
    title: 'Electronics & gadgets',
    text: 'Handled with care',
    category: 'Electronics',
    description: 'From accessories to a specific gadget, tell us the model and where it is available. A clear description helps us understand exactly what you are asking for.',
    highlights: [
      'Add the model and store details',
      'Attach a photo if the product has similar variants',
      'Every request is reviewed by our team',
      'We confirm availability, price and timing with you',
    ],
  ),
  GalleryItem(
    index: 7,
    slug: 'documents-related-info',
    asset: 'assets/images/gallery/gal7.webp',
    title: 'Documents & related info',
    text: 'Handed over with care',
    category: 'Documents',
    description: 'Add one or many items from one or many stores in a single request, then share the document or packet details and one delivery address. Our team reviews every item, confirms what is accepted, and keeps everything under one Request ID.',
    highlights: [
      'Add multiple products and stores to one request',
      'Give each item its own product and pickup details',
      'Use one delivery address and one Request ID for everything',
      'We confirm eligibility and next steps with you first',
    ],
  ),
  GalleryItem(
    index: 8,
    slug: 'on-time-every-time',
    asset: 'assets/images/gallery/gal8.webp',
    title: 'On time, every time',
    text: "We'll keep you posted",
    category: 'Communication',
    description: 'We keep the process clear: submit your request, look out for the confirmation email, and stay in touch with our team as availability, price and timing are confirmed.',
    highlights: [
      'Confirmation appears right after you submit',
      'Keep your Request ID for your records',
      'Availability, price and timing are confirmed with you',
      'Reach our team any time through the Contact page',
    ],
  ),
];

GalleryItem? galleryItemBySlug(String slug) {
  for (final g in kGalleryItems) {
    if (g.slug == slug) return g;
  }
  return null;
}
