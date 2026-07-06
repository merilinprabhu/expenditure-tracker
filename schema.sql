-- Enable UUID extension if not already enabled
create extension if not exists "uuid-ossp";

-- Drop existing tables to avoid policy conflicts and apply fresh schema
drop table if exists public.yono_statements cascade;
drop table if exists public.sip_statements cascade;
drop table if exists public.salary_accounts cascade;
drop table if exists public.user_budgets cascade;

-- Create tables
create table if not exists public.yono_statements (
    id uuid default gen_random_uuid() primary key,
    user_id uuid references auth.users(id) on delete cascade not null,
    date date not null,
    cretarias text,
    purpose text,
    person text,
    brief text,
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
    month_year text not null, -- Format: YYYY-MM or YYYY-DA1, YYYY-DA2, YYYY-ENC, YYYY-OTH
    base_salary numeric(12, 2) not null,
    allowances numeric(12, 2) default 0.00,
    deductions numeric(12, 2) default 0.00,
    net_salary numeric(12, 2) not null,
    credited_date date not null,
    status text check (status in ('credited', 'pending')) not null,
    
    -- Payslip Details
    employee_name text default 'Mr. DEVARAJA',
    kgid_no text default '2439106',
    pran_no text default '110017978368',
    ddo_code text default '239070',
    days_worked integer default 30,
    pay_scale text default '44425-83700',
    
    -- Additions
    basic numeric(12, 2) default 0.00,
    da numeric(12, 2) default 0.00,
    hra numeric(12, 2) default 0.00,
    med numeric(12, 2) default 0.00,
    fa_recovery numeric(12, 2) default 0.00,
    
    -- Deductions
    pt numeric(12, 2) default 0.00,
    egis numeric(12, 2) default 0.00,
    kgid numeric(12, 2) default 0.00,
    nps numeric(12, 2) default 0.00,
    lic numeric(12, 2) default 0.00,
    column1 numeric(12, 2) default 0.00,
    
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    constraint unique_user_month_year unique (user_id, month_year)
);

create table if not exists public.user_budgets (
    id uuid default gen_random_uuid() primary key,
    user_id uuid references auth.users(id) on delete cascade not null,
    criteria text not null,
    amount numeric(12, 2) not null,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    constraint unique_user_criteria unique (user_id, criteria)
);

-- Set up Row Level Security (RLS)
alter table public.yono_statements enable row level security;
alter table public.sip_statements enable row level security;
alter table public.salary_accounts enable row level security;
alter table public.user_budgets enable row level security;

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

create policy "Users can view their own budgets" on public.user_budgets
    for select using (auth.uid() = user_id);
create policy "Users can insert their own budgets" on public.user_budgets
    for insert with check (auth.uid() = user_id);
create policy "Users can update their own budgets" on public.user_budgets
    for update using (auth.uid() = user_id);
create policy "Users can delete their own budgets" on public.user_budgets
    for delete using (auth.uid() = user_id);
