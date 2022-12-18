local M = {}

M.toggleterm = {
  "ToggleTerm",
  "ToggleTermAll",
  "ToggleTermSendCurrentLine",
  "ToggleTermSendVisualSelection",
  "ToggleTermSendVisualLine",
  "ToggleTermSetName",
}

M.packer = {
  "PackerSnapshot",
  "PackerSnapshotRollback",
  "PackerSnapshotDelete",
  "PackerInstall",
  "PackerUpdate",
  "PackerSync",
  "PackerClean",
  "PackerCompile",
  "PackerStatus",
  "PackerProfile",
  "PackerLoad",
}

M.treesitter = {
  "TSInstall",
  "TSBufEnable",
  "TSBufDisable",
  "TSEnable",
  "TSDisable",
  "TSModuleInfo",
}

return M
