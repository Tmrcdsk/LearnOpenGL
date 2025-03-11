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
	vec3 direction;
	float cutOff;

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
	vec3 lightDir = normalize(light.position - vFragPos);

	// check if lighting is inside the spotlight cone
	float theta = dot(lightDir, normalize(-light.direction));
	
	if (theta > light.cutOff) // remember that we're working with angles as cosines instead of degrees so a '>' is used.
	{
		// ambient
		vec3 ambient = light.ambient * vec3(texture(material.diffuse, vTexCoords));

		// diffuse
		vec3 normal = normalize(vNormal);
		float diff = max(0.0, dot(normal, lightDir));
		vec3 diffuse = light.diffuse * diff * vec3(texture(material.diffuse, vTexCoords));

		// specular
		vec3 viewDir = normalize(uViewPos - vFragPos);
		vec3 reflectDir = reflect(-lightDir, normal);
		float spec = pow(max(0.0, dot(viewDir, reflectDir)), material.shininess);
		vec3 specular = light.specular * spec * vec3(texture(material.specular, vTexCoords));

		// attenuation
		float distance = length(light.position - vFragPos);
		float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * distance * distance);
		ambient *= attenuation;
		diffuse *= attenuation;
		specular *= attenuation;

		vec3 result = ambient + diffuse + specular;
		FragColor = vec4(result, 1.0);
	}
	else
	{
		// else, use ambient light so scene isn't completely dark outside the spotlight.
		FragColor = vec4(light.ambient * texture(material.diffuse, vTexCoords).rgb, 1.0);
	}
}