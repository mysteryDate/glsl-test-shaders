// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

uniform sampler2D heart_unbroken;
uniform sampler2D perlin_noise;
uniform sampler2D ford;

vec2 random2(vec2 st){
    st = vec2( dot(st,vec2(0.040,-0.250)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.633);
}

// Value Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float valuenoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = smoothstep(0.0, 1.0, f);

    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;
  uv.x *= .7;
  uv += vec2(0.1);
  float noisey = valuenoise(uv * 50.0);

  float LOW_THRESHOLD = 0.2;
  float THRESHOLD = 0.5;
  float fade = 0.2;

  // vec2 center = normalize(vec2(-1.0, .0));
  // float  d = 1.0/pow(distance(uv.xy,center),.5);
  // d -= max(0.1, sin(iGlobalTime));
  // d *= 3.5;
  float d = 2.0 * (iMouse.x - 0.45);
  // d = sin(iGlobalTime) + 0.5;
  d = 1.0;
  // d *= 1.0/distance(uv.xy, iMouse.xy);
  // d *= 1.0/pow(distance(uv.xy,vec2(0., iMouse.y)),3.);
  noisey = smoothstep(d + 0.2, d, noisey);

  vec4 color = vec4(1.0) - vec4(0.74, 0.07, 0.03, 1.0);

  vec4 heartTex = texture2D(ford, uv);
  // float heart2 = texture2D(ford, uv + 7.0 * iMouse.x * valuenoise(uv * 10.0 + iGlobalTime) * vec2(.01, 0.0)).a;
  // float heart3 = texture2D(ford, uv + 7.0 * iMouse.x * valuenoise(uv * 10.0 + iGlobalTime) * vec2(-.01, 0.0)).a;
  // float heart4 = texture2D(ford, uv + 7.0 * iMouse.x * valuenoise(uv * 10.0 + iGlobalTime) * vec2(0.0, 0.01)).a;
  // float heart5 = texture2D(ford, uv + 7.0 * iMouse.x * valuenoise(uv * 10.0 + iGlobalTime) * vec2(0.0, -0.01)).a;
  vec4 heart2 = texture2D(ford, uv + 100.0 * iMouse.x * valuenoise(uv * 20.0 * iMouse.y + iGlobalTime) * vec2(.01, 0.0));
  vec4 heart3 = texture2D(ford, uv + 100.0 * iMouse.x * valuenoise(uv * 20.0 * iMouse.y + iGlobalTime) * vec2(-.01, 0.0));
  vec4 heart4 = texture2D(ford, uv + 400.0 * iMouse.x * valuenoise(uv * 20.0 * iMouse.y + iGlobalTime) * vec2(0.0, 0.01));
  vec4 heart5 = texture2D(ford, uv + 100.0 * iMouse.x * valuenoise(uv * 20.0 * iMouse.y + iGlobalTime) * vec2(0.0, -0.01));

  vec4 trans = (heart2 + heart3 + heart4 + heart5)/4.0;

  // gl_FragColor = vec4(1.0) - color * noisey * trans;
  gl_FragColor = trans;
  gl_FragColor = vec4(heart2.r, heart3.g, heart4.b, 1.0);
  // gl_FragColor = vec4(heartTex.rg, heart4.b, 1.0);
  // gl_FragColor = heartTex;
  // gl_FragColor = vec4(1.0, 0., 1., 1.) * d;
}
