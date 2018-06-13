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

float lineWidth = 0.01;
void main() {
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;
  uv = map(uv, 0.0, 1.0, -1.0, 1.0);
  vec3 color = vec3(0.0);

  float numSquares = mod(u_time/10.0, 2.0) + 0.5;
  // float numSquares = 2.0;
  vec2 sqUV = uv;
  vec2 lastUV = uv;
  for(int ii = 0; ii < 8; ii++)
  {
    vec2 edgeUV = abs(lastUV - 0.5);
    sqUV = mod(sqUV, 1.0/numSquares) * numSquares;
    float edge = 1.0 - step(0.2, max(edgeUV.x, edgeUV.y));
    float lines = outline(0.0, lineWidth, sqUV);
    // lines *= edge;
    color += lines;
    lastUV = sqUV;
  }

  gl_FragColor.rgb = color;
}
