# Docker container for running the analyses the GTEx data in Urbut,
# Wang & Stephens (2017).

# This is the base Docker image. It configures basic R and Python
# environments to run related pipelines.
FROM gaow/lab-base

MAINTAINER Gao Wang, gaow@uchicago.edu

# These are the versions of the software used to run the analyses.
ENV MOSEK_VERSION 8.1.0.49
ENV GSL_VERSION 2.4
ENV ED_VERSION master
ENV SFA_VERSION 1.0
ENV PAPER_VERSION 0.2-1
ENV MASHR_VERSION 0.2-6
ENV PATH /opt/mosek/8/tools/platform/linux64x86/bin:$PATH
ENV LD_LIBRARY_PATH /opt/miniconda3/lib:$LD_LIBRARY_PATH

WORKDIR /tmp

## Install rhdf5 library.
RUN Rscript -e 'source("https://bioconductor.org/biocLite.R"); biocLite("rhdf5", suppressUpdates=TRUE)' \
    && rm -rf *

## Install GSL and HDF5 tools.
RUN conda update -n base conda \
    && conda install -c conda-forge -y --no-deps gsl=${GSL_VERSION} hdf5 openblas blas \
    && conda clean --all -tipsy

## Install SFA.
RUN curl http://stephenslab.uchicago.edu/assets/software/sfa/sfa${SFA_VERSION}.tar.gz -o sfa.tar.gz \
    && ln -s /opt/miniconda3/lib/libgsl.so.23.0.0 /lib/x86_64-linux-gnu/libgsl.so.0 \
    && tar zxf sfa.tar.gz && mv sfa /opt && rm -rf *

## Install Extreme Deconvolution R package.
## Here I manually link it to openblas for a speed-up
RUN curl -L https://github.com/jobovy/extreme-deconvolution/archive/${ED_VERSION}.zip -o ed.zip \
    && unzip ed.zip && cd extreme-deconvolution-${ED_VERSION} \
    && cp src/*.h src/*.c r/src && patch r/src/proj_gauss_mixtures_IDL.c < r/src/proj_gauss_mixtures_R.patch \
    && sed -i 's/^PKG_CFLAGS.*$/PKG_CFLAGS = -std=c99 -fPIC -fopenmp -shared -I. -Isrc -I\/opt\/miniconda3\/include/' \
       r/src/Makefile \
    && sed -i 's/^PKG_CLIBS.*$/PKG_CLIBS = -L\/opt\/miniconda3\/lib -lm -lgsl -lopenblas -lgomp/' \
       r/src/Makefile \
    && Rscript -e "devtools::install('r/')" && rm -rf /tmp/*

## Install MOSEK, Rmosek and REBayes (to set up running the analysis with the new mashr package).
RUN curl https://download.mosek.com/stable/${MOSEK_VERSION}/mosektoolslinux64x86.tar.bz2 -o mosek.tar.bz2 \
    && tar jxf mosek.tar.bz2 && mv mosek /opt && rm -rf *
RUN Rscript -e 'install.packages("Rmosek", type="source", INSTALL_opts="--no-multiarch",\
    configure.vars="PKG_MOSEKHOME=/opt/mosek/8/tools/platform/linux64x86 PKG_MOSEKLIB=mosek64",\
    repos="http://download.mosek.com/R/8")' \
    && install.R REBayes && rm -rf *

## Install mashr package, a fast implementation of MASH algorithm.
RUN Rscript -e 'devtools::install_github("stephenslab/mashr@v'${MASHR_VERSION}'")'

## Install MASH code (to reproduce Urbut et al 2017 paper).
RUN curl -L https://github.com/stephenslab/mashr-paper/archive/v${PAPER_VERSION}.zip -o mash.zip \
    && unzip mash.zip && mv mashr-paper-${PAPER_VERSION}/R /opt/mash-paper && rm -rf *
RUN install.R mvtnorm SQUAREM gplots colorRamps && rm -rf *

## Install SoS for workflow execution.
RUN pip install --no-cache-dir sos sos-pbs && rm -rf $HOME/.cache

# Default command.
CMD ["bash"]
