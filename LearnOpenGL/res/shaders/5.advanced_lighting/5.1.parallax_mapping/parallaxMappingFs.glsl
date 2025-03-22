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
	float height = texture(uDepthMap, texCoords).r;
	return texCoords - viewDir.xy /*/ viewDir.z*/ * (height * uHeightScale);
	// 有偏移量限制的视差贴图 (Parallax Mapping with Offset Limiting)，如果除以 viewDir.z 则是普通的视差贴图
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
