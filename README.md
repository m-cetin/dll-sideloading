# Create ISO payloads

This powershell script creates a malicious ISO payload by using DLL sideloading and an LNK file to trigger the payload

# Requirements

- the "pyminizip" python module was installed using conda:

`conda install -c mzh pyminizip`

If you are not using Anaconda and installed pyminizip with `pip`, remove `conda run -n base` from line 39

- this scripts uses [PackMyPayload](https://github.com/mgeeky/PackMyPayload) to pack the payloads into the ISO. It's included in this directory.

# How it works

The iso file contains the OneDriveStandaloneUpdater.exe, which is a legitime binary executing your shellcode (version.dll). For further explanation, see:

https://blog.sunggwanchoi.com/recreating-an-iso-payload-for-fun-and-no-profit/&cd=1&hl=en&ct=clnk&gl=de 

# Usage

`.\make-iso.ps1 -dll version.dll -lnk readme.txt.lnk -iso Updates.iso -file OneDriveStandaloneUpdater.exe`

Explanation:

- OneDriveStandaloneUpdater.exe. This is a legitime Microsoft OneDrive binary. By default it's located at `C:\Users\%USERPROFILE%\AppData\Local\Microsoft\OneDrive`
- version.dll is your payload. Just make sure to rename it to "version.dll"
- readme.txt.lnk. An LNK file triggering the payload process. Name it as you like.
- Updates.iso. Your final payload containing all pieces. Name it as you like.
