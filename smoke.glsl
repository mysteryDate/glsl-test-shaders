// https://www.shadertoy.com/view/4dK3zc
#define show_smoke
#define smoke_turbulence

float currTime;
const float timeFactor = 2.0;

// Smoke options
const float SMOKE_BRIGHTNESS = 40.0;
const vec3 SMOKE_COLOR = vec3(0.7, 0.75, 0.8) * SMOKE_BRIGHTNESS;
const float SMOKE_SCALE = 2.;
const float SMOKE_SPEED = 15.7;
const float SMOKE_DENSITY = 5.5;
const float SMOKE_BIAS = -0.01;
const float SMOKE_POWER = 1.9;
const float SMOKE_TURBULANCE = 0.01;
const float SMOKE_TURBULANCE_SCALE = 1.0;

// 1D hash function
float hash( float n ){
  return fract(sin(n)*3538.5453);
}

// 2D Vector rotation
vec2 rotateVec(vec2 vect, float angle)
{
  vec2 rv;
  rv.x = vect.x*cos(angle) - vect.y*sin(angle);
  rv.y = vect.x*sin(angle) + vect.y*cos(angle);
  return rv;
}

// From https://www.shadertoy.com/view/4sfGzS
float noise(vec3 x)
{
  //x.x = mod(x.x, 0.4);
  vec3 p = floor(x);
  vec3 f = fract(x);
  f = f*f*(3.0 - 2.0*f);

  float n = p.x + p.y*157.0 + 113.0*p.z;
  return mix(mix(mix(hash(n + 0.0), hash(n + 1.0),f.x),
  mix(hash(n + 157.0), hash(n + 158.0),f.x),f.y),
  mix(mix(hash(n + 113.0), hash(n + 114.0),f.x),
  mix(hash(n + 270.0), hash(n + 271.0),f.x),f.y),f.z);
}

const mat3 m = mat3( 0.00,  0.80,  0.60,
  -0.80,  0.36, -0.48,
  -0.60, -0.48,  0.64 );

// From https://www.shadertoy.com/view/4sfGzS
float noise2(vec3 pos)
{
  vec3 q = 8.0*pos;
  float f  = 0.5000*noise(q) ; q = m*q*2.01;
  f+= 0.2500*noise(q); q = m*q*2.02;
  f+= 0.1250*noise(q); q = m*q*2.03;
  f+= 0.0625*noise(q); q = m*q*2.01;
  return f;
}

////////////////////////////////////////////////////////
// Smoke functions from www.shadertoy.com/view/XsX3RB //
////////////////////////////////////////////////////////
vec3 rayRef;
// Mapping of the smoke
vec4 mapSmoke(vec3 pos)
{
  vec3 pos2 = pos - vec3(0.0, 8.0, -20.0);;
  pos2.x -= 10.;


  const float tubeDiam = 2.8;
  const float tubeclen = 1.6;
  const float tubeLen2 = 1.5;

  // Calculating the smoke domain (3D space giving the probability to have smoke inside
  float sw = max(tubeDiam*0.84 + 0.25*pos2.y*(1. + max(0.15*pos2.y, 0.)) + 0.01*(pos.y - tubeclen - tubeLen2 + 0.3), 0.);
  float f = noise(vec3(currTime * 4.0, pos.xy * 2.0 + vec2(0.0, -2.0) * currTime)) * 0.4 * smoothstep(0.0, 0.5, sw);
  sw += f;

  float smokeDomain = smoothstep(1.2 + sw/5.3, 0.7 - sw*0.5, length(pos2.xz)/sw);
  smokeDomain *= smoothstep(-1.0, 1.2, pos.y);

  float d;
  vec4 res = vec4(0.0);
  // Space modification in function of the time and wind
  vec3 q = pos2 + vec3(0.0,-currTime*SMOKE_SPEED + 10.,0.0);
  q/= SMOKE_SCALE;
  q.y+= 8.0 + 1.5/(0.7);

  // Turbulence of the smoke
  #ifdef smoke_turbulence
  if (SMOKE_TURBULANCE>0.)
  {
    float n = smoothstep(4., 0., pos2.y + 3.2)*SMOKE_TURBULANCE*noise(q*SMOKE_TURBULANCE_SCALE)/(currTime + 3.);
    q.xy = rotateVec(-q.xy, pos.z*n);
    q.yz = rotateVec(-q.yz, pos.x*n);
    q.zx = rotateVec(-q.zx, pos.y*n);
  }
  #endif

  // Calculation of the noise
  d = clamp(0.6000*noise(q), 0.4, 1.); q = q*2.02;
  d+= 0.2500*noise(q); q = q*2.03;
  d+= 0.1200*noise(q); q = q*2.08;
  d+= 0.0500*noise(q);

  d = d - 0.3 - SMOKE_BIAS - 0.04*pos.y + 0.05*(1.0);
  d = clamp(d, 0.0, 1.0);

  res = vec4(pow(d*smokeDomain, SMOKE_POWER));

  // Some modifications of color and alpha
  res.xyz = mix(SMOKE_COLOR, 0.2*vec3(0.4, 0.4, 0.4), res.x);
  res.xyz*= 0.2 + 0.2*smoothstep(-2.0, 1.0, pos.y);
  res.w*= max(SMOKE_DENSITY - 1.8*sqrt(pos.y - 4.), 0.);

  return res;
}

// Raymarching of the smoke
vec4 raymarchSmoke(vec3 cameraPosition, vec3 rayDirection, float tmax)
{
  vec4 sum = vec4(0.0);
  float windAngle = 0.0;
  vec2 windDir = rotateVec(vec2(1.0, 0.0), windAngle);
  float chimneyBase = 20.0;

  float t = abs(0.95 * (cameraPosition.z + chimneyBase) / rayDirection.z);
  for(int i = 0; i < 16; i++)
  {
    if(t > tmax || sum.w > 1.0) break;
    vec3 pos = cameraPosition + t * rayDirection;

    vec4 col = mapSmoke(pos);

    sum = sum + col * (1.0 - sum.a);
    t += 0.07 * max(0.1, 0.05 * t);
  }
  return clamp(sum, 0.0, 1.0);
}

////////////////////////////////////////////////////////////////

vec4 smokeRes;
// From https://www.shadertoy.com/view/lsSXzD, modified
vec3 GetCameraRayDir(vec2 st, vec3 viewDirection, float fov)
{
  vec3 forward = normalize(viewDirection);
  vec3 right = normalize(cross(vec3(0.0, 1.0, 0.0), forward));
  vec3 up = normalize(cross(forward, right));

  vec3 rayDirection = normalize(st.x * right + st.y * up + forward * fov);
  return rayDirection;
}

// Main tracing function
void main()
{
  currTime = u_time * timeFactor;
  vec3 cameraPosition = vec3(9.5, -6.0, 10.0);

  vec2 uv = gl_FragCoord.xy / iResolution.xy;
  uv = uv * 2.0 - 1.0;
  uv.x *= iResolution.x / iResolution.y;
  uv.xy = uv.yx;

  vec3 viewDirection = vec3(0.0, 0.4, -1.0); // Out and slightly upwards
  float fov = 4.5;
  vec3 ray = GetCameraRayDir(uv, viewDirection, fov);
  smokeRes = raymarchSmoke(cameraPosition, ray, 40.0);

  vec3 col = smokeRes.rgb * smokeRes.w;

  gl_FragColor = vec4(col, 1.0);
}
