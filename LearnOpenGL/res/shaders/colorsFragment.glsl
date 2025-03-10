#version 330 core
out vec4 FragColor;

in vec3 vFragPos;
in vec3 vNormal;
in vec2 vTexCoords;

uniform vec3 uViewPos;

struct Material {
	// 环境光颜色在几乎所有情况下都等于漫反射颜色，所以我们不需要将它们分开储存
	sampler2D diffuse;
	sampler2D specular;
	float shininess;
};
uniform Material material;

struct Light {
	vec3 position;
	vec3 ambient;
	vec3 diffuse;
	vec3 specular;
};
uniform Light light;

void main()
{
	// ambient
	vec3 ambient = light.ambient * vec3(texture(material.diffuse, vTexCoords));

	// diffuse
	vec3 normal = normalize(vNormal);
	vec3 lightDir = normalize(light.position - vFragPos);
	float diff = max(0.0, dot(normal, lightDir));
	vec3 diffuse = light.diffuse * diff * vec3(texture(material.diffuse, vTexCoords));

	// specular
	vec3 viewDir = normalize(uViewPos - vFragPos);
	vec3 reflectDir = reflect(-lightDir, normal);
	float spec = pow(max(0.0, dot(viewDir, reflectDir)), material.shininess);
	vec3 specular = light.specular * spec * vec3(texture(material.specular, vTexCoords));

	vec3 result = ambient + diffuse + specular;
	FragColor = vec4(result, 1.0);
}