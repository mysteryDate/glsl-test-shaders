// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

// uniform vec3 u_color;
// varying vec2 v_uv;
// varying float v_seed;
const vec2 CENTER = vec2(0.5, 0.2);
const float LUMPINESS = 1.0;
const float PI = 3.141592;

float map(float value, float inMin, float inMax, float outMin, float outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
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

void main()
{
  vec2 v_uv = gl_FragCoord.xy/iResolution.xy;

  vec2 fromCenter = v_uv - CENTER;

  float radius = length(fromCenter);
  radius *= 2.0; // now 0 to 1 at edges (sqrt2 at corners)

  float theta = atan(fromCenter.y, fromCenter.x); // 0 to 2PI
  // TODO: mirror theta, to avoid the "noise seam"

  float radiusThreshold = gradientNoise(vec2(theta*LUMPINESS, v_uv.x));
  radiusThreshold = map(radiusThreshold, -1.0, 1.0, 0.5, 1.0);
  radiusThreshold = 1.;
  vec2 hairDirection = vec2(0., 1.0);
  float amt = dot(fromCenter, hairDirection) + 0.5;
  amt = v_uv.y - CENTER.y;
  // radiusThreshold *= pow(amt, 1.0);

  if (radius > radiusThreshold) {
    discard;
  }

  gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
  // gl_FragColor = vec4(amt);

}
