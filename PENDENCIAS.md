# Pendências do site (o que falta o instituto enviar ou confirmar)

Tudo que está abaixo **não aparece no site publicado**: campos vazios ficam ocultos.
Quando você enviar cada item, ele entra no lugar certo.

## Dados da instituição
- [ ] Cidade/UF (o texto original cita Dourados – MS; os posts também marcam Maringá – PR)
- [ ] Endereço completo (alimenta o card "Endereço", o mapa do Google, o rodapé e os dados estruturados)
- [ ] CNPJ
- [x] E-mail de contato: drbach.instituto@gmail.com (informado pelo instituto em 20/09/2026; já está no rodapé, no card de contato, nos dados estruturados e na Política de Privacidade)
- [ ] Confirmar se esse mesmo e-mail serve como canal do encarregado de dados (LGPD) na Política de Privacidade, ou se há outro
- [ ] Horário de atendimento
- [ ] Domínio final do site (usado em sitemap.xml, robots.txt, Open Graph e dados estruturados; hoje aparece `SEU-DOMINIO-AQUI`)

## MEC e credibilidade
- [ ] Texto oficial do ato do MEC (a bio do Instagram cita "P MEC 1.135/2024", provavelmente Portaria MEC nº 1.135/2024). Enquanto não confirmado, o número **não** aparece no site
- [ ] Confirmar em quais cursos vale "Reconhecido pelo MEC". Hoje o selo aparece em: TSB, 2ª Licenciatura em Pedagogia, em Música, em Educação Especial e Tecnólogo em Gestão Pública. **Não** aparece em ASB e AEE
- [ ] Confirmação da parceria com a FACOP: nome completo e natureza da parceria (e se o AEE é mesmo divulgado com ela)
- [ ] Link da fonte dos dados de mercado (406,2 mil dentistas: Ministério da Saúde, via O Globo; +230 mil consultórios)

## Cursos
- [ ] Valores e parcelas confirmados: TSB (hoje "entrada de R$ 600,00 + parcelas"), ASB, Educação Especial, Gestão Pública, AEE. Confirmar também Pedagogia e Música (R$ 600,00 + 11x de R$ 400,00)
- [ ] Duração do TSB, ASB, Educação Especial, Gestão Pública e AEE (só Pedagogia e Música têm "12 meses")
- [ ] Ementas, carga horária e a lista "O que você vai aprender" de cada curso
- [ ] Público-alvo de cada curso
- [ ] Onde acontecem as aulas práticas presenciais (local e datas)
- [ ] Comparativo ASB × TSB: linhas de Duração, O que faz, Investimento e Certificado MEC do ASB, mais o texto "qual escolher"
- [ ] Confirmar "Turma 2026 · Inscrições abertas" e "início imediato" (informado para Pedagogia e Música)
- [ ] Confirmar "pacientes reais desde o primeiro dia" no card de diferenciais
- [x] As páginas "Segunda Graduação" e "Cursos EAD" foram removidas (agora são as 2ª licenciaturas e a modalidade em cada curso). Confirmado pelo instituto em 20/09/2026
- [ ] Capacitação, Extensão, Pós-graduação e Cursos técnicos: hoje só há um cartão de contato pelo WhatsApp em "Também oferecemos"

## Conteúdo e imagens
- [ ] Logo em vetor (SVG). Hoje usamos PNG recortado da imagem enviada
- [ ] Fotos originais em alta resolução, **sem texto nem logos sobrepostos**: aulas práticas, estrutura da clínica, equipe, entregas de certificado (lista completa e tamanhos em ASSETS.md). As 8 fotos tiradas do Instagram são provisórias
- [ ] **Foto do hero da Início** (`hero/pratica-consultorio.jpg`): pedido do usuário em 22/09/2026, é uma foto de banco de imagens (Pexels, licença gratuita, atribuição não obrigatória — pexels.com/photo/19976604, fotógrafo Arda Kaykısız), **não é uma foto do Instituto**. Trocar pela foto real do Instituto assim que houver uma boa (a página Sobre já usa a foto real da turma)
- [ ] **Autorização de uso de imagem (LGPD)** de todos os alunos, professores e pacientes que aparecem nas fotos atuais e nas futuras
- [ ] **Permissão para exibir a marca FACOP**: ela aparece na arte `pratica/aula-pratica-colagem.jpg` (Início, seção Prática real, e página do ASB). Se não houver permissão, a foto sai
- [ ] **Nome do professor** da foto `equipe/professor-jaleco.jpg`. Hoje o card se chama "Professor da equipe", sem cargo e sem legenda com nome
- [ ] Ao fundo das fotos de formatura e do "Professor da equipe" aparece a placa de outra empresa ("Instituto Santana"). Confirmar se pode aparecer ou trocar as fotos
- [ ] Profª Drª Raquel Pereverzieff aparece só na página do TSB, junto da matéria Biossegurança e Técnicas Radiológicas. Confirmar se ela também ministra no ASB ou em outros cursos (é só me avisar)
- [ ] Texto alternativo da foto de prática com paciente: a arte mostra um professor atendendo (o jaleco parece identificar o Prof. Dr. Evandro). Deixei um texto neutro ("Prática clínica com paciente real no Instituto Dr. Bach") em vez de "aluno". Confirmar quem aparece
- [ ] Mini-bios e fotos dos professores; mais professores, se houver
- [ ] História e missão do instituto (página Sobre)
- [ ] 3 depoimentos reais **com autorização**. Enquanto não houver, a seção não existe
- [ ] Autorização de uso de imagem dos alunos (LGPD) para as fotos de formatura e de aulas
- [ ] ID de um vídeo do YouTube (opcional): sem ele o bloco de vídeo fica oculto

## Textos provisórios para revisar
- [ ] Respostas do FAQ (marcadas como provisórias no código)
- [ ] Política de Privacidade: **revisar com o jurídico** antes de publicar

## Rastreio (opcional, desligado)
- [ ] ID do GA4 e do Meta Pixel, se quiserem medir. Ao ativar, aparece o aviso de cookies

## Verificação técnica
- [ ] Rodar o Lighthouse com nota real (não foi possível neste ambiente, sem Node instalado)
