vec2 hash(vec2 st) {
  st = vec2(dot(st, vec2(0.040, -0.250)), dot(st, vec2(269.5, 183.3)));
  return fract(sin(st) * 43758.633) * 2.0 - 1.0;
}

vec2 hash(float x, float y) {
  return hash(vec2(x, y));
}

vec3 hash(float x, float y, float z) {
  vec2 xy = hash(x, y);
  vec2 yz = hash(y, z);
  vec2 xz = hash(x, z);
  vec3 res = vec3(dot(xy, yz), dot(yz, xz), dot(xy, xz));
  return res;
}

#pragma glslify: export(hash)
