// vec2 u_resolution
// vec2 u_mouse
// float u_time
#pragma glslify: tileableValueNoise = require("./lib/tileableValueNoise")
#pragma glslify: valueNoise = require("./lib/valueNoise")
#pragma glslify: hash = require('./lib/hash')
#pragma glslify: map = require('./lib/map')

uniform sampler2D u_mainTex; // textures/cait.jpg

#define sqrt2 1.414
#define sqrt3over2 0.866
#define PI 3.142
#define ANIMATION_LOOP_TIME 3.0

float triSDF(vec2 st) {
  st = 2.0 * (2.0 * st - 1.0) ;
  return max(sqrt3over2 * abs(st.x) + 0.5 * st.y, -0.5 * st.y);
}

void main()
{
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;
  vec2 centeredUV = uv - vec2(0.5);
  float length = sqrt2 * length(centeredUV);
  float theta = atan(centeredUV.y, centeredUV.x);
  theta = map(theta, -PI, PI, 0.0, 1.0);

  float a = floor(valueNoise(vec2(theta)));
  float frequency = 4.0;
  // theta *= frequency;
  // theta = floor(theta);
  // theta /= frequency;

  float l = tileableValueNoise(vec2(frequency * theta), vec2(frequency));
  l = map(l, -1.0, 1.0, 0.0, 1.0);
  // l = step(0.01, l);
  float c = step(l, length);

  float seed = theta * frequency;
  float i = floor(seed);
  float f = seed - i;
  vec2 random = map(hash(vec2(i)), -1.0, 1.0, 0.0, 1.0);
  vec2 random2 = map(hash(vec2(i + 1.0)), -1.0, 1.0, 0.0, 1.0);
  float y = mix(random.x, random2.x, f);
  y = map(y, 0.0, 1.0, 0.5, 0.6);
  float lc = step(y, length);

  // c = 1.0 - step(lc, length);
  c = step(triSDF(uv), 0.5);

  gl_FragColor = vec4(c);
}
