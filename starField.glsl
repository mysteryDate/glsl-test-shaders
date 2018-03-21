#pragma glslify: map = require('./lib/map')
#pragma glslify: hash = require('./lib/hash')

const int GRID_SIZE = 1;
void main() {
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;
  uv.x *= u_resolution.x/u_resolution.y;
  // scale
  float numCells = 10.0;
  vec2 st = numCells * uv;
  st.x += u_time / 5.0;
  vec2 cellNumber = floor(st);
  vec2 cellPosition = fract(st);

  float brightness = 0.0;
  for (int y = -GRID_SIZE; y <= GRID_SIZE; y++) {
    for (int x = -GRID_SIZE; x <= GRID_SIZE; x++) {
      vec2 neighbor = vec2(float(x), float(y));
      vec2 point = map(hash(cellNumber + neighbor), -1.0, 1.0, 0.0, 1.0);
      vec2 randHash = map(hash(point), -1.0, 1.0, 0.0, 1.0);
      float currentBrightness = map(randHash.x, -1.0, 1.0, 0.0, 1.0);
      float twinkle = map(sin(randHash.y * 2.0 * u_time), -1.0, 1.0, 0.1, 1.0);
      currentBrightness *= twinkle;

      vec2 diff = neighbor + point - cellPosition;
      float dist = length(diff);
      float maxDist = 1.5;
      brightness += 0.03 * currentBrightness/dist * (1.0 - smoothstep(maxDist * 0.5, maxDist, dist));
    }
  }

  gl_FragColor.rgb = vec3(brightness);
}
