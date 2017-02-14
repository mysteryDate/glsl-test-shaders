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
  float dist = min(min(uv.x, uv.y), min((1.0 - uv.x) , 1.0 - uv.y));



  float arrowCenter = iMouse.y;
  // float arrowWidth = iMouse.x;
  // float arrowCenter = 0.3;
  float arrowWidth = iMouse.x;
  float dist2 = abs(uv.y - arrowCenter) / arrowWidth;

  // if(dist2 < 1. && uv.x > 0.5) {
    // dist += cubicPulse( arrowCenter, arrowWidth, uv.y) / 20.;
  // }
  // float vignette = uv.x * uv.y * (1.-uv.x) * (1.-uv.y);
  dist += mix(max(0., 1.0 - abs(uv.y - arrowCenter)/arrowWidth)/20., 0., smoothstep(0., .5, uv.x));

  float val = cubicPulse(padding, width, dist);
  val += cubicPulse(padding * 2.0, width * 0.8, dist);

  // val = cubicPulse(padding, width, (vignette * 10. + dist) / 2.);

  return val;
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  float bord = border(uv, 0.03, 0.07);
  // bord = border(uv, iMouse.y / 5.0, iMouse.x);
  // bord = border(uv, iMouse.y / 5.0, iMouse.x);
  gl_FragColor = vec4(bord);
  // gl_FragColor = vec4(gl_FragCoord.xy/(100. * iMouse.x), 1.0, 1.0);

  vec2 center = vec2(0.05, 0.1);
  float dl = abs(uv.x - center.x);
  float dr = abs((1. - uv.x) - center.x);
  float db = abs(uv.y - center.y);
  float dt = abs((1. - uv.y) - center.y);
  float d = min(min(dl, dr), min(dt, db));
  float oo = cubicPulse(0., .01, d);
  gl_FragColor = vec4(oo);

  // float dist = min(uv.x, uv.y);
  // gl_FragColor = vec4(dist);
  //
  // float vignette = uv.x * uv.y * (1.-uv.x) * (1.-uv.y);
  // gl_FragColor = vec4(vignette * 3.0);
}
