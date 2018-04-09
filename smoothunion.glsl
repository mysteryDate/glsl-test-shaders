// vec2 u_resolution
// vec2 u_mouse
// float u_time

#pragma glslify: map = require('./lib/map')
#pragma glslify: smoothUnion = require('./lib/smoothUnion')
uniform sampler2D u_mainTex; // textures/cait.jpg

float circleSDF(vec2 st, vec2 center, float radius) {
  return length(st - center) - radius;
}

float sin01(float x) {
  return map(sin(x), -1.0, 1.0, 0.0, 1.0);
}

void main()
{
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;

  vec4 tex = texture2D(u_mainTex, uv);

  vec3 color;
  float c1 = circleSDF(uv, u_mouse.xy, 0.1);
  float c2 = circleSDF(uv, vec2(0.9, 0.9), 0.2);

  // float sdf = smoothUnion(c1, c2, map(sin(u_time), -1.0, 1.0, 0.0, 0.4));
  float sdf = smoothUnion(c1, c2, 1.5);

  color = vec3(1.0, 0.0, 1.0) * (1.0 - step(0.0, sdf));
  // color += vec3(1.0) * (1.0 - step(0.0, c1));
  // color += vec3(1.0) * (1.0 - step(0.0, c2));

  gl_FragColor.rgb = color;
}
