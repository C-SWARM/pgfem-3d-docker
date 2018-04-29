== PGFem3D Deployment Image ==

=== Requirements ===
  * Docker environment with external network connectivity
    To install - https://www.docker.com/community-edition    

=== Quick Start ===

Within this directory /pgfem-3d-docker, run:

 > docker build -t "cswarm:pgfem3d" .

Docker will pull the required base image and begin building the
PGFem3D software. This may take a consderable amount of time
depending on your hardware. 10m to 20m is common.

Software is installed to the /opt prefix in the container image.

Once the build is complete, you may launch PGFem3d from within your
docker container. For example:

 > docker images -a      # to list images
 > docker run "cswarm:pgfem3d" /opt/pgfem-3d/bin/PGFem3D -SS

For an interactive shell in your container:

 > docker run -ti "cswarm:pgfem3d" /bin/bash
 > cd pgfem-3d
 > make check

To run the example from the interactive shell:

 > cd pgfem-3d-examples 
 > ./local_makeset.pl clean -np 4  # to generate input for 4-core job 
 > ./run.sh                        # to run the example
 > docker commit CONTAINER_ID cswarm:pgfem3d # to commit the changes to cswarm:pgfem3d; please do this from a terminal on the host; execute "docker ps" for CONTAINER_ID

To visualize the example output, you firt need to launch Paraview (assuming ssh with X11 forwarding to docker server host)

 On Windows (use a terminal on the host)
 > docker run --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/home/cswarm/.Xauthority:rw" "cswarm:pgfem3d" paraview &  # to open the paraview on the container

 On Mac (use a terminal on the host)
 > open -a XQuartz 
   X11 Preferences -> Security -> enable "Allow connection from network clients"
 > defaults write org.macosforge.xquartz.X11 enable_iglx -bool true # without iglx, paraview gets frozen
 > xhost + $(hostname)
 > docker run --net=host -e DISPLAY=$(hostname):0 --volume="$HOME/.Xauthority:/home/cswarm/.Xauthority:rw" "cswarm:pgfem3d" paraview &  # to open the paraview on the container
 
 Once the paraview GUI is open:
 1. File -> Load State -> select the file "parview_displacement_z.pvsm" (or "parview_displacement_y.pvsm") and click OK
 2. Once the paraview state is loaded, point to: out -> box_4CPU -> VTK -> box_..pvtu 
 3. Click onto the "Play" button to see the affect of thermal expansion


For any technical assistance, plase contac:
1. Ezra Kissel <ezkissel@indiana.edu>
2. Kamal K Saha <ksaha@nd.edu>
3. Luke D'Alessandro <ldalessa@uw.edu>
