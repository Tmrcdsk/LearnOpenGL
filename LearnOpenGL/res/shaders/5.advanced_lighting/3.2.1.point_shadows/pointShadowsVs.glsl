#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;

out VS_OUT
{
	vec3 FragPos;
	vec3 Normal;
	vec2 TexCoords;
} vs_out;

uniform mat4 uProjection;
uniform mat4 uView;
uniform mat4 uModel;

uniform bool uReverseNormals;

void main()
{
	vs_out.FragPos = vec3(uModel * vec4(aPos, 1.0));
	if (uReverseNormals) // a slight hack to make sure the outer large cube displays lighting from the 'inside' instead of the default 'outside'.
		vs_out.Normal = transpose(inverse(mat3(uModel))) * (-1.0 * aNormal);
	else
		vs_out.Normal = transpose(inverse(mat3(uModel))) * aNormal;
	vs_out.TexCoords = aTexCoords;
	gl_Position = uProjection * uView * uModel * vec4(aPos, 1.0);
}
