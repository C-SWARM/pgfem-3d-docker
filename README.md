== PGFem3D Deployment Image ==

=== Requirements ===
  * Docker environment with external network connectivity
    To install - https://www.docker.com/community-edition    

=== Quick Start ===

Within this directory, run:

 > docker build -t "cswarm:pgfem3d" .

Docker will pull the required base image and begin building the
PGFem3D software. This may take a consderable amount of time
depending on your hardware. 10m to 30m is common.

Software is installed to the /opt prefix in the container image.

Once the build is complete, you may launch PGFem3d from within your
docker container. For example:

 > docker ps -a      # to list images
 > docker run "cswarm:pgfem3d" /opt/pgfem-3d/bin/PGFem3D -SS

For an interactive shell in your container:

 > docker run -ti "cswarm:pgfem3d" /bin/bash
 > cd pgfem-3d
 > make check

To run the example:
 > cd pgfem-3d-examples 
   and follow the README located therein
 > docker commit CONTAINER_ID cswarm:pgfem3d # to commit the changes to cswarm:pgfem3d, this can be done from a separte terminal

To visualize the example output:
 Launch Paraview (assuming ssh with X11 forwarding to docker server host)

 On Windows
 > docker run --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/home/cswarm/.Xauthority:rw" "cswarm:pgfem3d" paraview &

 On Mac
 > open -a XQuartz 
   X11 Preferences -> Security -> enable "Allow connection from network clients"
 > defaults write org.macosforge.xquartz.X11 enable_iglx -bool true # without iglx, paraview gets frozen
 > xhost + $(hostname)
 > docker run --net=host -e DISPLAY=$(hostname):0 --volume="$HOME/.Xauthority:/home/cswarm/.Xauthority:rw" "cswarm:pgfem3d" paraview &
