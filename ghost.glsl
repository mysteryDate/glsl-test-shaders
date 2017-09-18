// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

#define PI 3.14159
uniform sampler2D ghost_1; // ../../web/textures/ghost_1.png
uniform sampler2D background; // ../../web/textures/halloween_background.jpg

vec2 getRandomVec2(vec2 seed) {
  seed = vec2(dot(seed, vec2(0.040,-0.250)),
  dot(seed, vec2(269.5,183.3)));
  return -1.0 + 2.0 * fract(sin(seed) * 43758.633);
}

float gradientNoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = smoothstep(0.0, 1.0, f);

    return mix(mix(dot(getRandomVec2(i + vec2(0.0,0.0)), f - vec2(0.0,0.0)),
                   dot(getRandomVec2(i + vec2(1.0,0.0)), f - vec2(1.0,0.0)), u.x),
               mix(dot(getRandomVec2(i + vec2(0.0,1.0)), f - vec2(0.0,1.0)),
                   dot(getRandomVec2(i + vec2(1.0,1.0)), f - vec2(1.0,1.0)), u.x), u.y);
}

// float sinSDF()

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;
  vec2 st = (uv - 0.25) * 2.0;
  st.y *= iResolution.y/iResolution.x;
  st.y *= 0.7 + gradientNoise(vec2(u_time/5.3))/2.0;
  st.y += 1.5;

  float offset = cos(st.y * PI + u_time) * 0.1;

  st.y -= mod(u_time/4.0, 3.0);

  st.x += gradientNoise(vec2(u_time/2.0 + st.x / 1.0))/10.0;
  st.x += offset;
  // st.y += gradientNoise(vec2(u_time + st.y / 1.0))/8.0;

  vec4 tex = texture2D(ghost_1, st);
  tex.a *= 0.5 + gradientNoise(vec2(u_time/2.0 + st.x * 2., st.y * 2. + u_time))/1.0;

  vec4 background = texture2D(background, uv);
  gl_FragColor = tex * tex.a + background * (1.0 - tex.a);
  // gl_FragColor = vec4(offset);
}
