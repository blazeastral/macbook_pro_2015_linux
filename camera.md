# Install Dependencies and Firmware

## Open your terminal and install the required build tools and utilities:

sudo apt update
sudo apt install -y git curl xz-utils cpio kmod libssl-dev checkinstall

## Clone and install the facetimehd-firmware extractor:

cd /tmp
git clone https://github.com/patjak/facetimehd-firmware.git
cd facetimehd-firmware
make
sudo make install

# Build and Load the Camera Driver

## Move back, clone the PCIe driver module, and compile it:

cd /tmp
git clone https://github.com/patjak/bcwc_pcie.git
cd bcwc_pcie
make
sudo make install

## Register and load the module into your kernel:

sudo depmod
sudo modprobe -r bdc_pci
sudo modprobe facetimehd

# Make the Driver Persistent

## To ensure the camera loads automatically after system reboots or kernel upgrades, add the module to your system configuration:

echo "facetimehd" | sudo tee -a /etc/modules
