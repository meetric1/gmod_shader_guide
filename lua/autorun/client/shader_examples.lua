
local switch = CreateConVar("shader_example", "0")

local material1 = Material("gmod_shader_guide/example1")
local function example1()
	cam.Start2D()
	render.SetMaterial(material1)

	-- we gotta use a box for these screenspace examples, as the vertex shader isnt defined and uses
	-- some weird premade vertex shader that takes screenspace coords
	render.DrawBox(Vector(-1, 1), Angle(), Vector(0, 0, 0), Vector(0.5, -0.5, 0))
	cam.End2D()
end

local examples = {
	example1,

}

hook.Add("PostDrawOpaqueRenderables", "shader_example", function(_, _, sky3d)
	if sky3d then return end	-- avoid rendering in skybox

	local example = examples[switch:GetInt()]
	if example then
		example()
	end

	--render.OverrideDepthEnable(false, false)
end)
