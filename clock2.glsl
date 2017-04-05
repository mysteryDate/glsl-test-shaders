// vec2 iResolution
// vec2 iMouse
// float iGlobalTime
const float len = 0.5;

vec2 getCenter(float frequency)
{
  float t = frequency * iGlobalTime;
  return len * vec2(-cos(t), sin(t)) / 2.0 + vec2(0.5);
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  float len = 0.5;
  float circleSize = 0.3;
  float speedUp = 1.0;
  vec2 redCenter = getCenter(speedUp);
  vec2 greenCenter = getCenter(speedUp / 60.0);
  vec2 blueCenter = getCenter(speedUp / 60.0 / 60.0);

  float redDist = length(uv - redCenter);
  float greenDist = length(uv - greenCenter);
  float blueDist = length(uv - blueCenter);

  float red = smoothstep(circleSize, circleSize - 0.1, redDist);
  float green = smoothstep(circleSize, circleSize - 0.1, greenDist);
  float blue = smoothstep(circleSize, circleSize - 0.1, blueDist);

  red *= pow(length(uv - vec2(0.5)), 2.0) * 5.;
  green *= pow(length(uv - vec2(0.5)), 2.0) * 5.;
  blue *= pow(length(uv - vec2(0.5)), 2.0) * 5.;

  // gl_FragColor = vec4(1.0) - vec4(red, green, blue, 1.0);
  gl_FragColor = vec4(red, green, blue, 1.0);
  // gl_FragColor = vec4(red, 0.0, 0.0, 1.0);
}
