# systemd-syntax.nvim

Systemd syntax highlighting for Neovim.

## Installation

Use your favorite plugin manager to install:

### Using Packer
```lua
use 'chrisgeo/systemd-syntax.nvim'
```
### vim-plug
```viml
Plug 'chrisgeo/systemd-syntax.nvim'
```
### LazyVim
```lua
{
  "chrisgeo/systemd-syntax.nvim",
  config = function()
    require('systemd')
  end
}
```

## Usage

The syntax highlighting will be automatically applied to systemd unit files.

