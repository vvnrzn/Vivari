## Secrets and credentials

| # | Check | Yes / No / N/A | Evidence |
| - | --- | --- | --- |
| 1 | No API key, token or password is hardcoded in `lib/` | Yes | I searched the Dart files in `lib/` for credential-like strings and found no hardcoded keys, tokens, or passwords. |
| 2 | Private config is gitignored and an example file is committed | Yes | `.gitignore` excludes `.env` and `env.json`, and `.env.example` contains placeholder values only. The app does not currently use private configuration. |
| 3 | No keystore, `key.properties` or signing credential is in the repository | Yes | I searched the repository file list for keystore and signing files and found none. |
| 4 | Git history searched for password, secret, API key and token | Yes | I searched the available Git history for those terms; I found template guidance and placeholders, but no real credential values. |
| 5 | Any credential that was ever committed has been rotated | N/A | I found no real credentials in the available history, so there was nothing to rotate. |

## GitHub Actions 

This workflow only builds and deploys the web app. It does not use configured secrets or build a signed APK
| # | Check | Yes / No / N/A | Evidence |
| - | --- | --- | --- |
| 6 | No secret value is written literally in workflow YAML | N/A | |
| 7 | Secrets are stored in Actions secrets and read with `${{ secrets.NAME }}` | N/A | |
| 8 | No workflow step prints a secret, and a recent run log was checked | N/A |  |
| 9 | Signed APK keystore is decoded from a base64 secret | N/A ||
| 10 | Uploaded artifacts contain no key file, keystore or generated config | N/A |  |
| 11 | Third-party actions are pinned to commit SHAs | N/A ||
| 12 | Secret scanning and push protection are enabled | N/A ||

## Backend and security rules

| # | Check | Yes / No / N/A | Evidence |
| - | --- | --- | --- |
| 13 | Firestore and Storage rules require authentication | N/A | The app has no Firebase or other backend integration in its current code. |
| 14 | Rules restrict users to their own documents | N/A | There is no backend or user-document access in the current app. |
| 15 | Supabase RLS is enabled for every table | N/A | The app does not currently use Supabase or have database tables. |
| 16 | Firebase and Google API keys are restricted | N/A | The app does not currently include Firebase or Google API keys. |
| 17 | Signed-out backend access was tested | N/A | There is no backend data access or sign-in flow to test. |
| 18 | Seed and sample data is invented | N/A | The current app does not include backend seed data; dashboard values are empty. |

## Input and app surface

| # | Check | Yes / No / N/A | Evidence |
| - | --- | --- | --- |
| 19 | Input is validated before it is written | Yes | In `add_aquarium_screen.dart`, creation requires a non-empty name, a selected aquarium type, and a volume greater than zero; the created values are returned as an in-memory model. |
| 20 | No secret is recoverable from the built app | Yes | I found no real secrets in the app code or configuration; the web workflow does not pass secret values into its build. |

## Repository and privacy

| # | Check | Yes / No / N/A | Evidence |
| - | --- | --- | --- |
| 21 | No student number, personal email, phone number or home address in files or commit messages | Yes | I searched repository text and available commit history for common personal-data patterns and found no matching personal contact details or student number. |
| 22 | No classmate’s personal data is in the repository | Yes | I found no classmate data in the app code or searched repository text; screenshots and all repository content should still be reviewed manually. |
| 23 | Dependencies are from pub.dev, and build outputs are gitignored | Yes | `pubspec.yaml` lists Flutter and pub.dev packages; `.gitignore` excludes both `build/` and `.dart_tool/`. |
| 24 | Images, fonts and other assets are mine, licensed, or credited | Yes | The project uses Google Fonts through the `google_fonts` package. |
| 25 | Repository visibility is deliberate and checked after the last push | Yes | |

## Anything I found and fixed

I found no real API keys, passwords, or tokens in the local code or the Git history I searched, so I did not need to rotate or remove a credential. 
