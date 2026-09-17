-- Render invisible or confusable Unicode characters inline as <0xXXXX>,
-- the way JetBrains IDEs do. Pure Lua, no plugins.
local M = {}
local api = vim.api

local ns = api.nvim_create_namespace("invisible_chars")
local group = api.nvim_create_augroup("InvisibleChars", { clear = true })
local has_inline = vim.fn.has("nvim-0.10") == 1

-- Code points that get rendered. Each entry is { first, last } inclusive.
-- Ordinary tabs, trailing spaces and \r are intentionally absent: those
-- belong to 'listchars' and 'fileformat'.
local RANGES = {
    { 0x00A0, 0x00A0 }, -- no-break space
    { 0x00AD, 0x00AD }, -- soft hyphen
    { 0x034F, 0x034F }, -- combining grapheme joiner
    { 0x061C, 0x061C }, -- Arabic letter mark
    { 0x115F, 0x1160 }, -- Hangul fillers
    { 0x1680, 0x1680 }, -- Ogham space mark
    { 0x180E, 0x180E }, -- Mongolian vowel separator
    { 0x2000, 0x200F }, -- en/em spaces, zero-width space/joiners, LRM/RLM
    { 0x2028, 0x202F }, -- line/para separators, bidi embeds, narrow nbsp
    { 0x205F, 0x206F }, -- medium math space, word joiner, bidi isolates
    { 0x3000, 0x3000 }, -- ideographic space
    { 0x3164, 0x3164 }, -- Hangul filler
    { 0xFE00, 0xFE0F }, -- variation selectors
    { 0xFEFF, 0xFEFF }, -- BOM / zero-width nbsp
    { 0xFFA0, 0xFFA0 }, -- halfwidth Hangul filler
    { 0xFFF9, 0xFFFB }, -- interlinear annotation chars
}

local config = {
    enabled = true,
    ignore_filetypes = { "help", "man", "lazy", "mason", "TelescopePrompt", "neo-tree", "alpha", "trouble", "undotree" },
    highlight = has_inline and "NonText" or "ErrorMsg",
    max_lines = 20000,
    margin = 200,
    debounce_ms = 100,
}

local state = {
    enabled = false,
    regex = nil,
    saved = {}, -- win -> { conceallevel, concealcursor } before we touched them
    timers = {}, -- buf -> uv timer
}

local function build_regex()
    local parts = {}
    for _, r in ipairs(RANGES) do
        if r[1] == r[2] then
            parts[#parts + 1] = string.format("\\u%04X", r[1])
        else
            parts[#parts + 1] = string.format("\\u%04X-\\u%04X", r[1], r[2])
        end
    end
    return vim.regex("[" .. table.concat(parts) .. "]")
end

local function set_highlight()
    api.nvim_set_hl(0, "InvisibleChar", { link = config.highlight, default = true })
end

local function eligible(buf)
    if not api.nvim_buf_is_valid(buf) or not api.nvim_buf_is_loaded(buf) then
        return false
    end
    if vim.bo[buf].buftype ~= "" then
        return false
    end
    return not vim.tbl_contains(config.ignore_filetypes, vim.bo[buf].filetype)
end

local function win_opt(win, name)
    return api.nvim_get_option_value(name, { win = win })
end

local function set_win_opt(win, name, value)
    api.nvim_set_option_value(name, value, { win = win, scope = "local" })
end

local OURS = { conceallevel = 2, concealcursor = "nc" }

local function stamp(win, name)
    local info = api.nvim_get_option_info2(name, { win = win })
    return info.last_set_sid .. ":" .. info.last_set_linenr .. ":" .. info.last_set_chan
end

local function apply_win(win)
    if not has_inline or state.saved[win] or not api.nvim_win_is_valid(win) then
        return
    end
    if win_opt(win, "conceallevel") >= 1 then
        return
    end
    local saved = { stamp = {} }
    for name, value in pairs(OURS) do
        saved[name] = win_opt(win, name)
        set_win_opt(win, name, value)
        saved.stamp[name] = stamp(win, name)
    end
    state.saved[win] = saved
end

-- Only put back values we set and nobody changed since (ftplugins and
-- render-markdown write these options too).
local function restore_win(win)
    local saved = state.saved[win]
    if not saved then
        return
    end
    state.saved[win] = nil
    if not api.nvim_win_is_valid(win) then
        return
    end
    for name, value in pairs(OURS) do
        if win_opt(win, name) == value and stamp(win, name) == saved.stamp[name] then
            set_win_opt(win, name, saved[name])
        end
    end
end

local function mark_range(buf, first, last)
    local re = state.regex
    for lnum = first, last do
        local col = 0
        local s, e = re:match_line(buf, lnum, col)
        while s do
            local start_col, end_col = col + s, col + e
            local text = api.nvim_buf_get_text(buf, lnum, start_col, lnum, end_col, {})[1]
            local label = string.format("<0x%04X>", vim.fn.char2nr(text, true))
            local opts = { end_col = end_col }
            if has_inline then
                opts.conceal = ""
                opts.virt_text = { { label, "InvisibleChar" } }
                opts.virt_text_pos = "inline"
            else
                opts.hl_group = "InvisibleChar"
            end
            api.nvim_buf_set_extmark(buf, ns, lnum, start_col, opts)
            col = end_col
            s, e = re:match_line(buf, lnum, col)
        end
    end
end

local function is_large(buf)
    return api.nvim_buf_line_count(buf) > config.max_lines
end

local function refresh(buf, win)
    if not state.enabled or not eligible(buf) then
        return
    end
    api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    local last = api.nvim_buf_line_count(buf) - 1
    if is_large(buf) then
        win = (win and api.nvim_win_is_valid(win)) and win or api.nvim_get_current_win()
        if api.nvim_win_get_buf(win) ~= buf then
            return
        end
        local view = api.nvim_win_call(win, function()
            return { vim.fn.line("w0") - 1, vim.fn.line("w$") - 1 }
        end)
        mark_range(buf, math.max(0, view[1] - config.margin), math.min(last, view[2] + config.margin))
    else
        mark_range(buf, 0, last)
    end
end

local function refresh_debounced(buf)
    local timer = state.timers[buf]
    if not timer then
        timer = vim.uv.new_timer()
        state.timers[buf] = timer
    end
    timer:stop()
    timer:start(config.debounce_ms, 0, vim.schedule_wrap(function()
        if api.nvim_buf_is_valid(buf) then
            refresh(buf)
        end
    end))
end

local function drop_timer(buf)
    local timer = state.timers[buf]
    if timer then
        timer:stop()
        timer:close()
        state.timers[buf] = nil
    end
end

local function on_win_show(win, buf)
    if eligible(buf) then
        apply_win(win)
        refresh(buf, win)
    else
        restore_win(win)
    end
end

local function create_autocmds()
    api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter", "FileType" }, {
        group = group,
        callback = function(ev)
            on_win_show(api.nvim_get_current_win(), ev.buf)
        end,
    })
    api.nvim_create_autocmd("TextChanged", {
        group = group,
        callback = function(ev)
            refresh(ev.buf)
        end,
    })
    api.nvim_create_autocmd("TextChangedI", {
        group = group,
        callback = function(ev)
            refresh_debounced(ev.buf)
        end,
    })
    api.nvim_create_autocmd("WinScrolled", {
        group = group,
        callback = function(ev)
            local win = tonumber(ev.match) or api.nvim_get_current_win()
            if api.nvim_win_is_valid(win) then
                local buf = api.nvim_win_get_buf(win)
                if is_large(buf) then
                    refresh(buf, win)
                end
            end
        end,
    })
    api.nvim_create_autocmd("WinNew", {
        group = group,
        callback = function()
            local new_win = api.nvim_get_current_win()
            local parent = vim.fn.win_getid(vim.fn.winnr("#"))
            if state.saved[parent] and not state.saved[new_win] then
                state.saved[new_win] = vim.deepcopy(state.saved[parent])
            end
        end,
    })
    api.nvim_create_autocmd("WinClosed", {
        group = group,
        callback = function(ev)
            state.saved[tonumber(ev.match)] = nil
        end,
    })
    api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
        group = group,
        callback = function(ev)
            drop_timer(ev.buf)
        end,
    })
    api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = set_highlight,
    })
end

function M.enable()
    if state.enabled then
        return
    end
    state.enabled = true
    state.regex = state.regex or build_regex()
    set_highlight()
    create_autocmds()
    for _, win in ipairs(api.nvim_list_wins()) do
        on_win_show(win, api.nvim_win_get_buf(win))
    end
end

function M.disable()
    if not state.enabled then
        return
    end
    state.enabled = false
    api.nvim_clear_autocmds({ group = group })
    for buf in pairs(state.timers) do
        drop_timer(buf)
    end
    for _, buf in ipairs(api.nvim_list_bufs()) do
        if api.nvim_buf_is_loaded(buf) then
            api.nvim_buf_clear_namespace(buf, ns, 0, -1)
        end
    end
    for win in pairs(state.saved) do
        restore_win(win)
    end
end

function M.toggle()
    if state.enabled then
        M.disable()
    else
        M.enable()
    end
end

function M.is_enabled()
    return state.enabled
end

function M.setup(opts)
    config = vim.tbl_deep_extend("force", config, opts or {})
    set_highlight()

    api.nvim_create_user_command("InvisibleChars", function(cmd)
        local action = cmd.fargs[1] or "toggle"
        if action == "toggle" or action == "enable" or action == "disable" then
            M[action]()
        else
            vim.notify("InvisibleChars: unknown action " .. action, vim.log.levels.ERROR)
        end
    end, {
        nargs = "?",
        complete = function()
            return { "toggle", "enable", "disable" }
        end,
        desc = "Toggle inline rendering of invisible Unicode characters",
    })

    vim.keymap.set("n", "<leader>ui", M.toggle, { silent = true, desc = "Invisible Chars Toggle" })

    if config.enabled then
        M.enable()
    end
end

return M
