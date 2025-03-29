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
IncludeDir["Assimp"] = "Dependencies/Assimp/include"

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
		"%{prj.name}/vendor/glm/**.hpp",
		"%{prj.name}/vendor/glm/**.inl",
		"%{prj.name}/vendor/stb_image/**.h",
		"%{prj.name}/vendor/stb_image/**.cpp",
		"%{prj.name}/vendor/imgui/**.h",
		"%{prj.name}/vendor/imgui/**.cpp",
		"Dependencies/Glad/src/**.c"
	}

	includedirs
	{
		"%{prj.name}/src",
		"%{prj.name}/vendor",
		"%{IncludeDir.GLFW}",
		"%{IncludeDir.Glad}",
		"%{IncludeDir.Assimp}"
	}

	libdirs
	{
		"Dependencies/GLFW/lib-vc2022",
		"Dependencies/Assimp/lib/Release"
	}

	links
    {
        "glfw3.lib",
        "opengl32.lib",
        "assimp-vc143-mt.lib"
    }

	postbuildcommands
	{
		"{COPY} %{wks.location}/Dependencies/Assimp/lib/Release/assimp-vc143-mt.dll %{wks.location}/bin/" .. outputdir .. "/%{prj.name}/"
	}
