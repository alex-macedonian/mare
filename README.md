## Mare version 3.0	

## Brief Package Description.	
It's no secret  that the Debian GNU/Linux operating system  is not for beginners users. 
To help such a user take the first steps in using this wonderful system, a mare package 
was developed.

The  mare package  is designed to  administer workstations running the Debian GNU/Linux 
operating  system immediately  after  installation. With  this  package,  administering 
workstations  running the Debian GNU/Linux operating system boils down to entering just 
one command: mare -f.

## Opportunities of the current version:	
- configures elevated privileges for the user by editing the /etc/sudoers file;	
- configures the wireless network interface by installing firmware and editing
  the NetworkManager.conf file;	
- сonnects the wireless network interface to the Internet;
- configures package sources (edits the /etc/apt/sources.list file) and updates
  the system by installing or updating packages;
- installs the necessary micro programs for the proper operation of your computer;	
- configures the bootloader of the operating system (edits the /etc/default/grub
  file);	
- configures the filesystems table (edits the /etc/fstab file);	
- improves system performance by setting the dump of RAM pages to the swap section
  and setting the amount of allocated RAM for the cache;	
- installs additional packages and codecs at the request of the user;	
- configures a dynamic message of the day.	
- configures the LightDM display manager

## Instructions for installing the mare package on your system.	
1. Download the latest mare package by clicking on the following link: [https://github.com/alex-macedonian/mare/releases](https://github.com/alex-macedonian/mare/releases)
2. Go to the directory where you downloaded the mare package, for example with this command: cd Download/
3. Extract the contents of the archive into the current directory using the following command: tar -xvf mare-3.0.tar.gz
4. Go to the package directory: cd ./mare-3.0	
5. Install the necessary packages: apt-get -y install make wireless-tools
6. Install files from the mare package using the following command: make install

## Mare script usage guide.
Setting up your operating system proceeds in two steps if the X Window System does not
start after installing the Debian GNU/Linux 10 operating system. This can happen if
you have a video card from AMD/ATI installed in the system unit. From the beginning, 
you should run a small configuration of the operating system by entering the command in 
the console: mare -s. Restart the computer, and then run a large configuration of the 
operating system by typing: mare -b in the terminal of your desktop environment. Such 
problems do not arise with video cards from NVIDIA, and then the Debian GNU/Linux 10 
operating system is configured with one command: mare -f, as stated in the description 
of this package.

If you use a USB Wi-Fi adapter to connect to the Internet, then setting up your Debian 
GNU/Linux 10 operating system takes place in three stages. At the first stage, micro 
programs for the USB Wi-Fi adapter are installed with the following command: mare -w. 
The second stage will be a small configuration of the operating system and the third 
stage will be a large configuration of the operating system.
