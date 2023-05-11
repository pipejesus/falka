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

void main() {
    vec4 black = vec4(1.0, 1.0, 1.0, 1.0);
    vec2 uv = 1.0 - (gl_FragCoord.xy / iResolution.xy);
    vec3 tc = vec3(abs(sin(iTime / 8.0)), uv.x * sin(iTime), 1.0 - uv.y);
    vec4 fc = vec4(hsb2rgb(tc), 1.0);
    fc = mix(black, fc, plot(uv));

    gl_FragColor = vec4(fc);
}