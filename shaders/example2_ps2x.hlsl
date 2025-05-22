// This is the default input structure for screenspace_general pixel shaders
// Note that we only get to use 'uv' (texture coordinates), which is quite limited. We will make our own input structure later on
struct PS_INPUT {
	float2 p  : VPOS;
	float2 uv : TEXCOORD0;
};

// Like C and C++, all programs start with a 'main' method.
// We created a structure above named PS_INPUT, which is given from the vertex shader and is the first (and afaik only) input to the main method
float4 main(PS_INPUT frag) : COLOR {
	// In HLSL, colors are floats (decimal values) from 0 - 1, not 0 - 255 like GMod
	float red = frag.uv.x;
	float green = frag.uv.y;

	// We return a COLOR, which you can imagine is just a Vector with 4 numbers (dictated with float4)
	// Colors have 4 channels, Red, Green, Blue, and Alpha (transparency) in that order (though, usually Alpha is omitted. We will look at it later).
	// More info on colors can be found here: https://en.wikipedia.org/wiki/RGB_color_model

	// Try returning different values and seeing what happens!
	// Don't forget to recompile your shader!
	return float4(red, green, 0.0, 1.0);
};
