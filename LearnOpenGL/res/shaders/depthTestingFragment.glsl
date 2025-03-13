#version 330 core
out vec4 FragColor;

in vec2 vTexCoords;

uniform float uNear;
uniform float uFar;

float LinearizeDepth(float depth)
{
    float z = depth * 2.0 - 1.0; // ת��Ϊndc
    return (2.0 * uNear * uFar) / (uFar + uNear - z * (uFar - uNear));
}

void main()
{
    float depth = LinearizeDepth(gl_FragCoord.z) / uFar; // Ϊ����ʾ����far
    FragColor = vec4(vec3(depth), 1.0);
}
