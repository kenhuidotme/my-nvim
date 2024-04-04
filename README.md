Neovim configuration for myself, base on [NvChad](https://github.com/NvChad/NvChad).

# Install

```jsx
git clone https://github.com/kenhuidotme/MyNvim ~/.config/nvim --depth 1 && nvim
```

# Reset

```jsx
rm -rf ~/.local/share/nvim
```

# Mappings

## Common

| Key | Description |
| --- | --- |
| <leader>n | Toggle line number |
| <leader>rn | Toggle relative number |
| <leader>/ | Toggle comment |
| <leader>th | Select themes |

## Buffer

| Key | Description |
| --- | --- |
| < | Buffer prev |
| > | Buffer next |
| _ | Buffer move left |
| + | Buffer move right |
| S-b | Buffer new |
| S-c | Buffer close |

## Window

| Key | Description |
| --- | --- |
| C-x | Window split |
| C-y | Window vertical split |
| C-k | Window jump up |
| C-j | Window jump down |
| C-h | Window jump left |
| C-l | Window jump right |
| C-Up | Window height +1 |
| C-Down | Window height -1 |
| C-Left | Window width +1 |
| C-Right | Window width -1 |
| C-c | Window close |

## Tab

| Key | Description |
| --- | --- |
| C-] | Tab next |
| C-[ | Tab prev |
| Tab | Tab new |
| S-Tab | Tab close |

## Terminal

| Key | Description |
| --- | --- |
| C-t | Terminal new |
| C-q | Terminal escape |

## Nvim-tree

| Key | Description |
| --- | --- |
| C-e | Nvim-tree toggle |
| C-f | Nvim-tree Focus |
| C-x | Nvim-tree open: horizontal split |
| C-y | Nvim-tree open: vertical split |
| C-i | Nvim-tree help |
| = | Nvim-tree CD: change root to selected directory |
| - | Nvim-tree CD: change root to parent |
| P | Nvim-tree goto: parent directory |
| < | Nvim-tree goto: previous sibling |
| > | Nvim-tree goto: next sibling |
| i | Nvim-tree info |
| H | Nvim-tree toggle filter: dotfiles |
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
| K | LSP hover |
| gD | LSP declaration |
| gT | LSP type definition |
| gd | LSP definition |
| gi | LSP implementation |
| gr | LSP references |
| <leader>ls | LSP signature |
| <leader>ra | LSP rename |
| <leader>fm | LSP formatting |
| <leader>ca | LSP code action |
| <leader>df | LSP diagnostic floating |
| <leader>dp | LSP diagnostic prev |
| <leader>dn | LSP diagnostic next |
| <leader>dl | LSP diagnostic list |
| <leader>wl | LSP workspace list |
| <leader>wa | LSP workspace add |
| <leader>wr | LSP workspace remove |

## Telescope

| Key | Description |
| --- | --- |
| <leader>ff | Telescope find files |
| <leader>fa | Telescope find all |
| <leader>fo | Telescope find old files |
| <leader>fb | Telescope find buffers |
| <leader>fh | Telescope find Help page |
| <leader>fw | Telescope live grep |
| <leader>fz | Telescope fuzzy find in current buffer |

## Git

| Key | Description |
| --- | --- |
| <leader>cm | Git commits |
| <leader>gs | Git status |
| <leader>hn | Git next hunk |
| <leader>hp | Git prev hunk |
| <leader>hr | Git hunk reset |
| <leader>hs | Git hunk preview |
| <leader>hb | Git hunk blame |
| <leader>hd | Git hunk deleted |
