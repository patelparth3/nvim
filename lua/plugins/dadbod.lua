vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_win_position   = 'right'
vim.g.db_ui_winheight      = 50


-- ======================================
-- Export current VISUAL selection via psql \copy
-- Adds CSV and TSV commands
-- ======================================

local EXPORT_DIR = "/Users/parth/db-exports"
vim.fn.mkdir(EXPORT_DIR, "p")

local function ts() return os.date("%Y%m%d_%H%M%S") end

local function ensure_name(name, ext) -- ext = "csv" or "tsv"
    if not name or name == "" then
        return ("results_%s.%s"):format(ts(), ext)
    end
    if name:match("%." .. ext .. "$") then
        return name
    end
    return ("%s_%s.%s"):format(name, ts(), ext)
end

-- DSN from dadbod/env
local function get_dadbod_dsn()
    if type(vim.b.db) == "string" and vim.b.db:match("://") then return vim.b.db end
    if type(vim.b.db) == "table" then
        local t = vim.b.db
        if type(t.url) == "string" and t.url:match("://") then return t.url end
        if t.type == "postgres" or t.adapter == "postgres" then
            local user = t.user or os.getenv("USER") or "postgres"
            local pass = t.password and (":" .. t.password) or ""
            local host = t.host or "localhost"
            local port = t.port and (":" .. t.port) or ""
            local db   = t.database or t.db or ""
            return string.format("postgres://%s%s@%s%s/%s", user, pass, host, port, db)
        end
    end
    local env = os.getenv("PGURL") or os.getenv("DATABASE_URL")
    if env and env:match("://") then return env end
    return nil
end

-- get last VISUAL selection (works even after leaving visual mode)
local function get_sql_selection()
    local s = vim.fn.getpos("'<")
    local e = vim.fn.getpos("'>")
    local ls, cs = s[2], s[3]
    local le, ce = e[2], e[3]
    if ls == 0 or le == 0 or (ls == le and cs == ce) then
        vim.notify("Select SQL in visual mode, then run the command.", vim.log.levels.WARN)
        return nil
    end
    if (le < ls) or (le == ls and ce < cs) then
        ls, le, cs, ce = le, ls, ce, cs
    end
    local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
    if #lines == 0 then
        vim.notify("Empty selection.", vim.log.levels.WARN)
        return nil
    end
    local BIG = 2000000000
    if cs > 1 then lines[1] = lines[1]:sub(cs) end
    if ce > 0 and ce < BIG then lines[#lines] = lines[#lines]:sub(1, ce) end
    local sql = table.concat(lines, "\n")
    sql = sql:gsub("%s*;%s*$", "") -- drop trailing ;
    if not sql:match("%S") then
        vim.notify("Selection contained only whitespace.", vim.log.levels.WARN)
        return nil
    end
    return sql
end

-- core runner: format = "csv" or "tsv"
local function run_psql_copy(sql, out_path, dsn, format)
    if vim.fn.executable("psql") == 0 then
        vim.notify("psql not found in PATH", vim.log.levels.ERROR)
        return
    end
    local path_sql = out_path:gsub("'", "''")

    -- ***** THIS is the only difference for TSV vs CSV *****
    local with_clause
    if format == "tsv" then
        -- tab-separated; keeps quoting/escaping; Excel/Numbers behave better
        with_clause = "WITH (FORMAT csv, DELIMITER E'\\t', HEADER true, QUOTE '\"', ESCAPE '\"')"
    else
        -- classic CSV
        with_clause = "WITH (FORMAT csv, HEADER true)"
    end
    local copy_cmd = ([[\copy (%s) TO '%s' %s]]):format(sql, path_sql, with_clause)

    local cmd = { "psql", dsn, "-v", "ON_ERROR_STOP=1", "-c", copy_cmd }
    vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_stderr = function(_, data)
            if data and #data > 0 then
                local msg = table.concat(data, "\n")
                if msg:match("%S") then vim.notify(msg, vim.log.levels.WARN) end
            end
        end,
        on_exit = function(_, code)
            if code == 0 then
                vim.notify("Exported → " .. out_path, vim.log.levels.INFO)
            else
                vim.notify("Export failed (exit " .. code .. "). See messages.", vim.log.levels.ERROR)
            end
        end,
    })
end

-- :DBCopyCSV [name]
vim.api.nvim_create_user_command("DBCopyCSV", function(cmd)
    local sql = get_sql_selection(); if not sql then return end
    local dsn = get_dadbod_dsn(); if not dsn then
        vim.notify("No dadbod connection. Connect with :DB ... first.", vim.log.levels.ERROR)
        return
    end
    local name = cmd.args ~= "" and cmd.args or vim.fn.input("CSV name (no ext ok): ")
    local fname = ensure_name(name, "csv")
    local out = (EXPORT_DIR:gsub("/$", "")) .. "/" .. fname
    vim.fn.mkdir(EXPORT_DIR, "p")
    run_psql_copy(sql, out, dsn, "csv")
end, { nargs = "?", complete = "file" })

-- :DBCopyTSV [name]  (recommended for big text fields)
vim.api.nvim_create_user_command("DBCopyTSV", function(cmd)
    local sql = get_sql_selection(); if not sql then return end
    local dsn = get_dadbod_dsn(); if not dsn then
        vim.notify("No dadbod connection. Connect with :DB ... first.", vim.log.levels.ERROR)
        return
    end
    local name = cmd.args ~= "" and cmd.args or vim.fn.input("TSV name (no ext ok): ")
    local fname = ensure_name(name, "tsv")
    local out = (EXPORT_DIR:gsub("/$", "")) .. "/" .. fname
    vim.fn.mkdir(EXPORT_DIR, "p")
    run_psql_copy(sql, out, dsn, "tsv")
end, { nargs = "?", complete = "file" })

-- Optional keybinds (visual mode)
vim.keymap.set("v", "<leader>ec", ":<C-U>DBCopyCSV<CR>", { desc = "Export selection → CSV via psql" })
vim.keymap.set("v", "<leader>et", ":<C-U>DBCopyTSV<CR>", { desc = "Export selection → TSV via psql" })
