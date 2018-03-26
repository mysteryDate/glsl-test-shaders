#pragma glslify: map = require('./lib/map')
#pragma glslify: hash = require('./lib/hash')
#pragma glslify: valueNoise = require('./lib/valueNoise')
#pragma glslify: smoothUnion = require('./lib/smoothUnion')
#pragma glslify: hsv2rgb = require('./lib/hsv2rgb')

const int GRID_SIZE = 1;
const float STAR_BRIGHTNESS = 0.01;
const float MAX_NEIGHBOR_DISTANCE = 2.0;
void main() {
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;
  uv.x *= u_resolution.x/u_resolution.y;
  // scale
  float numCells = 5.0;
  // vec2 st = numCells * uv;
  vec2 st = map(uv, 0.0, 1.0, -numCells/2.0 - 2.0 * sin(u_time/4.0), numCells/2.0 + 2.0 * sin(u_time/4.0));
  st += vec2(200.0);
  // st *= map(sin(u_time / 2.0), -1.0, 1.0, 0.5, 2.0);
  // st = map(st, )
  // st += vec2(200.0);
  // st += u_time / 2.0;

  vec2 cellNumber = floor(st);
  vec2 cellPosition = fract(st);

  // float brightness = 0.0;
  float minVal = float(9999.9);
  vec3 color = vec3(0.5);
  for (int y = -GRID_SIZE; y <= GRID_SIZE; y++) {
    for (int x = -GRID_SIZE; x <= GRID_SIZE; x++) {
      vec2 neighbor = vec2(float(x), float(y));
      vec2 point = map(hash(cellNumber + neighbor), -1.0, 1.0, 0.0, 1.0); // Position of neighbor star in its cell
      vec2 neighborSeed = hash(point);

      float bloopSize = map(neighborSeed.x, -1.0, 1.0, 0.0, 0.25);
      // bloopSize *= map(sin(neighborSeed.y * 2.0 * u_time), -1.0, 1.0, 0.2, 1.0);
      float hue = map(neighborSeed.y, -1.0, 1.0, 0.0, 1.0);
      vec3 neighborColor = hsv2rgb(vec3(hue, 0.5, 1.0));

      float radius = bloopSize;
      vec2 pc = point;
      point += valueNoise(sin(u_time / 3.0 + 0.1 * pc) + hash(pc));
      point = 0.5 + 0.5 * sin(u_time / 4.0 + 6.2831 * point);
      float circleSDF = length(neighbor + point - cellPosition) - bloopSize;
      minVal = smoothUnion(minVal, circleSDF, 0.5);
      color = mix(color, neighborColor, 1.0 - smoothstep(0.1, 0.4, circleSDF));
    }
  }
  vec3 col = color * (1.0 - step(0.1, minVal));

  gl_FragColor.rgb = col;
}
