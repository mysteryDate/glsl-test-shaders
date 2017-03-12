// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

uniform vec3 DIGIT_COLORS[10];

// DIGIT_COLORS[0] = vec3(0.0, 0.0, 0.0);
// DIGIT_COLORS[1] = vec3(1.0, 0.0, 0.0);
// DIGIT_COLORS[2] = vec3(0.0, 1.0, 0.0);
// DIGIT_COLORS[3] = vec3(0.0, 0.0, 1.0);
// DIGIT_COLORS[4] = vec3(1.0, 1.0, 0.0);
// DIGIT_COLORS[5] = vec3(1.0, 0.0, 1.0);
// DIGIT_COLORS[6] = vec3(0.0, 1.0, 1.0);
// DIGIT_COLORS[7] = vec3(1.0, 1.0, 0.5);
// DIGIT_COLORS[8] = vec3(1.0, 0.5, 1.0);
// DIGIT_COLORS[9] = vec3(1.0, 1.0, 1.0);

// vec3 digitToColor(float digit) {

// }

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;
  uv.y = 1.0 - uv.y;
  uv.x = 1.0 - uv.x;

  float seconds = 60.0;
  seconds = 2.0;
  float secondHand = mod(iGlobalTime, seconds)/seconds;
  float minutes = 2.0 * seconds;
  float minuteHand = mod(iGlobalTime, minutes)/minutes;
  float hours = 2.0 * minutes;
  float hourHand = mod(iGlobalTime, hours)/hours;
  float colors = 5.0 * hours;
  float colorHand = mod(iGlobalTime, colors)/hours + 1.0;

  vec2 centerUV = uv - vec2(0.5);

  // angle of
  float phi = atan(centerUV.x, centerUV.y) / (2.0 * 3.14159) + 0.5;

  float definition = 6.;
  float secondPower = pow(1.0 - abs(2.*(secondHand - phi)), definition);
  float minutePower = pow(1.0 - abs(2.*(minuteHand - phi)), definition);
  float hourPower = pow(1.0 - abs(2.*(hourHand - phi)), definition);

  vec3 col = vec3(hourPower, minutePower, secondPower);

  gl_FragColor = vec4(col * colorHand, 1.0) * 1.0;
  // gl_FragColor = vec4(minutePower, 0., 0., 1.0);
  // gl_FragColor = vec4(secondPower, 0., 0., 1.0);
}
