// vec2 iResolution
// vec2 iMouse
// float iGlobalTime

vec3 hillColors[3];

vec3 hills(vec2 st)
{
  hillColors[0] = vec3(0.38, 0.58, 0.29);
  hillColors[1] = vec3(0.44, 0.65, 0.33);
  hillColors[2] = vec3(0.46, 0.70, 0.35);

  vec3 col = vec3(0.0);

  if(sin(3. * (st.x - 0.324))/5. + 0.280 > st.y) {
    col = hillColors[2];
  }
  else if((sin(2.416 * (st.x + 0.6))/6. + 0.456 > st.y)) {
    col = hillColors[1];
  }
    else if((sin(1.944 * (st.x + 0.000))/6. + 0.520 > st.y)) {
    col = hillColors[0];
  }
  return col;
}

void main()
{
  vec2 uv = gl_FragCoord.xy/iResolution.xy;

  vec3 col = hills(uv);

  gl_FragColor = vec4(col, 1.0);
}
