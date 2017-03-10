// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

// uniform sampler2D cait;
float parabola( float x, float k ){
    return pow( 4.0*x*(1.0-x), k );
}

float plot(vec2 uv, float pct){
  return  smoothstep( pct-0.02, pct, uv.y) -
          smoothstep( pct, pct+0.02, uv.y);
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution;

  float y = parabola(uv.x,1.0);

  vec3 color = vec3(y);

  float pct = plot(uv ,y);
  color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

  gl_FragColor = vec4(color,1.0);
}
