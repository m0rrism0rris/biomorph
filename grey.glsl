vec2 csqr(in vec2 z) {
    return vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y);
}

vec2 csin(in vec2 z) {
    return vec2(sin(z.x) * cosh(z.y), cos(z.x) * sinh(z.y));
}

vec2 cexp(in vec2 z) {
    float expz = exp(z.x);
    return vec2(expz * cos(z.y), expz * sin(z.y));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = vec2(10.0, 10.0) * (fragCoord / iResolution.y - vec2(0.5 * iResolution.x / iResolution.y, 0.5));
    vec2 sclmouse = (2.0 * iMouse.xy / iResolution.xy - vec2(1.0, 1.0));
    float v;
    for (int i = 0; i < 50; i++) {
        uv = csin(uv) + csqr(uv) + sclmouse;
        if (uv.x * uv.x + uv.y * uv.y > 100.0) break;
    }
    uv.x = abs(uv.x);
    uv.y = abs(uv.y);
    if (abs(uv.x) < 10.0) {v = 0.5 + uv.x * 0.05;}
    else if (abs(uv).y < 10.0) {v = 0.5 - uv.y * 0.05;}
    else v = 0.5;
    
    fragColor = vec4(v, v, v, 1.0);
}