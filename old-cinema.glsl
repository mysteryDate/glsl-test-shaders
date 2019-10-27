#define BLACK_AND_WHITE
#define VIGNETTE
#define FLICKER
#define MOVE
#define LINES_AND_FLICKER
#define BLOTCHES
#define GRAIN

#define FREQUENCY 15.0
// #define FREQUENCY 1.0
#define NUM_LINES 4
#define NUM_BLOTCHES 8

uniform sampler2D iChannel0; // textures/cait.jpg
vec2 uv;

float rand(vec2 co){
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float rand(float c){
  return rand(vec2(c,1.0));
}

float randomLine(float seed)
{
  float b = 0.01 * rand(seed);
  float a = rand(seed+1.0);
  float c = rand(seed+2.0) - 0.5;
  float mu = rand(seed+3.0);


  float d = abs(a * uv.x + b * uv.y + c );
  float width = 0.1;
  d = min(d * 1.0/width, 1.0);

  float l = 1.0;
  if ( mu > 0.2) // dark bands
    l = pow(d, 2.0 * width );
  else // bright bands
    l = 2.0 - pow(d, 2.0 * width );

  return mix(0.5, 1.0, l);
}

// Generate some blotches.
float randomBlotch(float seed)
{
  float x = rand(seed);
  float y = rand(seed+1.0);
  float s = 0.1 * rand(seed+2.0);

  vec2 p = vec2(x,y) - uv;
  p.x *= iResolution.x / iResolution.y;
  float a = atan(p.y,p.x);
  float v = 1.0;
  float ss = s*s * (sin(6.2831*a*x)*0.1 + 1.0);

  if ( dot(p,p) < ss ) v = 0.2;
  else
    v = pow(dot(p,p) - ss, 1.0/16.0);

  return mix(0.3 + 0.2 * (1.0 - (s / 0.02)), 1.0, v);
}


void main()
{
  uv = gl_FragCoord.xy / iResolution.xy;

  // Set frequency of global effect to 15 variations per second
  float t = float(int(u_time * FREQUENCY));
  // t = 1.;

  #ifdef MOVE
    // Get some image movement
    uv = uv + 0.002 * vec2( rand(t), rand(t + 23.0));
  #endif

  // Get the image
  vec3 image = texture2D( iChannel0, vec2(uv.x, uv.y) ).xyz;

  #ifdef BLACK_AND_WHITE
    // Convert it to B/W
    float luma = dot( vec3(0.2126, 0.7152, 0.0722), image );
    vec3 oldImage = luma * vec3(0.7, 0.7, 0.7);
  #else
    vec3 oldImage = image;
  #endif

  float vI = 1.0;

  #ifdef FLICKER
    // Create a time-varying vignetting effect
    vI = 16.0 * (uv.x * (1.0-uv.x) * uv.y * (1.0-uv.y));
    vI *= mix( 0.7, 1.0, rand(t + 0.5));

    // Add additive flicker
    vI += 1.0 + 0.4 * rand(t+8.);
  #endif

  #ifdef VIGNETTE
    // Add a fixed vignetting (independent of the flicker)
    vI *= pow(16.0 * uv.x * (1.0-uv.x) * uv.y * (1.0-uv.y), 0.4);
  #endif

  // t = 1.;
  // Add some random lines (and some multiplicative flicker. Oh well.)
  #ifdef LINES_AND_FLICKER
    int l = int(float(NUM_LINES + 1) * rand(t+7.0));

    for (int i = 0; i <= NUM_LINES; i++) {
      if (i < l) {
        vI *= randomLine( t+6.0+17.* float(i));
      }
    }
  #endif

  // Add some random blotches.
  #ifdef BLOTCHES
    int s = int( max(float(NUM_BLOTCHES) * rand(t+18.0) -2.0, 0.0 ));

    for (int i = 0; i <= NUM_BLOTCHES; i++) {
      if (i < s) {
        vI *= randomBlotch( t+6.0+19.* float(i));
      }
    }
  #endif

  // Show the image modulated by the defects
  gl_FragColor.xyz = oldImage * vI;

  // Add some grain (thanks, Jose!)
  #ifdef GRAIN
    gl_FragColor.xyz *= (1.0+(rand(uv+t*.01)-.2)*.15);
  #endif
}
