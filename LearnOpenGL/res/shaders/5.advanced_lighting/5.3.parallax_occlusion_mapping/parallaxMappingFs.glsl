#version 330 core
out vec4 FragColor;

in VS_OUT
{
	vec3 FragPos;
	vec2 TexCoords;
	vec3 TangentLightPos;
	vec3 TangentViewPos;
	vec3 TangentFragPos;
} fs_in;

uniform sampler2D uDiffuseMap;
uniform sampler2D uNormalMap;
uniform sampler2D uDepthMap;

uniform float uHeightScale;

vec2 ParallaxMapping(vec2 texCoords, vec3 viewDir)
{
	// number of depth layers
	const float minLayers = 8;
	const float maxLayers = 32;
	float numLayers = mix(maxLayers, minLayers, abs(dot(vec3(0.0, 0.0, 1.0), viewDir)));
	// calculate the size of each layer
	float layerDepth = 1.0 / numLayers;
	// depth of current layer
	float currentLayerDepth = 0.0;
	// the amount to shift the texture coordinates per layer (from vector P)
	vec2 P = viewDir.xy / viewDir.z * uHeightScale;
	vec2 deltaTexCoords = P / numLayers;

	// get initial values
	vec2 currentTexCoords = texCoords;
	float currentDepthMapValue = texture(uDepthMap, currentTexCoords).r;

	while (currentLayerDepth < currentDepthMapValue)
	{
		// shift texture coordinates along direction of P
		currentTexCoords -= deltaTexCoords;
		// get depthmap value at current texture coordinates
		currentDepthMapValue = texture(uDepthMap, currentTexCoords).r;
		// get depth of next layer
		currentLayerDepth += layerDepth;
	}

	// get texture coordinates before collision (reverse operations)
	vec2 prevTexCoords = currentTexCoords + deltaTexCoords;

	// get depth after and before collision for linear interpolation
	float afterDepth = currentLayerDepth - currentDepthMapValue;
	float beforeDepth = texture(uDepthMap, prevTexCoords).r - (currentLayerDepth - layerDepth);

	// interpolation of texture coordinates
	float weight = afterDepth / (afterDepth + beforeDepth);
	vec2 finalTexCoords = weight * prevTexCoords + (1.0 - weight) * currentTexCoords;

	return finalTexCoords;
}

void main()
{
	// offset texture coordinates with Parallax Mapping
	vec3 viewDir = normalize(fs_in.TangentViewPos - fs_in.TangentFragPos);
	vec2 texCoords = fs_in.TexCoords;

	texCoords = ParallaxMapping(fs_in.TexCoords, viewDir);
	if (texCoords.x > 1.0 || texCoords.y > 1.0 || texCoords.x < 0.0 || texCoords.y < 0.0)
		discard;

	// obtain normal from normal map
	vec3 normal = texture(uNormalMap, texCoords).rgb;
	normal = normalize(normal * 2.0 - 1.0);

	// get diffuse color
	vec3 color = texture(uDiffuseMap, texCoords).rgb;
	// ambient
	vec3 ambient = 0.1 * color;
	// diffuse
	vec3 lightDir = normalize(fs_in.TangentLightPos - fs_in.TangentFragPos);
	float diff = max(0.0, dot(lightDir, normal));
	vec3 diffuse = diff * color;
	// specular
	vec3 haldwayDir = normalize(lightDir + viewDir);
	float spec = pow(max(0.0, dot(haldwayDir, normal)), 32.0);

	vec3 specular = spec * vec3(0.2);
	FragColor = vec4(ambient + diffuse + specular, 1.0);
}
