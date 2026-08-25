# GRUB shorten time and automatically add other Operating Systems

```bash
sudo nano /etc/default/grub
```

add: `GRUB_RECORDFAIL_TIMEOUT=5`

```bash
sudo update-grub
```

