/**
* Part 1 Challenges
* - Make the circle yellow
* - Make the circle smaller by decreasing its radius
* - Make the circle smaller by moving the camera back
* - Make the size of the circle oscillate using the sin() function and the iTime
*   uniform provided by shadertoy
*/

const int MAX_MARCHING_STEPS = 255;
const float MIN_DIST = 0.0;
const float MAX_DIST = 200.0;
const float EPSILON = 0.0001;

/**
* Signed distance function for a sphere centered at the origin with radius 1.0;
*/
float sphereSDF(vec3 samplePoint) {
  return length(samplePoint) - 0.5;
}

float torusSDF(vec3 samplePoint) {
  float majorRadius = 0.7;
  float minorRadius = 0.0;
  vec2 q = vec2(length(samplePoint.xz) - majorRadius, samplePoint.y);
  return length(q) - minorRadius;
}

/**
* Signed distance function describing the scene.
*
* Absolute value of the return value indicates the distance to the surface.
* Sign indicates whether the point is inside or outside the surface,
* negative indicating inside.
*/
float sceneSDF(vec3 samplePoint) {
  return torusSDF(samplePoint);
}

/**
* Return the shortest distance from the eyepoint to the scene surface along
* the marching direction. If no part of the surface is found between start and end,
* return end.
*
* eye: the eye point, acting as the origin of the ray
* marchingDirection: the normalized direction to march in
* start: the starting distance away from the eye
* end: the max distance away from the ey to march before giving up
*/
float distanceToCenter(vec3 eye, vec3 marchingDirection, float start, float end) {
  float depth = start;
  float minDist = end;
  for (int i = 0; i < MAX_MARCHING_STEPS; i++) {
    float dist = sceneSDF(eye + depth * marchingDirection);
    minDist = min(dist, minDist);
    if (dist > minDist) { // We've passed the minimum
      return minDist;
    }
    depth += dist;
  }
  return minDist;
}


/**
* Return the normalized direction to march in from the eye point for a single pixel.
*
* fieldOfView: vertical field of view in degrees
* size: resolution of the output image
* fragCoord: the x,y coordinate of the pixel in the output image
*/
vec3 rayDirection(float fieldOfView, vec2 size, vec2 fragCoord) {
  vec2 xy = fragCoord - size / 2.0;
  float z = size.y / tan(radians(fieldOfView) / 2.0);
  return normalize(vec3(xy, -z));
}

/**
 * Return a transform matrix that will transform a ray from view space
 * to world coordinates, given the eye point, the camera target, and an up vector.
 *
 * This assumes that the center of the camera is aligned with the negative z axis in
 * view space when calculating the ray marching direction. See rayDirection.
 */
mat4 makeViewMatrix(vec3 eye, vec3 center, vec3 up) {
    // Based on gluLookAt man page
    vec3 f = normalize(center - eye);
    vec3 s = normalize(cross(f, up));
    vec3 u = cross(s, f);
    return mat4(
        vec4(s, 0.0),
        vec4(u, 0.0),
        vec4(-f, 0.0),
        vec4(0.0, 0.0, 0.0, 1)
    );
}

void main()
{
  vec3 viewDir = rayDirection(30.0, iResolution.xy, gl_FragCoord.xy);

  vec3 cameraPosition = vec3(0.0, 0.0, 10.0);
  vec3 cameraTarget = vec3(0.0, 0.0, 0.0);
  vec3 cameraUp = vec3(0.0, 1.0, 0.0);
  mat4 viewToWorld = makeViewMatrix(cameraPosition, cameraTarget, cameraUp);
  vec3 worldDir = (viewToWorld * vec4(viewDir, 0.0)).xyz;

  float dist = distanceToCenter(cameraPosition, worldDir, MIN_DIST, MAX_DIST);

  gl_FragColor = vec4(0.1/vec3(dist), 1.0);
}
