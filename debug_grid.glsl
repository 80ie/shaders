// Debug overlay: cell borders, r axes (red r.x=0, green r.y=0), "x,y" id label per cell.
// Include after ANGLE is defined; call at the end of main: col = debugGrid(col, r);

// 3x5 bitmaps, bit = col + 3 * row (row 0 = bottom). 10 = '-', 11 = ','
float dbgGlyph(float c) {
    if (c == 0.) return 31599.;
    if (c == 1.) return 9879.;
    if (c == 2.) return 31183.;
    if (c == 3.) return 31207.;
    if (c == 4.) return 23524.;
    if (c == 5.) return 29671.;
    if (c == 6.) return 29679.;
    if (c == 7.) return 31012.;
    if (c == 8.) return 31727.;
    if (c == 9.) return 31719.;
    if (c == 10.) return 448.;
    if (c == 11.) return 17.;
    return 0.;
}

float dbgChar(vec2 p, float c) {
    if (p.x < 0. || p.x >= 3. || p.y < 0. || p.y >= 5.) return 0.;
    float bit = floor(p.x) + 3. * floor(p.y);
    return mod(floor(dbgGlyph(c) / exp2(bit)), 2.);
}

// p in font pixels from the label's bottom-left
float dbgLabel(vec2 p, vec2 n) {
    float slot = floor(p.x / 4.);
    float c = -1.;
    if (slot == 0. && n.x < 0.) c = 10.;
    if (slot == 1. && abs(n.x) < 10.) c = abs(n.x);
    if (slot == 2.) c = 11.;
    if (slot == 3. && n.y < 0.) c = 10.;
    if (slot == 4. && abs(n.y) < 10.) c = abs(n.y);
    return dbgChar(vec2(mod(p.x, 4.), p.y), c);
}

vec3 debugGrid(vec3 col, vec2 r) {
    vec2 id = floor(r), f = fract(r);

    float edge = min(min(f.x, 1. - f.x), min(f.y, 1. - f.y));
    col = mix(col, vec3(.55), step(edge, .015));
    if (abs(r.x) < .04) col = vec3(.9, .1, .1);
    if (abs(r.y) < .04) col = vec3(.1, .7, .1);

    // Map the offset from cell center back to screen orientation (main's map is its own inverse)
    float a = radians(ANGLE);
    vec2 v = f - .5;
    vec2 s = vec2(dot(v, vec2(-sin(a), cos(a))), dot(v, vec2(cos(a), sin(a))));
    return mix(col, vec3(.1, .2, .9), dbgLabel(s * 24. + vec2(9.5, 2.5), id));
}
