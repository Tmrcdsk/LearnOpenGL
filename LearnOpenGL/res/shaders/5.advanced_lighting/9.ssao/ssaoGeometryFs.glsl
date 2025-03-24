#version 330 core
layout (location = 0) out vec3 gPosition;
layout (location = 1) out vec3 gNormal;
layout (location = 2) out vec3 gAlbedo;

in vec2 vTexCoords;
in vec3 vFragPos;
in vec3 vNormal;

void main()
{
	// store the fragment position vector in the first gbuffer texture
	gPosition = vFragPos;
	// also store the per-fragment normals into the gbuffer
	gNormal = normalize(vNormal);
	// and the diffuse per-fragment color
	gAlbedo.rgb = vec3(0.95);
}
