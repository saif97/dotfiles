// ============================================================================
// TUNABLE PARAMETERS - Adjust for vintage amber CRT effect
// ============================================================================

float warp = 0.2;        // CRT curvature (higher = more curved). Try 0.5-1.0 for strong effect
float scan = 0.1;        // Scanline darkness (higher = darker lines). Try 0.3-0.6
float vignette = 0.5;    // Edge darkening intensity. Try 0.3-0.7
float brightness = 1.5;  // Overall brightness boost. Try 1.0-1.5

// CRT rolling effect (horizontal lines moving down)
float rollSpeed = 0.15;   // Speed of rolling lines. Try 0.1-0.3 (0.0 to disable)
float rollIntensity = 0.15; // Brightness variation of roll lines. Try 0.1-0.3

// Amber/sepia color tint (old CRT monitor look)
vec3 crtColor = vec3(1.0, 0.75, 0.35);  // Warm amber. Try adjusting RGB for different tones

// ============================================================================

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // squared distance from center
    vec2 uv = fragCoord / iResolution.xy;
    vec2 dc = abs(0.5 - uv);
    dc *= dc;
    
    // warp the fragment coordinates
    uv.x -= 0.5; uv.x *= 1.0 + (dc.y * (0.3 * warp)); uv.x += 0.5;
    uv.y -= 0.5; uv.y *= 1.0 + (dc.x * (0.4 * warp)); uv.y += 0.5;

    // sample inside boundaries, otherwise set to black
    if (uv.y > 1.0 || uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0)
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    else
    {
        // Scanline effect
        float scanlineIntensity = abs(sin(fragCoord.y) * 0.5 * scan);

        // Sample texture and apply amber CRT color tint
        vec3 color = texture(iChannel0, uv).rgb;
        vec3 tintedColor = color * crtColor * brightness;

        // Apply scanlines
        tintedColor = mix(tintedColor, vec3(0.0), scanlineIntensity);

        // CRT rolling effect (horizontal refresh lines moving down)
        float rollPos = mod(fragCoord.y + iTime * iResolution.y * rollSpeed, iResolution.y);
        float rollLine = smoothstep(0.0, 50.0, rollPos) * smoothstep(100.0, 50.0, rollPos);
        tintedColor += tintedColor * rollLine * rollIntensity;

        // Vignette effect (darken edges)
        vec2 vignetteUV = fragCoord / iResolution.xy;
        vignetteUV *= 1.0 - vignetteUV.yx;
        float vig = vignetteUV.x * vignetteUV.y * 15.0;
        vig = pow(vig, vignette);

        tintedColor *= vig;

        fragColor = vec4(tintedColor, 1.0);
    }
}
