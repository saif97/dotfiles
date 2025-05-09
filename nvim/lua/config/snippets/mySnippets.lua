M = {}

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

function M.setup()
	addall()
	addShell()
	addMarkdown()
	addLua()
end

function addall()
	ls.add_snippets("all", {
		s(
			"checkbox",
			t({
				"- [ ] ",
			})
		),
	})
end

function addShell()
	ls.add_snippets("sh", {
		s(
			"she",
			t({
				"#!/bin/bash",
				"set -xe",
			})
		),
	})
end

function addLua()
	ls.add_snippets("lua", {
		s("notify - print", {
			t([[vim.notify("]]),
			i(1),
			t([[")]]),
		}),
	})
end

function addMarkdown()
	local function get_date()
		return os.date("%B %dth %I:%M %p") -- May 2nd 5:35 AM
	end

	ls.add_snippets("markdown", {
		s(
			"date",
			t({
				"------------------------",
				get_date(),
				"",
			})
		),
	})
end

function addPython()
	ls.add_snippets("python", {
		s(
			"ignore type",
			t({
				"# type: ignore",
			})
		),
	})
end

return M
