```bash
vagrant init 'markeganfuller/panic_test'
vagrant up
vagrant ssh

$ mount | grep  # Check /bobby_mount is a nfs v4.2 mount
$ sudo -i
$ cd /bobby_mount
$ strace -f -o /dev/console singularity create bob.img 2>&1 > /dev/console

# Kernel panic
```
