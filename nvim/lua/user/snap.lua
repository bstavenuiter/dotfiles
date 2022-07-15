local snap = require'snap'

snap.maps {
  {"<Leader><Leader>", snap.config.file {producer = "ripgrep.file"}},
  {"<Leader>fb", snap.config.file {producer = "vim.buffer"}},
  {"<Leader>fo", snap.config.file {producer = "vim.oldfile"}},
  {"<Leader>ff", snap.config.vimgrep {}},
}

vim.cmd[[
highlight! link SnapSelect GruvboxBlue
highlight! link SnapMultiSelect GruvboxGray
highlight! link SnapNormal GruvboxFg1
highlight! link SnapBorder SnapNormal
highlight! link SnapPrompt GruvboxOrangeBold
highlight! link SnapPosition GruvboxOrangeBold
]]
