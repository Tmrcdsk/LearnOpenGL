#version 330 core
out vec4 FragColor;

in VS_OUT
{
	vec3 FragPos;
	vec3 Normal;
	vec2 TexCoords;
} fs_in;

uniform sampler2D uFloorTexture;
uniform vec3 uLightPos;
uniform vec3 uViewPos;
uniform bool uBlinn;

void main()
{
	vec3 color = texture(uFloorTexture, fs_in.TexCoords).rgb;
	// ambient
	vec3 ambient = 0.05 * color;
	// diffuse
	vec3 lightDir = normalize(uLightPos - fs_in.FragPos);
	vec3 normal = normalize(fs_in.Normal);
	float diff = max(0.0, dot(lightDir, normal));
	vec3 diffuse = diff * color;
	// specular
	vec3 viewDir = normalize(uViewPos - fs_in.FragPos);
	float spec = 0.0;
	if (uBlinn)
	{
		vec3 halfwayDir = normalize(lightDir + viewDir);
		spec = pow(max(0.0, dot(halfwayDir, normal)), 32.0);
	}
	else
	{
		vec3 reflectDir = reflect(-lightDir, normal);
		spec = pow(max(0.0, dot(viewDir, reflectDir)), 8.0);
	}
	vec3 specular = vec3(0.3) * spec; // assuming bright white light color
	FragColor = vec4(ambient + diffuse + specular, 1.0);
}
