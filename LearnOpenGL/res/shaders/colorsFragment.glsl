#version 330 core
out vec4 FragColor;

in vec3 vFragPos;
in vec3 vNormal;

uniform vec3 uObjectColor;
uniform vec3 uLightColor;
uniform vec3 uLightPos;

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

	vec3 result = (ambient + diffuse) * uObjectColor;
	FragColor = vec4(result, 1.0);
}