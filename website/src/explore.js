/**
 * LEXILENS STUDIO & EXPLORE SCRIPT
 * Manages document reading surface, TTS, simplification, and universal settings persistence.
 */

// Sample Documents
const SAMPLES = {
  biology: {
    raw: `Photosynthesis represents the biological synthesis through which phototrophic autotrophs convert solar electromagnetic radiation into stored chemical potential energy via chloroplast thylakoid membranes, subsequently releasing oxygen as a byproduct.`,
    simplified: `Plants use sunlight to make food. In their leaves, green cells absorb solar light and turn it into energy. During this natural process, the plants release fresh oxygen into the air.`
  },
  history: {
    raw: `The socioeconomic ramifications of the Industrial Revolution precipitated unprecedented urbanization metrics across Western European manufacturing corridors, simultaneously necessitating extensive legislative intervention regarding juvenile labor exploitation.`,
    simplified: `The Industrial Revolution caused thousands of families to move from farms into growing factory cities. This massive change forced governments to create new protective laws for workers and young children.`
  },
  contract: {
    raw: `The tenant hereby covenants to indemnify and hold innocuous the landlord against liabilities, losses, damages, or expenditures arising from unauthorized structural modifications or non-conforming tenant alterations.`,
    simplified: `The tenant agrees not to make structural changes without permission. If accidental damage occurs from unapproved changes, the tenant is responsible for repair costs.`
  }
};

// Universal Settings Keys
const SETTINGS_KEY = 'lexilens_reading_settings';

const DEFAULT_SETTINGS = {
  font: 'lexend',
  fontSize: 20,
  lineHeight: 1.8,
  letterSpacing: 0.05,
  overlay: 'cream',
  reduceMotion: false
};

// State
let currentSettings = { ...DEFAULT_SETTINGS };
let currentText = SAMPLES.biology.simplified;
let isSimplified = true;
let isPlaying = false;
let currentUtterance = null;
let currentWordIndex = -1;
let wordSpans = [];

function loadSettings() {
  try {
    const saved = localStorage.getItem(SETTINGS_KEY);
    if (saved) {
      currentSettings = { ...DEFAULT_SETTINGS, ...JSON.parse(saved) };
    }
  } catch (e) {
    console.error('Failed to load settings', e);
  }
  applySettings();
}

function saveSettings() {
  try {
    localStorage.setItem(SETTINGS_KEY, JSON.stringify(currentSettings));
  } catch (e) {
    console.error('Failed to save settings', e);
  }
}

function applySettings() {
  const root = document.documentElement;
  const viewport = document.getElementById('reading-viewport');
  const fontDisplay = document.getElementById('reading-font-display');

  // Font family mapping
  let fontCSS = "'Lexend', sans-serif";
  let fontName = 'Lexend';
  if (currentSettings.font === 'opendyslexic') {
    fontCSS = "'Lexend', cursive, sans-serif"; // Using weighted baseline style
    fontName = 'OpenDyslexic (Weighted Baseline)';
  } else if (currentSettings.font === 'atkinson') {
    fontCSS = "'Atkinson Hyperlegible', sans-serif";
    fontName = 'Atkinson Hyperlegible';
  }

  root.style.setProperty('--reading-font', fontCSS);
  root.style.setProperty('--reading-size', `${currentSettings.fontSize}px`);
  root.style.setProperty('--reading-line-height', currentSettings.lineHeight);
  root.style.setProperty('--reading-letter-spacing', `${currentSettings.letterSpacing}em`);

  if (fontDisplay) fontDisplay.textContent = `Font: ${fontName}`;

  // Color Overlay
  const tints = {
    none: 'transparent',
    cream: '#FFF6D9',
    blue: '#E4F0F6',
    rose: '#FBE7E4',
    sage: '#EAF2E8'
  };

  const overlayColor = tints[currentSettings.overlay] || 'transparent';
  root.style.setProperty('--reading-bg-overlay', overlayColor);

  if (viewport) {
    viewport.setAttribute('data-tint', currentSettings.overlay);
  }

  // Update Drawer UI Controls
  document.querySelectorAll('.pill-btn').forEach(btn => {
    btn.classList.toggle('active', btn.getAttribute('data-font') === currentSettings.font);
  });

  const fontSlider = document.getElementById('font-size-slider');
  const fontVal = document.getElementById('font-size-val');
  if (fontSlider) fontSlider.value = currentSettings.fontSize;
  if (fontVal) fontVal.textContent = `${currentSettings.fontSize}px`;

  const lhSlider = document.getElementById('line-height-slider');
  const lhVal = document.getElementById('line-height-val');
  if (lhSlider) lhSlider.value = currentSettings.lineHeight;
  if (lhVal) lhVal.textContent = currentSettings.lineHeight;

  const lsSlider = document.getElementById('letter-spacing-slider');
  const lsVal = document.getElementById('letter-spacing-val');
  if (lsSlider) lsSlider.value = currentSettings.letterSpacing;
  if (lsVal) lsVal.textContent = `${currentSettings.letterSpacing}em`;

  document.querySelectorAll('.swatch-btn').forEach(btn => {
    btn.classList.toggle('active', btn.getAttribute('data-overlay') === currentSettings.overlay);
  });

  const reduceMotion = document.getElementById('reduce-motion-toggle');
  if (reduceMotion) reduceMotion.checked = currentSettings.reduceMotion;
}

// Render Reading Surface Text with Word Wrappers for Synchronized Audio
function renderReadingText(text) {
  const container = document.getElementById('reading-text-container');
  const wordCountElem = document.getElementById('reading-word-count');
  if (!container) return;

  const words = text.split(/\s+/).filter(w => w.length > 0);
  if (wordCountElem) wordCountElem.textContent = `Word Count: ${words.length}`;

  container.innerHTML = words.map((w, idx) => `
    <span class="reading-word" id="word-${idx}">${w}</span> 
  `).join('');

  wordSpans = container.querySelectorAll('.reading-word');
}

// Speech Synthesis
function stopAudio() {
  if (window.speechSynthesis) {
    window.speechSynthesis.cancel();
  }
  isPlaying = false;
  currentWordIndex = -1;
  wordSpans.forEach(span => span.classList.remove('active-word'));

  const playIcon = document.getElementById('icon-play');
  const pauseIcon = document.getElementById('icon-pause');
  const audioLabel = document.getElementById('audio-label');
  if (playIcon) playIcon.style.display = 'inline';
  if (pauseIcon) pauseIcon.style.display = 'none';
  if (audioLabel) audioLabel.textContent = 'Listen';
}

function playAudio() {
  if (!('speechSynthesis' in window)) {
    alert('Speech synthesis is not supported on this browser.');
    return;
  }

  stopAudio();

  const textToRead = currentText;
  currentUtterance = new SpeechSynthesisUtterance(textToRead);

  const speedSelect = document.getElementById('audio-speed');
  if (speedSelect) {
    currentUtterance.rate = parseFloat(speedSelect.value) || 1.0;
  }

  currentUtterance.onboundary = (event) => {
    if (event.name === 'word') {
      const charIndex = event.charIndex;
      // Find matching word
      const textSub = textToRead.substring(0, charIndex);
      const wordIdx = textSub.split(/\s+/).filter(Boolean).length;

      wordSpans.forEach(span => span.classList.remove('active-word'));
      const activeSpan = document.getElementById(`word-${wordIdx}`);
      if (activeSpan) {
        activeSpan.classList.add('active-word');
        activeSpan.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      }
    }
  };

  currentUtterance.onend = () => {
    stopAudio();
  };

  currentUtterance.onerror = () => {
    stopAudio();
  };

  window.speechSynthesis.speak(currentUtterance);
  isPlaying = true;

  const playIcon = document.getElementById('icon-play');
  const pauseIcon = document.getElementById('icon-pause');
  const audioLabel = document.getElementById('audio-label');
  if (playIcon) playIcon.style.display = 'none';
  if (pauseIcon) pauseIcon.style.display = 'inline';
  if (audioLabel) audioLabel.textContent = 'Pause';
}

function toggleAudio() {
  if (isPlaying) {
    stopAudio();
  } else {
    playAudio();
  }
}

// Init Event Listeners
document.addEventListener('DOMContentLoaded', () => {
  loadSettings();
  renderReadingText(currentText);

  // Settings Drawer Toggle
  const openDrawerBtn = document.getElementById('open-settings-btn');
  const closeDrawerBtn = document.getElementById('close-drawer-btn');
  const drawer = document.getElementById('reading-drawer');
  const backdrop = document.getElementById('drawer-backdrop');

  function openDrawer() {
    drawer.classList.add('open');
    backdrop.classList.add('open');
  }

  function closeDrawer() {
    drawer.classList.remove('open');
    backdrop.classList.remove('open');
  }

  if (openDrawerBtn) openDrawerBtn.addEventListener('click', openDrawer);
  if (closeDrawerBtn) closeDrawerBtn.addEventListener('click', closeDrawer);
  if (backdrop) backdrop.addEventListener('click', closeDrawer);

  // Drawer Controls
  document.querySelectorAll('.pill-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      currentSettings.font = btn.getAttribute('data-font');
      saveSettings();
      applySettings();
    });
  });

  const fontSlider = document.getElementById('font-size-slider');
  if (fontSlider) {
    fontSlider.addEventListener('input', (e) => {
      currentSettings.fontSize = parseInt(e.target.value);
      saveSettings();
      applySettings();
    });
  }

  const lhSlider = document.getElementById('line-height-slider');
  if (lhSlider) {
    lhSlider.addEventListener('input', (e) => {
      currentSettings.lineHeight = parseFloat(e.target.value);
      saveSettings();
      applySettings();
    });
  }

  const lsSlider = document.getElementById('letter-spacing-slider');
  if (lsSlider) {
    lsSlider.addEventListener('input', (e) => {
      currentSettings.letterSpacing = parseFloat(e.target.value);
      saveSettings();
      applySettings();
    });
  }

  document.querySelectorAll('.swatch-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      currentSettings.overlay = btn.getAttribute('data-overlay');
      saveSettings();
      applySettings();
    });
  });

  const reduceMotion = document.getElementById('reduce-motion-toggle');
  if (reduceMotion) {
    reduceMotion.addEventListener('change', (e) => {
      currentSettings.reduceMotion = e.target.checked;
      saveSettings();
      applySettings();
    });
  }

  // Audio Controls
  const playBtn = document.getElementById('btn-play-pause');
  const stopBtn = document.getElementById('btn-stop-audio');
  if (playBtn) playBtn.addEventListener('click', toggleAudio);
  if (stopBtn) stopBtn.addEventListener('click', stopAudio);

  // Sample Presets
  document.querySelectorAll('.sample-pill-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.sample-pill-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      const key = btn.getAttribute('data-sample');
      const sample = SAMPLES[key];
      if (sample) {
        document.getElementById('raw-text-input').value = sample.raw;
        currentText = sample.simplified;
        renderReadingText(currentText);
        stopAudio();
      }
    });
  });

  // Simplify Button
  const simplifyBtn = document.getElementById('btn-simplify');
  if (simplifyBtn) {
    simplifyBtn.addEventListener('click', () => {
      const raw = document.getElementById('raw-text-input').value.trim();
      if (!raw) return;

      simplifyBtn.disabled = true;
      simplifyBtn.innerHTML = `<span>Simplifying with AI...</span>`;

      setTimeout(() => {
        simplifyBtn.disabled = false;
        simplifyBtn.innerHTML = `
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"/></svg>
          <span>Simplify Text with AI</span>
        `;
        
        // Quick rule-based transformation simulation
        const transformed = raw
          .replace(/represents the biological synthesis through which/gi, 'is how')
          .replace(/convert solar electromagnetic radiation/gi, 'turn sunlight')
          .replace(/precipitated unprecedented/gi, 'caused huge')
          .replace(/hereby covenants to indemnify/gi, 'promises to protect');

        currentText = transformed;
        renderReadingText(currentText);
        stopAudio();
      }, 400);
    });
  }

  // Reset Button
  const resetBtn = document.getElementById('btn-reset');
  if (resetBtn) {
    resetBtn.addEventListener('click', () => {
      const raw = document.getElementById('raw-text-input').value;
      currentText = raw;
      renderReadingText(currentText);
      stopAudio();
    });
  }

  // Dropzone Click
  const dropzone = document.getElementById('upload-zone');
  const fileInput = document.getElementById('file-input');
  if (dropzone && fileInput) {
    dropzone.addEventListener('click', () => fileInput.click());
    fileInput.addEventListener('change', (e) => {
      if (e.target.files && e.target.files[0]) {
        const file = e.target.files[0];
        document.getElementById('raw-text-input').value = `[OCR Extract from ${file.name}]\n` + SAMPLES.biology.raw;
        currentText = SAMPLES.biology.simplified;
        renderReadingText(currentText);
      }
    });
  }
});
