for _,f in pairs(game.forces) do 
  f.reset_recipes()
  f.recipes['relay-combinator'].enabled = f.technologies['factory-architecture'].researched 
end