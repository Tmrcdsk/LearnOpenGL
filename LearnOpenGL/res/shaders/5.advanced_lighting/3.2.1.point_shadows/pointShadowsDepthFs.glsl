#version 330 core
in vec4 FragPos;

uniform vec3 uLightPos;
uniform float uFarPlane;

void main()
{
	float lightDistance = length(FragPos.xyz - uLightPos);
	
	// map to [0;1] range by dividing by uFarPlane
	lightDistance = lightDistance / uFarPlane;

	// write this as modified depth
	gl_FragDepth = lightDistance;
}
