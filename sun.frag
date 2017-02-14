// Author: Aaron Krajeski
// Title: Sun

#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sun_back;
uniform sampler2D sun_front;
uniform sampler2D sun_middle;
uniform sampler2D sun_center;

void main()
{
    vec2 uv = gl_FragCoord.xy / iResolution.xy;

    vec4 backTex = texture2D(sun_back,uv);
    vec4 middleTex = texture2D(sun_middle, uv);

    if (middleTex.a <= .1) {
      discard;
    }

    gl_FragColor = middleTex + vec4(.1,.1,.1,.1);
}
