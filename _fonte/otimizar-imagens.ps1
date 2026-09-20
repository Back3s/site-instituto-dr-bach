# ==========================================================================
#  Instituto Dr. Bach - otimizador de imagens
#  Para trocar uma foto: substitua o .jpg em assets\images\<pasta>\ mantendo o nome,
#  rode este script e depois o gerar-site.ps1.
#  O que ele faz:
#   1) reduz para no máximo 1800 px no lado maior (guarda o original em _fonte\originais)
#   2) gera versões WebP em vários tamanhos (<nome>-480.webp, -800, -1200, ...)
#  O .jpg continua como alternativa para navegadores antigos.
#  Precisa do Microsoft Edge instalado (ele faz a conversão para WebP).
# ==========================================================================
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$fonte = Split-Path -Parent $MyInvocation.MyCommand.Path
$root  = Split-Path -Parent $fonte
$MAX   = 1800
$QUALIDADE_WEBP = 0.80
$LARGURAS = @(480, 800, 1200, 1800)
$pastas = 'hero', 'pratica', 'equipe', 'formaturas', 'cursos'

$edge = @("${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe", "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe", "$env:ProgramFiles\Google\Chrome\Application\chrome.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $edge) { throw 'Não encontrei o Microsoft Edge (ou Chrome) para gerar os WebP.' }

$jpeg = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$par = New-Object System.Drawing.Imaging.EncoderParameters(1)
$par.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]86)

function Reduzir($arquivo) {
  $img = [System.Drawing.Image]::FromFile($arquivo)
  $w = $img.Width; $h = $img.Height
  # só reduz fotos grandes nas DUAS dimensões (ex.: 3024x3024); as demais mantêm o tamanho
  if ([Math]::Min($w, $h) -le $MAX) { $img.Dispose(); return }
  # guarda o original antes de reduzir
  $rel = $arquivo.Substring("$root\assets\images\".Length)
  $dest = "$fonte\originais\$rel"
  New-Item -ItemType Directory -Force (Split-Path -Parent $dest) | Out-Null
  if (-not (Test-Path $dest)) { Copy-Item $arquivo $dest }
  $esc = $MAX / [Math]::Max($w, $h)
  $nw = [int][Math]::Round($w * $esc); $nh = [int][Math]::Round($h * $esc)
  $bmp = New-Object System.Drawing.Bitmap($nw, $nh)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = 'HighQualityBicubic'; $g.SmoothingMode = 'HighQuality'; $g.PixelOffsetMode = 'HighQuality'
  $g.DrawImage($img, 0, 0, $nw, $nh); $g.Dispose(); $img.Dispose()
  $tmp = $arquivo + '.tmp'
  $bmp.Save($tmp, $jpeg, $par); $bmp.Dispose()
  Move-Item $tmp $arquivo -Force
  "  reduzida: ${w}x${h} -> ${nw}x${nh}"
}

function GerarWebp($arquivo) {
  $img = [System.Drawing.Image]::FromFile($arquivo); $ow = $img.Width; $img.Dispose()
  $base = [IO.Path]::Combine((Split-Path -Parent $arquivo), [IO.Path]::GetFileNameWithoutExtension($arquivo))
  $alvos = @(); foreach ($l in $LARGURAS) { if ($l -lt $ow) { $alvos += $l } }; $alvos += $ow
  $faltam = @($alvos | Where-Object { -not (Test-Path "$base-$_.webp") -or ((Get-Item "$base-$_.webp").LastWriteTime -lt (Get-Item $arquivo).LastWriteTime) })
  if (-not $faltam.Count) { "  webp em dia"; return }
  $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($arquivo))
  $ws = ($faltam -join ',')
  $pagina = '<!DOCTYPE html><html><body><pre id="o"></pre><script>' +
    'var img=new Image();img.onload=function(){var out={};[' + $ws + '].forEach(function(w){var h=Math.round(img.naturalHeight*w/img.naturalWidth);var c=document.createElement("canvas");c.width=w;c.height=h;var x=c.getContext("2d");x.imageSmoothingEnabled=true;x.imageSmoothingQuality="high";x.drawImage(img,0,0,w,h);var u=c.toDataURL("image/webp",' + $QUALIDADE_WEBP + ');out[w]=(u.indexOf("data:image/webp")===0)?u.split(",")[1]:"ERRO";});document.getElementById("o").textContent=JSON.stringify(out);};' +
    'img.src="data:image/jpeg;base64,' + $b64 + '";</script></body></html>'
  $tmpHtml = Join-Path $env:TEMP ('drbach-webp-' + [Guid]::NewGuid().ToString('N') + '.html')
  [IO.File]::WriteAllText($tmpHtml, $pagina, (New-Object Text.UTF8Encoding($false)))
  try {
    $ErrorActionPreference = 'Continue'
    $dom = & $edge --headless=new --disable-gpu --virtual-time-budget=30000 --dump-dom ([System.Uri]$tmpHtml).AbsoluteUri 2>$null | Out-String
    $ErrorActionPreference = 'Stop'
  } finally { Remove-Item $tmpHtml -Force -ErrorAction SilentlyContinue }
  $m = [regex]::Match($dom, '<pre id="o">(.*?)</pre>', 'Singleline')
  if (-not $m.Success -or -not $m.Groups[1].Value.Trim()) { throw "Falha ao converter $arquivo" }
  $json = [System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value) | ConvertFrom-Json
  foreach ($w in $faltam) {
    $dados = $json."$w"
    if (-not $dados -or $dados -eq 'ERRO') { throw "O navegador não gerou WebP de $w px para $arquivo" }
    [IO.File]::WriteAllBytes("$base-$w.webp", [Convert]::FromBase64String($dados))
    '  {0}-{1}.webp  {2} KB' -f [IO.Path]::GetFileName($base), $w, [int]((Get-Item "$base-$w.webp").Length / 1KB)
  }
}

foreach ($p in $pastas) {
  $dir = "$root\assets\images\$p"
  if (-not (Test-Path $dir)) { continue }
  foreach ($f in Get-ChildItem $dir -Filter *.jpg -File) {
    "$p\$($f.Name)"
    Reduzir $f.FullName
    GerarWebp $f.FullName
  }
}
'Concluído.'
