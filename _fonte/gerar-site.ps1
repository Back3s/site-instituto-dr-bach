# ==========================================================================
#  Instituto Dr. Bach - gerador do site
#  Como usar: clique com o botão direito neste arquivo > "Executar com o PowerShell"
#  (ou rode:  powershell -ExecutionPolicy Bypass -File _fonte\gerar-site.ps1 )
#  Ele lê estilo.css, script.js e icones.html desta pasta e grava as páginas .html
#  na pasta acima. Todo o CONTEÚDO editável está no bloco "1. CONTEÚDO".
#  Campos vazios ('') NÃO aparecem no site publicado.
# ==========================================================================
$ErrorActionPreference = 'Stop'
$fonte = Split-Path -Parent $MyInvocation.MyCommand.Path
$root  = Split-Path -Parent $fonte
$utf8  = New-Object Text.UTF8Encoding($false)

# ==========================================================================
# 1. CONTEÚDO (edite aqui)
# ==========================================================================
$INST = [ordered]@{
  nome          = 'Instituto de Desenvolvimento Humano Dr. Bach'
  curto         = 'Instituto Dr. Bach'
  instagram     = 'https://www.instagram.com/institutodrbach/'
  instagramUser = '@institutodrbach'
  zap           = '5567996793094'
  zapExibe      = '(67) 99679-3094'
  cidadeUF      = ''   # TODO: confirmar (Dourados - MS? os posts também marcam Maringá - PR)
  endereco      = ''   # TODO: endereço completo (alimenta o card e o mapa)
  email         = 'drbach.instituto@gmail.com'   # confirmado pelo instituto (antes: TODO)
  cnpj          = ''   # TODO
  horario       = ''   # TODO
  parceria      = 'FACOP'
}
$SITE_URL      = ''    # TODO: endereço final do site, ex.: 'https://www.seudominio.com.br' (usado em sitemap, Open Graph e JSON-LD)
$VIDEO_YT      = ''    # TODO: ID de um vídeo do YouTube (ex.: 'dQw4w9WgXcQ'). Vazio = bloco de vídeo oculto
$FONTE_MERCADO = 'Ministério da Saúde, via O Globo'   # TODO: confirmar o link da fonte original antes de publicar
$AVISO_VALORES = 'Valores e condições sujeitos a alteração. Consulte no WhatsApp.'
$TURMA         = 'Turma 2026 · Inscrições abertas'

# ---- IMAGENS (equivalente ao images.ts): caminhos, textos alternativos e enquadramento ----
# Para trocar uma foto: substitua o .jpg em assets\images\<pasta>\ mantendo o nome, rode
# otimizar-imagens.ps1 e depois este gerador (largura, altura e WebP saem sozinhos).
# pos = object-position (enquadramento do recorte). Não coloque texto por cima das artes 02, 05, 06 e 08.
$IMAGENS = [ordered]@{
  turma     = @{ pasta='hero';       arq='turma-alunos';                  pos='50% 40%'; alt='Turma de alunos do Instituto Dr. Bach reunida com o certificado digital' }
  heroFoto  = @{ pasta='hero';       arq='pratica-consultorio';           pos='50% 46%'; alt='Procedimento odontológico em consultório, com profissional atendendo paciente' }   # foto de banco de imagens (Pexels, licença gratuita, sem necessidade de atribuição — pexels.com/photo/19976604); TODO: substituir por foto real do Instituto quando disponível (ver PENDENCIAS.md)
  tsb       = @{ pasta='formaturas'; arq='tsb-entrega-certificado';       pos='';        alt='Aluna do curso Técnico em Saúde Bucal recebendo o certificado ao lado de professores' }
  recepcao  = @{ pasta='formaturas'; arq='entrega-certificado-recepcao';  pos='';        alt='Equipe e aluno do Instituto Dr. Bach com o certificado de conclusão' }
  professor = @{ pasta='pratica';    arq='professor-conversando-alunos';  pos='';        alt='Professor conversando com alunos durante orientação no instituto' }
  pratica   = @{ pasta='pratica';    arq='pratica-real-paciente';         pos='';        alt='Prática clínica com paciente real no Instituto Dr. Bach' }   # a foto mostra um professor atendendo (jaleco identifica o Prof. Dr. Evandro); alt neutro de propósito
  colagem   = @{ pasta='pratica';    arq='aula-pratica-colagem';          pos='';        alt='Colagem de alunos em aulas práticas de saúde bucal' }        # a arte exibe a marca FACOP: confirmar permissão (PENDENCIAS.md)
  jaleco    = @{ pasta='equipe';     arq='professor-jaleco';              pos='50% 0%';  alt='Professor do Instituto Dr. Bach de jaleco' }                  # TODO: identificar o professor (PENDENCIAS.md)
  raquel    = @{ pasta='equipe';     arq='raquel-pereverzieff';           pos='50% 0%';  alt='Profª Drª Raquel Pereverzieff, professora de Biossegurança e Técnicas Radiológicas' }
}

$docentes = @(
  @{ nome='Dr. Evandro Nolasco';       cargo='Diretor Pedagógico'; area=''; reg='CRBM-MS 66811'; foto='evandro.jpg'; iniciais='EN'; instagram='' },
  @{ nome='Dr. Márcio Santiago';       cargo='Coordenador';        area=''; reg='CRO-MS 8513';    foto='marcio.jpg';  iniciais='MS'; instagram='https://www.instagram.com/dr.marciosantiago/' },
  @{ nome='Professor da equipe'; cargo=''; area=''; reg=''; foto=''; iniciais='PE'; instagram=''; pic='jaleco' }   # TODO: identificar o professor. A Profª Raquel aparece só na página do curso, junto da matéria dela
)

$faq = @(
  @{ p='O curso é reconhecido pelo MEC?';
     r='Sim. As licenciaturas, o tecnólogo em Gestão Pública e o Técnico em Saúde Bucal têm certificado reconhecido pelo MEC. Para conferir a situação de cada curso, fale com a nossa equipe no WhatsApp.' },
  @{ p='As aulas práticas são presenciais? Onde acontecem?';
     r='Nos cursos de saúde bucal, sim: as aulas práticas são presenciais, com pacientes reais e acompanhamento de professores. Fale com a nossa equipe para saber o local e as datas.' },
  @{ p='Qual a diferença entre ASB e TSB?';
     r='O ASB (Auxiliar em Saúde Bucal) é a entrada rápida no mercado. O TSB (Técnico em Saúde Bucal) é uma formação técnica, com mais responsabilidade e mais mercado. Veja o comparativo na página de cursos ou peça ajuda para escolher.' },
  @{ p='Posso estudar à distância?';
     r='Sim. Os cursos de saúde bucal são EAD ou semipresenciais, com teoria online e práticas presenciais. As 2ª licenciaturas e o tecnólogo em Gestão Pública são 100% online.' },
  @{ p='Como funciona o pagamento?';
     r='Nas 2ª licenciaturas em Pedagogia e em Música: entrada de R$ 600,00 (Pix, dinheiro ou cartão de crédito) + 11x de R$ 400,00 no boleto. Nos demais cursos, consulte a nossa equipe. Valores e condições sujeitos a alteração.' },
  @{ p='Qual a duração dos cursos?';
     r='As 2ª licenciaturas em Pedagogia e em Música duram 12 meses. Para os demais cursos, consulte a nossa equipe no WhatsApp.' },
  @{ p='Preciso ter experiência na área?';
     r='Fale com a nossa equipe para saber os requisitos de cada curso.' }
)

# Cursos (a ordem daqui é a ordem no site; saúde bucal primeiro)
$cursos = @(
  @{ slug='tsb'; titulo='Técnico em Saúde Bucal'; sigla='TSB'; tag='Saúde bucal · Técnico'; area='saude'; icone='cross'; saude=$true;
     nivel='Técnico'; modal='EAD ou semipresencial, com aulas práticas presenciais'; modalCurta='EAD ou semipresencial'; duracao=''; publico=''; mec=$true;
     coord='Dr. Márcio Santiago · CRO-MS 8513'; online=$false;
     preco=@{ entrada='R$ 600,00'; entradaObs='Pix, dinheiro ou cartão de crédito'; parcelas=''; parcelasObs='' };
     card='Mais responsabilidade e mais mercado, com prática em pacientes reais.';
     lead='Formação técnica em saúde bucal, com mais responsabilidade no consultório. Aulas práticas presenciais em pacientes reais, com acompanhamento de professores.';
     lista=@('Aulas práticas presenciais com pacientes reais','Acompanhamento de professores durante a prática','Teoria em EAD ou semipresencial, no seu ritmo','Certificado reconhecido pelo MEC');
     aprender=@();
     para='Para quem quer uma formação técnica em odontologia, com mais responsabilidade do que a capacitação.';
     rel=@('asb','pedagogia','musica') },
  @{ slug='asb'; titulo='Auxiliar em Saúde Bucal'; sigla='ASB'; tag='Saúde bucal · Capacitação'; area='saude'; icone='tooth'; saude=$true;
     nivel='Capacitação'; modal='EAD ou semipresencial, com aulas práticas presenciais'; modalCurta='EAD ou semipresencial'; duracao=''; publico=''; mec=$false;
     coord='Dr. Márcio Santiago · CRO-MS 8513'; online=$false; preco=$null;
     card='Aprenda a atuar ao lado do cirurgião-dentista e entre rápido no mercado, com prática em pacientes reais.';
     lead='Aprenda a atuar ao lado do cirurgião-dentista, com rotina de consultório e aulas práticas presenciais em pacientes reais.';
     lista=@('Aulas práticas presenciais com pacientes reais','Acompanhamento de professores durante a prática','Teoria em EAD ou semipresencial, no seu ritmo','Entrada rápida no mercado');
     aprender=@();
     para='Para quem quer entrar na área da saúde e começar uma nova carreira na odontologia. O mercado está em expansão, e cada consultório precisa de pelo menos um auxiliar qualificado.';
     rel=@('tsb','pedagogia','gestao-publica') },
  @{ slug='pedagogia'; titulo='2ª Licenciatura em Pedagogia'; sigla=''; tag='Educação · Graduação'; area='educacao'; icone='book'; saude=$false;
     nivel='Graduação · 2ª Licenciatura'; modal='100% online'; modalCurta='100% online'; duracao='12 meses'; publico='Quem já possui graduação'; mec=$true;
     coord=''; online=$true;
     preco=@{ entrada='R$ 600,00'; entradaObs='Pix, dinheiro ou cartão de crédito'; parcelas='11x de R$ 400,00'; parcelasObs='no boleto' };
     card='Formação pedagógica rápida, 100% online e reconhecida pelo MEC, em 12 meses.';
     lead='Formação pedagógica rápida para quem já tem graduação: 12 meses, 100% online, com certificado reconhecido pelo MEC e início imediato.';
     lista=@('Formação pedagógica rápida, em 12 meses','100% online: estude de onde estiver','Início imediato','Certificado reconhecido pelo MEC');
     aprender=@();
     para='Para quem já tem graduação e quer atuar na educação, com uma segunda licenciatura.';
     rel=@('musica','educacao-especial','aee') },
  @{ slug='musica'; titulo='2ª Licenciatura em Música'; sigla=''; tag='Educação · Graduação'; area='educacao'; icone='music'; saude=$false;
     nivel='Graduação · 2ª Licenciatura'; modal='100% online'; modalCurta='100% online'; duracao='12 meses'; publico='Quem já possui graduação'; mec=$true;
     coord=''; online=$true;
     preco=@{ entrada='R$ 600,00'; entradaObs='Pix, dinheiro ou cartão de crédito'; parcelas='11x de R$ 400,00'; parcelasObs='no boleto' };
     card='Uma segunda licenciatura em Música, 100% online, em 12 meses e reconhecida pelo MEC.';
     lead='Uma segunda licenciatura para quem já ama música e quer levá-la para a sala de aula. 12 meses, 100% online, com certificado reconhecido pelo MEC e início imediato.';
     lista=@('Você se forma para dar aula de música','12 meses, 100% online','Início imediato','Certificado reconhecido pelo MEC');
     aprender=@();
     para='Para quem já é formado, ama música e quer dar aula.';
     rel=@('pedagogia','educacao-especial','tsb') },
  @{ slug='educacao-especial'; titulo='2ª Licenciatura em Educação Especial'; sigla=''; tag='Educação · Graduação'; area='educacao'; icone='smile'; saude=$false;
     nivel='Graduação · 2ª Licenciatura'; modal='100% online'; modalCurta='100% online'; duracao=''; publico='Quem já possui graduação'; mec=$true;
     coord=''; online=$true; preco=$null;
     card='Uma segunda licenciatura em Educação Especial, para atuar com inclusão em sala de aula.';
     lead='Uma formação em educação inclusiva, para atuar com crianças e jovens em sala de aula. 100% online, com certificado reconhecido pelo MEC.';
     lista=@('Você atua com inclusão de crianças e jovens em sala de aula','Foco em inclusão e desenvolvimento humano','100% online: estude de onde estiver','Certificado reconhecido pelo MEC');
     aprender=@();
     para='Para quem já tem graduação e quer se especializar em inclusão escolar.';
     rel=@('aee','pedagogia','musica') },
  @{ slug='gestao-publica'; titulo='Tecnólogo em Gestão Pública'; sigla=''; tag='Educação · Tecnólogo'; area='educacao'; icone='landmark'; saude=$false;
     nivel='Graduação · Tecnólogo'; modal='100% online'; modalCurta='100% online'; duracao=''; publico=''; mec=$true;
     coord=''; online=$true; preco=$null;
     card='Tecnólogo 100% online voltado para a administração pública.';
     lead='Uma graduação tecnológica 100% online, voltada para quem quer atuar na administração pública, com certificado reconhecido pelo MEC.';
     lista=@('Formação voltada à administração pública','Para quem atua ou quer atuar no setor público','100% online: estude de onde estiver','Certificado reconhecido pelo MEC');
     aprender=@();
     para='Para quem quer atuar na gestão pública, ou já atua e quer uma graduação tecnológica.';
     rel=@('pedagogia','tsb','asb') },
  @{ slug='aee'; titulo='Atendimento Educacional Especializado'; sigla='AEE'; tag='Educação · Curso'; area='educacao'; icone='users'; saude=$false;
     nivel=''; modal=''; modalCurta=''; duracao=''; publico=''; mec=$false;
     coord=''; online=$false; preco=$null;
     card='Tecnologias assistivas, materiais adaptados e apoio individualizado no atendimento educacional especializado.';
     lead='Atendimento complementar ao ensino regular, com tecnologias assistivas e materiais adaptados, apoio individualizado ou em pequenos grupos e atividades que promovem autonomia e participação.';
     lista=@('Tecnologias assistivas e materiais adaptados','Apoio individualizado ou em pequenos grupos','Atividades que promovem autonomia e participação','Salas de recursos multifuncionais e ambientes inclusivos');
     aprender=@();
     para='Para educadores e profissionais que querem atuar no atendimento educacional especializado, complementando o ensino regular.';
     rel=@('educacao-especial','pedagogia','asb') }
)

# Comparativo ASB x TSB: só aparecem as linhas em que os DOIS lados estão preenchidos.
$comparativo = @(
  @('Modalidade',       'EAD ou semipresencial, com aulas práticas presenciais', 'EAD ou semipresencial, com aulas práticas presenciais'),
  @('Prática',          'Com pacientes reais e acompanhamento de professores',   'Com pacientes reais e acompanhamento de professores'),
  @('Perfil',           'Entrada rápida no mercado',                             'Mais responsabilidade e mercado mais amplo'),
  @('Certificado MEC',  '',                                                      'Reconhecido pelo MEC'),   # TODO: confirmar o do ASB
  @('Duração',          '',                                                      ''),                       # TODO
  @('O que faz',        '',                                                      ''),                       # TODO
  @('Investimento',     '',                                                      'Entrada de R$ 600,00 + parcelas')  # TODO: confirmar o do ASB
)

# ==========================================================================
# 2. AJUSTES E PEÇAS DE LAYOUT
# ==========================================================================
$ZAP = $INST.zap
function ZapLink($txt) { 'https://wa.me/' + $ZAP + '?text=' + [uri]::EscapeDataString($txt) }
function Curso($slug) { $cursos | Where-Object { $_.slug -eq $slug } }
foreach ($c in $cursos) {
  $c.completo = $c.titulo; if ($c.sigla) { $c.completo = $c.titulo + ' (' + $c.sigla + ')' }
}

# Imagens e matérias por curso (chaves de $IMAGENS). Para adicionar a professora em outro curso, copie a linha de 'materias'.
$cTsb = Curso 'tsb'
$cTsb.imgVantagens = 'tsb'
$cTsb.imgPratica   = 'pratica'
$cTsb.materias     = @(@{ titulo = 'Biossegurança e Técnicas Radiológicas'; professora = 'Profª Drª Raquel Pereverzieff'; img = 'raquel' })
$cAsb = Curso 'asb'
$cAsb.imgPratica   = 'colagem'

$MAPA_BUSCA = $INST.endereco; if (-not $MAPA_BUSCA) { $MAPA_BUSCA = 'Mato Grosso do Sul, Brasil' }
$zoom = '6'; if ($INST.endereco) { $zoom = '16' }
$MAPA_EMBED = 'https://maps.google.com/maps?q=' + [uri]::EscapeDataString($MAPA_BUSCA) + '&z=' + $zoom + '&output=embed'
$MAPA_LINK  = 'https://www.google.com/maps/search/?api=1&query=' + [uri]::EscapeDataString($MAPA_BUSCA)

$estilo   = '<style>' + "`n" + [IO.File]::ReadAllText("$fonte\estilo.css", [Text.Encoding]::UTF8).TrimEnd() + "`n" + '</style>'
$jsInline = '<script>' + "`n" + [IO.File]::ReadAllText("$fonte\script.js", [Text.Encoding]::UTF8).TrimEnd() + "`n" + '</script>'
$sprite   = [IO.File]::ReadAllText("$fonte\icones.html", [Text.Encoding]::UTF8)

Add-Type -AssemblyName System.Drawing
$li = [System.Drawing.Image]::FromFile("$root\assets\logo.png"); $LW = $li.Width; $LH = $li.Height; $li.Dispose()

$ogImg = 'assets/og.jpg'; if ($SITE_URL) { $ogImg = $SITE_URL + '/assets/og.jpg' }

function Json($obj) { '<script type="application/ld+json">' + ($obj | ConvertTo-Json -Depth 8 -Compress) + '</script>' }

function Foto($pasta, $arq, $legenda, $alt, $classe) {
  '<figure class="foto ' + $classe + '"><img src="assets/images/' + $pasta + '/' + $arq + '" alt="' + $alt + '" loading="lazy" onerror="this.remove()">' +
  '<figcaption class="foto__ph"><svg class="i" aria-hidden="true"><use href="#i-camera"/></svg><span>Substituir: ' + $legenda + '</span></figcaption></figure>'
}

function Pic($chave, $sizes, $classe, $eager, $pos) {
  $im = $IMAGENS[$chave]
  $dir = "$root\assets\images\$($im.pasta)"
  $jpg = "$dir\$($im.arq).jpg"
  if (-not (Test-Path $jpg)) { throw "Imagem não encontrada: $jpg" }
  $img = [System.Drawing.Image]::FromFile($jpg); $w = $img.Width; $h = $img.Height; $img.Dispose()
  $lista = @(Get-ChildItem $dir -Filter ($im.arq + '-*.webp') | ForEach-Object { [pscustomobject]@{ w = [int]([IO.Path]::GetFileNameWithoutExtension($_.Name).Split('-')[-1]); n = $_.Name } } | Sort-Object w)
  $rel = 'assets/images/' + $im.pasta + '/'
  $srcset = ($lista | ForEach-Object { $rel + $_.n + ' ' + $_.w + 'w' }) -join ', '
  $p = $im.pos; if ($pos) { $p = $pos }
  $estilo = ''; if ($p) { $estilo = ' style="object-position:' + $p + '"' }
  $carga = ' loading="lazy" decoding="async"'; if ($eager) { $carga = ' fetchpriority="high" decoding="async"' }
  $cls = ''; if ($classe) { $cls = ' class="' + $classe + '"' }
  $fonte = ''; if ($srcset) { $fonte = '<source type="image/webp" srcset="' + $srcset + '" sizes="' + $sizes + '">' }
  '<picture' + $cls + '>' + $fonte + '<img src="' + $rel + $im.arq + '.jpg" alt="' + $im.alt + '" width="' + $w + '" height="' + $h + '"' + $carga + $estilo + '></picture>'
}

function PreloadImg($chave, $sizes) {
  $im = $IMAGENS[$chave]
  $dir = "$root\assets\images\$($im.pasta)"
  $lista = @(Get-ChildItem $dir -Filter ($im.arq + '-*.webp') | ForEach-Object { [pscustomobject]@{ w = [int]([IO.Path]::GetFileNameWithoutExtension($_.Name).Split('-')[-1]); n = $_.Name } } | Sort-Object w)
  $rel = 'assets/images/' + $im.pasta + '/'
  $srcset = ($lista | ForEach-Object { $rel + $_.n + ' ' + $_.w + 'w' }) -join ', '
  '  <link rel="preload" as="image" type="image/webp" imagesrcset="' + $srcset + '" imagesizes="' + $sizes + '" fetchpriority="high">'
}

function Head($title, $desc, $extra) {
  $urlMeta = ''
@"
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>$title</title>
  <meta name="description" content="$desc">
  <meta name="theme-color" content="#340E3F">
  <meta property="og:type" content="website">
  <meta property="og:locale" content="pt_BR">
  <meta property="og:site_name" content="$($INST.nome)">
  <meta property="og:title" content="$title">
  <meta property="og:description" content="$desc">
  <meta property="og:image" content="$ogImg">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="$title">
  <meta name="twitter:description" content="$desc">
  <meta name="twitter:image" content="$ogImg">
  <link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%2370327D'%3E%3Cpath d='M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z'/%3E%3C/svg%3E">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;0,800;1,600;1,700&family=Work+Sans:wght@400;500;600;700&family=Fraunces:ital,wght@0,700;1,700&display=swap" rel="stylesheet">
$extra
$estilo
</head>
<body>

<!-- Ícones (sprite) -->

"@
}

function Header($ativo, $escuro) {
  $itens = @(@('cursos.html', 'Cursos', 'cursos'), @('index.html#pratica', 'Prática real', ''), @('index.html#professores', 'Professores', ''), @('sobre.html', 'Sobre', 'sobre'), @('contato.html', 'Contato', 'contato'))
  $nav = ''
  foreach ($i in $itens) {
    $cur = ''; if ($i[2] -and $i[2] -eq $ativo) { $cur = ' aria-current="page"' }
    $nav += '      <a href="' + $i[0] + '"' + $cur + '>' + $i[1] + '</a>' + "`n"
  }
  $wa = ZapLink 'Olá! Vim pelo site do Instituto Dr. Bach e gostaria de saber mais sobre os cursos.'
  $clsTopo = 'topo'; $logoArq = 'logo.png'; $clsCta = 'btn--magenta'
  if ($escuro) { $clsTopo = 'topo topo--escuro'; $logoArq = 'logo-branco.png'; $clsCta = 'btn--ouro-hero' }
@"
<a class="skip" href="#conteudo">Ir para o conteúdo</a>

<header class="$clsTopo" id="topo">
  <div class="container topo__in">
    <a class="topo__logo" href="index.html" aria-label="$($INST.curto) — início">
      <img src="assets/$logoArq" alt="$($INST.curto) de Desenvolvimento Humano" width="$LW" height="$LH">
    </a>

    <nav class="nav" id="nav" aria-label="Principal">
$nav      <a class="btn $clsCta nav__cta" href="$wa" target="_blank" rel="noopener"><svg class="i" aria-hidden="true"><use href="#i-chat"/></svg> Falar no WhatsApp</a>
    </nav>

    <button class="menu-btn" id="menuBtn" aria-label="Abrir menu" aria-expanded="false" aria-controls="nav">
      <svg class="i i--open" aria-hidden="true"><use href="#i-menu"/></svg>
      <svg class="i i--close" aria-hidden="true"><use href="#i-close"/></svg>
    </button>
  </div>
</header>

<main id="conteudo">

"@
}

function Footer($waTxt) {
  $wa = ZapLink $waTxt
  $info = ''
  if ($INST.cidadeUF)  { $info += '      <span>' + $INST.cidadeUF + '</span>' + "`n" }
  if ($INST.endereco)  { $info += '      <span>' + $INST.endereco + '</span>' + "`n" }
  if ($INST.email)     { $info += '      <a href="mailto:' + $INST.email + '">' + $INST.email + '</a>' + "`n" }
  if ($INST.horario)   { $info += '      <span>' + $INST.horario + '</span>' + "`n" }
  if ($INST.cnpj)      { $info += '      <span>CNPJ ' + $INST.cnpj + '</span>' + "`n" }
  if ($info) { $info = '    <div class="rodape__info">' + "`n" + $info + '    </div>' + "`n" }
@"

</main>

<footer class="rodape">
  <div class="container rodape__grid">
    <div class="rodape__marca">
      <img src="assets/logo-branco.png" alt="$($INST.curto) de Desenvolvimento Humano" width="$LW" height="$LH" loading="lazy">
      <p>$($INST.nome). Saúde, educação e desenvolvimento humano: conhecimento que cuida e transforma.</p>
      <div class="parceria parceria--rodape">
        <span class="parceria__rotulo">Em parceria com</span>
        <span class="parceria__marca" aria-label="$($INST.parceria)">$($INST.parceria)</span>
      </div>
$info    </div>
    <nav aria-label="Rodapé">
      <h4>Navegação</h4>
      <a href="index.html">Início</a>
      <a href="cursos.html">Cursos</a>
      <a href="sobre.html">Sobre</a>
      <a href="contato.html">Contato</a>
      <a href="inscricao.html">Cadastro de inscrição</a>
      <a href="politica-de-privacidade.html">Política de Privacidade</a>
    </nav>
    <div>
      <h4>Contato</h4>
      <a href="https://wa.me/$ZAP" target="_blank" rel="noopener">WhatsApp: $($INST.zapExibe)</a>
      <a href="$($INST.instagram)" target="_blank" rel="noopener">Instagram: $($INST.instagramUser)</a>
      <span>Capacitação | Extensão | Pós-graduação | Técnico</span>
    </div>
  </div>
  <div class="container rodape__base">
    <span>© <span id="ano">2026</span> $($INST.nome). Todos os direitos reservados.</span>
  </div>
</footer>

<a class="zap" href="$wa" target="_blank" rel="noopener" aria-label="Falar no WhatsApp">
  <svg class="i" aria-hidden="true"><use href="#i-chat"/></svg>
</a>

$jsInline
</body>
</html>
"@
}

function Banner($migalhas, $tag, $h1, $lead, $icone, $acoes) {
  $mig = ''
  for ($k = 0; $k -lt $migalhas.Count; $k++) {
    $m = $migalhas[$k]
    if ($k -gt 0) { $mig += '<span aria-hidden="true">/</span>' }
    if ($m[1]) { $mig += '<a href="' + $m[1] + '">' + $m[0] + '</a>' } else { $mig += '<span aria-current="page">' + $m[0] + '</span>' }
  }
  $t = ''; if ($tag) { $t = '      <span class="tag">' + $tag + '</span>' + "`n" }
  $a = ''; if ($acoes) { $a = '      <div class="pagina-topo__acoes">' + $acoes + '</div>' + "`n" }
  $l = ''; if ($lead) { $l = '      <p class="pagina-topo__lead">' + $lead + '</p>' + "`n" }
@"
<section class="pagina-topo">
  <svg class="pagina-topo__marca" aria-hidden="true"><use href="#i-$icone"/></svg>
  <div class="container">
    <nav class="migalhas" aria-label="Você está aqui">$mig</nav>
$t      <h1 class="pagina-topo__titulo">$h1</h1>
$l$a  </div>
</section>

"@
}

function Card($c) {
  $sig = ''; if ($c.sigla) { $sig = ' <small>(' + $c.sigla + ')</small>' }
  $meta = ''
  if ($c.duracao)    { $meta += '<li>' + $c.duracao + '</li>' }
  if ($c.modalCurta) { $meta += '<li>' + $c.modalCurta + '</li>' }
  if ($c.mec)        { $meta += '<li class="mec">Reconhecido pelo MEC</li>' }
  if ($meta) { $meta = '          <ul class="curso__meta">' + $meta + '</ul>' + "`n" }
  # o card inteiro é um link só (não tem outro link dentro): o "botão" é um <span> com cara de botão
  '      <a class="curso" data-area="' + $c.area + '" href="curso-' + $c.slug + '.html" aria-label="' + $c.titulo + ' — conhecer o curso">' + "`n" +
  '        <span class="curso__marca" aria-hidden="true"><svg class="i" aria-hidden="true"><use href="#i-' + $c.icone + '"/></svg></span>' + "`n" +
  '        <div class="curso__corpo">' + "`n" +
  '          <span class="tag">' + $c.tag + '</span>' + "`n" +
  '          <h3>' + $c.titulo + $sig + '</h3>' + "`n" +
  '          <p>' + $c.card + '</p>' + "`n" +
  $meta +
  '          <span class="curso__cta">Conhecer o curso <svg class="i" aria-hidden="true"><use href="#i-arrow"/></svg></span>' + "`n" +
  '        </div>' + "`n" +
  '      </a>' + "`n"
}

function TambemOferecemos() {
  $itens = @(
    @('cap',       'Capacitação',   'Cursos rápidos para entrar no mercado.'),
    @('users',     'Extensão',      'Amplie seus conhecimentos com cursos de extensão.'),
    @('award',     'Pós-graduação', 'Aprofunde sua formação e conquiste novos caminhos.'),
    @('briefcase', 'Cursos técnicos', 'Formação técnica para atuar na sua área.')
  )
  $h = ''
  foreach ($i in $itens) {
    $wa = ZapLink ('Olá! Tenho interesse em: ' + $i[1] + '. Pode me passar mais informações?')
    $h += '      <a class="mais__item" href="' + $wa + '" target="_blank" rel="noopener"><svg class="i" aria-hidden="true"><use href="#i-' + $i[0] + '"/></svg><h3>' + $i[1] + '</h3><p>' + $i[2] + '</p><span>Consultar no WhatsApp</span></a>' + "`n"
  }
@"
    <div class="curso__bloco">
      <header class="secao__cab">
        <span class="pill pill--roxo">Também oferecemos</span>
        <h2 class="secao__titulo">Outras formas de <em>crescer</em></h2>
      </header>
      <div class="mais__grid">
$h      </div>
    </div>
"@
}

function CtaFinal($titulo, $texto) {
  $wa = ZapLink 'Olá! Vim pelo site do Instituto Dr. Bach e gostaria de saber mais sobre os cursos.'
@"

<section class="contato">
  <div class="container contato__in">
    <div class="contato__texto reveal">
      <span class="pill pill--ouro">Fale com a gente</span>
      <h2>$titulo</h2>
      <p>$texto</p>
    </div>
    <div class="contato__acoes reveal">
      <a class="btn btn--magenta btn--lg" href="$wa" target="_blank" rel="noopener"><svg class="i" aria-hidden="true"><use href="#i-chat"/></svg> $($INST.zapExibe)</a>
      <a class="btn btn--borda btn--lg" href="inscricao.html">Preencher cadastro <svg class="i" aria-hidden="true"><use href="#i-arrow"/></svg></a>
    </div>
  </div>
</section>

"@
}

function Localizacao() {
  $waGeral = ZapLink 'Olá! Vim pelo site do Instituto Dr. Bach e gostaria de saber mais sobre os cursos.'
  $cardEnd = ''
  if ($INST.endereco) {
    $cardEnd = @"
        <div class="ccard reveal">
          <span class="ccard__ic"><svg class="i" aria-hidden="true"><use href="#i-pin"/></svg></span>
          <h3>Endereço</h3>
          <strong>$($INST.endereco)</strong>
          <span class="ccard__desc">Use o mapa ou o link abaixo para traçar a rota até o Instituto.</span>
          <a class="ccard__link" href="$MAPA_LINK" target="_blank" rel="noopener">Abrir no Google Maps</a>
        </div>

"@
  }
  $cardEmail = ''
  if ($INST.email) {
    $cardEmail = @"
        <a class="ccard reveal" href="mailto:$($INST.email)">
          <span class="ccard__ic"><svg class="i" aria-hidden="true"><use href="#i-mail"/></svg></span>
          <h3>E-mail</h3>
          <strong>$($INST.email.Replace('@', '@<wbr>'))</strong>
          <span class="ccard__desc">Escreva para o Instituto</span>
        </a>

"@
  }
  $mapaTexto = 'Encontre o Instituto no mapa, fale com a nossa equipe pelo WhatsApp ou acompanhe o dia a dia no Instagram.'
@"
<!-- ============ LOCALIZAÇÃO E CONTATO ============ -->
<section class="secao" id="contato">
  <div class="container">
    <header class="secao__cab reveal">
      <span class="pill pill--roxo">Onde estamos</span>
      <h2 class="secao__titulo">Venha nos <em>conhecer</em></h2>
      <p class="secao__lead">$mapaTexto</p>
    </header>

    <div class="local__grid">
      <div class="local__cards">
$cardEnd        <a class="ccard reveal" href="$waGeral" target="_blank" rel="noopener">
          <span class="ccard__ic"><svg class="i" aria-hidden="true"><use href="#i-chat"/></svg></span>
          <h3>WhatsApp</h3>
          <strong>$($INST.zapExibe)</strong>
          <span class="ccard__desc">Atendimento direto com a nossa equipe</span>
        </a>
$cardEmail        <a class="ccard reveal" href="$($INST.instagram)" target="_blank" rel="noopener">
          <span class="ccard__ic"><svg class="i" aria-hidden="true"><use href="#i-insta"/></svg></span>
          <h3>Instagram</h3>
          <strong>$($INST.instagramUser)</strong>
          <span class="ccard__desc">Acompanhe as novidades do Instituto</span>
        </a>
      </div>

      <div class="local__mapa reveal">
        <iframe title="Mapa do Google Maps com a localização do $($INST.curto)" src="$MAPA_EMBED" loading="lazy" referrerpolicy="no-referrer-when-downgrade" allowfullscreen></iframe>
      </div>
    </div>
  </div>
</section>

"@
}

function Docentes($classeSecao) {
  $h = ''
  foreach ($d in $docentes) {
    $reg = ''; if ($d.reg) { $reg = '        <span class="docente__reg">' + $d.reg + '</span>' + "`n" }
    $area = ''; if ($d.area) { $area = '        <span class="docente__area">' + $d.area + '</span>' + "`n" }
    $lnk = ''; if ($d.instagram) { $lnk = '        <a class="docente__link" href="' + $d.instagram + '" target="_blank" rel="noopener"><svg class="i" aria-hidden="true"><use href="#i-insta"/></svg> Instagram</a>' + "`n" }
    $cargo = ''; if ($d.cargo) { $cargo = '        <span class="docente__cargo">' + $d.cargo + '</span>' + "`n" }
    if ($d.pic) {
      $fotoHtml = '        <div class="docente__foto docente__foto--img">' + (Pic $d.pic '(max-width: 560px) 80vw, 320px' '' $false) + '</div>' + "`n"
    } else {
      $fotoHtml = '        <div class="docente__foto" role="img" aria-label="Foto de ' + $d.nome + '">' + $d.iniciais + '<img src="assets/images/equipe/' + $d.foto + '" alt="' + $d.nome + '" loading="lazy" onerror="this.remove()"></div>' + "`n"
    }
    $clsDoc = 'docente reveal'; if ($d.pic) { $clsDoc += ' docente--foto' }
    $h += '      <article class="' + $clsDoc + '">' + "`n" + $fotoHtml + $cargo +
          '        <h3>' + $d.nome + '</h3>' + "`n" + $reg + $area + $lnk +
          '      </article>' + "`n"
  }
@"
<!-- ============ CORPO DOCENTE E DIREÇÃO ============ -->
<section class="secao $classeSecao" id="professores">
  <div class="container">
    <header class="secao__cab reveal">
      <span class="pill pill--roxo">Quem ensina</span>
      <h2 class="secao__titulo">Direção e <em>professores</em></h2>
      <p class="secao__lead">Quem dirige e quem dá aula no Instituto.</p>
    </header>
    <div class="docentes">
$h    </div>
  </div>
</section>

"@
}

function Pagina($ativo, $title, $desc, $main, $extraHead, $waTxt, $escuro) {
  if (-not $waTxt) { $waTxt = 'Olá! Vim pelo site do Instituto Dr. Bach e gostaria de saber mais sobre os cursos.' }
  (Head $title $desc $extraHead) + $sprite + "`n" + (Header $ativo $escuro) + $main + (Footer $waTxt)
}

function Salvar($nome, $conteudo) { [IO.File]::WriteAllText("$root\$nome", $conteudo, $utf8) }

# JSON-LD da organização (campos desconhecidos são omitidos)
$org = [ordered]@{ '@context' = 'https://schema.org'; '@type' = 'EducationalOrganization'; name = $INST.nome; alternateName = $INST.curto }
if ($SITE_URL) { $org['url'] = $SITE_URL; $org['logo'] = $SITE_URL + '/assets/logo.png' }
$org['sameAs'] = @($INST.instagram)
$org['contactPoint'] = [ordered]@{ '@type' = 'ContactPoint'; contactType = 'customer service'; telephone = '+' + $INST.zap; availableLanguage = 'Portuguese' }
if ($INST.email)    { $org['email'] = $INST.email }
if ($INST.endereco) { $org['address'] = [ordered]@{ '@type' = 'PostalAddress'; streetAddress = $INST.endereco } }
$orgLd = Json $org

# ==========================================================================
# 3. PÁGINAS
# ==========================================================================

# ---------------- INÍCIO ----------------
$cardsTodos = ''; foreach ($c in $cursos) { $cardsTodos += Card $c }
$waMatricula = ZapLink 'Olá! Vim pelo site do Instituto Dr. Bach e quero me matricular. Pode me passar mais informações?'
$waSaudeBucal = ZapLink 'Olá! Quero saber mais sobre os cursos de saúde bucal (ASB e TSB).'

$hero = @"
<!-- ============ HERO ============ -->
<section class="hero hero--v4" id="inicio">
  <div class="hero__bg">
    $(Pic 'heroFoto' '100vw' 'hero__bgimg' $true)
  </div>

  <div class="container hero__grid">
    <div class="hero__texto">
      <span class="pill pill--ouro">Saúde bucal e licenciaturas</span>
      <h1 class="hero__titulo">Prática com <span class="destaque">paciente real</span>,<br><span class="leve">desde o primeiro dia.</span></h1>
      <p class="hero__lead">Cursos de saúde bucal e de licenciatura com certificado reconhecido pelo MEC. Teoria no seu ritmo e prática com pacientes de verdade.</p>

      <div class="hero__acoes">
        <a class="btn btn--ouro-hero btn--lg" href="$waMatricula" target="_blank" rel="noopener">Quero me matricular <svg class="i" aria-hidden="true"><use href="#i-arrow"/></svg></a>
        <a class="btn btn--borda btn--lg" href="#cursos">Conheça os cursos</a>
      </div>

      <ul class="selos">
        <li class="selo"><svg class="i" aria-hidden="true"><use href="#i-shield"/></svg> Reconhecido pelo MEC</li>
        <li class="selo"><svg class="i" aria-hidden="true"><use href="#i-heart"/></svg> Prática real</li>
        <li class="selo"><svg class="i" aria-hidden="true"><use href="#i-laptop"/></svg> EAD ou semipresencial</li>
      </ul>
    </div>
  </div>

  <div class="container">
    <div class="hero__equipe">
      <div class="credito">
        <span class="credito__rotulo">Coordenador do Curso</span>
        <strong class="credito__nome">Dr. Márcio Santiago</strong>
        <span class="credito__reg">CRO-MS 8513</span>
      </div>
      <div class="credito">
        <span class="credito__rotulo">Diretor Pedagógico</span>
        <strong class="credito__nome">Dr. Evandro Nolasco</strong>
        <span class="credito__reg">CRBM-MS 66811</span>
      </div>
      <div class="parceria">
        <span class="parceria__rotulo">Em parceria com</span>
        <span class="parceria__marca" aria-label="$($INST.parceria)">$($INST.parceria)</span>
      </div>
    </div>
  </div>
</section>

<div class="turma">
  <div class="container turma__in">
    <span>$TURMA</span>
    <a href="$waMatricula" target="_blank" rel="noopener">Garanta sua vaga</a>
  </div>
</div>
"@

$difs = @"
<!-- ============ DIFERENCIAIS ============ -->
<section class="secao secao--compacta" id="diferenciais">
  <div class="container">
    <header class="secao__cab reveal">
      <span class="pill pill--roxo">Por que o Dr. Bach</span>
      <h2 class="secao__titulo">Saúde, educação e <em>cuidado</em> em cada detalhe</h2>
    </header>

    <div class="difs">
      <article class="dif reveal">
        <span class="dif__icone"><svg class="i" aria-hidden="true"><use href="#i-heart"/></svg></span>
        <h3>Prática real</h3>
        <p>Você atende paciente real desde a primeira aula prática, com um professor acompanhando de perto.</p>
      </article>
      <article class="dif reveal">
        <span class="dif__icone"><svg class="i" aria-hidden="true"><use href="#i-users"/></svg></span>
        <h3>Professores que ajudam</h3>
        <p>Professores que “pegam na sua mão” e acompanham você de perto durante a formação.</p>
      </article>
      <article class="dif reveal">
        <span class="dif__icone"><svg class="i" aria-hidden="true"><use href="#i-shield"/></svg></span>
        <h3>Certificado reconhecido pelo MEC</h3>
        <p>Certificado reconhecido pelo MEC nas licenciaturas, no tecnólogo e no Técnico em Saúde Bucal.</p>
      </article>
      <article class="dif reveal">
        <span class="dif__icone"><svg class="i" aria-hidden="true"><use href="#i-laptop"/></svg></span>
        <h3>Estude no seu ritmo</h3>
        <p>Teoria on-line, no seu horário, e prática presencial nos cursos de saúde bucal.</p>
      </article>
    </div>
  </div>
</section>

"@

$secCursos = @"
<!-- ============ CURSOS ============ -->
<section class="secao secao--lilas" id="cursos">
  <div class="container">
    <header class="secao__cab reveal">
      <span class="pill pill--roxo">Nossos cursos</span>
      <h2 class="secao__titulo">Da capacitação à <em>segunda graduação</em></h2>
      <p class="secao__lead">Comece pela saúde bucal, o carro-chefe do Instituto, ou por uma segunda licenciatura 100% online.</p>
    </header>

    <div class="filtros reveal" role="tablist" aria-label="Filtrar cursos por área">
      <button class="filtro is-ativo" role="tab" aria-selected="true" data-filtro="todos">Todos</button>
      <button class="filtro" role="tab" aria-selected="false" data-filtro="saude">Saúde bucal</button>
      <button class="filtro" role="tab" aria-selected="false" data-filtro="educacao">Educação</button>
    </div>

    <div class="cursos" id="cursosGrid">
$cardsTodos    </div>

    <p class="secao__lead" style="text-align:center;margin-top:26px;font-size:.85rem">$AVISO_VALORES</p>
$(TambemOferecemos)
  </div>
</section>

"@

$video = ''
if ($VIDEO_YT) {
  $video = '      <div class="video" data-video="' + $VIDEO_YT + '" data-titulo="Vídeo de uma aula prática"><button type="button" aria-label="Assistir ao vídeo"><svg class="i" aria-hidden="true"><use href="#i-play"/></svg></button></div>' + "`n"
}
$pratica = @"
<!-- ============ PRÁTICA REAL ============ -->
<section class="pratica" id="pratica">
  <div class="container pratica__grid">
    <div class="pratica__texto">
      <span class="pill pill--ouro reveal">Prática real</span>
      <h2 class="pratica__titulo reveal">Você atende <span class="leve">pacientes</span> <span class="destaque">reais.</span></h2>
      <p class="pratica__frase reveal">Prática com gente de verdade, não só com livro.</p>
      <p class="reveal">Nos cursos de saúde bucal, você atende pacientes reais com um professor ao seu lado, orientando cada passo.</p>
      <a class="btn btn--magenta btn--lg reveal" href="$waSaudeBucal" target="_blank" rel="noopener">Quero praticar com pacientes reais <svg class="i" aria-hidden="true"><use href="#i-arrow"/></svg></a>
    </div>
    <div class="pratica__midia reveal">
      <div class="midia-duo">
        $(Pic 'pratica' '(max-width: 960px) 44vw, 270px' 'img-r' $false)
        <!-- FACOP: a arte abaixo exibe a marca da FACOP. Confirmar com o instituto a permissão de exibir a marca (ver PENDENCIAS.md) -->
        $(Pic 'colagem' '(max-width: 960px) 44vw, 270px' 'img-r' $false)
      </div>
$video    </div>
  </div>
</section>

"@

$mercado = @"
<!-- ============ MERCADO ============ -->
<section class="secao mercado-sec" id="mercado">
  <div class="container mercado__in">
    <header class="secao__cab reveal">
      <span class="pill pill--roxo">Mercado da odontologia</span>
      <h2 class="secao__titulo">O tamanho do mercado <em>odontológico</em> no Brasil</h2>
    </header>
    <div class="stats">
      <div class="stat reveal">
        <span class="stat__num" data-valor="406.2" data-casas="1" data-sufixo=" mil">406,2 mil</span>
        <span class="stat__rotulo">dentistas no Brasil</span>
      </div>
      <div class="stat reveal">
        <span class="stat__num" data-valor="230" data-casas="0" data-prefixo="+" data-sufixo=" mil">+230 mil</span>
        <span class="stat__rotulo">consultórios odontológicos, e cada um precisa de pelo menos 1 auxiliar qualificado</span>
      </div>
    </div>
    <p class="mercado__fecho reveal">É um mercado grande, e começa com gente qualificada.</p>
    <p class="fonte">Fonte: $FONTE_MERCADO. <!-- TODO: confirmar link da fonte original antes de publicar --></p>
    <a class="btn btn--magenta btn--lg reveal" href="$waSaudeBucal" target="_blank" rel="noopener">Quero me qualificar <svg class="i" aria-hidden="true"><use href="#i-arrow"/></svg></a>
  </div>
</section>

"@

$linha = @"
<!-- ============ DO ZERO AO PRIMEIRO EMPREGO ============ -->
<section class="secao secao--lilas" id="como-funciona">
  <div class="container">
    <header class="secao__cab reveal">
      <span class="pill pill--roxo">Como funciona</span>
      <h2 class="secao__titulo">Os passos até o <em>seu certificado</em></h2>
      <p class="secao__lead">Veja como começar, em quatro passos.</p>
    </header>
    <div class="linha-wrap">
      <div class="linha__img reveal">
        $(Pic 'professor' '(max-width: 960px) 80vw, 400px' 'img-r' $false)
      </div>
      <ol class="linha">
      <li class="reveal"><span class="linha__n">1</span><h3>Escolha o curso</h3><p>Veja as opções de saúde bucal e de educação e escolha a que combina com você.</p></li>
      <li class="reveal"><span class="linha__n">2</span><h3>Faça sua matrícula</h3><p>Fale com a nossa equipe pelo WhatsApp e garanta sua vaga. Nas licenciaturas, o início é imediato.</p></li>
      <li class="reveal"><span class="linha__n">3</span><h3>Estude e pratique</h3><p>Teoria online no seu ritmo e, nos cursos de saúde bucal, aulas práticas presenciais com pacientes reais.</p></li>
      <li class="reveal"><span class="linha__n">4</span><h3>Receba seu certificado</h3><p>Você recebe o certificado de conclusão do curso escolhido.</p></li>
    </ol>
    </div>
  </div>
</section>

"@

$formaturas = @"
<!-- ============ FORMATURAS E RESULTADOS ============ -->
<!-- TODO: depoimentos reais só entram com autorização; enquanto isso, mostramos apenas a galeria -->
<section class="secao secao--lilas" id="formaturas">
  <div class="container">
    <header class="secao__cab reveal">
      <span class="pill pill--roxo">Nossos alunos</span>
      <h2 class="secao__titulo">Formaturas e <em>conquistas</em></h2>
      <p class="secao__lead">Fotos de turmas que já passaram pelo Instituto.</p>
    </header>
    <div class="forma reveal">
      $(Pic 'recepcao' '(max-width: 960px) 92vw, 480px' 'img-r' $false)
      $(Pic 'tsb' '(max-width: 960px) 92vw, 480px' 'img-r' $false)
    </div>
  </div>
</section>

"@

$instaFotos = ''
foreach ($n in 1..6) { $instaFotos += '        <a href="' + $INST.instagram + '" target="_blank" rel="noopener" aria-label="Ver publicações no Instagram">' + (Foto 'instagram' ('0' + $n + '.jpg') 'imagem do Instagram' 'Publicação do Instagram do Instituto Dr. Bach' 'foto--quadrada') + '</a>' + "`n" }
$insta = @"
<!-- ============ INSTAGRAM ============ -->
<section class="secao" id="instagram">
  <div class="container insta">
    <div class="insta__texto reveal">
      <span class="pill pill--roxo">Instagram</span>
      <h2 class="secao__titulo" style="text-align:left">Acompanhe o <em>dia a dia</em></h2>
      <p>Bastidores das aulas, turmas e novidades do Instituto. Siga $($INST.instagramUser).</p>
      <a class="btn btn--magenta btn--lg" href="$($INST.instagram)" target="_blank" rel="noopener"><svg class="i" aria-hidden="true"><use href="#i-insta"/></svg> Seguir $($INST.instagramUser)</a>
    </div>
    <div class="insta__grid reveal">
$instaFotos    </div>
  </div>
</section>

"@

$faqHtml = ''
foreach ($q in $faq) {
  $faqHtml += '      <details><summary>' + $q.p + ' <svg class="i" aria-hidden="true"><use href="#i-chev"/></svg></summary><div class="faq__resp">' + $q.r + '</div></details>' + "`n"
}
$faqSec = @"
<!-- ============ FAQ ============ -->
<!-- TODO: respostas provisórias, revisar com o instituto antes de publicar -->
<section class="secao secao--lilas" id="faq">
  <div class="container">
    <header class="secao__cab reveal">
      <span class="pill pill--roxo">Dúvidas frequentes</span>
      <h2 class="secao__titulo">Ficou com <em>dúvida?</em></h2>
    </header>
    <div class="faq reveal">
$faqHtml    </div>
  </div>
</section>

"@

$homeMain = $hero + $difs + $secCursos + $pratica + $mercado + $linha + (Docentes '') + $formaturas + $insta + $faqSec + (Localizacao) + (CtaFinal 'Ficou interessado? Entre em contato!' 'Fale com a nossa equipe pelo WhatsApp e tire suas dúvidas sobre os cursos.')
Salvar 'index.html' (Pagina 'inicio' 'Instituto Dr. Bach | Cursos de Saúde Bucal e Licenciaturas com prática real' 'Cursos de saúde bucal (TSB e ASB) e 2ª licenciatura com certificado reconhecido pelo MEC e prática real com pacientes. Fale com o Instituto Dr. Bach pelo WhatsApp.' $homeMain ($orgLd + "`n" + (PreloadImg 'heroFoto' '100vw')) 'Olá! Vim pelo site do Instituto Dr. Bach e quero me matricular. Pode me passar mais informações?' $true)

# ---------------- CURSOS ----------------
$comp = ''
foreach ($l in $comparativo) { if ($l[1] -and $l[2]) { $comp += '        <tr><th scope="row">' + $l[0] + '</th><td>' + $l[1] + '</td><td>' + $l[2] + '</td></tr>' + "`n" } }
$waEscolher = ZapLink 'Olá! Estou em dúvida entre o ASB e o TSB. Pode me ajudar a escolher?'
$secComp = @"
<!-- ============ COMPARATIVO ASB x TSB ============ -->
<!-- TODO: completar linhas de Duração, O que faz, Investimento e Certificado MEC do ASB em `$comparativo (gerar-site.ps1) -->
<section class="secao" id="comparativo">
  <div class="container">
    <header class="secao__cab reveal">
      <span class="pill pill--roxo">Saúde bucal</span>
      <h2 class="secao__titulo">ASB ou TSB: qual a <em>diferença</em> e qual escolher?</h2>
    </header>
    <div class="comp-wrap reveal">
      <table class="comp">
        <caption class="sr-only">Comparativo entre Auxiliar e Técnico em Saúde Bucal</caption>
        <thead><tr><th scope="col"><span class="sr-only">Item</span></th><th scope="col">ASB</th><th scope="col">TSB</th></tr></thead>
        <tbody>
$comp        </tbody>
      </table>
      <p class="comp__nota">Em dúvida? Nossa equipe ajuda você a escolher. <a class="btn btn--magenta" href="$waEscolher" target="_blank" rel="noopener" style="margin-left:8px">Falar no WhatsApp</a></p>
    </div>
  </div>
</section>

"@
$cursosMain = (Banner @(@('Início', 'index.html'), @('Cursos', $null)) $null 'Nossos cursos' 'Veja os cursos de saúde bucal, as licenciaturas e o tecnólogo 100% online.' 'book' $null) + @"
<section class="secao secao--lilas">
  <div class="container">
    <div class="filtros" role="tablist" aria-label="Filtrar cursos por área">
      <button class="filtro is-ativo" role="tab" aria-selected="true" data-filtro="todos">Todos</button>
      <button class="filtro" role="tab" aria-selected="false" data-filtro="saude">Saúde bucal</button>
      <button class="filtro" role="tab" aria-selected="false" data-filtro="educacao">Educação</button>
    </div>
    <div class="cursos" id="cursosGrid">
$cardsTodos    </div>
    <p class="secao__lead" style="text-align:center;margin-top:26px;font-size:.85rem">$AVISO_VALORES</p>
$(TambemOferecemos)
  </div>
</section>

"@ + $secComp + (CtaFinal 'Não sabe qual escolher?' 'Fale com a nossa equipe pelo WhatsApp. Ela ajuda você a escolher o curso certo.')
Salvar 'cursos.html' (Pagina 'cursos' 'Cursos | Instituto Dr. Bach' 'Conheça os cursos do Instituto Dr. Bach: Técnico e Auxiliar em Saúde Bucal, 2ª licenciaturas em Pedagogia, Música e Educação Especial, Gestão Pública e AEE.' $cursosMain '' '')

# ---------------- UMA PÁGINA POR CURSO ----------------
foreach ($c in $cursos) {
  # fatos: só entram os campos preenchidos
  $f = @()
  if ($c.nivel)   { $f += ,@('Nível', $c.nivel) }
  if ($c.modal)   { $f += ,@('Modalidade', $c.modal) }
  if ($c.duracao) { $f += ,@('Duração', $c.duracao) }
  if ($c.publico) { $f += ,@('Público', $c.publico) }
  if ($c.mec)     { $f += ,@('Certificado', 'Reconhecido pelo MEC') }
  if ($c.coord)   { $f += ,@('Coordenação', $c.coord) }
  $fatos = ''; foreach ($x in $f) { $fatos += '        <div><dt>' + $x[0] + '</dt><dd>' + $x[1] + '</dd></div>' + "`n" }
  if ($fatos) { $fatos = '      <dl class="cs__fatos">' + "`n" + $fatos + '      </dl>' + "`n" }

  $lista = ''; foreach ($li2 in $c.lista) { $lista += '        <li><svg class="i" aria-hidden="true"><use href="#i-check"/></svg> ' + $li2 + '</li>' + "`n" }
  $ulLista = '      <ul class="cs__lista">' + "`n" + $lista + '      </ul>' + "`n"
  $listaBloco = $ulLista
  if ($c.imgVantagens) {
    $listaBloco = '      <div class="cs__duas">' + "`n" + $ulLista + '        <div class="cs__figura">' + (Pic $c.imgVantagens '(max-width: 720px) 70vw, 260px' 'img-r' $false) + '</div>' + "`n" + '      </div>' + "`n"
  }
  $aprender = ''
  if ($c.aprender.Count -gt 0) {
    $itens = ''; foreach ($a in $c.aprender) { $itens += '        <li><svg class="i" aria-hidden="true"><use href="#i-check"/></svg> ' + $a + '</li>' + "`n" }
    $aprender = '      <h2 class="cs__sub">O que você vai aprender</h2>' + "`n" + '      <ul class="cs__lista">' + "`n" + $itens + '      </ul>' + "`n"
  }
  $pratica2 = ''
  if ($c.saude) {
    $textoPratica = '<p class="cs__texto">Você estuda a teoria em EAD ou semipresencial, no seu ritmo, e faz as aulas práticas de forma presencial, com pacientes reais e um professor acompanhando de perto.</p>'
    if ($c.imgPratica) {
      $aviso = ''; if ($c.imgPratica -eq 'colagem') { $aviso = '        <!-- FACOP: a arte exibe a marca da FACOP. Confirmar com o instituto a permissão de exibir a marca (ver PENDENCIAS.md) -->' + "`n" }
      $fina = ''; if ($c.imgPratica -eq 'pratica') { $fina = ' cs__duas--fina' }
      $pratica2 = '      <h2 class="cs__sub">Como funciona a prática</h2>' + "`n" +
                  '      <div class="cs__duas' + $fina + '">' + "`n" + '        ' + $textoPratica + "`n" + $aviso +
                  '        <div class="cs__figura">' + (Pic $c.imgPratica '(max-width: 720px) 70vw, 260px' 'img-r' $false) + '</div>' + "`n" + '      </div>' + "`n"
    } else {
      $pratica2 = '      <h2 class="cs__sub">Como funciona a prática</h2>' + "`n" + '      ' + $textoPratica + "`n"
    }
  }
  # matéria com a professora responsável (foto e nome junto da matéria que ela ministra)
  $materiasHtml = ''
  if ($c.materias) {
    $materiasHtml = '      <h2 class="cs__sub">Matéria e professora</h2>' + "`n"
    foreach ($m in $c.materias) {
      $materiasHtml += '      <article class="materia">' + "`n" +
                       '        <div class="materia__foto">' + (Pic $m.img '(max-width: 640px) 90vw, 240px' '' $false '50% 0%') + '</div>' + "`n" +
                       '        <div>' + "`n" +
                       '          <span class="materia__rotulo">Matéria</span>' + "`n" +
                       '          <h3>' + $m.titulo + '</h3>' + "`n" +
                       '          <p>Aulas com a <strong>' + $m.professora + '</strong>, responsável pela matéria.</p>' + "`n" +
                       '        </div>' + "`n" +
                       '      </article>' + "`n"
    }
  }
  $dica = ''
  if ($c.slug -eq 'asb' -or $c.slug -eq 'tsb') {
    $dica = '      <div class="cs__caixa"><strong>Em dúvida entre ASB e TSB?</strong> <a href="cursos.html#comparativo">Veja o comparativo</a> ou fale com a nossa equipe.</div>' + "`n"
  }

  # condição de matrícula
  $precoHtml = ''
  if ($c.preco) {
    $parc = $c.preco.parcelas; $parcObs = $c.preco.parcelasObs
    if (-not $parc) { $parc = 'Consulte'; $parcObs = 'Valor e número de parcelas no WhatsApp' }
    $precoHtml = '      <div class="preco"><span class="preco__rotulo">Entrada</span><span class="preco__valor">' + $c.preco.entrada + '</span><span class="preco__obs">' + $c.preco.entradaObs + '</span></div>' + "`n" +
                 '      <div class="preco"><span class="preco__rotulo">Parcelas</span><span class="preco__valor">' + $parc + '</span><span class="preco__obs">' + $parcObs + '</span></div>' + "`n" +
                 '      <p class="aviso">' + $AVISO_VALORES + '</p>' + "`n"
  } else {
    $precoHtml = '      <p class="aviso">Consulte valores e condições de matrícula no WhatsApp.</p>' + "`n"
  }

  $rel = ''; foreach ($r in $c.rel) { $rel += Card (Curso $r) }
  $txtCurso = 'Olá! Vim pelo site do Instituto Dr. Bach e tenho interesse no curso: ' + $c.completo + '. Pode me passar mais informações?'
  $waCurso = ZapLink $txtCurso
  $h1 = $c.titulo; if ($c.sigla) { $h1 += ' <small>(' + $c.sigla + ')</small>' }
  $acoes = '<a class="btn btn--magenta btn--lg" href="' + $waCurso + '" target="_blank" rel="noopener"><svg class="i" aria-hidden="true"><use href="#i-chat"/></svg> Quero me matricular</a>' +
           '<a class="btn btn--borda btn--lg" href="inscricao.html?curso=' + $c.slug + '">Preencher cadastro <svg class="i" aria-hidden="true"><use href="#i-arrow"/></svg></a>'
  $mig = @(@('Início', 'index.html'), @('Cursos', 'cursos.html'), @($c.titulo, $null))
  $banner = Banner $mig $c.tag $h1 $c.lead $c.icone $acoes

  $corpo = @"
<section class="secao cs">
  <div class="container cs__grid">
    <div class="cs__info">
$fatos
      <h2 class="cs__sub">O que você encontra</h2>
$listaBloco$aprender$pratica2$materiasHtml
      <h2 class="cs__sub">Para quem é</h2>
      <p class="cs__texto">$($c.para)</p>
$dica    </div>

    <aside class="cs__insc" aria-label="Matrícula">
      <h2>Garanta sua vaga</h2>
      <p>Fale com a nossa equipe pelo WhatsApp ou deixe seus dados no cadastro.</p>
$precoHtml      <a class="btn btn--magenta btn--lg btn--bloco" href="$waCurso" target="_blank" rel="noopener"><svg class="i" aria-hidden="true"><use href="#i-chat"/></svg> Quero me matricular</a>
      <a class="btn btn--borda btn--bloco" href="inscricao.html?curso=$($c.slug)">Preencher cadastro online</a>
    </aside>
  </div>
</section>

<section class="secao secao--lilas">
  <div class="container">
    <header class="secao__cab">
      <span class="pill pill--roxo">Continue explorando</span>
      <h2 class="secao__titulo">Outros <em>cursos</em></h2>
    </header>
    <div class="cursos">
$rel    </div>
    <div class="secao__mais">
      <a class="btn btn--magenta btn--lg" href="cursos.html">Ver todos os cursos <svg class="i" aria-hidden="true"><use href="#i-arrow"/></svg></a>
    </div>
  </div>
</section>
"@

  # JSON-LD do curso (campos desconhecidos omitidos)
  $ld = [ordered]@{ '@context' = 'https://schema.org'; '@type' = 'Course'; name = $c.completo; description = $c.lead
                    provider = [ordered]@{ '@type' = 'EducationalOrganization'; name = $INST.nome } }
  if ($SITE_URL) { $ld['provider']['url'] = $SITE_URL; $ld['url'] = $SITE_URL + '/curso-' + $c.slug + '.html' }
  if ($c.online -or $c.duracao) {
    $instCurso = [ordered]@{ '@type' = 'CourseInstance' }
    if ($c.online) { $instCurso['courseMode'] = 'online' }
    if ($c.duracao -eq '12 meses') { $instCurso['courseWorkload'] = 'P12M' }
    $ld['hasCourseInstance'] = $instCurso
  }
  Salvar ('curso-' + $c.slug + '.html') (Pagina 'cursos' ($c.completo + ' | Instituto Dr. Bach') $c.lead ($banner + $corpo) (Json $ld) $txtCurso)
}

# ---------------- SOBRE ----------------
$faixa = @"
<section class="faixa" aria-label="Modalidades e credenciais">
  <div class="container faixa__grid">
    <div class="faixa__item">
      <svg class="i" aria-hidden="true"><use href="#i-cap"/></svg>
      <div><strong>Capacitação | Extensão</strong><span>Cursos rápidos para entrar no mercado</span></div>
    </div>
    <div class="faixa__item">
      <svg class="i" aria-hidden="true"><use href="#i-award"/></svg>
      <div><strong>Pós-graduação | Técnico</strong><span>Aprofunde e conquiste seu diploma</span></div>
    </div>
    <div class="faixa__item">
      <svg class="i" aria-hidden="true"><use href="#i-shield"/></svg>
      <div><strong>Certificado reconhecido pelo MEC</strong><span>Nos cursos de graduação e no TSB</span></div>
    </div>
    <div class="faixa__item">
      <svg class="i" aria-hidden="true"><use href="#i-tooth"/></svg>
      <div><strong>Prática real</strong><span>Atendimento a pacientes de verdade</span></div>
    </div>
  </div>
</section>

"@
$sobreImg = @"
<div class="container sobre__banner">
  $(Pic 'turma' '(max-width: 1220px) 92vw, 1180px' 'img-r img-r--crop' $false '50% 42%')
</div>

"@
$sobreMain = (Banner @(@('Início', 'index.html'), @('Sobre', $null)) $null 'Sobre o Instituto' 'Saúde, educação e cuidado reunidos em um só lugar: conhecimento que vira prática e prática que vira carreira.' 'heart' $null) + $sobreImg + @"
<!-- TODO: história e missão do instituto (texto oficial) -->
<section class="secao">
  <div class="container sobre__grid">
    <div class="sobre__texto reveal">
      <span class="pill pill--roxo">Quem somos</span>
      <h2 class="secao__titulo">Desenvolvimento <em>humano</em> em primeiro lugar</h2>
    </div>
    <div class="sobre__corpo reveal">
      <p>O $($INST.nome) oferece capacitação, extensão, pós-graduação e cursos técnicos e de graduação nas áreas da saúde e da educação.</p>
      <p>Nossa identidade une saúde, educação, cuidado e conhecimento. Por isso, nossas formações valorizam a prática real, como o atendimento a pacientes reais na saúde bucal, com o acompanhamento de perto de quem dirige e coordena o Instituto.</p>
      <p>Nossos cursos de graduação e o Técnico em Saúde Bucal têm certificado reconhecido pelo MEC. Contamos com a parceria da $($INST.parceria).</p>
      <a class="btn btn--magenta btn--lg" href="cursos.html">Conheça nossos cursos <svg class="i" aria-hidden="true"><use href="#i-arrow"/></svg></a>
    </div>
  </div>
</section>

"@ + $faixa + (Docentes 'secao--lilas') + (CtaFinal 'Faça parte do Instituto' 'Fale com a nossa equipe, escolha o curso e comece a sua formação.')
Salvar 'sobre.html' (Pagina 'sobre' 'Sobre | Instituto Dr. Bach' 'Conheça o Instituto de Desenvolvimento Humano Dr. Bach: saúde, educação e prática real, com direção, coordenação e professores que acompanham você de perto.' $sobreMain '' '')

# ---------------- CONTATO ----------------
$contatoMain = (Banner @(@('Início', 'index.html'), @('Contato', $null)) $null 'Fale com a gente' 'Tire suas dúvidas, conheça os cursos e descubra como começar. Nossa equipe atende direto pelo WhatsApp.' 'chat' $null) + (Localizacao) + (CtaFinal 'Pronto para começar?' 'Fale com a nossa equipe ou faça seu cadastro agora mesmo.')
Salvar 'contato.html' (Pagina 'contato' 'Contato | Instituto Dr. Bach' 'WhatsApp (67) 99679-3094 e Instagram @institutodrbach do Instituto Dr. Bach. Fale com a nossa equipe.' $contatoMain '' '')

# ---------------- CADASTRO / INSCRIÇÃO ----------------
$opcoes = ''; foreach ($c in $cursos) { $opcoes += '            <option value="' + $c.slug + '">' + $c.completo + '</option>' + "`n" }
$opcoes += '            <option value="outros">Capacitação, extensão, pós-graduação ou cursos técnicos</option>' + "`n"
$waGeral = ZapLink 'Olá! Vim pelo site do Instituto Dr. Bach e gostaria de saber mais sobre os cursos.'
$inscMain = (Banner @(@('Início', 'index.html'), @('Cadastro de inscrição', $null)) $null 'Cadastro de inscrição' 'Preencha seus dados e escolha o curso. Em seguida, abrimos o WhatsApp com tudo pronto para a nossa equipe continuar o seu atendimento.' 'cap' $null) + @"
<section class="secao">
  <div class="container insc__grid">
    <div class="cs__insc insc__form">
      <h2>Seus dados</h2>
      <p>Os campos com * são obrigatórios.</p>

      <form class="form" id="formInscricao">
        <label class="campo">
          <span>Curso *</span>
          <select name="curso" required>
            <option value="" disabled selected>Selecione o curso</option>
$opcoes          </select>
        </label>
        <label class="campo">
          <span>Nome completo *</span>
          <input type="text" name="nome" autocomplete="name" required minlength="3" placeholder="Seu nome">
        </label>
        <div class="form__duplo">
          <label class="campo">
            <span>WhatsApp com DDD *</span>
            <input type="tel" name="whatsapp" autocomplete="tel" inputmode="tel" required pattern="\(\d{2}\) \d{4,5}-\d{4}" title="Informe o DDD e o número, por exemplo (67) 99999-9999" placeholder="(67) 99999-9999">
          </label>
          <label class="campo">
            <span>E-mail <em>(opcional)</em></span>
            <input type="email" name="email" autocomplete="email" placeholder="voce@email.com">
          </label>
        </div>
        <label class="campo">
          <span>Cidade *</span>
          <input type="text" name="cidade" autocomplete="address-level2" required placeholder="Onde você mora">
        </label>
        <label class="campo">
          <span>Observação <em>(opcional)</em></span>
          <textarea name="obs" rows="3" placeholder="Alguma dúvida ou informação que queira nos passar?"></textarea>
        </label>
        <button class="btn btn--magenta btn--lg form__enviar" type="submit">Enviar cadastro <svg class="i" aria-hidden="true"><use href="#i-arrow"/></svg></button>
        <p class="form__nota">Ao enviar, o WhatsApp será aberto com seus dados para a nossa equipe. Este site não armazena as informações. Veja a <a href="politica-de-privacidade.html" style="color:#FFD21C">Política de Privacidade</a>.</p>
      </form>

      <div class="confirmacao" id="confirmacao" tabindex="-1" role="status" hidden>
        <svg class="i" aria-hidden="true"><use href="#i-check"/></svg>
        <div>
          <strong>Quase lá!</strong>
          <p>Abrimos o WhatsApp com os seus dados. Basta enviar a mensagem para concluir o cadastro. Se ele não abriu, <a id="confirmacaoLink" href="#" target="_blank" rel="noopener">clique aqui</a>.</p>
        </div>
      </div>
    </div>

    <div class="insc__lado">
      <h2 class="cs__sub">Como funciona</h2>
      <ol class="passos">
        <li><span class="passos__n">1</span><div><strong>Preencha o cadastro</strong><p>Informe seus dados e escolha o curso de interesse.</p></div></li>
        <li><span class="passos__n">2</span><div><strong>Abrimos o WhatsApp</strong><p>Seus dados vão prontos na mensagem para a nossa equipe.</p></div></li>
        <li><span class="passos__n">3</span><div><strong>Continue o atendimento</strong><p>A equipe tira suas dúvidas e passa valores, datas e documentos.</p></div></li>
      </ol>

      <div class="insc__ajuda">
        <strong>Prefere falar direto?</strong>
        <p>Chame a nossa equipe agora pelo WhatsApp.</p>
        <a class="btn btn--magenta" href="$waGeral" target="_blank" rel="noopener"><svg class="i" aria-hidden="true"><use href="#i-chat"/></svg> $($INST.zapExibe)</a>
      </div>
      <a class="cs__voltar" href="cursos.html"><svg class="i" aria-hidden="true"><use href="#i-arrow"/></svg> Ainda em dúvida? Veja os cursos</a>
    </div>
  </div>
</section>
"@
Salvar 'inscricao.html' (Pagina 'inscricao' 'Cadastro de inscrição | Instituto Dr. Bach' 'Faça seu cadastro de inscrição nos cursos do Instituto Dr. Bach e continue o atendimento pelo WhatsApp.' $inscMain '' '')

# ---------------- POLÍTICA DE PRIVACIDADE ----------------
$contatoPriv = 'pelo WhatsApp ' + $INST.zapExibe
if ($INST.email) { $contatoPriv += ' ou pelo e-mail ' + $INST.email }
$privMain = (Banner @(@('Início', 'index.html'), @('Política de Privacidade', $null)) $null 'Política de Privacidade' 'Como o Instituto Dr. Bach trata os seus dados pessoais, em linha com a Lei Geral de Proteção de Dados (LGPD).' 'shield' $null) + @"
<!-- TODO: modelo básico. REVISAR COM O JURÍDICO antes de publicar (dados do controlador, prazos e bases legais) -->
<section class="secao">
  <div class="container texto-longo">
    <p>Esta política explica quais dados coletamos neste site, para que os usamos e quais são os seus direitos.</p>

    <h2>1. Quem somos</h2>
    <p>O $($INST.nome) é o responsável pelo tratamento dos dados coletados neste site.</p>

    <h2>2. Quais dados coletamos</h2>
    <ul>
      <li>Dados que você informa no cadastro de inscrição: nome, WhatsApp, e-mail (opcional), cidade, curso de interesse e observações.</li>
      <li>Dados de navegação, somente se você aceitar os cookies de medição: páginas visitadas, tipo de aparelho e cliques em botões de contato.</li>
    </ul>

    <h2>3. Como os dados são usados</h2>
    <p>Usamos os dados do cadastro apenas para responder ao seu contato, informar sobre cursos e conduzir a sua matrícula. Este site não guarda os dados do formulário: ao enviar, o WhatsApp é aberto com uma mensagem pronta e a conversa acontece diretamente entre você e a nossa equipe.</p>

    <h2>4. Cookies e medição</h2>
    <p>Quando ativados, usamos ferramentas como Google Analytics e Meta Pixel para entender como o site é usado. Elas só funcionam depois que você aceita o aviso de cookies, e você pode recusar.</p>

    <h2>5. Compartilhamento</h2>
    <p>Não vendemos os seus dados. Eles podem ser tratados por serviços que usamos para operar o site e o atendimento, como o WhatsApp, e por ferramentas de medição, quando você aceita os cookies.</p>

    <h2>6. Seus direitos</h2>
    <p>Você pode pedir a confirmação do tratamento, acesso, correção, anonimização ou eliminação dos seus dados, além de revogar consentimentos, conforme o art. 18 da LGPD.</p>

    <h2>7. Como falar com a gente</h2>
    <p>Para exercer seus direitos ou tirar dúvidas sobre esta política, fale conosco $contatoPriv.</p>

    <h2>8. Atualizações</h2>
    <p>Esta política pode ser atualizada. A versão em vigor é sempre a publicada nesta página.</p>
  </div>
</section>
"@
Salvar 'politica-de-privacidade.html' (Pagina 'privacidade' 'Política de Privacidade | Instituto Dr. Bach' 'Saiba como o Instituto Dr. Bach trata os seus dados pessoais, em linha com a LGPD.' $privMain '' '')

# ==========================================================================
# 4. SEO: sitemap, robots e imagem de compartilhamento
# ==========================================================================
$base = $SITE_URL; if (-not $base) { $base = 'https://SEU-DOMINIO-AQUI' }   # TODO: definir $SITE_URL
$paginas = @('index.html', 'cursos.html', 'sobre.html', 'contato.html', 'inscricao.html', 'politica-de-privacidade.html') + ($cursos | ForEach-Object { 'curso-' + $_.slug + '.html' })
$sm = '<?xml version="1.0" encoding="UTF-8"?>' + "`n" + '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' + "`n"
foreach ($p in $paginas) { $sm += '  <url><loc>' + $base + '/' + $p + '</loc></url>' + "`n" }
$sm += '</urlset>' + "`n"
Salvar 'sitemap.xml' $sm
Salvar 'robots.txt' ("User-agent: *`nAllow: /`nDisallow: /_fonte/`n`nSitemap: " + $base + "/sitemap.xml`n")

$og = "$root\assets\og.jpg"
if (-not (Test-Path $og)) {
  $bmp = New-Object System.Drawing.Bitmap(1200, 630)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'; $g.TextRenderingHint = 'AntiAlias'; $g.InterpolationMode = 'HighQualityBicubic'
  $br = New-Object System.Drawing.Drawing2D.LinearGradientBrush((New-Object System.Drawing.Rectangle(0, 0, 1200, 630)), [System.Drawing.ColorTranslator]::FromHtml('#521D61'), [System.Drawing.ColorTranslator]::FromHtml('#340E3F'), 60)
  $g.FillRectangle($br, 0, 0, 1200, 630)
  $logo = [System.Drawing.Image]::FromFile("$root\assets\logo-branco.png")
  $ogW = 640; $ogH = [int]($ogW * $logo.Height / $logo.Width)
  $g.DrawImage($logo, [int]((1200 - $ogW) / 2), 110, $ogW, $ogH)
  $fonteTxt = New-Object System.Drawing.Font('Georgia', 34, [System.Drawing.FontStyle]::Bold)
  $fmt = New-Object System.Drawing.StringFormat; $fmt.Alignment = 'Center'
  $g.DrawString('Cursos de saúde bucal e graduação com prática real', $fonteTxt, [System.Drawing.Brushes]::White, (New-Object System.Drawing.RectangleF(60, 440, 1080, 120)), $fmt)
  $g.Dispose(); $logo.Dispose()
  $bmp.Save($og, [System.Drawing.Imaging.ImageFormat]::Jpeg); $bmp.Dispose()
}

'gerados: ' + ((Get-ChildItem $root -Filter *.html | ForEach-Object { $_.Name }) -join ', ')
