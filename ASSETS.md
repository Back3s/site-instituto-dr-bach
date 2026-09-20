# Imagens do site

As fotos abaixo são **provisórias**: vieram do Instagram do instituto (qualidade comprimida, com texto e logos na arte). Servem para o site já ter cara de site pronto enquanto o instituto não envia as fotos originais.

## Como trocar uma foto
1. Salve a nova foto (JPG) em `assets/images/<pasta>/` **com o mesmo nome** do arquivo atual.
2. Rode `_fonte/otimizar-imagens.ps1` (botão direito > Executar com o PowerShell). Ele reduz fotos maiores que 1800 px (guardando o original em `_fonte/originais`) e gera as versões WebP em vários tamanhos.
3. Rode `_fonte/gerar-site.ps1`. Largura e altura saem sozinhas, para a página não "pular" ao carregar.

Os caminhos, os textos alternativos (alt) e o enquadramento de cada foto ficam no bloco `$IMAGENS` do topo de `_fonte/gerar-site.ps1`. Para trocar o nome do arquivo, o alt ou o recorte, edite a linha da foto ali. Não coloque texto por cima das artes 02, 05, 06 e 08: elas já têm texto próprio.

## Fotos atuais (provisórias)
| Imagem | Onde é usada | Tamanho atual | Tamanho ideal (versão final) | O que o instituto precisa enviar |
|---|---|---|---|---|
| `hero/turma-alunos.jpg` | Início: hero (moldura à direita). Sobre: foto de abertura | 1800 × 1800 (original 3024 × 3024) | 1600 × 1600 (quadrada). Se preferir 4:3 (1600 × 1200), me avise que ajusto a moldura | Foto original da turma, sem edição e com boa luz |
| `formaturas/entrega-certificado-recepcao.jpg` | Início: Formaturas e conquistas (imagem principal, maior) | 1800 × 1800 (original 3024 × 3024) | 1200 × 900 (4:3) ou até 1600 × 1600 | Fotos originais de entrega de certificado |
| `formaturas/tsb-entrega-certificado.jpg` | Curso TSB (ao lado das vantagens). Início: Formaturas (segunda imagem) | 1080 × 1350 | 1200 × 1500 (4:5), **sem texto na arte** | Foto original da entrega do certificado do TSB |
| `pratica/professor-conversando-alunos.jpg` | Início: "Do zero ao primeiro emprego" | 1350 × 1688 | 1200 × 1500 (4:5), sem texto na arte | Foto original do professor orientando alunos |
| `pratica/pratica-real-paciente.jpg` | Início: Prática real (destaque vertical). Curso TSB: Como funciona a prática | 1170 × 2080 (capa de vídeo, com texto) | Foto vertical 1080 × 1920 ou horizontal 1600 × 1200, **sem texto** | Fotos e vídeos originais de aulas práticas com pacientes |
| `pratica/aula-pratica-colagem.jpg` | Início: Prática real (card de apoio). Curso ASB: Como funciona a prática | 1440 × 1920 (colagem, com logo FACOP) | 1200 × 900 por foto, uma por arquivo, **sem texto e sem logos** | Fotos individuais das aulas práticas e da estrutura da clínica |
| `equipe/professor-jaleco.jpg` | Início e Sobre: card "Professor da equipe" (largura máxima de 320 px) | 720 × 1280 (baixa resolução, capa de vídeo) | 1200 × 1000, retrato do rosto e ombros | Foto de rosto em alta resolução e o nome do professor |
| `equipe/raquel-pereverzieff.jpg` | Curso TSB: matéria Biossegurança e Técnicas Radiológicas (recortada só na pessoa) | 1088 × 1344 (arte "Seja Bem-Vinda", com faixas) | 1200 × 900, retrato sem faixas e sem texto | Retrato profissional da Profª Drª Raquel |

## Outras imagens do site
| Arquivo | Onde aparece | Tamanho ideal | Situação |
|---|---|---|---|
| `assets/logo.png` e `assets/logo-branco.png` | Cabeçalho e rodapé | SVG (vetor) | PNG recortado da imagem enviada; trocar quando houver o vetor |
| `assets/og.jpg` | Prévia ao compartilhar o link | 1200 × 630 | Provisória, gerada com o logo em fundo roxo (não usa as fotos do Instagram) |
| `assets/images/equipe/evandro.jpg` e `marcio.jpg` | Cartões da direção (Início e Sobre) | 600 × 600, rosto centralizado | Sem foto ainda: aparecem as iniciais |
| `assets/images/instagram/01.jpg` a `06.jpg` | Início: grade do Instagram | 1080 × 1080 | Sem imagens ainda: aparecem blocos lavanda |
| `assets/equipe.png` | (não é mais usada) | – | Era a foto do hero antes da foto da turma; pode ser apagada |

As pastas `assets/images/hero` e `assets/images/cursos` guardam as fotos de destaque; `cursos` está reservada para fotos de capa por curso (ainda não usada).
