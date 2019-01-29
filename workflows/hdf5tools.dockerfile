# Docker container for converting eQTL summary statistics to mash format

# This is the base Docker image for a basic R and Python environment.
FROM gaow/lab-base

MAINTAINER Gao Wang, gaow@uchicago.edu

WORKDIR /tmp

# Install HDF5 library.
RUN apt-get update \
  && apt-get -y install hdf5-tools \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# Install R HDF5 library "rhdf5".
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("rhdf5", suppressUpdates=TRUE)' \
    && rm -rf *

# Install Python HDF5 library "pytables".
# Install SoS for workflow execution.
RUN pip install --no-cache-dir tables sos sos-pbs sos-notebook sos-bash jupyter_contrib_nbextensions && rm -rf $HOME/.cache

# Default command.
CMD ["bash"]
