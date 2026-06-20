# Mapagram · Revisão de Alemão 🇩🇪

Série de folhas **A4 horizontais** em estilo *mapagram* (mapa + diagrama) para
revisar tópicos de Alemão. Cada arquivo HTML = 1 página = 1 mapagram.

## Estrutura

```
Deutsch/
├── css/
│   └── mapagram.css      ← estilo compartilhado por toda a série
├── template-base.html    ← base/modelo para copiar a cada novo tópico
└── README.md
```

## Características da base

- **A4 paisagem** (297 × 210 mm), pronta para impressão.
- **Barra lateral esquerda de 5 cm**, pautada do topo ao rodapé, para anotações
  à mão.
- **Área principal** com malha de pontos discreta para guiar o diagrama.
- **Cabeçalho** com título, subtítulo e metadados (Tema · Nível · Data).
- **Componentes prontos**: nós coloridos, nó central, setas, chips, campos em
  branco para completar à mão e cores por gênero (`der`/`die`/`das`).

## Como criar um novo mapagram

1. Copie `template-base.html` com um nome do tópico
   (ex.: `01-artigos-definidos.html`).
2. Edite o cabeçalho e monte os nós dentro de `.canvas`.
3. Abra no navegador.

## Como exportar em PDF / imprimir

`Ctrl/Cmd + P` e use estas opções:

- Tamanho: **A4**
- Orientação: **Paisagem (Landscape)**
- Margens: **Nenhuma** (ou Padrão)
- Marque **"Gráficos de plano de fundo"** (*Background graphics*) — essencial
  para sair as pautas e as cores.
- Destino: **Salvar como PDF**

## Blocos disponíveis (resumo)

| Classe | Para que serve |
|---|---|
| `.node` | caixa de conceito |
| `.node--hub` | nó central em destaque |
| `.t-azul`, `.t-vermelho`, `.t-verde`, `.t-amarelo`, `.t-roxo`, `.t-cinza` | temas de cor |
| `.arrow` | seta/conector entre nós |
| `.chip` | etiqueta pequena |
| `.fill` | campo pautado em branco para completar à mão |
| `.de--der` / `.de--die` / `.de--das` | cor por gênero do substantivo |
| `.row`, `.col`, `.center`, `.wrap`, `.grow` | utilitários de layout |
