// Author:ZG-XiaoShu
// License: MIT
uniform float maxKernel; // = 15.0
const vec2 d = vec2(1.0/480.0, 1.0/360.0);

vec4 processSample(vec2 uv, bool useFirstTexture, int kernel, float effectValue) {
    vec4 maxCol;
    if (useFirstTexture) {
        maxCol = getFromColor(uv);  // texture2D → texture
    } else {
        maxCol = getToColor(uv);  // texture2D → texture
    }
    float maxKernel = float(kernel);
    float minKernel = maxKernel * 0.8;

    for (int x = -20; x <= 20; x++) {
        for (int y = -20; y <= 20; y++) {
            vec2 xy = vec2(x, y);
            float dis = distance(xy, vec2(0, 0));
            if (dis < maxKernel && dis > minKernel) {
                vec4 col;
                if (useFirstTexture) {
                    col = getFromColor(uv + d * xy);
                } else {
                    col = getToColor(uv + d * xy);
                }
                maxCol = max(maxCol, col);
            }
        }
    }
    return maxCol;
}

vec4 transition (vec2 uv) {
  float phase = clamp(progress * 3.0, 0.0, 3.0);

    if (phase < 1.0) {
        int kernel = int(maxKernel * phase);
        return processSample(uv, true, kernel, phase);
    }
    else if (phase < 2.0) {
        vec4 col1 = processSample(uv, true, int(maxKernel), 1.0);
        vec4 col2 = processSample(uv, false, int(maxKernel), 1.0);
        return mix(col1, col2, phase - 1.0);
    }
    else {
        int kernel = 7 - int(maxKernel * (phase - 2.0));
        return processSample(uv, false, kernel, 3.0 - phase); 
    }
}
