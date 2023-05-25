precision mediump float;

float blendScreen(float base, float blend) {
	return 1.0-((1.0-base)*(1.0-blend));
}

vec3 blendScreen(vec3 base, vec3 blend) {
	return vec3(blendScreen(base.r,blend.r),blendScreen(base.g,blend.g),blendScreen(base.b,blend.b));
}

vec3 blendScreen(vec3 base, vec3 blend, float opacity) {
	return (blendScreen(base, blend) * opacity + base * (1.0 - opacity));
}

float blendColorDodge(float base, float blend) {
	return (blend==1.0)?blend:min(base/(1.0-blend),1.0);
}

vec3 blendColorDodge(vec3 base, vec3 blend) {
	return vec3(blendColorDodge(base.r,blend.r),blendColorDodge(base.g,blend.g),blendColorDodge(base.b,blend.b));
}

vec3 blendColorDodge(vec3 base, vec3 blend, float opacity) {
	return (blendColorDodge(base, blend) * opacity + base * (1.0 - opacity));
}

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

vec3 createPhase(vec3 colorRGB, vec3 backgroundRGB, vec2 uvc, float uvyOffset, float twoWidth) {
    float s = sin(2.0 * uvc.x + mod(iTime,3.14*2.0)) / 4.0 * cos(iTime);

    float top = step(-twoWidth - s, uvc.y + uvyOffset);
    float bottom = step(twoWidth - s , uvc.y + uvyOffset);

    // float top = smoothstep(-twoWidth - s, -s, uvc.y + uvyOffset);
    // float bottom = smoothstep(-s, twoWidth - s, uvc.y + uvyOffset);

    float z = abs(top - bottom);
    
    return mix(backgroundRGB, colorRGB, z);     
}

bool isBlack(vec3 color) {
    return dot(color, color) == 0.0;
}

void main() {
    vec2 uv = (gl_FragCoord.xy / iResolution.xy);
    uv.y = 1.0 - uv.y;

    vec2 uvc = uv - vec2(0.5,0.5);    
    uvc.x *= iResolution.x / iResolution.y;

    vec3 c = vec3(0.0, 0.69, 0.89);
    vec3 backgroundRGB = vec3(0.0, 0.0, 0.0);
    vec3 colorRGB= hsb2rgb(c);

    float fWidth = 0.01; // 0.03 0.01
    vec3 cRGB = createPhase(colorRGB, backgroundRGB, uvc, 0.0, fWidth);
    cRGB = createPhase(colorRGB, cRGB, uvc, -0.05, fWidth);
    cRGB = createPhase(colorRGB, cRGB, uvc, -0.1, fWidth);
    cRGB = createPhase(colorRGB, cRGB, uvc, -0.15, fWidth);

    if (isBlack(cRGB)) {
        discard;
    }    

    gl_FragColor = vec4(cRGB, 1.0);
}