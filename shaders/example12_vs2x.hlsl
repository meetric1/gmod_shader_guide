#include "common_vs_fxc.h"

struct VS_INPUT {
	float4 vPos		 : POSITION;
	float4 vColor	 : COLOR0;
};

struct VS_OUTPUT {
	float4 proj_pos : POSITION;
	float4 color    : COLOR0;
	float size      : PSIZE;	// Point size (in pixels)
};

// Because we're dealing with point sprites, this will only run once per point
VS_OUTPUT main(VS_INPUT vert) {
	float3 world_pos;
	SkinPosition(0, vert.vPos, 0, 0, world_pos);

	float4 proj_pos = mul(float4(world_pos, 1), cViewProj);

	VS_OUTPUT output = (VS_OUTPUT)0;
	output.proj_pos = proj_pos;
	output.color = vert.vColor;

	// Point sprite size calculation
	float point_scale_fov = cAmbientCubeX[0].x;	// Sent from Lua
	output.size = point_scale_fov / proj_pos.z;

	return output;
};