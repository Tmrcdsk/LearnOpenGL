#version 330 core
out vec4 FragColor;

in vec2 vTexCoord;

uniform sampler2D uTexture1;
uniform sampler2D uTexture2;

void main()
{
	/* texture(): ��һ������Ϊ������������ڶ�������Ϊ��Ӧ�������� */
	FragColor = mix(texture(uTexture1, vTexCoord), texture(uTexture2, vTexCoord), 0.2);// * vec4(vColor, 1.0);
}