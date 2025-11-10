shader_type spatial;

uniform sampler2D NOISE_PATTERN;

void fragment(){
    float noiseValue = texture(NOISE_PATTERN, UV).x;
    ALBEDO = vec3(0.0, 0.0, noiseValue*10.0);
}

