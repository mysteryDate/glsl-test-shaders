#pragma glslify: map = require('./lib/map')
#pragma glslify: hash = require('./lib/hash')
#pragma glslify: valueNoise = require('./lib/valueNoise')

uniform sampler2D u_mainTex; // textures/cait.jpg
const float duration = 32.0;
const float maxCells = 80.0;
const float minCells = 2.0;
const float PI = 3.14159;
void main()
{
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;
  uv.x *= u_resolution.x/u_resolution.y;
  // uv = map(uv, 0.0, 1.0, -1.0, 1.0);
  // scale
  float numCells = map(sin(2.0 * PI * u_time/duration), -1.0, 1.0, minCells, maxCells);
  // numCells = 2.0;
  vec2 st = numCells * uv;
  vec2 cellNumber = floor(st);
  vec2 cellPosition = fract(st);

  float speed = map(numCells, minCells, maxCells, 0.0, 1.0);

  vec3 color = vec3(0.0);
  float minDist = 10.0;
  vec2 minVecDist = vec2(0.0);
  vec2 closestPoint = vec2(0.0);
  for (int y = -1; y <= 1; y++) {
    for (int x = -1; x <= 1; x++) {
      vec2 neighbor = vec2(float(x), float(y));
      vec2 point = mix(vec2(1.0), map(hash(cellNumber + neighbor), -1.0, 1.0, 0.0, 1.0), speed);
      // point = mix(point, 0.5 + 0.5 * sin(4.0 * u_time + 6.2831 * point), speed);
      vec2 diff = neighbor + point - cellPosition;
      float dist = length(diff);
      if (dist < minDist) {
        minDist = min(minDist, dist);
        closestPoint = point;
        minVecDist = diff;
      }
    }
  }

  // color += minDist;
  // color += 1.0 - step(0.02, minDist);
  // color.rg = closestPoint;
  // color.r += step(0.98, cellPosition.x) + step(0.98, cellPosition.y);

  // vec4 tex = texture2D(u_mainTex, map(uv + minVecDist/numCells, -1.0, 1.0, 0.0, 1.0));
  vec4 tex = texture2D(u_mainTex, uv + minVecDist/numCells);
  // gl_FragColor = vec4(color, 1.0);
  // tex.r = color.r;
  gl_FragColor = tex;
  // gl_FragColor = vec4(color, 1.0);
}
