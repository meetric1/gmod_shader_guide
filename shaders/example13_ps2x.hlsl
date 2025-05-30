// Volumetric texture
sampler BASETEXTURE : register(s0);

float4 C0 : register(c0); // c0_x = UV scale

// Our input structure defined by the vertex shader
struct PS_INPUT {
	float3 pos : TEXCOORD0;
};

float4 main(PS_INPUT frag) : COLOR {
	float uv_scale = C0.x;

	// if outside our box, discard our pixel
	if (
		frag.pos.x < 0 || frag.pos.x > uv_scale || 
		frag.pos.y < 0 || frag.pos.y > uv_scale || 
		frag.pos.z < 0 || frag.pos.z > uv_scale
	) discard;

	float3 final_color;
	final_color.xyz = tex3D(BASETEXTURE, frag.pos / uv_scale).zzz;	// Only display red channel

	return float4(final_color, 1.0);
};