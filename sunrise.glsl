// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

uniform sampler2D u_mainTex; // textures/wood.jpg

// Created by @pheeelicks
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

void main()
{
  vec2 st = gl_FragCoord.xy/iResolution.x - 0.5;

  gl_FragColor=texture2D(u_mainTex,mod(vec2(atan(st.y,st.x),.3)+.02*u_time, 1.0))/length(4.7*st);
}
