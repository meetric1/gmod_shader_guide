# The Comprehensive GMod Shader Guide
Hello! Welcome to my GMod Shader Guide!

It consists of everything I have learned making GMod shaders over the past few years. I aim to teach anyone new with shaders, specifically shaders within SourceEngine and GMod.

This guide ASSUMES you know the basics of how to code, including syntax, variables, and control flow.

If you do not know how to code I suggest doing a couple GLua projects and then coming back to this guide, as it is quite technical and a bit complex.

> [!NOTE]
> Source Engine (the game engine GMod uses), runs on DirectX9, which is *very* old, and there are many modern graphics features that do not exist. This means we will not be discussing things like tessilation shaders, mesh shaders, compute shaders, tensor shaders, and other modern shader types.

> [!NOTE]
> This guide likely does not cover *everything* about gmod shaders and HLSL, but I will try my best to include everything that is relevant. If you discover something new, PLEASE share it! Feel free to create an issue or make a pull request and add your own shader examples.

# Table of Contents
- [What is a Shader?](#what_is_a_shader?)
- [The Shader Pipeline](#the_shader_pipeline)
- [screenspace_general](#screenspace_general)
- [Getting Started](#getting_started)
- [[Example 1] - Your First Shader](#[example_1]_-_your_first_shader)
- [[Example 2] - Pixel Shaders](#[example_2]_-_pixel_shaders)
- [[Example 3] - pixel shader constants]
- [[Example 4] - gpu control flow]
- [[Example 5] - rendertargets]
- [[Example 6] - vertex shaders]
- [[Example 7] - vertex shader constants]
- [[Example 8] - the depth buffer]
- [[Example 9] - shaders on models]
- [[Example 10] - imeshes]
- [[Example 11] - geometry shaders]
- [We're Done!](#we're_done!)

# What is a Shader?
You may be asking to yourself, `what is a shader and why should I care?`, well have you ever wondered how games are able to display such complex geometry and graphics? At some point in any game you play, there is code running on your [GPU](https://en.wikipedia.org/wiki/Graphics_processing_unit) that determines the color of every pixel displayed on your screen. Yes, you heard that right, for *every* pixel there is code running to determine its color, in real time. Thats what we'll be writing today.

Here are some examples of some cool shaders:\
**GMod Grass shader (Me):**\
![ezgif-6bf72fdcc49f1b](https://github.com/user-attachments/assets/66115f5f-2375-4429-a73d-253d35cda73d)\
**GMod Ground Displacement (Evgeny Akabenko):**\
![image](https://github.com/user-attachments/assets/596fe2db-c05d-4a37-b293-a2764caeb349)\
**GMod Volumetric Clouds (Evgeny Akabenko):**\
![Untitled](https://github.com/user-attachments/assets/0aae45f1-9d7d-49b3-acc3-df3ae7ed8fcd)\
**Half Life: Alyx liquid shader (Valve):**\
![ebd09ce02b4b9b7c3d59eb442ee6afe22f20d291](https://github.com/user-attachments/assets/0339658e-a9ae-4b0a-8aff-c0f55a11ae46)\

# The Shader Pipeline
All graphics APIs, have something called a [Graphics Pipeline](https://en.wikipedia.org/wiki/Graphics_pipeline). This is a generalized, fixed set of stages which function to transform a 3 dimmensional scene, into something the screen can display.

The Graphics Pipeline:\
![graphics_pipeline](https://github.com/user-attachments/assets/5683817d-1d03-448d-b019-3870d5a9852d)\
<sup><sub>(image from [Vulkan Tutorial](https://vulkan-tutorial.com/Drawing_a_triangle/Graphics_pipeline_basics/Introduction))<sup><sub>

This guide won't go into the specifics of the math. For now, all you need to know is:
1. Every model that you see is made up of triangles and vertices (See [mat_wireframe](https://developer.valvesoftware.com/wiki/Mat_wireframe) for a visualization within Source).
2. Each vertice gets sent to the GPU, to be transformed onto the screen. This transformation will be controlled within your vertex shader.
3. The pixel shader then runs after that and fills in the [rasterized](https://en.wikipedia.org/wiki/Rasterisation) pixels with a color, controlled by your shader

# screenspace_general
(Feel free to skip this section if you already know about how .vmt's work)

Source engine has a custom extension named `vmt`. This basically controls aspects (flags) of a custom material.\
In this case, we are taking advantage of a shader named screenspace_general, which lets us set custom vertex and pixel shaders.

Despite its name, screenspace_general is not actually screenspace (as of the 2015 CS:S branch), and was likely used for testing.\
See [Example 9] for more specific information regarding screenspace_general

More info on .vmt's:\
https://developer.valvesoftware.com/wiki/VMT 

More info on screenspace_general:\
https://developer.valvesoftware.com/wiki/Screenspace_General 

Source code of the shader (From CS:S 2015):\
https://github.com/sr2echa/CSGO-Source-Code/blob/master/cstrike15_src/materialsystem/stdshaders/screenspace_general.cpp

# Getting Started
To start out, clone this repo into your `GarrysMod/garrysmod/addon` folder, there are 11 examples for you to look at and follow ingame.\
Each example will teach you about a specific topic about shaders. My hope is that by reading this guide and visualizing the shader you can get a better grasp of what is going on.

> [!NOTE]
> PLEASE LOAD INTO `gm_construct`, AS ITS ORIGIN IS RELATIVELY CLOSE TO THE SPAWN POINT. IT IS THE MAP THESE VISUALS ARE BASED AROUND.

Once loaded in, you should be able to type `shader_example 1` in your console to view the first shader. (It should just be a red square) It isn't very interesting but we'll work on making some cool shaders.
(IMAGE OF EXAMPLE_SHADER1)

# [Example 1] - Your First Shader
In order to make a shader, we will need something to compile it. For this guide I have decided to use [ShaderCompile](https://github.com/SCell555/ShaderCompile), as it supports 64 bit and is a hell of a lot easier than setting up the normal sourceengine shader compiler.\
I am also using an edited version of [ficool2's](https://github.com/ficool2/sdk_screenspace_shaders) `build_single_shader.bat`.

Please close GMod and navigate inside this repo to `gmod_shader_guide/shaders` and find `example1_ps2x.hlsl`.\
For reference, the name of a shader is very important, so lets split it into 4 parts.
1. `example1` - The name of the shader, this can be anything you want.
2. `ps` - Stands for Pixel Shader, can also be `vs` (Can you guess what it stands for?)
3. `2x` - The shader version. I will be using `2x`, as it is the most supported. `30` is also valid and has less restrictions, but does not work on native Linux
4. `.hlsl` - The file extension, all source shaders use hlsl

You must ENSURE that the name stays exactly in this format, or the tools provided won't work.

Once you are done, drag it on top of `build_single_shader.bat` and it should compile and automatically put the shader into `fxc`, which is where GMod shaders are loaded from.\
Compiled shaders are `.vcs` files, which stands for `Valve Compiled Shader`.

Next time you go in game, you should see a bright green square at the top left of your screen. If you do, congratulations! You have successfully compiled your first shader.

If the square is red, the shader hasn't overwritten anything and you've probably missed a step. Try restarting your game or checking for compile errors.

> [!NOTE]
> Editing (or recompiling) a shader without modifying the .vmt requires a game restart. 
> Until you wanna start editing .vmt's I suggest just restarting the game as it is the easiest method. Launching the game with `-noworkshop` helps a lot with load times.

> [!TIP]
> When you eventually start developing your own shaders, make sure to give them a distinct name, or you might get conflictions

# [Example 2] - Pixel Shaders
Pixel (also known as Fragment) shaders run a section of code for every pixel on the screen.\
In the first example, we learned how to compile a basic shader, but now we're going to try modifying one.

Navigate to `gmod_shader_guide/shaders` and open `example2_ps2x.hlsl` (preferably so both this guide, and the code are in view).\
I have overcommented `example2_ps2x.hlsl`. Read that to get a basic grasp of the HLSL syntax. It is a lot like C or C++.\
Feel free to try modifying the shader to do something different. Don't forget to recompile your shader!

If you would like to try changing the shader ingame, compile your shader and then navigate to `gmod_shader_guide/shaders/fxc` and change `example2_ps20b.vcs` to something like `example2a_ps20b.vcs`.\
Now, navigate to `gmod_shader_guide/materials/gmod_shader_guide` and open `example2.vmt` in any text editor (notepad or Visual Studio Code works fine)\
Like I explained before, .vmt files control information about the material. In this case, we are interested in the `$pixshader` flag which controls the pixel shader the material uses. Change it to whatever you renamed the shader to, so the line looks something like `$pixshader "example2a_ps2x"`, save it, and view your changes.

> [!NOTE]
> If you are trying to update the shader ingame, ensure the compiled .vcs shader exists before saving changes to the .vmt

# [Example 3] - Pixel Shader Constants

# [Example 4] - GPU Control Flow
No loops with sm2x, sm30 supports but linux only


# We're done!
If you made it here, you (hopefully) have read and understand everything there is to know (or atleast, that I know) about GMod shaders.\
Please note that this is NOT a comprehensive guide on everything HLSL! There is still plenty more to learn, but this is definitely a good starting point.\
Feel free to ask questions (or concerns) in the Issues tab. I will answer them best I can :)\

__Happy shading!__
