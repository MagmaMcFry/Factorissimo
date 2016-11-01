require 'lib/class'
require 'lib/explicit-global'
require 'lib/table-utils'

DebugManager = class()

function DebugManager:new()
    managers.event:register(defines.events.on_player_created, self, callback(self.setup_debug_items, self))
end

function DebugManager:setup_debug_items(event)
    local player = game.players[event.player_index]
    player.insert{name="small_factory", count=10}
    player.insert{name="express-transport-belt", count=200}
    player.insert{name="steel-axe", count=10}
    player.insert{name="medium-electric-pole", count=100}
    player.insert{name="burner-inserter", count=10}
    player.insert{name="solid-fuel", count=50}
    player.insert{name="steel-chest", count=10}
    player.insert{name="solar-panel", count=20}
    player.cheat_mode = true
    --player.gui.top.add{type="button", name="enter-factory", caption="Enter Factory"}
    --player.gui.top.add{type="button", name="leave-factory", caption="Leave Factory"}
    player.gui.top.add{type="button", name="debug", caption="Debug"}
    player.force.research_all_technologies()
end
