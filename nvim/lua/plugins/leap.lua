return {
	"ggandor/leap.nvim",
	config = function()
		local leap = require("leap")
		leap.create_default_mappings()
		leap.case_sensitive = false
		-- leap.set_repeat_keys('<enter>', '<backspace>')
		leap.labels = 'tnseriao/TNSERIAO?'

	end,
}

