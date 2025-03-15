#version 330 core
out vec4 FragColor;

in vec2 vTexCoords;

uniform sampler2D uScreenTexture;

void main()
{
    FragColor = texture(uScreenTexture, vTexCoords);
    float average = (FragColor.r + FragColor.g + FragColor.b) / 3.0;
    FragColor = vec4(average, average, average, 1.0);
} 