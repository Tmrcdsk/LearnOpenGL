#version 330 core
out vec4 FragColor;

in vec2 vTexCoords;

uniform sampler2D uTexture1;

void main()
{
    FragColor = texture(uTexture1, vTexCoords);
}
