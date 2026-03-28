# Portable Neovim DevBox

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
- Users who need Windows-native development tools (WSL may help them)
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
The default configuration is based on [Gruvbox Rainbow Preset](https://starship.rs/ja-JP/presets/gruvbox-rainbow).
You can customize it in `dotfiles/starship/starship.toml`.
See more about Starship in [Repository of Starship](https://github.com/starship/starship).

#### 3.2.1. Nerd Fonts (Recommended)

For optimal display, install a [Nerd Font](https://github.com/ryanoasis/nerd-fonts/) on your **host machine**. Recommended fonts:

- [JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/)
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
- Windows 10/11 (with Docker Desktop)

## 5. 🔧 Installation

### 5.1. Install from the Repository

#### 5.1.1. Quick Start (No Customization Needed)

If you just want to use the pre-configured environment without modifications:

1. Go to the repository page <https://github.com/Xinor-a/portable-neovim-devbox>.
2. Click on the green "Code" button and select "Download ZIP".
3. Extract the downloaded ZIP file anywhere you want to locate.

#### 5.1.2. Customization or Contribution

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

### 5.2. Configure Environment Variables

Edit the `.env` file in the project root to match your setup. This file is used in two ways:

- **Build time** — `docker compose build` reads `.env` automatically and passes the values as build arguments. `NEOVIM_VERSION`, `USER_NAME`, `HOST_OS` are baked into the image at this stage.
- **Runtime** — `USER_ID` and `GROUP_ID` can be overridden with `-e` when running `docker run` to match your host user. This is only needed on **Linux** where bind-mounted file ownership must match the host. On **Windows** and **macOS**, Docker Desktop handles file permissions through its VM layer, so these options can be omitted.

| Variable         | Description                                                     | Default        |
| :--------------- | :-------------------------------------------------------------- | :------------- |
| `NEOVIM_VERSION` | Neovim version to install (`"stable"` or a tag like `"v0.9.8"`) | `stable`       |
| `USER_NAME`      | Main user name inside the container                             | `user`         |
| `USER_ID`        | UID for the container user (matched to host for file ownership) | `1001`         |
| `GROUP_ID`       | GID for the shared group inside the container                   | `1010`         |
| `HOST_OS`        | Your host OS (`"Windows"`, `"MacOS"`, or `"Linux"`)             | `Windows`      |
| `LANG`           | Locale setting for the container                                | `en_US.UTF-8`  |

#### 5.2.1. Proxy Settings (Optional)

If you are behind a corporate or network proxy, set the following variables in `.env`:

| Variable       | Description                                       | Example                              |
| :------------- | :------------------------------------------------ | :----------------------------------- |
| `HTTP_PROXY`   | HTTP proxy URL                                    | `http://proxy.example.com:8080`      |
| `HTTPS_PROXY`  | HTTPS proxy URL                                   | `http://proxy.example.com:8080`      |
| `NO_PROXY`     | Comma-separated list of hosts to bypass the proxy | `localhost,127.0.0.1,.example.com`   |

These settings are applied in two stages:

- **Build time** — Passed as build arguments so that package managers (`apt-get`, `curl`, etc.) can fetch resources through the proxy during `docker compose build`.
- **Runtime** — Injected as environment variables into the running container so that tools inside the container can also access the network through the proxy.

If you do not need a proxy, simply leave these variables unset. They default to empty and have no effect.

### 5.3. Build the Docker Image

Run the following command in the root directory of the repository:

```bash
docker-compose build
```

### 5.4. Set Up and Run the Container

#### 5.4.1. Create the Storage Container

Create the data-only container that manages persistent volumes:

```bash
docker compose create devbox-storage
```

This container holds all shared volumes (SSH keys, Neovim plugins, configuration data). It does not run — it only provides named volumes for the devbox container.

#### 5.4.2. Launch the DevBox Container

Start a devbox container with access to the shared volumes and your project directory:

```bash
docker run --rm -it \
    -e LANG=en_US.UTF-8 \
    --volumes-from devbox-storage-master \
    -v /path/to/project:/home/user/project \
    devbox:latest
```

- Replace `/path/to/project` with the absolute path to your project directory.
- For Japanese locale, use `-e LANG=ja_JP.UTF-8` instead. If you are using `run-devbox.ps1`, also change the `-e LANG=en_US.UTF-8` line in the script to `-e LANG=ja_JP.UTF-8`.

> **Linux (Docker Engine) only:** Add `-e USER_ID=$(id -u) -e GROUP_ID=$(id -g)` to match bind-mounted file ownership with your host user. On Windows/macOS (Docker Desktop), this is unnecessary because the VM layer handles permissions automatically.

```bash
docker run --rm -it \
    -e LANG=en_US.UTF-8 \
    -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) \
    --volumes-from devbox-storage-master \
    -v /path/to/project:/home/user/project \
    devbox:latest
```

## 6. 📖 Usage

### 6.1. Entering Your Development Environment

Start a new devbox container with the shared volumes and your project mounted:

```bash
docker run --rm -it \
    -e LANG=en_US.UTF-8 \
    --volumes-from devbox-storage-master \
    -v /path/to/project:/home/user/project \
    devbox:latest
```

Replace `/path/to/project` with the absolute path to the project you want to work on. The `--rm` flag removes the container on exit; persistent data is stored in the `devbox-storage` volumes.

To attach to an already running devbox container:

```bash
docker exec -it <container-id> /bin/bash
```

## 7. 📁 Project Structure

### 7.1. Directory Architecture

```plaintext
ProjectRoot/
├── .env                        # Environment variables for Docker build
├── devbox.ico                  # DevBox icon (for Windows context menu)
├── docker-compose.yml          # Docker Compose service definition
├── dockerfile                  # Docker image build configuration
├── LICENSE                     # MIT License
├── README.md                   # This file
├── run-devbox.ps1              # Launch script for Windows (PowerShell)
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

| File             | Description                          |
| :--------------- | :----------------------------------- |
| `run-devbox.ps1` | PowerShell launch script for Windows |

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

## 8. 🐳 Using the Image from Another Directory

Once you have built the image with `docker compose build`, it is tagged as `devbox:latest`. You can start a devbox container from any directory by referencing the storage container:

```bash
docker run --rm -it \
    -e LANG=en_US.UTF-8 \
    --volumes-from devbox-storage-master \
    -v /path/to/project:/home/user/project \
    devbox:latest
```

This allows you to spin up devbox containers anywhere without rebuilding or creating additional compose files, while sharing persistent data through the `devbox-storage` volumes.

### 8.1. Launch Scripts

The repository includes launch scripts that automate volume creation and container startup. They check whether the required Docker volumes exist, create them if missing, and then run the devbox container with the specified project directory.

#### 8.1.1. Windows (PowerShell)

```powershell
.\run-devbox.ps1 -Path "C:\path\to\project"
```

### 8.2. Windows Setup

#### 8.2.1. Environment Variable

Set the `DEVBOX_PATH` environment variable to the repository root so the launch script can locate `docker-compose.yml`:

1. Open **Settings** > **System** > **About** > **Advanced system settings**.
2. Click **Environment Variables**.
3. Under **User variables**, click **New** and add:
   - **Variable name:** `DEVBOX_PATH`
   - **Variable value:** the absolute path to this repository (e.g. `D:\devbox`)

Or via PowerShell (admin):

```powershell
[Environment]::SetEnvironmentVariable("DEVBOX_PATH", "D:\devbox", "User")
```

Replace `D:\devbox` with your actual repository path.

#### 8.2.2. Right-Click Context Menu (Explorer)

You can add a **"DevBox"** entry to the Windows Explorer folder context menu so you can open any folder in the devbox container with a right-click.

Open **Registry Editor** (`regedit`) and create the following key:

```text
HKEY_CURRENT_USER\Software\Classes\Directory\shell\DevBox
```

- Set the **(Default)** value to `Open in DevBox` (or any label you prefer).
- To add an icon, create a string value named `Icon` and set it as `%DEVBOX_PATH%\devbox.ico`.
- Create new sub-key `command` under `DevBox` and set its **(Default)** value to:

  ```text
  powershell.exe -ExecutionPolicy Bypass -NoProfile -Command "& \"$env:DEVBOX_PATH\run-devbox.ps1\" \"%1\""
  ```

```text
HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\DevBox
```

- Set the **(Default)** value to `Open in DevBox` (or any label you prefer).
- To add an icon, create a string value named `Icon` and set it as `%DEVBOX_PATH%\devbox.ico`.
- Create new sub-key `command` under `DevBox` and set its **(Default)** value to:

  ```text
  powershell.exe -ExecutionPolicy Bypass -NoProfile -Command "& \"$env:DEVBOX_PATH\run-devbox.ps1\" \"%V\""
  ```

## 9. 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 10. 📄 License

This project is licensed under the MIT License. See the [LICENSE](https://github.com/Xinor-a/portable-neovim-devbox/blob/main/LICENSE) file for details.
