#version 330 core
out vec4 FragColor;

in vec3 vFragPos;
in vec3 vNormal;
in vec2 vTexCoords;

uniform vec3 uViewPos;

struct Material {
	// ��������ɫ�ڼ�����������¶�������������ɫ���������ǲ���Ҫ�����Ƿֿ�����
	sampler2D diffuse;
	sampler2D specular;
	float shininess;
};
uniform Material material;

struct Light {
	vec3 position;
	vec3 direction;
	float cutOff;
	float outerCutOff;

	vec3 ambient;
	vec3 diffuse;
	vec3 specular;

	float constant;
	float linear;
	float quadratic;
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

	// spotlight (soft edges)
	float theta = dot(lightDir, normalize(-light.direction));
	float epsilon = light.cutOff - light.outerCutOff;
	// ��ȷ��Լ��(Clamp)���ֵ����Ƭ����ɫ���оͲ�����Ҫif-else��
	float intensity = clamp((theta - light.outerCutOff) / epsilon, 0.0, 1.0);
	diffuse *= intensity;
	specular *= intensity;

	// attenuation
	float distance = length(light.position - vFragPos);
	float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * distance * distance);
	ambient *= attenuation;
	diffuse *= attenuation;
	specular *= attenuation;

	vec3 result = ambient + diffuse + specular;
	FragColor = vec4(result, 1.0);
}