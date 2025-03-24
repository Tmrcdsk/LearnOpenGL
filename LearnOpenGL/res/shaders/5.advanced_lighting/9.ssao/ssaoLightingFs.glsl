#version 330 core
out vec4 FragColor;

in vec2 vTexCoords;

uniform sampler2D uGPosition;
uniform sampler2D uGNormal;
uniform sampler2D uGAlbedo;
uniform sampler2D uSSAO;

struct Light {
	vec3 Position;
	vec3 Color;
	
	float Linear;
	float Quadratic;
};
uniform Light uLight;

void main()
{
	// retrieve data from gbuffer
	vec3 FragPos = texture(uGPosition, vTexCoords).xyz;
	vec3 Normal = texture(uGNormal, vTexCoords).xyz;
	vec3 Diffuse = texture(uGAlbedo, vTexCoords).rgb;
	float AmbientOcclusion = texture(uSSAO, vTexCoords).r;

	// then calculate lighting as usual
	vec3 ambient = vec3(0.3 * Diffuse * AmbientOcclusion);
	vec3 lighting  = ambient; 
	vec3 viewDir  = normalize(-FragPos); // viewpos is (0.0.0)
	// diffuse
	vec3 lightDir = normalize(uLight.Position - FragPos);
	vec3 diffuse = max(dot(Normal, lightDir), 0.0) * Diffuse * uLight.Color;
	// specular
	vec3 halfwayDir = normalize(lightDir + viewDir);  
	float spec = pow(max(dot(Normal, halfwayDir), 0.0), 8.0);
	vec3 specular = uLight.Color * spec;
	// attenuation
	float distance = length(uLight.Position - FragPos);
	float attenuation = 1.0 / (1.0 + uLight.Linear * distance + uLight.Quadratic * distance * distance);
	diffuse *= attenuation;
	specular *= attenuation;
	lighting += diffuse + specular;
	
	FragColor = vec4(lighting, 1.0);
}
