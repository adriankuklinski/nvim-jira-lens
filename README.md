# 🧐 nvim-jira-lens

Unveil your Jira issues right within Neovim! `nvim-jira-lens` is a Neovim plugin that brings your Jira issues closer to your code, allowing you to view and manage them without having to leave your favorite editor.

## 🚀 Features
- Fetch and display your Jira issues in a neat Telescope picker.
- Search and filter through your issues with ease.
- Preview issue descriptions right within the picker.

## 🛠️ Installation
Install the plugin using your favorite plugin manager. For example, using vim-plug:
### [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'adriankuklinski/nvim-jira-lens'
```
### [packer](https://github.com/wbthomason/packer.nvim)
```vim
use 'adriankuklinski/nvim-jira-lens'
```

## ⚙️️  Configuration
Setting up nvim-jira-lens is a breeze. Just add the following to your Neovim configuration:
```lua
require'nvim-jira-lens'.setup({
    username = "",
    password = "",
    base_url = ""
})

vim.cmd [[command! ShowIssues lua require('nvim-jira-lens.ui').show_issues()]]
vim.keymap.set('n', '<leader>ji', ':ShowIssues<CR>', { noremap = true, silent = true })
```

## 📈 Usage
- Launch the Jira issue picker with `:ShowIssues` or the default key mapping `<leader>ji`.
- Browse through your issues, and hit Enter to view a detailed preview.
- Use the Telescope picker to filter and search for specific issues.

## 📝 To Do
 - [ ] Checkout Git branches associated with Jira issues.
 - [ ] Navigate to the corresponding PRs of Jira issues.

## 🙏 Acknowledgements
This plugin was built with the help of the awesome [Telescope](https://github.com/nvim-telescope/telescope.nvim) plugin.

## 🤝 Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

