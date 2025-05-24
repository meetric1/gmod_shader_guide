
// Vertex shader that rounds the vertex position

// This includes a couple useful functions and defines for us to use
// In this case, we are using SkinPosition and cViewProj
#include "common_vs_fxc.h"

// This is an example of an input structure for screenspace_general vertex shaders
// As an example I am also going to give the UV (texture) coordinate of the model, just for visualization purposes
struct VS_INPUT {
	float4 vPos		 : POSITION;
	float4 vTexCoord : TEXCOORD0;
};

// All vertex shaders need an output to send to the pixel shader.
// In this case, we are giving the pixel shader the UV coordinates of our model
struct VS_OUTPUT {
	float4 proj_pos : POSITION;		// Required 
	float2 uv       : TEXCOORD0;	// UV coordinate we send to the pixel shader
};

// The code below runs for every vertex in the model
VS_OUTPUT main(VS_INPUT vert) {
	// This takes the vertex position in model space and puts it in worldspace
	float3 world_pos;
	SkinPosition(0, vert.vPos, 0, 0, world_pos);

	// This isnt a required step, I just think its neat visually
	// I am going to round each vertex on a grid of size 10
	// Which kind of emulates that PS1 rounding effect
	// What do you think will happen when this portion of code is commented out?
	world_pos /= 10.0;
	world_pos = floor(world_pos);	// Same as: world_pos = float3(world_pos.x, world_pos.y, world_pos.z);
	world_pos *= 10.0;

	// Takes our world space coordinate and projects it onto the screen
	float4 proj_pos = mul(float4(world_pos, 1), cViewProj);

	// Define our output structure (initializes everything to 0)
	VS_OUTPUT output = (VS_OUTPUT)0;
	output.proj_pos = proj_pos;
	output.uv = vert.vTexCoord.xy;

	return output;
};