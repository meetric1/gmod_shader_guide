// This is just a normal pixel shader, you should understand it pretty well

// Example texture
sampler BASETEXTURE : register(s0);

// Our input structure defined by the vertex shader
struct PS_INPUT {
	float2 uv    : TEXCOORD0;
};

float4 main(PS_INPUT frag) : COLOR {
	return float4(tex2D(BASETEXTURE, frag.uv).xyz, 1.0);
};