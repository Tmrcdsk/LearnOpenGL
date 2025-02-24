workspace "LearnOpenGL"
	architecture "x64"

	configurations 
	{ 
		"Debug",
		"Release"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir = {}
IncludeDir["GLFW"] = "Dependencies/GLFW/include"
IncludeDir["Glad"] = "Dependencies/Glad/include"

project "LearnOpenGL"
	location "LearnOpenGL"
	kind "ConsoleApp"
	language "C++"
    cppdialect "C++17"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"Dependencies/Glad/src/**.c"
	}

	includedirs
	{
		"%{prj.name}/src",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.Glad}"
	}

	libdirs
	{
		"Dependencies/GLFW/lib-vc2022"
	}

	links
    {
        "glfw3.lib",
        "opengl32.lib"
    }
