#version 330 core
out vec4 FragColor;

in vec2 vTexCoords;

uniform sampler2D uScreenTexture;

void main()
{
    vec3 col = texture(uScreenTexture, vTexCoords).rgb;
    float grayscale = 0.2126 * col.r + 0.7152 * col.g + 0.0722 * col.b;
    FragColor = vec4(vec3(grayscale), 1.0);
}
