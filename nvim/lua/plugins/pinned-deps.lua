-- Plugins that only appear as `dependencies` of other specs.
-- lazy.nvim merges specs by repo, so pinning them here pins them everywhere.
return {
	{ "nvim-lua/plenary.nvim", commit = "857c5ac632080dba10aae49dba902ce3abf91b35" },
	{ "MunifTanjim/nui.nvim", commit = "f535005e6ad1016383f24e39559833759453564e" },
	{ "nvim-tree/nvim-web-devicons", commit = "1fb58cca9aebbc4fd32b086cb413548ce132c127" },
	{ "rafamadriz/friendly-snippets", commit = "572f5660cf05f8cd8834e096d7b4c921ba18e175" },
}
