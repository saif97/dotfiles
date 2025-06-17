return {
	"nanozuki/tabby.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local theme = {
			fill = "TabLineFill",
			head = { fg = "#8aadf4", bg = "#24273a", style = "italic" },
			current_tab = { fg = "#1e2030", bg = "#8aadf4", style = "italic" },
			tab = { fg = "#8aadf4", bg = "#24273a", style = "italic" },
			win = { fg = "#1e2030", bg = "#8aadf4", style = "italic" },
			tail = { fg = "#8aadf4", bg = "#24273a", style = "italic" },
		}

		require("tabby.tabline").set(function(line)
			return {
				{
					{ "  ", hl = theme.head },
					line.sep("", theme.head, theme.fill), -- 
				},
				line.tabs().foreach(function(tab)
					local hl = tab.is_current() and theme.current_tab or theme.tab
					return {
						line.sep("", hl, theme.fill), -- 
						tab.number(),
						tab.name(),
						line.sep("", hl, theme.fill), -- 
						hl = hl,
						margin = " ",
					}
				end),

				line.spacer(),
				{
					line.sep("", theme.tail, theme.fill), -- 
					{ "   some future stuff", hl = theme.tail },
				},
				hl = theme.fill,
			}
		end)
	end,
}
