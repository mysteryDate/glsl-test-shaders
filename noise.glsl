// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

#define PI 3.14159265359

float random(vec2 x) {
  return fract(sin(dot(x, vec2(12.9898,78.233) * 43758.545312)));
}

vec2 random2(vec2 st){
    st = vec2( dot(st,vec2(0.040,-0.250)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.633);
}

// float random(float x) {
//   return fract(sin(x) * 100000.0);
// }

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    // vec2 u = f*f*(3.0-2.0*f);
    vec2 u = smoothstep(0.,1.,f);

    // Mix 4 coorners porcentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

// Value Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float valuenoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = f*f*(3.0-2.0*f);
    u = smoothstep(0.0, 1.0, f);

    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

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

void main() {
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  float col = gradientNoise(uv * 20.0);



  float d = 2.0 * (iMouse.x - 0.45);
  float q = iMouse.y;
  // col = smoothstep(d, d + 0.2, col);
  // col = smoothstep(.0, .1, col);
  // col = smoothstep(-.2,-.1,uv.x);

  gl_FragColor = vec4(col);
  if(col > 0.64) {
    gl_FragColor = vec4(1.0, 0.0, 1.0, 1.0);
  }

  // gl_FragColor = vec4(col);
}
