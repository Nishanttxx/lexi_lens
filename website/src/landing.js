/**
 * LEXILENS — LANDING PAGE INTERACTION SCRIPT
 * Manages Lenis smooth scroll, WebGL shaders, magnetic buttons, parallax tilt,
 * roadmap SVG draw on scroll, live demo, and smooth page transition to /explore.html.
 */

import Lenis from 'lenis';
import { initLensShader } from './shader.js';
import { CONTENT } from './content.js';

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

let currentSettings = { ...DEFAULT_SETTINGS };
let lenisInstance = null;
let heroShaderInstance = null;
let ctaShaderInstance = null;

// Universal Settings Loader & Applier
function initSettings() {
  try {
    const saved = localStorage.getItem(SETTINGS_KEY);
    if (saved) {
      currentSettings = { ...DEFAULT_SETTINGS, ...JSON.parse(saved) };
    }
  } catch (e) {
    console.error('Failed reading settings', e);
  }
  applySettings();

  // Drawer Toggles
  const drawer = document.getElementById('reading-drawer');
  const backdrop = document.getElementById('drawer-backdrop');
  const openButtons = [
    document.getElementById('nav-settings-btn'),
    document.getElementById('footer-reading-settings-link')
  ];
  const closeBtn = document.getElementById('close-drawer-btn');

  function openDrawer() {
    drawer.classList.add('open');
    backdrop.classList.add('open');
  }

  function closeDrawer() {
    drawer.classList.remove('open');
    backdrop.classList.remove('open');
  }

  openButtons.forEach(btn => {
    if (btn) btn.addEventListener('click', (e) => {
      e.preventDefault();
      openDrawer();
    });
  });

  if (closeBtn) closeBtn.addEventListener('click', closeDrawer);
  if (backdrop) backdrop.addEventListener('click', closeDrawer);

  // Settings Controls inside Drawer
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
      if (currentSettings.reduceMotion && lenisInstance) {
        lenisInstance.destroy();
      }
    });
  }
}

function saveSettings() {
  try {
    localStorage.setItem(SETTINGS_KEY, JSON.stringify(currentSettings));
  } catch (e) {
    console.error('Failed saving settings', e);
  }
}

function applySettings() {
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

// Lenis Smooth Scroll
function initSmoothScroll() {
  const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches || currentSettings.reduceMotion;
  if (prefersReduced) return;

  try {
    lenisInstance = new Lenis({
      duration: 1.1,
      easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
      smoothWheel: true
    });

    function raf(time) {
      if (lenisInstance) {
        lenisInstance.raf(time);
        requestAnimationFrame(raf);
      }
    }
    requestAnimationFrame(raf);
  } catch (e) {
    console.warn('Lenis scroll initialization skipped', e);
  }
}

// Magnetic Buttons Hover Effect
function initMagneticButtons() {
  const buttons = document.querySelectorAll('.magnetic-btn');
  buttons.forEach(btn => {
    btn.addEventListener('mousemove', (e) => {
      const rect = btn.getBoundingClientRect();
      const x = e.clientX - rect.left - rect.width / 2;
      const y = e.clientY - rect.top - rect.height / 2;
      btn.style.transform = `translate(${x * 0.22}px, ${y * 0.22}px)`;
    });

    btn.addEventListener('mouseleave', () => {
      btn.style.transform = 'translate(0px, 0px)';
    });
  });
}

// Desktop Cursor Glow
function initCursorGlow() {
  const glow = document.getElementById('cursor-glow');
  if (!glow) return;

  window.addEventListener('mousemove', (e) => {
    glow.style.left = `${e.clientX}px`;
    glow.style.top = `${e.clientY}px`;
  });
}

// Phone Mockup Parallax Tilt on Hero Mouse Move
function initPhoneParallax() {
  const phone = document.getElementById('phone-parallax-wrap');
  if (!phone) return;

  const heroSection = document.getElementById('hero');
  if (!heroSection) return;

  heroSection.addEventListener('mousemove', (e) => {
    const rect = heroSection.getBoundingClientRect();
    const x = (e.clientX - rect.left) / rect.width - 0.5;
    const y = (e.clientY - rect.top) / rect.height - 0.5;

    const bezel = phone.querySelector('.phone-glass-bezel');
    if (bezel) {
      bezel.style.transform = `rotateY(${x * 16}deg) rotateX(${-y * 16}deg)`;
    }
  });

  heroSection.addEventListener('mouseleave', () => {
    const bezel = phone.querySelector('.phone-glass-bezel');
    if (bezel) {
      bezel.style.transform = `rotateY(0deg) rotateX(0deg)`;
    }
  });
}

// How It Works Terminal Card Looping Stages
function initTerminalPipeline() {
  const stageScan = document.getElementById('stage-scan');
  const stageSimplify = document.getElementById('stage-simplify');
  const stageListen = document.getElementById('stage-listen');
  const stages = [stageScan, stageSimplify, stageListen].filter(Boolean);

  if (stages.length === 0) return;

  let currentStageIdx = 0;
  let pipelineInterval = null;

  function cycleStage() {
    stages.forEach((s, idx) => {
      s.classList.toggle('active', idx === currentStageIdx);
    });
    currentStageIdx = (currentStageIdx + 1) % stages.length;
  }

  // Observe terminal card when in view
  const terminal = document.getElementById('terminal-pipeline');
  if (!terminal) return;

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        if (!pipelineInterval) {
          pipelineInterval = setInterval(cycleStage, 2800);
        }
      } else {
        clearInterval(pipelineInterval);
        pipelineInterval = null;
      }
    });
  }, { threshold: 0.2 });

  observer.observe(terminal);
}

// Interactive Before / After Reader in //read
function initBeforeAfterReader() {
  const reader = document.getElementById('before-after-reader');
  if (!reader) return;

  const buttons = reader.querySelectorAll('.ba-btn');
  const textSample = document.getElementById('ba-text-sample');

  buttons.forEach(btn => {
    btn.addEventListener('click', () => {
      buttons.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      const view = btn.getAttribute('data-view');
      if (view === 'after') {
        textSample.className = 'ba-text after-mode';
      } else {
        textSample.className = 'ba-text before-mode';
      }
    });
  });
}

// Live Interactive Demo Sandbox
function initLiveDemo() {
  const surface = document.getElementById('demo-text-surface');
  const simplifyBtn = document.getElementById('demo-btn-simplify');
  const listenBtn = document.getElementById('demo-btn-listen');
  const resetBtn = document.getElementById('demo-btn-reset');
  const modeBadge = document.getElementById('demo-mode-badge');
  const playIcon = document.getElementById('demo-play-icon');
  const listenLabel = document.getElementById('demo-listen-label');

  if (!surface) return;

  let isSimplified = false;
  let isPlaying = false;
  let currentUtterance = null;

  function renderText(text) {
    const words = text.split(/\s+/).filter(Boolean);
    surface.innerHTML = words.map((w, idx) => `
      <span class="demo-word" id="d-word-${idx}">${w}</span> 
    `).join('');
  }

  renderText(CONTENT.demo.sampleRaw);

  if (simplifyBtn) {
    simplifyBtn.addEventListener('click', () => {
      isSimplified = !isSimplified;
      stopDemoAudio();

      if (isSimplified) {
        renderText(CONTENT.demo.sampleSimplified);
        simplifyBtn.innerHTML = `<span>&check; Simplified View</span>`;
        if (modeBadge) modeBadge.textContent = '// State: AI Simplified (7th Grade Lexile)';
      } else {
        renderText(CONTENT.demo.sampleRaw);
        simplifyBtn.innerHTML = `<span>Simplify Text</span>`;
        if (modeBadge) modeBadge.textContent = '// State: Standard Complex Input';
      }
    });
  }

  if (resetBtn) {
    resetBtn.addEventListener('click', () => {
      stopDemoAudio();
      isSimplified = false;
      renderText(CONTENT.demo.sampleRaw);
      if (simplifyBtn) simplifyBtn.innerHTML = `<span>Simplify Text</span>`;
      if (modeBadge) modeBadge.textContent = '// State: Standard Complex Input';
    });
  }

  function stopDemoAudio() {
    if (window.speechSynthesis) window.speechSynthesis.cancel();
    isPlaying = false;
    document.querySelectorAll('.demo-word').forEach(w => w.classList.remove('speaking-active'));
    if (listenLabel) listenLabel.textContent = 'Read Aloud';
  }

  function playDemoAudio() {
    if (!('speechSynthesis' in window)) {
      alert('Speech synthesis is not supported on this device.');
      return;
    }
    stopDemoAudio();

    const text = isSimplified ? CONTENT.demo.sampleSimplified : CONTENT.demo.sampleRaw;
    currentUtterance = new SpeechSynthesisUtterance(text);
    currentUtterance.rate = 1.0;

    currentUtterance.onboundary = (e) => {
      if (e.name === 'word') {
        const textSub = text.substring(0, e.charIndex);
        const wordIdx = textSub.split(/\s+/).filter(Boolean).length;
        document.querySelectorAll('.demo-word').forEach(w => w.classList.remove('speaking-active'));
        const span = document.getElementById(`d-word-${wordIdx}`);
        if (span) span.classList.add('speaking-active');
      }
    };

    currentUtterance.onend = stopDemoAudio;
    currentUtterance.onerror = stopDemoAudio;

    window.speechSynthesis.speak(currentUtterance);
    isPlaying = true;
    if (listenLabel) listenLabel.textContent = 'Pause';
  }

  if (listenBtn) {
    listenBtn.addEventListener('click', () => {
      if (isPlaying) {
        stopDemoAudio();
      } else {
        playDemoAudio();
      }
    });
  }
}

// 8-Month Roadmap Timeline SVG Draw on Scroll
function initRoadmapDraw() {
  const line = document.getElementById('timeline-draw-line');
  const container = document.getElementById('timeline-container');
  if (!line || !container) return;

  function updateTimeline() {
    const rect = container.getBoundingClientRect();
    const windowH = window.innerHeight;
    
    // Check progress as container scrolls through viewport
    const progress = Math.min(Math.max((windowH * 0.7 - rect.top) / rect.height, 0), 1);
    const strokeDash = 800 * (1 - progress);
    line.style.strokeDashoffset = strokeDash;
  }

  window.addEventListener('scroll', updateTimeline, { passive: true });
  updateTimeline();
}

// Code Copy Button
function initCodeCopy() {
  const btn = document.getElementById('btn-copy-code');
  if (!btn) return;

  btn.addEventListener('click', () => {
    if (navigator.clipboard) {
      navigator.clipboard.writeText(CONTENT.architecture.codeSnippet).then(() => {
        btn.textContent = 'Copied!';
        setTimeout(() => { btn.textContent = 'Copy snippet'; }, 2000);
      });
    }
  });
}

// Mobile Menu Navigation
function initMobileMenu() {
  const openBtn = document.getElementById('mobile-menu-btn');
  const closeBtn = document.getElementById('mobile-close-btn');
  const overlay = document.getElementById('mobile-menu-overlay');
  const mobileLinks = document.querySelectorAll('.mobile-link');

  if (openBtn && overlay) {
    openBtn.addEventListener('click', () => {
      overlay.classList.add('open');
      overlay.setAttribute('aria-hidden', 'false');
    });
  }

  function closeMobile() {
    if (overlay) {
      overlay.classList.remove('open');
      overlay.setAttribute('aria-hidden', 'true');
    }
  }

  if (closeBtn) closeBtn.addEventListener('click', closeMobile);
  mobileLinks.forEach(l => l.addEventListener('click', closeMobile));
}

// Seamless Page Transition to /explore.html for all "Start exploring" CTAs
function initPageNavigation() {
  const ctaButtons = [
    document.getElementById('nav-cta-btn'),
    document.getElementById('hero-cta-btn'),
    document.getElementById('final-cta-btn'),
    document.getElementById('mobile-start-btn')
  ];

  const curtain = document.getElementById('page-curtain');

  ctaButtons.forEach(btn => {
    if (!btn) return;
    btn.addEventListener('click', (e) => {
      e.preventDefault();

      // Check reduce motion
      const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches || currentSettings.reduceMotion;

      if (curtain && !prefersReduced) {
        curtain.classList.add('active');
        setTimeout(() => {
          window.location.href = '/explore.html';
        }, 450);
      } else {
        window.location.href = '/explore.html';
      }
    });
  });
}

// Initialize on DOM Ready
document.addEventListener('DOMContentLoaded', () => {
  initSettings();
  initSmoothScroll();
  initMagneticButtons();
  initCursorGlow();
  initPhoneParallax();
  initTerminalPipeline();
  initBeforeAfterReader();
  initLiveDemo();
  initRoadmapDraw();
  initCodeCopy();
  initMobileMenu();
  initPageNavigation();

  // Initialize WebGL Shaders
  const heroCanvas = document.getElementById('hero-shader-canvas');
  if (heroCanvas) {
    heroShaderInstance = initLensShader(heroCanvas);
  }

  const ctaCanvas = document.getElementById('cta-vortex-canvas');
  if (ctaCanvas) {
    ctaShaderInstance = initLensShader(ctaCanvas);
  }
});

// Cleanup on unload to prevent memory leaks or background RAF loops
window.addEventListener('beforeunload', () => {
  if (heroShaderInstance && heroShaderInstance.destroy) heroShaderInstance.destroy();
  if (ctaShaderInstance && ctaShaderInstance.destroy) ctaShaderInstance.destroy();
  if (lenisInstance && lenisInstance.destroy) lenisInstance.destroy();
  if (window.speechSynthesis) window.speechSynthesis.cancel();
});
