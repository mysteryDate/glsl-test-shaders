#pragma glslify: map = require('./lib/map')
#pragma glslify: hash = require('./lib/hash')
#pragma glslify: valueNoise = require('./lib/valueNoise')

vec4 voronoi(vec2 st)
{
  vec2 cellNumber = floor(st);
  vec2 cellPosition = fract(st);

  vec4 result = vec4(8.0);
  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      vec2 b = vec2(float(i), float(j));
      vec2 r = vec2(b) - cellPosition + map(hash(cellNumber + b), -1.0, 1.0, 0.0, 1.0);
      float d = dot(r, r);

      if (d < result.x) {
        result.y = result.x;
        result.x = d;
        result.zw = r;
      }
      else if( d < result.y ) {
        result.y = d;
      }
    }
  }

  return result;
}

const vec3 chocolateColor = vec3(0.196, 0.078, 0.031);
const vec3 milkColor = vec3(0.804, 0.604, 0.498);
const float blurriness = 0.01;
const float numSubspaces = 9.0;
const float numSubSubspaces = 1.0;
void main()
{
  vec3 color = vec3(0.0);
  vec2 uv = gl_FragCoord.xy/u_resolution.xy;
  // uv.x *= u_resolution.x/u_resolution.y;
  uv *= numSubspaces;
  vec2 cellNumber = floor(uv);
  float subSpaceRand = floor(map(hash(cellNumber * 100.0).x, -1.0, 1.0, 1.0, numSubSubspaces));
  subSpaceRand = max(2.0, floor(length(cellNumber - numSubspaces/2.0) + 1.0 + map(hash(cellNumber * 100.0).x, -1.0, 1.0, 0.0, 2.0)));
  float density = 1.0 - length(cellNumber - numSubspaces/2.0);
  density = map(density, 1.0, -1.0, 0.5, -0.5);
  // density = 1.0;

  uv *= subSpaceRand;
  cellNumber = floor(uv);
  vec2 cellPosition = fract(uv);

  vec4 result = vec4(8.0);
  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      vec2 b = vec2(float(i), float(j));
      vec2 r = vec2(b) - cellPosition + map(hash(cellNumber + b), -1.0, 1.0, 0.0, 1.0);
      float d = dot(r, r);

      if (d < result.x) {
        result.y = result.x;
        result.x = d;
        result.zw = r;
      }
      else if( d < result.y ) {
        result.y = d;
      }
    }
  }

  vec4 closestPoints = result;

  float border = closestPoints.y - closestPoints.x;
  float size = map(hash(uv + closestPoints.zw).x, -1.0, 1.0, 0.3, 1.0);
  size = (1.0 - density) / 3.0;
  color = mix(milkColor, chocolateColor, smoothstep(size - blurriness, size, border));
  // scale

  // color.r = step(0.95, cellPosition.x) + step(0.95, cellPosition.y);
	gl_FragColor = vec4(color, 1.0);
  // gl_FragColor = vec4(closestPoints.xxx, 1.0);
	// gl_FragColor = vec4(closestPoints.zw, 1.0, 1.0);
}
