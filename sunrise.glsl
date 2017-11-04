#pragma glslify: map = require('./lib/map')
#pragma glslify: valueNoise = require('./lib/valueNoise')

uniform sampler2D u_mainTex; // textures/wood.jpg

// Created by @pheeelicks
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

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
  uv.y -= map(mod(u_time, riseTime), 0.0, riseTime, -2.0, 0.2);
  // uv.y += 0.3;
  uv.x -= 0.5;
  float theta = atan(uv.y, uv.x); // Range [-pi, pi]
  // theta = map(theta, -PI, PI, 0.0, 6.0);
  vec2 st = mod(vec2(theta, texHeight) + speed * u_time, 1.0);
  float brightness = sunSize / length(uv);
  vec4 tex = texture2D(u_mainTex, st);

  float noiseAmt = 0.2;
  float noise = valueNoise(uv * 10.0 + speed * u_time * 10.0);
  // noise = map(noise, -1.0, 1.0, 1.0 - noiseAmt, 1.0 + noiseAmt);
  noise = map(noise, -1.0, 1.0, 0.0, noiseAmt);
  float colorStop = (uv.y + uv.x * uv.x) + noise;
  vec3 bgColor = mix(blue, blue * 0.2, clamp(colorStop/2.0 - 0.5, 0.0, 1.0));
  bgColor = mix(red, bgColor, clamp(colorStop * 1.5 - 0.5, 0.0, 1.0));
  bgColor = mix(yellow, bgColor, clamp(2.0 * colorStop, 0.0, 1.0));

  gl_FragColor = tex * brightness + vec4(bgColor, 1.0);
  // gl_FragColor =  vec4(bgColor, 1.0);
  // gl_FragColor = vec4(red, green, blue, 1.0) * brightness;
}
