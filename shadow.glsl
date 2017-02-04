// vec2 iResolution
// vec2 iMouse
// float iGlobalTime


void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  float d = length( uv - vec2(0.5, 0.5));
  float col = 0.;
  if(d > 0.5) {
    col = 1.;
  }
  col = smoothstep(0.5, 0.4, d);
  gl_FragColor = col * vec4(1.0);
}
