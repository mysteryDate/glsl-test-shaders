#pragma glslify: map = require('./lib/map')
#pragma glslify: valueNoise = require('./lib/valueNoise')

uniform sampler2D u_mainTex; // textures/wood.jpg

// Created by @pheeelicks
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

float clamp01(float x) {
  return clamp(x, 0.0, 1.0);
}

// http://iquilezles.org/www/articles/functions/functions.htm
float gain(float x, float k) {
  float a = 0.5*pow(2.0*((x<0.5)?x:1.0-x), k);
  return (x<0.5)?a:1.0-a;
}

// https://thebookofshaders.com/13/
const mat2 rotation = mat2(
  cos(0.5), sin(0.5),
  -sin(0.5), cos(0.5)
);
float fbm(vec2 st) {
  float value = 0.0;
  float amplitude = 0.7;
  vec2 shift = vec2(100.0);
  for (int i = 0; i < 5; i++) {
    value += amplitude * map(valueNoise(st), -1.0, 1.0, 0.0, 1.0);
    st = rotation * st;
    st *= 2.0;
    st += shift;
    amplitude *= 0.5;
  }
  value /= 1.5;
  return value;
}

vec4 cloud(vec2 st, float t) {
  vec2 q = vec2(0.0);
  q.x = fbm(st);
  q.y = fbm(st + 1.0);

  vec2 r = vec2(0.0);
  r.x = fbm(st + q + vec2(1.7, 9.2) + 0.15 * t);
  r.y = fbm(st + q + vec2(8.3, 2.8) + 0.13 * t);

  float f = fbm(st + r);

  vec3 color = vec3(1.0);
  color = mix(color, vec3(0.7), clamp01(length(q)));
  color = mix(color, vec3(0.9), clamp01(r.x));

  float alpha = gain(f, 12.0);
  alpha = clamp01(alpha);

  return vec4(vec3(1.0), alpha);
}

const float texHeight = 0.3;
const float speed = 0.06;
const float sunSize = 0.3;

const vec3 blue = vec3(0.314, 0.396, 0.706);
const vec3 red = vec3(0.592, 0.180, 0.184);
const vec3 yellow = vec3(0.965, 0.824, 0.365);
const float riseTime = 16.0;
void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.x;
  vec2 sunriseUV = uv;
  sunriseUV.x -= 0.5; // Shift the sun to the center
  float sunHeight = map(pow(mod(u_time, riseTime), 0.33), 0.0, pow(riseTime, 0.33), -2.0, 0.1);
  sunriseUV.y -= sunHeight; // Move
  float theta = atan(sunriseUV.y, sunriseUV.x); // Range [-pi, pi]
  vec2 st = mod(vec2(theta, texHeight) + speed * u_time, 1.0);
  float brightness = sunSize / length(sunriseUV);
  vec4 sun = texture2D(u_mainTex, st);

  float colorStop = (sunriseUV.y + sunriseUV.x * sunriseUV.x);
  vec3 bgColor = mix(blue, blue * 0.5, clamp(colorStop/2.0 - 0.5, 0.0, 1.0));
  bgColor = mix(red, bgColor, clamp(colorStop * 1.5 - 0.5, 0.0, 1.0));
  bgColor = mix(yellow, bgColor, clamp(2.0 * colorStop, 0.0, 1.0));

  uv.x *= u_resolution.x / u_resolution.y;

  float t = u_time;

  vec2 repeat = vec2(2.0, 10.0);
  vec2 offset = vec2(15.0);
  float scrollSpeed = 0.04;
  float warpSpeed = 0.4;

  offset.x += t * scrollSpeed;

  st = uv * repeat + offset;

  vec4 cloudColor = cloud(st, t * warpSpeed);

  cloudColor.a *= map(uv.y, 0.2, 1.0, 0.0, 1.0);
  cloudColor.a = clamp01(cloudColor.a);

  vec3 color = mix(vec3(0.0), cloudColor.rgb, cloudColor.a);

  vec4 cloud = vec4(color, cloudColor.a);

  cloud.a = pow(length(sunriseUV - uv), 1.0) * (1.0 - 0.8 * smoothstep(-0.4, 0.1, sunHeight));
  cloud.rgb *= min(pow(1.0/length(sunriseUV - uv), 3.0), 2.0);

  gl_FragColor = mix(sun * brightness + vec4(bgColor, 1.0), cloud, cloud.a);
}
