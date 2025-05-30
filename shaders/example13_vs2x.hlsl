
#include "common_vs_fxc.h"

struct VS_INPUT {
	float4 vPos		 : POSITION;
	float4 vTexCoord : TEXCOORD0;
};

struct VS_OUTPUT {
	float4 proj_pos : POSITION;
	float3 pos      : TEXCOORD0;
};

VS_OUTPUT main(VS_INPUT vert) {
	float3 world_pos;
	SkinPosition(0, vert.vPos, 0, 0, world_pos);

	float4 proj_pos = mul(float4(world_pos, 1), cViewProj);

	// Send world space position to pixel shader
	VS_OUTPUT output = (VS_OUTPUT)0;
	output.proj_pos = proj_pos;
	output.pos = world_pos;

	return output;
};