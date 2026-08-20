# Scrolling too fast

This guide provides step-by-step instructions for building, installing, and configuring `libinput-config` from source. `libinput-config` allows you to customize `libinput` parameters—such as scroll sensitivity—system-wide, even on desktop environments that do not expose these settings directly.

---

## Prerequisites

Before starting, ensure you have the required build dependencies installed (e.g., `git`, `meson`, `ninja-build`, and C compilers). On Debian/Ubuntu-based systems, you can install them with:

```bash
sudo apt update
sudo apt install git meson ninja-build build-essential libinput-dev
```

---

## 1. Clone and Build the Source Code

Clone the repository and compile the binaries using `meson` and `ninja`:

```bash
git clone https://github.com/lz42/libinput-config.git
cd libinput-config/
meson setup build
cd build/
ninja
```

---

## 2. Install the Compiled Binaries

Install the built library files and tools to system directories:

```bash
sudo ninja install
```

---

## 3. Create and Edit the Configuration File

Open or create the global configuration file at `/etc/libinput.conf` using the `nano` text editor:

```bash
sudo nano /etc/libinput.conf
```

Add your desired configuration parameters. For example, to override compositor-level settings and decrease touchpad/mouse scroll speed to 25% of default:

```ini
override-compositor=enabled
scroll-factor=0.25
```

### Key Shortcuts in Nano:
* Press **`Ctrl` + `O`**, then press **`Enter`** to save the file.
* Press **`Ctrl` + `X`** to exit the editor.

---

## 4. Apply Changes

Restart your graphical session (log out and log back in, or restart your display manager / system) for the `libinput` hooks to take effect across your desktop environment.
