// vec2 iResolution
// vec2 iMouse
// float iGlobalTime
#pragma glslify: hsv2rgb = require('./lib/hsv2rgb')
#pragma glslify: rgb2hsv = require('./lib/rgb2hsv')

uniform sampler2D u_mainTex; // textures/bdayballoon_blue.png
uniform sampler2D u_otherTex; // textures/bdayballoon_pink.png

mat3 rgb2YCgCo = mat3(0.25, -0.25, 0.5, 0.5, 0.5, 0.0, 0.25, -0.25, -0.5);
mat3 yCgCo2rgb = mat3(1.0, 1.0, 1.0, -1.0, 1.0, -1.0, 1.0, 0.0, -1.0);

vec3 colorMap(vec3 outColor, float luminance) {
  vec3 black = vec3(0.0);
  vec3 white = vec3(1.0);
  vec3 result = mix(black, outColor, smoothstep(0.4, 0.6, luminance));
  result = mix(result, white, smoothstep(0.7, 1.0, luminance));
  return result;
}

vec3 startColor = vec3(0.475, 0.753, 0.875);
vec3 replacementColor = vec3(0.816, 0.475, 0.718);
// vec3 replacementColor = vec3(1.0);
void main()
{
  vec3 hsvStart = rgb2hsv(startColor);
  vec3 hsvEnd = rgb2hsv(replacementColor);
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  vec4 tex = texture2D(u_mainTex, uv);
  vec4 background = vec4(fract(uv.x * 4.0), fract(uv.y * 4.0), 0.0, 1.0);

  float luminance = (rgb2YCgCo * tex.rgb).x;
  float value = rgb2hsv(tex.rgb).x;
  // tex.rgb += replacementColor - startColor;
  // tex.rgb = colorMap(replacementColor, luminance);
  // tex.rgb = replacementColor * value;
  vec3 hsv = rgb2hsv(tex.rgb);
  // hsv += hsvEnd - hsvStart;
  // if (hsv.g >= 0.5) {
    // hsv.b += hsvEnd.b - hsvStart.b;
    hsv.r += hsvEnd.r - hsvStart.r;
  // }
  // hsv.g += hsvEnd.g - hsvStart.g;
  tex.rgb = hsv2rgb(hsv);

  gl_FragColor = mix(background, tex, tex.a);

  vec4 tex2 = texture2D(u_otherTex, uv);
  // gl_FragColor = mix(background, tex2, tex2.a);
}
