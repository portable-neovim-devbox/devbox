# Portable Neovim DevBox

<p align="center">
  <img src="devbox.png" alt="DevBox logo" width="120">
</p>

A fully configured, portable Docker container with Neovim, Tmux, and modern CLI tools for developers.

## 1. 🚀 Overview

This repository provides a **fully configured Docker container** for a portable Neovim-based development environment. Whether you're setting up a new machine or working across multiple systems, this container ensures consistency and includes all the essential tools and configurations you need to be productive immediately.

### 1.1. Key Benefits

- 🔄 Reproducible Neovim environment across any machine
- 📦 No local system pollution - everything runs in Docker
- 🚀 Quick setup - get coding in minutes
- 🛠️ Pre-configured with modern development tools

## 2. 👥 Who This Is For

### 2.1. ✅ Ideal For

- **Neovim enthusiasts** who want a consistent setup across multiple machines
- **Developers** working on different computers (work, home, servers)
- **Team leads** who want to standardize development environments
- **Students/Learners** exploring modern CLI-based development workflows
- **Remote developers** needing quick, reproducible environment setup
- **Terminal lovers** who prefer keyboard-driven workflows

### 2.2. ⚠️ May Not Be Ideal For

- Beginners completely new to terminal/command-line interfaces
- Developers who prefer GUI-based IDEs (VS Code, IntelliJ, etc.)
- Teams requiring specific IDE integrations not available in Neovim

### 2.3. 📚 Recommended Background

- Basic understanding of:
  - Command-line navigation (`cd`, `ls`, `mkdir`, ...)
  - Text editing concepts (insert mode, normal mode)
  - Git basics (clone, commit, push)
  - Docker fundamentals (images, containers, docker-compose)
- Willingness to learn Neovim keybindings and modal editing

## 3. ✨ Features

### 3.1. Neovim (Editor)

Pre-configured Neovim with [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager and the following plugins:

| Plugin                                                                | Description                            |
| :-------------------------------------------------------------------- | :------------------------------------- |
| [catppuccin](https://github.com/catppuccin/nvim)                      | Color scheme                           |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)            | Language Server Protocol configuration |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)          | Status line                            |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)       | File explorer                          |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)    | Fuzzy finder                           |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Advanced syntax highlighting           |

See more about Neovim in [Repository of Neovim](https://github.com/neovim/neovim).

### 3.2. Starship (Modern Prompt)

Starship prompt showing git status, language versions, execution time, and more at a glance.
The default configuration is based on [Gruvbox Rainbow Preset](https://starship.rs/presets/gruvbox-rainbow).
You can customize it in `dotfiles/starship/starship.toml`.
See more about Starship in [Repository of Starship](https://github.com/starship/starship).

#### 3.2.1. Nerd Fonts (Recommended)

For optimal display, install a [Nerd Font](https://github.com/ryanoasis/nerd-fonts/) on your **host machine**. Recommended fonts:

- [JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono) (recommended)
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts/) — browse all available fonts
- [Moralerspace HWJP DOC](https://github.com/yuru7/moralerspace)

### 3.3. Tmux (Terminal Multiplexer)

Tmux for managing multiple terminal sessions, split panes, and persistent sessions that survive disconnections.
See more about Tmux in [Repository of Tmux](https://github.com/tmux/tmux).

## 4. 📋 Prerequisites

### 4.1. Required Software

- Docker Engine 29.1.2 or later (`stable` version recommended)
- Docker Compose v2.40.3 or later (`stable` version recommended)

### 4.2. Recommended

- Basic familiarity with Docker commands
- Terminal/command-line experience
- A Nerd Font installed on your host system for optimal display

### 4.3. Supported Platforms

- Linux (with Docker Engine)
- macOS 11+ (with Docker Desktop)

## 5. 🔧 Installation

### 5.1. Get the Repository

#### 5.1.1. Method 1 : Quick Installation (No Customization Needed)

If you just want to use the pre-configured environment without modifications:

1. Go to the repository page <https://github.com/Xinor-a/portable-neovim-devbox>.
2. Click on the green "Code" button and select "Download ZIP".
3. Extract the downloaded ZIP file anywhere you want to locate.

#### 5.1.2. Method 2 : Customization or Contribution

If you also want to customize configurations or contribute to the project:

1. Ensure you have Git installed on your machine.
2. Open your terminal and run the following command to clone the repository:

  ```bash
  git clone https://github.com/Xinor-a/portable-neovim-devbox.git
  ```

  or

  ```bash
  git clone git@github.com:Xinor-a/portable-neovim-devbox.git
  ```

3. Navigate into the cloned directory:

  ```bash
  cd portable-neovim-devbox
  ```

## 6. 📖 Usage

### 6.1. Initial Setup

Run the interactive setup script from the repository root:

```bash
bash setup.sh
```

The script prompts for the following settings and writes them to `.env`:

| Prompt        | Description                                                     | Default   |
| :------------ | :-------------------------------------------------------------- | :-------- |
| Neovim version | Version to install (`"stable"` or a tag like `"v0.9.8"`)      | `stable`  |
| Username      | Main user name inside the container                             | `user`    |
| LANG          | Locale for the container. Leave empty to inherit from the host. | *(empty)* |
| HTTP_PROXY    | HTTP proxy URL. Leave empty if not needed.                      | *(empty)* |
| HTTPS_PROXY   | HTTPS proxy URL. Leave empty if not needed.                     | *(empty)* |
| NO_PROXY      | Hosts to bypass the proxy. Leave empty if not needed.           | *(empty)* |

At the end, you will be asked whether to build the Docker image immediately. If you choose `n`, build it later with:

```bash
docker compose build
```

### 6.2. Run DevBox Container

Run the container with:

```bash
bash run-devbox.sh /path/to/project
```

Replace `/path/to/project` with the absolute path to the project you want to work on. If you omit the path, the current directory will be used.

This script checks for the required Docker volumes, creates them if they don't exist, detects the container username, and runs the devbox container with the specified project directory mounted.

### 6.3. Create a Convenient Alias

Also add the following to your `~/.bashrc` or `~/.zshrc` to create a convenient `devbox` alias for launching the container from any directory:

```bash
export DEVBOX_PATH="/path/to/devbox"
alias devbox='bash "$DEVBOX_PATH/run-devbox.sh"'
export LANG=ja_JP.UTF-8  # optional: set your preferred locale
```

## 7. 📁 Project Structure

### 7.1. Directory Architecture

```plaintext
ProjectRoot/
├── .env                        # Environment variables for Docker build
├── devbox.ico                  # DevBox icon
├── docker-compose.yml          # Docker Compose service definition
├── dockerfile                  # Docker image build configuration
├── storage.dockerfile          # Storage container image build configuration
├── LICENSE                     # MIT License
├── README.md                   # This file
├── dotfiles/                   # Configuration files for tools in the container
│   ├── git/
│   │   ├── .gitattributes      # Git attributes
│   │   └── .gitconfig          # Git global configuration
│   ├── nvim/                   # Neovim configuration
│   │   ├── init.lua            # Main Neovim initialization
│   │   ├── lazy-lock.json      # Plugin version lock file
│   │   ├── lsp/                # LSP server configurations
│   │   │   └── lua-ls.lua
│   │   └── lua/
│   │       ├── myluamodule.lua
│   │       └── config/
│   │           ├── clipboard.lua
│   │           ├── keymaps.lua
│   │           ├── lazy.lua    # Lazy plugin manager setup
│   │           └── plugins/
│   │               └── define/ # Plugin definitions
│   │                   ├── catppuccin.lua
│   │                   ├── lsp-config.lua
│   │                   ├── lualine.lua
│   │                   ├── neotree.lua
│   │                   ├── telescope.lua
│   │                   └── treesitter.lua
│   ├── starship/
│   │   └── starship.toml       # Starship prompt configuration
│   └── tmux/
│       └── .tmux.conf          # Tmux configuration
└── scripts/
     ├── init/                   # Build-time installation scripts
     │   ├── init.sh             # Main init script (installs dev tools)
     │   ├── 1-0_Git/
     │   │   └── init.sh
     │   ├── 1-1_OpenSsh/
     │   │   └── init.sh
     │   ├── 1-2_Neovim/
     │   │   └── init.sh
     │   ├── 1-3_Starship/
     │   │   └── init.sh
     │   └── 1-4_Tmux/
     │       └── init.sh
     └── entrypoint/             # Runtime container entry scripts
         ├── entrypoint.sh       # Main entrypoint
         ├── 1-0_Git/
         │   └── subentry.sh
         ├── 1-1_OpenSsh/
         │   └── subentry.sh
         ├── 1-2_Neovim/
         │   └── subentry.sh
         ├── 1-3_Starship/
         │   └── subentry.sh
         └── 1-4_Tmux/
             └── subentry.sh
```

### 7.2. Configuration Files

#### 7.2.1. `dotfiles/`

| File                              | Description                                                |
| :-------------------------------- | :--------------------------------------------------------- |
| `git/.gitconfig`                  | Git global configuration                                   |
| `git/.gitattributes`              | Git attributes                                             |
| `nvim/init.lua`                   | Neovim main initialization file                            |
| `nvim/lua/config/lazy.lua`        | Lazy.nvim plugin manager setup                             |
| `nvim/lua/config/keymaps.lua`     | Neovim key mappings                                        |
| `nvim/lua/config/clipboard.lua`   | Clipboard integration configuration                        |
| `nvim/lua/config/plugins/define/` | Individual plugin definition files                         |
| `nvim/lsp/lua-ls.lua`             | Lua Language Server configuration                          |
| `starship/starship.toml`          | Starship prompt configuration                              |
| `tmux/.tmux.conf`                 | Tmux configuration                                         |

### 7.3. Scripts

#### 7.3.1. `scripts/init/` (Build-time)

| File                   | Description                                               |
| :--------------------- | :-------------------------------------------------------- |
| `init.sh`              | Main init script; installs dev tools and runs sub-scripts |
| `1-0_Git/init.sh`      | Installs the latest Git                                   |
| `1-1_OpenSsh/init.sh`  | Installs the OpenSSH client                               |
| `1-2_Neovim/init.sh`   | Installs Neovim, Node.js, npm, and tree-sitter CLI        |
| `1-3_Starship/init.sh` | Installs the latest Starship                              |
| `1-4_Tmux/init.sh`     | Installs the latest Tmux                                  |

#### 7.3.2. `scripts/entrypoint/` (Runtime)

| File                       | Description                                                     |
| :------------------------- | :-------------------------------------------------------------- |
| `entrypoint.sh`            | Main entrypoint; sets up bash, permissions, and starts services |
| `1-0_Git/subentry.sh`      | Git runtime configuration                                       |
| `1-1_OpenSsh/subentry.sh`  | OpenSSH client runtime setup                                    |
| `1-2_Neovim/subentry.sh`   | Neovim runtime setup                                            |
| `1-3_Starship/subentry.sh` | Starship runtime setup                                          |
| `1-4_Tmux/subentry.sh`     | Tmux runtime setup                                              |

#### 7.3.3. Host Launch Scripts

| File            | Description                          |
| :-------------- | :----------------------------------- |
| `run-devbox.sh` | Bash launch script for Linux / macOS |

### 7.4. Docker Volumes

All volumes are managed by the `devbox-storage` data-only container and shared with devbox containers via `--volumes-from`.

| Volume              | Mount Path                       | Description                       |
| :------------------ | :------------------------------- | :-------------------------------- |
| `devbox-data`       | `/etc/devbox/`                   | DevBox configuration data         |
| `root-dotssh`       | `/root/.ssh`                     | Root user SSH configuration       |
| `user-dotssh`       | `/home/<user>/.ssh`              | Container user SSH configuration  |
| `nvim-plugin-cache` | `/etc/nvim/lazy/`                | Neovim plugin cache (lazy.nvim)   |
| `root-nvim-plugin`  | `/root/.local/share/nvim`        | Root user Neovim plugin data      |
| `user-nvim-plugin`  | `/home/<user>/.local/share/nvim` | Container user Neovim plugin data |

## 8. 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 9. 📄 License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/Xinor-a/portable-neovim-devbox/blob/main/LICENSE) file for details.
