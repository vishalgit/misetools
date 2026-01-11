# misetools

A development environment created using mise tools

cd into the directory

# build

docker/podman build -t misetools-image -f Dockerfile .

# create container

docker run -d -it \
--name misetools-container \
--user $(id -u):$(id -g) \
-e WAYLAND\_DISPLAY=wayland-1 \
-e XDG\_RUNTIME\_DIR=/tmp/xdg \
-v $XDG\_RUNTIME\_DIR:/tmp/xdg \
-v $HOME/projects:/home/ubuntu/projects \
-h misetools \
misetools-image

Sync Rclone From the home directory run this command rclone bisync notes mega:notes --resync --size-only
Sync Rclone From the home directory run this command rclone bisync ~/org mega:org --resync --size-only

In case of GitHub decrypting error run "gpg --decrypt /home/ubuntu/.secrets/gh.gpg' manually once in session

docker run -it \
--name misetools-container \
--network=host \
--shm-size=4g \
--memory=0 \
--memory-swap=0 \
--cpus=0 \
--cap-add=SYS_PTRACE \
--security-opt seccomp=unconfined \
-p 3389:3389 \
-p 22:22 \
-v projects:/home/ubuntu/projects \
-e DISPLAY=$DISPLAY \
-e XAUTHORITY=$XAUTHORITY \
misetools-image
