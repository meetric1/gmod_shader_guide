// Simple sphere intersection shader

// Defines cEyePos
#include "common_ps_fxc.h"

// $c0_x = sphere radius
float4 C0 : register(c0);

struct PS_INPUT {
	float3 pos 		   : TEXCOORD0;	// Position on triangle
	float4x4 view_proj : TEXCOORD1;	// Projection matrix (used for calculating depth)
};

// Similar to MRT, we need to define an explicit output structure
// In this case, we are defining DEPTH0
struct PS_OUTPUT {
	float4 color0 : COLOR0;
	float depth0  : DEPTH0;	
};

// Intersection code from https://www.shadertoy.com/view/ltBSzK
float sphere_intersect(float3 ray_pos, float3 ray_dir, float4 sphere) {
	float3 oc = ray_pos - sphere.xyz;
	float b = dot(oc, ray_dir);
	float c = dot(oc, oc) - sphere.w * sphere.w;
	float h = b * b - c;

	if (h < 0.0) return -1.0;
	return -b - sqrt(h);
}

PS_OUTPUT main(PS_INPUT frag) {
	// Setup variables for intersection
	float3 ray_origin = cEyePos;
	float3 ray_direction = normalize(frag.pos - cEyePos);
	float4 sphere = float4(0.0, 0.0, 0.0, C0.x); // (x, y, z, radius)

	// Intersection data
	float sphere_dist = sphere_intersect(ray_origin, ray_direction, sphere);
	if (sphere_dist <= 0.0) discard;	// discard pixel if we didn't hit the sphere
	float3 hit_pos = ray_origin + ray_direction * sphere_dist;
	float3 hit_normal = normalize(hit_pos - sphere.xyz);

	// Final calculations
	float4 proj_pos = mul(float4(hit_pos, 1), frag.view_proj);
	float final_depth = proj_pos.z / proj_pos.w;
	float3 final_color = hit_normal * 0.5 + 0.5;

	// We're done!
	PS_OUTPUT output = (PS_OUTPUT)0;
	output.color0 = float4(final_color, 1.0);
	output.depth0 = final_depth;

	return output;
};