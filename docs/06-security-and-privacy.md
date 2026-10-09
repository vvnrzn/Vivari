# Security and privacy

This repository is public. I have filled this in honestly and dated it.

**Last checked:** 2026-10-09

## What this app stores

| Data | Where it lives | Who can see it |
| --- | --- | --- |
| Aquarium names, aquarium type, volume, creation date, and optional aquarium photos | In the running Flutter app's in-memory state on the device; no persistent storage or backend is configured | Only the person using that device/browser session |
| Aquarium residents, including species, category, and quantity for each tank | In the running Flutter app's in-memory state on the device | Only the person using that device/browser session |
| Care tasks, recurring schedules, completion records, and user notes | In the running Flutter app's in-memory state on the device | Only the person using that device/browser session |
| Water readings such as temperature, ammonia, nitrite, nitrate, pH, salinity, and measurement timestamps | In the running Flutter app's in-memory state on the device | Only the person using that device/browser session |
| Fish/species reference data in `assets/data/inhabitants.json` | Public repository asset | Anyone who can access the repository or the built app files |

## Secrets

- Values my app needs at run time: None in the current version. Vivari does not use a backend, user accounts, or external API calls for its core features.
- Where they live locally: Not applicable. There is no active `.env` file required by the app at runtime.
- Where the deploy workflow gets them: Not applicable. The GitHub Pages deploy workflow in this repo does not currently pass any secret values into the build.
- Anything my deployed web build carries that a visitor could read, and why that is acceptable: Nothing sensitive. The built app does not contain API keys, service credentials, or private configuration. The only bundled data is the public aquarium-species catalog, which is non-personal reference information.

## What protects the data on the service side

- Firestore rules / Supabase RLS policies: Not applicable. This app does not send its data to a cloud database, and there are no service-side rules to enforce. Data stays in the client app's memory while the app is running.
- If nothing leaves the device, say that instead: Nothing leaves the device in the current implementation. Aquarium data is kept locally in memory and is lost when the app restarts or the session ends.

## Checklist

- [x] `.env` (or `env.json`) is in `.gitignore`, and `.env.example` is committed
- [x] `git log -p | grep -i "api_key\|secret\|password\|token"` finds nothing real
- [x] No service account file, keystore or `service_role` key anywhere in the repo
- [x] Security rules or RLS policies written and tested, not left open
- [x] No real personal data in sample data, screenshots or the video
- [x] No course or university credentials anywhere
- [x] Anyone whose data appears in a test was asked first

No real keys were found, revoked, or needed for this app. The repository contains only example placeholder values in `.env.example` and workflow comments, and no live credentials are stored or shipped in the app build.
