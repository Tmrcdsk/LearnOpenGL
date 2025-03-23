#version 330 core
out vec4 FragColor;

in vec2 vTexCoords;

uniform sampler2D uGPosition;
uniform sampler2D uGNormal;
uniform sampler2D uGAlbedoSpec;

struct Light {
	vec3 Position;
	vec3 Color;
	
	float Linear;
	float Quadratic;
};
const int NR_LIGHTS = 32;
uniform Light uLights[NR_LIGHTS];
uniform vec3 uViewPos;

void main()
{
	// retrieve data from gbuffer
	vec3 FragPos = texture(uGPosition, vTexCoords).rgb;
	vec3 Normal = texture(uGNormal, vTexCoords).rgb;
	vec3 Diffuse = texture(uGAlbedoSpec, vTexCoords).rgb;
	float Specular = texture(uGAlbedoSpec, vTexCoords).a;

	// then calculate lighting as usual
	vec3 lighting  = Diffuse * 0.1; // hard-coded ambient component
	vec3 viewDir  = normalize(uViewPos - FragPos);
	for (int i = 0; i < NR_LIGHTS; ++i)
	{
		// diffuse
		vec3 lightDir = normalize(uLights[i].Position - FragPos);
		vec3 diffuse = max(dot(Normal, lightDir), 0.0) * Diffuse * uLights[i].Color;
		// specular
		vec3 halfwayDir = normalize(lightDir + viewDir);
		float spec = pow(max(dot(Normal, halfwayDir), 0.0), 16.0);
		vec3 specular = uLights[i].Color * spec * Specular;
		// attenuation
		float distance = length(uLights[i].Position - FragPos);
		float attenuation = 1.0 / (1.0 + uLights[i].Linear * distance + uLights[i].Quadratic * distance * distance);
		diffuse *= attenuation;
		specular *= attenuation;
		lighting += diffuse + specular;
	}
	FragColor = vec4(lighting, 1.0);
}
