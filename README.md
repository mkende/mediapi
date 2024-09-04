# MediaPi

## Raspberry Pi Setup

This program is meant to work on a small 320 × 240 tactile screen like
[this one](https://www.adafruit.com/product/2298) (but it should work on any
screen of roughly the same size). Setting up the screen is out of scope for this
README.

However, we recommand to start with a Raspbian Lite ISO and then only install
the `lightdm` package and configure your Raspberry Pi with **Desktop Autologin**
in `raspi-config` in the **System options** / **Boot / Autologin** menu.

You also need a working sound output. Configuring that is also out of scope for
this README file.

## Installation

```sh
sudo apt-get install perl build-essential cpanminus tcl tcl-dev tk unifont vlc
sudo cpanm App::MediaPi -n -L /usr/local --man-pages --install-args 'DESTINSTALLBIN=/usr/local/bin'
echo '/usr/local/binmediapi' > ~/.xsessionrc
```

Note that when the `mediapi` program is running and idle, then it automatically
shutdown the Raspberry Pi after 20 minutes without playing any audio. So you
might want to run something like `pkill mediapi` in case you want to use the
Raspberry Pi for something else when the program is running
