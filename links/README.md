# Links · gabrielepinheiro.com/links

Página de links com o **Diagnóstico da Casa** funcionando dentro dela.
Cores e fontes: Paleta Amora & Floresta. Conteúdo: Jornada do Cliente GP.

| Arquivo | O que é |
|---|---|
| `index.html` | A página pública. Os links ficam em `/links`; o diagnóstico abre em `/links#diagnostico`. |
| `painel.html` | O painel do escritório: diagnósticos recebidos, senhas e público. Não tem link na página e não aparece no Google. |

## Colocar no ar com o diagnóstico funcionando

Sem o Supabase, o diagnóstico roda em **modo de teste**: senha `DEMO`, e as respostas ficam só no celular de quem respondeu. Você não recebe nada.

### 1. Supabase, onde chegam as respostas (cerca de 10 min, plano grátis)

1. Em supabase.com, clique em **New project**.
   - Nome: `diagnostico-gp`.
   - Região: **Frankfurt** (Europa).
   - Guarde a senha do banco.
2. Abra **SQL Editor → New query**.
   - Cole o arquivo `supabase.sql`.
   - Na última linha, troque `SEU-EMAIL-AQUI` pelo seu e-mail.
   - Clique em **Run**.
3. Em **Authentication → Users → Add user → Create new user**:
   - use o mesmo e-mail e uma senha;
   - marque **Auto Confirm User**.
4. Em **Authentication → Sign In / Providers**, desligue **Allow new users to sign up**.
5. Em **Project Settings → API Keys**, copie a **Project URL** e a chave **publishable** (ou **anon**).

### 2. Configuração (2 min)

Em `index.html` e em `painel.html`, preencha no bloco `GP_CONFIG`:
- `supabaseUrl` e `supabaseKey`;
- `instagram`.

A chave publishable pode ficar na página: ela foi feita para isso. Quem protege os dados são as regras do `supabase.sql`.

### 3. Wix (cerca de 10 min)

Siga a seção "Colocar no Wix" abaixo, para `links` e para `painel`.

### 4. Primeira senha e teste (2 min)

1. Abra `gabrielepinheiro.com/painel` e entre com o seu e-mail e senha.
2. Vá em **Senhas → Senha da campanha**, crie `CASA` com a validade que quiser.
3. Abra `gabrielepinheiro.com/links`, faça o diagnóstico com `CASA` e confira se ele aparece em **Diagnósticos**.

### 5. Instagram

1. Coloque `gabrielepinheiro.com/links` na bio.
2. Quem enviar **DIAGNÓSTICO** no direct recebe a senha. No painel, o botão **Copiar mensagem para o direct** gera o texto pronto.
3. Para responder sozinho, crie uma resposta automática para a palavra DIAGNÓSTICO nas automações do Meta Business Suite ou no ManyChat, com a mensagem da senha `CASA`.

> O plano grátis do Supabase pode pausar o projeto depois de uma semana sem uso. Se o diagnóstico parar, abra o painel do Supabase e clique em **Restore**.

## Painel e segurança

Com o Supabase configurado, o painel exige o login de um e-mail cadastrado na tabela `equipe`. Os dados são protegidos pelas regras do banco, não pela página.
No modo de teste, cada navegador vê apenas os próprios dados.

## Senha no link

As mensagens com senha individual geradas no painel usam o formato `…/links?s=SENHA#diagnostico`.
Esse link abre o diagnóstico com a senha já preenchida.

## Colocar no Wix (cerca de 15 minutos)

1. No Editor do Wix: **Páginas e Menu → + Adicionar página**, com o nome `links`.
2. Nas **Configurações** da página:
   - endereço (slug) `links`;
   - **Layouts → Sem cabeçalho e rodapé**;
   - oculte a página do menu.
3. **Adicionar → Código incorporado → Incorporar HTML → Inserir código**. Cole o conteúdo inteiro de `index.html` e clique em **Aplicar**.
4. Estique o elemento na largura toda. Deixe a altura igual à da tela:
   - no computador, cerca de 900 px;
   - no editor de celular, cerca de 700 px.
   A página rola dentro do elemento.
5. Publique e teste em `gabrielepinheiro.com/links`, no celular e no computador.

Painel: crie outra página, por exemplo `painel`, com `painel.html`. Oculte-a do menu e proteja com senha em **Permissões da página**.

Se o Wix recusar o código ou a rolagem incomodar, use a alternativa:
1. Hospede a pasta `links` (Netlify ou GitHub Pages).
2. No **Gerenciador de redirecionamento de URL** do Wix, crie um redirecionamento 301 de `/links` para o endereço hospedado.
