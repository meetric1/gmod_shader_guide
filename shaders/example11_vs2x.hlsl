#include "common_vs_fxc.h"

struct VS_INPUT {
	float4 vPos		 : POSITION;
	float4 vColor	 : COLOR0;
};

// Very simple shader, we're just outputting the color data from our mesh
struct VS_OUTPUT {
	float4 proj_pos : POSITION;
	float4 color    : COLOR0;
};

VS_OUTPUT main(VS_INPUT vert) {
	float3 world_pos;
	SkinPosition(0, vert.vPos, 0, 0, world_pos);

	float4 proj_pos = mul(float4(world_pos, 1), cViewProj);

	VS_OUTPUT output = (VS_OUTPUT)0;
	output.proj_pos = proj_pos;
	output.color = vert.vColor;

	return output;
};