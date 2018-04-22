# Docker container for running the analyses the GTEx data in Urbut,
# Wang & Stephens (2017).

# This is the base Docker image. It configures basic R and Python
# environments to run related pipelines.
FROM gaow/lab-base

MAINTAINER Gao Wang, gaow@uchicago.edu

# These are the versions of the software used to run the analyses.
ENV SFAVERSION 1.0
ENV MOSEK_VERSION 8.1.0.49
ENV MASHVERSION 0.2-1
ENV MASHRVERSION 0.2-6
ENV EDVERSION master
ENV PATH /opt/mosek/8/tools/platform/linux64x86/bin:$PATH
ENV MOSEKLM_LICENSE_FILE $HOME/.mosek.lic

WORKDIR /tmp
ADD http://stephenslab.uchicago.edu/assets/software/sfa/sfa${SFAVERSION}.tar.gz sfa.tar.gz
ADD https://download.mosek.com/stable/${MOSEK_VERSION}/mosektoolslinux64x86.tar.bz2 ./
ADD https://github.com/stephenslab/mashr-paper/archive/v${MASHVERSION}.zip mash.zip
ADD https://github.com/jobovy/extreme-deconvolution/archive/${EDVERSION}.zip ed.zip

## Install OpenMP, GSL and HDF5 library
RUN apt-get -qq update \
  && apt-get -qq -y install libgomp1 libgsl-dev hdf5-tools \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

## Install Extreme Deconvolution R package.
RUN unzip ed.zip && cd extreme-deconvolution-${EDVERSION} \
  && make && make rpackage && R CMD INSTALL ExtremeDeconvolution_1.3.tar.gz

## Install SFA.
RUN ln -s /lib/x86_64-linux-gnu/libgsl.so.23.0.0 \
  /lib/x86_64-linux-gnu/libgsl.so.0
RUN tar zxf sfa.tar.gz && mv sfa /opt

## Install MASH code (to reproduce Urbut et al 2017 paper).
RUN unzip mash.zip && mv mashr-paper-${MASHVERSION}/R /opt/mash-paper
RUN install.r mvtnorm SQUAREM gplots colorRamps

## Install MOSEK, Rmosek and REBayes (to set up running the analysis with the new mashr package).
RUN tar jxf mosektoolslinux64x86.tar.bz2 && mv mosek /opt
RUN Rscript -e 'install.packages("Rmosek", type="source", INSTALL_opts="--no-multiarch",\
    configure.vars="PKG_MOSEKHOME=/opt/mosek/8/tools/platform/linux64x86 PKG_MOSEKLIB=mosek64",\
    repos="http://download.mosek.com/R/8")'
RUN Rscript -e 'install.packages("REBayes")'

## Install mashr package, a fast implementation of MASH algorithm.
RUN Rscript -e 'devtools::install_github("stephenslab/mashr@v'${MASHRVERSION}'")'

## Install HDF5 libraries for Python and R.
RUN conda install pytables
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("rhdf5", suppressUpdates=TRUE)'

## Clean up.
RUN rm -rf *

# Default command.
CMD ["bash"]