// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

float cubicPulse( float c, float w, float x ){
    x = abs(x - c);
    if( x>w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  float y = cubicPulse(0.5,0.2,uv.x);

  vec3 color = vec3(y);

  float pct = plot(uv,y);
  color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

  gl_FragColor = vec4(color,1.0);

  // gl_FragColor = vec4(uv, 1., 1.);
}
