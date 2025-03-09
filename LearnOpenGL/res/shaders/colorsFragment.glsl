#version 330 core
out vec4 FragColor;

in vec3 vFragPos;
in vec3 vNormal;

uniform vec3 uObjectColor;
uniform vec3 uLightColor;
uniform vec3 uLightPos;
uniform vec3 uViewPos;

struct Material {
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
	float shininess;
};
uniform Material material;

void main()
{
	// ambient
	vec3 ambient = material.ambient * uLightColor;

	// diffuse
	vec3 normal = normalize(vNormal);
	vec3 lightDir = normalize(uLightPos - vFragPos);
	float diff = max(0.0, dot(normal, lightDir));
	vec3 diffuse = material.diffuse * diff * uLightColor;

	// specular
	vec3 viewDir = normalize(uViewPos - vFragPos);
	vec3 reflectDir = reflect(-lightDir, normal);
	float spec = pow(max(0.0, dot(viewDir, reflectDir)), material.shininess);
	vec3 specular = material.specular * spec * uLightColor;

	vec3 result = (ambient + diffuse + specular) * uObjectColor;
	FragColor = vec4(result, 1.0);
}