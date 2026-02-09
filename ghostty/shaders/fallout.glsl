// ============================================================================
// Fallout Terminal Shader for Ghostty
// Inspired by Pip-Boy 3000 and classic Fallout terminals
// ============================================================================

// --- Tunable Parameters ---

// CRT curvature
#define CURVE 15.0, 12.0

// Green Phosphor Color (Classic Pip-Boy Green)
const vec3 phosphorColor = vec3(0.2, 1.0, 0.1);

// Scanline settings
#define SCANLINE_STRENGTH 0.45
#define SCANLINE_PERIOD 2.5

// Bloom (Glow) settings
#define BLOOM_STRENGTH 0.7
#define BLOOM_SPREAD 6.0

// Flicker and Noise
#define FLICKER_STRENGTH 0.04
#define FLICKER_FREQ 20.0
#define NOISE_STRENGTH 0.1

// Vignette (Dark edges)
#define VIGNETTE_STRENGTH 0.25
#define VIGNETTE_BRIGHTNESS 1.5

// Rolling Bar A (Primary)
#define BAR_A_SPEED 0.08
#define BAR_A_INTENSITY 0.15
#define BAR_A_WIDTH 6.0    // Higher = Narrower

// Rolling Bar B (Secondary)
#define BAR_B_SPEED 0.14
#define BAR_B_INTENSITY 0.1
#define BAR_B_WIDTH 15.0   // Higher = Narrower

// Aperture Grille (Vertical subpixels)
#define GRILLE_STRENGTH 0.2

// --- End Parameters ---

// Simple noise function
float noise(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233) + iTime * 0.01)) * 43758.5453);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // 1. CRT Warp & Subtle Jitter
    float jitter = (noise(vec2(iTime, 0.0)) - 0.5) * 0.0003;
    vec2 uv = fragCoord.xy / iResolution.xy + vec2(0.0, jitter);
    
    vec2 warpedUV = (uv - 0.5) * 2.0;
    warpedUV.xy *= 1.0 + pow((abs(vec2(warpedUV.y, warpedUV.x)) / vec2(CURVE)), vec2(2.0));
    warpedUV = (warpedUV / 2.0) + 0.5;

    // 2. Bound Check
    if (warpedUV.x < 0.0 || warpedUV.x > 1.0 || warpedUV.y < 0.0 || warpedUV.y > 1.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }

    // 3. Sample Base Texture
    vec4 baseColor = texture(iChannel0, warpedUV);
    
    // 4. Color Tint (Phosphor Green)
    vec3 color = baseColor.rgb * phosphorColor;
    
    // 5. Scanlines (Horizontal)
    float scanline = mix(1.0, 0.8 + 0.2 * sin(warpedUV.y * iResolution.y * (6.28318 / SCANLINE_PERIOD)), SCANLINE_STRENGTH);
    color *= scanline;

    // 6. Simple Bloom (Fake by sampling nearby)
    vec3 bloom = vec3(0.0);
    vec2 bloomStep = BLOOM_SPREAD / iResolution.xy;
    
    // 4-point cross sample for efficient bloom
    bloom += texture(iChannel0, warpedUV + vec2(bloomStep.x, 0.0)).rgb;
    bloom += texture(iChannel0, warpedUV - vec2(bloomStep.x, 0.0)).rgb;
    bloom += texture(iChannel0, warpedUV + vec2(0.0, bloomStep.y)).rgb;
    bloom += texture(iChannel0, warpedUV - vec2(0.0, bloomStep.y)).rgb;
    
    color += (bloom / 4.0) * phosphorColor * BLOOM_STRENGTH;

    // 7. Flicker
    float flicker = 1.0 - FLICKER_STRENGTH * (0.5 + 0.5 * sin(iTime * FLICKER_FREQ));
    color *= flicker;

    // 8. Overlapping Rolling Bars (Independent Control)
    // Bar A (Primary)
    float rollPosA = fract(iTime * BAR_A_SPEED);
    float barA = pow(max(0.0, 1.0 - abs(fract(warpedUV.y + rollPosA) - 0.5) * BAR_A_WIDTH), 3.0);
    color += color * barA * BAR_A_INTENSITY;
    
    // Bar B (Secondary)
    float rollPosB = fract(iTime * BAR_B_SPEED);
    float barB = pow(max(0.0, 1.0 - abs(fract(warpedUV.y + rollPosB) - 0.5) * BAR_B_WIDTH), 2.0);
    color += color * barB * BAR_B_INTENSITY;

    // 9. Aperture Grille (Vertical lines)
    float grille = 0.85 + 0.15 * sin(fragCoord.x * 1.5);
    color *= mix(1.0, grille, GRILLE_STRENGTH);

    // 10. Noise / Grain
    color += (noise(warpedUV) - 0.5) * NOISE_STRENGTH * phosphorColor;

    // 11. Vignette
    float vig = warpedUV.x * warpedUV.y * (1.0 - warpedUV.x) * (1.0 - warpedUV.y);
    vig = pow(vig * 15.0, VIGNETTE_STRENGTH);
    color *= vig * VIGNETTE_BRIGHTNESS;

    fragColor = vec4(color, baseColor.a);
}