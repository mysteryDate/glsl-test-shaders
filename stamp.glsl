// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

uniform sampler2D heart_unbroken;
uniform sampler2D perlin_noise;

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

vec4 getBlurredPixel(vec2 st, sampler2D texture, float amt) {
  vec4 right = texture2D(texture, st + amt * vec2(1.0,  0.0));
  vec4 left  = texture2D(texture, st + amt * vec2(-1.0, 0.0));
  vec4 up    = texture2D(texture, st + amt * vec2(0.0,  1.0));
  vec4 down  = texture2D(texture, st + amt * vec2(0.0, -1.0));

  return (right + left + up + down) / 4.0;
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;
  // float noisey = valuenoise(uv * 100.0 * iMouse.y);
  float noisey = valuenoise(uv * 80.0);

  float slope = -1000.0;
  float intercept = 0.0;
  float distanceToLine = abs(slope * uv.x - uv.y + intercept) / sqrt(slope * slope + 1.0);

  noisey = smoothstep(distanceToLine + 0.2, distanceToLine, noisey);

  vec4 color = vec4(1.0) - vec4(0.74, 0.07, 0.03, 1.0);

  vec4 heartTex = texture2D(heart_unbroken, uv);
  vec4 blurredPix = getBlurredPixel(uv, heart_unbroken, 0.008 * distanceToLine);
  gl_FragColor = vec4(1.0) - color * noisey * (heartTex.a + 2.0 * blurredPix.a)/2.0;

}
