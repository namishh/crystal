" Setting up the colors
let s:wave0_gui = "#0d1617"
let s:wave1_gui = "#df5b61"
let s:wave2_gui = "#6ec587"
let s:wave3_gui = "#deb26a"
let s:wave4_gui = "#659bdb"
let s:wave5_gui = "#c167d9"
let s:wave6_gui = "#6fd1d5"
let s:wave7_gui = "#c5d7d7"
let s:wave8_gui = "#253336"
let s:wave9_gui = "#f16269"
let s:wave10_gui = "#8dd5a0"
let s:wave11_gui = "#dbb476"
let s:wave12_gui = "#739bdf"
let s:wave13_gui = "#d16ee0"
let s:wave14_gui = "#7bd3e0"
let s:wave15_gui = "#cedcd9"
let s:wavebg_gui = "#0a1011"
let s:wavefg_gui = "#d7e0e0"

let s:waveNR_fg = s:wave7_gui

hi clear
syntax reset
let g:colors_name = "wave"
set background=dark
set t_Co=256
hi Normal guifg=#d7e0e0 ctermbg=NONE guibg=#0a1011 gui=NONE

set t_Co=256
let &t_ut=''
if exists('+termguicolors')
  set termguicolors
endif

" Focused line Number toggle
if !exists("g:waveNR")
    let g:waveNR = 1
endif

if g:waveNR == 0
    let s:waveNR_fg = .s:wave0_gui
endif

"Syntax Highlighting
exe "hi CursorLineNR guifg=" s:waveNR_fg
exe "hi CursorLine guibg=" s:wave0_gui

exe "hi ErrorMsg guifg=" s:wave1_gui." guibg="s:wave8_gui
exe "hi WarningMsg guifg=" s:wave0_gui

exe "hi PreProc guifg=" s:wave4_gui
exe "hi Exception guifg=" s:wave7_gui
exe "hi Error guifg=" s:wave1_gui
exe "hi Type guifg=" s:wave4_gui
exe "hi Identifier guifg=" s:wave1_gui

exe "hi Constant guifg=" s:wave4_gui
exe "hi Repeat guifg=" s:wave5_gui
exe "hi Keyword guifg=" s:wave5_gui
exe "hi IncSearch guifg=" s:wave3_gui
exe "hi Title guifg=" s:wave2_gui
exe "hi PreCondit guifg=" s:wave5_gui
exe "hi Debug guifg=" s:wave13_gui
exe "hi SpecialChar guifg=" s:wave4_gui
exe "hi Conditional guifg=" s:wave1_gui
exe "hi Todo guifg=" s:wavebg_gui
exe "hi Todo guibg=" s:wave3_gui
exe "hi Special guifg=" s:wave4_gui
exe "hi Label guifg=" s:wave12_gui
exe "hi Delimiter guifg=" s:wave7_gui
exe "hi Number guifg=" s:wave6_gui
exe "hi Define guifg=" s:wave6_gui
exe "hi MoreMsg guifg=" s:wave14_gui
exe "hi Tag guifg=" s:wave15_gui
exe "hi String guifg=" s:wave2_gui
exe "hi MatchParen guifg=" s:wave1_gui
exe "hi Macro guifg=" s:wave5_gui
exe "hi Function guifg=" s:wave4_gui
exe "hi Directory guifg=" s:wave4_gui
exe "hi markdownLinkText guifg=" s:wave9_gui
exe "hi Include guifg=" s:wave1_gui
exe "hi Storage guifg=" s:wave9_gui
exe "hi Statement guifg=" s:wave5_gui
exe "hi Operator guifg=" s:wave4_gui
exe "hi ColorColumn guibg=" s:wave8_gui
exe "hi PMenu guifg="s:wave7_gui." guibg=" s:wave0_gui
exe "hi PMenuSel guifg="s:wave8_gui." guibg="s:wave5_gui
exe "hi SignColumn guibg=" s:wave0_gui
exe "hi Title guifg=" s:wave3_gui
exe "hi LineNr guifg="s:wave8_gui
exe "hi NonText guifg="s:wave5_gui." guibg="s:wave0_gui
exe "hi Comment guifg="s:wave8_gui "gui=italic" 
exe "hi SpecialComment guifg="s:wave8_gui "gui=italic guibg=NONE "
exe "hi TabLineFill gui=NONE guibg="s:wave1_gui
exe "hi TabLineSel gui=NONE guibg="s:wave1_gui
exe "hi TabLine guifg="s:wavefg_gui." guibg="s:wave1_gui
exe "hi StatusLine guibg="s:wavebg_gui." guifg="s:wavefg_gui
exe "hi StatusLineNC guibg="s:wavebg_gui." guifg="s:wavefg_gui
exe "hi Search guibg="s:wave8_gui." guifg="s:wave4_gui
exe "hi VertSplit gui=NONE guifg="s:wave8_gui." guibg="s:wave0_gui
exe "hi Visual gui=NONE guibg="s:wave0_gui
exe "hi Underlined guifg="s:wave3_gui
exe "hi EndOfBuffer guibg=NONE"

" Spell Highlightings
exe "hi SpellBad guifg="s:wave1_gui
exe "hi SpellCap guifg="s:wave1_gui." guibg="s:wave8_gui
exe "hi SpellLocal guifg="s:wave4_gui
exe "hi SpellRare guifg="s:wave5_gui

" Diff Highlightings
exe "hi DiffAdd guifg="s:wave2_gui." guibg="s:wavebg_gui
exe "hi DiffChange guifg="s:wave5_gui." guibg="s:wavebg_gui
exe "hi DiffDelete guifg="s:wave1_gui." guibg="s:wavebg_gui
exe "hi DiffText guifg="s:wave2_gui." guibg="s:wavebg_gui

" GitGutter Highlightings
exe "hi GitGutterAdd guifg="s:wave3_gui
exe "hi GitGutterChange guifg="s:wave1_gui
exe "hi GitGutterDelete guifg="s:wave3_gui
exe "hi GitGutterChangeDelete guifg="s:wave4_gui
exe "hi GitGutterLineHighlightsEnable guifg="s:wave9_gui." guibg="s:wave8_gui

" Nvim-Treesitter Highlights
exe "hi TSAttribute guifg="s:wave4_gui
exe "hi TSBoolean guifg="s:wave6_gui
exe "hi TSCharacter guifg="s:wave4_gui
exe "hi TSComment guifg="s:wave8_gui
exe "hi TSConditional guifg="s:wave1_gui
exe "hi TSConstant guifg="s:wave6_gui
exe "hi TSConstBuiltin guifg="s:wave4_gui
exe "hi TSConstMacro guifg="s:wave3_gui
exe "hi TSConstructor guifg="s:wave4_gui
exe "hi TSException guifg="s:wave8_gui
exe "hi TSField guifg="s:wave1_gui
exe "hi TSFloat guifg="s:wave8_gui
exe "hi TSFunction guifg="s:wave1_gui
exe "hi TSFuncBuiltin guifg="s:wave14_gui
exe "hi TSFuncMacro guifg="s:wave2_gui
exe "hi TSInclude guifg="s:wave9_gui
exe "hi TSKeyword guifg="s:wave5_gui
exe "hi TSKeywordFunction guifg="s:wave4_gui
exe "hi TsKeywordOperator guifg="s:wave12_gui
exe "hi TSKeywordReturn guifg="s:wave4_gui
exe "hi TSLabel guifg="s:wave4_gui
exe "hi TSMethod guifg="s:wave12_gui
exe "hi TSNamespace guifg="s:wave9_gui
exe "hi TSNumber guifg="s:wave3_gui
exe "hi TSParameter guifg="s:wave1_gui
exe "hi TSParameterReference guifg="s:wave9_gui
exe "hi TSProperty guifg="s:wave1_gui
exe "hi TSPunctDelimiter guifg="s:wave7_gui
exe "hi TSPunctBracket guifg="s:wave7_gui
exe "hi TSPunctSpecial guifg="s:wave7_gui
exe "hi TSRepeat guifg="s:wave11_gui
exe "hi TSString guifg="s:wave2_gui
exe "hi TSStringRegex guifg="s:wave2_gui
exe "hi TSStringEscape guifg="s:wave4_gui
exe "hi TSStringSpecial guifg="s:wave4_gui
exe "hi TSSymbol guifg="s:wave1_gui
exe "hi TSTag guifg="s:wave4_gui
exe "hi TSTagAttribute guifg="s:wave1_gui
exe "hi TSTagDelimiter guifg="s:wave7_gui
exe "hi TSText guifg="s:wave7_gui
exe "hi TSStrong guifg="s:wave7_gui
exe "hi TSEmphasis gui=italic guifg="s:wave7_gui
exe "hi TSUnderline guifg="s:wave5_gui
exe "hi TSStrike guifg="s:wave7_gui
exe "hi TSTitle guifg="s:wave3_gui
exe "hi TSLiteral guifg="s:wave2_gui
exe "hi TSURI guifg="s:wave3_gui
exe "hi TSMath guifg="s:wave6_gui
exe "hi TSTextReference guifg="s:wave6_gui
exe "hi TSEnvirontment guifg="s:wave5_gui
exe "hi TSEnvironmentName guifg="s:wave3_gui
exe "hi TSNote guifg="s:wave8_gui
exe "hi TSWarning guifg="s:wave0_gui." guibg="s:wave1_gui
exe "hi TSDanger guifg="s:wave8_gui
exe "hi TSType guifg="s:wave3_gui
exe "hi TSTypeBuiltin guifg="s:wave3_gui
exe "hi TSVariable guifg="s:wave7_gui
exe "hi TSVariableBuiltin guifg="s:wave4_gui

" C Language Higlights
exe "hi cConstant guifg="s:wave4_gui
exe "hi cCppBracket guifg="s:wave7_gui
exe "hi cCppInElse guifg="s:wave7_gui
exe "hi cCppInElse2 guifg="s:wave7_gui
exe "hi cCppInIf guifg="s:wave4_gui
exe "hi cCppInSkip guifg="s:wave7_gui
exe "hi cCppInWapper guifg="s:wave5_gui
exe "hi cCppOutElse guifg="s:wave7_gui
exe "hi cCppOutIf guifg="s:wave8_gui
exe "hi cCppOutIf2 guifg="s:wave8_gui
exe "hi cCppOutInGroup guifg="s:wave8_gui
exe "hi cCppOutSkip guifg="s:wave8_gui
exe "hi cCppOutWrapper guifg="s:wave5_gui
exe "hi cCppParen guifg="s:wave7_gui
exe "hi cCppString guifg="s:wave2_gui
exe "hi cCurlyError guifg="s:wave7_gui." guibg="s:wave9_gui
exe "hi cErrInBracket guifg="s:wave7_gui." guibg="s:wave9_gui
exe "hi cErrInParen guifg="s:wave7_gui." guibg="s:wave9_gui
exe "hi cFloat guifg="s:wave8_gui
exe "hi cFormat guifg="s:wave4_gui
exe "hi cMutli guifg="s:wave3_gui
exe "hi cOperator guifg="s:wave4_gui
exe "hi cParen guifg="s:wave3_gui
exe "hi cParenError guifg="s:wave7_gui." guibg="s:wave9_gui
exe "hi PreProcGroup guifg="s:wave4_gui
exe "hi cSpaceError guifg="s:wave1_gui
exe "hi cSpecial guifg="s:wave4_gui
exe "hi cSpecialCharacter guifg="s:wave4_gui
exe "hi cStatement guifg="s:wave5_gui
exe "hi cStorageClass guifg="s:wave3_gui
exe "hi cString guifg="s:wave2_gui
exe "hi cType guifg="s:wave3_gui
exe "hi cUserCont guifg="s:wave7_gui

" GoLang Highlight Groups
exe "hi goBlock guifg="s:wave7_gui
exe "hi goBuiltins guifg="s:wave13_gui
exe "hi goCharacter guifg="s:wave1_gui
exe "hi goComment guifg="s:wave8_gui
exe "hi goComplexes guifg="s:wave3_gui
exe "hi goConditional guifg="s:wave5_gui
exe "hi goConstants guifg="s:wave5_gui
exe "hi goDecimalInt  guifg="s:wave3_gui
exe "hi goDeclType guifg="s:wave13_gui
exe "hi goDeclaration guifg="s:wave5_gui
exe "hi goDirective guifg="s:wave1_gui
exe "hi goEscapeC guifg="s:wave4_gui
exe "hi goEscapeBigU guifg="s:wave4_gui
exe "hi goEscapeError guifg="s:wave0_gui." guibg="s:wave1_gui
exe "hi goEscapeOctal guifg="s:wave4_gui
exe "hi goEscapeU guifg="s:wave4_gui
exe "hi goEscapeX guifg="s:wave4_gui
exe "hi goExtraType guifg="s:wave3_gui
exe "hi goFloat guifg="s:wave11_gui
exe "hi goFloats guifg="s:wave12_gui
exe "hi goHexadecimalInt guifg="s:wave3_gui
exe "hi goImaginary guifg="s:wave3_gui
exe "hi goLabel guifg="s:wave3_gui
exe "hi goOctalError guifg="s:wave1_gui
exe "hi goOctalInt guifg="s:wave11_gui
exe "hi goParen guifg="s:wave7_gui
exe "hi goRawString guifg="s:wave10_gui
exe "hi goRepeat guifg="s:wave3_gui
exe "hi goSignedInts guifg="s:wave11_gui
exe "hi goSpaceError guifg="s:wave0_gui." guibg="s:wave1_gui
exe "hi goSpecialString guifg="s:wave12_gui
exe "hi goStatement guifg="s:wave1_gui
exe "hi goString guifg="s:wave10_gui
exe "hi goTSComment guifg="s:wave8_gui
exe "hi goTSFunction guifg="s:wave4_gui
exe "hi goTSInclude guifg="s:wave4_gui
exe "hi goTSkeyword guifg="s:wave5_gui
exe "hi goTSKeywordFunction guifg="s:wave5_gui
exe "hi goTSMethod guifg="s:wave4_gui
exe "hi goTSNumber guifg="s:wave8_gui
exe "hi goTSOperator guifg="s:wave12_gui
exe "hi goTSProperty guifg="s:wave1_gui
exe "hi goTSPunctBracket guifg="s:wave6_gui
exe "hi goTSPunctDelimiter guifg="s:wave13_gui
exe "hi goTSRepeat guifg="s:wave3_gui
exe "hi goTSString guifg="s:wave10_gui
exe "hi goTSType guifg="s:wave3_gui
exe "hi goTSTypeBuiltin guifg="s:wave3_gui
exe "hi goTSVariable guifg="s:wave5_gui
exe "hi goTodo guifg="s:wave3_gui
exe "hi goType guifg="s:wave3_gui

" NvimTree Highlights
exe "hi NvimTreeFolderIcon guifg="s:wave3_gui
exe "hi NvimTreeFoldername guifg="s:wavefg_gui
exe "hi NvimTreeOpenedFolderName guifg="s:wave4_gui
exe "hi NvimTreeEmptyFolderName guifg="s:wave4_gui
exe "hi NvimTreeFileDirty guifg="s:wave1_gui
exe "hi NvimTreeExecFile guifg="s:wavefg_gui
exe "hi NvimTreeGitDirty guifg="s:wave1_gui
exe "hi NvimTreeGitDeleted guifg="s:wave1_gui
exe "hi NvimTreeRootFolder guifg="s:wave5_gui
exe "hi NvimTreeIndentMarker guifg="s:wave0_gui
