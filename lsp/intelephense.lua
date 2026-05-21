local function filter_ctp_undefined(err, result, ctx, config)
    if result and result.uri and result.uri:sub(-4) == '.ctp' and result.diagnostics then
        result.diagnostics = vim.tbl_filter(function(d)
            return not (d.message and d.message:find('^Undefined variable'))
        end, result.diagnostics)
    end
    return vim.lsp.handlers['textDocument/publishDiagnostics'](err, result, ctx, config)
end

return {
    settings = {
        intelephense = {
            format = {
                braces = "k&r",
            },
        },
        environment = {
            phpVersion = "5.6.0"
        },
    },
    handlers = {
        ['textDocument/publishDiagnostics'] = filter_ctp_undefined,
    },
}
