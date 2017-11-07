#pragma glslify: hsv2rgb = require('./lib/hsv2rgb')
#pragma glslify: rgb2hsv = require('./lib/rgb2hsv')

uniform sampler2D u_mainTex; // textures/bokeh-background.jpg

mat3 RGB2SEPIA = mat3(
        0.393, 0.349, 0.272,
        0.769, 0.686, 0.534,
        0.189, 0.168, 0.131);

mat3 GLAM_FILTER = mat3(
        0.000, 0.000, 0.000,
        0.525, 0.455, 0.271,
        0.300, 0.300, 0.300);

mat3 GLAM_FILTER_2 = mat3(
        0.000, 0.000, 0.000,
        0.000, 0.000, 0.000,
        0.500, 0.500, 0.500);

        /*
        r2r, r2g, r2b,
        g2r, g2g, g2b,
        b2r, b2g, b2b,

        */
mat3 TEST = mat3(
        0.0, 1.0, 0.0,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0);

vec3 gold = vec3(0.965, 0.824, 0.365);
vec3 black = vec3(0.0);
vec3 silver = vec3(0.5);
float transAmt = 0.30;
vec3 colorMap(float x) {
  vec3 result = mix(black, silver, smoothstep(0.33 - transAmt, 0.33 + transAmt, x));
  result = mix(result, gold, smoothstep(0.66 - transAmt, 0.66 + transAmt, x));
  return result;
}


void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  vec4 tex = texture2D(u_mainTex, uv);

  vec3 hsvColor = rgb2hsv(tex.rgb);
  vec3 color = colorMap(smoothstep(0.4, 0.9, tex.g));
  // hsvColor.r += 0.5;
  // hsvColor.r += sin(u_time) / 2.0;
  // hsvColor.r = smoothstep(0.4, 0.4, hsvColor.r);
  // vec3 color = hsv2rgb(hsvColor);

  gl_FragColor = vec4(color, 1.0);
}
