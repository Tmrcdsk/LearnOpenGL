#include "Shader.h"

#include <glad/glad.h>

#include <iostream>
#include <fstream>
#include <sstream>

#include <glm/gtc/type_ptr.hpp>

Shader::Shader(const char* vertexPath, const char* fragmentPath)
{
	std::string vertexSrc;
	std::string fragmentSrc;
	std::ifstream vShaderFile;
	std::ifstream fShaderFile;
	vShaderFile.exceptions(std::ifstream::failbit | std::ifstream::badbit);
	fShaderFile.exceptions(std::ifstream::failbit | std::ifstream::badbit);
	try
	{
		vShaderFile.open(vertexPath);
		fShaderFile.open(fragmentPath);
		std::stringstream vShaderStream, fShaderStream;

		vShaderStream << vShaderFile.rdbuf();
		fShaderStream << fShaderFile.rdbuf();

		vShaderFile.close();
		fShaderFile.close();

		vertexSrc = vShaderStream.str();
		fragmentSrc = fShaderStream.str();
	}
	catch (std::ifstream::failure e)
	{
		std::cout << "ERROR::SHADER::FILE_NOT_SUCCESSFULLY_READ" << std::endl;
	}

	const char* vShaderSrc = vertexSrc.c_str();
	const char* fShaderSrc = fragmentSrc.c_str();

	unsigned int vertexShader;
	vertexShader = glCreateShader(GL_VERTEX_SHADER);
	glShaderSource(vertexShader, 1, &vShaderSrc, nullptr);
	glCompileShader(vertexShader);

#define SHADER_DEBUG
#ifdef SHADER_DEBUG
	int  success;
	char infoLog[512];
	glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
	if (!success)
	{
		glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
		std::cout << "ERROR::SHADER::VERTEX::COMPILATION_FAILED\n" << infoLog << std::endl;
	}
#endif

	unsigned int fragmentShader;
	fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
	glShaderSource(fragmentShader, 1, &fShaderSrc, nullptr);
	glCompileShader(fragmentShader);

#ifdef SHADER_DEBUG
	glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
	if (!success)
	{
		glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
		std::cout << "ERROR::SHADER::FRAGMENT::COMPILATION_FAILED\n" << infoLog << std::endl;
	}
#endif

	m_RendererID = glCreateProgram();
	glAttachShader(m_RendererID, vertexShader);
	glAttachShader(m_RendererID, fragmentShader);
	glLinkProgram(m_RendererID);
#ifdef SHADER_DEBUG
	glGetProgramiv(m_RendererID, GL_LINK_STATUS, &success);
	if (!success) {
		glGetProgramInfoLog(m_RendererID, 512, NULL, infoLog);
		std::cout << "ERROR::SHADER::PROGRAM::LINKING_FAILED\n" << infoLog << std::endl;
	}
#endif
	glDeleteShader(vertexShader);
	glDeleteShader(fragmentShader);
}

Shader::~Shader()
{
	glDeleteProgram(m_RendererID);
}

void Shader::Bind() const
{
	glUseProgram(m_RendererID);
}

void Shader::Unbind() const
{
	glUseProgram(0);
}

void Shader::SetUniformBool(const std::string& name, bool value) const
{
	int location = glGetUniformLocation(m_RendererID, name.c_str());
	glUniform1i(location, (int)value);
}

void Shader::SetUniformInt(const std::string& name, int value) const
{
	int location = glGetUniformLocation(m_RendererID, name.c_str());
	glUniform1i(location, value);
}

void Shader::SetUniformFloat(const std::string& name, float value) const
{
	int location = glGetUniformLocation(m_RendererID, name.c_str());
	glUniform1f(location, value);
}

void Shader::SetUniformFloat2(const std::string& name, float v0, float v1) const
{
	int location = glGetUniformLocation(m_RendererID, name.c_str());
	glUniform2f(location, v0, v1);
}

void Shader::SetUniformFloat3(const std::string& name, float v0, float v1, float v2) const
{
	int location = glGetUniformLocation(m_RendererID, name.c_str());
	glUniform3f(location, v0, v1, v2);
}

void Shader::SetUniformFloat3(const std::string& name, const glm::vec3& values) const
{
	int location = glGetUniformLocation(m_RendererID, name.c_str());
	glUniform3fv(location, 1, glm::value_ptr(values));
}

void Shader::SetUniformFloat4(const std::string& name, float v0, float v1, float v2, float v3) const
{
	int location = glGetUniformLocation(m_RendererID, name.c_str());
	glUniform4f(location, v0, v1, v2, v3);
}

void Shader::SetUniformMat3(const std::string& name, const glm::mat3& matrix) const
{
	int location = glGetUniformLocation(m_RendererID, name.c_str());
	glUniformMatrix3fv(location, 1, GL_FALSE, glm::value_ptr(matrix));
}

void Shader::SetUniformMat4(const std::string& name, const glm::mat4& matrix) const
{
	int location = glGetUniformLocation(m_RendererID, name.c_str());
	glUniformMatrix4fv(location, 1, GL_FALSE, glm::value_ptr(matrix));
}

void Shader::SetUniformBlock(const std::string& name, unsigned int uniformBlockIndex) const
{
	unsigned int index = glGetUniformBlockIndex(m_RendererID, name.c_str());
	glUniformBlockBinding(m_RendererID, uniformBlockIndex, 0);
}
