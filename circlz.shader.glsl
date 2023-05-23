precision mediump float;

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

    float a = atan(uvc.y, uvc.x) / 1.0;
    float c = cos((iTime + seed + uvc.y) / 1.2);    
    float s = sin((iTime + seed + uvc.x * a) / 1.2);

    // Why? I used pow(c, 8.0) but the results were buggy on one hardware
    // and correct on another one... no clue, missing something big here.
    float addX = (c * c * c * c * c * c * c * c) / 8.0;
    float addY = (s * s * s * s * s * s * s * s) / 8.0;

    dist2 += vec2(0.9 * addX, 0.7 * addY);        
    radius += (0.05) * (radius / 0.5) *  (sin(iTime) + 1.0);

    float z = 1.0 - smoothstep(radius-(radius*0.300),
                         radius+(radius*0.891),
                         dot(dist, dist2)*5.0);
    
    vec3 colorRGB= hsb2rgb(color);
    vec3 r = mix(initial, colorRGB, z);     
    
    return mix(initial, r, z);
}

void main() {
    vec2 uv = 1.0 - (gl_FragCoord.xy / iResolution.xy);
    vec2 uvc = uv - vec2(0.5,0.5);    
    uvc.x *= iResolution.x / iResolution.y;
    // vec3 initial = hsb2rgb(vec3(1.0, 0.0, 0.9));
    vec3 initial = hsb2rgb(vec3(1.0, 0.0, 1.0));

    float hue = 1.0; //0.113; // 0.583;

    vec3 c = createCircular(uvc, initial, 0.52, vec3(hue, 0.03, 0.899), 3.14 / 16.0);     
    c = createCircular(uvc, c, 0.5, vec3(hue, 0.6, 1.0), 0.0);
    c = createCircular(uvc, c, 0.25, vec3(0.554, 0.5, 0.7), 3.14 / 2.0);
    c = createCircular(uvc, c, 0.05, vec3(hue, 0.0, 0.88), 3.14 / 2.0);
    gl_FragColor = vec4(c, 1.0);
}