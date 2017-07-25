// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

vec2 vec2Random(vec2 st) {
  st = vec2(dot(st, vec2(0.040,-0.250)),
  dot(st, vec2(269.5,183.3)));
  return -1.0 + 2.0 * fract(sin(st) * 43758.633);
}

float gradientNoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = smoothstep(0.0, 1.0, f);

    return mix(mix(dot(vec2Random(i + vec2(0.0,0.0)), f - vec2(0.0,0.0)),
                   dot(vec2Random(i + vec2(1.0,0.0)), f - vec2(1.0,0.0)), u.x),
               mix(dot(vec2Random(i + vec2(0.0,1.0)), f - vec2(0.0,1.0)),
                   dot(vec2Random(i + vec2(1.0,1.0)), f - vec2(1.0,1.0)), u.x), u.y);
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;
  float size = 200.0;

  float d = pow(length(uv.x - 0.5), 0.0);

  float col = gradientNoise(uv * vec2(d, 10.0));
  // float col2 = gradientNoise(size * vec2(d, uv.y));

  gl_FragColor = vec4(col);
}
