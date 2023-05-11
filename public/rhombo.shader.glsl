
float decide(vec2 uv) {
    float s = pow(sin(iTime), 2.0);
    float f = 0.0;
    float comp = 1.0;
    float x = mod(gl_FragCoord.x, f);
    float y = mod(gl_FragCoord.y, f);

    float res = step(comp, x) * step(comp,y);
    return res;  
}

float dist_factor(vec2 uv) {
    vec2 center = vec2(0.5, 0.5);
    vec2 add = vec2(cos(iTime * 1.5), sin(iTime)) / 2.0;
    float dist = distance(center + add, uv);
    return dist;
}

void main() {
    vec2 uv = 1.0 - (gl_FragCoord.xy / iResolution.xy);
    vec3 filled = vec3(0.51, 0.55, 0.8);
    vec3 empty = vec3(.1, .1, .3);
    float decision = decide(uv) * (1.0 - dist_factor(uv));
    vec3 fc = mix(empty, filled, decision);
    gl_FragColor = vec4(fc, 1.0);
}