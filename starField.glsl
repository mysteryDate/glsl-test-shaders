#pragma glslify: map = require('./lib/map')
#pragma glslify: hash = require('./lib/hash')

const int GRID_SIZE = 1;
const float STAR_BRIGHTNESS = 0.01;
const float MAX_NEIGHBOR_DISTANCE = 2.0;
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
      vec2 point = map(hash(cellNumber + neighbor), -1.0, 1.0, 0.0, 1.0); // Position of neighbor star in its cell

      vec2 neighborSeed = hash(point);
      float starStrength = map(neighborSeed.x, -1.0, 1.0, 0.5, 1.0);
      float twinkle = map(sin(neighborSeed.y * 2.0 * u_time), -1.0, 1.0, 0.1, 1.0);
      starStrength *= twinkle;

      float dist = length(neighbor + point - cellPosition);
      float neighborBrightness = STAR_BRIGHTNESS * starStrength/dist;
      neighborBrightness *= 1.0 - smoothstep(MAX_NEIGHBOR_DISTANCE * 0.5, MAX_NEIGHBOR_DISTANCE, dist);
      brightness += neighborBrightness;
    }
  }

  gl_FragColor.rgb = vec3(brightness);
}
