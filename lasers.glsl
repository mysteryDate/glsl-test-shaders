// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

vec2 laser(float x, float a, float theta) {
  float xn = x + a - 0.5;
  float y = xn / tan(theta) + 1.0;
  float d = (y + 1.0) * sin(theta) - xn * cos(theta);// - ()
  return vec2(y, d);
}

float plot(vec2 uv, float pct){
  return  smoothstep( pct-0.02, pct, uv.y) -
          smoothstep( pct, pct+0.02, uv.y);
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution;

  float a = 0.0;

  vec2 yd = laser(uv.x, 0.0, 0.3);

  gl_FragColor = vec4(yd.x, yd.y, 1.0,1.0);
}
