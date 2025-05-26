// The framebuffer
sampler BASETEXTURE : register(s0);

struct PS_INPUT {
	float2 uv : TEXCOORD0;
};

// We need to specify that we are returning 2 colors. 
// So we return this output structure instead of a float4 
struct PS_OUTPUT {
	float4 color0 : COLOR0;
	float4 color1 : COLOR1;
};

PS_OUTPUT main(PS_INPUT frag) {
	// Sample our framebuffer
	float3 color = tex2D(BASETEXTURE, frag.uv).xyz;

	// This first "post processing" shader simply returns the red channel
	float3 post_process0 = float3(color.x, 0.0, 0.0);

	// This second one just returns the green channel
	float3 post_process1 = float3(0.0, color.y, 0.0);

	// Now, define our output structure
	PS_OUTPUT output = (PS_OUTPUT)0;
	output.color0 = float4(post_process0, 1.0);
	output.color1 = float4(post_process1, 1.0);

	return output;
};