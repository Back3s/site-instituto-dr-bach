(function () {
  'use strict';

  // ---------- configuração (deixe vazio para manter o rastreio desligado) ----------
  var RASTREIO = { ga4: '', pixel: '' };   // ex.: ga4: 'G-XXXXXXXXXX', pixel: '1234567890'
  var ZAP = '5567996793094';

  // Marca que o JS está ativo (as animações de entrada só se aplicam com JS)
  document.documentElement.classList.add('js');

  var reduzMovimento = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  // ---------- menu mobile ----------
  var menuBtn = document.getElementById('menuBtn');
  var nav = document.getElementById('nav');

  function fecharMenu() {
    nav.classList.remove('is-aberto');
    menuBtn.setAttribute('aria-expanded', 'false');
    menuBtn.setAttribute('aria-label', 'Abrir menu');
  }

  if (menuBtn && nav) {
    menuBtn.addEventListener('click', function () {
      var aberto = nav.classList.toggle('is-aberto');
      menuBtn.setAttribute('aria-expanded', String(aberto));
      menuBtn.setAttribute('aria-label', aberto ? 'Fechar menu' : 'Abrir menu');
    });
    nav.addEventListener('click', function (e) {
      if (e.target.closest('a')) fecharMenu();
    });
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') fecharMenu();
    });
  }

  // ---------- filtro de cursos ----------
  var filtros = document.querySelectorAll('.filtro');
  var cursos = document.querySelectorAll('#cursosGrid .curso');

  filtros.forEach(function (btn) {
    btn.addEventListener('click', function () {
      var alvo = btn.getAttribute('data-filtro');

      filtros.forEach(function (b) {
        var ativo = b === btn;
        b.classList.toggle('is-ativo', ativo);
        b.setAttribute('aria-selected', String(ativo));
      });

      cursos.forEach(function (curso) {
        var areas = curso.getAttribute('data-area').split(' ');
        curso.classList.toggle('is-oculto', alvo !== 'todos' && areas.indexOf(alvo) === -1);
      });
    });
  });

  // ---------- máscara de telefone brasileiro ----------
  function mascaraTelefone(valor) {
    var d = valor.replace(/\D/g, '').slice(0, 11);
    if (d.length > 10) return '(' + d.slice(0, 2) + ') ' + d.slice(2, 7) + '-' + d.slice(7);
    if (d.length > 6) return '(' + d.slice(0, 2) + ') ' + d.slice(2, 6) + '-' + d.slice(6);
    if (d.length > 2) return '(' + d.slice(0, 2) + ') ' + d.slice(2);
    if (d.length > 0) return '(' + d;
    return '';
  }

  document.querySelectorAll('input[type="tel"]').forEach(function (campo) {
    campo.addEventListener('input', function () {
      campo.value = mascaraTelefone(campo.value);
    });
  });

  // ---------- rastreio (GA4 e Meta Pixel), só com consentimento ----------
  var CHAVE_COOKIES = 'cookies-drbach';
  var rastreioAtivo = !!(RASTREIO.ga4 || RASTREIO.pixel);
  var consentimento = null;

  function lerConsentimento() {
    try { return window.localStorage.getItem(CHAVE_COOKIES); } catch (e) { return null; }
  }
  function gravarConsentimento(v) {
    try { window.localStorage.setItem(CHAVE_COOKIES, v); } catch (e) { /* segue sem guardar */ }
  }

  function carregarRastreio() {
    if (RASTREIO.ga4) {
      var s = document.createElement('script');
      s.async = true;
      s.src = 'https://www.googletagmanager.com/gtag/js?id=' + encodeURIComponent(RASTREIO.ga4);
      document.head.appendChild(s);
      window.dataLayer = window.dataLayer || [];
      window.gtag = function () { window.dataLayer.push(arguments); };
      window.gtag('js', new Date());
      window.gtag('config', RASTREIO.ga4);
    }
    if (RASTREIO.pixel) {
      /* eslint-disable */
      !function (f, b, e, v, n, t, s) { if (f.fbq) return; n = f.fbq = function () { n.callMethod ? n.callMethod.apply(n, arguments) : n.queue.push(arguments); }; if (!f._fbq) f._fbq = n; n.push = n; n.loaded = !0; n.version = '2.0'; n.queue = []; t = b.createElement(e); t.async = !0; t.src = v; s = b.getElementsByTagName(e)[0]; s.parentNode.insertBefore(t, s); }(window, document, 'script', 'https://connect.facebook.net/en_US/fbevents.js');
      /* eslint-enable */
      window.fbq('init', RASTREIO.pixel);
      window.fbq('track', 'PageView');
    }
  }

  function registrarEvento(nomeGa, nomePixel, dados) {
    if (consentimento !== 'sim') return;
    if (window.gtag) window.gtag('event', nomeGa, dados || {});
    if (window.fbq) window.fbq('track', nomePixel);
  }

  function mostrarBanner() {
    var caixa = document.createElement('div');
    caixa.className = 'cookies';
    caixa.setAttribute('role', 'dialog');
    caixa.setAttribute('aria-label', 'Aviso de cookies');
    caixa.innerHTML =
      '<p>Usamos cookies para medir a audiência e melhorar o site. Saiba mais na <a href="politica-de-privacidade.html">Política de Privacidade</a>.</p>' +
      '<div class="cookies__acoes">' +
      '<button type="button" class="btn btn--contorno" data-cookies="nao" style="border-color:#fff;color:#fff">Recusar</button>' +
      '<button type="button" class="btn btn--magenta" data-cookies="sim">Aceitar</button>' +
      '</div>';
    caixa.addEventListener('click', function (e) {
      var b = e.target.closest('[data-cookies]');
      if (!b) return;
      consentimento = b.getAttribute('data-cookies');
      gravarConsentimento(consentimento);
      if (consentimento === 'sim') carregarRastreio();
      caixa.remove();
    });
    document.body.appendChild(caixa);
  }

  if (rastreioAtivo) {
    consentimento = lerConsentimento();
    if (consentimento === 'sim') carregarRastreio();
    else if (consentimento !== 'nao') mostrarBanner();
  }

  // clique em qualquer botão de WhatsApp vira evento
  document.addEventListener('click', function (e) {
    var a = e.target.closest && e.target.closest('a[href^="https://wa.me/"]');
    if (a) registrarEvento('click_whatsapp', 'Contact', { link_url: a.href });
  });

  // ---------- página de cadastro (envia os dados para o WhatsApp) ----------
  var form = document.getElementById('formInscricao');

  if (form) {
    var selCurso = form.elements.curso;
    var confirmacao = document.getElementById('confirmacao');
    var confirmacaoLink = document.getElementById('confirmacaoLink');

    // o curso pode vir escolhido pela URL (inscricao.html?curso=tsb)
    var pedido = new URLSearchParams(window.location.search).get('curso');
    Array.prototype.forEach.call(selCurso.options, function (op) {
      if (pedido && op.value === pedido) selCurso.value = pedido;
    });

    var montarMensagem = function () {
      var v = function (nome) { return form.elements[nome].value.trim(); };
      var curso = selCurso.options[selCurso.selectedIndex].text;
      var linhas = ['Olá! Vim pelo site do Instituto Dr. Bach e quero me matricular no curso: ' + curso + '.', ''];
      linhas.push('Nome: ' + v('nome'));
      linhas.push('WhatsApp: ' + v('whatsapp'));
      if (v('email')) linhas.push('E-mail: ' + v('email'));
      linhas.push('Cidade: ' + v('cidade'));
      if (v('obs')) linhas.push('Observação: ' + v('obs'));
      return linhas.join('\n');
    };

    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var url = 'https://wa.me/' + ZAP + '?text=' + encodeURIComponent(montarMensagem());

      // link clicado por script: abre em nova aba sem depender do retorno de window.open
      var a = document.createElement('a');
      a.href = url; a.target = '_blank'; a.rel = 'noopener';
      document.body.appendChild(a); a.click(); document.body.removeChild(a);

      registrarEvento('generate_lead', 'Lead', { curso: selCurso.value });
      confirmacaoLink.href = url;
      confirmacao.hidden = false;
      confirmacao.focus();
    });
  }

  // ---------- vídeo (só carrega o player quando a pessoa clica) ----------
  document.querySelectorAll('[data-video]').forEach(function (caixa) {
    var botao = caixa.querySelector('button');
    if (!botao) return;
    botao.addEventListener('click', function () {
      var frame = document.createElement('iframe');
      frame.src = 'https://www.youtube-nocookie.com/embed/' + encodeURIComponent(caixa.getAttribute('data-video')) + '?autoplay=1&rel=0';
      frame.title = caixa.getAttribute('data-titulo') || 'Vídeo';
      frame.allow = 'autoplay; encrypted-media; picture-in-picture';
      frame.allowFullscreen = true;
      caixa.replaceChild(frame, botao);
    });
  });

  // ---------- números animados (mercado) ----------
  function formatar(n, casas) {
    return n.toLocaleString('pt-BR', { minimumFractionDigits: casas, maximumFractionDigits: casas });
  }

  function animarNumero(el) {
    var alvo = parseFloat(el.getAttribute('data-valor'));
    var casas = parseInt(el.getAttribute('data-casas') || '0', 10);
    var pre = el.getAttribute('data-prefixo') || '';
    var suf = el.getAttribute('data-sufixo') || '';
    if (isNaN(alvo)) return;
    if (reduzMovimento) { el.textContent = pre + formatar(alvo, casas) + suf; return; }
    var inicio = null;
    var duracao = 1600;
    function passo(agora) {
      if (inicio === null) inicio = agora;
      var t = Math.min((agora - inicio) / duracao, 1);
      var suave = 1 - Math.pow(1 - t, 3);
      el.textContent = pre + formatar(alvo * suave, casas) + suf;
      if (t < 1) window.requestAnimationFrame(passo);
    }
    window.requestAnimationFrame(passo);
  }

  var numeros = document.querySelectorAll('[data-valor]');
  if ('IntersectionObserver' in window && numeros.length) {
    var obsNum = new IntersectionObserver(function (entradas) {
      entradas.forEach(function (entrada) {
        if (entrada.isIntersecting) {
          animarNumero(entrada.target);
          obsNum.unobserve(entrada.target);
        }
      });
    }, { threshold: 0.4 });
    numeros.forEach(function (el) { obsNum.observe(el); });
  }

  // ---------- animação de entrada ao rolar ----------
  var itens = document.querySelectorAll('.reveal');

  if ('IntersectionObserver' in window) {
    var obs = new IntersectionObserver(function (entradas) {
      entradas.forEach(function (entrada) {
        if (entrada.isIntersecting) {
          entrada.target.classList.add('is-visivel');
          obs.unobserve(entrada.target);
        }
      });
    }, { threshold: 0.12 });

    itens.forEach(function (el, i) {
      el.style.transitionDelay = (i % 4) * 70 + 'ms';
      obs.observe(el);
    });
  } else {
    itens.forEach(function (el) { el.classList.add('is-visivel'); });
  }

  // ---------- ano do rodapé ----------
  var ano = document.getElementById('ano');
  if (ano) ano.textContent = new Date().getFullYear();
})();
