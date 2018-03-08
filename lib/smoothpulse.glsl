float smoothpulse(float center, float width, float edgeWidth, float x) {
  float left = smoothstep(center - width/2.0 - edgeWidth, center - width/2.0, x);
  float right = 1.0 - smoothstep(center + width/2.0, center + width/2.0 + edgeWidth, x);

  return left * right;
}

#pragma glslify: export(smoothpulse)
