vim.opt.expandtab = true    -- Tabs zu Spaces konvertieren
vim.opt.tabstop = 4         -- Wie breit ein Tab-Zeichen angezeigt wird
vim.opt.softtabstop = 4     -- Wie viele Spaces beim Drücken von Tab/Backspace eingefügt/gelöscht werden
vim.opt.shiftwidth = 4      -- Einrückungstiefe bei >>, << und Auto-Indent
vim.opt.smartindent = true  -- Automatisches Einrücken (C-like)
vim.opt.autoindent = true   -- Übernimmt Einrückung der vorherigen Zeile


require("config.lazy")
