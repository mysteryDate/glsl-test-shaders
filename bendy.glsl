// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

uniform sampler2D effects_thumb_birthdayCakeBlue;
uniform sampler2D blossom;
uniform sampler2D blossoms2;
const vec2 center = vec2(0., .83);
const vec2 center2 = vec2(1., 0.15);

vec2 twistUV(vec2 st, vec2 center, float phase, float amt) {

  vec2 shiftedUv = st - center;
  float d = length(shiftedUv);
  float angle = d * sin(iGlobalTime + phase) * amt;
  mat2 rotationMat = mat2(cos(angle), sin(angle), -sin(angle), cos(angle));
  shiftedUv = rotationMat * shiftedUv;
  return shiftedUv + center;
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;
  vec2 uv1 = uv;
  uv1.x /= 2.0;

  uv1 = twistUV(uv1, center, 0.0, 1.0);

  vec4 tex = texture2D(blossom, uv1);
  if(uv1.y > 1.0) {
    tex.a = 0.0;
  }
  tex *= tex.a;

  vec2 uv2 = uv;
  uv2 *= 2.0 - vec2(1.0);
  uv2 = twistUV(uv2, center2, 2.1, 0.05);
  vec4 tex2 = texture2D(blossoms2, uv2);
  if(uv2.y > 1.0) {
    tex2.a = 0.0;
  }
  tex2 *= tex2.a;

  if (tex.a > 0.1) {
    gl_FragColor = tex;
  }
  else {
    gl_FragColor = tex2;
  }
  // if(length(uv - center2) < 0.01) {
  //   gl_FragColor = vec4(1., 0., 1., 1.);
  // }
}
