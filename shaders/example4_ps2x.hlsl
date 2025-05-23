
// In this example, I present a modified blur shader that blurs a texture
// There is a lot of inefficiency in this shader. This is intentional for educational purposes. 
// Please do not use this code in your own projects

// Texture to blur
sampler BASETEXTURE : register(s0);

// $c0_x = size of blur
float4 C0 : register(c0);

// Our default input structure
struct PS_INPUT {
	float2 uv    : TEXCOORD0;	// Texture coordinates
};

// Blurs in a 3x3 area around our UV coordinate
// Note that this code is *very* inefficient. Most techniques split the work into 2 passes
// This reduces the complexity of the algorithm to O(n) instead of O(n^2)
// For simplicity however, we're gonna go with this less efficient approach
//
// Oh, by the way you can define functions. Sorry for not explaining that earlier :P
// Hopefully the syntax is pretty readable
float3 blur_3x3(PS_INPUT frag) {
	float3 average = float3(0.0, 0.0, 0.0);

	for (int y = -1; y <= 1; y++) {
		for (int x = -1; x <= 1; x++) {
			average += tex2D(BASETEXTURE, frag.uv + float2(x, y) * C0.x).xyz;
		}
	}

	return average / 9.0;
}

float3 operation_1(PS_INPUT frag) {
	float3 final_color = float3(0.0, 0.0, 0.0);
	
	// Blurs pixels in a checkerboard pattern
	if (((floor(frag.uv.x * 100.0) % 2) + (floor(frag.uv.y * 100.0) % 2)) % 2 == 1) {
		final_color = blur_3x3(frag);
	} else {
		final_color = float3(1.0, 0.0, 1.0); // bright pink
	}

	return final_color;
}

float3 operation_2(PS_INPUT frag) {
	float3 final_color = float3(0.0, 0.0, 0.0);
	
	// Only blur right half the texture
	if (frag.uv.x > 0.5) {
		final_color = blur_3x3(frag);
	} else {
		final_color = float3(1.0, 0.0, 1.0); // bright pink
	}

	return final_color;
}

float4 main(PS_INPUT frag) : COLOR {
	// Both operations blur half of the pixels on the texture, but one of them is much more efficent
	// Which one do you think is more efficient? (Answer at bottom of shader)

	// Operation 1
	float3 final_color = operation_1(frag);

	// Operation 2
	//float3 final_color = operation_2(frag);
	
	return float4(final_color.xyz, 1.0);
};


// ↓↓↓ Answer to Question ↓↓↓ //
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// 
//
// If you said that Operation 1 was LESS efficient, you would be correct!
// Despite both implementations blurring the same number of pixels, Operation 1 is LESS efficient.

// This is because Operation 1 does not maintains control flow within each warp. Warps are spread around a texture in groups
// In Operation 1, we can notice that blurring is done in a checkerboard pattern, meaning every other pixel is blurred
// This means that our warp is diverging for every other pixel, meaning half the warp doesn't do anything and sits idle
// Lots of divergence -> bad!

// Operation 2 on the other hand blurs a region of the texture (right half), meaning most of the control flow in each region is identical. 
// Low divergence -> good!







