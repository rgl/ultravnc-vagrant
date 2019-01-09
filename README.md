this is a [UltraVNC](https://www.uvnc.com/) playground

# Usage

[Build and install the Windows 2019 base image](https://github.com/rgl/windows-2016-vagrant).

Launch the machines:

```bash
vagrant up --provider=virtualbox # or --provider=libvirt
```

Logon at the `windows1` machine console.

Using UltraVNC Viewer, connect to the `windows2.example.com` machine with the `vagrant` username and password.
