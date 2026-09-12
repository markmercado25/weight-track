-- Weight Tracker — Supabase schema
-- Run this once in your project's SQL Editor (Supabase dashboard -> SQL Editor -> New query -> Run).
-- Safe to re-run: uses "if not exists" / "or replace" where possible.

create table if not exists entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade default auth.uid(),
  date date not null,
  weight numeric(5,1) not null,
  time text,
  created_at timestamptz not null default now(),
  unique (user_id, date)
);

create table if not exists goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade default auth.uid(),
  weight numeric(5,1) not null,
  timeframe text not null,
  start_date date,
  end_date date,
  created_at timestamptz not null default now()
);

alter table entries enable row level security;
alter table goals enable row level security;

drop policy if exists "Users manage their own entries" on entries;
create policy "Users manage their own entries" on entries
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users manage their own goals" on goals;
create policy "Users manage their own goals" on goals
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
