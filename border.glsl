// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

//  Function from Iñigo Quiles
//  www.iquilezles.org/www/articles/functions/functions.htm
float cubicPulse( float c, float w, float x ){
  x = abs(x - c);
  if( x>w ) return 0.0;
  x /= w;
  return 1.0 - x*x*(3.0-2.0*x);
}

float border(vec2 uv, float width, float padding)
{
  float dist = min(min(uv.x, uv.y), min(1.0 - uv.x, 1.0 - uv.y));
  float vignette = uv.x * uv.y * (1.-uv.x) * (1.-uv.y);

  float val = cubicPulse(padding, width, dist);
  val += cubicPulse(padding * 2.0, width * 0.8, dist);

  val = cubicPulse(padding, width, (vignette * 10. + dist) / 2.);

  return val;
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  float bord = border(uv, 0.01, 0.02);
  bord = border(uv, iMouse.y / 5.0, iMouse.x);
  gl_FragColor = vec4(bord);

  // float dist = min(uv.x, uv.y);
  // gl_FragColor = vec4(dist);
  //
  // float vignette = uv.x * uv.y * (1.-uv.x) * (1.-uv.y);
  // gl_FragColor = vec4(vignette * 3.0);
}
