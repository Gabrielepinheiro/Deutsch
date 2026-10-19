-- Diagnóstico da Casa · banco de dados no Supabase
-- Como usar: Supabase → SQL Editor → New query → cole este arquivo inteiro → Run.
-- Antes de rodar, troque SEU-EMAIL-AQUI (última linha) pelo e-mail que você vai usar para entrar no painel.

create extension if not exists pgcrypto;

-- Quem pode entrar no painel
create table if not exists public.equipe (
  email text primary key
);

-- Senhas do diagnóstico (campanha = uma palavra para muitas pessoas; individual = vale uma vez)
create table if not exists public.senhas (
  id uuid primary key default gen_random_uuid(),
  codigo text not null unique,
  tipo text not null default 'campanha' check (tipo in ('campanha', 'individual')),
  nome text,
  instagram text,
  nota text,
  usos_max integer check (usos_max is null or usos_max > 0),
  usos integer not null default 0,
  valida_ate timestamptz,
  ativa boolean not null default true,
  criada_em timestamptz not null default now()
);

-- Diagnósticos recebidos
create table if not exists public.diagnosticos (
  id uuid primary key default gen_random_uuid(),
  senha_id uuid references public.senhas (id) on delete set null,
  codigo text,
  nome text,
  email text,
  instagram text,
  respostas jsonb not null,
  resultado jsonb not null,
  estado text,
  caminho text,
  status text not null default 'novo' check (status in ('novo', 'respondido', 'arquivado')),
  criado_em timestamptz not null default now()
);

alter table public.equipe enable row level security;
alter table public.senhas enable row level security;
alter table public.diagnosticos enable row level security;

-- A pessoa logada está na equipe?
create or replace function public.e_equipe()
returns boolean
language sql stable security definer set search_path = public
as $$
  select exists (
    select 1 from public.equipe
    where lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;

-- Só a equipe lê e altera senhas e diagnósticos. Visitantes não leem nada.
drop policy if exists "equipe lê senhas" on public.senhas;
drop policy if exists "equipe cria senhas" on public.senhas;
drop policy if exists "equipe altera senhas" on public.senhas;
drop policy if exists "equipe lê diagnósticos" on public.diagnosticos;
drop policy if exists "equipe altera diagnósticos" on public.diagnosticos;
create policy "equipe lê senhas" on public.senhas for select to authenticated using (public.e_equipe());
create policy "equipe cria senhas" on public.senhas for insert to authenticated with check (public.e_equipe());
create policy "equipe altera senhas" on public.senhas for update to authenticated using (public.e_equipe()) with check (public.e_equipe());
create policy "equipe lê diagnósticos" on public.diagnosticos for select to authenticated using (public.e_equipe());
create policy "equipe altera diagnósticos" on public.diagnosticos for update to authenticated using (public.e_equipe()) with check (public.e_equipe());

-- Visitante: confere a senha sem ver a tabela
create or replace function public.verificar_senha(p_codigo text)
returns jsonb
language plpgsql stable security definer set search_path = public
as $$
declare s public.senhas;
begin
  select * into s from public.senhas where codigo = upper(trim(p_codigo));
  if not found or not s.ativa then return jsonb_build_object('ok', false, 'motivo', 'invalida'); end if;
  if s.valida_ate is not null and s.valida_ate < now() then return jsonb_build_object('ok', false, 'motivo', 'expirada'); end if;
  if s.usos_max is not null and s.usos >= s.usos_max then return jsonb_build_object('ok', false, 'motivo', 'usada'); end if;
  return jsonb_build_object('ok', true, 'nome', s.nome, 'tipo', s.tipo);
end;
$$;

-- Visitante: envia o diagnóstico (confere a senha de novo e conta o uso)
create or replace function public.enviar_diagnostico(p_codigo text, p_respostas jsonb, p_resultado jsonb)
returns jsonb
language plpgsql volatile security definer set search_path = public
as $$
declare
  s public.senhas;
  v_id uuid;
begin
  select * into s from public.senhas where codigo = upper(trim(p_codigo)) for update;
  if not found or not s.ativa then return jsonb_build_object('ok', false, 'motivo', 'invalida'); end if;
  if s.valida_ate is not null and s.valida_ate < now() then return jsonb_build_object('ok', false, 'motivo', 'expirada'); end if;
  if s.usos_max is not null and s.usos >= s.usos_max then return jsonb_build_object('ok', false, 'motivo', 'usada'); end if;
  if coalesce(p_respostas ->> 'consentimento', 'false') <> 'true' then return jsonb_build_object('ok', false, 'motivo', 'consentimento'); end if;
  if coalesce(trim(p_respostas ->> 'nome'), '') = '' or coalesce(p_respostas ->> 'email', '') !~ '^[^\s@]+@[^\s@]+\.[^\s@]{2,}$'
     or jsonb_typeof(p_resultado) <> 'object' or octet_length(p_respostas::text) + octet_length(p_resultado::text) > 200000 then
    return jsonb_build_object('ok', false, 'motivo', 'dados');
  end if;

  insert into public.diagnosticos (senha_id, codigo, nome, email, instagram, respostas, resultado, estado, caminho)
  values (
    s.id, s.codigo,
    left(trim(p_respostas ->> 'nome'), 120),
    left(trim(p_respostas ->> 'email'), 160),
    nullif(left(trim(p_respostas ->> 'instagram'), 60), ''),
    p_respostas, p_resultado,
    left(p_resultado #>> '{estado,nome}', 60),
    left(p_resultado #>> '{caminho,linha}', 60)
  )
  returning id into v_id;

  update public.senhas set usos = usos + 1 where id = s.id;
  return jsonb_build_object('ok', true, 'id', v_id);
end;
$$;

-- Acesso às tabelas: visitantes não tocam nelas; a equipe só pelo que as regras acima permitem.
-- Funciona com "Automatically expose new tables" ligado ou desligado.
grant usage on schema public to anon, authenticated;
revoke all on public.equipe, public.senhas, public.diagnosticos from anon;
revoke all on public.equipe from authenticated;
grant select, insert, update on public.senhas to authenticated;
grant select, update on public.diagnosticos to authenticated;

revoke execute on function public.verificar_senha(text) from public;
revoke execute on function public.enviar_diagnostico(text, jsonb, jsonb) from public;
revoke execute on function public.e_equipe() from public;
grant execute on function public.verificar_senha(text) to anon, authenticated;
grant execute on function public.enviar_diagnostico(text, jsonb, jsonb) to anon, authenticated;
grant execute on function public.e_equipe() to authenticated;

-- Quem entra no painel: troque pelo seu e-mail
insert into public.equipe (email) values ('SEU-EMAIL-AQUI') on conflict do nothing;
