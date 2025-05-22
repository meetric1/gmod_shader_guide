// Simple shader that returns bright green
// As of right now we're just trying to compile this shader, though feel free to take a look
struct PS_INPUT {
	float2 p  : VPOS;
	float2 uv : TEXCOORD0;
};

float4 main(PS_INPUT frag) : COLOR {
	return float4(0.0, 1.0, 0.0, 1.0);
};
