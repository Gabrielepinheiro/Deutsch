# Links · gabrielepinheiro.com/links

Página de links com o **Diagnóstico da Casa** funcionando dentro dela.
Cores e fontes: Paleta Amora & Floresta. Conteúdo: Jornada do Cliente GP.

| Arquivo | O que é |
|---|---|
| `index.html` | A página pública. Os links ficam em `/links`; o diagnóstico abre em `/links#diagnostico`. |
| `painel.html` | O painel do escritório: diagnósticos recebidos, senhas e público. Não tem link na página e não aparece no Google. |

## Para colocar no ar

1. Suba `index.html` para que ele responda em `www.gabrielepinheiro.com/links`. O painel vai junto, em `/links/painel.html`.
2. Preencha o bloco `GP_CONFIG` no fim do `index.html`. Campo vazio = item escondido:
   - `instagram`, `portfolio`, `foto`
   - `premier`: link de agendamento. Vazio: o botão leva ao diagnóstico.
   - `impressum` e `privacidade`: obrigatórios na Alemanha.
   - `whatsapp`: só depois de confirmar o número oficial.
3. Para receber os diagnósticos de verdade, preencha `supabaseUrl` e `supabaseKey` **nos dois arquivos**.
   Sem eles, tudo funciona em **modo de teste**: senha `DEMO`, e os dados ficam só no navegador de quem respondeu.

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
