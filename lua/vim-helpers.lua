-- all vim helper functions here

vim.keymap.set("n", "<leader>ce", function()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #diagnostics > 0 then
		local message = diagnostics[1].message
		vim.fn.setreg("+", message)
		print("Copied diagnostic: " .. message)
	else
		print("No diagnostic at cursor")
	end
end, { noremap = true, silent = true })

-- go to errors in a file :/
vim.keymap.set("n", "<leader>ne", vim.diagnostic.goto_next) -- next err
vim.keymap.set("n", "<leader>pe", vim.diagnostic.goto_prev) -- previous err
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
-- copy current file path (absolute) into clipboard
vim.keymap.set("n", "<leader>cp", function()
	local filepath = vim.fn.expand("%:p")
	vim.fn.setreg("+", filepath) -- Copy to Neovim clipboard
	vim.fn.system("echo '" .. filepath .. "' | pbcopy") -- Copy to macOS clipboard
	print("Copied: " .. filepath)
end, { desc = "Copy absolute path to clipboard" })

-- open the current file in browser
vim.keymap.set("n", "<leader>ob", function()
	local file_path = vim.fn.expand("%:p") -- get the current file path
	if file_path ~= "" then
		local cmd
		if vim.fn.has("mac") == 1 then
			local firefox_installed = os.execute(" which /Applications/Firefox.app/Contents/MacOS/firefox")
			if firefox_installed ~= "/Applications/Firefox.app/Contents/MacOS/firefox" then
				cmd = "open -a 'Firefox' " .. file_path
			else
				cmd = "open -a 'Google Chrome' " .. file_path
			end
		else
			cmd = "Firefox " .. file_path
			local firefox_installed = os.execute("which firefox > /dev/null 2>&1")
			if firefox_installed ~= 0 then
				cmd = "google-chrome " .. file_path
			end
		end
		os.execute(cmd .. " &")
	else
		print("No file to open")
	end
end, { desc = "Open current file in browser" })

-- set language based on vim mode
-- requires im-select https://github.com/daipeihust/im-select
-- recommend installing it by brew
local function get_current_layout()
	local f = io.popen("im-select")
	local layout = nil
	if f ~= nil then
		layout = f:read("*all"):gsub("\n", "")
		f:close()
	end
	return layout
end

-- Save current layout
local previous_layout = get_current_layout()

vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		previous_layout = get_current_layout()
	end,
})

-- If exit insert mode, in command mode -> eng layout
vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineEnter" }, {
	callback = function()
		os.execute("im-select com.apple.keylayout.ABC")
	end,
})

-- mode change to normal -> eng layout
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*:*n",
	callback = function()
		os.execute("im-select com.apple.keylayout.ABC")
	end,
})

-- when back to nvim, restore prev layout
vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
		os.execute("im-select " .. previous_layout)
	end,
})
