#pragma glslify: valueNoise = require("./lib/valueNoise")
#pragma glslify: map = require('./lib/map')

// Remapping the unit interval into the unit interval by expanding the sides and
// compressing the center, and keeping 1/2 mapped to 1/2.
//
// Values of k < 1 push everything towards 0.5.
// Values of k > 1 push everything away from 0.5.
//
// http://iquilezles.org/www/articles/functions/functions.htm
float gain(float x, float k) {
  float a = 0.5 * pow(2.0*((x<0.5)?x:1.0-x), k);
  return (x<0.5)?a:1.0-a;
}

void main() {
  vec2 uv = gl_FragCoord.xy / iResolution.xy;
  float aspect = iResolution.x / iResolution.y;

  uv = map(uv, 0.0, 1.0, -1.0, 1.0);
  uv.y /= aspect;
  // uv.y += 1.2;

  float r = length(uv);
  float theta = atan(uv.y, uv.x);
  // theta = map(theta, 0.0, 6.28, 0.0, 1.0);

  r /= 1.8;
  // theta *= 5.0;
  theta *= floor(3.0 * (sin(iGlobalTime/2.0)/2.0 + 1.0));

  theta = sin(theta);


  float v = map(valueNoise(vec2(r, theta - iGlobalTime)), -1.0, 1.0, 0.0, 1.0);
  v += map(valueNoise(vec2(r * 1.0, theta * 2.0 - iGlobalTime) + 12.392), -1.0, 1.0, 0.0, 0.5);
  v /= 1.5;

  v = gain(v, 2.4);

  vec3 fg = vec3(0.0, 0.0, 0.8);
  vec3 bg = vec3(0.0, 1.0, 0.0);
  // bg.r += sin(iGlobalTime);
  vec3 bbg = vec3(0.0);
  // vec3 bbg = mix(vec3(0.0), vec3(1.0), sin(iGlobalTime/4.0));
  vec3 color = mix(bg, fg, v);

  float offset = valueNoise(vec2(iGlobalTime, theta));
  float mask = map(valueNoise(uv * 3.0 + 5.0 * r + offset), -1.0, 1.0, 0.0, 1.0);
  mask *= smoothstep(0.0, 0.3, r);
  mask *= 1.0 - smoothstep(0.42, 0.5, r);
  color = mix(bbg, color, mask);

  gl_FragColor = vec4(color * 1.5, 1.0);
}
