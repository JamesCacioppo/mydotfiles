# Dotfiles rebuild decisions

Last updated: 2026-10-01

## Status and process

This is the implementation checklist for the guided rebuild. Tool selections
below are design decisions, not evidence that tools have been installed or
configured. Only this planning document has been added so far.

- Build from scratch, using `/home/jcacioppo/repos/dotfiles` (Seb's repository)
  as inspiration and this repository's existing files as historical reference
- Review every tool Seb uses in manageable batches before implementation
- Explain each proposal in relation to the old setup, including alternatives
- Read the relevant authoritative documentation in full before proposals
- Keep this file updated as decisions are made; distinguish recommendations
  from accepted choices
- Do not blindly copy Seb's machine-specific settings or Linux desktop changes

## Target systems

- Primary: macOS on Apple Silicon
- Omarchy VM: Linux x86-64
- Other Linux distributions also used; exact distributions remain to be listed
- Linux access is mainly SSH, VS Code Remote, and Guacamole
- Omarchy desktop is experimental, but Linux should receive the 1Password app
  and CLI as explicitly requested

## Accepted foundation and interactive tools

| Area | Decision | Relationship to old setup |
| --- | --- | --- |
| Management | Full mise approach: tools plus bootstrap packages, dotfiles, and settings | Replaces the custom install scripts and Brewfile as the primary setup workflow |
| Shell | Fish | Replaces interactive Zsh and Oh My Zsh |
| Prompt | Starship | Replaces Powerlevel10k on Mac and robbyrussell on Linux |
| Fish plugins | Fisher, autopair.fish, done | Provides Fish plugin management, paired delimiters, and completion notifications |
| Terminal | Ghostty | Successor to the old Alacritty/iTerm2 choices |
| Multiplexer | herdr | Successor to the old tmux/Oh My Tmux setup |
| Editors | VS Code and Neovim | Retains VS Code; replaces the old Vim configuration with a fresh Neovim setup |
| File listing | eza, with Seb's aliases | Replaces interactive ls/tree commands |
| File viewing | bat, with Seb's cat alias | Adds highlighted file viewing |
| File finding | fd | Adds a convenient finder alongside the existing search workflow |
| Search and selection | fzf and ripgrep, following Seb's behavior | Retains existing tools with revised configuration |
| Directory navigation | zoxide, keeping z/zi separate from cd | Adds learned directory navigation |
| Git tools | delta, lazygit, gh | Replaces plain Git paging with delta; adds a terminal Git UI; retains gh |
| Git aliases | Seb's aliases | Replaces old aliases the user says they never used |
| Command examples | tealdeer | Replaces the old tldr client |
| System information | fastfetch, on demand only | No startup invocation; old startup used fortune/cowsay |

The delta/lazygit/gh selection was previously carried forward from the user's
batch acceptance and explicitly summarized in the conversation without correction.

### Selected shell alias and search behavior

```text
ls   = eza --group-directories-first
l    = eza -l --group-directories-first
la   = eza -a --group-directories-first
ll   = eza -al --group-directories-first
tree = eza -T --group-directories-first
cat  = bat --paging=never
```

- ripgrep includes hidden files while respecting Git ignores
- fzf uses Seb's file previews and skips dependency/build directories
- Follow Seb's Git alias definitions; notable meanings: `st` = stash,
  `r` = rebase, and `l` = log --oneline
- Read and verify the source definitions again when implementing

## Credentials and SSH

| Platform | Decision |
| --- | --- |
| macOS | 1Password desktop app and CLI, 1Password SSH agent, and Git signing |
| Linux | 1Password desktop app and CLI; no 1Password SSH agent |
| Linux connectivity | Must work independently of agent forwarding because connections come from various clients, including Guacamole |

- Linux key storage, standard OpenSSH agent setup, and Git signing are still
  open decisions; local keys were recommended but are not recorded as approved
- Do not copy Seb's Linux IdentityAgent or 1Password signing configuration
- Adopt fnox and Seb's age plus 1Password provider structure; configure a
  personal age identity and user-owned secret references during implementation.
  Linux secret access uses the 1Password app and CLI directly, without an
  SSH-agent dependency or forwarding.

## Accepted checks and formatting

| Item | Decision | Relationship to old setup |
| --- | --- | --- |
| hk | Follow Seb's global hook approach | Takes the hook-runner role; old Brewfile listed pre-commit |
| Commit messages | Enforce Conventional Commits | Old Brewfile included convco, but no corresponding hook was found |
| Automatic fixes | Apply fixes, stop the commit when files change, leave review and staging to the user | Explicit review step before committing formatter changes |
| ShellCheck | Adopt for Bash/sh scripts | Adds script analysis absent from the old Brewfile |
| shfmt | Adopt for Bash/sh scripts | Adds consistent automatic shell formatting |
| Fish validation | Adopt fish syntax checking and fish_indent | Checks and formats the new Fish configuration |
| EditorConfig | Adopt with two-space indentation for Bash/sh files | Preserves the old Vim two-space preference; differs from Seb's four spaces for .sh |
| editorconfig-checker | Adopt | Adds hk enforcement of the repository's EditorConfig rules |
| StyLua | Adopt through mise and hk; two-space indentation, 80-column wrapping target, other defaults | Adds formatting for Lua/Neovim configuration; old Vim configuration used Vimscript |
| Tombi | Adopt through mise and hk; use Tombi's VS Code extension | Replaces Even Better TOML in VS Code and adds repository TOML checks/formatting |
| rumdl | Adopt through mise and hk | Adds Markdown checks/formatting alongside the old Markdown editing and preview workflow |
| TOML sorting | Follow Seb's ascending key sorting in selected mise tables: settings, tools, dotfiles, bootstrap packages/directories/files, and tasks | Automatically organizes declarations replacing manually maintained setup files; command sequences retain their intended order |
| Markdown wrapping | Enable rumdl semantic line breaks with the default 80-column limit | Replaces the old README's mixed manual wrapping with sentence-aware source formatting |
| actionlint | Adopt through mise and hk for GitHub Actions workflows | Adds workflow-specific checks alongside the old yamllint and VS Code YAML tooling |
| zizmor | Adopt through mise and hk for GitHub Actions workflows | Adds automation security checks with no equivalent found in the old dotfiles |
| betterleaks | Adopt through mise with hk staged-change checks and a Git-history scan in the eventual CI workflow; redact output, no live credential validation | Adds secret detection alongside 1Password; no dedicated scanner found in the old Brewfile |
| hadolint | Adopt through mise and hk for Dockerfile checks | Adds Dockerfile and embedded shell checks alongside the old Docker Desktop and editor tooling |
| Trivy | Adopt through mise for on-demand image scans; add CI image scanning if a dotfiles container image is adopted | Adds image vulnerability, secret, and configuration scanning to the old Docker workflow |
| Pkl CLI | Adopt through mise for Seb's Pkl evaluation and formatting steps | Supports the new hk configuration; hk itself uses a built-in evaluator |
| mise formatting check | Adopt Seb's mise fmt check/fix step | Checks the manifests replacing the old Brewfile and setup scripts |
| hk-test | Adopt Seb's step-defined test check | Adds tests for hook steps in the new setup |

Betterleaks findings stop the commit for investigation. This check does not
automatically remove or repair credentials. No secret scan has been run during
this planning review.

The documented hk review behavior discussed was `fix = true`, `stash = "git"`,
`stage = false`, and `fail_on_fix = true` for pre-commit. Verify the final global
and repository configuration together before deployment. Whole-file formatters
can affect unstaged portions of partially staged files.

Global hk adoption does not automatically approve every repository-specific
linter Seb uses. Individual checks remain subject to this review process.

## Accepted global hk hygiene checks

Adopt Seb's global hk hygiene checks for UTF-8 BOMs,
large files (default 500 kB limit), case-conflicting paths, executable shebangs,
merge markers, broken symlinks, private-key markers, mixed line endings,
final newlines, and trailing whitespace. Exclude Markdown from the generic
trailing-whitespace fixer and let rumdl handle it, preserving intentional
hard breaks; align EditorConfig accordingly. Skip global smart
quote replacement because curly quotes can be intentional in prose.
All automatic changes remain subject to the accepted stop-for-review rule.
Accepted by the user on 2026-09-23; implementation remains pending.

## Accepted Node, Python, and uv setup

Accepted on 2026-09-23: adopt Node, Python, and uv through
mise. Prefer Node LTS over Seb's latest, and select a supported Python minor
at implementation rather than following new minor releases automatically.
Project versions override personal defaults. Replace the old direct Homebrew
runtime declarations and pyenv shell initialization in the new configuration.
Use uv for new Python project dependencies, lockfiles, and virtual environments;
omit pipx and Poetry from the baseline, adding Poetry per project when required.
Existing Poetry projects are not automatically migrated. Keep mise responsible
for Python runtimes; verify uv interpreter selection during implementation.
Enable existing .python-version and Node version-file discovery in mise.
Implementation remains pending.

## Accepted Rust, CMake, and tree-sitter setup

Accepted on 2026-09-23: adopt all three through mise. Adopt tree-sitter CLI
for Neovim parser management, and CMake through mise as a general build tool
complementing the CMake extensions in the old Brewfile. Adopt stable Rust
with Seb's rust-analyzer and rust-src components; mise uses rustup underneath.
Validate Neovim/plugin/CLI compatibility and native compiler prerequisites at
implementation. Full Neovim plugin selection remains separate.
Implementation remains pending.

## Accepted jq and yq setup

Accepted on 2026-09-23: retain jq (jqlang/jq) and yq
(mikefarah/yq), moving their direct Homebrew declarations to mise like Seb.
The old Brewfile already lists both; Homebrew's yq formula is Mike Farah's
implementation, matching Seb's aqua backend. Keep both, with jq
for JSON and yq for YAML queries/updates and format conversion. The separate
Python-based kislyuk/yq is not selected. Implementation remains pending.

## Accepted Bash, Fish, Lua, and Markdown language servers

Accepted on 2026-09-27: adopt Seb's bash-language-server, fish-lsp,
lua-language-server (LuaLS), and Marksman through mise for Neovim. Bash and
Fish servers use Seb's npm backend declarations. Bash language server uses
the accepted ShellCheck/shfmt tools; align editor indentation with two spaces.
Fish LSP complements fish -n/fish_indent. LuaLS adds intelligence for the Lua
Neovim configuration while StyLua remains the selected Lua formatter.
Marksman adds Markdown link/heading navigation and completion alongside rumdl;
Markdown preview and VS Code extension choices remain separate. Compare with
the old Bash scripts, Zsh-to-Fish move, Vimscript config, and VS Code Markdown
All in One/Preview Enhanced extensions. Keep server installation in mise;
Neovim connects to these executables. Implementation remains pending.

## Initial setup policy: no new keybindings to learn

Decided on 2026-09-29: defer features that require learning new keybindings.
This supersedes earlier Neovim shortcut adoptions below; those sections retain
the reviewed designs for possible later use, not initial implementation approval
where they conflict with this policy. Apply the same constraint to remaining
tool reviews without undoing explicitly selected tools or shell/Git aliases.

- Preserve native editing/navigation keys rather than importing Seb's Space
  leader scheme, backslash toggles, or changed native motion meanings.
- Defer mini.align, mini.surround, mini.ai, mini.move, mini.jump, mini.jump2d,
  mini.snippets/friendly-snippets, and their custom snippets and mappings.
- Defer mini.files and mini.pick/extra workflows for the initial setup: their
  new browser/picker interaction should be reviewed when ready to learn it.
  Do not automatically reinstall old plugins as substitutes. Native file
  opening remains available; Fish fzf is unaffected.
- Keep automatic mini.diff signs and mini.git status integration, but defer
  hunk actions, Git leader shortcuts, overlays, and Git picker workflows.
- Keep Conform format-on-save; defer manual formatting shortcuts and toggles.
- Keep automatic completion and pairing. Familiar Tab/Shift-Tab/Enter/Backspace
  completion behavior already selected can remain; mini.keymap is implementation
  support for that behavior, not a new shortcut scheme. Native completion remains
  available. Defer any additional completion/snippet keybindings.
- Use native commenting initially instead of adding mini.comment configuration.
- Keep accepted statusline, tabline, icons, notifications, cursorword,
  hipatterns, and Markdown-safe trailspace highlighting. Defer manual trimming.
- Defer mini.map and its controls; do not auto-open it as a workaround for
  avoiding its shortcuts. Omit its search-key refresh remaps initially.
- Keep mini.clue for discovering native commands, without importing Seb's custom
  leader groups, window-resize submode, or deferred-plugin triggers.
- Existing rejected/deferred modules remain excluded. Already accepted shell
  and Git aliases and tool choices remain selected; review future terminal/editor
  shortcuts under this policy.

No runtime configuration has been implemented. Non-keybinding parts of the
latest proposed utility batch (statuscolumn, misc root/cursor/loading helpers)
remain pending, not implicitly accepted by this policy change.

## Accepted Neovim plugin foundation

Accepted on 2026-09-27: adopt Seb's native vim.pack
plugin management, replacing the old simultaneous vim-plug and Vundle setup.
Track nvim-pack-lock.json and review deliberate plugin updates. vim.pack is
documented as experimental; select and validate a compatible Neovim release
(0.12+ for this API) before implementation, without silently choosing nightly.
Alternative reviewed: lazy.nvim, offering a plugin UI, dependency sequencing,
and automatic lazy-loading. Selected vim.pack for Seb's small plugin set.
Also adopt nvim-lspconfig with native vim.lsp.config/vim.lsp.enable to connect
the accepted mise-managed servers. It supplies server configurations, not
server installations or a completion menu. Other plugins and individual
mini.nvim modules remain separate decisions. Implementation remains pending.

## Accepted Neovim file browsing and fuzzy finding

Accepted on 2026-09-27: adopt mini.files with Seb's
preview-enabled column browser, mini.pick, and mini.extra's additional pickers.
Replace NERDTree for file browsing and fzf.vim/Command-T for Neovim fuzzy
finding. Retain the already accepted fzf CLI for Fish. Adopt Seb's Space
leader mappings for this group: e (current-file browser), Ed (working-directory
browser), ff (files), fg (live text search), fb (buffers), fr (resume picker).
Use rg/fd where supported and verify hidden-file/ignore behavior against the
accepted dotfile search policy. mini.files edits are synchronized with a
confirmation; validate macOS behavior as well as Linux. Other mini.nvim
modules, startup behavior, and Git features remain separate choices.
Implementation remains pending.

## Accepted Neovim Git integration

Accepted on 2026-09-27: adopt mini.git and mini.diff like
Seb, replacing Fugitive in the new configuration. Use accepted lazygit for
broader repository workflows. mini.git provides :Git and contextual history;
mini.diff shows buffer changes relative to the Git index, supports staging
and resetting hunks, and does not support unstaging hunks. It does not recreate
NERDTree Git status badges in mini.files. Adopt Seb's Git keymaps,
including Space gd/ga/gl/go/gc (unstaged diff/staged diff/history/overlay/commit)
and Space gC (amend), with uppercase file-specific counterparts where defined,
plus his mini.extra Git pickers. Preserve conventional-commit and
stop-after-fixes rules for commits initiated from any interface; validate
actual integration during implementation. Fugitive was considered as an
alternative and is not selected for the new configuration.
Implementation remains pending.

## Accepted Neovim completion and snippets

Accepted on 2026-09-27: adopt mini.completion,
mini.snippets, and friendly-snippets via vim.pack. mini.completion connects
to accepted language servers; old YCM-Generator was a configuration helper,
not proof of a complete YouCompleteMe installation. mini.snippets replaces
the disabled UltiSnips role; friendly-snippets replaces the disabled
honza/vim-snippets collection role with language-loaded JSON snippets.
Adopt Seb's completion filtering (hide LSP Text items, place Snippet
items last), Tab/Shift-Tab selection and Enter acceptance; use default
Ctrl-J expansion and Ctrl-L/Ctrl-H snippet placeholder navigation.
Include Seb's cdate/ctime/cdtm snippets and Lua local snippet/removed prefixes.
Do not assume friendly-snippets automatically appears in the completion
menu: Seb's config does not start the optional snippet LSP server. Validate
the chosen completion/expansion behavior and remote key delivery during
implementation. mini.keymap/mini.pairs details remain for later review.
Implementation remains pending.

## Accepted Neovim formatting

Accepted on 2026-09-27: adopt conform.nvim via
vim.pack with format-on-save, Seb's 500 ms save timeout, manual Space lf
formatting, and global/buffer toggles (`\f` / `\F`, FormatDisable[!], FormatEnable).
Expand Seb's explicit Lua-only formatter mapping to the accepted tools:
Lua=StyLua, Bash/sh=shfmt, Fish=fish_indent, TOML=Tombi, Markdown=rumdl.
Use project configuration, including accepted indentation and Markdown rules.
Follow Seb's LSP fallback when no external formatter is available; this can
format other filetypes when an attached server supports it. Verify fallback
does not conflict with selected formatter policy. Old vim-terraform already
enabled format-on-save; Terraform integration remains for its tool review.
Saving applies formatting without a confirmation prompt. The hk rule
still stops commits when the hook itself makes fixes; editor formatting is
reviewed through normal diffs/staging. Manual-only formatting was considered;
format-on-save was selected. Implementation remains pending.

## Accepted Neovim editing helpers

Accepted on 2026-09-27: adopt all four editing helpers with Seb's defaults,
including mini.pairs in command-line mode. Implementation remains pending.

- mini.align replaces the old vim-easy-align plugin. Use default ga alignment
  and gA alignment with live preview.
- mini.comment adds explicit commenting configuration: gcc for the current
  line and gc for motions or visual selections. No dedicated commenting plugin
  was found in the old vimrc. Native Neovim commenting is a viable simpler
  alternative; selected Seb's module for configuration consistency.
- mini.pairs adds automatic bracket/quote pairing in Insert mode and, following
  Seb, command-line mode. No equivalent explicit plugin was found in the old
  vimrc. This complements Fish autopair, which only affects the shell.
- mini.surround adds manipulation of surrounding quotes, brackets, and tags;
  no equivalent explicit plugin was found in the old vimrc. Follow Seb's default
  sa/sd/sr mappings for adding/deleting/replacing surroundings. These use the s
  prefix, changing the native Normal-mode s binding.

Read the complete upstream README for each of these four modules.

## Accepted Neovim text selection and movement

Accepted on 2026-09-27: adopt mini.ai, mini.move, mini.jump,
and mini.jump2d with Seb's configuration and the described keybinding changes.

- mini.ai extends native inside/around text objects. Follow Seb's cover search
  method and custom B whole-buffer object from the accepted mini.extra module.
  This changes native iB/aB from brace-block objects to buffer objects; use
  i{/a{ for brace blocks. Its an/in mappings also override Neovim 0.12's native
  incremental selection. No equivalent dedicated plugin in the old vimrc.
- mini.move moves selected text or the current line with Alt-h/j/k/l, with
  linewise reindentation enabled. Adds shortcuts over native cut/paste and
  indentation. Old Ctrl-h/j/k/l mappings moved the cursor or paged, not text.
  Validate Alt delivery through Ghostty, VS Code terminals, and Guacamole;
  Seb's Ghostty config sets macos-option-as-alt=true. Terminal choices are
  still a separate review item.
- mini.jump extends native f/F/t/T searches across lines and repeats with the
  same jump key. This changes familiar native motions, including operators;
  native line-limited motions remain the simpler alternative.
- mini.jump2d uses Enter in Normal/Visual/operator-pending mode to show labels
  for jumping to visible positions, including other windows in the tab.
  Adds navigation beyond old native search, relative line numbers, and paging;
  does not replace the accepted file/content pickers. Changes native Normal-mode
  Enter behavior; Insert-mode Enter completion/pairing remains separate.

Read all four complete upstream READMEs. Implementation remains pending.

## Native Neovim indentation navigation and text operators

Decided on 2026-09-27: use native Neovim for this batch. Do not enable
mini.indentscope, mini.bracketed, mini.operators, or mini.splitjoin.

- Keep native navigation and selections; do not add the animated indentation
  scope indicator or ii/ai scope objects. Retain accepted two-space indentation.
- Use native navigation commands and accepted pickers instead of mini.bracketed.
  Do not add its undo tracking wrappers or plugin-specific bracket mappings.
- Use native editing, registers, and sorting instead of mini.operators. Preserve
  native gx and gr-prefixed LSP mappings; do not copy Seb's workaround that
  removes those LSP mappings. Review any additional language shortcuts later.
- Use native line edits and joining instead of mini.splitjoin's gS toggle.
  Accepted Conform formatting remains in scope.

The old vimrc had no dedicated equivalent plugins. This decision applies to
these four proposed modules; earlier accepted mini.nvim modules remain accepted.
Read all four complete upstream READMEs. Implementation remains pending.

## Accepted Neovim interface choices

Accepted on 2026-09-29: adopt mini.clue; keep native
command-line completion and input prompts instead of mini.cmdline/mini.input.

- mini.clue shows possible next keys and descriptions after a prefix. Follow
  Seb's 250 ms delay, automatic window width, and mini.files trigger setup.
  Adapt clues to accepted mappings and native Neovim; do not introduce rejected
  modules through copied labels or shortcuts. Old showcmd shows typed keys,
  but the old vimrc has no next-key hint plugin. Selected this to help learn
  the accepted mappings. Native help and mapping inspection are alternatives.
- mini.cmdline adds automatic command-line completion, fixed-candidate word
  autocorrection, and command-range previews. Seb enables all defaults. Old
  wildmenu and wildmode=list:longest provide the historical native baseline.
  Retain native completion; native automatic completion
  is also available on Neovim 0.12. No new completion setting selected here.
- mini.input replaces vim.ui.input handling with customizable non-blocking
  prompts. Seb uses defaults; old vimrc has no equivalent prompt UI plugin.
  Keep native prompts because no customization need is established.

Read all three complete upstream READMEs. Implementation remains pending.

## Accepted Neovim status display and notifications

Accepted on 2026-09-29: adopt mini.statusline,
mini.tabline, mini.icons, and mini.notify with Seb's setup and an explicit
ASCII icon option for clients without suitable font support.

- mini.statusline enhances the old native statusline (laststatus=2, ruler,
  showmode) with a mode indicator and integration with accepted mini.git/diff.
  Use Seb's default module configuration. Native statusline is an alternative.
- mini.tabline shows listed buffers across the top, with unique labels and
  separate tabpage information. Old vimrc has no buffer tabline plugin. This
  complements the accepted buffer picker; native tabpages represent window
  layouts rather than one tab per file. Use Seb's defaults.
- mini.icons supplies filetype/path and LSP-kind icons, including the accepted
  completion UI. Follow Seb's filetype detection preference for scm/txt/yml/
  json/yaml extensions and tweak_lsp_kind integration. Old vimrc has no icon
  provider. Glyph display needs Nerd Fonts v3-compatible client-side rendering;
  provide a manually selectable ASCII mode for remote clients where needed.
  Font choice and client configuration remain separate decisions; do not infer
  icon support merely from SSH environment detection.
- mini.notify shows vim.notify messages and LSP progress in Neovim floating
  windows, with accessible notification history. Old vimrc has no equivalent
  notification plugin. Use Seb's defaults; native messages remain an alternative.
  These are in-editor notifications, separate from accepted Fish done desktop
  notifications and their unresolved remote delivery behavior.

Read all four complete upstream READMEs. Implementation remains pending.

## Deferred Neovim startup, sessions, and visits

Decided on 2026-09-29: skip mini.starter, mini.sessions, and mini.visits for now.
Exclude all three from the initial setup.

- Use native startup without a dashboard or automatic file-browser opening.
  The accepted mini.files and file pickers remain available on demand, replacing
  the browsing/finding roles of old NERDTree, fzf.vim, and Command-T.
- Keep native session commands available without a session manager or automatic
  session saving/restoring. The accepted herdr choice is unaffected.
- Use native recent-file history and accepted pickers without mini.visits
  tracking, ranking, labels, or favorites.
- Omit Seb's session and visit/favorite mappings, visit-dependent pickers, and
  their clue groups. This narrows any earlier broad adoption of mini.extra
  picker mappings to those whose dependencies are selected.

Read all three complete upstream READMEs and the full mini.starter reference.
Implementation remains pending.

## Accepted Neovim visual helpers

Accepted on 2026-09-29: adopt all four: mini.cursorword, mini.hipatterns,
mini.trailspace with the Markdown adjustment below, and mini.map.

- mini.cursorword adds automatic word-under-cursor highlighting with Seb's
  default 100 ms delay. Complements old hlsearch and native word searches;
  it matches words rather than language-server symbol references.
- mini.hipatterns follows Seb's FIXME/HACK/TODO/NOTE highlighters (upper/title/
  lower-case variants) and hex-color previews. Extends old syntax highlighting;
  no dedicated equivalent plugin was in the old vimrc. Text patterns are not
  limited to comments. Native syntax/search is the simpler alternative.
- mini.trailspace adds visible trailing-whitespace highlighting and Seb's
  manual Space ot trim shortcut, complementing accepted hk/formatter checks.
  Do not add automatic trimming. Custom adaptation: disable this highlighting
  and prevent the generic trim shortcut in Markdown buffers, leaving Markdown
  cleanup to rumdl to preserve intentional hard breaks. Validate implementation
  of the shortcut guard separately from the module's highlighting disable flag.
- mini.map provides a buffer minimap with search/diff/diagnostic marks and
  navigation. Seb uses Space mt toggle, mf focus, mr refresh, ms switch side.
  Old vimrc had no minimap. Adopt Seb's toggleable setup, integrations, mappings,
  and refresh calls embedded in his search keys. It complements native scrolling,
  search, accepted pickers, and diff tools. Keep it on demand for narrow terminals.

Read all four complete upstream READMEs. Implementation remains pending.

## Accepted Neovim statuscolumn and deferred utility shortcuts

Updated on 2026-09-29: defer mini.bufremove because Seb's buffer close/delete
commands need new mappings; use native buffer commands. mini.misc zoom/resize
also needs new mappings and is deferred. mini.misc automatic root selection
was rejected; keep the launch directory. Adopt mini.statuscolumn with Seb's
default setup; it formats the existing gutter without adding mappings.
mini.keymap may support the familiar completion/pairing behavior already chosen,
subject to the initial setup policy above. The reviewed proposal follows for
reference; its shortcut choices are not authorized for initial implementation.

- mini.bufremove closes buffers while preserving window layout. Old vimrc had
  no dedicated buffer-removal helper; native bdelete/bwipeout are alternatives.
  Follow Seb's Space bd/bw delete/wipe mappings and bD/bW forced variants that
  discard unsaved edits. These remove editor buffers, not files on disk.
- mini.statuscolumn renders the gutter containing line numbers, signs, and
  folding information, following native options and dimming inactive windows.
  Extends old number/relativenumber display; separate from accepted statusline.
  Accepted on 2026-09-29; no new shortcut is needed.
- mini.misc supplies Seb's immediate/deferred setup helpers, automatic working
  directory selection, last-cursor-position restoration, and Space oz zoom /
  Space or resize. No dedicated old equivalent. Automatic directory changes
  affect relative paths, terminal launches, and directory-scoped pickers; verify
  root selection with local/remote projects during implementation. This cursor
  restoration does not enable deferred session management or visit tracking.
  Cursor restoration was accepted separately; automatic root selection was
  rejected. Adopt no other automatic directory/window functions.
- mini.keymap supplies the conditional Tab/Shift-Tab/Enter/Backspace mappings
  already selected with mini.completion/pairs. Complements old direct mappings
  with completion/pair-aware behavior. Follow Seb's four multistep mappings;
  do not enable unrelated combo or navigation features from upstream examples.

Read all four complete upstream READMEs. Implementation remains pending.
mini.basics, native options, theme, and remaining language support are still
separate review items; this batch does not approve copying options.lua wholesale.

## Accepted Neovim theme and configuration approach

Accepted on 2026-09-29:

- Adopt mini.hues with Seb's #282c34 background and #ffffff foreground seeds.
  Generates a consistent palette for native syntax/UI, diagnostics, and accepted
  mini.nvim modules. Old vimrc enables syntax highlighting and sets a column-80
  highlight but selects no named colorscheme. Native colorscheme is an alternative.
- Use opaque editor and popup backgrounds initially, unlike Seb's transparency.
  This is a readability recommendation across varied remote terminal backgrounds.
  Keep his thin single popup borders and unblended popup appearance, subject to
  compatible Neovim options. No interactive theme tools or new mappings.
- Skip mini.colors initially: Seb uses it to remove backgrounds for transparency,
  which the selected opaque theme does not require. Its other color-editing
  capabilities are not needed for this setup.
- Skip mini.basics as a preset bundle; choose explicit native settings instead.
  It combines option, mapping, and autocommand presets, and Seb enables additional
  window/Alt mappings. This follows the old vimrc's explicit configuration model
  and the new no-new-keybindings policy. The module can disable mappings, but
  direct settings make the selected behavior easier to review.

Read complete upstream READMEs for mini.hues, mini.colors, and mini.basics.
Native option choices (including recovery, search, folding, and Markdown behavior)
remain separate review items. Preserve previously accepted two-space indentation;
do not copy Seb's four-space defaults or his Markdown gO override.

## Accepted Neovim recovery, search, folding, and Markdown

Accepted on 2026-09-29:

- Retain native swapfile recovery (old vimrc did not disable it), instead of
  Seb's swapfile=false. Enable persistent undo (undofile) and Seb's confirm=true
  save/discard prompts. Undo history persists on file writes; it is not crash
  recovery. Keep generated state machine-local, outside tracked dotfiles.
- Retain old ignorecase/incsearch/hlsearch, add smartcase, and follow Seb's
  inccommand=split replacement preview. Uppercase in a typed search makes it
  case-sensitive; native word-search commands have documented exceptions.
  No search-key remapping. Manual case modifiers/native nosplit preview remain
  alternatives.
- Keep native manual folding initially. Defer Seb's Tree-sitter fold expression
  until parser/language review; do not enable automatic fold closing or add
  fold shortcuts. Old vimrc had no enabled global automatic folding setup.
  This does not reject future automatic syntax highlighting.
- Retain old nowrap for code; follow Seb's Markdown-only spell and visual wrap,
  with camel-case spell handling. Visual wrapping does not add file newlines;
  accepted rumdl formatting remains separate. Preserve native Markdown gO and
  native navigation. Keeping Markdown nowrap/spell off remains an alternative.

Read the complete upstream option-reference entries for swapfile, undofile,
ignorecase, smartcase, incsearch, hlsearch, inccommand, foldmethod, foldexpr,
foldlevel, foldtext, wrap, spell, spelloptions, and confirm. Other options and
automatic helpers remain separate review items. Implementation remains pending.

## Accepted Neovim cursor, directory, and display behavior

Accepted on 2026-09-29:

- Adopt mini.misc.setup_restore_cursor with its defaults: restore and center
  the last cursor position for recognized normal file buffers, excluding
  gitcommit/gitrebase. Uses native ShaDa file marks. Old vimrc had no explicit
  restore helper. No session manager, visit tracker, or new mapping is enabled.
- Skip mini.misc.setup_auto_root initially. Seb invokes it with default root
  markers .git/Makefile, changing current directory on buffer entry. Keep the
  launch directory unless explicitly changed, consistent with the old vimrc's
  lack of automatic directory switching. This keeps relative paths predictable
  when editing files from multiple projects. LSP root detection is separate.
- Retain old number+relativenumber and colorcolumn=80. Use the selected theme's
  guide highlight rather than copying old hardcoded ColorColumn colors.
- Retain showcmd=true from the old vimrc instead of Seb's showcmd=false.
- Adopt Seb's scrolloff=8 and sidescrolloff=8, compared with old scrolloff=3
  and no explicit horizontal margin. Keeping the old margins is an alternative.
- Enable cursorline with Seb's cursorlineopt=screenline,number to highlight the
  current screen row and line number; old vimrc had no explicit cursorline.

Read complete mini.misc reference entries for setup_restore_cursor,
setup_auto_root, and find_root; read complete native option entries for these
display settings. Other unselected utilities/options remain pending.

## Accepted Neovim syntax highlighting and diagnostics

Accepted on 2026-09-29:

- Adopt nvim-treesitter for parser installation/queries and native automatic
  Tree-sitter highlighting. Include Seb's go/python/rust/javascript/typescript/
  tsx plus bash, fish, lua, toml, json, yaml, markdown, and markdown_inline for
  this dotfiles setup. Include required query dependencies of selected parsers.
  This enhances old syntax-on highlighting and the syntax role of language
  plugins, but does not replace vim-go build/test tooling, Fireplace REPL
  integration, or Terraform formatting. Those remain separate reviews.
- Keep native manual folding and existing indentation policy; no Tree-sitter
  text-object mappings or experimental Tree-sitter indentation. Use conventional
  syntax for filetypes without selected parsers. Compile/install parsers during
  bootstrap and update them alongside reviewed plugin revisions. Validate a
  compatible Neovim/plugin/CLI/compiler combination on both architectures;
  upstream main currently documents 0.12+ (nightly), so do not silently switch
  the user to nightly. Honor upstream's no-lazy-loading requirement.
- Use native diagnostic signs and underlines. Adapt Seb's current-line-only
  inline messages to include warnings as well as errors (severity min=WARN),
  so warnings are readable without introducing a custom shortcut. Keep native
  update_in_insert=false and virtual_lines=false. Existing LSP selection is
  unchanged; parsers do not themselves provide LSP diagnostics or completion.
- Old vimrc used individual language plugins rather than a unified LSP display.
  Alternatives: conventional syntax highlighting alone; Seb's errors-only
  current-line messages or native signs/underlines without inline messages.

Read the full nvim-treesitter README and supported-language catalogue, plus
complete relevant native diagnostic configuration/severity/display references.
Implementation remains pending.

## Remaining review and implementation questions

Tombi, rumdl, targeted mise key sorting, and semantic Markdown line breaks are
accepted. Markdown editing and preview extension choices remain separate.

actionlint and zizmor are accepted. The old dotfiles have no .github directory.
The actual CI workflow design remains a separate decision; tool adoption does
not select Seb's release or image-publishing workflows.

hadolint and Trivy are accepted. Full image scans will not run on every commit.
Docker runtime selection, image creation, SBOM generation, and CI failure
thresholds remain separate decisions.

Pkl CLI, mise formatting, and hk-test are accepted. Validate the effective hk
configuration with hk validate during implementation. Keep mise and Tombi
formatting compatible; verify the installed versions and nested config coverage
before deployment. hk test runs step-defined tests, not a full machine bootstrap
test.

This list groups remaining work; it is not approval to adopt the tools listed.
Reconcile it against Seb's manifests and configuration files before declaring
the tool review complete.

## Accepted fnox and AI agent setup

Accepted on 2026-09-30: reverse the earlier fnox deferral and adopt Seb's fnox
tool/configuration pattern, including mise-managed fnox and age, an age
encryption provider, 1Password-backed personal/work profiles, and fnox MCP
integration for Codex and Claude Code. Follow Seb's MCP allowlist that exposes
`exec` only and excludes direct `get_secret` responses. Use the user's own age
identity, account/vault selections, and secret references; do not copy Seb's
private identity or personal identifiers. Linux access uses 1Password app and
CLI, without 1Password SSH agent or forwarding.

Adopt Seb's Codex and Claude Code configurations, Herdr session-state hooks,
shared Herdr skill, status-line setup, notifications, and app choices for
macOS (ChatGPT and Claude desktop apps). Manage the `codex` and `claude-code`
CLIs with mise. Omarchy-specific desktop package choices remain for the distro
review. Keep Vim-mode options disabled initially to honor the no-new-keybindings
policy; review those options again when ready to adopt new key behavior. The
old dotfiles had no comparable AI agent setup, so this adds new tools rather
than replacing old configuration.

Read the relevant fnox configuration, age, 1Password provider, and MCP
references. Codex/Claude settings and Herdr hook installation still need
implementation-time compatibility checks. No configurations have been written.

- Validate final hook composition, including the accepted global hygiene checks
- Additional runtimes and development tools from the old Brewfile
- Neovim plugins/configuration and VS Code extensions/settings
- Desktop applications, keyboard utilities, and macOS settings
- Personal/work profiles, machine identity, and distro-specific package choices
- mise configuration history, deployment layout, lockfiles, and bootstrap flow
- Old cloud/Kubernetes/Terraform/QMK tools and useful shell functions to retain
- Linux SSH keys and Git signing
- Validate done notifications in the intended desktop/remote sessions

## Accepted and deferred desktop app choices

Accepted on 2026-10-01:

- Already selected elsewhere: Ghostty, 1Password app/CLI, ChatGPT and Claude
  desktop apps on macOS. These are not new decisions in this batch.
- Defer Fastmail desktop app. The old setup had no mail client; its web
  interface remains an alternative.
- Defer Linear, which has no counterpart in the old Brewfile.
- Keep Notion, as in the old Brewfile; defer Obsidian, which would move notes
  into local Markdown vaults and change the workflow.
- Defer Spotify, which has no old Brewfile counterpart.
- Keep Firefox as the browser; defer Zen. The old Brewfile also listed Chrome.
- Adopt Fira Code Nerd Font for Ghostty on macOS and Linux. The old setup did
  not pin a font; this adds consistent terminal glyph coverage.
- Discord appears in the old Brewfile, so retain it if still used. Ghostty,
  1Password, ChatGPT, and Claude were already selected in earlier decisions.

Accepted macOS settings on 2026-10-01:

- Adopt Seb's Finder list view, show hidden files, path bar, and status bar.
- Adopt `press_and_hold = false`, disabling the accent popup so held keys
  repeat.
- Defer Seb's Dock recent-app visibility and Mission Control Space reordering
  settings.

Still deferred — keyboard utility:

- ZSA Keymapp: adds a ZSA-specific layout display and firmware utility. Your
  old setup instead had Karabiner-Elements and QMK CLI; Keymapp does not
  replace either for non-ZSA keyboards. Defer unless you have a ZSA keyboard.
  Preserve the current keyboard behavior and mappings.

Reviewed Seb's desktop package layers, macOS preferences, complete relevant
Fastmail/Obsidian/Notion/Zen/Keymapp/Karabiner/QMK references, and mise's full
macOS defaults guide. See documentation list below. App implementation and
remaining Keymapp decision remain pending; no packages or preferences have
been applied.

## Accepted Ghostty, Herdr, and Fish interaction settings

Accepted on 2026-10-14, with the user's requested Herdr prefix change. These
choices preserve familiar navigation and avoid introducing new keys for the
initial setup.

- Ghostty: use the already accepted Fira Code Nerd Font; defer Seb's opacity,
  macOS blur/titlebar, blinking-cursor, and mouse-hide appearance overrides
  until trying the defaults. Set `macos-option-as-alt=left` so left Option
  keeps the old iTerm2 Esc+ behavior used for direct Option+hjkl pane
  navigation, while right Option remains available for accented characters.
  Defer Seb's Ctrl+Shift+Space keymap and use Ghostty defaults; Herdr will
  provide the multiplexer interface. Linux blur is desktop-environment
  dependent, so do not make the cross-platform setup depend on it.
- Herdr: use Ctrl+A as the prefix, per the user's explicit choice; this differs
  from both Seb's Ctrl+Space and the familiar tmux Ctrl+B prefix. Preserve the
  old README's direct Alt/Option+h/j/k/l pane navigation and `prefix+d` detach
  behavior. The old Oh My Tmux configuration itself is not present here, so do
  not infer any custom secondary prefix from it. Validate Alt delivery through
  Ghostty, VS Code Remote terminals, and Guacamole.
  Adopt `theme="terminal"` and tmux-like no-gaps/no-outer-borders/no-scrollbar
  presentation. Retain confirmation and tab-name prompts; allow Herdr's first
  run onboarding. Defer Herdr toast delivery until the accepted `done`
  notifications are checked in local and remote sessions. Omit an explicit
  kitty-graphics setting because Seb's value matches Herdr's documented
  default.
- Fish: retain its default Emacs command-line mode, matching old interactive
  Zsh (the old vimrc does not indicate Vi-mode shell editing). Do not copy
  `fish_vi_key_bindings` or the block cursor. Adopt Seb's `MANPAGER` using
  already selected bat, and set `EDITOR`/`VISUAL` to the already selected
  Neovim. Previously accepted Fish aliases, plugins, and tool initializers
  remain in scope.

The old terminal apps were Alacritty and iTerm2; their terminal preferences
are not checked in. The old README documents Oh My Tmux and direct Option+hjkl
pane movement. Sources reviewed: [Ghostty configuration reference](https://ghostty.org/docs/config/reference),
[Ghostty keybindings](https://ghostty.org/docs/config/keybind),
[Ghostty key sequences](https://ghostty.org/docs/config/keybind/sequence),
[Herdr configuration reference](https://herdr.dev/docs/config-reference/),
[Herdr configuration](https://herdr.dev/docs/configuration/),
[Herdr keyboard reference](https://herdr.dev/docs/keyboard/), and
[Fish interactive use](https://fishshell.com/docs/current/interactive.html).
No runtime configuration has been written; these decisions are for the later
implementation phase.

## Proposed Go toolchain migration

Pending review on 2026-10-14. Seb does not declare Go or Go tools in his mise
manifests. Your old Brewfile does declare Go, the Go VS Code extension, and a
large set of Go utilities, including gopls and Delve. This would preserve your
old Go development capability while moving runtime management from Homebrew
to mise; it is not a copy of Seb's tool list.

- Adopt Go through mise as a runtime, with project `go.mod` versions taking
  precedence. The Go command can select a toolchain based on each module's
  `go`/`toolchain` directives, so avoid hard-coding a specific global version
  before reviewing active projects.
- Adopt `gopls` through mise for Neovim's already accepted native LSP setup.
  The old Brewfile already installed it, and the old VS Code Go extension is
  its editor counterpart. `gopls` is now the official Go language server and
  provides navigation, completion, diagnostics, and refactoring.
- Defer a global `dlv`/Delve install until the VS Code and Neovim debugger
  choices are reviewed. The old Brewfile installed Delve; the VS Code Go
  extension can manage debugger tooling, so a separate mise install may be
  redundant. Add it through mise if the chosen editors need the shared binary.
- Do not migrate the entire old Go utility list automatically. Start without
  the separate legacy tools `godef`, `gorename`, `guru`, `gotags`, `fillstruct`,
  `gomodifytags`, `impl`, `iferr`, `motion`, and `keyify`; review continuing
  needs for `goimports`, `golangci-lint`, `staticcheck`, `errcheck`, `golint`,
  and `asmfmt` with the Go editor/tooling setup. The old Brewfile is evidence
  these were installed, but not that they are still used.
- Defer Java/OpenJDK and Perl. Each appears only as a runtime package in the
  old Brewfile; no corresponding project or editor configuration was found.
  If an active project needs either, declare its runtime in that project's
  mise configuration instead of adding it globally by default.

Sources reviewed: [mise Go runtime reference](https://mise.jdx.dev/lang/go.html),
[mise Go tool backend](https://mise.jdx.dev/dev-tools/backends/go.html),
[Go toolchain selection](https://go.dev/doc/toolchain),
[Go language server documentation](https://go.dev/gopls/), and
[Delve debugger documentation](https://github.com/go-delve/delve).
Implementation remains pending.

## Accepted Docker image test workflow

Accepted on 2026-10-01:

- Retain Docker as a development tool. Your old Brewfiles include the Docker
  CLI, Docker Desktop, and cleanup helper; VS Code included Docker and Remote
  Containers extensions. Seb's Dockerfile is a separate test image for the
  dotfiles bootstrap, not a replacement runtime or a required part of normal
  host setup. Decide macOS and Linux runtime/package details in the later
  per-platform application review.
- Adopt a CI-only Arch Linux bootstrap smoke-test image modeled on Seb's
  `Dockerfile` and image job. It builds a non-root environment, applies mise
  bootstrap, then checks expected packages/files and that Fish starts. This
  complements the old `install-container.sh`/`Brewfile.container`, which
  installed the previous host setup but had no Dockerfile or image validation.
  Seb targets `linux/amd64`, matching the Omarchy VM; Apple Silicon can emulate
  amd64 locally, while the separate macOS CI job tests macOS directly.
- Keep Trivy image scanning on demand, as already selected; do not copy Seb's
  full HIGH/CRITICAL vulnerability, secret, and misconfiguration scan into
  every commit check. Hadolint remains the accepted Dockerfile linter.
- Defer the image SBOM artifact and GHCR release/publishing/attestation flow.
  Seb's release workflow is disabled, and the test image does not yet have a
  distribution use case. Revisit if you want a shareable prebuilt environment.

Read Docker's complete relevant Dockerfile/building best-practices,
multi-platform build, and build-attestation references. See documentation
list below. Implementation remains pending. No image publishing, SBOM
generation, or per-commit Trivy image scan is selected. Docker runtime/package
choices for macOS and Linux remain for the platform review.

## Execution checklist

- [ ] Complete the tool inventory and outstanding user choices
- [ ] Prepare a concrete implementation layout and migration plan
- [ ] Preserve access to the old files as reference throughout the rebuild
- [ ] Build the selected mise manifests and configuration files
- [ ] Validate hooks, formatter review behavior, and bootstrap configuration
- [ ] Review the resulting changes with the user before deployment
- [ ] Bootstrap and verify on Apple Silicon macOS and x86-64 Linux

## Documentation already used for the latest decisions

- [ShellCheck README](https://github.com/koalaman/shellcheck#readme)
- [shfmt manual](https://github.com/mvdan/sh/blob/master/cmd/shfmt/shfmt.1.scd)
- [Fish command reference](https://fishshell.com/docs/current/cmds/fish.html)
- [fish_indent reference](https://fishshell.com/docs/current/cmds/fish_indent.html)
- [EditorConfig overview](https://editorconfig.org/)
- [editorconfig-checker README](https://github.com/editorconfig-checker/editorconfig-checker#readme)
- [hk hooks reference](https://hk.jdx.dev/hooks.html)
- [Conventional Commits specification](https://www.conventionalcommits.org/en/v1.0.0/)
- [StyLua README and configuration reference](https://github.com/JohnnyMorganz/StyLua#readme)
- [Tombi documentation](https://tombi-toml.github.io/tombi/docs/)
- [Tombi formatter CLI](https://tombi-toml.github.io/tombi/docs/cli/formatter/)
- [Tombi linter CLI](https://tombi-toml.github.io/tombi/docs/cli/linter/)
- [Tombi VS Code extension](https://tombi-toml.github.io/tombi/docs/editors/vscode-extension/)
- [rumdl README](https://github.com/rvben/rumdl#readme)
- [Tombi auto sorting](https://tombi-toml.github.io/tombi/docs/formatter/auto-sorting/)
- [rumdl MD013 wrapping reference](https://github.com/rvben/rumdl/blob/main/docs/md013.md)
- [actionlint README](https://github.com/rhysd/actionlint#readme)
- [zizmor overview](https://docs.zizmor.sh/)
- [zizmor quickstart](https://docs.zizmor.sh/quickstart/)
- [Betterleaks README](https://github.com/betterleaks/betterleaks#readme)
- [Betterleaks scanning guide](https://github.com/betterleaks/betterleaks/blob/main/docs/scanning.md)
- [Hadolint README and configuration reference](https://github.com/hadolint/hadolint#readme)
- [Trivy README](https://github.com/aquasecurity/trivy#readme)
- [hk Pkl essentials](https://hk.jdx.dev/pkl_introduction.html)
- [hk builtins catalogue](https://hk.jdx.dev/builtins.html)
- [hk test reference](https://hk.jdx.dev/cli/test.html)
- [mise fmt reference](https://mise.jdx.dev/cli/fmt.html)
- [mise Node guide](https://mise.jdx.dev/lang/node.html)
- [mise Python guide](https://mise.jdx.dev/lang/python.html)
- [mise Rust guide](https://mise.jdx.dev/lang/rust.html)
- [fnox configuration reference](https://fnox.jdx.dev/reference/configuration.html)
- [fnox age provider](https://fnox.jdx.dev/providers/age)
- [fnox 1Password provider](https://fnox.jdx.dev/providers/1password.html)
- [fnox MCP server](https://fnox.jdx.dev/guide/mcp.html)
- [Dockerfile overview](https://docs.docker.com/build/concepts/dockerfile/)
- [Docker build best practices](https://docs.docker.com/build/building/best-practices/)
- [Docker multi-platform builds](https://docs.docker.com/build/building/multi-platform/)
- [Docker build attestations](https://docs.docker.com/build/metadata/attestations/)
- [Fastmail desktop app](https://www.fastmail.help/hc/en-us/articles/14026270682511-The-Fastmail-desktop-app)
- [Obsidian data storage](https://obsidian.md/help/data-storage)
- [Notion databases](https://www.notion.com/help/intro-to-databases)
- [Zen Browser user manual](https://docs.zen-browser.app/user-manual)
- [ZSA Keymapp overview](https://blog.zsa.io/keymapp/)
- [Karabiner-Elements features](https://karabiner-elements.pqrs.org/docs/getting-started/features/)
- [QMK CLI](https://docs.qmk.fm/cli)
- [mise macOS defaults](https://mise.jdx.dev/bootstrap/macos-defaults.html)
- [Bash language server README](https://github.com/bash-lsp/bash-language-server/blob/main/README.md)
- [Fish LSP README](https://github.com/ndonfris/fish-lsp/blob/master/README.md)
- [LuaLS README](https://github.com/LuaLS/lua-language-server/blob/master/README.md)
- [Marksman README](https://github.com/artempyanykh/marksman/blob/main/README.md)
- [Neovim package management reference](https://github.com/neovim/neovim/blob/master/runtime/doc/pack.txt)
- [lazy.nvim README](https://github.com/folke/lazy.nvim/blob/main/README.md)
- [nvim-lspconfig README](https://github.com/neovim/nvim-lspconfig/blob/master/README.md)
- [mini.files README](https://nvim-mini.org/mini.nvim/readmes/mini-files)
- [mini.pick README](https://nvim-mini.org/mini.nvim/readmes/mini-pick)
- [mini.extra README](https://nvim-mini.org/mini.nvim/readmes/mini-extra)
- [mini.git README](https://nvim-mini.org/mini.nvim/readmes/mini-git)
- [mini.diff README](https://nvim-mini.org/mini.nvim/readmes/mini-diff)
- [mini.completion README](https://nvim-mini.org/mini.nvim/readmes/mini-completion)
- [mini.snippets README](https://nvim-mini.org/mini.nvim/readmes/mini-snippets)
- [friendly-snippets README](https://github.com/rafamadriz/friendly-snippets/blob/main/README.md)
- [Conform README and API](https://github.com/stevearc/conform.nvim/blob/master/README.md)
- [mini.align README](https://nvim-mini.org/mini.nvim/readmes/mini-align)
- [mini.comment README](https://nvim-mini.org/mini.nvim/readmes/mini-comment)
- [mini.pairs README](https://nvim-mini.org/mini.nvim/readmes/mini-pairs)
- [mini.surround README](https://nvim-mini.org/mini.nvim/readmes/mini-surround)
- [mini.ai README](https://nvim-mini.org/mini.nvim/readmes/mini-ai)
- [mini.move README](https://nvim-mini.org/mini.nvim/readmes/mini-move)
- [mini.jump README](https://nvim-mini.org/mini.nvim/readmes/mini-jump)
- [mini.jump2d README](https://nvim-mini.org/mini.nvim/readmes/mini-jump2d)
- [mini.indentscope README](https://nvim-mini.org/mini.nvim/readmes/mini-indentscope)
- [mini.bracketed README](https://nvim-mini.org/mini.nvim/readmes/mini-bracketed)
- [mini.operators README](https://nvim-mini.org/mini.nvim/readmes/mini-operators)
- [mini.splitjoin README](https://nvim-mini.org/mini.nvim/readmes/mini-splitjoin)
- [mini.clue README](https://nvim-mini.org/mini.nvim/readmes/mini-clue)
- [mini.cmdline README](https://nvim-mini.org/mini.nvim/readmes/mini-cmdline)
- [mini.input README](https://nvim-mini.org/mini.nvim/readmes/mini-input)
- [mini.statusline README](https://nvim-mini.org/mini.nvim/readmes/mini-statusline)
- [mini.tabline README](https://nvim-mini.org/mini.nvim/readmes/mini-tabline)
- [mini.icons README](https://nvim-mini.org/mini.nvim/readmes/mini-icons)
- [mini.notify README](https://nvim-mini.org/mini.nvim/readmes/mini-notify)
- [mini.starter README](https://nvim-mini.org/mini.nvim/readmes/mini-starter)
- [mini.starter reference](https://nvim-mini.org/mini.nvim/doc/mini-starter)
- [mini.sessions README](https://nvim-mini.org/mini.nvim/readmes/mini-sessions)
- [mini.visits README](https://nvim-mini.org/mini.nvim/readmes/mini-visits)
- [mini.cursorword README](https://nvim-mini.org/mini.nvim/readmes/mini-cursorword)
- [mini.hipatterns README](https://nvim-mini.org/mini.nvim/readmes/mini-hipatterns)
- [mini.map README](https://nvim-mini.org/mini.nvim/readmes/mini-map)
- [mini.trailspace README](https://nvim-mini.org/mini.nvim/readmes/mini-trailspace)
- [mini.bufremove README](https://nvim-mini.org/mini.nvim/readmes/mini-bufremove)
- [mini.statuscolumn README](https://nvim-mini.org/mini.nvim/readmes/mini-statuscolumn)
- [mini.misc README](https://nvim-mini.org/mini.nvim/readmes/mini-misc)
- [mini.keymap README](https://nvim-mini.org/mini.nvim/readmes/mini-keymap)
- [mini.hues README](https://nvim-mini.org/mini.nvim/readmes/mini-hues)
- [mini.colors README](https://nvim-mini.org/mini.nvim/readmes/mini-colors)
- [mini.basics README](https://nvim-mini.org/mini.nvim/readmes/mini-basics)
- [Neovim native option reference](https://neovim.io/doc/user/options/)
- [mini.misc function reference](https://nvim-mini.org/mini.nvim/doc/mini-misc)
- [Tree-sitter supported languages](https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md)
- [Neovim diagnostic configuration](https://neovim.io/doc/user/diagnostic/)
- [Fugitive README](https://github.com/tpope/vim-fugitive/blob/master/README.markdown)
- [jq README](https://github.com/jqlang/jq/blob/master/README.md)
- [Mike Farah yq README](https://github.com/mikefarah/yq/blob/master/README.md)
- [Homebrew yq formula](https://formulae.brew.sh/formula/yq)
- [Alternative Python yq README](https://github.com/kislyuk/yq/blob/main/README.rst)
- [rustup components](https://rust-lang.github.io/rustup/concepts/components.html)
- [CMake README](https://github.com/Kitware/CMake/blob/master/README.rst)
- [Tree-sitter CLI README](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md)
- [nvim-treesitter README](https://github.com/nvim-treesitter/nvim-treesitter/blob/main/README.md)
- [uv overview](https://docs.astral.sh/uv/)
- [uv project guide](https://docs.astral.sh/uv/guides/projects/)
- [hk large-file check](https://hk.jdx.dev/cli/util/check-added-large-files.html)
- [hk case-conflict check](https://hk.jdx.dev/cli/util/check-case-conflict.html)
- [hk executable shebang check](https://hk.jdx.dev/cli/util/check-executables-have-shebangs.html)
- [hk merge-conflict check](https://hk.jdx.dev/cli/util/check-merge-conflict.html)
- [hk symlink check](https://hk.jdx.dev/cli/util/check-symlinks.html)
- [hk private-key check](https://hk.jdx.dev/cli/util/detect-private-key.html)
- [hk BOM check](https://hk.jdx.dev/cli/util/check-byte-order-marker.html)
- [hk BOM fixer](https://hk.jdx.dev/cli/util/fix-byte-order-marker.html)
- [hk smart quote fixer](https://hk.jdx.dev/cli/util/fix-smart-quotes.html)
- [hk line-ending check](https://hk.jdx.dev/cli/util/mixed-line-ending.html)
- [hk final-newline fixer](https://hk.jdx.dev/cli/util/end-of-file-fixer.html)
- [hk trailing-whitespace fixer](https://hk.jdx.dev/cli/util/trailing-whitespace.html)

Documentation research so far has covered complete relevant pages and READMEs,
not every page of each project's documentation site. Read further references
as needed for the remaining choices and implementation.
