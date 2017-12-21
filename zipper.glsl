// vec2 u_resolution
// vec2 u_mouse
// float u_time

uniform sampler2D u_leftZipperTex; // textures/zipper_left.png
uniform sampler2D u_rightZipperTex; // textures/zipper_right.png


const float zipperWidth = 0.015;
void main()
{
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;
  uv *= 2.0;
  uv.y = mod(uv.y, 0.998);

  vec2 leftUV = uv - vec2(zipperWidth, 0.0);
  vec4 leftZipper = texture2D(u_leftZipperTex, leftUV);
  leftZipper *= leftZipper.a;

  vec2 rightUV = uv - vec2(1.0 - zipperWidth, 0.0);
  vec4 rightZipper = texture2D(u_rightZipperTex, rightUV);
  rightZipper *= rightZipper.a;

  gl_FragColor = leftZipper;
  gl_FragColor = rightZipper;
  gl_FragColor = leftZipper + rightZipper;
}
