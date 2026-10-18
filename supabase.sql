-- FORMA Tap Card Studio schema. Run in Supabase Dashboard > SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 role text not null default 'client' check (role in ('admin','client')),
 created_at timestamptz not null default now()
);
create table if not exists public.clients (
 id uuid primary key default gen_random_uuid(),
 user_id uuid unique references auth.users(id) on delete set null,
 full_name text not null,
 title text default '',
 business_name text default '',
 email text default '',
 phone text default '',
 whatsapp text default '',
 website text default '',
 location text default '',
 instagram text default '',
 linkedin text default '',
 booking_url text default '',
 slug text not null unique,
 bio text default '',
 services text default '',
 address text default '',
 photo_url text default '',
 active boolean not null default true,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$ begin new.updated_at = now(); return new; end; $$;
drop trigger if exists clients_touch_updated_at on public.clients;
create trigger clients_touch_updated_at before update on public.clients for each row execute function public.touch_updated_at();

alter table public.profiles enable row level security;
alter table public.clients enable row level security;
create or replace function public.is_admin()
returns boolean language sql security definer set search_path=public stable as $$
 select exists(select 1 from public.profiles where id=auth.uid() and role='admin');
$$;
drop policy if exists "read own profile or admin" on public.profiles;
create policy "read own profile or admin" on public.profiles for select to authenticated using (id=auth.uid() or public.is_admin());
drop policy if exists "admin manage profiles" on public.profiles;
create policy "admin manage profiles" on public.profiles for all to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "admin all clients" on public.clients;
create policy "admin all clients" on public.clients for all to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "client reads own client row" on public.clients;
create policy "client reads own client row" on public.clients for select to authenticated using (user_id=auth.uid());

-- Public, read-only view: exposes only published profile fields. Do not add private notes or billing data here.
create or replace view public.public_clients with (security_invoker = false) as
 select full_name,title,business_name,email,phone,whatsapp,website,location,instagram,linkedin,booking_url,slug,bio,services,address,photo_url
 from public.clients where active=true;
grant select on public.public_clients to anon, authenticated;
-- Storage bucket for client headshots/logos. Public read is needed for public card profiles; upload is admin-only.
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('profile-images','profile-images',true,5242880,array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do update set public=true,file_size_limit=5242880;
drop policy if exists "public read profile images" on storage.objects;
create policy "public read profile images" on storage.objects for select using (bucket_id='profile-images');
drop policy if exists "admin upload profile images" on storage.objects;
create policy "admin upload profile images" on storage.objects for insert to authenticated with check (bucket_id='profile-images' and public.is_admin());
drop policy if exists "admin update profile images" on storage.objects;
create policy "admin update profile images" on storage.objects for update to authenticated using (bucket_id='profile-images' and public.is_admin()) with check (bucket_id='profile-images' and public.is_admin());
drop policy if exists "admin delete profile images" on storage.objects;
create policy "admin delete profile images" on storage.objects for delete to authenticated using (bucket_id='profile-images' and public.is_admin());

-- After creating your first auth user in Authentication > Users, replace UUID below and run:
-- insert into public.profiles (id, role) values ('PASTE-YOUR-AUTH-USER-UUID-HERE','admin')
-- on conflict (id) do update set role='admin';
-- Client account linking:
-- insert into public.profiles (id, role) values ('CLIENT-AUTH-USER-UUID','client') on conflict (id) do update set role='client';
-- update public.clients set user_id='CLIENT-AUTH-USER-UUID' where slug='client-slug';
