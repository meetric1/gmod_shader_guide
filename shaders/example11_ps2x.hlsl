// FinalOutput (and related definitions)
#include "common_ps_fxc.h"

struct PS_INPUT {
	float4 color : COLOR0;
};

float4 main(PS_INPUT frag) : COLOR {
	// We're doing "proper" shaders now, so don't forget to call FinalOutput!
	return FinalOutput(frag.color, 0, PIXEL_FOG_TYPE_NONE, TONEMAP_SCALE_LINEAR);
}