#pragma glslify: map = require('./lib/map')
#pragma glslify: valueNoise = require('./lib/valueNoise')

uniform sampler2D u_mainTex; // textures/wood.jpg

// Created by @pheeelicks
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

float clamp01(float x) {
  return clamp(x, 0.0, 1.0);
}

// http://iquilezles.org/www/articles/functions/functions.htm
float gain(float x, float k) {
  float a = 0.5*pow(2.0*((x<0.5)?x:1.0-x), k);
  return (x<0.5)?a:1.0-a;
}

// https://thebookofshaders.com/13/

float fbm(vec2 st) {
  float value = 0.0;
  float amplitude = 0.5;
  vec2 shift = vec2(100.0);
  // Rotate to reduce axial bias
  mat2 rotation = mat2(
    cos(0.5), sin(0.5),
    -sin(0.5), cos(0.5)
  );
  for (int i = 0; i < 5; i++) {
    value += amplitude * map(valueNoise(st), -1.0, 1.0, 0.0, 1.0);
    st = rotation * st;
    st *= 2.0;
    st += shift;
    amplitude *= 0.5;
  }
  return value;
}

vec4 cloud(vec2 st, float t) {
  vec2 q = vec2(0.0);
  q.x = fbm(st);
  q.y = fbm(st + 1.0);

  vec2 r = vec2(0.0);
  r.x = fbm(st + q + vec2(1.7, 9.2) + 0.15 * t);
  r.y = fbm(st + q + vec2(8.3, 2.8) + 0.13 * t);

  float f = fbm(st + r);

  vec3 color = vec3(1.0);
  color = mix(color, vec3(0.7), clamp01(length(q)));
  color = mix(color, vec3(0.9), clamp01(r.x));

  float alpha = gain(f, 12.0);
  alpha = clamp01(alpha);

  return vec4(color, alpha);
}

vec3 skyGradient(vec2 uv) {
  vec3 bg = vec3(0.012, 0.6, 0.741);
  vec3 fg = vec3(0.314, 0.686, 0.894);

  float k = uv.y;
  k *= map(valueNoise(uv), -1.0, 1.0, 0.0, 1.5);
  k = clamp01(k);
  return mix(bg, fg, k);
}

vec4 cloud(vec2 uv) {
  uv.x *= u_resolution.x / u_resolution.y;

  float t = u_time;
  t *= 4.0;

  vec3 color = skyGradient(uv + vec2(0.01 * t, 0.0));
  color *= 0.0;

  vec2 repeat = vec2(2.0, 10.0);
  vec2 offset = vec2(15.0);

  float scrollSpeed = 0.07;
  offset.x += t * scrollSpeed;

  vec2 st = uv * repeat + offset;

  float warpSpeed = 0.5;
  vec4 cloudColor = cloud(st, t * warpSpeed);

  cloudColor.a *= map(uv.y, 0.2, 1.0, 0.0, 1.4);
  cloudColor.a = clamp01(cloudColor.a);

  color = mix(color, cloudColor.rgb, cloudColor.a);

  return vec4(color, 1.0);
}

const float texHeight = 0.3;
const float speed = 0.02;
const float sunSize = 0.3;
const float PI = 3.14159;
const float duration = 8.0;

const vec3 blue = vec3(0.314, 0.396, 0.506);
const vec3 red = vec3(0.592, 0.180, 0.184);
const vec3 yellow = vec3(0.965, 0.824, 0.365);
const mat3 colors = mat3(blue, red, yellow);
const float riseTime = 32.0;
void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.x;
  vec2 sunriseUV = uv;
  sunriseUV.y -= map(mod(u_time, riseTime), 0.0, riseTime, -2.0, 0.2);
  // sunriseUV.y += 0.3;
  sunriseUV.x -= 0.5;
  float theta = atan(sunriseUV.y, sunriseUV.x); // Range [-pi, pi]
  // theta = map(theta, -PI, PI, 0.0, 6.0);
  vec2 st = mod(vec2(theta, texHeight) + speed * u_time, 1.0);
  float brightness = sunSize / length(sunriseUV);
  vec4 tex = texture2D(u_mainTex, st);

  float noiseAmt = 0.2;
  float noise = valueNoise(sunriseUV * 10.0 + speed * u_time * 10.0);
  // noise = map(noise, -1.0, 1.0, 1.0 - noiseAmt, 1.0 + noiseAmt);
  noise = map(noise, -1.0, 1.0, 0.0, noiseAmt);
  // float colorStop = (sunriseUV.y + sunriseUV.x * sunriseUV.x) + noise;
  float colorStop = (sunriseUV.y + sunriseUV.x * sunriseUV.x);
  vec3 bgColor = mix(blue, blue * 0.8, clamp(colorStop/2.0 - 0.5, 0.0, 1.0));
  bgColor = mix(red, bgColor, clamp(colorStop * 1.5 - 0.5, 0.0, 1.0));
  bgColor = mix(yellow, bgColor, clamp(2.0 * colorStop, 0.0, 1.0));

  gl_FragColor = tex * brightness + vec4(bgColor, 1.0);
  gl_FragColor *= (cloud(uv) + 1.0);
  // gl_FragColor =  vec4(bgColor, 1.0);
  // gl_FragColor = vec4(red, green, blue, 1.0) * brightness;
}
