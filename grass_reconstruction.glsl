// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

vec3 brightGrassColor = vec3(0.05, 0.1, 0.0) * 0.8;
vec3 darkGrassColor = vec3(0.0, 0.3, 0.0);

vec4 grass(vec2 p, float seed)
{
  float s = mix(0.7, 2.0, 0.5 + sin(seed * 22.0) * .5);
  p.x += pow(1.0 + p.y, 2.0) * 0.5 * cos(seed * 0.5 + iGlobalTime);
  p.x *= s;
  p.y = (1.0 + p.y) * s - 1.0;
  float m = 1.0 - smoothstep(0.0,
                             clamp(1.0 - p.y * 1.5, 0.01, 0.6),// * 0.2 * s,
                             pow(abs(p.x) * 19.0, 1.5) + p.y - 0.6);
  // return vec4(m * smoothstep(-1.0, -0.9, p.y));
  return vec4(
    mix(brightGrassColor,
        darkGrassColor,
        (p.y + 1.0) * 0.5 + abs(p.x)), 1.0) * m * smoothstep(-1.0, -0.9, p.y);
    // m * smoothstep(-1.0, -0.9, p.y));
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;
  vec2 position = vec2(0.5,1.0);
  float sizeInPercentage = 0.999;
  vec2 normalizedUV = (uv - position) / sizeInPercentage;

  vec4 outCol = grass(normalizedUV, 0.1);

  gl_FragColor = outCol;
}
