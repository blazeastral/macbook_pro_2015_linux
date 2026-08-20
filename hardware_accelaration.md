# How to Enable VA-API Hardware Video Acceleration in Firefox on Ubuntu

This guide provides step-by-step instructions for enabling Hardware Video Acceleration (VA-API) in Firefox on Ubuntu (suitable for Intel Broadwell / Iris 6100 integrated graphics and similar hardware) to reduce CPU load and improve performance during video playback.

---

## 1. System Information & Driver Installation

### Step 1.1: Verify Your Graphics Hardware
Check your GPU details to confirm the active graphics adapter and OpenGL renderer:

```bash
lspci | grep -e VGA -e 3D
glxinfo | grep -e "OpenGL driver vendor" -e "OpenGL renderer"
```

> **Note:** If `glxinfo` is missing, install `mesa-utils`:
> ```bash
> sudo apt install mesa-utils
> ```

### Step 1.2: Install the Intel VA-API Driver
For older Intel integrated graphics (such as 5th Gen Broadwell / Iris Graphics 6100), install the legacy `i965` VA-API driver:

```bash
sudo apt update
sudo apt install i965-va-driver
```

### Step 1.3: Set the VA-API Environment Variable
Explicitly specify the VA-API driver name in your user environment profile:

```bash
echo 'export LIBVA_DRIVER_NAME=i965' >> ~/.profile
source ~/.profile
```

---

## 2. Configure Firefox Settings

1. Open **Firefox**.
2. Type `about:config` in the address bar and press **Enter**.
3. Click **"Accept the Risk and Continue"**.
4. Search for the following keys and adjust their values as specified:

| Preference Key | Value | Description |
| :--- | :---: | :--- |
| `media.ffmpeg.vaapi.enabled` | `true` | Enables VA-API hardware decoding |
| `media.ffvpx.enabled` | `false` | Disables internal FFVPX software decoder |
| `media.rdd-vpx.enabled` | `false` | Disables RDD VPX software decoder |
| `media.navigator.mediadatadecoder_vpx_enabled` | `true` | Enables media data decoder for VPX |

5. **Restart Firefox** for the changes to take effect.

---

## 3. Install Browser Extension (Force H.264 Playback)

Most older GPUs support hardware decoding for **H.264** video streams but lack hardware support for modern codecs like **VP9** or **AV1**.

1. Install the extension **h264ify** or **Enhanced-h264ify** in Firefox:
   - [h264ify on Firefox Add-ons](https://addons.mozilla.org/en-US/firefox/addon/h264ify/)
   - [Enhanced-h264ify on Firefox Add-ons](https://addons.mozilla.org/en-US/firefox/addon/enhanced-h264ify/)
2. Open the extension settings and ensure **Block VP8 / VP9 / AV1** is enabled to force YouTube and other streaming sites to serve H.264 streams.

> **Browser Compatibility Note:**
> Hardware video acceleration configured via these steps works reliably in **Firefox** (lowering GPU/CPU usage to ~5%). In Chromium-based browsers like **Brave**, additional flag configurations or drivers may be required, and hardware acceleration might not function as expected out of the box on this hardware configuration.

---

## 4. Verify Hardware Acceleration Status

### Step 4.1: Install Monitoring Tools
Install `intel-gpu-tools` to monitor GPU usage real-time:

```bash
sudo apt install intel-gpu-tools
```

### Step 4.2: Monitor GPU Usage
Run the monitoring tool in a terminal:

```bash
sudo intel_gpu_top
```

1. Start streaming a 1080p video on YouTube inside **Firefox**.
2. Check the `intel_gpu_top` monitor. You should see active usage percentages under the **Video / VideoEnhance (VDBOX)** engine, confirming that decoding is handled by the GPU hardware rather than the CPU.

