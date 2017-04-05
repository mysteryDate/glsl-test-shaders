// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

uniform sampler2D cait;

vec2 random(vec2 st){
    st = vec2( dot(st,vec2(0.040,-0.250)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.633);
}

// Value Noise by Inigo Quilez - iq/2013
// https://www.shadertoy.com/view/lsf3WH
float valuenoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = f*f*(3.0-2.0*f);
    u = smoothstep(0.0, 1.0, f);

    return mix( mix( dot( random(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                     dot( random(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                mix( dot( random(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                     dot( random(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  // float d = length(uv - vec2(fract(iGlobalTime), fract(iGlobalTime / 10.0)));
  vec2 pt = vec2(valuenoise(uv*iGlobalTime*100.), valuenoise(uv.yx*iGlobalTime*10.));
  vec2 st = floor(uv * 5.0) / 5.0;
  // vec2 st = floor(gl_FragCoord.xy);
  float d = length(st - pt);

  d *= 2.0;
  d = 1.0 - d;
  // d = floor(d * 5.0) / 5.0;

  // float noise = valuenoise(vec2(uv.x, uv.y) * 10.0) *  sin(iGlobalTime);

  // vec4 tex = texture2D(cait, uv);

  // gl_FragColor = vec4(uv, 1.0, 1.0);
  gl_FragColor = vec4(d);
}
