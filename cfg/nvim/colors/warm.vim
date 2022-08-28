" Setting up the colors
let s:warm0_gui = "#252528"
let s:warm1_gui = "#d08689"
let s:warm2_gui = "#9bcba8"
let s:warm3_gui = "#d3b787"
let s:warm4_gui = "#7894b0"
let s:warm5_gui = "#c095cb"
let s:warm6_gui = "#87b9bb"
let s:warm7_gui = "#b9c1c1"
let s:warm8_gui = "#282931"
let s:warm9_gui = "#db7176"
let s:warm10_gui = "#9adaab"
let s:warm11_gui = "#d3b787"
let s:warm12_gui = "#77a6c2"
let s:warm13_gui = "#d7a1df"
let s:warm14_gui = "#81c6cf"
let s:warm15_gui = "#ccc9c3"
let s:warmbg_gui = "#0f0f0f"
let s:warmfg_gui = "#dfdee0"

let s:warmNR_fg = s:warm7_gui

hi clear
syntax reset
let g:colors_name = "warm"
set background=dark
set t_Co=256
hi Normal guifg=#dfdde0 ctermbg=NONE guibg=#0f0f0f gui=NONE

set t_Co=256
let &t_ut=''
if exists('+termguicolors')
  set termguicolors
endif

" Focused line Number toggle
if !exists("g:warmNR")
    let g:warmNR = 1
endif

if g:warmNR == 0
    let s:warmNR_fg = .s:warm0_gui
endif

"Syntax Highlighting
exe "hi CursorLineNR guifg=" s:warmNR_fg
exe "hi CursorLine guibg=" s:warm0_gui

exe "hi ErrorMsg guifg=" s:warm1_gui." guibg="s:warm8_gui
exe "hi WarningMsg guifg=" s:warm0_gui

exe "hi PreProc guifg=" s:warm4_gui
exe "hi Exception guifg=" s:warm7_gui
exe "hi Error guifg=" s:warm1_gui
exe "hi Type guifg=" s:warm4_gui
exe "hi Identifier guifg=" s:warm1_gui

exe "hi Constant guifg=" s:warm4_gui
exe "hi Repeat guifg=" s:warm5_gui
exe "hi Keyword guifg=" s:warm5_gui
exe "hi IncSearch guifg=" s:warm3_gui
exe "hi Title guifg=" s:warm2_gui
exe "hi PreCondit guifg=" s:warm5_gui
exe "hi Debug guifg=" s:warm13_gui
exe "hi SpecialChar guifg=" s:warm4_gui
exe "hi Conditional guifg=" s:warm1_gui
exe "hi Todo guifg=" s:warmbg_gui
exe "hi Todo guibg=" s:warm3_gui
exe "hi Special guifg=" s:warm4_gui
exe "hi Label guifg=" s:warm12_gui
exe "hi Delimiter guifg=" s:warm7_gui
exe "hi Number guifg=" s:warm6_gui
exe "hi Define guifg=" s:warm6_gui
exe "hi MoreMsg guifg=" s:warm14_gui
exe "hi Tag guifg=" s:warm15_gui
exe "hi String guifg=" s:warm2_gui
exe "hi MatchParen guifg=" s:warm1_gui
exe "hi Macro guifg=" s:warm5_gui
exe "hi Function guifg=" s:warm4_gui
exe "hi Directory guifg=" s:warm4_gui
exe "hi markdownLinkText guifg=" s:warm9_gui
exe "hi Include guifg=" s:warm1_gui
exe "hi Storage guifg=" s:warm9_gui
exe "hi Statement guifg=" s:warm5_gui
exe "hi Operator guifg=" s:warm4_gui
exe "hi ColorColumn guibg=" s:warm8_gui
exe "hi PMenu guifg="s:warm7_gui." guibg=" s:warm0_gui
exe "hi PMenuSel guifg="s:warm8_gui." guibg="s:warm5_gui
exe "hi SignColumn guibg=" s:warm0_gui
exe "hi Title guifg=" s:warm3_gui
exe "hi LineNr guifg="s:warm8_gui
exe "hi NonText guifg="s:warm5_gui." guibg="s:warm0_gui
exe "hi Comment guifg="s:warm8_gui "gui=italic" 
exe "hi SpecialComment guifg="s:warm8_gui "gui=italic guibg=NONE "
exe "hi TabLineFill gui=NONE guibg="s:warm1_gui
exe "hi TabLineSel gui=NONE guibg="s:warm1_gui
exe "hi TabLine guifg="s:warmfg_gui." guibg="s:warm1_gui
exe "hi StatusLine guibg="s:warmbg_gui." guifg="s:warmfg_gui
exe "hi StatusLineNC guibg="s:warmbg_gui." guifg="s:warmfg_gui
exe "hi Search guibg="s:warm8_gui." guifg="s:warm4_gui
exe "hi VertSplit gui=NONE guifg="s:warm8_gui." guibg="s:warm0_gui
exe "hi Visual gui=NONE guibg="s:warm0_gui
exe "hi Underlined guifg="s:warm3_gui
exe "hi EndOfBuffer guibg=NONE"

" Spell Highlightings
exe "hi SpellBad guifg="s:warm1_gui
exe "hi SpellCap guifg="s:warm1_gui." guibg="s:warm8_gui
exe "hi SpellLocal guifg="s:warm4_gui
exe "hi SpellRare guifg="s:warm5_gui

" Diff Highlightings
exe "hi DiffAdd guifg="s:warm2_gui." guibg="s:warmbg_gui
exe "hi DiffChange guifg="s:warm5_gui." guibg="s:warmbg_gui
exe "hi DiffDelete guifg="s:warm1_gui." guibg="s:warmbg_gui
exe "hi DiffText guifg="s:warm2_gui." guibg="s:warmbg_gui

" GitGutter Highlightings
exe "hi GitGutterAdd guifg="s:warm3_gui
exe "hi GitGutterChange guifg="s:warm1_gui
exe "hi GitGutterDelete guifg="s:warm3_gui
exe "hi GitGutterChangeDelete guifg="s:warm4_gui
exe "hi GitGutterLineHighlightsEnable guifg="s:warm9_gui." guibg="s:warm8_gui

" Nvim-Treesitter Highlights
exe "hi TSAttribute guifg="s:warm4_gui
exe "hi TSBoolean guifg="s:warm6_gui
exe "hi TSCharacter guifg="s:warm4_gui
exe "hi TSComment guifg="s:warm8_gui
exe "hi TSConditional guifg="s:warm1_gui
exe "hi TSConstant guifg="s:warm6_gui
exe "hi TSConstBuiltin guifg="s:warm4_gui
exe "hi TSConstMacro guifg="s:warm3_gui
exe "hi TSConstructor guifg="s:warm4_gui
exe "hi TSException guifg="s:warm8_gui
exe "hi TSField guifg="s:warm1_gui
exe "hi TSFloat guifg="s:warm8_gui
exe "hi TSFunction guifg="s:warm1_gui
exe "hi TSFuncBuiltin guifg="s:warm14_gui
exe "hi TSFuncMacro guifg="s:warm2_gui
exe "hi TSInclude guifg="s:warm9_gui
exe "hi TSKeyword guifg="s:warm5_gui
exe "hi TSKeywordFunction guifg="s:warm4_gui
exe "hi TsKeywordOperator guifg="s:warm12_gui
exe "hi TSKeywordReturn guifg="s:warm4_gui
exe "hi TSLabel guifg="s:warm4_gui
exe "hi TSMethod guifg="s:warm12_gui
exe "hi TSNamespace guifg="s:warm9_gui
exe "hi TSNumber guifg="s:warm3_gui
exe "hi TSParameter guifg="s:warm1_gui
exe "hi TSParameterReference guifg="s:warm9_gui
exe "hi TSProperty guifg="s:warm1_gui
exe "hi TSPunctDelimiter guifg="s:warm7_gui
exe "hi TSPunctBracket guifg="s:warm7_gui
exe "hi TSPunctSpecial guifg="s:warm7_gui
exe "hi TSRepeat guifg="s:warm11_gui
exe "hi TSString guifg="s:warm2_gui
exe "hi TSStringRegex guifg="s:warm2_gui
exe "hi TSStringEscape guifg="s:warm4_gui
exe "hi TSStringSpecial guifg="s:warm4_gui
exe "hi TSSymbol guifg="s:warm1_gui
exe "hi TSTag guifg="s:warm4_gui
exe "hi TSTagAttribute guifg="s:warm1_gui
exe "hi TSTagDelimiter guifg="s:warm7_gui
exe "hi TSText guifg="s:warm7_gui
exe "hi TSStrong guifg="s:warm7_gui
exe "hi TSEmphasis gui=italic guifg="s:warm7_gui
exe "hi TSUnderline guifg="s:warm5_gui
exe "hi TSStrike guifg="s:warm7_gui
exe "hi TSTitle guifg="s:warm3_gui
exe "hi TSLiteral guifg="s:warm2_gui
exe "hi TSURI guifg="s:warm3_gui
exe "hi TSMath guifg="s:warm6_gui
exe "hi TSTextReference guifg="s:warm6_gui
exe "hi TSEnvirontment guifg="s:warm5_gui
exe "hi TSEnvironmentName guifg="s:warm3_gui
exe "hi TSNote guifg="s:warm8_gui
exe "hi TSWarning guifg="s:warm0_gui." guibg="s:warm1_gui
exe "hi TSDanger guifg="s:warm8_gui
exe "hi TSType guifg="s:warm3_gui
exe "hi TSTypeBuiltin guifg="s:warm3_gui
exe "hi TSVariable guifg="s:warm7_gui
exe "hi TSVariableBuiltin guifg="s:warm4_gui

" C Language Higlights
exe "hi cConstant guifg="s:warm4_gui
exe "hi cCppBracket guifg="s:warm7_gui
exe "hi cCppInElse guifg="s:warm7_gui
exe "hi cCppInElse2 guifg="s:warm7_gui
exe "hi cCppInIf guifg="s:warm4_gui
exe "hi cCppInSkip guifg="s:warm7_gui
exe "hi cCppInWapper guifg="s:warm5_gui
exe "hi cCppOutElse guifg="s:warm7_gui
exe "hi cCppOutIf guifg="s:warm8_gui
exe "hi cCppOutIf2 guifg="s:warm8_gui
exe "hi cCppOutInGroup guifg="s:warm8_gui
exe "hi cCppOutSkip guifg="s:warm8_gui
exe "hi cCppOutWrapper guifg="s:warm5_gui
exe "hi cCppParen guifg="s:warm7_gui
exe "hi cCppString guifg="s:warm2_gui
exe "hi cCurlyError guifg="s:warm7_gui." guibg="s:warm9_gui
exe "hi cErrInBracket guifg="s:warm7_gui." guibg="s:warm9_gui
exe "hi cErrInParen guifg="s:warm7_gui." guibg="s:warm9_gui
exe "hi cFloat guifg="s:warm8_gui
exe "hi cFormat guifg="s:warm4_gui
exe "hi cMutli guifg="s:warm3_gui
exe "hi cOperator guifg="s:warm4_gui
exe "hi cParen guifg="s:warm3_gui
exe "hi cParenError guifg="s:warm7_gui." guibg="s:warm9_gui
exe "hi PreProcGroup guifg="s:warm4_gui
exe "hi cSpaceError guifg="s:warm1_gui
exe "hi cSpecial guifg="s:warm4_gui
exe "hi cSpecialCharacter guifg="s:warm4_gui
exe "hi cStatement guifg="s:warm5_gui
exe "hi cStorageClass guifg="s:warm3_gui
exe "hi cString guifg="s:warm2_gui
exe "hi cType guifg="s:warm3_gui
exe "hi cUserCont guifg="s:warm7_gui

" GoLang Highlight Groups
exe "hi goBlock guifg="s:warm7_gui
exe "hi goBuiltins guifg="s:warm13_gui
exe "hi goCharacter guifg="s:warm1_gui
exe "hi goComment guifg="s:warm8_gui
exe "hi goComplexes guifg="s:warm3_gui
exe "hi goConditional guifg="s:warm5_gui
exe "hi goConstants guifg="s:warm5_gui
exe "hi goDecimalInt  guifg="s:warm3_gui
exe "hi goDeclType guifg="s:warm13_gui
exe "hi goDeclaration guifg="s:warm5_gui
exe "hi goDirective guifg="s:warm1_gui
exe "hi goEscapeC guifg="s:warm4_gui
exe "hi goEscapeBigU guifg="s:warm4_gui
exe "hi goEscapeError guifg="s:warm0_gui." guibg="s:warm1_gui
exe "hi goEscapeOctal guifg="s:warm4_gui
exe "hi goEscapeU guifg="s:warm4_gui
exe "hi goEscapeX guifg="s:warm4_gui
exe "hi goExtraType guifg="s:warm3_gui
exe "hi goFloat guifg="s:warm11_gui
exe "hi goFloats guifg="s:warm12_gui
exe "hi goHexadecimalInt guifg="s:warm3_gui
exe "hi goImaginary guifg="s:warm3_gui
exe "hi goLabel guifg="s:warm3_gui
exe "hi goOctalError guifg="s:warm1_gui
exe "hi goOctalInt guifg="s:warm11_gui
exe "hi goParen guifg="s:warm7_gui
exe "hi goRawString guifg="s:warm10_gui
exe "hi goRepeat guifg="s:warm3_gui
exe "hi goSignedInts guifg="s:warm11_gui
exe "hi goSpaceError guifg="s:warm0_gui." guibg="s:warm1_gui
exe "hi goSpecialString guifg="s:warm12_gui
exe "hi goStatement guifg="s:warm1_gui
exe "hi goString guifg="s:warm10_gui
exe "hi goTSComment guifg="s:warm8_gui
exe "hi goTSFunction guifg="s:warm4_gui
exe "hi goTSInclude guifg="s:warm4_gui
exe "hi goTSkeyword guifg="s:warm5_gui
exe "hi goTSKeywordFunction guifg="s:warm5_gui
exe "hi goTSMethod guifg="s:warm4_gui
exe "hi goTSNumber guifg="s:warm8_gui
exe "hi goTSOperator guifg="s:warm12_gui
exe "hi goTSProperty guifg="s:warm1_gui
exe "hi goTSPunctBracket guifg="s:warm6_gui
exe "hi goTSPunctDelimiter guifg="s:warm13_gui
exe "hi goTSRepeat guifg="s:warm3_gui
exe "hi goTSString guifg="s:warm10_gui
exe "hi goTSType guifg="s:warm3_gui
exe "hi goTSTypeBuiltin guifg="s:warm3_gui
exe "hi goTSVariable guifg="s:warm5_gui
exe "hi goTodo guifg="s:warm3_gui
exe "hi goType guifg="s:warm3_gui

" NvimTree Highlights
exe "hi NvimTreeFolderIcon guifg="s:warm3_gui
exe "hi NvimTreeFoldername guifg="s:warmfg_gui
exe "hi NvimTreeOpenedFolderName guifg="s:warm4_gui
exe "hi NvimTreeEmptyFolderName guifg="s:warm4_gui
exe "hi NvimTreeFileDirty guifg="s:warm1_gui
exe "hi NvimTreeExecFile guifg="s:warmfg_gui
exe "hi NvimTreeGitDirty guifg="s:warm1_gui
exe "hi NvimTreeGitDeleted guifg="s:warm1_gui
exe "hi NvimTreeRootFolder guifg="s:warm5_gui
exe "hi NvimTreeIndentMarker guifg="s:warm0_gui
