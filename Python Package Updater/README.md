# 📦 Upgrade Pip Packages Script

## 📌 Overview

This repository contains a collection of useful shell scripts designed to automate common system and development tasks. This particular script adds a new utility that helps developers keep their Python environment clean and up to date by automatically upgrading all outdated pip packages in a safe and readable way.

The script checks for outdated Python packages and upgrades them one by one, displaying useful information such as current and latest versions during the process.

It is designed to be simple, transparent, and beginner-friendly while still being reliable for daily development workflows.

---

## 🛠 Script Name

`upgrade_pip_packages.sh`

---

## 🎯 Purpose

Managing Python dependencies manually can be time-consuming, especially when working across multiple environments. This script automates the process of:

* Detecting outdated pip packages
* Upgrading pip itself
* Updating each outdated package sequentially
* Showing progress and version details

This helps maintain a clean and updated development environment without relying on complex one-liner commands.

---

## ✨ Features

* Clean and readable implementation
* Step-by-step upgrade process
* Automatic pip upgrade before package updates
* Displays:

  * Package name
  * Current version
  * Latest version
* Safe and transparent execution
* Works on most Linux distributions

---

## 📋 Requirements

Before running the script, ensure the following are installed:

* Python 3
* pip
* Linux shell (bash)

Check installations:

```bash
python3 --version
pip --version
```

---

## 🚀 How to Use

### 1️⃣ Clone the repository

```bash
git clone https://github.com/Yuvraj960/Shell-Scripting.git
cd Shell-Scripting
```

### 2️⃣ Give execute permission

```bash
chmod +x upgrade_pip_packages.sh
```

### 3️⃣ Run the script

```bash
./upgrade_pip_packages.sh
```

---

## 🔍 What the Script Does Internally

1. Verifies Python and pip are installed
2. Upgrades pip to the latest version
3. Retrieves a list of outdated packages
4. Iterates through each package
5. Upgrades them individually using pip
6. Displays progress logs

---

## 📁 Example Output

```
Checking Python and pip availability...
Upgrading pip to latest version...

Getting list of outdated packages...
Total outdated packages: 5

Upgrading: matplotlib
Current version: 3.9.2
Latest version : 3.10.6
----------------------------------------
```

---

## ⚠️ Important Notes

* If you are working with GPU/ML environments (PyTorch, TensorFlow, CUDA):

  * Upgrading core libraries may affect compatibility.
  * Consider reviewing package upgrades before running.

* Recommended best practice:

  * Use this script inside virtual environments.

---

## 🧠 Best Use Cases

This script is useful for:

* Developers maintaining Python projects
* Data science environments
* System cleanup and maintenance
* Regular dependency updates

---