#version 330 core
out vec4 FragColor;

in VS_OUT
{
	vec3 FragPos;
	vec3 Normal;
	vec2 TexCoords;
	vec4 FragPosLightSpace;
} fs_in;

uniform sampler2D uDiffuseTexture;
uniform sampler2D uShadowMap;

uniform vec3 uLightPos;
uniform vec3 uViewPos;

uniform bool uShadows;

float ShadowCalculation(vec4 fragPosLightSpace)
{
	// perform perspective divide
	vec3 projCoords = fragPosLightSpace.xyz / fragPosLightSpace.w;
	// transform to [0,1] range
	projCoords = projCoords * 0.5 + 0.5;
	// get closest depth value from light's perspective (using [0,1] range fragPosLight as coords)
	float closestDepth = texture(uShadowMap, projCoords.xy).r; 
	// get depth of current fragment from light's perspective
	float currentDepth = projCoords.z;
	// calculate bias (based on depth map resolution and slope)
	vec3 normal = normalize(fs_in.Normal);
	vec3 lightDir = normalize(uLightPos - fs_in.FragPos);
	float bias = max(0.05 * (1.0 - dot(normal, lightDir)), 0.005);
	// check whether current frag pos is in shadow
	// float shadow = currentDepth - bias > closestDepth ? 1.0 : 0.0;
	// PCF
	float shadow = 0.0;
	vec2 texelSize = 1.0 / textureSize(uShadowMap, 0);
	for(int x = -1; x <= 1; ++x)
	{
		for(int y = -1; y <= 1; ++y)
		{
			float pcfDepth = texture(uShadowMap, projCoords.xy + vec2(x, y) * texelSize).r; 
			shadow += currentDepth - bias > pcfDepth ? 1.0 : 0.0;
		}
	}
	shadow /= 9.0;

	// Keep the shadow at 0.0 when outside the far_plane region of the light's frustum.
	if (projCoords.z > 1.0)
		shadow = 0.0;
	
	return shadow;
}

void main()
{
	vec3 color = texture(uDiffuseTexture, fs_in.TexCoords).rgb;
	vec3 normal = normalize(fs_in.Normal);
	vec3 lightColor = vec3(0.3);
	// ambient
	vec3 ambient = 0.3 * lightColor;
	// diffuse
	vec3 lightDir = normalize(uLightPos - fs_in.FragPos);
	float diff = max(0.0, dot(lightDir, normal));
	vec3 diffuse = diff * lightColor;
	// specular
	vec3 viewDir = normalize(uViewPos - fs_in.FragPos);
	vec3 reflectDir = reflect(-lightDir, normal);
	float spec = 0.0;
	vec3 halfwayDir = normalize(lightDir + viewDir);
	spec = pow(max(0.0, dot(halfwayDir, normal)), 64.0);
	vec3 specular = spec * lightColor;
	// calculate shadow
	float shadow = uShadows ? ShadowCalculation(fs_in.FragPosLightSpace) : 0.0;
	shadow = min(shadow, 0.75); // reduce shadow strength a little: allow some diffuse/specular light in shadowed regions
	vec3 lighting = (ambient + (1.0 - shadow) * (diffuse + specular)) * color;

	FragColor = vec4(lighting, 1.0);
}
