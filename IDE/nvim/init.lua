-- ==========================================
-- NEOVIM + NEOVIDE КОНФИГ ДЛЯ РАЗРАБОТКИ
-- Java | Python | C++
-- ==========================================
-- ~/.config/nvim/init.lua

-- 1. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Загрузка плагинов
-- Эта строка говорит Lazy загрузить всё из папки lua/plugins/
require("lazy").setup("plugins", {
    change_detection = { notify = false } -- Опционально: убрать уведомления об изменении конфига
})

-- Здесь могут быть ваши общие настройки (vim.opt...) и keymaps
-- Базовые настройки
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.encoding = "utf-8"
vim.cmd("syntax on")
vim.opt.termguicolors = true

-- Отступы (4 пробела для Java/C++, 4 для Python)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Поиск
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- ==========================================
-- NEOVIDE НАСТРОЙКИ
-- ==========================================

if vim.g.neovide then
    vim.o.guifont = "JetBrainsMono Nerd Font:h13"
    vim.g.neovide_scale_factor = 1.0
    vim.g.neovide_cursor_animation_length = 0.10
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_refresh_rate = 144
    vim.g.neovide_remember_window_size = true
end

-- ==========================================
-- ЗАГРУЗКА ПЛАГИНОВ
-- ==========================================
