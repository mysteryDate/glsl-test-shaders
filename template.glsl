// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

uniform sampler2D ghost_1; // ../../web/textures/ghost_1.png

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  vec4 tex = texture2D(bdayballoon_blue, uv);

  gl_FragColor = tex;
}
