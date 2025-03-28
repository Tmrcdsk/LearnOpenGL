#version 330 core
layout (location = 0) in vec3 aPos;

uniform mat4 uProjection;
uniform mat4 uView;

out vec3 vWorldPos;

void main()
{
	vWorldPos = aPos;

	mat4 rotView = mat4(mat3(uView));
	vec4 clipPos = uProjection * rotView * vec4(vWorldPos, 1.0);

	gl_Position = clipPos.xyww;
}