// vec2 u_resolution
// vec2 u_mouse
// float u_time

uniform sampler2D u_mainTex; // textures/cait.jpg

void main()
{
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;

  vec4 tex = texture2D(u_mainTex, uv);

  gl_FragColor = tex;
}
