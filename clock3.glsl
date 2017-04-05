// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

uniform sampler2D color_stops;
uniform sampler2D color_stops2;

float shape(vec2 uv, vec2 center, float size)
{
  float d = length(uv - center);
  d = 1.0 - d;

  return d;
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  float seconds = mod(iGlobalTime, 60.0);
  // float tenSeconds = mod(iGlobalTime, 100.0)/100.0;

  float secondsOnes = mod(seconds, 10.0);
  vec4 secondsColor = texture2D(color_stops2, vec2(sin(secondsOnes) * 0.5 + 0.5 / 10.0, 0.0));
  secondsColor *= shape(uv, vec2(1.0, 0.0), 1.0);

  float secondsTens = (seconds - secondsOnes) / 10.0;
  vec4 tenSecondsColor = texture2D(color_stops2, vec2(secondsTens / 10.0, 0.0));
  tenSecondsColor *= shape(uv, vec2(1.0, 1.0), 2.0);

  gl_FragColor = vec4(uv, 1.0, 1.0);
  gl_FragColor = secondsColor;// + tenSecondsColor;
  // gl_FragColor = tex;
}
