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
   - `instagram`, `portfolio`, `collection`, `foto`
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
