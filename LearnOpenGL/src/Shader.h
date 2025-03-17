#pragma once

#include <string>

#include <glm/glm.hpp>

class Shader
{
public:
	Shader(const char* vertexPath, const char* fragmentPath, const char* geometryPath = nullptr);
	~Shader();

	void Bind() const;
	void Unbind() const;

	void SetUniformBool(const std::string& name, bool value) const;
	void SetUniformInt(const std::string& name, int value) const;
	void SetUniformFloat(const std::string& name, float value) const;
	void SetUniformFloat2(const std::string& name, float v0, float v1) const;
	void SetUniformFloat3(const std::string& name, float v0, float v1, float v2) const;
	void SetUniformFloat3(const std::string& name, const glm::vec3& values) const;
	void SetUniformFloat4(const std::string& name, float v0, float v1, float v2, float v3) const;
	void SetUniformMat3(const std::string& name, const glm::mat3& matrix) const;
	void SetUniformMat4(const std::string& name, const glm::mat4& matrix) const;
	void SetUniformBlock(const std::string& name, unsigned int uniformBlockIndex) const;
private:
	unsigned int m_RendererID;
};