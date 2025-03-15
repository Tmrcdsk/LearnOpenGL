#version 330 core
out vec4 FragColor;

in vec2 vTexCoords;

uniform sampler2D uScreenTexture;

void main()
{
    FragColor = vec4(vec3(1.0 - texture(uScreenTexture, vTexCoords)), 1.0);
} 