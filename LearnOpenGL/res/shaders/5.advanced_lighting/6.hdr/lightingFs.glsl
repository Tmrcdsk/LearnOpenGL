#version 330 core
out vec4 FragColor;

in VS_OUT {
    vec3 FragPos;
    vec3 Normal;
    vec2 TexCoords;
} fs_in;

struct Light {
    vec3 Position;
    vec3 Color;
};

uniform Light uLights[16];
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
    for (int i = 0; i < 16; ++i)
    {
        // diffuse
        vec3 lightDir = normalize(uLights[i].Position - fs_in.FragPos);
        float diff = max(0.0, dot(lightDir, normal));
        vec3 diffuse = uLights[i].Color * diff * color;
        vec3 result = diffuse;
        // attenuation (use quadratic as we have gamma correction)
        float distance = length(fs_in.FragPos - uLights[i].Position);
        result *= 1.0 / (distance * distance);
        lighting += result;
    }
    FragColor = vec4(ambient + lighting, 1.0);
}
