#pragma glslify: map = require('./lib/map')
#pragma glslify: hash = require('./lib/hash')
#pragma glslify: valueNoise = require('./lib/valueNoise')

void main()
{
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;
  uv.x *= u_resolution.x/u_resolution.y;
  // scale
  float numCells = 30.0;
  vec2 st = numCells * uv;
  vec2 cellNumber = floor(st);
  vec2 cellPosition = fract(st);

  vec3 color = vec3(0.0);
  float minDist = 1.0;
  vec2 closestPoint = vec2(0.0);
  for (int y = -1; y <= 1; y++) {
    for (int x = -1; x <= 1; x++) {
      vec2 neighbor = vec2(float(x), float(y));
      vec2 point = map(hash(cellNumber + neighbor), -1.0, 1.0, 0.0, 1.0);
      point = 0.5 + 0.5 * sin(u_time + 6.2831 * point);
      vec2 diff = neighbor + point - cellPosition;
      float dist = length(diff);
      if (dist < minDist) {
        minDist = min(minDist, dist);
        closestPoint = point;
      }
    }
  }

  color += minDist;
  color += 1.0 - step(0.02, minDist);
  color.rg = closestPoint;
  color.r += step(0.98, cellPosition.x) + step(0.98, cellPosition.y);
  gl_FragColor = vec4(color, 1.0);
}
