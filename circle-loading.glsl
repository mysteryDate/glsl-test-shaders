// vec2 u_resolution
// vec2 u_mouse
// float u_time

#pragma glslify: map = require('./lib/map')
#pragma glslify: smoothUnion = require('./lib/smoothUnion')

float circleSDF(vec2 st, vec2 center, float radius) {
  return length(st - center) - radius;
}

float sin01(float x) {
  return map(sin(x), -1.0, 1.0, 0.0, 1.0);
}

#define PI 3.14159
#define NUM_CIRCLES 12
#define c1 vec3(0.25, 0.2, 0.4)
#define c2 vec3(0.99, 0.55, 0.79)
#define OFFSET 12
void main() {
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;
  uv = map(uv, 0.0, 1.0, -1.0, 1.0);
  vec3 color = vec3(1.0);

  float height = 0.0;
  for (int i = 1 + OFFSET; i <= NUM_CIRCLES + OFFSET; i++) {
    float angle = float(i) * u_time * 0.2 + PI/2.0;
    // float angle = 0.0;
    vec2 pos = vec2(sin(angle), cos(angle)) * 0.5;
    float radius = 3.0 / float(i);
    float shape = circleSDF(uv, pos, radius);
    float circle = 1.0 - smoothstep(0.0, 0.05 * sin01(u_time) + 0.01, shape);
    height += circle;
  }

  color = mix(c1, c2, mod(height, 2.0));

  gl_FragColor.rgb = color;
}
