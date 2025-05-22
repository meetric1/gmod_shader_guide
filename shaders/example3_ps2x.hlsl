// We have 4 texture samplers. This shader will only use the first one (BASETEXTURE), but the other 3 are here for reference
// The name of each sampler (aka. texture) doesn't matter in the hlsl, these are just the variable names I use
sampler BASETEXTURE : register(s0);
sampler TEXTURE1    : register(s1);
sampler TEXTURE2    : register(s2);
sampler TEXTURE3    : register(s3);

// In gmod, there are 3 constants, with 4 controllable inputs
// (Again, the name of each constant doesn't matter, I chose C0, C1, and C2)
float4 C0 : register(c0); // Holds material flags $c0_x, $c0_y, $c0_z, and $c0_w
float4 C1 : register(c1); // Holds material flags $c1_x, $c1_y, $c1_z, and $c1_w
float4 C2 : register(c2); // Holds material flags $c2_x, $c2_y, $c2_z, and $c2_w

// Our default input structure
struct PS_INPUT {
	float2 pixel : VPOS;		// Location on the screen in pixel space
	float2 uv    : TEXCOORD0;	// Texture coordinates
};

// The section of code below will run for every pixel on the screen
float4 main(PS_INPUT frag) : COLOR {
	// In our case, $c0_x is going to be updated to curtime (this is done in the Lua)
	// We can reference it like this:
	float curtime = C0.x;

	// Animate our texture to the left
	float2 shifted_uv = frag.uv;
	shifted_uv.x = shifted_uv.x + curtime;

	// Clamp it from 0 - 1!
	// This isn't required, but aliviates precision issues during sampling
	shifted_uv.x = shifted_uv.x % 1.0;

	// Sample a 2D texture, at our UV coordinate.
	// We do .xyz to trim the w (alpha) component. We don't need it right now
	float3 final_color = tex2D(BASETEXTURE, shifted_uv).xyz;	

	// This is called swizzling, and it is a powerful way to manipulate vectors
	// Feel free to do your own research on this topic
	// In this case, I am swapping the x (red) and z (blue) components of the final color
	final_color.xyz = final_color.zyx;
	
	return float4(final_color, 1.0);
};
