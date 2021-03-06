//////////////////////
// Fire Flame shader

// procedural noise from IQ
// https://www.shadertoy.com/view/Xd3GD4

uniform sampler2D u_mainTex; // textures/zipper_slider.png
vec2 hash(vec2 p)
{
  p = vec2(dot(p, vec2(127.1, 311.7)),
       dot(p, vec2(269.5, 183.3)));
  return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(in vec2 p)
{
  const float K1 = 0.366025404; // (sqrt(3) - 1)/2;
  const float K2 = 0.211324865; // (3 - sqrt(3))/6;

  vec2 i = floor(p + (p.x + p.y) * K1);

  vec2 a = p - i + (i.x + i.y) * K2;
  vec2 o = (a.x>a.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec2 b = a - o + K2;
  vec2 c = a - 1.0 + 2.0 * K2;

  vec3 h = max(0.5 - vec3(dot(a, a), dot(b, b), dot(c, c)), 0.0);

  vec3 n = h * h * h * h * vec3(dot(a, hash(i + 0.0)), dot(b, hash(i + o)), dot(c, hash(i + 1.0)));

  return dot(n, vec3(70.0));
}

float fbm(vec2 uv)
{
  float f;
  mat2 m = mat2(1.6, 1.2, -1.2, 1.6);
  f  = 0.5000 * noise(uv); uv = m * uv;
  f += 0.2500 * noise(uv); uv = m * uv;
  f += 0.1250 * noise(uv); uv = m * uv;
  f += 0.0625 * noise(uv); uv = m * uv;
  f = 0.5 + 0.5 * f;
  return f;
}

// A reddish to white glow based energy
vec3 blackBodyRadiation(float c)
{
  return vec3(1.5*c, 1.5*c*c*c, c*c*c*c*c*c);
}

// no defines, standard redish flames
// #define BLUE_FLAME
// #define GREEN_FLAME

void main()
{
  vec2 uv = gl_FragCoord.xy / iResolution.xy;
  vec4 tex = texture2D(u_mainTex, uv * 2.0 - vec2(0.5, 0.0));
  vec2 q = uv;
  // q.x *= 5.0;
  // q.x += fract(u_time / 10.0) * 4.0;
  q.x += 2.0;
  q.y *= 2.0;
  float strength = floor(q.x + 1.0);
  float T3 = max(3.0, 1.25 * strength) * u_time;
  // float T3 = max(3.0, 1.25 * strength);
  q.x = mod(q.x, 1.0) - 0.5;
  q.y -= 0.25;
  float noise = fbm(strength * q - vec2(0.0, T3));
  float flameShape = 1.0 - 16.0 * pow(max(0.0, length(q * vec2(1.8 + q.y * 1.5, 0.75)) - noise * max(0.0, q.y +  0.25)), 1.2);
  // float flameWithSmoke = noise * flameShape * (1.5 - pow(1.25 * uv.y, 4.0));
  float flameWithSmoke = noise * flameShape * (1.5 - pow(2.50 * uv.y, 4.0));
  flameWithSmoke = clamp(flameWithSmoke, 0.0, 1.0);


  vec3 col = blackBodyRadiation(flameWithSmoke);
  col = mix(col, pow(vec3(1.0 - clamp(flameWithSmoke, -1.0, 0.0)) * pow(fbm(strength * q * 1.25 - vec2(0, T3)), 2.0), vec3(2.0)), 0.75 - (col.x + col.y + col.z)/3.0); // Just added this line!!! :)

#ifdef BLUE_FLAME
  col = col.zyx;
#endif
#ifdef GREEN_FLAME
  col = 0.85 * col.yxz;
#endif

  float mask = flameShape * (1.0 - pow(uv.y, 3.0));
  vec4 finalColor = vec4(mix(vec3(0.0), col, mask), 1.0);
  // finalColor = vec4(flameWithSmoke) + vec4(length(tex)/4.0);
  gl_FragColor = finalColor;
}
