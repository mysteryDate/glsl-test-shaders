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
  // uv = vec2(length(uv - 0.5));
  // uv.x *= u_resolution.x/u_resolution.y;
  vec2 st = uv * numSubspaces;
  vec2 cellNumber = floor(st);
  vec2 initialCellPosition = fract(st);
  float subSpaceRand = floor(map(hash(cellNumber * 100.0).x, -1.0, 1.0, 1.0, numSubSubspaces));
  subSpaceRand = max(2.0, floor(length(cellNumber - numSubspaces/2.0) + 1.0 + map(hash(cellNumber * 100.0).x, -1.0, 1.0, 0.0, 2.0)));
  float pieceSize = length(cellNumber - numSubspaces/2.0);
  pieceSize = map(pieceSize, 0.0, sqrt(2.0)/2.0 * numSubspaces, 1.0, 0.0);
  // density = 1.0;

  st *= subSpaceRand;
  cellNumber = floor(st);
  vec2 cellPosition = fract(st);

  vec4 result = vec4(8.0);
  vec2 closestPoint = vec2(0.0);
  vec2 secondClosestPoint = vec2(0.0);
  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      vec2 b = vec2(float(i), float(j));
      vec2 r = vec2(b) - cellPosition + map(hash(cellNumber + b), -1.0, 1.0, 0.0, 1.0);
      float d = dot(r, r);

      if (d < result.x) {
        result.y = result.x;
        result.x = d;
        result.zw = r;
        secondClosestPoint = closestPoint;
        closestPoint = r;
      }
      else if( d < result.y ) {
        result.y = d;
        secondClosestPoint = r;
      }
    }
  }

  vec4 closestPoints = result;

  float border = closestPoints.y - closestPoints.x;
  border = dot(0.5 * (closestPoint + secondClosestPoint), normalize(secondClosestPoint - closestPoint));
  // float dis = dot( 0.5*(a+b), normalize(b-a) );
  float alpha = 1.0 - smoothstep(pieceSize - 0.2, pieceSize + 0.2, 1.0 - border);
  alpha -= step(0.95, initialCellPosition.x) + step(0.95, initialCellPosition.y);
  alpha = max(0.0, alpha);
  color = mix(milkColor, chocolateColor, alpha);

  // color += step(0.95, cellPosition.x) + step(0.95, cellPosition.y);
	gl_FragColor = vec4(color, 1.0);
	// gl_FragColor = vec4(uv, 1.0, 1.0);
  // gl_FragColor = vec4(closestPoints.xxx, 1.0);
	// gl_FragColor = vec4(closestPoints.zw, 1.0, 1.0);
}
