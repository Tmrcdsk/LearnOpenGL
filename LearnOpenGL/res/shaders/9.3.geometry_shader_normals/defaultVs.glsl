#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 2) in vec2 aTexCoords; // 注意这里是 location = 2

out vec2 vTexCoords;

uniform mat4 uProjection;
uniform mat4 uView;
uniform mat4 uModel;

void main()
{
	vTexCoords = aTexCoords;
	gl_Position = uProjection * uView * uModel * vec4(aPos, 1.0);
}
