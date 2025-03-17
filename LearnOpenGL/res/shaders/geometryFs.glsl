#version 330 core
out vec4 FragColor;

in vec2 vTexCoords;

uniform sampler2D uTextureDiffuse1;

void main()
{
    FragColor = texture(uTextureDiffuse1, vTexCoords);
}