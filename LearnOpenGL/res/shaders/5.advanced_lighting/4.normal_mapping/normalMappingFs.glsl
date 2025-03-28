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

uniform vec3 uLightPos;
uniform vec3 uViewPos;

void main()
{
	// obtain normal from normal map in range [0,1]
	vec3 normal = texture(uNormalMap, fs_in.TexCoords).rgb;
	// transform normal vector to range [-1,1]
	normal = normalize(normal * 2.0 - 1.0); // this normal is in tangent space

	// get diffuse color
	vec3 color = texture(uDiffuseMap, fs_in.TexCoords).rgb;
	// ambient
	vec3 ambient = 0.1 * color;
	// diffuse
	vec3 lightDir = normalize(fs_in.TangentLightPos - fs_in.TangentFragPos);
	float diff = max(0.0, dot(lightDir, normal));
	vec3 diffuse = diff * color;
	// specular
	vec3 viewDir = normalize(fs_in.TangentViewPos - fs_in.TangentFragPos);
	vec3 halfwayDir = normalize(lightDir + viewDir);
	float spec = pow(max(0.0, dot(normal, halfwayDir)), 32.0);
	vec3 specular = spec * vec3(0.2);

	FragColor = vec4(ambient + diffuse + specular, 1.0);
}
