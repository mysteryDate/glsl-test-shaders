// vec2 u_resolution
// vec2 u_mouse
// float u_time

#pragma glslify: map = require('./lib/map')
  #pragma glslify: smoothpulse = require('./lib/smoothpulse')

// vec2 smoothstep(vec2 edge, vec2 st) {
//   return
// }
float outline(float width, float fade, vec2 st) {
  vec2 result = 1.0 - smoothstep(vec2(width), vec2(width + fade), st);
  result += smoothstep(vec2(1.0 - width - fade), vec2(1.0 - width), st);
  return result.x + result.y;
}

float lineWidth = 0.05;
float numSquares = 5.0;
void main() {
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;
  float easing = 0.655;
  float zoom = mod(u_time / 10.0, pow(0.4, 1.0/easing));
  zoom = pow(zoom, easing);
  uv = map(uv, 0.0, 1.0, zoom, 1.0 - zoom);
  vec3 color = vec3(0.0);

  // float numSquares = mod(u_time/10.0, 2.0) + 0.5;
  float lines = outline(0.0, lineWidth, uv);
  color += lines;
  vec2 sqUV = uv;
  vec2 lastUV = uv;
  for(int ii = 0; ii < 4; ii++)
  {
    sqUV = mod(sqUV, 1.0/numSquares) * numSquares;
    lines = outline(0.0, lineWidth, sqUV);
    color += lines;
    lastUV = sqUV;
  }

  gl_FragColor.rgb = 1.0 - color;
}
