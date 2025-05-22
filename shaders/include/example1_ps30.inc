#pragma once
#include "shaderlib/cshader.h"
class example1_ps30_Static_Index
{
public:
	example1_ps30_Static_Index( IShaderShadow* pShaderShadow, IMaterialVar** params )
	{
	}

	int GetIndex() const
	{
		return 0;
	}
};

#define shaderStaticTest_example1_ps30 1


class example1_ps30_Dynamic_Index
{
public:
	example1_ps30_Dynamic_Index( IShaderDynamicAPI* pShaderAPI )
	{
	}

	int GetIndex() const
	{
		return 0;
	}
};

#define shaderDynamicTest_example1_ps30 1

