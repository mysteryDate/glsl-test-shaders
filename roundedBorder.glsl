// based on https://www.shadertoy.com/view/lsXXDj
// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

float F(vec2 p)
{
	float x = abs(p.x);
  float y = abs(p.y);

  x *= 3.0;
  y *= 3.0;

  float Scale = 1. - 10. * abs(pow(x, 4.) + pow(y, 4.) - 1.);
  float brightness = 1.1;

  return Scale * brightness;
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;
  float aspect = iResolution.x / iResolution.y;
  uv.x = uv.x * aspect;
  vec2 p = uv - vec2(0.5 * aspect, 0.5);
  vec3 col = vec3(0.0, 0.0, 0.0);

  float scale = F(p);

  vec3 Color = vec3(uv,0.5+0.5*sin(iGlobalTime));
  col = Color * scale;


	gl_FragColor = vec4(col,scale);
	gl_FragColor = vec4(p, 1., 1.);
}
