<h1 align="center">MyNvim</h1>

<p align="center">
Neovim configuration for myself / yourself.
</p>

# Features

- Basic structure from [NvChad](https://github.com/NvChad/NvChad)
- File explorer with [Nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)
- Outline explorer with [Aerial](https://github.com/stevearc/aerial.nvim)
- Autocompletion with [Cmp](https://github.com/hrsh7th/nvim-cmp)
- Git integration with [Gitsigns](https://github.com/lewis6991/gitsigns.nvim)
- Terminal with [Toggleterm](https://github.com/akinsho/toggleterm.nvim)
- Fuzzy finding with [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- Syntax highlighting with [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- Language Server Protocol with [Native LSP](https://github.com/neovim/nvim-lspconfig)

# Pre-requisites
- [Nerd Fonts](https://www.nerdfonts.com/font-downloads)
- [Neovim 0.9.5+](https://github.com/neovim/neovim/releases/tag/stable)
- [Tree-sitter CLI](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md)
- A clipboard tool is necessary for the integration with the system clipboard
- Optional Requirements:
  - [fd](https://github.com/sharkdp/fd) Telescope find file (`<leader>`ff)
  - [ripgrep](https://github.com/BurntSushi/ripgrep) Telescope live grep (`<leader>`fw)

# Install

## Linux / Macos (unix)

```shell
git clone https://github.com/kenhuidotme/MyNvim ~/.config/nvim && nvim
```

## Windows CMD

```shell
git clone https://github.com/kenhuidotme/MyNvim %USERPROFILE%\AppData\Local\nvim && nvim

```
## Window PowerShell

```shell
git clone https://github.com/kenhuidotme/MyNvim $ENV:USERPROFILE\AppData\Local\nvim && nvim
```

# Uninstall

## Linux / Macos (unix)

```shell
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
```

## Windows CMD

```shell
rd -r ~\AppData\Local\nvim
rd -r ~\AppData\Local\nvim-data
```

## Window PowerShell

```shell
rm -Force ~\AppData\Local\nvim
rm -Force ~\AppData\Local\nvim-data
```

# Mappings

## Common

| Key | Description |
| --- | --- |
| C-s | Save file |
| C-c | Copy selected text to clipboard |
| C-v | Paste text from clipboard in insert mode |
| `<leader>`n | Toggle line number |
| `<leader>`rn | Toggle relative number |
| `<leader>`/ | Toggle comment |
| `<leader>`th | Select themes |

## Buffer

| Key | Description |
| --- | --- |
| < | Buffer prev |
| > | Buffer next |
| _ | Buffer move left |
| + | Buffer move right |
| S-b | Buffer new |
| S-c | Buffer close |

## Tab

| Key | Description |
| --- | --- |
| S-t | Tab new |
| S-q | Tab close |
| } | Tab next |
| { | Tab prev |

## Window

| Key | Description |
| --- | --- |
| C-x | Window horizontal split |
| C-y | Window vertical split |
| C-k | Window jump up |
| C-j | Window jump down |
| C-h | Window jump left |
| C-l | Window jump right |
| C-Up | Window height +1 |
| C-Down | Window height -1 |
| C-Left | Window width +1 |
| C-Right | Window width -1 |
| C-q | Window close |

## Terminal

| Key | Description |
| --- | --- |
| C-t | Toggle terminal |
| C-f | Toggle terminal float |
| C-d | Terminal mode escape |

## Nvim-tree

| Key | Description |
| --- | --- |
| C-e | Nvim-tree toggle |
| C-b | Nvim-tree file current buffer |
| C-x | Nvim-tree open: horizontal split |
| C-y | Nvim-tree open: vertical split |
| g? | Nvim-tree help |
| = | Nvim-tree CD: change root to selected directory |
| - | Nvim-tree CD: change root to parent |
| P | Nvim-tree goto: parent directory |
| < | Nvim-tree goto: previous sibling |
| > | Nvim-tree goto: next sibling |
| i | Nvim-tree info |
| H | Nvim-tree toggle filter: dot files |
| c | Nvim-tree copy |
| d | Nvim-tree delete |
| o | Nvim-tree open |
| p | Nvim-tree paste |
| r | Nvim-tree rename |
| x | Nvim-tree cut |
| f | Nvim-tree live filter: start |
| F | Nvim-tree live filter: clear |

## Aerial

| Key | Description |
| --- | --- |
| C-\ | Aerial toggle |
| C-[ | Aerial jump backwards |
| C-] | Aerial jump forwards |

## Lsp

| Key | Description |
| --- | --- |
| gh | LSP hover |
| gd | LSP definition |
| gD | LSP declaration |
| gt | LSP type definition |
| gi | LSP implementation |
| gr | LSP references |
| gs | LSP signature |
| `<leader>`dt | LSP Toggle diagnostics |
| `<leader>`dn | LSP diagnostic next |
| `<leader>`dp | LSP diagnostic prev |
| `<leader>`dl | LSP diagnostic list |
| `<leader>`db | LSP diagnostic for current buffer |
| `<leader>`da | LSP diagnostic for all open buffers |
| `<leader>`ra | LSP rename |
| `<leader>`fm | LSP formatting |
| `<leader>`ca | LSP code action |
| `<leader>`wl | LSP workspace list |
| `<leader>`wa | LSP workspace add |
| `<leader>`wr | LSP workspace remove |

## Telescope

| Key | Description |
| --- | --- |
| `<leader>`fe | Telescope file explorer |
| `<leader>`fb | Telescope file explorer, focus current buffer |
| `<leader>`ff | Telescope find files |
| `<leader>`fa | Telescope find all |
| `<leader>`fo | Telescope find old files |
| `<leader>`fb | Telescope find buffers |
| `<leader>`fh | Telescope find help page |
| `<leader>`fw | Telescope live grep |
| `<leader>`fz | Telescope fuzzy find in current buffer |

## Git

| Key | Description |
| --- | --- |
| `<leader>`st | Git status |
| `<leader>`cm | Git commits |
| `<leader>`hn | Git next hunk |
| `<leader>`hp | Git prev hunk |
| `<leader>`hr | Git hunk reset |
| `<leader>`hv | Git hunk preview |
| `<leader>`hb | Git hunk blame |
| `<leader>`hd | Git hunk deleted |
