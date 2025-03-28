#version 330 core
out float FragColor;

in vec2 vTexCoords;

uniform sampler2D uGPosition;
uniform sampler2D uGNormal;
uniform sampler2D uTexNoise;

uniform vec3 uSamples[64];

// parameters (you'd probably want to use them as uniforms to more easily tweak the effect)
int kernelSize = 64;
float radius = 0.5;
float bias = 0.025;

// tile noise texture over screen based on screen dimensions divided by noise size
const vec2 noiseScale = vec2(1200.0 / 4.0, 900.0 / 4.0);

uniform mat4 uProjection;

void main()
{
	// get input for SSAO algorithm
	vec3 fragPos = texture(uGPosition, vTexCoords).xyz;
	vec3 normal = normalize(texture(uGNormal, vTexCoords).xyz);
	vec3 randomVec = normalize(texture(uTexNoise, vTexCoords * noiseScale).xyz);
	// create TBN change-of-basis matrix: from tangent-space to view-space
	vec3 tangent = normalize(randomVec - normal * dot(randomVec, normal));
	vec3 bitangent = cross(normal, tangent);
	mat3 TBN = mat3(tangent, bitangent, normal);
	// iterate over the sample kernel and calculate occlusion factor
	float occlusion = 0.0;
	for (int i = 0; i < kernelSize; ++i)
	{
		// get sample position
		vec3 samplePos = TBN * uSamples[i]; // from tangent to view-space
		samplePos = fragPos + samplePos * radius;

		// project sample position (to sample texture) (to get position on screen/texture)
		vec4 offset = vec4(samplePos, 1.0);
		offset = uProjection * offset; // from view to clip-space
		offset.xyz /= offset.w; // perspective divide
		offset.xyz = offset.xyz * 0.5 + 0.5; // transform to range 0.0 - 1.0

		// get sample depth
		float sampleDepth = texture(uGPosition, offset.xy).z; // get depth value of kernel sample

		// range check & accumulate
		float rangeCheck = smoothstep(0.0, 1.0, radius / abs(fragPos.z - sampleDepth));
		occlusion += (sampleDepth >= samplePos.z + bias ? 1.0 : 0.0) * rangeCheck;
	}
	occlusion = 1.0 - (occlusion / kernelSize);

	FragColor = occlusion;
}
