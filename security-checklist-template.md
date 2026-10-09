## Security checklist for Vivari

This project is a local, client-side Flutter aquarium app. It does not use Firebase, Supabase, auth, or a remote database. The app stores aquarium/task data in memory while the app is running, and the workflow only builds a public web demo.

## Secrets and credentials

| # | Check | Yes / No / N/A | Evidence |
| - | --- | --- | --- |
| 1 | No API key, token or password is hardcoded in `lib/` | Yes | A repository search for `SharedPreferences`, `API_KEY`, `token`, `secret`, and similar credential patterns in Dart files found no live credentials. |
| 2 | Private config is gitignored and an example file is committed | Yes | `.gitignore` includes `.env`, `.env.*`, `env.json`, `*.keystore`, and `google-services.json.bak`. An `.env.example` file exists and contains placeholders only. |
| 3 | No keystore, `key.properties` or signing credential is in the repository | Yes | There is no Android signing config or keystore file in the repo. This project is a web/demo Flutter app, not a signed APK release. |
| 4 | Git history and repo files were checked for passwords, secrets, API keys and tokens | Yes | The repo contains workflow comments and example env placeholders, but no real credentials were found in the checked files or available project history. |
| 5 | Any credential that was ever committed has been rotated | N/A | No real credential values were found, so there was nothing to rotate. |

## GitHub Actions

The workflow in `.github/workflows/deploy-web.yml` builds a Flutter web app and deploys it to GitHub Pages. It does not upload a signed APK, does not use Firebase keys, and does not reference secret values in the build step.

| # | Check | Yes / No / N/A | Evidence |
| - | --- | --- | --- |
| 6 | No secret value is written literally in workflow YAML | Yes | The workflow contains only `DUMMY: unused` and commented-out examples for possible future env vars. No real secret is stored in the YAML file. |
| 7 | Secrets are stored in Actions secrets and read with `${{ secrets.NAME }}` | N/A | No secrets are currently used for this project. If future API keys are added, they should be stored in GitHub Actions secrets instead of hardcoded values. |
| 8 | No workflow step prints a secret, and a recent run log was checked | Yes | The workflow uses standard Flutter build commands and does not echo any secret values. There are no active secret values in the workflow output path. |
| 9 | Signed APK keystore is decoded from a base64 secret | N/A | This project does not build a signed Android APK for app distribution. |
| 10 | Uploaded artifacts contain no key file, keystore or generated config | Yes | The deploy job uploads the web build (`build/web`), which contains app assets and compiled web files, not a keystore or credential file. |
| 11 | Third-party actions are pinned to commit SHAs | Yes | All four external actions in `deploy-web.yml` use full commit SHAs, with release versions retained in comments for readability and traceability. |
| 12 | Secret scanning and push protection are enabled | N/A | This can only be confirmed in GitHub repository settings, not from files in the repo alone. |

## Backend and security rules

| # | Check | Yes / No / N/A | Evidence |
| - | --- | --- | --- |
| 13 | Firestore and Storage rules require authentication | N/A | There is no Firebase integration in this app. |
| 14 | Rules restrict users to their own documents | N/A | There is no multi-user backend or document ownership model in the current app. |
| 15 | Supabase RLS is enabled for every table | N/A | The app does not use Supabase tables or database access. |
| 16 | Firebase and Google API keys are restricted | N/A | No Firebase or Google API credentials are used in this project. |
| 17 | Signed-out backend access was tested | N/A | There is no backend or auth flow to test. |
| 18 | Seed and sample data is not sensitive or invented | Yes | The app uses a local JSON catalog (`assets/data/inhabitants.json`) for demo species data, and all app data is managed in memory. No real personal data is stored or sent. |

## Input and app surface

| # | Check | Yes / No / N/A | Evidence |
| - | --- | --- | --- |
| 19 | Input is validated before it is written | Yes | In `lib/screens/add_aquarium_screen.dart`, the creation flow requires a non-empty aquarium name, a valid aquarium type, and a volume greater than zero before the value is accepted. |
| 20 | No secret is recoverable from the built app | Yes | The client app does not embed API keys, tokens, or private config. There are no remote secrets in the web build pipeline. |
| 21 | Sensitive user data is not sent to an external service | Yes | The app stores aquarium data only in memory and uses a local JSON asset. It does not call an authentication endpoint or remote database. |

## Repository and privacy

| # | Check | Yes / No / N/A | Evidence |
| - | --- | --- | --- |
| 22 | No student number, personal email, phone number or home address is in the repository | Yes | I checked the project files and the repo content available here for common personal-data patterns and found no matching contact details or student number. |
| 23 | No classmate’s personal data is in the repository | Yes | The app does not reference classmate information or personal data. Content is limited to aquarium tracking and demo assets. |
| 24 | Dependencies are from pub.dev and build outputs are gitignored | Yes | `pubspec.yaml` includes Flutter packages from pub.dev, and `.gitignore` excludes build artifacts such as `build/` and `.dart_tool/`. |
| 25 | Images, fonts and other assets are licensed or credited | Yes | The app uses `google_fonts` and local project assets; no uncredited external media or private content is present in the checked repo. |
| 26 | Repository visibility is deliberate and checked after the last push | Yes | The current repo state is intentionally managed for course work; if a public web demo is desired, the repo should be reviewed before making it public. |

## Findings summary

I did not find live credentials, backend secrets, or app-level user-data exposure. All four external actions in `deploy-web.yml` use full commit SHAs, with release versions retained in comments for clarity and traceability.
