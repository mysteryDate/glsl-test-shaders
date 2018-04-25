#pragma glslify: getRandomFloat = require('./lib/getRandomFloat')
uniform sampler2D iChannel0; // textures/space-text.jpg

// From https://www.shadertoy.com/view/XslGDr
vec3 highlights(vec3 pixel, float thres)
{
  float val = (pixel.x + pixel.y + pixel.z) / 3.0;
  return pixel * smoothstep(thres - 0.1, thres + 0.1, val);
}

vec3 samplef(vec2 tc)
{
  return pow(texture2D(iChannel0, tc).xyz, vec3(0.9));
}

vec3 hsample(vec2 tc)
{
  return highlights(samplef(tc), 0.3);
}

vec3 blur(vec2 tc, float offs)
{
  vec4 xoffs = offs * vec4(-2.0, -1.0, 1.0, 2.0) / iResolution.x;
  vec4 yoffs = offs * vec4(-2.0, -1.0, 1.0, 2.0) / iResolution.y;

  vec3 color = vec3(0.0, 0.0, 0.0);
  color += hsample(tc + vec2(xoffs.x, yoffs.x)) * 0.00366;
  color += hsample(tc + vec2(xoffs.y, yoffs.x)) * 0.01465;
  color += hsample(tc + vec2(    0.0, yoffs.x)) * 0.02564;
  color += hsample(tc + vec2(xoffs.z, yoffs.x)) * 0.01465;
  color += hsample(tc + vec2(xoffs.w, yoffs.x)) * 0.00366;

  color += hsample(tc + vec2(xoffs.x, yoffs.y)) * 0.01465;
  color += hsample(tc + vec2(xoffs.y, yoffs.y)) * 0.05861;
  color += hsample(tc + vec2(    0.0, yoffs.y)) * 0.09524;
  color += hsample(tc + vec2(xoffs.z, yoffs.y)) * 0.05861;
  color += hsample(tc + vec2(xoffs.w, yoffs.y)) * 0.01465;

  color += hsample(tc + vec2(xoffs.x, 0.0)) * 0.02564;
  color += hsample(tc + vec2(xoffs.y, 0.0)) * 0.09524;
  color += hsample(tc + vec2(    0.0, 0.0)) * 0.15018;
  color += hsample(tc + vec2(xoffs.z, 0.0)) * 0.09524;
  color += hsample(tc + vec2(xoffs.w, 0.0)) * 0.02564;

  color += hsample(tc + vec2(xoffs.x, yoffs.z)) * 0.01465;
  color += hsample(tc + vec2(xoffs.y, yoffs.z)) * 0.05861;
  color += hsample(tc + vec2(    0.0, yoffs.z)) * 0.09524;
  color += hsample(tc + vec2(xoffs.z, yoffs.z)) * 0.05861;
  color += hsample(tc + vec2(xoffs.w, yoffs.z)) * 0.01465;

  color += hsample(tc + vec2(xoffs.x, yoffs.w)) * 0.00366;
  color += hsample(tc + vec2(xoffs.y, yoffs.w)) * 0.01465;
  color += hsample(tc + vec2(    0.0, yoffs.w)) * 0.02564;
  color += hsample(tc + vec2(xoffs.z, yoffs.w)) * 0.01465;
  color += hsample(tc + vec2(xoffs.w, yoffs.w)) * 0.00366;

  return color;
}

void main()
{
  vec2 uv = gl_FragCoord.xy / iResolution.xy;
  float offset = iMouse.y * iResolution.y / 100.0;
  vec3 color = blur(uv, offset);

  color += samplef(uv);
  vec2 noiseDensity = 1.0 / vec2(0.01, 1.0);
  float noiseSpeed = 0.031;
  float cellSize = 0.003;
  vec2 noiseUV = floor(uv / cellSize) * cellSize;
  float r = smoothstep(0.9, 1.0, getRandomFloat(-noiseUV * noiseDensity + 1.2 * noiseSpeed * u_time));
  float g = smoothstep(0.9, 1.0, getRandomFloat(noiseUV * noiseDensity + noiseSpeed * u_time));
  float b = smoothstep(0.9, 1.0, getRandomFloat(noiseUV * noiseDensity + 1.8 * noiseSpeed * u_time));
  vec3 noise = vec3(r, g, b) * iMouse.y * 0.5;
  color += noise;

  float div_pos = iMouse.x;
  float divider = smoothstep(div_pos - 0.01, div_pos + 0.01, uv.x);
  vec4 original = texture2D(iChannel0, uv);
  color = mix(original.rgb, color, divider);
  color = mix(color, vec3(1.0, 0.0, 1.0), 1.0 - 2.0 * abs(0.5 - divider));
  gl_FragColor = vec4(color, 1.0);

}
