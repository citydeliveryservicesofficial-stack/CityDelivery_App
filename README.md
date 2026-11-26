# City Delivery Services — Flutter app

Flutter (Android + iOS) port of the City Delivery Services React website. It talks to the **same** Node/Express/MongoDB
backend as the website — no new endpoints, no separate database, no dummy data.

> **Status:** this code was written by reading your React source; it has **not been compiled or run** (no Flutter SDK was
> available where it was produced). All 45 Dart files parse cleanly, but expect to fix a handful of compile errors
> (usually an icon name or a package version) on the first `flutter analyze`. Requires **Flutter ≥ 3.27**.

## Run it

```bash
bash setup_platforms.sh
cp .env.example .env
flutter run
```
The app loads `.env` at startup. `API_URL` is the deployed API (`https://city-delivery-be.vercel.app/api`) or your local
backend. The fallback is `http://10.0.2.2:5000/api`; for a physical phone use your PC's LAN IP or the deployed URL.
After changing `.env`, stop the app and run `flutter run` again so the bundled asset is rebuilt. Hot reload/hot restart is not
enough. Build-time `--dart-define` values still override `.env`.

## Build APK / AAB
1. Create a keystore: `keytool -genkey -v -keystore ~/cds-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
2. Add `android/key.properties` (`storePassword`, `keyPassword`, `keyAlias=upload`, `storeFile=/path/cds-upload.jks`) and wire it
   into `android/app/build.gradle(.kts)` `signingConfigs.release` — see https://docs.flutter.dev/deployment/android#sign-the-app
3. `flutter build apk --release`
4. `flutter build appbundle --release` (Play Store)
5. iOS: open `ios/Runner.xcworkspace`, set your Team/Bundle ID, then `flutter build ipa --release`

Release builds must use **https** (Android release and iOS block cleartext).

## Website → app mapping
| Website | App | API used |
|---|---|---|
| `/` Home (hero, ticker, steps, gallery, why-us, journey, FAQ, reviews, CTA) | `screens/home_screen.dart`, `screens/home/*` | – |
| `/request` | `request_screen.dart` | `POST /requests` (multipart: fields + `productImage`) |
| `/contact` | `contact_screen.dart` | `POST /contact` (JSON) |
| `/become-a-rider` | `rider/become_rider_screen.dart` | – |
| `/rider/register` (6 steps) | `rider/rider_register_screen.dart` | `GET /riders/config`, `POST /riders/register` (multipart, 12 document slots) |
| `/rider/status` | `rider/rider_status_screen.dart` | `POST /riders/status` |
| `/how-it-works`, `/about`, `/privacy`, `/terms`, `/prohibited-items-policy`, `/gallery/:slug`, 404 | matching screens | – |

Architecture: `core/` (config, constants, theme, helpers) · `data/` (models, `ApiClient`, `ApiService`, draft storage) ·
`providers/` (Provider/ChangeNotifier: one per form) · `widgets/` (common, form, layout) · `screens/`.
Same validation rules, error texts, `submissionKey` idempotency and empty `website` honeypot as the website.

## Decisions you should check
- **Admin panel not included.** It is staff-only (x-api-key / sensitive key) and not customer-facing; shipping those keys in a
  public app would be a security risk. The app has no Admin button either.
- **No login/token storage.** The website has no customer accounts, so there is no auth/session to replicate. Nothing sensitive is
  stored; if you add customer auth later, use `flutter_secure_storage`.
- **Drafts:** half-filled request/rider forms are saved on the phone and restored. Aadhaar, PAN, licence, bank/UPI details and
  consents are never saved to disk; files are not saved.
- `GET /requests/:requestId/status` powers the request status screen from the success CTA, bottom-nav Status and footer. Submitted Request IDs are also saved locally for the "My Requests" history screen (device-only, no login); that screen uses `POST /requests/status/bulk` so the whole list refreshes with one status check.
- Text values are trimmed before sending (the website sends them raw); PAN/IFSC fields auto-capitalise.
- Images were converted PNG → WebP (≈2 MB total) for a smaller app; fonts (Sora, Plus Jakarta Sans) load via `google_fonts`
  — download them into `assets/fonts` if you need fully offline first launch.
- "Back to gallery" returns to Home (top) rather than scrolling to the gallery section.

## Missing / needs your attention
- No missing endpoints were found for any customer-facing feature.
- Production API URL, and whether the backend's CORS/rate-limit config accepts native clients (no `Origin` header), are unknown.
- Not verified on device: uploads against the real backend (repeated multipart keys such as
  `workPreferences.availabilityDays` are sent as separate text parts), HEIC picks on iOS, and pixel-level visual parity.
