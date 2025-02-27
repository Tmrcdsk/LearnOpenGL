#pragma once

#include <string>

class Shader
{
public:
	Shader(const char* vertexPath, const char* fragmentPath);
	~Shader();

	void Bind() const;
	void Unbind() const;

	void SetUniformBool(const std::string& name, bool value) const;
	void SetUniformInt(const std::string& name, int value) const;
	void SetUniformFloat(const std::string& name, float value) const;
	void SetUniformFloat2(const std::string& name, float v0, float v1) const;
	void SetUniformFloat3(const std::string& name, float v0, float v1, float v2) const;
	void SetUniformFloat4(const std::string& name, float v0, float v1, float v2, float v3) const;
private:
	unsigned int m_RendererID;
};