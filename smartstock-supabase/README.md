# SmartStock (Supabase edition)

Works in two modes:
- **Local demo** (default): leave `config.js` empty. Data lives in the browser. Demo login: demo@smartstock.in / demo1234
- **Cloud mode**: fill `config.js` with your Supabase URL + anon key. Real accounts, products saved per user in Postgres, stock changes logged.

## Setup
1. Create a project at supabase.com.
2. SQL Editor -> New query -> paste `supabase/schema.sql` -> Run.
3. Authentication -> Providers -> Email: for a quick demo, turn OFF "Confirm email".
4. Project Settings -> API: copy the Project URL and the `anon` public key into `config.js`.
5. Serve the folder (double-clicking index.html also works) and sign up. The first login seeds 15 sample products for that user.
6. Deploy: push to GitHub and enable Pages. Then in Supabase -> Authentication -> URL Configuration, add your Pages URL.

## Security notes
- The anon key is meant to be public; Row Level Security in schema.sql is what protects data (each user sees only their own rows).
- Never put the `service_role` key in this project.
