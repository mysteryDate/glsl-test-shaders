float smoothpulse(float center, float width, float edgeWidth, float x) {
  float left = smoothstep(center - width/2.0 - edgeWidth, center - width/2.0, x);
  float right = 1.0 - smoothstep(center + width/2.0, center + width/2.0 + edgeWidth, x);

  return left * right;
}

vec2 smoothpulse(vec2 center, vec2 width, vec2 edgeWidth, vec2 st) {
  float x = smoothpulse(center.x, width.x, edgeWidth.x, st.x);
  float y = smoothpulse(center.y, width.y, edgeWidth.y, st.y);

  return vec2(x, y);
}

vec2 smoothpulse(float center, float width, float edgeWidth, vec2 st) {
  return smoothpulse(vec2(center), vec2(width), vec2(edgeWidth), st);
}

#pragma glslify: export(smoothpulse)
