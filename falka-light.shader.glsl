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

float plot(vec2 uv) {
    float middle = cos(iTime * 1.5) / 3.0
        * sin(uv.x * 4.0 + iTime) / 6.0 
        + 0.5;

    return smoothstep(
        middle,
        middle + 0.3,
        uv.y
    );
}

float decide(vec2 uv) {
    float s = pow(sin(iTime), 2.0);
    float f = 0.0;
    float comp = 1.0;
    float x = mod(gl_FragCoord.x, f);
    float y = mod(gl_FragCoord.y, f);

    float res = step(comp, x) * step(comp,y);
    return res;  
}

float dist_factor(vec2 uv, float seed) {
    vec2 center = vec2(0.5, 0.5);
    vec2 add = vec2(cos((iTime + seed) * 1.5), sin(iTime + seed)) / 2.0;
    float dist = distance(center + add, uv);
    return dist;
}

void main() {
    
    vec2 uv = 1.0 - (gl_FragCoord.xy / iResolution.xy);
    
    vec3 filled = vec3(1.0, 0.55, 0.8);
    vec3 filled2 = vec3(.55, 1.0, 0.8);
    // vec3 empty = vec3(.1, .1, .3);
    vec3 empty = vec3(1.0, 1.0, 1.0);

    float decision = decide(uv) * (1.0 - dist_factor(uv, 0.0));
    float decision2 = decide(uv) * (1.0 - dist_factor(uv, 1.6));
    vec3 light = mix(empty, filled, decision);
    light = mix(light, filled2, decision2);

    vec4 black = vec4(light.xyz, 1.0);

    vec3 tc = vec3(abs(sin(iTime / 8.0)), uv.x * sin(iTime), max(1.0 - uv.y, 0.5));
    vec4 fc = vec4(hsb2rgb(tc), 1.0);
    fc = mix(black, fc, plot(uv));

    gl_FragColor = vec4(fc);
}