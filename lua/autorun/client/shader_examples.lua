-- This is the Lua file that controls the rendering for each shader example
-- Each example is defined by a function and is ran in a PostDrawOpaque hook depending on which convar option is selected
-- Hopefully its pretty easy to understand and follow


-- we gotta use a quad for these screenspace examples, as the vertex shader isnt defined and uses
-- some weird premade vertex shader that takes screenspace relative coordinates
-- and render.DrawScreenQuadEx takes integer inputs which arent precise enough
local function unfucked_draw_screen_quad(mat)
	render.SetMaterial(mat)

	cam.Start2D()
	render.DrawQuad(Vector(-1, 1), Vector(-0.5, 1), Vector(-0.5, 0.5), Vector(-1, 0.5, 0))
	cam.End2D()
end
-- If you are reading this^ and wondering why even the simplest example requires some fuckery.. welcome to gmod

-----------------------------------------------------------
------------------------ Example 1 ------------------------
-----------------------------------------------------------
local material1 = Material("gmod_shader_guide/example1.vmt")
local function example1()
	unfucked_draw_screen_quad(material1)
end


-----------------------------------------------------------
------------------------ Example 2 ------------------------
-----------------------------------------------------------
local material2 = Material("gmod_shader_guide/example2.vmt")
local function example2()
	unfucked_draw_screen_quad(material2)
end

-----------------------------------------------------------
------------------------ Example 3 ------------------------
-----------------------------------------------------------
local material3 = Material("gmod_shader_guide/example3.vmt")
local function example3()
	-- set up our material input the shader will use
	material3:SetFloat("$c0_x", CurTime())

	unfucked_draw_screen_quad(material3)
end

-----------------------------------------------------------
------------------------ Example 4 ------------------------
-----------------------------------------------------------
local material4 = Material("gmod_shader_guide/example4.vmt")
local function example4()
	unfucked_draw_screen_quad(material4)
end

-----------------------------------------------------------
------------------------ Example 5 ------------------------
-----------------------------------------------------------

-----------------------------------------------------------
------------------------ Rendering ------------------------
-----------------------------------------------------------

local switch = CreateConVar("shader_example", "0")
local examples = {
	example1,
	example2,
	example3,
	example4,
}

hook.Add("PostDrawOpaqueRenderables", "shader_example", function(_, _, sky3d)
	if sky3d then return end	-- avoid rendering in skybox

	local example = examples[switch:GetInt()]
	if example then
		example()
	end

	--render.OverrideDepthEnable(false, false)
end)
