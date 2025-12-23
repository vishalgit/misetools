# misetools

A development environment created using mise tools

cd into the directory

# build

docker/podman build -t misetools-image -f Dockerfile .

# create container

docker run -it   
--name misetools-container   
--user $(id -u):$(id -g)   
-e WAYLAND\_DISPLAY=wayland-1   
-e XDG\_RUNTIME\_DIR=/tmp/xdg   
-v $XDG\_RUNTIME\_DIR:/tmp/xdg   
-v $HOME/projects:/home/ubuntu/projects   
--net host   
misetools-image zsh
Sync Rclone From the home directory run this command rclone bisync notes mega:notes --resync --size-only

In case of GitHub decrypting error run "gpg --decrypt /home/ubuntu/.secrets/gh.gpg' manually once in session

