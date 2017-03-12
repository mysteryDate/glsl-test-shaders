// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

float laser(vec2 uv, float pos, float theta) {
  // y-coordinate of center of laser at this x-coordinate
  float yCenter = (uv.x + pos - 0.5) / tan(theta) + 1.0;
  // y-distance from line at this uv
  float yDist = uv.y - yCenter;
  // distance to laser
  float dist = yDist * sin(theta);
  return 1.0 - abs(dist);
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution;

  float a = 0.0;
  float theta = 0.2;

  float laser1 = laser(uv, a, theta);

  gl_FragColor = vec4(laser1);
}
