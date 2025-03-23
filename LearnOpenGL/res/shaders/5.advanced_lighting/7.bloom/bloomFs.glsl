#version 330 core
layout (location = 0) out vec4 FragColor;
layout (location = 1) out vec4 BrightColor;

in VS_OUT {
    vec3 FragPos;
    vec3 Normal;
    vec2 TexCoords;
} fs_in;

struct Light {
    vec3 Position;
    vec3 Color;
};

uniform Light uLights[4];
uniform sampler2D uDiffuseTexture;
uniform vec3 uViewPos;

void main()
{
    vec3 color = texture(uDiffuseTexture, fs_in.TexCoords).rgb;
    vec3 normal = normalize(fs_in.Normal);
    // ambient
    vec3 ambient = 0.0 * color;
    // lighting
    vec3 lighting = vec3(0.0);
    vec3 viewDir = normalize(uViewPos - fs_in.FragPos);
    for (int i = 0; i < 4; ++i)
    {
        // diffuse
        vec3 lightDir = normalize(uLights[i].Position - fs_in.FragPos);
        float diff = max(0.0, dot(lightDir, normal));
        vec3 result = uLights[i].Color * diff * color;
        // attenuation (use quadratic as we have gamma correction)
        float distance = length(fs_in.FragPos - uLights[i].Position);
        result *= 1.0 / (distance * distance);
        lighting += result;
    }
    vec3 result = ambient + lighting;
    // check whether result is higher than some threshold, if so, output as bloom threshold color
    float brightness = dot(result, vec3(0.2126, 0.7152, 0.0722));
    if (brightness > 1.0)
        BrightColor = vec4(result, 1.0);
    else
        BrightColor = vec4(0.0, 0.0, 0.0, 1.0);
    FragColor = vec4(result, 1.0);
}
