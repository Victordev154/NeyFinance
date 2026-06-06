/* ─────────────────────────────
   STATE
───────────────────────────── */
let transacoes = [];
let tipoAtual = 'receita';

let chartRD = null;
let chartCat = null;

/* ─────────────────────────────
   UTILS
───────────────────────────── */
function fmt(v) {
  return (
    'R$ ' +
    v
      .toFixed(2)
      .replace('.', ',')
      .replace(/\B(?=(\d{3})+(?!\d))/g, '.')
  );
}

function fmtData(d) {
  return new Date(d + 'T00:00:00').toLocaleDateString('pt-BR');
}

/* ─────────────────────────────
   NAVEGAÇÃO
───────────────────────────── */
function showPage(id, el) {

  document.querySelectorAll('.page').forEach((p) => {
    p.classList.remove('active');
  });

  document.querySelectorAll('.nav-item').forEach((n) => {
    n.classList.remove('active');
  });

  document
    .getElementById('page-' + id)
    .classList.add('active');

  if (el) {
    el.classList.add('active');
  }

  if (id === 'relatorios') {
    setTimeout(renderRelatorios, 50);
  }
}

/* ─────────────────────────────
   TIPO
───────────────────────────── */
function setTipo(t) {

  tipoAtual = t;

  document.getElementById('btn-rec').className =
    'type-btn' +
    (t === 'receita' ? ' active income' : '');

  document.getElementById('btn-dep').className =
    'type-btn' +
    (t === 'despesa' ? ' active expense' : '');
}

/* ─────────────────────────────
   SALVAR
───────────────────────────── */
function salvar() {

  const desc =
    document.getElementById('f-desc').value.trim();

  const valor =
    parseFloat(
      document.getElementById('f-valor').value
    );

  const cat =
    document.getElementById('f-cat').value;

  const data =
    document.getElementById('f-data').value;

  if (
    !desc ||
    !valor ||
    valor <= 0 ||
    !cat ||
    !data
  ) {
    alert(
      'Por favor, preencha todos os campos corretamente.'
    );
    return;
  }

  transacoes.push({
    id: Date.now(),
    tipo: tipoAtual,
    desc,
    valor,
    cat,
    data
  });

  limpar();

  const al =
    document.getElementById('alert-ok');

  al.style.display = 'flex';

  setTimeout(() => {
    al.style.display = 'none';
  }, 2800);

  atualizarDash();
  renderHistorico();
}

/* ─────────────────────────────
   LIMPAR
───────────────────────────── */
function limpar() {

  [
    'f-desc',
    'f-valor',
    'f-cat',
    'f-data'
  ].forEach((id) => {
    document.getElementById(id).value = '';
  });

  document.getElementById('f-data').value =
    new Date().toISOString().slice(0, 10);
}

/* ─────────────────────────────
   DASHBOARD
───────────────────────────── */
function atualizarDash() {

  const rec =
    transacoes.filter(
      (t) => t.tipo === 'receita'
    );

  const dep =
    transacoes.filter(
      (t) => t.tipo === 'despesa'
    );

  const totRec =
    rec.reduce((s, t) => s + t.valor, 0);

  const totDep =
    dep.reduce((s, t) => s + t.valor, 0);

  const saldo = totRec - totDep;

  const elSaldo =
    document.getElementById('m-saldo');

  elSaldo.textContent = fmt(saldo);

  elSaldo.className =
    'metric-value' +
    (
      saldo > 0
        ? ' positive'
        : saldo < 0
        ? ' negative'
        : ''
    );

  document.getElementById('m-receitas')
    .textContent = fmt(totRec);

  document.getElementById('m-despesas')
    .textContent = fmt(totDep);

  document.getElementById('m-nrec')
    .textContent =
    rec.length + ' lançamento(s)';

  document.getElementById('m-ndep')
    .textContent =
    dep.length + ' lançamento(s)';

  const trend =
    document.getElementById('m-trend');

  if (saldo > 0) {

    trend.textContent =
      '▲ Saldo positivo';

    trend.style.color =
      'var(--green-light)';

  } else if (saldo < 0) {

    trend.textContent =
      '▼ Saldo negativo';

    trend.style.color =
      'var(--red-light)';

  } else {

    trend.textContent =
      '— Sem movimentações';

    trend.style.color = '';
  }

  const lista =
    [...transacoes]
      .sort((a, b) => b.id - a.id)
      .slice(0, 6);

  const el =
    document.getElementById('dash-list');

  if (!lista.length) {

    el.innerHTML = `
      <div class="empty-state">
        <i class="fa-regular fa-folder-open"></i>
        Nenhuma transação registrada ainda.
      </div>
    `;

    return;
  }

  el.innerHTML =
    lista.map(txHTML).join('');
}

/* ─────────────────────────────
   TRANSAÇÃO HTML
───────────────────────────── */
function txHTML(t) {

  const isInc =
    t.tipo === 'receita';

  return `
    <div class="tx-item">

      <div class="tx-dot ${t.tipo}">
        <i class="fa-solid ${isInc ? 'fa-plus' : 'fa-minus'}"></i>
      </div>

      <div class="tx-info">

        <div class="tx-name">
          ${t.desc}
        </div>

        <div class="tx-meta">
          ${t.cat} · ${fmtData(t.data)}

          <span class="badge ${t.tipo}">
            ${isInc ? 'Receita' : 'Despesa'}
          </span>
        </div>

      </div>

      <div class="tx-amount ${t.tipo}">
        ${isInc ? '+' : '-'}${fmt(t.valor)}
      </div>

    </div>
  `;
}

/* ─────────────────────────────
   HISTÓRICO
───────────────────────────── */
function renderHistorico() {

  const tipo =
    document.getElementById('ft-tipo').value;

  const cat =
    document.getElementById('ft-cat').value;

  let lista =
    [...transacoes]
      .sort((a, b) => b.id - a.id);

  if (tipo) {
    lista =
      lista.filter((t) => t.tipo === tipo);
  }

  if (cat) {
    lista =
      lista.filter((t) => t.cat === cat);
  }

  const el =
    document.getElementById('hist-list');

  if (!lista.length) {

    el.innerHTML = `
      <div class="empty-state">
        <i class="fa-regular fa-folder-open"></i>
        Nenhuma transação encontrada.
      </div>
    `;

    return;
  }

  el.innerHTML =
    lista.map(txHTML).join('');
}

/* ─────────────────────────────
   RELATÓRIOS
───────────────────────────── */
const COLORS = [
  '#3fb950',
  '#58a6ff',
  '#f85149',
  '#d29922',
  '#a371f7',
  '#e06c75',
  '#56d364',
  '#79c0ff',
  '#ffa657',
  '#ff7b72'
];

function renderRelatorios() {

  const totRec =
    transacoes
      .filter((t) => t.tipo === 'receita')
      .reduce((s, t) => s + t.valor, 0);

  const totDep =
    transacoes
      .filter((t) => t.tipo === 'despesa')
      .reduce((s, t) => s + t.valor, 0);

  /* RECEITAS X DESPESAS */

  if (chartRD) {
    chartRD.destroy();
  }

  chartRD = new Chart(
    document.getElementById('chartRD'),
    {
      type: 'bar',

      data: {
        labels: ['Receitas', 'Despesas'],

        datasets: [{
          data: [totRec, totDep],

          backgroundColor: [
            'rgba(63,185,80,0.7)',
            'rgba(248,81,73,0.7)'
          ],

          borderColor: [
            '#3fb950',
            '#f85149'
          ],

          borderWidth: 1,
          borderRadius: 6,
          borderSkipped: false
        }]
      },

      options: {
        responsive: true,
        maintainAspectRatio: false,

        plugins: {
          legend: {
            display: false
          }
        },

        scales: {

          x: {
            grid: {
              color: 'rgba(255,255,255,0.05)'
            },

            ticks: {
              color: '#8b949e'
            }
          },

          y: {
            grid: {
              color: 'rgba(255,255,255,0.05)'
            },

            ticks: {
              color: '#8b949e',

              callback: (v) =>
                'R$' + Math.round(v)
            }
          }

        }
      }
    }
  );

  /* CATEGORIAS */

  const cats = {};

  transacoes
    .filter((t) => t.tipo === 'despesa')
    .forEach((t) => {

      cats[t.cat] =
        (cats[t.cat] || 0) + t.valor;
    });

  const keys = Object.keys(cats);

  const vals =
    keys.map((k) => cats[k]);

  if (chartCat) {
    chartCat.destroy();
  }

  if (keys.length) {

    chartCat = new Chart(
      document.getElementById('chartCat'),
      {

        type: 'doughnut',

        data: {
          labels: keys,

          datasets: [{
            data: vals,
            backgroundColor:
              COLORS.slice(0, keys.length),

            borderWidth: 0
          }]
        },

        options: {
          responsive: true,
          maintainAspectRatio: false,

          plugins: {

            legend: {

              position: 'bottom',

              labels: {
                color: '#8b949e',

                font: {
                  size: 11
                },

                boxWidth: 10,
                padding: 10
              }
            }

          }
        }
      }
    );
  }

  /* RANKING */

  const barEl =
    document.getElementById('bar-rank');

  if (!keys.length) {

    barEl.innerHTML = `
      <div class="empty-state">
        <i class="fa-solid fa-chart-simple"></i>
        Nenhuma despesa registrada.
      </div>
    `;

    return;
  }

  const max = Math.max(...vals);

  const sorted =
    keys
      .map((k, i) => ({
        k,
        v: vals[i],
        c: COLORS[i % COLORS.length]
      }))
      .sort((a, b) => b.v - a.v);

  barEl.innerHTML =
    sorted.map((item) => `
      <div class="bar-row">

        <div
          class="bar-label"
          title="${item.k}"
        >
          ${item.k}
        </div>

        <div class="bar-track">
          <div
            class="bar-fill"
            style="
              width:${Math.round(item.v / max * 100)}%;
              background:${item.c}
            "
          ></div>
        </div>

        <div class="bar-val">
          ${fmt(item.v)}
        </div>

      </div>
    `).join('');
}

/* ─────────────────────────────
   INIT
───────────────────────────── */
document.getElementById('f-data').value =
  new Date().toISOString().slice(0, 10);