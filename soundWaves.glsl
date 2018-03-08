#pragma glslify: valueNoise = require("./lib/valueNoise")
#pragma glslify: map = require("./lib/map")
#pragma glslify: smoothpulse = require("./lib/smoothpulse")
#pragma glslify: hsv2rgb = require("./lib/hsv2rgb")

float cubicPulse(float c, float w, float x){
  x = abs(x - c);
  if(x>w) return 0.0;
  x /= w;
  return 1.0 - x*x*(3.0-2.0*x);
}

uniform sampler2D u_mainTex; // textures/shadertoy-color-noise.png

const float BPM = 120.0;
#define PI 3.14159
const float numHarmonics = 10.0;
float wave(vec2 st, float t) {
  float secondsPerBeat = 1.0 / BPM * 60.0;
  float beatPosition = mod(u_time, secondsPerBeat) / secondsPerBeat; // [-0.5, 0.5]
  // float amplitude = cubicPulse(0.5, 0.4, beatPosition);
  float amplitude = map(cubicPulse(0.5, 0.3, beatPosition), 0.0, 1.0, 0.01, 1.0);

  float result = 0.0;
  float volume = map(sin(t), -1.0, 1.0, 10.0, 30.0);
  float wavelength = 0.5;
  float sampleTime = st.x / wavelength;

  float height = 0.0;
  for (float i = 1.0; i < numHarmonics + 1.0; i++)
  {
    float frequency = PI * i + 20.0 + valueNoise(t, i);
    float intensity = 1.0 / frequency * valueNoise(t * i);
    height += sin(frequency * sampleTime) * intensity * volume;
    height = clamp(-0.5, 0.5, height);
    // height *= cubicPulse(0.5, 0.6, st.x);
  }
  height /= log(numHarmonics);
  height *= smoothpulse(0.5, 0.1, 0.5, st.x);
  height *= amplitude * 1.0;
  float width = map(cubicPulse(0.5, 0.5, st.x), 0.0, 1.0, 0.005, 0.02);
  float intensity = cubicPulse(0.0, width, height - st.y);
  result += intensity;

  return result;
}

const float numStops = 1.0;
void main() {
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;
  vec2 waveUV = (uv - vec2(0.0, 0.5));

  vec3 color = vec3(0.0);
  float hue = u_time;
  for(float i = 0.0; i < numStops; i++)
  {
    float waveStrength = wave(waveUV, u_time + i/1.0) / (i + 1.0);
    color += hsv2rgb(vec3(i/8.0 + 0.5, 0.0, 2.0)) * waveStrength;
  }

  gl_FragColor = vec4(color, 1.0);
}
