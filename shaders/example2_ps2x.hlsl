// This is the default input structure for screenspace_general pixel shaders
// Note that for right now we only get to use 'uv' (texture coordinates), which is quite limited. 
// When we cover vertex shaders I will dive more into more detail and we will make our own input structure
struct PS_INPUT {
	float2 uv : TEXCOORD0;	// Texture coordinates (see https://learn.microsoft.com/en-us/windows/win32/direct3d9/images/uvcoordinates.jpg)
};

// Like C and C++, all programs start with a 'main' method.
// We created a structure above named PS_INPUT, which is given from the vertex shader and is the first (and afaik only) input to the main method
// The section of code below will run for every pixel on the screen
float4 main(PS_INPUT frag) : COLOR {
	// In HLSL, colors are floats (decimal values) from 0 - 1 (not 0 - 255 like GMod)
	float red = frag.uv.x;
	float green = frag.uv.y;

	// HLSL has pretty much all of the basic operators (+, -, *, /, %)
	// Unfortunately however, we do NOT have bitwise operations (&, |, ^, <<, >>, ~) because the shader model is so old
	float red_weird = (red * 10.0) % 1.0;

	// Our shaders are compiled, meaning this unused variable will be optimized out and will have no performance impact ingame. Pretty neat huh?
	// (However.. this is no excuse to have messy code :P )
	float3 unused = float3(0.0, 0.0, 1.0);

	// We return a COLOR, which you can imagine is just a Vector with 4 numbers (dictated with float4)
	// Colors have 4 channels, Red, Green, Blue, and Alpha (transparency) in that order (though, usually Alpha is omitted. We will look at it later).
	// More info on colors can be found here: https://en.wikipedia.org/wiki/RGB_color_model

	// Try returning different values and seeing what happens!
	// Don't forget to recompile your shader!
	return float4(red_weird, green, 0.0, 1.0);
};
