return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			ui.setup()

			require("nvim-dap-virtual-text").setup()

			dap.adapters.php = {
				type = "executable",
				command = "node",
				args = { "/Users/b.stavenuiter/code/vscode-php-debug/out/phpDebug.js" },
			}

			dap.configurations.php = {
				{
					type = "php",
					request = "launch",
					name = "Listen for Xdebug (9003)",
					port = 9003,
				},
			}

			-- Eval var under cursor
			vim.keymap.set("n", "<space>?", function()
				require("dapui").eval(nil, { enter = true })
			end)

			vim.keymap.set("n", "<leader>db", ui.toggle) -- toggle the ui
			vim.keymap.set("n", "<leader>dr", function() -- reset the layout
				ui.setup()
				ui.close()
				ui.open()
			end)

			vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor)
			vim.keymap.set("n", "<leader>dc", dap.continue)
			vim.keymap.set("n", "<F5>", dap.step_back)
			vim.keymap.set("n", "<F13>", dap.restart)

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
					vim.keymap.set("n", "J", require("dap").step_into, { desc = "DAP: Step Into" })
					vim.keymap.set("n", "L", require("dap").step_over, { desc = "DAP: Step Over" })
					vim.keymap.set("n", "K", require("dap").step_out, { desc = "DAP: Step Out" })
					vim.keymap.set("n", "C", require("dap").continue, { desc = "DAP: Continue" })
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.disconnect.dapui_config = function()
					pcall(vim.keymap.del, "n", "J")
					pcall(vim.keymap.del, "n", "L")
					pcall(vim.keymap.del, "n", "K")
					pcall(vim.keymap.del, "n", "C")
			end
		end,
	},
}
