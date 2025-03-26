#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;

out vec2 vTexCoords;
out vec3 vWorldPos;
out vec3 vNormal;

uniform mat4 uProjection;
uniform mat4 uView;
uniform mat4 uModel;
uniform mat3 uNormalMatrix;

void main()
{
	vTexCoords = aTexCoords;
	vWorldPos = vec3(uModel * vec4(aPos, 1.0));
	vNormal = uNormalMatrix * aNormal;

	gl_Position = uProjection * uView * vec4(vWorldPos, 1.0);
}
