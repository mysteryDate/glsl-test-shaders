// https://www.shadertoy.com/view/4dK3zc
#define pi 3.141593

// Switches, you can play with them!
#define show_smoke
#define smoke_turbulence

float aaindex;

float currTime;
const float timeFactor = 1.;

// Scene objects sizes and description
const vec3 wallPos = vec3(30, -20, -11.3);
const vec3 wallSize = vec3(20, 46, 50);
const vec3 brickSize = vec3(0.2, 0.34, 2.04);
const vec3 brickStep = vec3(0., 0.44, 2.29);
const float brickBR = 0.05;

const float tubeDiam = 2.8;
const float tubeLen1 = 2.1;
const float tubeclen = 1.6;
const float tubeLen2 = 1.5;
const vec3 chimneyOrig = vec3(-1.3, wallPos.x - wallSize.x - tubeLen1 + 0.2, -17.5);

// Camera options
vec3 campos;
vec3 camtarget = vec3(7., 3., -18);
vec3 camdir;
float fov = 4.5;

// Lighing options
const vec3 ambientColor = vec3(0.1, 0.5, 1.);
const float ambientint = 0.21;

// Shading options
float specint[4];
float specshin[4];
const float aoint = 0.9;
const float aoMaxdist = 50.;
const float aoFalloff = 0.2;
const float shi = 0.55;
const float shf = 0.05;

// Tracing options
const float normdelta = 0.001;
const float maxdist = 400.;
const float nbrref = 12.;      // This controls the number of diffuse reflections. You can set it higher if you want the chimney appear softer, but the FPS will drop
const float rrefblur = 0.8;

// Smoke options
const float smokeBrightness = 4.0;
const vec3 smokeCol = vec3(0.7, 0.75, 0.8)*smokeBrightness;
const float smokeColPresence = 0.1;
const float smokeColBias = 0.7;
const float smokeScale = 2.;
const float smokeSpeed = 15.7;
// const float smokeSpeed = 1.7;
const float smokeDens = 5.5;
const float smokeBias = -0.01;
const float smokePow = 1.9;
const float smokeRefInt = 0.0003;
const float smokeTurbulence = 0.01;
const float smokeTurbulenceScale = 2.5;

// Wind options
const float maxWindIntensity = 1.8;
// const float maxWindAngle = 0.27;
const float maxWindAngle = 0.0;
float windIntensity;
float dWindIntensity;
float windAngle;

// Cloud options

// Antialias. Change from 1 to 2 or more AT YOUR OWN RISK! It may CRASH your browser while compiling!
const float aawidth = 0.65;
const int aasamples = 1;

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
vec4 mapSmoke(in vec3 pos)
{
  vec3 pos2 = pos;
  pos2-= chimneyOrig;
  pos2.x -= 10.;

  // Calculating the smoke domain (3D space giving the probability to have smoke inside
  float sw = max(tubeDiam*0.84 + 0.25*pos2.y*(1. + max(0.15*pos2.y, 0.)) + 0.01*(pos.y + chimneyOrig.x - tubeclen - tubeLen2 + 0.3), 0.);
  sw += noise2(vec3(currTime, pos.xy)) * 0.5 * sw;

  float smokeDomain = smoothstep(1.2 + sw/5.3, 0.7 - sw*0.5, length(pos2.xz)/sw);

  float d;
  vec4 res;
  if (smokeDomain>0.1)
  {
    // Space modification in function of the time and wind
    vec3 q = pos2 + vec3(0.0,-currTime*smokeSpeed + 10.,0.0);
    q/= smokeScale;
    q.y+= 8.0 + 1.5/(0.7);

    // Turbulence of the smoke
    #ifdef smoke_turbulence
    if (smokeTurbulence>0.)
    {
      float n = smoothstep(4., 0., pos2.y + 3.2)*smokeTurbulence*noise(q*smokeTurbulenceScale)/(currTime + 3.);
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

    d = d - 0.3 - smokeBias - 0.04*pos.y + 0.05*(1. + windIntensity);
    d = clamp(d, 0.0, 1.0);

    res = vec4(pow(d*smokeDomain, smokePow));

    // Some modifications of color and alpha
    res.xyz = mix(smokeCol, 0.2*vec3(0.4, 0.4, 0.4), res.x);
    res.xyz*= 0.2 + 0.2*smoothstep(-2.0, 1.0, pos.y);
    res.w*= max(smokeDens - 1.8*sqrt(pos.y - 4.), 0.);
  }
  else
  {
    d = 0.;
    res = vec4(0.);
  }

  return res;
}

// Raymarching of the smoke
vec4 raymarchSmoke(in vec3 ro, in vec3 rd, in vec3 bcol, float tmax, bool isShadow)
{
  vec4 sum = vec4(0.0);
  vec2 windDir = rotateVec(vec2(1., 0.), windAngle);

  float t = isShadow?5.4:abs(0.95*(campos.z - chimneyOrig.z)/rd.z);
  for(int i=0; i<32; i++)
  {
    // if(t>tmax || sum.w>1.) break;
    vec3 pos = ro + t*rd;

    vec4 col = mapSmoke(pos);

    sum = sum + col*(1.0 - sum.a);
    t+= 0.07*(1.0)*max(0.1,0.05*t);
  }
  return clamp(sum, 0.0, 1.0);
}

////////////////////////////////////////////////////////////////

vec4 smokeRes;
// Sets the position of the camera with the mouse and calculates its direction
void setCamera()
{
  vec2 iMouse2;
  if (iMouse.x==0. && iMouse.y==0.)
  iMouse2 = iResolution.xy*vec2(0.52, 0.65);
  else
  iMouse2 = iMouse.xy;

  campos = vec3(19.*(1. - iMouse2.x/iResolution.x - 0.5),
  18.*(iMouse2.y/iResolution.y - 0.35),
  10.);
  /*campos = camtarget + vec3(-20.*cos(3. + 6.*iMouse2.x/iResolution.x),
  20.*cos(3.*iMouse2.y/iResolution.y),
  20.*sin(3. + 6.*iMouse2.x/iResolution.x)*sin(3.*iMouse2.y/iResolution.y)); */

  camdir = camtarget-campos;
}

// From https://www.shadertoy.com/view/lsSXzD, modified
vec3 GetCameraRayDir(vec2 vWindow, vec3 vCameraDir, float fov)
{
  vec3 vForward = normalize(vCameraDir);
  vec3 vRight = normalize(cross(vec3(0., 1., 0.), vForward));
  vec3 vUp = normalize(cross(vForward, vRight));

  vec3 vDir = normalize(vWindow.x*vRight + vWindow.y*vUp + vForward*fov);
  return vDir;
}

// Function to get the intensity of the wind as a function
float getWindIntensity(float t)
{
  return maxWindIntensity*smoothstep(-0.3, 2.2, sin(t*0.153 + 18.) + 0.63*sin(t*0.716 - 7.3) + 0.26*sin(t*1.184 + 87.));
}
// Function to get the angle of the wind as a function
float getWindAngle(float t)
{
  return maxWindAngle*pi*(sin(t*0.0117) + 0.67*sin(t*0.0672 + 5.6) + 0.26*sin(t*0.1943 - 18.7));
}

// Main render function with diffuse reflections on the chimney
vec3 ray;
int robjnr;
// Main tracing function
void main()
{
  currTime = u_time*timeFactor;
  setCamera();
  windIntensity = getWindIntensity(currTime*0.8);
  // windIntensity = 0.0;
  dWindIntensity = windIntensity - getWindIntensity(currTime*0.8 - 0.2);
  // windAngle = getWindAngle(currTime);
  windAngle = 0.0;

  vec2 uv = gl_FragCoord.xy / iResolution.xy;
  uv = uv*2.0 - 1.0;
  uv.x*= iResolution.x / iResolution.y;

  ray = GetCameraRayDir(uv, camdir, fov);
  smokeRes = raymarchSmoke(campos, ray, vec3(1.), 40., false);

  vec3 col = smokeRes.rgb * smokeRes.w * (1. + 0.06*smokeRes.w);

  gl_FragColor = vec4(col, 1.);
}
