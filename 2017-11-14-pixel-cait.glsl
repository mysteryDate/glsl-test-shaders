#pragma glslify: map = require('./lib/map')
uniform sampler2D u_mainTex; // textures/cait.jpg

const float maxCells = 200.0;
const float duration = 30.0;
const float easing = 3.0;
void main()
{
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;
  // scale
  float clock = mod(u_time, duration) / duration - 0.5;
  float easedClock = pow((easing * clock), easing) / pow(easing/2.0, easing);
  float numCells = map(easedClock, 0.0, 1.0, 2.0, maxCells);
  vec2 st = numCells * uv;
  vec2 cellNumber = floor(st);
  vec2 cellPosition = fract(st);

  st = cellNumber/numCells;
  vec4 tex = texture2D(u_mainTex, st);

  gl_FragColor = tex;
}
