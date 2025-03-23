#version 330 core
out vec4 FragColor;

in vec2 vTexCoords;

uniform sampler2D uScene;
uniform sampler2D uBloomBlur;
uniform bool uBloom;
uniform float uExposure;

void main()
{
	const float gamma = 2.2;
	vec3 hdrColor = texture(uScene, vTexCoords).rgb;
	vec3 bloomColor = texture(uBloomBlur, vTexCoords).rgb;
	if (uBloom)
		hdrColor += bloomColor; // additive blending
	// tone mapping
	vec3 result = vec3(1.0) - exp(-hdrColor * uExposure);
	// also gamma correct while we're at it
	result = pow(result, vec3(1.0 / gamma));
	FragColor = vec4(result, 1.0);
}
