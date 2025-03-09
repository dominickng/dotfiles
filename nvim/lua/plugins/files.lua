return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "echasnovski/mini.icons" },
		opts = function()
			local fzf = require("fzf-lua")
			local config = fzf.config
			local actions = fzf.actions

			vim.keymap.set("n", "<Bslash>f", function()
				require("fzf-lua").files()
			end)
			vim.keymap.set("n", "<Bslash>b", function()
				require("fzf-lua").buffers()
			end)
			vim.keymap.set("v", "<Bslash>v", function()
				require("fzf-lua").grep_visual()
			end)
			vim.keymap.set("n", "<Bslash>g", function()
				require("fzf-lua").grep_cword()
			end)

			config.defaults.actions.files["ctrl-s"] = false
			config.defaults.actions.files["enter"] = actions.file_switch_or_edit
			config.defaults.actions.files["ctrl-x"] = actions.file_split
		end,
	},
}
