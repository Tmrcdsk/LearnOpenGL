#version 330 core
layout (location = 0) out vec3 gPosition;
layout (location = 1) out vec3 gNormal;
layout (location = 2) out vec4 gAlbedoSpec;

in vec2 vTexCoords;
in vec3 vFragPos;
in vec3 vNormal;

uniform sampler2D uTextureDiffuse1;
uniform sampler2D uTextureSpecular1;

void main()
{
	// store the fragment position vector in the first gbuffer texture
	gPosition = vFragPos;
	// also store the per-fragment normals into the gbuffer
	gNormal = normalize(vNormal);
	// and the diffuse per-fragment color
	gAlbedoSpec.rgb = texture(uTextureDiffuse1, vTexCoords).rgb;
	// store specular intensity in gAlbedoSpec's alpha component
	gAlbedoSpec.a = texture(uTextureSpecular1, vTexCoords).r;
}
