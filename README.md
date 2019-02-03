this is a [UltraVNC](https://www.uvnc.com/) playground

# Usage

[Build and install the Windows 2019 base image](https://github.com/rgl/windows-2016-vagrant).

Launch the machines:

```bash
vagrant up --provider=virtualbox # or --provider=libvirt
```

Logon at the `windows1` machine console.

Using UltraVNC Viewer, connect to the `windows2.example.com` machine with the `vagrant` username and password.

# Notes

* The `ddengine` (which requires Windows 8+ and DirectX) replaced the mirror driver in UltraVNC 1.2.2.1.
  * This repository last support for the mirror driver was at [revision c7ee1658ee1126b95c0d74402722a0ea6ea76e08](https://github.com/rgl/ultravnc-vagrant/commit/c7ee1658ee1126b95c0d74402722a0ea6ea76e08).
