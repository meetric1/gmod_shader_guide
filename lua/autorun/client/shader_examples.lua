-- This is the Lua file that controls the rendering for each shader example
-- Each example is defined by a function and is ran in a PostDrawOpaque hook depending on which convar option is selected
-- Hopefully its pretty easy to understand and follow


-- we gotta use a quad for these screenspace examples, as the vertex shader isnt defined and uses
-- some weird premade vertex shader that takes screenspace relative coordinates
-- and render.DrawScreenQuadEx takes integer inputs which arent precise enough
local function draw_screen_quad(mat)
	render.SetMaterial(mat)

	cam.Start2D()
	render.DrawQuad(Vector(-1, 1), Vector(-0.5, 1), Vector(-0.5, 0.5), Vector(-1, 0.5))
	cam.End2D()
end
-- If you are reading this^ and wondering why even the simplest example requires some fuckery.. welcome to gmod

-----------------------------------------------------------
------------------------ Example 1 ------------------------
-----------------------------------------------------------
local material1 = Material("gmod_shader_guide/example1.vmt")
local function example1()
	draw_screen_quad(material1)
end


-----------------------------------------------------------
------------------------ Example 2 ------------------------
-----------------------------------------------------------
local material2 = Material("gmod_shader_guide/example2.vmt")
local function example2()
	draw_screen_quad(material2)
end

-----------------------------------------------------------
------------------------ Example 3 ------------------------
-----------------------------------------------------------
local material3 = Material("gmod_shader_guide/example3.vmt")
local function example3()
	-- set up our material input the shader will use
	material3:SetFloat("$c0_x", CurTime())

	draw_screen_quad(material3)
end

-----------------------------------------------------------
------------------------ Example 4 ------------------------
-----------------------------------------------------------
local material4 = Material("gmod_shader_guide/example4.vmt")
local function example4()
	draw_screen_quad(material4)
end

-----------------------------------------------------------
------------------------ Example 5 ------------------------
-----------------------------------------------------------
local material5 = Material("gmod_shader_guide/example5.vmt")
local function example5()
	render.SetMaterial(material5)
	render.DrawBox(Vector(), Angle(30, 30, 30) * CurTime(), Vector(-50, -50, -50), Vector(50, 50, 50))
end

-----------------------------------------------------------
------------------------ Example 6 ------------------------
-----------------------------------------------------------
local material6 = Material("gmod_shader_guide/example6.vmt")
local dummy_model = ClientsideModel("models/shadertest/vertexlit.mdl")
dummy_model:SetModelScale(0)	-- make it invisible
local function set_vertex_metadata(x, y, z)
	-- make sure to supress engine lighting before setting it up, otherwise we won't override anything
	render.SuppressEngineLighting(true)	

	-- Actually send our metadata to the shader. In this case, I am using the front part of the cube (0)
	-- You can use different directions to send up to 6 different constants
	-- (The source code of which can be found in common_vs_fxc.h)
	render.SetModelLighting(0, x, y, z)

	-- Forces sourceengine to set up our custom lighting
	dummy_model:DrawModel()

	-- Don't forget to reenable lighting!
	render.SuppressEngineLighting(false)
end

local function example6()
	render.SetMaterial(material6)
	set_vertex_metadata(CurTime(), 0, 0)
	render.DrawSphere(Vector(), 50, 10, 10)
end

-----------------------------------------------------------
------------------------ Example 7 ------------------------
-----------------------------------------------------------
local rt_mat = CreateMaterial("ex7_mat", "UnlitGeneric", {["$ignorez"] = 1})

-- fills a rendertarget with a grass block texture
local function fill_rt(rt)
	rt_mat:SetTexture("$basetexture", "gmod_shader_guide/grass_block")
	render.SetMaterial(rt_mat)

	render.PushRenderTarget(rt)
	render.DrawScreenQuad()
	render.PopRenderTarget()
end

-- create some render targets. the only thing changing here are the texture flags
local nopoint_noclamp = GetRenderTargetEx("ex7_0", 16, 16, 0, 2,  16,          0, 0) fill_rt(nopoint_noclamp)
local point_noclamp   = GetRenderTargetEx("ex7_1", 16, 16, 0, 2,  1,           0, 0) fill_rt(point_noclamp)
local nopoint_clamp   = GetRenderTargetEx("ex7_2", 16, 16, 0, 2,  4 + 8 + 16,  0, 0) fill_rt(nopoint_clamp)
local point_clamp     = GetRenderTargetEx("ex7_3", 16, 16, 0, 2,  1 + 4 + 8,   0, 0) fill_rt(point_clamp)

-- draw_texture is an insanely inefficient function btw. Don't use this code
local function draw_texture(texture, x, y, size)
	-- Set our material with our rendertarget (its pretty much just a texture)
	rt_mat:SetTexture("$basetexture", texture:GetName())
	render.SetMaterial(rt_mat)

	cam.Start2D()
	-- this is pretty cursed but I need a mesh with wacky UVs
	mesh.Begin(MATERIAL_QUADS, 1)
		mesh.Position(x, y, 0)
		mesh.TexCoord(0, -1, -1)
		mesh.AdvanceVertex()

		mesh.Position(x + size, y, 0)
		mesh.TexCoord(0, 2, -1)
		mesh.AdvanceVertex()

		mesh.Position(x + size, y + size, 0)
		mesh.TexCoord(0, 2, 2)
		mesh.AdvanceVertex()
		
		mesh.Position(x, y + size, 0)
		mesh.TexCoord(0, -1, 2)
		mesh.AdvanceVertex()
	mesh.End()
	cam.End2D()
end

local function example7()
	cam.Start2D()
	draw.DrawText("anisotropic + noclamp", "ChatFont", 0, 30, color_white)
	draw.DrawText("point + noclamp", "ChatFont", 250, 30, color_white)
	draw.DrawText("anisotropic + clamp", "ChatFont", 0, 280, color_white)
	draw.DrawText("point + clamp", "ChatFont", 250, 280, color_white)
	cam.End2D()

	draw_texture(nopoint_noclamp, 0, 50, 200)
	draw_texture(point_noclamp, 250, 50, 200)
	draw_texture(nopoint_clamp, 0, 300, 200)
	draw_texture(point_clamp, 250, 300, 200)
end

-----------------------------------------------------------
------------------------ Rendering ------------------------
-----------------------------------------------------------

local switch = CreateConVar("shader_example", "0")
local examples = {
	example1,
	example2,
	example3,
	example4,
	example5,
	example6,
	example7,
}

hook.Add("PostDrawOpaqueRenderables", "shader_example", function(_, _, sky3d)
	if sky3d then return end	-- avoid rendering in skybox

	local example = examples[switch:GetInt()]
	if example then
		example()
	end

	--render.OverrideDepthEnable(false, false)
end)