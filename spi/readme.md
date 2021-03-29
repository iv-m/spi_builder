```
How to build SPI image
======================

To build mitx.full.padded:

Set the source dir, cross compiler, and DUAL_FLASH in Makefile.

$ make BOARD=mitx-d

To build a debug module separate from the SPI image:

Comment out the required module in ArmBaikalPkg/ArmBaikalBfkm.fdf.inc. For example:
#INF ArmBaikalPkg/Drivers/BaikalEthDxe/BaikalEthDxe.inf

Set UEFI_BUILD_TYPE = DEBUG in the Makefile and run:

$ make uefi

Copy the debug version of the module to USB flash:
cp  ../baikal-m/uefi/Build/ArmBaikalBfkm-AARCH64/DEBUG_GCC6/AARCH64/BaikalEthDxe.efi /media/ndz/B03B-6A17/
umount /media/ndz/B03B-6A17

Insert the USB flash and boot. During boot, add the module via menu "Add driver options".

How to burn the image to SPI
============================

sudo apt install libftdi1

$ minicom -C ses.log S2

You need to set ATX_PSON and EN_1V8 pins. There id's can be different from 19
and 23, so use the 'list' command first.

>:pins list
>:pins set 19
Set pin 19 (ATX_PSON)
>:pins set 23
Set pin 23 (EN_1V8)

Flashrom shall be at least version 1.2:
$ cd img

# You will need at least firmware-v1.2 installed. If it is not available in the
# repo, just build the current flashrom from source. You will need libftdi-dev
# installed first.

# Burn full image, where BOARD is the target you have built.
$ sudo flashrom -p ft2232_spi:type=arm-usb-tiny-h,port=A,divisor=8 -w $BOARD.full.padded -c MT25QU256 -l mitx.layout -i vadim

# Burn a specific section
$ sudo flashrom -p ft2232_spi:type=arm-usb-tiny-h,port=A,divisor=8 -w $BOARD.full.padded -c MT25QU256

Upon success, type in minicom:

>:pins board_off
```