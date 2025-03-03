#version 330 core
out vec4 FragColor;

in vec2 vTexCoord;

uniform sampler2D uTexture1;
uniform sampler2D uTexture2;

void main()
{
	/* texture(): 第一个参数为纹理采样器，第二个参数为对应纹理坐标 */
	FragColor = mix(texture(uTexture1, vTexCoord), texture(uTexture2, vTexCoord), 0.2);// * vec4(vColor, 1.0);
}