-- SmartStock schema. Run in Supabase: SQL Editor -> New query -> paste -> Run.
create extension if not exists pgcrypto;

create table if not exists public.products (
  id          uuid primary key default gen_random_uuid(),
  owner       uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name        text not null check (length(trim(name)) > 0),
  dept        text not null,
  qty         integer not null default 0 check (qty >= 0),
  price       numeric(10,2) not null default 0 check (price >= 0),
  orig_price  numeric(10,2),
  expiry      date not null,
  min_stock   integer not null default 0 check (min_stock >= 0),
  emoji       text default '🛒',
  on_sale     boolean not null default false,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
create index if not exists products_owner_idx on public.products(owner);

create table if not exists public.stock_log (
  id          bigint generated always as identity primary key,
  owner       uuid not null default auth.uid() references auth.users(id) on delete cascade,
  product_id  uuid references public.products(id) on delete set null,
  note        text,
  created_at  timestamptz not null default now()
);

create or replace function public.touch_updated_at() returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;
drop trigger if exists products_touch on public.products;
create trigger products_touch before update on public.products
  for each row execute function public.touch_updated_at();

-- Row Level Security: each shop owner sees only their own rows.
alter table public.products  enable row level security;
alter table public.stock_log enable row level security;

drop policy if exists "own products" on public.products;
create policy "own products" on public.products for all to authenticated
  using (owner = auth.uid()) with check (owner = auth.uid());

drop policy if exists "own stock log" on public.stock_log;
create policy "own stock log" on public.stock_log for all to authenticated
  using (owner = auth.uid()) with check (owner = auth.uid());
