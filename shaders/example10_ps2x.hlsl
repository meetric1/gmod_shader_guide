// declares FinalOutput (and related definitions)
#include "common_ps_fxc.h"

sampler BASETEXTURE	: register(s0);

struct PS_INPUT {
	float2 uv            : TEXCOORD0;	
	float3 pos           : TEXCOORD1;
	float3 normal        : TEXCOORD2;
};

// gm_construct ambient color
#define AMBIENT_COLOR float3(0.308251, 0.454464, 0.547380)

float4 main(PS_INPUT frag) : COLOR {
	
	float3 final_color = float3(1.0, 1.0, 1.0);

	// simple diffuse material calculation
	final_color *= max(dot(frag.normal, normalize(float3(1.0, 1.0, 1.0))), 0.0);	// sun direction
	final_color += AMBIENT_COLOR;													// ambient color
	final_color *= tex2D(BASETEXTURE, frag.uv).xyz;									// albedo

	// FinalOutput basically does all the HDR and gamma correction stuff for you
	return FinalOutput(float4(final_color, 1.0f), 0, PIXEL_FOG_TYPE_NONE, TONEMAP_SCALE_LINEAR);
}