// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

uniform sampler2D cait;
uniform float array[2];

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  float blurSize = 0.005;

  vec4 sum = vec4(0.0);
  sum += texture2D(cait, vec2(uv.x - blurSize * 4.0, uv.y)) * 0.05;
  sum += texture2D(cait, vec2(uv.x - blurSize * 3.0, uv.y)) * 0.09;
  sum += texture2D(cait, vec2(uv.x - blurSize * 2.0, uv.y)) * 0.12;
  sum += texture2D(cait, vec2(uv.x - blurSize * 1.0, uv.y)) * 0.15;
  sum += texture2D(cait, vec2(uv.x + blurSize * 0.0, uv.y)) * 0.18;
  sum += texture2D(cait, vec2(uv.x + blurSize * 1.0, uv.y)) * 0.15;
  sum += texture2D(cait, vec2(uv.x + blurSize * 2.0, uv.y)) * 0.12;
  sum += texture2D(cait, vec2(uv.x + blurSize * 3.0, uv.y)) * 0.09;
  sum += texture2D(cait, vec2(uv.x + blurSize * 4.0, uv.y)) * 0.05;

  gl_FragColor = sum;
}
