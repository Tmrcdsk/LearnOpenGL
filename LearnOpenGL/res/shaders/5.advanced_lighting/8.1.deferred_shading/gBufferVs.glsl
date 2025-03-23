#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;

out vec3 vFragPos;
out vec2 vTexCoords;
out vec3 vNormal;

uniform mat4 uModel;
uniform mat4 uView;
uniform mat4 uProjection;

void main()
{
	vec4 worldPos = uModel * vec4(aPos, 1.0);
	vFragPos = worldPos.xyz;
	vTexCoords = aTexCoords;

	mat3 normalMatrix = transpose(inverse(mat3(uModel)));
	vNormal = normalMatrix * aNormal;

	gl_Position = uProjection * uView * worldPos;
}
