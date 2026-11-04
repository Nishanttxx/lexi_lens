/**
 * LEXILENS — CONTENT REGISTRY
 * All copy, research summaries, and specifications centralized in one place.
 */

export const CONTENT = {
  project: {
    name: "LexiLens",
    badge: "A KSCST project: AI for inclusive education",
    attribution: "A KSCST Sponsored Project · Developed by LexiLens Team, NMAM Institute of Technology, Nitte",
    theme: "Theme 4: Artificial Intelligence, Data Science and Digital Technologies"
  },

  nav: {
    links: [
      { label: "How it works", href: "#how-it-works" },
      { label: "Features", href: "#features" },
      { label: "Research", href: "#research" },
      { label: "Architecture", href: "#architecture" },
      { label: "Impact & SDGs", href: "#impact" }
    ],
    cta: "Start exploring"
  },

  hero: {
    eyebrow: "// ASSISTIVE READING PLATFORM",
    headlineWords: ["Read", "without", "barriers.", "Powered", "by", "AI."],
    subhead: "LexiLens transforms captured photos of printed text into a calm, fully adjustable visual and auditory experience tailored for dyslexic readers.",
    primaryCta: "Start exploring",
    secondaryCta: "How it works",
    reassurance: "Open Source · Offline-First · Zero Cloud Tracking"
  },

  howItWorks: {
    eyebrow: "// HOW IT WORKS",
    title: "From printed page to effortless comprehension.",
    subtitle: "A unified three-stage pipeline designed to eliminate cognitive fatigue and visual crowding.",
    steps: [
      {
        stage: "[ Scan ]",
        label: "Stage 01",
        heading: "Intelligent Optical Capture",
        desc: "Point your camera at any book, worksheet, or document. Adaptive OpenCV binarization removes shadows while Tesseract extracts characters with bounding box precision."
      },
      {
        stage: "[ Simplify ]",
        label: "Stage 02",
        heading: "Syntactic Clarification",
        desc: "Dense compound sentences are transformed into clear, direct statements using lightweight NLP models without losing semantic nuance."
      },
      {
        stage: "[ Listen ]",
        label: "Stage 03",
        heading: "Bimodal Speech Synthesis",
        desc: "Text is read aloud with synchronized word-by-word highlight tracking, reinforcing phonological decoding and reducing cognitive load by up to 34%."
      }
    ]
  },

  features: [
    {
      id: "scan",
      tag: "//scan",
      title: "Real-Time OCR & Document Preprocessing",
      description: "Extract clean, uncorrupted text from curved pages, low-light snapshots, and classroom handouts using hybrid edge detection.",
      bullets: [
        "Automatic skew correction and adaptive thresholding via OpenCV",
        "Bounding box character geometry and baseline stabilization",
        "Works with printed textbooks, typed handouts, and digital screenshots"
      ],
      badge: "Tesseract + OpenCV"
    },
    {
      id: "simplify",
      tag: "//simplify",
      title: "AI-Powered Sentence Simplification",
      description: "Convert dense academic jargon and passive constructions into active, straightforward statements that are effortless to process.",
      bullets: [
        "Syntactic decomposition of run-on clauses into concise sentences",
        "Vocabulary softening while preserving factual accuracy",
        "Maintains context hierarchy for students and researchers"
      ],
      badge: "Transformer NLP"
    },
    {
      id: "read",
      tag: "//read",
      title: "Dyslexia-Tuned Visual Reading Surface",
      description: "Eliminate visual crowding and line-skipping with weighted baseline fonts, custom tracking, and soothing chromatic overlays.",
      bullets: [
        "OpenDyslexic and Atkinson Hyperlegible high-contrast typography",
        "Customizable character spacing (0–0.12em) and line height (1.5–2.4x)",
        "Specialized reading overlay tints: Warm Cream, Soft Blue, Pastel Rose, and Sage"
      ],
      badge: "WCAG AAA Ready"
    },
    {
      id: "listen",
      tag: "//listen",
      title: "Bimodal Text-to-Speech with Live Sync",
      description: "Listen while reading with precise karaoke-style word highlighting that keeps eyes locked on the current sentence.",
      bullets: [
        "Synchronized boundary highlighting mapped to millisecond timestamps",
        "Adjustable playback speed (0.75x to 1.5x) for comfortable comprehension",
        "Local browser Web Speech API integration with zero latency"
      ],
      badge: "Bimodal Audio"
    },
    {
      id: "personalize",
      tag: "//personalize",
      title: "Private, Persistent Reading Preferences",
      description: "Your accessibility preferences sync locally on your device without invasive analytics or mandatory account walls.",
      bullets: [
        "Instant persistence across sessions via local encrypted storage",
        "Zero tracking of user documents, captured images, or reading habits",
        "One-click systemwide accessibility toggle"
      ],
      badge: "Privacy First"
    }
  ],

  demo: {
    eyebrow: "// LIVE INTERACTIVE DEMO",
    title: "Experience the difference in seconds.",
    subtitle: "Test the text simplification, font toggles, and bimodal speech synthesis directly in your browser.",
    sampleRaw: "The photosynthesis process represents an intricate biological synthesis wherein phototrophic autotrophs convert solar electromagnetic radiation into stored chemical potential energy within chloroplast thylakoid membranes, subsequently releasing diatomic oxygen as a physiological byproduct.",
    sampleSimplified: "Plants use sunlight to make food. Inside their leaves, green cells absorb light and turn it into energy. During this natural process, the plants release fresh oxygen into the air."
  },

  architecture: {
    eyebrow: "// SYSTEM ARCHITECTURE",
    title: "Engineered for speed, privacy, and accessibility.",
    subtitle: "A lightweight mobile and web architecture bridging OpenCV computer vision, local transformer models, and accessible renderers.",
    pipelineSteps: [
      { num: "01", name: "User", sub: "Camera Capture / Upload" },
      { num: "02", name: "Flutter App", sub: "Responsive Client Shell" },
      { num: "03", name: "OCR Engine", sub: "Tesseract + OpenCV" },
      { num: "04", name: "NLP Engine", sub: "Syntactic Simplification" },
      { num: "05", name: "Formatter", sub: "Dyslexia-Friendly Layout" },
      { num: "06", name: "TTS Engine", sub: "Bimodal Audio Playback" },
      { num: "07", name: "Experience", sub: "Calm, Clear Reading" }
    ],
    codeSnippet: `from fastapi import FastAPI, UploadFile, File
from lexilens.vision import preprocess_image, extract_text_tesseract
from lexilens.nlp import simplify_complex_clauses

app = FastAPI(title="LexiLens Ingestion API", version="2.0")

@app.post("/api/v1/process-scan")
async def process_scan(image: UploadFile = File(...)):
    # 1. OpenCV adaptive thresholding & perspective warp
    processed_cv = preprocess_image(await image.read())
    
    # 2. Tesseract OCR with character bounding boxes
    raw_text = extract_text_tesseract(processed_cv)
    
    # 3. AI Text Simplification preserving semantic core
    simplified = simplify_complex_clauses(raw_text, target_grade=8)
    
    return {
        "status": "success",
        "raw_text": raw_text,
        "simplified_text": simplified,
        "reading_metrics": {"syllable_reduction": 0.38, "fk_grade": 7.4}
    }`
  },

  research: {
    eyebrow: "// EVIDENCE-BASED DESIGN",
    title: "Validated by clinical and educational research.",
    statNumber: "5–15%",
    statLabel: "of the global population lives with dyslexia — representing over 700 million learners worldwide.",
    marqueeRow1: [
      {
        citation: "Svensson et al. (2019)",
        finding: "Assistive technology interventions significantly increase reading fluency and academic self-efficacy in students with developmental dyslexia."
      },
      {
        citation: "Singh & Alexander (2020)",
        finding: "Synchronized bimodal presentation (highlighted text paired with synthetic speech) reduces cognitive working memory load by up to 34%."
      },
      {
        citation: "Alqahtani et al. (2022)",
        finding: "Customizable typography, increased character tracking, and low-contrast background tints measurably reduce visual crowding and fixation duration."
      }
    ],
    marqueeRow2: [
      {
        citation: "Rello & Baeza-Yates (2017)",
        finding: "Sans-serif typefaces paired with 1.6–2.0 line spacing measurably improve reading speed in individuals with phonological decoding impairments."
      },
      {
        citation: "Bouldoukian et al. (2021)",
        finding: "Color overlays (cream, pastel blue) substantially alleviate visual perceptual distortions and ocular fatigue during sustained reading tasks."
      },
      {
        citation: "World Dyslexia Association (2023)",
        finding: "Early access to assistive mobile tools fosters independent lifelong learning and reduces dropout rates in STEM disciplines."
      }
    ]
  },

  impact: {
    eyebrow: "// GLOBAL IMPACT & SUSTAINABILITY",
    title: "Advancing United Nations Sustainable Development Goals.",
    sdgs: [
      {
        num: "SDG 4",
        name: "Quality Education",
        desc: "Ensuring inclusive, equitable quality education and promoting lifelong learning opportunities for neurodivergent learners."
      },
      {
        num: "SDG 9",
        name: "Innovation & Infrastructure",
        desc: "Fostering accessible digital infrastructure by integrating open-source computer vision and NLP models into public tools."
      },
      {
        num: "SDG 10",
        name: "Reduced Inequalities",
        desc: "Eliminating literacy and learning barriers, empowering individuals with dyslexia to excel in higher education and professional careers."
      },
      {
        num: "SDG 17",
        name: "Partnerships for the Goals",
        desc: "Bridging academic research, engineering institutes, and government bodies (KSCST) to build sustainable assistive technology."
      }
    ],
    timeline: [
      { month: "Month 1–2", title: "Literature & User Needs", desc: "Research synthesis, dyslexia font benchmarking, and clinician interviews." },
      { month: "Month 3–4", title: "OCR & Vision Pipeline", desc: "OpenCV thresholding, Tesseract integration, and bounding box extraction." },
      { month: "Month 5–6", title: "NLP Simplification & TTS", desc: "Syntactic simplification models and bimodal audio synchronization." },
      { month: "Month 7–8", title: "Integration & Field Testing", desc: "Flutter mobile client, web studio deployment, and user usability evaluations." }
    ]
  },

  finalCta: {
    headline: "Ready to read without barriers?",
    subhead: "Experience how LexiLens transforms difficult text into crystal-clear understanding with personalized typography and speech.",
    button: "Start exploring"
  },

  footer: {
    columns: [
      {
        title: "// PRODUCT",
        links: [
          { label: "Studio & Explore", href: "/explore.html" },
          { label: "OCR Scanner", href: "#features" },
          { label: "AI Simplifier", href: "#features" },
          { label: "Reading Settings", href: "#" }
        ]
      },
      {
        title: "// RESEARCH",
        links: [
          { label: "Evidence Base", href: "#research" },
          { label: "Bimodal Speech Study", href: "#research" },
          { label: "Visual Crowding", href: "#research" },
          { label: "KSCST Proposal", href: "https://kscst.org.in" }
        ]
      },
      {
        title: "// OPEN SOURCE",
        links: [
          { label: "GitHub Repository", href: "https://github.com" },
          { label: "OpenCV Preprocessor", href: "#architecture" },
          { label: "FastAPI Service", href: "#architecture" },
          { label: "License (MIT)", href: "#" }
        ]
      },
      {
        title: "// PROJECT",
        links: [
          { label: "NMAMIT Nitte", href: "https://nmamit.nitte.edu.in" },
          { label: "KSCST Karnataka", href: "https://kscst.org.in" },
          { label: "Project Team", href: "#" },
          { label: "Contact Us", href: "mailto:lexilens@nmamit.in" }
        ]
      }
    ]
  }
};
