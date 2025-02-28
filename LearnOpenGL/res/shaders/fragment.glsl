#version 330 core
out vec4 FragColor;

in vec3 vColor;
in vec2 vTexCoord;

uniform sampler2D uTexture;

void main()
{
	/* texture(): 第一个参数为纹理采样器，第二个参数为对应纹理坐标 */
	FragColor = texture(uTexture, vTexCoord);// * vec4(vColor, 1.0);
}