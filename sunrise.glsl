#pragma glslify: map = require('./lib/map')
#pragma glslify: valueNoise = require('./lib/valueNoise')

uniform sampler2D u_mainTex; // textures/wood.jpg

// Created by @pheeelicks
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

const float texHeight = 0.3;
const float speed = 0.02;
const float sunSize = 0.3;
const float PI = 3.14159;
void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.x;
  uv -= 0.5; // Center the uv
  float theta = atan(uv.y, uv.x); // Range [-pi, pi]
  // theta = map(theta, -PI, PI, 0.0, 6.0);
  vec2 st = mod(vec2(theta, texHeight) + speed * u_time, 1.0);
  float brightness = sunSize / length(uv);
  vec4 tex = texture2D(u_mainTex, st);

  // float red = valueNoise(vec2(st) * 10.0);
  // red = map(red, -1.0, 1.0, 0.0, 1.0);
  // red = smoothstep(0.4, 1.0, red);
  // float green = valueNoise(vec2(st + 1235.0) * 8.0);
  // green = map(green, -1.0, 1.0, 0.0, 1.0);
  // green = smoothstep(0.4, 1.0, green);
  // float blue = valueNoise(vec2(st + 15.0) * 9.0);
  // blue = map(blue, -1.0, 1.0, 0.0, 1.0);
  // blue = smoothstep(0.4, 1.0, blue);

  gl_FragColor = tex * brightness;
  // gl_FragColor = vec4(red, green, blue, 1.0) * brightness;
}
