# cs_elective_2

Flutter product catalog using Supabase, with GitHub OAuth sign-in.

## GitHub OAuth setup

1. In GitHub, create an OAuth App. Set its Authorization callback URL to
   `https://<your-project-ref>.supabase.co/auth/v1/callback`.
2. In the Supabase Dashboard, open **Authentication → Providers → GitHub**,
   enable GitHub, and enter the OAuth App client ID and client secret.
3. In **Authentication → URL Configuration**, add
   `io.supabase.flutter://login-callback/` to the allowed redirect URLs. Set
   the Site URL to your web app's origin when running on the web.
4. Run the app with its existing `.env` containing `SUPABASE_URL` and
   `SUPABASE_ANON_KEY`. The app uses the native callback scheme
   `io.supabase.flutter://login-callback/` on Android and iOS, and the configured
   Supabase Site URL on web.

Users must complete the GitHub OAuth consent flow before the product catalog is
shown. Use the sign-out icon in the catalog app bar to return to sign-in.
