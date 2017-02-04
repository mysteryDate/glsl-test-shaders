// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

uniform sampler2D gold_star;
// Slope
float a = -3.5;
// intersect
float c = 2.;

void main()
{
  // c += 2. * sin(iGlobalTime * 2.);
  c = 1. - a;
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  // line: y = a*uv.x + c
  // Reflect uv about lines
  float d = (uv.x + a*(uv.y - c)) / (1. + a * a);
  float xprime = 2.*d - uv.x;
  float yprime = 2.*d*a - uv.y + 2.*c;

  vec4 texCol = texture2D(gold_star, uv);
  vec4 reflectedTexCol = texture2D(gold_star, vec2(xprime, yprime));
  // gl_FragColor = texCol * texCol.a;
  // gl_FragColor = reflectedTexCol * reflectedTexCol.a;
  // Point is over the fold line
  // else {
  if(uv.y > a*uv.x + c) {
    texCol = vec4(0.);
    reflectedTexCol = vec4(0.);
  }
  if(uv.y < a*uv.x + c) {
    if(reflectedTexCol.a > 0.1) {
      texCol = vec4(0.55,.42,.02,1.);
    }
  }
  // else {

  gl_FragColor = texCol * texCol.a;
  // gl_FragColor = reflectedTexCol * reflectedTexCol.a;
}
