// vec2 iResolution
// vec2 iMouse
// float iGlobalTime
const vec2 BOTTOM_LEFT = vec2(0.1, 0.2);
const vec2 TOP_RIGHT = vec2(0.8, 0.7);
const vec2 BOTTOM_RIGHT = vec2(0.8, 0.2);

// Assumes that AB and BC are perpendicular
bool ptInRect(vec2 pt, vec2 A, vec2 B, vec2 C)
{
  if (dot(B - A, pt - A) >= 0.0 && dot(B - A, pt - A) <= dot(B - A, B - A)
    && dot(C - B, pt - B) >= 0.0 && dot(C - B, pt - B) <= dot(C - B, C - B)) {
      return true;
  }
  return false;
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;
  vec3 col = vec3(0.0);

  if(ptInRect(uv, BOTTOM_LEFT, BOTTOM_RIGHT, TOP_RIGHT)) {
    col = vec3(1.0);
  }

  gl_FragColor = vec4(col, 1.0);
}
