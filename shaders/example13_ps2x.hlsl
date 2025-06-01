//sampler3D BASETEXTURE : register(s0);

// potential fix: sampler3D doesn't work on AMD cards?
Texture3D BASETEXTURE : register(s0);
SamplerState SAMPLER_STATE {
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = WRAP;
    AddressV = WRAP;
	AddressW = WRAP;
};

float4 C0 : register(c0); // c0_x = UV scale

// Our input structure defined by the vertex shader
struct PS_INPUT {
	float3 pos : TEXCOORD0;
};

float4 main(PS_INPUT frag) : COLOR {
	float uv_scale = C0.x;

	float3 final_color;
	//final_color.xyz = tex3D(BASETEXTURE, frag.pos / uv_scale).zzz;	// Only display red channel
	final_color.xyz = BASETEXTURE.Sample(SAMPLER_STATE, frag.pos / uv_scale).zzz;	// Only display red channel

	return float4(final_color, 1.0);
};