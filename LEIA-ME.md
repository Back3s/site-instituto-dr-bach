# Site do Instituto Dr. Bach

Site estático em português: não precisa instalar nada nem ter servidor. Para ver, dê dois cliques em **index.html**.

## Estrutura
- `index.html` (início), `cursos.html`, `curso-*.html` (uma página por curso), `sobre.html`, `contato.html`, `inscricao.html` (cadastro), `politica-de-privacidade.html`
- Cada página tem o HTML, o CSS e o JavaScript **dentro dela**, sem arquivos separados
- `assets/` guarda logo, fotos e `og.jpg`. Veja **ASSETS.md** para saber quais imagens enviar
- `sitemap.xml` e `robots.txt` são para o Google
- `PENDENCIAS.md` lista o que ainda falta confirmar ou enviar

## Como editar o conteúdo
Todo o conteúdo (telefone, cursos, valores, FAQ, professores, endereço) fica no topo do arquivo `_fonte/gerar-site.ps1`, no bloco **1. CONTEÚDO**. Campos vazios (`''`) não aparecem no site.

1. Edite o texto no bloco de conteúdo.
2. Clique com o botão direito em `_fonte/gerar-site.ps1` e escolha **Executar com o PowerShell**. As páginas `.html` são refeitas.

Atenção: refazer as páginas **substitui** alterações feitas à mão nos `.html`. Se preferir, é só pedir a mudança ao Claude.

## Como trocar uma foto
Salve o novo JPG em `assets/images/<pasta>/` com o mesmo nome, rode `_fonte/otimizar-imagens.ps1` (reduz e gera WebP, precisa do Microsoft Edge instalado) e depois `_fonte/gerar-site.ps1`. Detalhes em **ASSETS.md**. Os caminhos e textos alternativos das fotos ficam no bloco `$IMAGENS` de `gerar-site.ps1`.

## Como trocar as cores
As cores são variáveis no início de `_fonte/estilo.css` (bloco `:root`): `--roxo`, `--roxo-escuro`, `--roxo-medio`, `--magenta`, `--ouro`, `--lilas`, `--texto`. Mude ali e rode o gerador de novo.
Atalho no VS Code: `Ctrl+Shift+H` (substituir em todos os arquivos) trocando o código da cor, por exemplo `#C4179F`.

## Rastreio (opcional)
Em `_fonte/script.js`, no topo, preencha `RASTREIO = { ga4: '', pixel: '' }`. Vazio = desligado. Ao preencher, aparece o aviso de cookies e os cliques no WhatsApp viram eventos.

## Publicar
Envie para a hospedagem tudo **menos** a pasta `_fonte`. Antes, defina o domínio em `$SITE_URL` (gerar-site.ps1) e rode o gerador, para o sitemap, o Open Graph e os dados estruturados saírem corretos.

## Como funciona o cadastro
O formulário não guarda nada: ao enviar, abre o WhatsApp (67) 99679-3094 com uma mensagem pronta contendo os dados. A inscrição só conta quando a pessoa envia essa mensagem.
