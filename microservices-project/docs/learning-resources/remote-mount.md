# Remote Mounting
```sh
sshfs user@ubuntu-server:/remote/path /Users/you/ubuntu_mount -o IdentityFile=~/.ssh/id_rsa
```
## Actual
```sh
sshfs dane@ubuntu-laptop:/home/dane/Sources/scaling_project /Users/danebalia/Sources/scaling_project -o IdentityFile=~/.ssh/id_rsa
```

## Remove
```sh
umount dane@ubuntu-laptop:/home/dane/Sources/scaling_project
```
