// Author: Aaron Krajeski
// Title: Sun

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;


void main()
{
    vec2 uv = gl_FragCoord.xy / iResolution.xy;

    float sharp = 0.808 * 100.;
    float bright = 1.000;
    sharp = (sin(iGlobalTime * 5.) + 2.) * 50.;
    vec2 center = vec2(0.480,0.480);
    vec2 centerVec = uv - center;
    float vert = pow((-1.*abs(centerVec.x)+1.),sharp);
    float horiz = pow((-1.*abs(centerVec.y)+1.),sharp);
    float outCol = (vert * horiz) * bright;

    gl_FragColor = vec4(vec3(outCol),1.);
}
