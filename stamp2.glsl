uniform sampler2D testTextTexture;
uniform sampler2D stamp_bubble2;

vec2 random2(vec2 st){
  st = vec2( dot(st,vec2(0.040,-0.250)),
            dot(st,vec2(269.5,183.3)) );
  return -1.0 + 2.0*fract(sin(st)*43758.633);
}

// Value Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float gradientnoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = smoothstep(0.0, 1.0, f);

    return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

float cubicPulse( float c, float w, float x ){
  x = abs(x - c);
  if( x>w ) return 0.0;
  x /= w;
  return 1.0 - x*x*(3.0-2.0*x);
}

void main()
{
  vec2 v_uv = gl_FragCoord.xy/iResolution.xy;
  float transparency = 1. - texture2D(testTextTexture, v_uv).a;
  transparency -= texture2D(stamp_bubble2, vec2(1. - v_uv.x, v_uv.y)).a;
  float random = gradientnoise(v_uv * 40.0);

  float fade = 0.2;

  // vec2 center = normalize(vec2(-1.0, .0));
  vec2 center = (vec2(iMouse.x) - vec2(0.5)) * 5.;
  float  d = 1.0/pow(distance(v_uv.xy,center), iMouse.y);
  float stampAmount = smoothstep(d - fade, d, random + 1.);

  vec4 color = vec4(0.74, 0.07, 0.03, 1.0);

  gl_FragColor = mix(vec4(1,1,1,1), color, stampAmount * transparency);
  // gl_FragColor = vec4(stampAmount);
  // gl_FragColor = vec4(1.0, 0.0, 1.0, 1.0);
}
