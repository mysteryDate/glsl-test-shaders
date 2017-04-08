// #define BLADES 110
vec4 hillColors[3];

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

vec4 hills(vec2 st)
{
  hillColors[0] = vec4(0.38, 0.58, 0.29, 1.0);
  hillColors[1] = vec4(0.44, 0.65, 0.33, 1.0);
  hillColors[2] = vec4(0.46, 0.70, 0.35, 1.0);

  vec4 col = vec4(0.0);

  if(sin(3. * (st.x - 0.324))/5. + 0.280 > st.y) {
    col = hillColors[2];
  }
  else if((sin(2.416 * (st.x + 0.6))/6. + 0.456 > st.y)) {
    col = hillColors[1];
  }
  else if((sin(1.944 * (st.x + 0.000))/6. + 0.520 > st.y)) {
    col = hillColors[0];
  }
  return col;
}

// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

vec3 brightGrassColor = vec3(0.05, 0.1, 0.0) * 0.8;
vec3 darkGrassColor = vec3(0.0, 0.3, 0.0);

vec4 grass(vec2 p, float x)
{
  float s = mix(0.7, 2.0, 0.5 + sin(x * 22.0) * .5);
  p.x += pow(1.0 + p.y, 2.0) * 0.1 * cos(x * 0.5 + iGlobalTime);
  p.x *= s;
  p.y = (1.0 + p.y) * s - 1.0;
  float m = 1.0 - smoothstep(0.0,
                             clamp(1.0 - p.y * 1.5, 0.01, 0.6) * 0.2 * s,
                             pow(abs(p.x) * 19.0, 1.5) + p.y - 0.6);
  return vec4(
    mix(brightGrassColor,
        darkGrassColor,
        (p.y + 1.0) * 0.5 + abs(p.x)),
    m * smoothstep(-1.0, -0.9, p.y));
}
#define BLADES 32

void main()
{
  vec2 u_resolution = iResolution.xy;
  vec2 v_uv = gl_FragCoord.xy/iResolution;
  vec2 position = vec2(0.0,-0.2);
  float aspectRatio = u_resolution.x/u_resolution.y;

  // Independent of message size
  float sizeInPix = 400.0;
  vec2 normalizedUV = v_uv*u_resolution/sizeInPix - position;
  // grass grows with message
  float sizeInPercentage = 0.1;
  normalizedUV = (v_uv - position) / sizeInPercentage - vec2(0.0, 1.)/sizeInPercentage;
  normalizedUV.x *= aspectRatio;

  vec4 fcol = vec4(0.);

  for(int i = 0; i < BLADES; i += 1)
  {
    float z = float(BLADES - i);
    vec2 tc = normalizedUV * pow(z, 0.1);

    // This makes the grass arragnement more chaotic
    // tc.x += cos(float(i) * 200.);


    float cell = floor(tc.x);

    tc.x = (tc.x - cell) - 0.5;

    vec4 c = grass(tc, float(i) + cell);

    fcol = mix(fcol, c * 2.280, c.w);
  }

  gl_FragColor = fcol;
}
