// vec2 u_resolution
// vec2 u_mouse
// float u_time

uniform sampler2D u_leftZipperTex; // textures/zipper_left.png
uniform sampler2D u_rightZipperTex; // textures/zipper_right.png


const float zipperWidth = 0.015;
void main()
{
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;
  vec2 tiledUV = uv * 2.0;
  tiledUV.y = mod(tiledUV.y, 1.0);

  vec2 leftUV = tiledUV - vec2(zipperWidth, 0.0);
  vec2 rightUV = tiledUV - vec2(1.0 - zipperWidth, 0.0);

  float zipAmount = pow(10.0, 2.0 * uv.y - 4.0 + 2.0 * (sin(u_time) + 1.0));
  // float zipAmount = pow(10.0, 2.0 * uv.y - 1.7);
  leftUV.x += zipAmount;
  rightUV.x -= zipAmount;
  leftUV.x = min(leftUV.x, 1.0);
  rightUV.x = max(rightUV.x, 0.0);
  // leftUV.y += pow(zipAmount, 2.0);
  // leftUV.y = min(leftUV.y, 1.0);
  // rightUV.y =
  // leftUV.x *= (1.0 - leftUV.x);

  vec4 leftZipper = texture2D(u_leftZipperTex, leftUV);
  leftZipper *= leftZipper.a;
  vec4 rightZipper = texture2D(u_rightZipperTex, rightUV);
  rightZipper *= rightZipper.a;

  gl_FragColor = leftZipper;
  gl_FragColor = rightZipper;
  gl_FragColor = leftZipper + rightZipper;
}
