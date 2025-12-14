# Grass Desktop Node Installer

This repository provides an automated script to build and install the **Grass Desktop App** on Fedora Linux. 

Since the official Grass application is only distributed as a `.deb` (for Debian/Ubuntu), and the official `.rpm` was not published yet, I decided to take the matter in my own hands. This tool acts as a _bridge_ between distros. It downloads the official package, repackages it into a native Fedora `.rpm` with correct dependencies, and installs it.

## ⚠️ DISCLAIMER ⚠️
This is an **unofficial community tool**. 
- The software you will be installing is proprietary intellectual property of the **Grass Foundation** (Grass OpCo Ltd).
- This tool does not modify anything inside the official binary; it only adjusts the packaging format to work on Fedora.
- Use the tool at your own risk.

## ⚙️ Compatibility ⚙️
- **Verified on:** Fedora 43 KDE Plasma Desktop Edition.
- **Likely works on (but not guaranteed):** Fedora 41+, Nobara, RHEL 9, CentOS Stream and other DNF-centered GNU/Linux distributions.
- Bazzite/Silverblue users should edit the script to use `rpm-ostree install` due to the specific configurations of the OS.

```bash
rpm-ostree install grass-*grass version number*.rpm
```

## ➡️**Installation Guide**⬅️

You must install the RPM Build Tools (`rpm-build`) and `binutils` first to make the script work. Installing `wget` will allow you to download the original Debian package _straight_ from the command line without any use of a browser. Installing `git` is also required if you want to perform a `git clone`.

   ```bash 
   sudo dnf install rpm-build binutils wget
```
To start the installation, you can either `git clone` this repository in a folder or download the script directly. Make sure to make the script executable.

```bash
git clone https://github.com/777FIRSTGAMER777/grass-rpm-installer.git

cd grass-rpm-installer

chmod +x touch_grass.sh
```
Now, you can execute the script.

```bash
./touch_grass.sh
```
I hope this will help for us all. If you spot any issues, don't hesitate to report them. :)

Notice: This script was made with the assistance of AI (Gemini 3 Pro by Google) and was manually tested.
