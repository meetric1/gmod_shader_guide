# HELLO! IF YOU ARE READING THIS, THE GUIDE IS CURRENTLY WIP AND UNFINISHED, DON'T JUDGE IT TOO HARSHLY YET
#
#
#
#
#
#
#
#
# The Comprehensive GMod Shader Guide
Hello! Welcome to my GMod Shader Guide!

It consists of everything I have learned making GMod shaders over the past few years. I aim to teach anyone new with shaders, specifically shaders within SourceEngine and GMod.

This guide **ASSUMES** you know the basics of how to code, including syntax, variables, and control flow.

If you do not know how to code I suggest doing a couple GLua projects and then coming back to this guide, as it is quite technical and a bit complex.

> [!NOTE]
> Source Engine (the game engine GMod uses), runs on DirectX9, which is *very* old, and there are many modern graphics features that do not exist. This means we will not be discussing things like tessilation shaders, mesh shaders, compute shaders, tensor shaders, and other modern shader types.

> [!NOTE]
> This guide likely does not cover *everything* about gmod shaders and HLSL, but I will try my best to include everything that is relevant. If you discover something new, **PLEASE** share it! Feel free to create an issue or make a pull request and add your own shader examples.

# Table of Contents
- [What is a Shader?](#what-is-a-shader)
- [The Shader Pipeline](#the-shader-pipeline)
- [screenspace_general](#screenspace_general)
- [Getting Started](#getting-started)
- [[Example 1] - Your First Shader](#example-1---your-first-shader)
- [[Example 2] - Pixel Shaders](#example-2---pixel-shaders)
- [[Example 3] - Pixel Shader Constants](#example-3---pixel-shader-constants)
- [[Example 4] - GPU Architecture](#example-4---gpu-architecture)
- [[Example 5] - Vertex Shaders](#example-5---vertex-shaders)
- [[Example 6] - Vertex Shader Constants](#example-6---vertex-shader-constants)
- [[Example 7] - Render Targets](#example-7---render-targets)
- [[Example 8] - Multi-Render Targets](#example-8---multi-render-targets)
- [[Example 9] - Depth]
- [[Example 10] - shaders on models]
- [[Example 11] - imeshes]
- [[Example 12] - volume textures]
- [[Example 13] - geometry shaders]
- [We're Done!](#were-done)

# What is a Shader?
You may be asking to yourself, `what is a shader and why should I care?`, well have you ever wondered how games are able to display such complex geometry and graphics? At some point in any game you play, there is code running on your [GPU](https://en.wikipedia.org/wiki/Graphics_processing_unit) that determines the color of every pixel displayed on your screen. Yes, you heard that right, for *every* pixel there is code running to determine its color, in real time. Thats what we'll be writing today.

Here are some examples of some cool shaders:\
**GMod Grass shader (Me):**\
![ezgif-6bf72fdcc49f1b](https://github.com/user-attachments/assets/66115f5f-2375-4429-a73d-253d35cda73d)\
**GMod Parallax Mapping (Evgeny Akabenko):**\
![image](https://github.com/user-attachments/assets/596fe2db-c05d-4a37-b293-a2764caeb349)\
**GMod Volumetric Clouds (Evgeny Akabenko):**\
![Untitled](https://github.com/user-attachments/assets/0aae45f1-9d7d-49b3-acc3-df3ae7ed8fcd)\
**Half Life: Alyx liquid shader (Valve):**\
![ebd09ce02b4b9b7c3d59eb442ee6afe22f20d291](https://github.com/user-attachments/assets/0339658e-a9ae-4b0a-8aff-c0f55a11ae46)\

# The Shader Pipeline
All graphics APIs, have something called a [Graphics Pipeline](https://en.wikipedia.org/wiki/Graphics_pipeline). This is a generalized, fixed set of stages which function to transform a 3 dimensional scene, into something the screen can display.

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
In this case, we are taking advantage of a shader named `screenspace_general`, which lets us set custom vertex and pixel shaders.

> [!NOTE]
> A material can have many flags, but only 1 shader.

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

Once loaded in, you should be able to type `shader_example 1` in your console to view the first shader. (It should just be a red rectangle on your screen) It isn't very interesting but we'll work on making some cool shaders.

# [Example 1] - Your First Shader
In order to make a shader, we will need something to compile it. For this guide I have decided to use [ShaderCompile](https://github.com/SCell555/ShaderCompile), as it supports 64 bit and is a hell of a lot easier than setting up the normal sourceengine shader compiler.

After taking a look at `shader_example 1`, please close GMod and navigate inside this repo to `gmod_shader_guide/shaders`.\
The source code of all the shaders are in this folder as `.hlsl` files.\
You may have also noticed a bunch of `.h` files too. Ignore these for now, we'll use them in our shaders later

Now, for reference, the name of a shader is very important, so lets split it into 5 parts.
1. `example1` - The name of the shader, this can be anything you want.
2. `_` - Required underscore to separate the name and the rest of the data.
3. `ps` - Stands for Pixel Shader, can also be `vs` (Can you guess what it stands for?)
4. `2x` - The shader version. I will be using `2x`, as it is the most supported. `30` is also valid and has less restrictions, but does not work on native Linux
5. `.hlsl` - The file extension, all source shaders use hlsl

You must ENSURE that the name stays exactly in this format, or the tools provided won't work.

Now, we're going to overwrite an existing shader with a new one.\
Drag `example1_ps2x.hlsl` on top of `build_single_shader.bat` and it should compile and automatically put the shader into `fxc`, which is where GMod shaders are loaded from.\
Compiled shaders are `.vcs` files, which stands for `Valve Compiled Shader`.

Next time you go in game (don't forget to type `shader_example 1`!), you should see a bright green square at the top left of your screen. If you do, congratulations! You have successfully compiled your first shader.

If the square is red, we haven't overwritten anything and you've probably missed a step. Try restarting your game or checking for compile errors.

> [!NOTE]
> Editing (or recompiling) a shader without modifying the .vmt requires a game restart.\
> Until you want to start editing .vmt's I suggest just restarting the game as it is the easiest method. Launching the game with `-noworkshop` helps a lot with load times.

> [!TIP]
> When you eventually start developing your own shaders, make sure to give them a distinct name, or you might get conflictions

![image](https://github.com/user-attachments/assets/f009c4a2-4e2b-4b65-a297-7f8fa9434880)

# [Example 2] - Pixel Shaders
Pixel (or more accurately, Fragment) shaders run a section of code for every pixel on the screen.\
In the first example, we learned how to compile a basic shader, but now we're going to try modifying one.\
Type `shader_example 2` in console and take a quick look at what this shader currently produces. It should look like this:\
![image](https://github.com/user-attachments/assets/e33ce1e3-12d8-4bb8-941f-bc7b1c8f4dce)

Now, navigate to `gmod_shader_guide/shaders` and open `example2_ps2x.hlsl`.\
I have overcommented `example2_ps2x.hlsl`. Read that to get a basic grasp of the HLSL syntax. It is a lot like C or C++.\
Try modifying the shader to do something different. Don't forget to recompile your shader!

If you would like to try changing the shader ingame, compile your shader, navigate to `gmod_shader_guide/shaders/fxc` and change `example2_ps20b.vcs` to something like `example2a_ps20b.vcs`.\
Now, navigate to `gmod_shader_guide/materials/gmod_shader_guide`. This is the folder which holds all of the materials.\
Open `example2.vmt` in any text editor (notepad or Visual Studio Code works fine)\
Like I explained before, .vmt files control information about the material. In this case, we are interested in the `$pixshader` flag which controls the pixel shader the material uses. Change it to whatever you renamed the shader to, so the line looks something like `$pixshader "example2a_ps20b"`, save it, and view your changes.

> [!NOTE]
> When hotloading shaders, once a name is used, it cannot be used again. So if you wanted to change your shader a second time, you'd need to name it something like `example2b_ps20b`

> [!NOTE]
> When hotloading shaders, ensure the compiled .vcs shader exists before saving changes to the .vmt

> [!TIP]
> You might have noticed the `$ignorez 1` flag in the .vmt, this is because all screenspace shaders *need* this flag to work properly! Otherwise they might not render

> [!TIP]
> The `$vertextransform 1` flag in the .vmt ensures coordinates are not in screenspace. This is useful since all of the `render.` functions are in worldspace.

# [Example 3] - Pixel Shader Constants
Hopefully by now you have a basic grasp of the HLSL syntax. Now we're going to be looking at a slightly more complex shader.\
Type `shader_example 3` in console and take a quick look at what our shader produces. It should look like this:\
![image](https://github.com/user-attachments/assets/1a04f2e5-2de7-40e1-bec3-67dd46aea5b9)

In this shader, we are sampling from a texture, and inputting [CurTime](https://wiki.facepunch.com/gmod/Global.CurTime) to make it appear animated.

As we already know, each .vmt represents a material, with a shader. What we're doing, is giving the material a global value which the shader can use. 
In this case, we are inputting CurTime, which you can see in the `example3` function in `gmod_shader_guide/lua/autorun/client/shader_examples.lua`.

Unfortunately, screenspace_general has a limited number of global constants we are allowed to input (which you can see [here](https://developer.valvesoftware.com/wiki/Screenspace_General)). However, I find it unlikely you will actually need to use all of them.

In this example, I am using input `$c0_x`, which takes a float to give CurTime to the shader.

Now, lets check the code behind this shader..\
Open `example3.vmt` and take a look at its parameters. Try modifying the basetexture to something like `hunter/myplastic` or `phoenix_storms/wood` and seeing what changes!

Note how, in the .vmt, I define `$c0_y` despite it not being used in the shader HLSL.\
After playing around with the vmt, open `example3_ps2x.hlsl` and try to understand its code.\
Try doing something with the unused `$c0_y` parameter!

> [!TIP]
> There are some more, undocumented pixel shader constants that are automatically set by Source Engine. They can be viewed [here](https://github.com/ficool2/sdk_screenspace_shaders/blob/94071cb6d464a7c04ced726770ca87a7ecd5d9a1/shadersrc/common.hlsl#L29).\
> Most aren't too useful, but someone might find them handy one day

# [Example 4] - GPU Architecture
Now that we know the basic syntax and general control of pixel shaders, I feel like its a good time to start looking at GPU architecture and control flow. It is important for you to think about GPUs as an entirely different computer, because in reality, they are. GPUs have their own processor, RAM, motherboard, firmware, and even cooling. 

GPUs operate *very* different compared to CPUs, so be prepared to think a bit differently than normal.

### Architecture

GPU Architecture is meant for very specific set of instructions for optimial speed. GPUs are *really* good at floating point operations. Infact they are so good, a modern GPU (in 2025) can do 15 TFLOPS (or 15,000,000,000,000) floating point operations per second. That is *fast*. 

Unfortunately however, that is pretty much all they're good at. GPUs are *ONLY* good at fast floating point (and integer) arithmetic. This makes them fast, but limited (think of a CPU, but dumber). Shader model 20b (the one we are using) doesn't even support doubles. If you do somehow get doubles working though, I would advise against it, as they are extremely slow and not what the GPU architecture is meant for.

### Control Flow

Lets move on to control flow. In languages on the CPU (Lua, C++, etc), an `if` statement is not a big deal. Guarding and preventing execution of code is usually a good thing for performance.

Although counterintuitive, on the GPU, this is not the case. You should avoid `if` statements when possible. Its a bit complex to explain why, but I will try my best.

On the GPU, a group of threads, called a warp, are launched in an area of the screen to compute things asynchronously. Due to the GPUs architecture, when a branch occurs, this divergence will cause the other non diverging threads to hang until the statement is finished executing, and vise versa. This reduces the parallelization of GPUs and effectively halves the performance in that block of code. Each side of the if statement must be computed synchronously.

Here is an example:
```
if (PIXEL.x <= 2) {
    do_work_1();
} else {
    do_work_2();
}
```
Lets pretend we have 1 warp with 4 threads named `0`, `1`, `2`, and `3`. Pretend we calculating a row of 4 pixels. When the GPU reaches the `if` statement, threads `2` and `3` are deactivated until threads `0` and `1` are finished with `do_work_1()`. Then, threads `0`, `1` are deactivated, and `2`, `3` are activated. Then, after `do_work_2()` finishes, all the threads are reactivated and the code continues execution. We have effectively doubled the amount of time it took to calculate `do_work_1()` and `do_work_2()`.

Don't let this mislead you though. Using an `if` statement does not always halve your performance. This is only true in the worst case scenario.\
Remember that if all threads take the same branch, efficiency is not lost.

If none of that made sense, all you really need to know is that you should avoid code branching, wherever possible. This includes (but is not limited to): `if-else`, `continue`, and `break` statements.

### Loops

In this guide, We are using shader model 20b. Model 20b is interesting because (as far as I'm aware) all loops need to be [unrolled](https://en.wikipedia.org/wiki/Loop_unrolling), and cannot be dynamic.

Shader model 30 does however support dynamic loops, but is not supported on Linux systems.

To continue, navigate to `gmod_shader_guide/shaders` and take a look at `example4_ps2x.hlsl`

# [Example 5] - Vertex Shaders

> [!NOTE]
> **FOR THIS EXAMPLE, PLEASE LOAD INTO** `gm_construct` **AS IT IS THE MAP THESE VISUALS ARE BASED AROUND**.

Now that we have the basics on everything pixel shader related, it's time to jump into vertex shaders.

Like I explained earlier in [The Shader Pipeline](#the-shader-pipeline), vertex shaders are the section of code which transforms 3D coordinates onto the screen.\
As you'd expect, vertex shaders run shader code for every vertex.

In this vertex shader example, we are going to be including some Valve helper functions. The source code is in the `.h` files you might have seen earlier.

These files include a bunch of useful functions and definitions for us to use. A good example is `cEyePos`, which returns the current eye position of the player (as you can imagine, this can be useful in many types of shaders).

Now, type `shader_example 5` in console and take a quick look at what this shader currently produces. It should look like this:\
<img src="https://github.com/user-attachments/assets/9efe05ee-a962-45df-aa8b-1b84e297f655" width="50%" height="50%">

Then, take a look at `example5_ps2x.hlsl`. Feel free to make your own changes.

> [!NOTE]
> We no longer need the `$vertextransform` and `$ignorez` flags defined in the .vmt because we aren't doing screenspace operations anymore

> [!TIP]
> If you look at the vmt, you will notice the `$cull` flag being set to 1. This is because by default, the shader renders on both sides.

> [!TIP]
> For performance reasons, it is generally a good idea to keep as many calculations as possible within the vertex shader, because the pixel shader runs a lot more than the vertex shader.

# [Example 6] - Vertex Shader Constants

![meme](https://github.com/user-attachments/assets/cbd5d599-ae07-4de6-90bc-027ce073a128)

> [!NOTE]
> **FOR THIS EXAMPLE, PLEASE LOAD INTO** `gm_construct`, **AS IT IS THE MAP THESE VISUALS ARE BASED AROUND**.

The source code for `screenspace_general` does not specify any custom constants we can use to input data into the vertex shader.

In order to get metadata into our vertex shader, we are going to need to sneak it in through existing constants, since there aren't any explicitly defined. This is pretty hacky, but I'm not aware of any other way.

I've seen people use fog data and the projection matrix, but for our case I am going to use the ambient cube. I have chosen to do this, as it is pretty versatile and allows for 18 custom inputs.

If there is another, cleaner technique, please make an issue or pull request to this repository so it can be documented!

Here is an image of what `shader_example 6` should look like:\
<img src="https://github.com/user-attachments/assets/ca379402-9bb6-41de-94cc-011b5151bb48" width="50%" height="50%">

After you view `shader_example 6`, open `example6_vs2x.hlsl` and `gmod_shader_guide/lua/autorun/client/shader_examples.lua` to get an understanding of how this works.

# [Example 7] - Render Targets
We're going to take a small detour with shaders to talk about render targets, as they are very important when implementing your own render pipelines.

The concept of a render target is quite simple. A render target is just a texture that you can edit.\
Unless specified otherwise (using IMAGE_FORMAT) a render target has 4 color channels (Red, Green, Blue, Alpha) which you should already understand fairly well.

`shader_example 7` Shows you different flags you can use in a 16x16 render target.\
![image](https://github.com/user-attachments/assets/32b1a036-b92b-47f7-9591-68fa527a3aee)

Because this example is more of an explanation, it doesn't use any custom shaders. And since I don't really have anything else to say, I am going to document some of my findings about render targets which some people may find useful.

> [!NOTE]
> Despite what the wiki tells you, render targets do not have mipmapping.

> [!NOTE]
> In a shader you should still return a color space of `0.0 - 1.0` regardless of the render targets IMAGE_FORMAT

> [!NOTE]
> Source Engine is really weird and does gamma correction on render targets (INCLUDING on the alpha channel!), meaning you will likely want to use the `$linearwrite` flag on your shader if you want exact results. This is particularly useful with UI shaders

# [Example 8] - Multi-Render Targets
Multi-render target (abbreviated MRT) is a rendering technique which allows a shader to output to multiple render targets in a single pass. This means you can output more useful data which may be required in later stages of a rendering pipeline.

Example 8 is simply 2 different postprocessing shaders of the [framebuffer](https://en.wikipedia.org/wiki/Framebuffer) (the rendered frame) running at the same time. When you type `shader_example 8`, you will see 2 rendertargets. The top is the first output, the bottom is the second. MRT allows for up to 4 separate render targets to be written to at a time. (But the example just renders 2)

![image](https://github.com/user-attachments/assets/d4105837-485f-4677-a802-99740487f91f)

Take a look at `example8_ps2x.hlsl` for the syntax.

> [!NOTE]
> When doing MRT, ensure you output to render targets that are the same resolution as your render context (usually just the screen resolution), otherwise you may run into undefined behavior.

> [!NOTE]
> Any operations on the GPU which read or write memory are quite expensive, this includes (but is not limited to) any of the texture sampler functions (tex1D, tex2D, tex2Dlod, etc) and MRT

# [Example 9] - Depth
DEPTH pixel shader

# [] - Shaders on Models
normals compression

# [] - IMeshes

# [] - Geometry Shaders

# [] - Volumetric Textures
traditional animated textures arent possible
need to use volumetric

# Shader Model Differences
Shader Model 30:
- Supports Dynamic Loops
- More avaliable instructions
- VPOS input in pixel shader
- Not supported on linux

Shader Model 20b:
- Supported on Linux

# We're done!
If you made it here, you (hopefully) have read and understand everything there is to know (or atleast, that I know) about GMod shaders.\
Please note that this is NOT a comprehensive guide on everything HLSL! There is still plenty more to learn, but this is definitely a good starting point.

If you want more shader examples, check out shaders in the [Source SDK](https://github.com/ValveSoftware/source-sdk-2013/tree/master/src/materialsystem/stdshaders) (labeled as .fxc)

Feel free to ask questions (or concerns) in the Issues tab. I will answer them best I can :)

<ins>Happy shading!</ins>
