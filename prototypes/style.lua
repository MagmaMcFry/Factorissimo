data:extend({
    {
        type = "font",
        name = "factory_save_subheading",
        from = "default-bold",
        size = 16
    }
})

local default_gui = data.raw["gui-style"].default

default_gui.factory_save_frame = {
    type = "frame_style",
    parent = "frame_style",
    minimal_width = 400,
}

default_gui.factory_name_input =
{
    type = "textfield_style",
    left_padding = 3,
    right_padding = 2,
    minimal_width = 410,
    maximal_width = 410,
    minimal_height = 35,
    maximal_height = 35,
    font = "default-large",
    font_color = {},
    graphical_set = {
        type = "composition",
        filename = "__core__/graphics/gui.png",
        priority = "extra-high-no-scale",
        corner_size = {3, 3},
        position = {16, 0}
    },
    selection_background_color = {r = 0.66, g = 0.7, b = 0.83}
}

default_gui.factory_name_label = {
    type = "label_style",
    font = "factory_save_subheading",
}
