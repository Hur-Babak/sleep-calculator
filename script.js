const CYCLE_MINUTES = 90;
const FALL_ASLEEP_MINUTES = 15;
const CYCLES = [6, 5, 4, 3];

const wakeupBlock = document.getElementById('wakeup-block');
const sleepnowBlock = document.getElementById('sleepnow-block');
const modeBtns = document.querySelectorAll('.mode-btn');
const wakeInput = document.getElementById('wake-time');
const calcWakeupBtn = document.getElementById('calc-wakeup');
const calcSleepnowBtn = document.getElementById('calc-sleepnow');
const results = document.getElementById('results');
const resultsTitle = document.getElementById('results-title');
const resultsSub = document.getElementById('results-sub');
const timesGrid = document.getElementById('times-grid');

document.getElementById('year').textContent = new Date().getFullYear();

modeBtns.forEach(btn => {
  btn.addEventListener('click', () => {
    modeBtns.forEach(b => {
      b.classList.remove('active');
      b.setAttribute('aria-selected', 'false');
    });
    btn.classList.add('active');
    btn.setAttribute('aria-selected', 'true');

    const mode = btn.dataset.mode;
    wakeupBlock.classList.toggle('hidden', mode !== 'wakeup');
    sleepnowBlock.classList.toggle('hidden', mode !== 'sleepnow');
    results.classList.add('hidden');
  });
});

function formatTime(date) {
  const h = date.getHours().toString().padStart(2, '0');
  const m = date.getMinutes().toString().padStart(2, '0');
  return `${h}:${m}`;
}

function qualityLabel(cycles) {
  if (cycles >= 5) return { text: 'Recommended', cls: 'good' };
  if (cycles === 4) return { text: 'Workable', cls: 'ok' };
  return { text: 'Short', cls: 'short' };
}

function renderTimes(times, recommendedIndex) {
  timesGrid.innerHTML = '';
  times.forEach((t, i) => {
    const card = document.createElement('div');
    card.className = 'time-card' + (i === recommendedIndex ? ' recommended' : '');
    const label = qualityLabel(t.cycles);
    card.innerHTML = `
      <div class="time">${t.time}</div>
      <div class="cycles">${t.cycles} cycles · ${(t.cycles * 1.5).toFixed(1)}h sleep</div>
      <div class="label ${label.cls}">${label.text}</div>
    `;
    timesGrid.appendChild(card);
  });
}

function calcBedtimes() {
  const value = wakeInput.value;
  if (!value) return;
  const [h, m] = value.split(':').map(Number);
  const wake = new Date();
  wake.setHours(h, m, 0, 0);

  const times = CYCLES.map(cycles => {
    const bedTime = new Date(wake.getTime() - (cycles * CYCLE_MINUTES + FALL_ASLEEP_MINUTES) * 60000);
    return { time: formatTime(bedTime), cycles };
  });

  resultsTitle.textContent = `To wake up at ${value}, go to bed at:`;
  resultsSub.textContent = 'The earliest times give you the most sleep. Pick the one that fits your schedule.';
  renderTimes(times, 1);
  results.classList.remove('hidden');
  results.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
}

function calcWakeTimes() {
  const now = new Date();
  const sleepStart = new Date(now.getTime() + FALL_ASLEEP_MINUTES * 60000);

  const times = [...CYCLES].reverse().map(cycles => {
    const wakeTime = new Date(sleepStart.getTime() + cycles * CYCLE_MINUTES * 60000);
    return { time: formatTime(wakeTime), cycles };
  });

  resultsTitle.textContent = `If you fall asleep now, wake up at:`;
  resultsSub.textContent = `Assuming you fall asleep around ${formatTime(sleepStart)}. Later times give you more rest.`;
  renderTimes(times, times.length - 2);
  results.classList.remove('hidden');
  results.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
}

calcWakeupBtn.addEventListener('click', calcBedtimes);
calcSleepnowBtn.addEventListener('click', calcWakeTimes);
wakeInput.addEventListener('change', calcBedtimes);

calcBedtimes();
