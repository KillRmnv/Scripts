-- ==========================================
-- NEOVIM + NEOVIDE КОНФИГ ДЛЯ РАЗРАБОТКИ
-- Java | Python | C++
-- ==========================================
-- ~/.config/nvim/init.lua

-- Leader key (Space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim (менеджер плагинов)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Загрузка всех плагинов из lua/plugins/
require("lazy").setup("plugins", {
    change_detection = { notify = false } -- убрать уведомления об изменении конфига
})

-- ==========================================
-- БАЗОВЫЕ НАСТРОЙКИ
-- ==========================================

vim.opt.number = true            -- нумерация строк
vim.opt.mouse = "a"              -- мышь везде
vim.opt.clipboard = "unnamedplus"-- системный буфер обмена
vim.opt.encoding = "utf-8"
vim.cmd("syntax on")
vim.opt.termguicolors = true     -- 24-bit цвета

-- Отступы (4 пробела)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Поиск
vim.opt.ignorecase = true        -- регистронезависимый поиск
vim.opt.smartcase = true         -- умный регистр (если есть заглавные — учитывать)
vim.opt.hlsearch = true          -- подсветка результатов
vim.opt.incsearch = true         -- инкрементальный поиск

-- Флаг для cmp-ai (локальное AI автодополнение)
vim.g.cmp_ai_enabled = false

-- ==========================================
-- NEOVIDE НАСТРОЙКИ (GUI-фронтенд для Neovim)
-- https://github.com/neovide/neovide
-- ==========================================

if vim.g.neovide then
    vim.o.guifont = "JetBrainsMono Nerd Font:h13"
    vim.g.neovide_scale_factor = 1.0
    vim.g.neovide_cursor_animation_length = 0.10
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_refresh_rate = 144
    vim.g.neovide_remember_window_size = true

    -- Прозрачность фона Neovide (0.0 — полностью прозрачный, 1.0 — непрозрачный)
    vim.g.neovide_opacity = 0.85
    -- Тень для плавающего окна (опционально, убирает "чёрный" фон)
    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 5
end
