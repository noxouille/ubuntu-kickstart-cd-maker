# make-automated-install-cd.sh

## What does this script do? 

This script lets you create a completely automated Ubuntu Server installation CD (default:12.04.3 64 bit) that you can boot on any PC and have a working server in minutes without ever touching a keyboard.

## How does it do it?

It downloads the installation CD ISO from the ubuntu file servers, remasters it with a [KickStart](http://fedoraproject.org/wiki/Anaconda/Kickstart) file, configures a few other files, and creates a new ISO file you can burn onto a disk.

Based on this [askubuntu.com thread](http://askubuntu.com/questions/122505/how-do-i-create-a-completely-unattended-install-of-ubuntu).

## How do I run it?

If you're happy with Ubuntu server 12.04.3 64 bit, just download/clone the repository, chdir to it, and run the script:

    ./make-automated-install-cd.sh

If you want another version, edit the script. (TODO: preload other distros/versions).

## What is the default name and password?

Default usename is user and password is 'p@ssw0rd!'. 

## What are the other files in this repo?

3 Files are copied onto the CD image:

* `ks.cfg` - This is the kickstart configuration file. Either edit by hand, or use `system-config-kickstart`. Copied to the root directory of the image (`/`).
* `isolinux.cfg` - Copied to /isolinux on the image. The only thing I changed from the default is to set the `timeout` value to 10 (instead of 0, which means no timeout) so that you don't have to select a language upon boot.
* `txt.cfg` - This is the file that contains that list boot options when you boot a Linux box.  You can set kernel boot parameters here.  Note that I added `ks=cdrom:/ks.cfg` to the params. Also copied to /isolinux on the image.

`ubuntu-12.04.3-server-amd64.iso.MD5SUM` is the md5sum file for default ISO file which the script points to.  If you want to try a different distro, you'll need to download it manually, create a similar file with (`md5sum foobar.iso > foobar.iso.MD5SUM`) and edit the script accordingly.
 
## Why would I want to use a disk over network booting with PXE/TFTP/etc?

For a small number of servers, or if you only occasionally deploy
I you manage lots of deploy lots of servers, 

## How do I do XYZ?

I don't know much about kickstart besides what is in this repo.  But, consider this: you can add a [%post] [post] section to the kick start configuration file which lets you run arbitrary commands after the installation (but before rebooting).  This should be enough to create config files for you favorite configuration management system (puppet/chef/salt/cfengine/whatever), which you should be using instead of trying to hack at kickstart for post-installation configuration.

  [post]: http://fedoraproject.org/wiki/Anaconda/Kickstart#Chapter_5._Post-installation_Script

## How do I add packages to be installed during the automated installation?

You can add the packages at the end of the ks.cfg file.

## Will it work on other distros?

Probably, at least for Ubuntu and Debian based distros.  Just edit the variables in the script and create a iso-file-name.MD5SUM file.

## Why does the script ask for my root password?

Because apparently, in order to extract an ISO file on linux, you need to mount it with the 'loop' option, and you need root permissions to mount anything on Linux.  This is stupid.  Note that if you google this, you'll find links that says you can use the 7zip program, BUT do not believe them: 7zip has a bug in Linux where files extracted from an ISO with long file names get truncated (!).

## What is a preseed file?

I'm not sure, but apparently you need to pass it to the kernel params along with the `ks.cfg` file.  There are default preseed files on the CD under the /preseed/ directory, and I use the `ubuntu-server.seed` file. Perhaps there are interesting things in there. 
