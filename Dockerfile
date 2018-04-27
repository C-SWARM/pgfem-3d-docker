FROM gcc:7

MAINTAINER Ezra Kissel <ezkissel@indiana.edu>

RUN apt-get update
RUN apt-get -y install openmpi-bin libopenmpi-dev git paraview cmake numdiff cpio sudo libxaw7

ENV INTEL_MKL=l_mkl_2018.2.199.tgz
ENV SUITESPARSE=SuiteSparse-5.1.0.tar.gz
ENV HYPRE=hypre-2.11.2.tar.gz

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/cswarm && \
    echo "cswarm:x:${uid}:${gid}:C-SWARM,,,:/home/cswarm:/bin/bash" >> /etc/passwd && \
    echo "cswarm:x:${uid}:" >> /etc/group && \
    echo "cswarm ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/cswarm && \
    chmod 0440 /etc/sudoers.d/cswarm && \
    chown ${uid}:${gid} -R /home/cswarm && \
    chown ${uid}:${gid} -R /opt

USER cswarm
ENV HOME /home/cswarm
WORKDIR $HOME

RUN curl -O http://kanar.open.sice.indiana.edu/images/$INTEL_MKL
RUN curl -O http://faculty.cse.tamu.edu/davis/SuiteSparse/$SUITESPARSE
RUN curl -O https://computation.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods/download/$HYPRE

RUN git clone -b develop https://github.com/C-SWARM/ttl.git
RUN git clone -b develop https://github.com/C-SWARM/gcm.git
RUN git clone -b develop https://github.com/C-SWARM/pgfem-3d.git
RUN git clone -b master https://github.com/C-SWARM/pgfem-3d-examples.git

ADD mkl_silent.cfg .

RUN tar -xf $INTEL_MKL
RUN ${INTEL_MKL%.*}/install.sh -s ./mkl_silent.cfg

ADD build.sh .
RUN bash ./build.sh

RUN rm -f $INTEL_MKL $SUITESPARSE $HYPRE
