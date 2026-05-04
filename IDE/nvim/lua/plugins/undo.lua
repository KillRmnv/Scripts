-- undo.lua — дерево отмен (undo tree)

return {
    -- ==========================================
    -- UNDOTREE — визуальное дерево отмен
    -- https://github.com/mbbill/undotree
    -- Бинд: <leader>u (toggle)
    -- ==========================================
    "mbbill/undotree",
    config = function()
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
}
