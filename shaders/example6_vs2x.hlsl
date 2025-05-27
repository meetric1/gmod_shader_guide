
/// Simple "jelly" shader which wiggles vertices

#include "common_vs_fxc.h"

// Our default vertex data input structure
struct VS_INPUT {
	float4 vPos		 : POSITION;
	float4 vTexCoord : TEXCOORD0;
};

// A normal vertex data output structure
struct VS_OUTPUT {
	float4 proj_pos : POSITION;		// Screen space position 
	float2 uv       : TEXCOORD0;	// UV coordinate we send to the pixel shader
};

float hash(float x) {
	return sin(x * 5.0);
}

// The code below runs for every vertex in the model
VS_OUTPUT main(VS_INPUT vert) {
	float3 world_pos;
	SkinPosition(0, vert.vPos, 0, 0, world_pos);

	// Inside of shader_examples.lua, I am setting the front ambient cube x value to CurTime
	// We can get it like so:
	float curtime = cAmbientCubeX[0].x;

	// Now, animate our vertices
	world_pos.x += hash(world_pos.x + curtime);
	world_pos.y += hash(world_pos.y + curtime);
	world_pos.z += hash(world_pos.z + curtime);

	// Finish up our vertex shader
	float4 proj_pos = mul(float4(world_pos, 1), cViewProj);

	VS_OUTPUT output = (VS_OUTPUT)0;
	output.proj_pos = proj_pos;
	output.uv = vert.vTexCoord.xy;

	return output;
};