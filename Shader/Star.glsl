
void mainImage( out vec4 O, vec2 UV )
{
  float clampedTime = mod(iTime,8.), 
        angleNum = 3. + 5. * min(clampedTime, 8. - clampedTime),
        r = 1.,                     // radius
        r0 = .5;                    // relative interior radius
    
  vec2 Resolution = iResolution.xy;
  UV = ( UV + UV - Resolution ) / Resolution.y;
  float a = atan(UV.x,UV.y), l = length(UV),
        b = 3.14159/angleNum,
        tb = tan(b),
      //  s = sin(b); // if control by peak angle
        s = (r0 * tb)/(sqrt(1.+tb*tb)-r0); // control by r
  a = mod(a,2.*b)-b;
  UV = l * vec2(cos(a),sin(a)) / cos(b);
  UV.y = abs(UV.y);
  UV.x -= r/cos(b);
  
  l = -(s*UV.x+UV.y)/sqrt(1.+s*s);  // true euclidian distance ( +: inside )



  //l = -(UV.x+UV.y/s);               // field fitting radial distance ( +: indide )
  O = vec4(l);
  // O = vec4( 0.5, 0.5, 0.5, 0.5);
    
    //O = sin(30.*O);
  // if (O.x < 0.) 
  //   O = vec4(1, 0.4, 0, 0);
  // float pi = 3.14;
  // O.b = .5*sin(2. * pi * 10. * l);
}