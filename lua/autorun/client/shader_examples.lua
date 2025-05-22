
local switch = CreateConVar("shader_example", "0")
local function example1()

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
