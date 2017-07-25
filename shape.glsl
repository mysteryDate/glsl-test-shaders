// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

#define polar(a) vec2(cos(a),sin(a))

const float pi = atan(1.0)*4.0;

//--- 2D Shapes ---
vec2 hex0 = polar((1.0 * pi) / 6.0);
vec2 hex1 = polar((3.0 * pi) / 6.0);
vec2 hex2 = polar((5.0 * pi) / 6.0);

float hexagon(vec2 uv, float r) {
    return max(max(
        abs(dot(uv, hex0)),
        abs(dot(uv, hex1))),
        abs(dot(uv, hex2)))
      - r;
}

vec2 twin(vec2 st, vec2 line) {
  return 2.0 * dot(st, normalize(line)) - st;
}

void main() {
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  float hex = 1.0 - hexagon(uv - vec2(1.), 0.1);

  vec2 line = vec2(1.0);
  vec2 uv2 = twin(uv, line);

  gl_FragColor = vec4(uv, 1.0, 1.0);
}
