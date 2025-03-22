#version 330 core
out vec4 FragColor;

in VS_OUT {
	vec3 FragPos;
	vec3 Normal;
	vec2 TexCoords;
} fs_in;

uniform sampler2D uDiffuseTexture;
uniform samplerCube uDepthMap;

uniform vec3 uLightPos;
uniform vec3 uViewPos;

uniform float uFarPlane;
uniform bool uShadows;

float ShadowCalculation(vec3 fragPos)
{
	// get vector between fragment position and light position
	vec3 fragToLight = fragPos - uLightPos;
	// ise the fragment to light vector to sample from the depth map
	// float closestDepth = texture(uDepthMap, fragToLight).r;
	// it is currently in linear range between [0,1], let's re-transform it back to original depth value
	// closestDepth *= uFarPlane;
	// now get current linear depth as the length between the fragment and light position
	float currentDepth = length(fragToLight);
	// display closestDepth as debug (to visualize depth cubemap)
	// FragColor = vec4(vec3(closestDepth / uFarPlane), 1.0);
	// test for shadows
	vec3 sampleOffsetDirections[20] = vec3[]
	(
		vec3( 1,  1,  1), vec3( 1, -1,  1), vec3(-1, -1,  1), vec3(-1,  1,  1), 
		vec3( 1,  1, -1), vec3( 1, -1, -1), vec3(-1, -1, -1), vec3(-1,  1, -1),
		vec3( 1,  1,  0), vec3( 1, -1,  0), vec3(-1, -1,  0), vec3(-1,  1,  0),
		vec3( 1,  0,  1), vec3(-1,  0,  1), vec3( 1,  0, -1), vec3(-1,  0, -1),
		vec3( 0,  1,  1), vec3( 0, -1,  1), vec3( 0, -1, -1), vec3( 0,  1, -1)
	);
	float shadow = 0.0;
	float bias = 0.15;
	int samples = 20;
	float viewDistance = length(uViewPos - fragPos);
	float diskRadius = (1.0 + (viewDistance / uFarPlane)) / 25.0;
	for (int i = 0; i < samples; ++i)
	{
		float closestDepth = texture(uDepthMap, fragToLight + sampleOffsetDirections[i] * diskRadius).r;
		closestDepth *= uFarPlane; // undo mapping [0;1]
		if (currentDepth - bias > closestDepth)
			shadow += 1.0;
	}
	shadow /= float(samples);
	
	return shadow;
}

void main()
{
	vec3 color = texture(uDiffuseTexture, fs_in.TexCoords).rgb;
	vec3 normal = normalize(fs_in.Normal);
	vec3 lightColor = vec3(0.3);
	// ambient
	vec3 ambient = 0.3 * lightColor;
	// diffuse
	vec3 lightDir = normalize(uLightPos - fs_in.FragPos);
	float diff = max(0.0, dot(lightDir, normal));
	vec3 diffuse = diff * lightColor;
	// specular
	vec3 viewDir = normalize(uViewPos - fs_in.FragPos);
	float spec = 0.0;
	vec3 halfwayDir = normalize(lightDir + viewDir);
	spec = pow(max(0.0, dot(halfwayDir, normal)), 64.0);
	vec3 specular = spec * lightColor;
	// calculate shadow
	float shadow = uShadows ? ShadowCalculation(fs_in.FragPos) : 0.0;
	vec3 lighting = (ambient + (1.0 - shadow) * (diffuse + specular)) * color;

	FragColor = vec4(lighting, 1.0);
}
