#pragma glslify: map = require('./lib/map')
#pragma glslify: hash = require('./lib/hash')
#pragma glslify: valueNoise = require('./lib/valueNoise')

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
  for (int y = -1; y <= 1; y++) {
    for (int x = -1; x <= 1; x++) {
      vec2 neighbor = vec2(float(x), float(y));
      vec2 point = map(hash(cellNumber + neighbor), -1.0, 1.0, 0.0, 1.0);
      vec2 randHash = map(hash(point), -1.0, 1.0, 0.0, 1.0);
      float currentBrightness = map(randHash.x, -1.0, 1.0, 0.0, 1.0);
      float twinkle = map(sin(randHash.y * 2.0 * u_time), -1.0, 1.0, 0.1, 1.0);
      currentBrightness *= twinkle;

      vec2 diff = neighbor + point - cellPosition;
      float dist = length(diff);
      brightness += 0.02 * currentBrightness/dist;
    }
  }
  float c = brightness;

  gl_FragColor.rgb = vec3(c);
}
