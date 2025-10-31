local dap = require("dap")
local dapui = require("dapui")

-- UI setup
dapui.setup()

-- Auto open/close dap-ui
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

--  Keymaps

-- Breakpoints
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })

-- Run to cursor
vim.keymap.set("n", "<leader>gb", dap.run_to_cursor, { desc = "DAP run to cursor" })

-- Eval var under cursor
vim.keymap.set("n", "<leader>?", function()
    dapui.eval(nil, { enter = true })
end, { desc = "DAP eval under cursor" })

-- Core debug keys (F-keys)
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP continue" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP step into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP step over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "DAP step out" })

vim.keymap.set("n", "<F13>", dap.restart, { desc = "DAP restart" }) -- Shift+F1

-- UI toggle
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP UI toggle" })

-- 🐍 Python helpers
local ok_py, dap_python = pcall(require, "dap-python")
if ok_py then
    dap_python.setup("python3")
    vim.keymap.set("n", "<leader>dn", dap_python.test_method, { desc = "DAP Python test method" })
    vim.keymap.set("n", "<leader>df", dap_python.test_class, { desc = "DAP Python test class" })
    vim.keymap.set("v", "<leader>ds", dap_python.debug_selection, { desc = "DAP Python debug selection" })
end

-- 🦫 Go helpers
local ok_go, dap_go = pcall(require, "dap-go")
if ok_go then
    dap_go.setup()
    vim.keymap.set("n", "<leader>dt", dap_go.debug_test, { desc = "DAP Go debug test" })
end


-- Docker debugpy attach (works with DEBUGPY env in container)
dap.configurations.python = {
    {
        type = "python",
        request = "attach",
        name = "Attach: Docker (5678, /app)",
        connect = { host = "127.0.0.1", port = 5678 }, -- change if you use another port
        justMyCode = false,
        pathMappings = {
            { localRoot = vim.fn.getcwd(), remoteRoot = "/madden" },
        },
        cwd = vim.fn.getcwd(),
    },
}
