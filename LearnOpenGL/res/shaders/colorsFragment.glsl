#version 330 core
out vec4 FragColor;

in vec3 vFragPos;
in vec3 vNormal;

uniform vec3 uObjectColor;
uniform vec3 uLightColor;
uniform vec3 uLightPos;
uniform vec3 uViewPos;

void main()
{
	// ambient
	float ambientStrength = 0.1;
	vec3 ambient = ambientStrength * uLightColor;

	// diffuse
	vec3 normal = normalize(vNormal);
	vec3 lightDir = normalize(uLightPos - vFragPos);
	float diff = max(0.0, dot(normal, lightDir));
	vec3 diffuse = diff * uLightColor;

	// specular
	float specularStrength = 0.5;
	vec3 viewDir = normalize(uViewPos - vFragPos);
	vec3 reflectDir = reflect(-lightDir, normal);
	float spec = pow(max(0.0, dot(viewDir, reflectDir)), 32);
	vec3 specular = specularStrength * spec * uLightColor;

	vec3 result = (ambient + diffuse + specular) * uObjectColor;
	FragColor = vec4(result, 1.0);
}