#pragma glslify: map = require('./lib/map')
#pragma glslify: hash = require('./lib/hash')
#pragma glslify: valueNoise = require('./lib/valueNoise')

float star(vec2 st) {
    float bright = 1.000;
    float sharp = (sin(iGlobalTime * 5.) + 2.) * 5.;
    sharp = 5.0;
    vec2 center = vec2(0.5);
    vec2 centerVec = st - center;
    float vert = pow((-1.*abs(centerVec.x)+1.),sharp);
    float horiz = pow((-1.*abs(centerVec.y)+1.),sharp);
    float outCol = (vert * horiz) * bright;
    outCol *= sin(iGlobalTime * 5.0);

    return outCol;
}

void main() {
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;
  uv.x *= u_resolution.x/u_resolution.y;
  // scale
  float numCells = 10.0;
  vec2 st = numCells * uv;
  st.x += mod(u_time/5.0, 20.0);
  vec2 cellNumber = floor(st);
  vec2 cellPosition = fract(st);

  vec3 color = vec3(0.0);
  float minDist = 1.0;
  vec2 closestPoint = vec2(0.0);
  float brightness = 0.0;
  for (int y = -1; y <= 1; y++) {
    for (int x = -1; x <= 1; x++) {
      vec2 neighbor = vec2(float(x), float(y));
      vec2 point = map(hash(cellNumber + neighbor), -1.0, 1.0, 0.0, 1.0);
      // point = 0.5 + 0.5 * sin(u_time + 6.2831 * point);
      vec2 diff = neighbor + point - cellPosition;
      float dist = length(diff);
      if (dist < minDist) {
        minDist = min(minDist, dist);
        closestPoint = point;
      }
      vec2 randHash = map(hash(point), -1.0, 1.0, 0.0, 1.0);
      float b = map(randHash.x, -1.0, 1.0, 0.0, 1.0) * (sin(randHash.y * 2.0 * u_time) + 1.0) * 0.5;
      // b = 1.0;
      brightness += 0.02 * b/dist;
    }
  }
  float c = brightness;

  gl_FragColor.rgb = vec3(c);
}
