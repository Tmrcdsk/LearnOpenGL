#version 330 core
out vec4 FragColor;

in vec3 vNormal;
in vec3 vPosition;

uniform vec3 uCameraPos;
uniform samplerCube uSkybox;

void main()
{
    vec3 I = normalize(vPosition - uCameraPos);
    vec3 R = reflect(I, normalize(vNormal));
    FragColor = vec4(texture(uSkybox, R).rgb, 1.0);
}