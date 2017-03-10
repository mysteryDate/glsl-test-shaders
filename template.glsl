// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

uniform sampler2D cait;

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  vec4 tex = texture2D(cait, uv);

  gl_FragColor = vec4(uv, 1.0, 1.0);
}
