# misetools
A development environment created using mise tools

cd into the directory
# build
docker/podman build -t misetools-image -f Dockerfile .
# create container
docker run -it \
  --name misetools-container \
  --user $(id -u):$(id -g) \
  -e WAYLAND_DISPLAY=wayland-1 \
  -e XDG_RUNTIME_DIR=/tmp/xdg \
  -v $XDG_RUNTIME_DIR:/tmp/xdg \
  -v $HOME/projects:/home/ubuntu/projects \
  --net host \
  misetools-image zsh
Sync Rclone From the home directory run this command rclone bisync notes mega:notes --resync --size-only
