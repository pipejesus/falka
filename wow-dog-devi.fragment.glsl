
//  Function from Iñigo Quiles
//  https://www.shadertoy.com/view/MsS3Wc
vec3 hsb2rgb( in vec3 c ) {
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),
                            6.0)-3.0)-1.0,
                    0.0,
                    1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

vec3 createCircular(vec2 uvc, vec3 initial, float radius) {
    vec3 red = hsb2rgb(vec3(1.0, 1.0, 1.0));
    
    vec2 dist = uvc;
    vec2 dist2 = uvc;

    float factorX = cos(uvc.y * iTime) / 8.0 ;
    float factorY = pow(sin(uvc.x * iTime), 4.0) / 4.0 ;
    
    dist2.x += 0.1*factorX; 
    dist2.y += 0.9*factorY;

    float z = 1.-smoothstep(radius-(radius*0.01),
                         radius+(radius*0.01),
                         dot(dist, dist2)*4.0);

   
    // vec3 r = red * z;
    vec3 r = red * z;
    return initial + r;
}

void main() {
    vec2 uv = 1.0 - (gl_FragCoord.xy / iResolution.xy);
    vec2 uvc = uv - vec2(0.5,0.5);
    uvc.x *= iResolution.x / iResolution.y;
    vec3 initial = hsb2rgb(vec3(0.0, 0.0, 0.0));
    vec3 c = createCircular(uvc, initial, 0.3);
    gl_FragColor = vec4(c, 1.0);
}