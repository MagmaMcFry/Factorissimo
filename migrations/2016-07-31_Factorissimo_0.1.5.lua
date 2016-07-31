if game.is_demo() then
	return
end

for index, force in pairs(game.forces) do
	local technologies = force.technologies;
	local recipes = force.recipes;
	
	if technologies["factory-architecture"].enabled then
		recipes["small-power-plant"].enabled = true
	end
end