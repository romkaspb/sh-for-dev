# sh-for-dev
Simple script to run on vagrant virtual machine

##Steps:  
1) Install vagrant and virtual box  
2) Then `git clone git@github.com:romkaspb/sh-for-dev.git`  
3) Move Vagrantfile to your vagrant directory  
4) Then, move there and create directory names `dev` and move `install.sh` there    
5) `vagrant up`  
6) `ssh vagrant@127.0.0.1 -p 2202`
7) `ssh-keygen`
8) On the host machine: `ssh-copy-id "vagrant@127.0.0.1 -p 2202"` (for key authentification)  
9) Switch to vagrant  
10) `cd dev`  
11) `sudo ./install.sh`, root password is `vagrant`
12) Enter required values - git login, git email, mysql root password  
13) Have fun!
