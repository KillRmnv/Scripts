local icons = require("io.github.israiloff.config.icons")
local dashboard = require("alpha.themes.dashboard")
local properties = require("io.github.israiloff.config.properties")
local ascii_art = require("io.github.israiloff.config.ascii_art")

dashboard.section.header.val = ascii_art.get_random()

dashboard.section.header.opts = {
	position = "center",
	hl = "FloatBorder",
}

dashboard.section.buttons.val = {
	dashboard.button("f", icons.ui.FindFile .. " Find file", ":Telescope find_files<CR>"),
	dashboard.button("e", icons.ui.NewFile .. " New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("p", icons.ui.Project .. " Projects", ":Telescope projects<CR>"),
	dashboard.button("r", icons.ui.History .. " Recent files", ":Telescope oldfiles<CR>"),
	dashboard.button("t", icons.ui.FindText .. " Find text", ":Telescope live_grep<CR>"),
	dashboard.button("q", icons.ui.SignOut .. " Quit", ":qa<CR>"),
}

dashboard.section.footer.val = {
	"Java NeoVim IDE v" .. properties.version,
}

return dashboard