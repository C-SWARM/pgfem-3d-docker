== PGFem3D Deployment Image ==

=== Requirements ===
  * Docker environment with external network connectivity
    To install - https://www.docker.com/community-edition    

=== Quick Start ===

Within this directory /pgfem-3d-docker, run:
```
user@host~$ docker build -t "cswarm:pgfem3d" .
```

Docker will pull the required base image and begin building the
PGFem3D software. This may take a consderable amount of time
depending on your hardware. 10m to 20m is common.

Software is installed to the /opt prefix in the container image.

Once the build is complete, you may launch PGFem3d from within your
docker container. For example:
```
user@host~$ docker images -a      # to list images
user@host~$ docker run "cswarm:pgfem3d" /opt/pgfem-3d/bin/PGFem3D -SS
```

In order to build, run, and visualize output from an interactive shell in your
container:
 * For X forwarding from the docker container, Mac OS X users must first follow
   XQuartz instructions at the end of this document.

```
user@host~$ docker run --net=host -e DISPLAY --volume="$HOME/.Xauthority:/home/cswarm/.Xauthority:rw" -ti "cswarm:pgfem3d" /bin/bash
cswarm@container~$ cd pgfem-3d
cswarm@container~$ make check
```

To run the example from the interactive shell:
```
cswarm@container~$ cd pgfem-3d-examples 
cswarm@container~$ ./local_makeset.pl clean -np 4  # to generate input (for 4-core job)
cswarm@container~$ ./run.sh 4                      # to run the example (for 4-core job)
```

To visualize the resulting output launch paraview.
```
cswarm@container~$ paraview &
```

Once the paraview GUI is open:
1. File -> Load State -> select the file "parview_displacement_z.pvsm" (or "parview_displacement_y.pvsm") and click OK
2. Once the paraview state is loaded, point to: out -> box_4CPU -> VTK -> box_..pvtu 
3. Click onto the "Play" button to see the affect of thermal expansion

In order to retain changes made within the container, from a second terminal on
the host (not the terminal inside the container).

```
user@host~$ docker ps                       # to find the CONTAINER_ID to commit changes
user@host~$ docker commit CONTAINER_ID cswarm:pgfem3d # to commit the changes to cswarm:pgfem3d
```

Preparing XQuartz On Mac OS X for visualizatoin (use a terminal on the host)
 * XQuartz can be installed from https://www.xquartz.org/.
 * You may need to log out and log back in after a new XQuartz install.
 * The homebrew install is untested.
 * Ensure that X11 Preferences -> Security -> enable "Allow connection from
   network clients" is clicked in the preference pane.

```
user@host~$ open -a XQuartz
user@host~$ defaults write org.macosforge.xquartz.X11 enable_iglx -bool true # without iglx, paraview gets frozen
user@host~$ xhost + $(hostname)
user@host~$ export DISPLAY=$(hostname):0 
```

For any technical assistance, please contac:
1. Ezra Kissel <ezkissel@indiana.edu>
2. Kamal K Saha <ksaha@nd.edu>
3. Luke D'Alessandro <ldalessa@uw.edu>
