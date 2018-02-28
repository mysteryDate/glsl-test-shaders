/* == original shader https://www.shadertoy.com/view/4tcXWj ==*/

vec3 gradient(vec2 uv, vec3 startColor, vec3 endColor, vec2 startUV, vec2 endUV) {
  vec2 gradientVector = endUV - startUV;
  float k = dot(uv - startUV, gradientVector);
  k /= dot(gradientVector, gradientVector); // length squared
  k = clamp(k, 0.0, 1.0);
  return mix(startColor, endColor, k);
}

void main() {
	/* == Background == */
  vec3 grad= gradient (
        gl_FragCoord.xy/iResolution.xy,
        vec3(1.0, 0.627, 0.75),
        vec3(1.0, .9, 0.5),
        vec2(0.0, .4),
        vec2(.255, 1.0));
  gl_FragColor = vec4(grad, 1.0);

    /* == Sun == */
    vec2 center = vec2(3.0 * iResolution.x / 4.0, 3.0 * iResolution.y / 4.0);
    float radius = cos(u_time) * 7.0 + (iResolution.y * 15.0) / 100.0;

    float distSun = sqrt(pow(gl_FragCoord.x - center.x, 2.0) + pow(gl_FragCoord.y - center.y, 2.0));

    if ( distSun < radius ) {
    	gl_FragColor = vec4(1.0, 1.0, 0.455, 1.0);
    }

    /* == Rays == */
    float angleRay = 25.0;

    float deltaX = center.x - gl_FragCoord.x;
    float deltaY = center.y - gl_FragCoord.y;
    float angleRad = ((atan(deltaX, deltaY) * 180.0) / 3.14) + u_time * 2.0;
    if ( (mod(angleRad, angleRay) <= 7.0) && (distSun > radius + 25.0) ) {
        gl_FragColor = vec4(1.0, 1.0, 0.455, 1.0);
    }

    /* == Waves == */
    vec2 dist = gl_FragCoord.xy / iResolution.xy;

    float pi2 = 3.14 * 2.0;
    float waves1 = 3.0; float height1 = 0.18;
    float waves2 = 2.0; float height2 = 0.30;

    float ampli = 0.03;

    float wave1 = ampli * cos((u_time) + dist.x *  waves1 * pi2) + height1;
    float wave2 = ampli * cos((u_time * 1.5) + dist.x * waves2 * pi2) + height2;

    if (dist.y < wave2) {
       gl_FragColor = vec4(0.416, .755, 0.871, 1.0);
    }

    if (dist.y < wave1) {
        gl_FragColor = vec4(0.600, .875, 0.933, 1.0);
    }
}
