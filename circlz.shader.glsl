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

vec3 createCircular(vec2 uvc, vec3 initial, float radius, vec3 color, float seed) {    
    vec2 dist = uvc;
    vec2 dist2 = uvc;

    float factorX = pow(cos( (uvc.y + iTime + seed) / 1.2), 8.0) / 8.0;
    float factorY = pow(sin( (uvc.x + iTime + seed) / 1.2), 8.0) / 8.0;

    dist2.x += 0.9*factorX; 
    dist2.y += .7 * factorY;

    radius += (0.05) * (radius / 0.5) *  (sin(iTime) + 1.0);

    float z = 1.-smoothstep(radius-(radius*0.001),
                         radius+(radius*0.001),
                         dot(dist, dist2)*4.0);
    
    float za = smoothstep(0.5, 1.0, mod(gl_FragCoord.x, 40.0));
    za *= smoothstep(0.5, 1.0, mod(gl_FragCoord.y, 40.0));

    // float za2 = (0.1 * floor(gl_FragCoord.y / 40.0));
    // za2 = za2 * (0.1 * floor(gl_FragCoord.x / 40.0));
    // za2 = 1.0 - za2;
    
    // if (za <= 0.0) {
    //     color.z = color.z + 0.1;
    // }
    // } else {
        // color.z = color.z + za;
    // }
    vec3 colorRGB= hsb2rgb(color);
    vec3 r = colorRGB * z;

    return mix(initial, r, z);
}

void main() {
    vec2 uv = 1.0 - (gl_FragCoord.xy / iResolution.xy);
    vec2 uvc = uv - vec2(0.5,0.5);
    uvc.x *= iResolution.x / iResolution.y;
    vec3 initial = hsb2rgb(vec3(1.0, 0.0, 0.9));

    float hue = 1.0; //0.113; // 0.583;
    vec3 c = createCircular(uvc, initial, 0.52, vec3(hue, 0.03, 0.899), 3.14 / 8.0); 
    
    c = createCircular(uvc, c, 0.5, vec3(hue, 0.6, 1.0), 0.0);
    c = createCircular(uvc, c, 0.35, vec3(hue, 0.5, 1.0), 3.14 / 2.0);
    c = createCircular(uvc, c, 0.05, vec3(hue, 0.4, 1.0), 3.14 / 2.0);
    gl_FragColor = vec4(c, 1.0);
}