// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

uniform sampler2D cait;

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;


  vec4 tex = texture2D(cait, uv);

  float bnw = (tex.a + tex.r + tex.g + tex.b) / 4.;

  float d = distance(uv, iMouse);
  vec4 outy = mix(vec4(bnw), tex, d);


  gl_FragColor = vec4(uv, 1.0, 1.0);
  gl_FragColor = outy * .2/d;
  // gl_FragColor = vec4(iMouse, 1.0, 1.0);
}
