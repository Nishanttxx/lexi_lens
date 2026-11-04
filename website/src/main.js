/**
 * LEXI LENS — INTERACTIVE FRONTEND ENGINE
 * Modern Vanilla JavaScript module for dark editorial AI document platform.
 */

// Preset Document Data for the Interactive Workbench
const DOCUMENT_PRESETS = {
  quantum: {
    id: "DOC-8942-QC",
    metaStats: "Tokens: 4,120 · Language: English (Academic) · Format: PDF/LaTeX",
    input: `1: TITLE: Fault-Tolerant Surface Codes Under Biased Pauli-Z Noise
2: ABSTRACT: Superconducting qubits exhibit physical noise dominated by dephasing errors (Z-bias > 100:1).
3: Standard rotated surface codes allocate identical distances dx = dz, resulting in suboptimal error thresholds.
4: We propose an asymmetric rectangular surface lattice where X-stabilizer measurements are scheduled with
5: continuous dynamical decoupling pulses. When bias ratio η > 10^2, the threshold improves from 0.75% to 2.1%.
6: METHODOLOGY: Syndrome measurements were executed across 72 transmon qubits configured on an 8x9 grid.
7: CAVEAT: High-frequency crosstalk along diagonal couplers induces correlated 2-qubit phase slips when
8: readout amplitudes exceed -18 dBm. This limits scalable coherence times to t < 42 μs in current planar packaging.`,
    processing: [
      {
        phase: "PHASE 1",
        badgeClass: "",
        name: "Axiomatic Dependency Mapping",
        text: "Identified premise: Pauli-Z bias allows asymmetric surface lattice geometry. Confirmed mathematical threshold boundary shift from 0.75% to 2.1% under η > 100."
      },
      {
        phase: "PHASE 2",
        badgeClass: "highlight",
        name: "Anomaly & Limitation Extraction",
        text: "Flagged hidden bottleneck: Diagonal coupler crosstalk at > -18 dBm induces correlated 2-qubit phase slips. Coherence ceiling identified at 42 μs."
      },
      {
        phase: "PHASE 3",
        badgeClass: "",
        name: "Synthesizing Decision Matrix",
        text: "Formulating actionable takeaways for hardware design teams: requires physical attenuation shielding or altered packaging geometry."
      }
    ],
    tools: [
      { name: "lexi.ast_parse_equations", param: '{ target: "threshold_boundary_equation", formal_verification: true }', latency: "24ms" },
      { name: "lexi.cross_reference_citations", param: '{ doi: "10.1103/PhysRevA.90.062320", claim: "biased_noise_threshold" }', latency: "58ms" },
      { name: "lexi.semantic_graph_synthesizer", param: '{ output_schema: "lexi.v2.ActionableReport" }', latency: "31ms" }
    ],
    output: {
      exec: "The paper proves that tailoring surface codes to asymmetric dephasing (Z-noise) dramatically expands quantum error thresholds (from 0.75% to 2.1%), but real-world scalability is currently blocked by planar packaging crosstalk exceeding -18 dBm.",
      insights: [
        { strong: "Asymmetric Lattice:", text: "Rectangular geometry outperforms square layouts by 2.8x when Z-bias ratio > 100." },
        { strong: "Hidden Blocker:", text: "Readout pulse amplitudes over -18 dBm trigger correlated 2-qubit phase slips, capping coherence at 42 μs." }
      ],
      action: "Do not manufacture full 72-qubit planar substrates until diagonal coupler spacing is widened or 3D flip-chip integration is adopted."
    }
  },

  rfc: {
    id: "RFC-842-KAFKA-CONSENSUS",
    metaStats: "Tokens: 8,450 · Format: Markdown/RFC · Category: Distributed Systems Architecture",
    input: `1: RFC-842: High-Throughput Event Streaming vs. Partition Resiliency
2: SCOPE: Comparing zero-copy page cache logging against replicated quorum state machines under WAN jitter.
3: The existing cluster deploys 12 broker nodes handling 1.8M msg/sec with replication factor RF=3.
4: ANALYSIS: Under transient cross-AZ partition events exceeding 450ms, in-sync replica (ISR) shrink triggers
5: severe producer backpressure. While min.insync.replicas=2 maintains durability, client retry storms cause
6: TCP socket saturation on remaining brokers.
7: RECOMMENDATION: Decouple partition leader election from OS page-cache flushes. Migrate to tiered storage
8: with local ephemeral SSD buffers to eliminate synchronous disk barrier contention.`,
    processing: [
      {
        phase: "PHASE 1",
        badgeClass: "",
        name: "Topology & Constraint Parsing",
        text: "Parsed cluster topology: 12 brokers, 1.8M msg/sec, RF=3, min.isr=2. Flagged cascading failure vector: 450ms partition triggers ISR drop and producer retry storms."
      },
      {
        phase: "PHASE 2",
        badgeClass: "highlight",
        name: "Failure Cascade Isolation",
        text: "Isolated socket saturation root cause: Clients retry without exponential jitter, leading to head-of-line blocking on surviving broker networking threads."
      },
      {
        phase: "PHASE 3",
        badgeClass: "",
        name: "Operational Rule Derivation",
        text: "Mapped tier storage transition benefits: removes synchronous disk barrier flushes and stabilizes producer latency p99 within 12ms."
      }
    ],
    tools: [
      { name: "lexi.parse_architecture_dag", param: '{ source: "RFC-842", detect_deadlocks: true }', latency: "38ms" },
      { name: "lexi.simulate_partition_failure", param: '{ delay_ms: 450, retry_policy: "exponential_jitter" }', latency: "74ms" },
      { name: "lexi.generate_runbook_matrix", param: '{ target_audience: "staff_sre" }', latency: "42ms" }
    ],
    output: {
      exec: "The architecture suffers from cascading socket saturation during WAN network blips over 450ms because unjittered client retries overwhelm surviving brokers while ISR sets shrink.",
      insights: [
        { strong: "Cascading Blocker:", text: "Surviving brokers run out of epoll file descriptors due to connection bursts from failing producers." },
        { strong: "Durability Trade-off:", text: "min.insync.replicas=2 protects data but creates availability blackouts during 2-node rolling restarts." }
      ],
      action: "Mandate exponential backoff jitter on producer SDK configs immediately, and adopt tiered storage with NVMe caching to prevent disk sync stalls."
    }
  },

  clinical: {
    id: "CLIN-PH3-ONC-091",
    metaStats: "Tokens: 12,200 · Category: Clinical Immunology Protocol · Regulatory: FDA / EMA",
    input: `1: PROTOCOL ID: BNT-904-PH3: Bi-Specific T-Cell Engager in Refractory Lymphoma
2: OBJECTIVE: Evaluate overall response rate (ORR) and progression-free survival (PFS) at 24 months.
3: DOSING SCHEDULE: Step-up priming dose of 2mg on Day 1, 10mg on Day 8, followed by 30mg weekly infusion.
4: SAFETY CRITERIA: Grade 3 Cytokine Release Syndrome (CRS) observed in 14.2% of cohort during Day 8 step-up.
5: Concomitant Tocilizumab (8mg/kg) administered within 2 hours mitigated progression to Grade 4 in 96% of cases.
6: EXCLUSION CRITERIA: Absolute lymphocyte count < 500/μL or active CNS metastases within prior 6 months.
7: STATISTICAL POWER: Target enrollment n=340 to detect hazard ratio HR=0.68 with alpha=0.025 and 90% power.`,
    processing: [
      {
        phase: "PHASE 1",
        badgeClass: "",
        name: "Endpoint & Dosing Alignment",
        text: "Extracted primary endpoints: ORR and 24-month PFS. Verified step-up titration schedule (2mg -> 10mg -> 30mg) designed to attenuate peak IL-6 secretion."
      },
      {
        phase: "PHASE 2",
        badgeClass: "highlight",
        name: "Adverse Event Hazard Detection",
        text: "Identified high-risk inflection window: Day 8 10mg step-up triggers 14.2% Grade 3 CRS. Confirmed 2-hour Tocilizumab rescue protocol intervention window."
      },
      {
        phase: "PHASE 3",
        badgeClass: "",
        name: "Eligibility & Exclusion Boundary Check",
        text: "Cross-checked exclusion criteria: ALC < 500/μL and recent CNS metastasis preclude trial entry to maintain statistical safety thresholds."
      }
    ],
    tools: [
      { name: "lexi.parse_clinical_endpoints", param: '{ target_schema: "FDA_CDISC_SEND", extract_adverse: true }', latency: "45ms" },
      { name: "lexi.verify_statistical_power", param: '{ sample_n: 340, target_hr: 0.68, power: 0.90 }', latency: "32ms" },
      { name: "lexi.extract_safety_safeguards", param: '{ syndrome: "CRS", protocol: "Tocilizumab_rescue" }', latency: "29ms" }
    ],
    output: {
      exec: "The protocol demonstrates robust statistical power (90%) for refractory lymphoma, but demands rigorous Day-8 bedside monitoring where 14.2% of patients experience Grade 3 CRS requiring rapid Tocilizumab infusion within 120 minutes.",
      insights: [
        { strong: "Vulnerability Window:", text: "The transition from 2mg to 10mg on Day 8 generates the primary toxicological burden, not the full 30mg maintenance dose." },
        { strong: "Rescue Efficacy:", text: "Tocilizumab within 2 hours prevented Grade 4 deterioration in 96% of affected patients." }
      ],
      action: "Pre-order ICU bedside bed reservations and confirm Tocilizumab stockpile verification prior to initiating Day 8 step-up infusions for every enrolled patient."
    }
  }
};

// Feature Deep-Dive Data for Feature Details Modal
const FEATURE_DETAILS = {
  1: {
    tag: "// ARCHITECTURE SPECIFICATION",
    title: "AI-Powered Text Analysis & Semantic Graphing",
    body: `
      <div class="modal-feature-deepdive">
        <p class="deepdive-lead">
          Lexi Lens uses a multi-tier neural parser that converts raw unformatted text, complex tables, mathematical equations, and unstructured document layouts into a high-dimensional semantic dependency graph.
        </p>
        <div class="deepdive-specs-grid">
          <div class="spec-card">
            <span class="spec-label">AST Equation Parsing</span>
            <p>Converts LaTeX, MathML, and image-based formulas into verifiable symbolic syntax trees.</p>
          </div>
          <div class="spec-card">
            <span class="spec-label">Implicit Link Discovery</span>
            <p>Discovers hidden causal dependencies and cross-sectional references across hundreds of pages.</p>
          </div>
          <div class="spec-card">
            <span class="spec-label">Ontology Mapping</span>
            <p>Supports domain-specific ontologies in Computer Science, Biomedicine, Law, and Finance.</p>
          </div>
          <div class="spec-card">
            <span class="spec-label">Sub-Second Processing</span>
            <p>Streaming inference yields first-token structural insights in under 180 milliseconds.</p>
          </div>
        </div>
      </div>
    `
  },
  2: {
    tag: "// SYNTHESIS ENGINE SPECIFICATION",
    title: "Lossless Executive Summarization & Retention",
    body: `
      <div class="modal-feature-deepdive">
        <p class="deepdive-lead">
          Unlike lossy consumer summarizers that discard qualifying caveats and numbers, the Lexi Lens Synthesis Engine preserves mission-critical operational context with 98.7% measured nuance retention.
        </p>
        <div class="deepdive-specs-grid">
          <div class="spec-card">
            <span class="spec-label">Lossless Synthesis Ratios</span>
            <p>Adjust compression from 30% executive briefings to 85% high-density technical digests.</p>
          </div>
          <div class="spec-card">
            <span class="spec-label">Zero-Hallucination Guardrails</span>
            <p>Every generated claim is bidirectionally pinned to exact source line references.</p>
          </div>
          <div class="spec-card">
            <span class="spec-label">Quantitative Retention</span>
            <p>Strict numerical extractors guarantee that thresholds, bounds, and metrics remain intact.</p>
          </div>
          <div class="spec-card">
            <span class="spec-label">Multi-Format Export</span>
            <p>Export directly to Markdown, Notion, LaTeX briefs, or structured JSON payloads.</p>
          </div>
        </div>
      </div>
    `
  },
  3: {
    tag: "// INTELLIGENCE SPECIFICATION",
    title: "Actionable Insights & Risk Factor Extractor",
    body: `
      <div class="modal-feature-deepdive">
        <p class="deepdive-lead">
          The extraction pipeline runs cognitive heuristics specifically designed to surface what human readers skim over: unstated assumptions, regulatory conflicts, single points of failure, and actionable checklists.
        </p>
        <div class="deepdive-specs-grid">
          <div class="spec-card">
            <span class="spec-label">Assumption Matrix</span>
            <p>Flags conditions where authors or drafts assume unvalidated parameters.</p>
          </div>
          <div class="spec-card">
            <span class="spec-label">Regulatory Vulnerability Scan</span>
            <p>Audits contracts and whitepapers against GDPR, HIPAA, SEC, and FDA compliance guidelines.</p>
          </div>
          <div class="spec-card">
            <span class="spec-label">Execution Runbooks</span>
            <p>Converts dense passive prose into imperative step-by-step engineering checklists.</p>
          </div>
          <div class="spec-card">
            <span class="spec-label">Confidence Scoring</span>
            <p>Calibrated Bayesian confidence score provided for every extracted insight item.</p>
          </div>
        </div>
      </div>
    `
  },
  4: {
    tag: "// RUNTIME SPECIFICATION",
    title: "Intuitive High-Performance Processing Runtime",
    body: `
      <div class="modal-feature-deepdive">
        <p class="deepdive-lead">
          Engineered for cognitive calm and developer throughput. Ingest up to 400-page documents with multi-column OCR, automatic footnotes de-noising, and zero clutter.
        </p>
        <div class="deepdive-specs-grid">
          <div class="spec-card">
            <span class="spec-label">Universal File Support</span>
            <p>PDF, EPUB, DOCX, Markdown, arXiv URLs, GitHub repos, and raw HTTP stream ingestion.</p>
          </div>
          <div class="spec-card">
            <span class="spec-label">Zero-Telemetry Privacy Mode</span>
            <p>Enterprise and Pro tiers offer zero-data-retention processing with private compute envelopes.</p>
          </div>
          <div class="spec-card">
            <span class="spec-label">Keyboard-First Navigation</span>
            <p>Vim and Emacs friendly keyboard commands for instant search, tag jumping, and filtering.</p>
          </div>
          <div class="spec-card">
            <span class="spec-label">REST & SSE Streaming API</span>
            <p>Integrate directly into internal enterprise search and automated analytics agents.</p>
          </div>
        </div>
      </div>
    `
  }
};

// UI Notification Toast Helper
function showToast(message, duration = 3000) {
  const container = document.getElementById("toast-container");
  if (!container) return;

  const toast = document.createElement("div");
  toast.className = "toast";
  toast.innerHTML = `
    <span style="color: #E7FF3F; font-size: 0.9rem;">✓</span>
    <span>${message}</span>
  `;

  container.appendChild(toast);

  setTimeout(() => {
    toast.style.opacity = "0";
    toast.style.transform = "translateY(10px)";
    toast.style.transition = "opacity 0.2s ease, transform 0.2s ease";
    setTimeout(() => toast.remove(), 250);
  }, duration);
}

// Clipboard Copy Helper
function copyText(text, successMessage = "Copied to clipboard!") {
  if (navigator.clipboard && window.isSecureContext) {
    navigator.clipboard.writeText(text).then(() => {
      showToast(successMessage);
    }).catch(() => {
      fallbackCopy(text, successMessage);
    });
  } else {
    fallbackCopy(text, successMessage);
  }
}

function fallbackCopy(text, successMessage) {
  const textArea = document.createElement("textarea");
  textArea.value = text;
  textArea.style.position = "fixed";
  textArea.style.left = "-9999px";
  document.body.appendChild(textArea);
  textArea.focus();
  textArea.select();
  try {
    document.execCommand("copy");
    showToast(successMessage);
  } catch (err) {
    showToast("Copy failed, please copy manually.");
  }
  document.body.removeChild(textArea);
}

// Document Workbench Logic
function initWorkbench() {
  const presetButtons = document.querySelectorAll(".preset-btn");
  const tabButtons = document.querySelectorAll(".workbench-tab");
  const docIdDisplay = document.getElementById("doc-id-display");
  const codeInputDisplay = document.getElementById("code-input-display");
  const processingStepsDisplay = document.getElementById("processing-steps-display");
  const toolsDisplay = document.getElementById("tools-display");
  const outputViewDisplay = document.getElementById("output-view-display");
  const reRunBtn = document.getElementById("btn-run-simulation");
  const copyBtn = document.getElementById("workbench-copy-btn");

  let currentPresetKey = "quantum";
  let activeTabName = "input";

  function renderPreset(presetKey) {
    const data = DOCUMENT_PRESETS[presetKey];
    if (!data) return;
    currentPresetKey = presetKey;

    if (docIdDisplay) docIdDisplay.textContent = data.id;
    if (codeInputDisplay) codeInputDisplay.textContent = data.input;

    // Render Processing
    if (processingStepsDisplay) {
      processingStepsDisplay.innerHTML = data.processing.map(step => `
        <div class="proc-step">
          <div class="proc-badge ${step.badgeClass}">${step.phase}</div>
          <div class="proc-details">
            <span class="proc-name">${step.name}</span>
            <p class="proc-text">${step.text}</p>
          </div>
        </div>
      `).join("");
    }

    // Render Tools
    if (toolsDisplay) {
      toolsDisplay.innerHTML = data.tools.map(tool => `
        <div class="tool-call-row">
          <span class="tool-status-dot"></span>
          <div class="tool-info">
            <span class="tool-call-name">${tool.name}</span>
            <span class="tool-param">${tool.param}</span>
          </div>
          <span class="tool-latency">${tool.latency}</span>
        </div>
      `).join("");
    }

    // Render Output
    if (outputViewDisplay) {
      outputViewDisplay.innerHTML = `
        <div class="output-block-card">
          <div class="card-eyebrow">// EXECUTIVE UNDERSTANDING</div>
          <p class="card-body-text">${data.output.exec}</p>
        </div>
        <div class="output-grid-two">
          <div class="output-block-card highlight-border">
            <div class="card-eyebrow">// KEY TAKEAWAYS &amp; INSIGHTS</div>
            <ul class="key-insights-list">
              ${data.output.insights.map(item => `<li><strong>${item.strong}</strong> ${item.text}</li>`).join("")}
            </ul>
          </div>
          <div class="output-block-card">
            <div class="card-eyebrow">// ACTIONABLE RECOMMENDATION</div>
            <p class="action-recommendation">${data.output.action}</p>
          </div>
        </div>
      `;
    }
  }

  // Handle Preset Switching
  presetButtons.forEach(btn => {
    btn.addEventListener("click", () => {
      presetButtons.forEach(b => {
        b.classList.remove("active");
        b.setAttribute("aria-selected", "false");
      });
      btn.classList.add("active");
      btn.setAttribute("aria-selected", "true");

      const preset = btn.getAttribute("data-preset");
      renderPreset(preset);
      showToast(`Loaded ${DOCUMENT_PRESETS[preset].id} into runtime`);
    });
  });

  // Handle Tab Switching
  tabButtons.forEach(tab => {
    tab.addEventListener("click", () => {
      tabButtons.forEach(t => {
        t.classList.remove("active");
        t.setAttribute("aria-selected", "false");
      });
      tab.classList.add("active");
      tab.setAttribute("aria-selected", "true");

      const targetTab = tab.getAttribute("data-tab");
      activeTabName = targetTab;
      document.querySelectorAll(".tab-pane").forEach(pane => pane.classList.remove("active"));
      const targetPane = document.getElementById(`pane-${targetTab}`);
      if (targetPane) targetPane.classList.add("active");
    });
  });

  // Re-run simulation animation
  if (reRunBtn) {
    reRunBtn.addEventListener("click", () => {
      reRunBtn.disabled = true;
      reRunBtn.style.opacity = "0.6";
      showToast("Re-running neural inference simulation...");

      // Switch to processing tab briefly
      const procTab = document.querySelector('.workbench-tab[data-tab="processing"]');
      if (procTab) procTab.click();

      setTimeout(() => {
        const outputTab = document.querySelector('.workbench-tab[data-tab="output"]');
        if (outputTab) outputTab.click();
        reRunBtn.disabled = false;
        reRunBtn.style.opacity = "1";
        showToast("Analysis verified with 99.4% confidence score");
      }, 700);
    });
  }

  // Copy current view
  if (copyBtn) {
    copyBtn.addEventListener("click", () => {
      const data = DOCUMENT_PRESETS[currentPresetKey];
      if (activeTabName === "input") {
        copyText(data.input, "Document input copied to clipboard!");
      } else if (activeTabName === "output") {
        copyText(`EXECUTIVE BRIEF:\n${data.output.exec}\n\nACTION:\n${data.output.action}`, "Executive understanding copied!");
      } else {
        copyText(JSON.stringify(data, null, 2), "Raw data copied!");
      }
    });
  }

  // Initialize with Quantum preset
  renderPreset("quantum");
}

// Modal Helpers
function openModal(modalId) {
  const modal = document.getElementById(modalId);
  if (!modal) return;
  modal.classList.add("open");
  modal.setAttribute("aria-hidden", "false");
  document.body.style.overflow = "hidden";
}

function closeModal(modalId) {
  const modal = document.getElementById(modalId);
  if (!modal) return;
  modal.classList.remove("open");
  modal.setAttribute("aria-hidden", "true");
  document.body.style.overflow = "";
}

// Initialize Custom Sandbox Modal
function initSandboxModal() {
  const sandboxModal = document.getElementById("sandbox-modal");
  const openButtons = [
    document.getElementById("btn-nav-cta"),
    document.getElementById("hero-primary-cta"),
    document.getElementById("final-primary-cta"),
    document.getElementById("mobile-cta-btn"),
    document.getElementById("btn-open-interactive-sandbox"),
    document.getElementById("feat-try-drop-btn")
  ];

  openButtons.forEach(btn => {
    if (btn) {
      btn.addEventListener("click", (e) => {
        e.preventDefault();
        openModal("sandbox-modal");
      });
    }
  });

  const closeBtn = document.getElementById("sandbox-close-btn");
  const backdrop = document.getElementById("sandbox-backdrop");
  if (closeBtn) closeBtn.addEventListener("click", () => closeModal("sandbox-modal"));
  if (backdrop) backdrop.addEventListener("click", () => closeModal("sandbox-modal"));

  // Sandbox Sample Fill buttons
  const textarea = document.getElementById("sandbox-user-input");
  const sampleButtons = document.querySelectorAll(".sample-fill-btn");
  const telemetry = document.getElementById("sandbox-telemetry");
  const runBtn = document.getElementById("btn-run-live-analysis");
  const summaryText = document.getElementById("sandbox-summary-text");
  const inferenceTime = document.getElementById("sandbox-inference-time");

  const SAMPLES = {
    ai: `Multi-head self-attention exhibits quadratic complexity O(N^2) with respect to context window length N. FlashAttention mitigates memory bandwidth bottlenecks via kernel tiling and online softmax recomputation without materializing full attention matrices. The key limitation resides in backward pass gradient checkpointing which consumes 12% additional FLOPs during fine-tuning.`,
    contract: `Clause 12.4 (Indemnification Cap): Neither party shall be liable for indirect, incidental, or punitive damages. However, Section 12.5 excludes gross negligence, willful misconduct, and breach of Confidentiality obligations from the aggregate liability ceiling ($1,000,000 USD). This exposes either party to unlimited discovery liability in contested cross-border IP claims.`,
    clear: ``
  };

  sampleButtons.forEach(b => {
    b.addEventListener("click", () => {
      const type = b.getAttribute("data-type");
      if (textarea && SAMPLES[type] !== undefined) {
        textarea.value = SAMPLES[type];
        if (telemetry) telemetry.textContent = type === "clear" ? "Cleared. Enter text above." : `Sample loaded: ${type.toUpperCase()}`;
      }
    });
  });

  // Run Live Analysis in Sandbox
  if (runBtn && textarea) {
    runBtn.addEventListener("click", () => {
      const val = textarea.value.trim();
      if (!val) {
        showToast("Please enter or paste text to analyze.");
        return;
      }

      runBtn.disabled = true;
      if (telemetry) telemetry.textContent = "Status: Executing neural deconstruction...";

      setTimeout(() => {
        runBtn.disabled = false;
        const latency = Math.floor(Math.random() * 80) + 110;
        if (inferenceTime) inferenceTime.textContent = `Latency: ${latency}ms`;
        if (telemetry) telemetry.textContent = `Status: Complete (Generated in ${latency}ms)`;

        if (summaryText) {
          summaryText.innerHTML = `<strong>Synthesized Takeaway:</strong> Analyzed ${val.length} characters. Identified 1 core architectural assertion, 2 implicit trade-offs, and derived 1 decisive mitigation invariant.`;
        }
        showToast("Document analysis complete!");
      }, 500);
    });
  }
}

// Feature Details Modal
function initFeatureDetails() {
  const detailsModal = document.getElementById("details-modal");
  const detailsButtons = document.querySelectorAll(".view-details-btn");
  const closeBtn = document.getElementById("details-close-btn");
  const backdrop = document.getElementById("details-backdrop");
  const modalTitle = document.getElementById("modal-details-title");
  const modalTag = document.getElementById("details-tag");
  const modalBody = document.getElementById("details-modal-body");

  detailsButtons.forEach(btn => {
    btn.addEventListener("click", (e) => {
      e.preventDefault();
      const featNum = btn.getAttribute("data-feature");
      const featData = FEATURE_DETAILS[featNum];
      if (featData) {
        if (modalTag) modalTag.textContent = featData.tag;
        if (modalTitle) modalTitle.textContent = featData.title;
        if (modalBody) modalBody.innerHTML = featData.body;
        openModal("details-modal");
      }
    });
  });

  if (closeBtn) closeBtn.addEventListener("click", () => closeModal("details-modal"));
  if (backdrop) backdrop.addEventListener("click", () => closeModal("details-modal"));
}

// Mobile Navigation
function initMobileNav() {
  const toggleBtn = document.getElementById("mobile-toggle");
  const overlay = document.getElementById("mobile-nav-overlay");
  const closeBtn = document.getElementById("mobile-close-btn");
  const mobileLinks = document.querySelectorAll(".mobile-link");

  if (toggleBtn && overlay) {
    toggleBtn.addEventListener("click", () => {
      overlay.classList.add("open");
      overlay.setAttribute("aria-hidden", "false");
      document.body.style.overflow = "hidden";
    });
  }

  function closeMobile() {
    if (overlay) {
      overlay.classList.remove("open");
      overlay.setAttribute("aria-hidden", "true");
      document.body.style.overflow = "";
    }
  }

  if (closeBtn) closeBtn.addEventListener("click", closeMobile);
  mobileLinks.forEach(link => link.addEventListener("click", closeMobile));

  // Footer mobile accordions
  const footerColToggles = document.querySelectorAll(".footer-col-toggle");
  footerColToggles.forEach(toggle => {
    toggle.addEventListener("click", (e) => {
      const parentCol = toggle.closest(".footer-links-col");
      if (parentCol) {
        const isOpen = parentCol.classList.contains("open");
        parentCol.classList.toggle("open");
        toggle.setAttribute("aria-expanded", String(!isOpen));
      }
    });
  });
}

// Copy Code Snippet Buttons in Hero & Dev Sections
function initCodeCopyButtons() {
  const heroCopyBtn = document.getElementById("hero-copy-btn");
  if (heroCopyBtn) {
    heroCopyBtn.addEventListener("click", () => {
      const textToCopy = `// LEXI LENS ANALYSIS REPORT
Executive Insight: Safety prioritized over availability under partition.
Invariant: Election timeout must exceed broadcast delay by 10x.
Checklist: Enforce monotonic term verification before replying to AppendEntries.`;
      copyText(textToCopy, "Hero report copied to clipboard!");
    });
  }

  const devCopyBtn = document.getElementById("dev-copy-btn");
  if (devCopyBtn) {
    devCopyBtn.addEventListener("click", () => {
      const devCode = `import { LexiLens } from '@lexilens/sdk';

const lexi = new LexiLens({ apiKey: process.env.LEXILENS_API_KEY });

const understanding = await lexi.documents.understand({
  source: 'https://arxiv.org/pdf/2403.09214.pdf',
  pipeline: 'deep_semantic',
  extract: ['assumptions', 'critical_risks', 'action_items'],
  options: {
    format: 'structured_json',
    preserveNuance: true
  }
});`;
      copyText(devCode, "SDK snippet copied!");
    });
  }
}

// Newsletter Subscription
function initNewsletter() {
  const form = document.getElementById("newsletter-form");
  const emailInput = document.getElementById("newsletter-email");

  if (form && emailInput) {
    form.addEventListener("submit", (e) => {
      e.preventDefault();
      const val = emailInput.value.trim();
      if (!val || !val.includes("@") || !val.includes(".")) {
        showToast("Please enter a valid research email address.");
        emailInput.focus();
        return;
      }

      showToast(`Subscribed ${val} to Cognitive AI briefs!`);
      emailInput.value = "";
    });
  }
}

// Pricing Buttons
function initPricing() {
  const tierButtons = document.querySelectorAll(".btn-tier-action");
  tierButtons.forEach(btn => {
    btn.addEventListener("click", () => {
      const tier = btn.getAttribute("data-tier");
      if (tier === "enterprise") {
        showToast("Enterprise inquiry opened. Our architects will contact you within 2 business hours.");
      } else {
        openModal("sandbox-modal");
        showToast(`Selected ${tier.toUpperCase()} tier! Test your document in the sandbox.`);
      }
    });
  });
}

// Global Keyboard Handler (Esc to close modals)
window.addEventListener("keydown", (e) => {
  if (e.key === "Escape") {
    closeModal("sandbox-modal");
    closeModal("details-modal");
    const mobileOverlay = document.getElementById("mobile-nav-overlay");
    if (mobileOverlay && mobileOverlay.classList.contains("open")) {
      mobileOverlay.classList.remove("open");
      document.body.style.overflow = "";
    }
  }
});

// App Initialization
document.addEventListener("DOMContentLoaded", () => {
  initWorkbench();
  initSandboxModal();
  initFeatureDetails();
  initMobileNav();
  initCodeCopyButtons();
  initNewsletter();
  initPricing();
});
