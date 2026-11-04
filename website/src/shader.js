/**
 * LEXILENS — WEBGL LENS / VORTEX SHADER
 * Battery-friendly, DPR capped at 1.5, intersection-observer paused off-screen,
 * and gracefully falls back to static gradient when reduced motion is active or WebGL is missing.
 */

export function initLensShader(canvasElement) {
  if (!canvasElement) return null;

  // Check reduced motion preference
  const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  if (prefersReducedMotion) {
    canvasElement.style.opacity = '0';
    return null;
  }

  const gl = canvasElement.getContext('webgl', { powerPreference: 'low-power', antialias: false });
  if (!gl) {
    console.warn('WebGL not supported, falling back to static CSS gradient.');
    return null;
  }

  // Vertex Shader
  const vsSource = `
    attribute vec2 position;
    void main() {
      gl_Position = vec4(position, 0.0, 1.0);
    }
  `;

  // Fragment Shader: Soft caustic lens & vortex flow in warm amber/dark tones
  const fsSource = `
    precision mediump float;
    uniform vec2 u_resolution;
    uniform float u_time;
    uniform vec2 u_mouse;

    void main() {
      vec2 st = (gl_FragCoord.xy - 0.5 * u_resolution) / min(u_resolution.x, u_resolution.y);
      
      // Distance from center
      float d = length(st);
      
      // Subtle vortex swirl
      float angle = atan(st.y, st.x) + d * 1.8 - u_time * 0.15;
      vec2 uv = vec2(cos(angle), sin(angle)) * d;

      // Caustic interference wave
      float wave1 = sin(uv.x * 4.0 + u_time * 0.3) * cos(uv.y * 4.0 + u_time * 0.2);
      float wave2 = sin(d * 8.0 - u_time * 0.4);
      float intensity = smoothstep(0.85, 0.15, d) * (wave1 * 0.35 + wave2 * 0.25 + 0.5);

      // Color mapping: Soft near-black to subtle warm amber glow (#E8833B)
      vec3 bg = vec3(0.047, 0.047, 0.058); // #0C0C0F
      vec3 amber = vec3(0.91, 0.51, 0.23); // #E8833B
      vec3 deepGlow = vec3(0.18, 0.09, 0.04);

      vec3 color = mix(bg, deepGlow, intensity * 0.8);
      color += amber * pow(intensity, 3.2) * 0.35;

      // Edge vignette
      color *= smoothstep(1.3, 0.3, d);

      gl_FragColor = vec4(color, 1.0);
    }
  `;

  function createShader(gl, type, source) {
    const shader = gl.createShader(type);
    gl.shaderSource(shader, source);
    gl.compileShader(shader);
    if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
      console.error(gl.getShaderInfoLog(shader));
      gl.deleteShader(shader);
      return null;
    }
    return shader;
  }

  const vertexShader = createShader(gl, gl.VERTEX_SHADER, vsSource);
  const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fsSource);
  if (!vertexShader || !fragmentShader) return null;

  const program = gl.createProgram();
  gl.attachShader(program, vertexShader);
  gl.attachShader(program, fragmentShader);
  gl.linkProgram(program);

  if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
    console.error(gl.getProgramInfoLog(program));
    return null;
  }

  // Geometry: Full-screen Quad
  const positionBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
    -1, -1,
     1, -1,
    -1,  1,
    -1,  1,
     1, -1,
     1,  1
  ]), gl.STATIC_DRAW);

  const positionLocation = gl.getAttribLocation(program, 'position');
  const resolutionLocation = gl.getUniformLocation(program, 'u_resolution');
  const timeLocation = gl.getUniformLocation(program, 'u_time');
  const mouseLocation = gl.getUniformLocation(program, 'u_mouse');

  let isVisible = true;
  let animationFrameId = null;
  let startTime = performance.now();
  const dpr = Math.min(window.devicePixelRatio || 1, 1.5); // DPR cap 1.5

  function resize() {
    const width = canvasElement.clientWidth;
    const height = canvasElement.clientHeight;
    if (canvasElement.width !== width * dpr || canvasElement.height !== height * dpr) {
      canvasElement.width = width * dpr;
      canvasElement.height = height * dpr;
      gl.viewport(0, 0, canvasElement.width, canvasElement.height);
    }
  }

  function render() {
    if (!isVisible) return;

    resize();
    gl.useProgram(program);

    gl.enableVertexAttribArray(positionLocation);
    gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
    gl.vertexAttribPointer(positionLocation, 2, gl.FLOAT, false, 0, 0);

    const currentTime = (performance.now() - startTime) * 0.001;
    gl.uniform2f(resolutionLocation, canvasElement.width, canvasElement.height);
    gl.uniform1f(timeLocation, currentTime);
    gl.uniform2f(mouseLocation, 0.5, 0.5);

    gl.drawArrays(gl.TRIANGLES, 0, 6);

    animationFrameId = requestAnimationFrame(render);
  }

  // Intersection Observer to pause off-screen
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      isVisible = entry.isIntersecting;
      if (isVisible) {
        cancelAnimationFrame(animationFrameId);
        animationFrameId = requestAnimationFrame(render);
      } else {
        cancelAnimationFrame(animationFrameId);
      }
    });
  }, { threshold: 0.05 });

  observer.observe(canvasElement);
  animationFrameId = requestAnimationFrame(render);

  return {
    destroy: () => {
      cancelAnimationFrame(animationFrameId);
      observer.disconnect();
      gl.deleteProgram(program);
      gl.deleteBuffer(positionBuffer);
    }
  };
}
