-- Preview the current markdown file with leaf (terminal markdown viewer)
-- in a floating terminal window.
local api = vim.api

local function leaf_preview()
    if vim.fn.executable("leaf") ~= 1 then
        vim.notify("leaf is not installed (paru -S leaf-markdown-viewer)", vim.log.levels.ERROR)
        return
    end

    local file = vim.fn.expand("%:p")
    if file == "" then
        vim.notify("No file to preview", vim.log.levels.WARN)
        return
    end

    -- write pending changes so leaf shows the current content
    vim.cmd("silent! update")

    local width = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.9)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local buf = api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"

    local win = api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    -- --watch reloads the preview when the file changes on disk
    vim.fn.jobstart({ "leaf", "--watch", file }, {
        term = true,
        on_exit = function()
            if api.nvim_win_is_valid(win) then
                api.nvim_win_close(win, true)
            end
        end,
    })
    vim.cmd("startinsert")
end

api.nvim_create_user_command("LeafPreview", leaf_preview, {
    desc = "Preview markdown with leaf",
})

api.nvim_create_autocmd("FileType", {
    group = api.nvim_create_augroup("LeafPreview", { clear = true }),
    pattern = "markdown",
    callback = function(ev)
        vim.keymap.set("n", "<leader>mp", "<cmd>LeafPreview<CR>", {
            buffer = ev.buf,
            silent = true,
            desc = "Preview markdown [leaf]",
        })
    end,
})
