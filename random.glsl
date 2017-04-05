// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

#define PI 3.14159265359

float random(float x) {
  return fract(sin(x) * 100000.0);
}

vec4 blueSquares() {
  vec2 uv = gl_FragCoord.xy/iResolution.xy * iMouse.x * 20.0;
  float theta = 2.0 * PI * iMouse.y;
  mat2 rotationMat = mat2(cos(theta), -sin(theta), sin(theta), cos(theta));
  uv = rotationMat * (uv - vec2(5.0)) - vec2(0.5);

  uv = floor(uv);
  float r = random(dot(uv, iMouse));
  float r2 = random(dot(uv, iMouse + vec2(0.5, 0.5)));

  return vec4(r, r2, 1.0, 1.0);
}

vec4 marchingLines() {
  vec2 uv = gl_FragCoord.xy/iResolution.xy * 20.0;
  float direction = 1.0;
  if(uv.y > 0.5 * 20.0) {
    uv.x /= 2.0;
    direction *= -1.0 * 2.0;
  }
  float randTime = random(fract(iGlobalTime/10.0));
  if(randTime > 0.9) {
    // uv.x += 5.0
  }
  uv.x += iGlobalTime * 2.0 * direction;
  float p = floor(uv.x);

  float r1 = random(p);
  float r2 = random(p + 1.0);

  float col = 0.;
  if(r2 > r1) {
    col = 1.;
  }

  return vec4(col);
}

void main() {
  gl_FragColor = blueSquares();
  // gl_FragColor = marchingLines();
}
