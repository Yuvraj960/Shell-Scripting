Here’s a detailed step-by-step guide for setting up and hosting an **Ubuntu Server** on your computer using **Oracle VirtualBox**, and accessing it from your Windows 11 host via SSH:

---

### **1. Install Oracle VirtualBox**
1. **Download VirtualBox**:
   - Go to the [VirtualBox website](https://www.virtualbox.org/) and download the Windows version.
2. **Install VirtualBox**:
   - Run the installer and follow the on-screen instructions.
   - Allow network and hardware virtualization features if prompted.

---

### **2. Download Ubuntu Server ISO**
1. Visit the official Ubuntu Server page: [https://ubuntu.com/download/server](https://ubuntu.com/download/server).
2. Download the latest **LTS version** of Ubuntu Server (e.g., 22.04 LTS).

---

### **3. Create a New Virtual Machine (VM)**
1. **Launch VirtualBox**:
   - Click **New** to create a new VM.
2. **Name the VM**:
   - Enter a name (e.g., `UbuntuServer`).
   - Choose **Linux** as the type and **Ubuntu (64-bit)** as the version.
3. **Allocate Resources**:
   - Memory: Assign at least **2GB (2048MB)**.
   - Storage: Create a virtual hard disk of at least **20GB**.
4. **Attach the Ubuntu ISO**:
   - Go to **Settings > Storage**.
   - Under **Controller: IDE**, click the empty disk and attach the downloaded Ubuntu Server ISO.

---

### **4. Install Ubuntu Server on the Virtual Machine**
1. **Start the VM**:
   - Click **Start** in VirtualBox to boot from the ISO.
2. **Follow Installation Steps**:
   - Select your language and keyboard layout.
   - Configure the network (use DHCP for now).
   - Create a username and password (e.g., `user` and `password`).
   - Select the default options for disk partitioning and software setup.
3. **Install OpenSSH Server**:
   - During the installation, choose to install **OpenSSH Server** (this is critical for SSH access).
4. **Complete Installation**:
   - Once installation is complete, reboot the VM.

---

### **5. Configure Network for SSH Access**
1. **Set Network Adapter in VirtualBox**:
   - Go to **Settings > Network** in VirtualBox.
   - Choose **Bridged Adapter** for the network mode.
     - This ensures your VM gets its own IP address on the same network as your Windows host.

2. **Get the VM's IP Address**:
   - Log in to the Ubuntu Server on the VM.
   - Run:
     ```bash
     ip addr
     ```
   - Note the IP address of the server (e.g., `192.168.1.100`).

3. **Test SSH Connection from Windows**:
   - Open the **Command Prompt** on Windows.
   - Run:
     ```bash
     ssh user@192.168.1.100
     ```
   - Replace `user` with the username you created and `192.168.1.100` with your VM's IP.

---

### **6. Set Up a Static IP for the Ubuntu Server**
1. **Edit Netplan Configuration**:
   - Open the configuration file:
     ```bash
     sudo nano /etc/netplan/00-installer-config.yaml
     ```
   - Example configuration for a static IP:
     ```yaml
     network:
       version: 2
       ethernets:
         enp0s3:
           dhcp4: no
           addresses:
             - 192.168.1.100/24
           gateway4: 192.168.1.1
           nameservers:
             addresses:
               - 8.8.8.8
               - 8.8.4.4
     ```
     - Replace `enp0s3` with your network interface name (found using `ip addr`).
2. **Apply the Configuration**:
   ```bash
   sudo netplan apply
   ```
3. **Verify the Static IP**:
   - Check with:
     ```bash
     ip addr
     ```

---

### **7. Enable SSH on Ubuntu**
1. **Verify SSH Service**:
   - Check if SSH is running:
     ```bash
     sudo systemctl status ssh
     ```
   - If not, start and enable it:
     ```bash
     sudo systemctl start ssh
     sudo systemctl enable ssh
     ```

2. **Configure Firewall**:
   - Allow SSH through `ufw`:
     ```bash
     sudo ufw allow OpenSSH
     sudo ufw enable
     ```

---

### **8. Test SSH Access**
1. **Access from Windows**:
   - Open Command Prompt and type:
     ```bash
     ssh user@192.168.1.100
     ```
     Replace `user` with the username and `192.168.1.100` with the server's IP.
   - Enter the password when prompted.

2. **Optional: Use an SSH Client**:
   - You can also use tools like **PuTTY** for SSH access.

---

### **9. Automate VirtualBox Startup**
1. **Set the VM to Start on Boot** (Optional):
   - On Windows, create a scheduled task to start VirtualBox with your VM.
     ```cmd
     VBoxManage startvm "UbuntuServer" --type headless
     ```

---

### **10. Verify and Use**
- You now have a fully operational Ubuntu Server hosted on VirtualBox.
- Access it via SSH from your Windows 11 host anytime.

This setup allows you to run a server environment seamlessly, enabling further configurations like hosting applications or displaying system stats. Let me know if you need help with additional tasks!
