-- Enable UUID extension if not already enabled
create extension if not exists "uuid-ossp";

-- Drop existing tables to avoid policy conflicts and apply fresh schema
drop table if exists public.yono_statements cascade;
drop table if exists public.sip_statements cascade;
drop table if exists public.salary_accounts cascade;

-- Create tables
create table if not exists public.yono_statements (
    id uuid default gen_random_uuid() primary key,
    user_id uuid references auth.users(id) on delete cascade not null,
    date date not null,
    cretarias text,
    purpose text,
    person text,
    details text,
    debit numeric(12, 2) default 0.00,
    credit numeric(12, 2) default 0.00,
    balance numeric(12, 2),
    ref_no text,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create table if not exists public.sip_statements (
    id uuid default gen_random_uuid() primary key,
    user_id uuid references auth.users(id) on delete cascade not null,
    date date not null,
    scheme_name text not null,
    amount numeric(12, 2) not null,
    units numeric(12, 4),
    nav numeric(12, 4),
    transaction_type text check (transaction_type in ('buy', 'sell')) not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create table if not exists public.salary_accounts (
    id uuid default gen_random_uuid() primary key,
    user_id uuid references auth.users(id) on delete cascade not null,
    month_year text not null, -- Format: YYYY-MM
    base_salary numeric(12, 2) not null,
    allowances numeric(12, 2) default 0.00,
    deductions numeric(12, 2) default 0.00,
    net_salary numeric(12, 2) not null,
    credited_date date not null,
    status text check (status in ('credited', 'pending')) not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    constraint unique_user_month_year unique (user_id, month_year)
);

-- Set up Row Level Security (RLS)
alter table public.yono_statements enable row level security;
alter table public.sip_statements enable row level security;
alter table public.salary_accounts enable row level security;

-- Create policies for select, insert, update, delete for authenticated users (owner only)
create policy "Users can view their own yono statements" on public.yono_statements
    for select using (auth.uid() = user_id);
create policy "Users can insert their own yono statements" on public.yono_statements
    for insert with check (auth.uid() = user_id);
create policy "Users can update their own yono statements" on public.yono_statements
    for update using (auth.uid() = user_id);
create policy "Users can delete their own yono statements" on public.yono_statements
    for delete using (auth.uid() = user_id);

create policy "Users can view their own sip statements" on public.sip_statements
    for select using (auth.uid() = user_id);
create policy "Users can insert their own sip statements" on public.sip_statements
    for insert with check (auth.uid() = user_id);
create policy "Users can update their own sip statements" on public.sip_statements
    for update using (auth.uid() = user_id);
create policy "Users can delete their own sip statements" on public.sip_statements
    for delete using (auth.uid() = user_id);

create policy "Users can view their own salary accounts" on public.salary_accounts
    for select using (auth.uid() = user_id);
create policy "Users can insert their own salary accounts" on public.salary_accounts
    for insert with check (auth.uid() = user_id);
create policy "Users can update their own salary accounts" on public.salary_accounts
    for update using (auth.uid() = user_id);
create policy "Users can delete their own salary accounts" on public.salary_accounts
    for delete using (auth.uid() = user_id);
