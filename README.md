Neovim configuration for myself, base on [NvChad](https://github.com/NvChad/NvChad).

# Pre-requisites

* [Neovim 0.9.5](https://github.com/neovim/neovim/releases/tag/v0.9.5).
* [Nerd Font](https://www.nerdfonts.com/) as your terminal font.

# Install

```shell
git clone https://github.com/kenhuidotme/MyNvim ~/.config/nvim --depth 1 && nvim
```

# Uninstall

```shell
# Linux / Macos (unix)
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim

# Windows CMD
rd -r ~\AppData\Local\nvim
rd -r ~\AppData\Local\nvim-data

# Window PowerShell
rm -Force ~\AppData\Local\nvim
rm -Force ~\AppData\Local\nvim-data
```

# Mappings

## Common

| Key | Description |
| --- | --- |
| <C-s> | Save file |
| <C-c> | Copy selected text to clipboard |
| <C-v> | Paste text from clipboard in insert mode |
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
| C-\ | Toggle terminal float |
| C-q | Terminal mode escape |

## Nvim-tree

| Key | Description |
| --- | --- |
| C-e | Nvim-tree toggle |
| C-f | Nvim-tree Focus |
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
| gf | LSP diagnostic floating |
| gn | LSP diagnostic next |
| gp | LSP diagnostic prev |
| gl | LSP diagnostic list |
| `<leader>`ra | LSP rename |
| `<leader>`fm | LSP formatting |
| `<leader>`ca | LSP code action |
| `<leader>`wl | LSP workspace list |
| `<leader>`wa | LSP workspace add |
| `<leader>`wr | LSP workspace remove |

## Telescope

| Key | Description |
| --- | --- |
| `<leader>`ff | Telescope find files |
| `<leader>`fa | Telescope find all |
| `<leader>`fo | Telescope find old files |
| `<leader>`fb | Telescope find buffers |
| `<leader>`fh | Telescope find Help page |
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
