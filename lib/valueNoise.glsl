#pragma glslify: hash = require("./hash")

float valueNoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float v00 = dot(hash(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0));
    float v10 = dot(hash(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0));
    float v01 = dot(hash(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0));
    float v11 = dot(hash(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0));

    vec2 u = smoothstep(0.0, 1.0, f);

    float v0 = mix(v00, v10, u.x);
    float v1 = mix(v01, v11, u.x);

    float v = mix(v0, v1, u.y);

    return v;
}

float valueNoise(float x, float y) {
  return valueNoise(vec2(x, y));
}

float valueNoise(float x) {
  return valueNoise(vec2(x, x));
}

#pragma glslify: export(valueNoise)
