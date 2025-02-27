#version 330 core
out vec4 FragColor;

in vec3 vColor;
uniform vec3 uColor;

void main()
{
	FragColor = vec4(uColor, 1.0f);
}