float getRandomFloat(vec2 seed) { // Range [0, 1]
  return fract(sin(dot(seed, vec2(12.9898, 78.233))) * 437858.5453);
}

float getRandomFloat(float seed) {
  return getRandomFloat(vec2(seed, 1.0));
}

#pragma glslify: export(getRandomFloat)
