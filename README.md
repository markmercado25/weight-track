# Weight Tracker

A personal daily weight tracker PWA with a pastel-blue glass UI. Data syncs
across devices via a Supabase (Postgres) backend, so it works as a normal
account-based app even though it's hosted as a static site on GitHub Pages.
Installable on iPhone and Android.

## Files

```
index.html            — the app
config.js              — your Supabase project URL + anon key (edit this)
supabase-schema.sql     — run once in Supabase to create the tables
manifest.json           — PWA config (name, icons, colors)
sw.js                   — service worker (offline app-shell support)
icon-192.png            — app icon
icon-512.png            — app icon
```

## 1. Create a Supabase project

1. Go to [supabase.com](https://supabase.com) and create a free account/project.
2. In the project dashboard, open **SQL Editor** → **New query**, paste the
   contents of `supabase-schema.sql`, and click **Run**. This creates the
   `entries` and `goals` tables with row-level security so each account only
   ever sees its own data.
3. Open **Project Settings → API**. Copy the **Project URL** and the
   **anon public** key.
4. Paste those into `config.js`:
   ```js
   window.SUPABASE_URL = 'https://xxxxx.supabase.co';
   window.SUPABASE_ANON_KEY = 'eyJ...';
   ```
   These values are safe to commit/publish — the anon key only allows what
   the RLS policies permit (a signed-in user's own rows).
5. (Optional) In **Authentication → Providers → Email**, turn off "Confirm
   email" if you want to sign in immediately after signing up instead of
   confirming via email first. Since this is a personal app, you may also
   want to turn off public sign-ups once your own account exists
   (**Authentication → Settings**).

## 2. Deploy to GitHub Pages

1. Create a new GitHub repository (can be private or public) — note that
   `config.js` will contain your Supabase URL/anon key, which is fine to
   publish as described above.
2. Push/upload all files to the root of the repo.
3. Go to **Settings → Pages**.
4. Under **Source**, select **Deploy from a branch**.
5. Choose **main** branch, **/ (root)** folder → click **Save**.
6. Your app will be live at `https://yourusername.github.io/your-repo-name/`.

> It may take 1–2 minutes for GitHub to build and publish the first time.

## 3. Create your account

Open the app, tap **Create one**, enter an email + password. Once signed in
you'll land on your dashboard. Sign in from any device with the same
credentials to see the same data.

If this browser already had entries from an earlier localStorage-only
version of the app, you'll see an **Import** banner after your first sign-in
offering to copy that local data into your account.

## Install on iPhone

1. Open the app URL in Safari.
2. Tap the **Share** button (box with arrow).
3. Tap **Add to Home Screen**.
4. Tap **Add** — it appears on your home screen like a native app.

## Notes

- Data is stored in your Supabase project's Postgres database, scoped to
  your account via Row Level Security — not in localStorage.
- The app requires a network connection to read/write weight data; the
  service worker only caches the app shell (HTML/CSS/JS) for fast/offline
  loading of the interface itself.
- Never put your Supabase **service_role** key anywhere in this app — only
  the anon/public key belongs in `config.js`.
