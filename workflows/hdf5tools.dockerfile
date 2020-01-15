# Docker container for converting eQTL summary statistics to mash format

# This is the base Docker image for a basic R + Python + SoS environment.
FROM gaow/base-notebook:1.0.0

MAINTAINER Gao Wang, gaow@uchicago.edu

USER root
WORKDIR /tmp

# Install HDF5 library.
RUN apt-get update \
  && apt-get -y install hdf5-tools \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# Install R HDF5 library "rhdf5".
RUN Rscript -e 'install.packages("BiocManager", repos="https://cloud.r-project.org"); BiocManager::install("rhdf5",update=F,ask=F)' \
    && rm -rf *

# Install Python dependencies.
RUN pip install --no-cache-dir tables scipy pandas && rm -rf $HOME/.cache

# Default command.
CMD ["bash"]
