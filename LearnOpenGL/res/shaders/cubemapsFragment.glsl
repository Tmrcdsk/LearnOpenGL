#version 330 core
out vec4 FragColor;

in vec3 vNormal;
in vec3 vPosition;

uniform vec3 uCameraPos;
uniform samplerCube uSkybox;

void main()
{
    float ratio = 1.00 / 1.52;
    vec3 I = normalize(vPosition - uCameraPos);
    vec3 R = refract(I, normalize(vNormal), ratio);
    FragColor = vec4(texture(uSkybox, R).rgb, 1.0);
}