# Docker container for running the analyses the GTEx data in Urbut,
# Wang & Stephens (2017).

# This is the base Docker image for a basic R and Python environment.
FROM gaow/lab-base

MAINTAINER Gao Wang, gaow@uchicago.edu

# These are the versions of the software used to run the analyses.
ENV PATH /opt/mosek/8/tools/platform/linux64x86/bin:$PATH
WORKDIR /tmp

# Install GSL (for SFA)
RUN apt-get update \
  && apt-get -y install libgsl-dev libgsl2 \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# Install MOSEK, Rmosek and REBayes (to set up running the analysis
# with the new mashr package).
ENV MOSEK_VERSION 8.1.0.49
RUN curl https://download.mosek.com/stable/${MOSEK_VERSION}/mosektoolslinux64x86.tar.bz2 -o mosek.tar.bz2 \
    && tar jxf mosek.tar.bz2 && mv mosek /opt && rm -rf *
RUN Rscript -e 'install.packages("Rmosek", type="source", INSTALL_opts="--no-multiarch",\
    configure.vars="PKG_MOSEKHOME=/opt/mosek/8/tools/platform/linux64x86 PKG_MOSEKLIB=mosek64",\
    repos="http://download.mosek.com/R/8")' \
    && install.R REBayes && rm -rf *

# Install Extreme Deconvolution R package.
ENV ED_VERSION master
RUN curl -L https://github.com/jobovy/extreme-deconvolution/archive/${ED_VERSION}.zip -o ed.zip \
    && unzip ed.zip && cd extreme-deconvolution-${ED_VERSION} \
    && cp src/*.h src/*.c r/src && patch r/src/proj_gauss_mixtures_IDL.c < r/src/proj_gauss_mixtures_R.patch \
    && Rscript -e "devtools::install('r/')" && rm -rf /tmp/*

# Install SFA.
ENV SFA_VERSION 1.0
RUN curl http://stephenslab.uchicago.edu/assets/software/sfa/sfa${SFA_VERSION}.tar.gz -o sfa.tar.gz \
    && ln -s /usr/lib/x86_64-linux-gnu/libgsl.so /usr/lib/x86_64-linux-gnu/libgsl.so.0 \
    && tar zxf sfa.tar.gz && mv sfa /opt && rm -rf *

# Install MASH code (to reproduce Urbut et al 2017 paper).
ENV PAPER_VERSION 0.2-1
RUN install.R mvtnorm SQUAREM gplots colorRamps && rm -rf *
RUN curl -L https://github.com/stephenslab/mashr-paper/archive/v${PAPER_VERSION}.zip -o mash.zip \
    && unzip mash.zip && mv mashr-paper-${PAPER_VERSION}/R /opt/mash-paper && rm -rf *

# Install mashr package, a fast implementation of MASH algorithm.
# and additional packages needed for mashr analysis.
RUN install.R mclust plyr
ENV MASHR_VERSION b5bf7e742e46fd02520bb40735267cd0f2552ccb
RUN Rscript -e 'devtools::install_github("stephenslab/mashr", ref = "'${MASHR_VERSION}'")' \
    && rm -rf *

# Install flashr.
ENV FLASHR_VERSION 5e84f8051ae9e97ca419f13c02e78e192fe55cb4
RUN Rscript -e 'devtools::install_github("stephenslab/flashr", ref = "'${FLASHR_VERSION}'")' \
    && rm -rf *

# Install SoS for workflow execution.
RUN pip install --no-cache-dir sos sos-notebook jupyter_contrib_nbextensions && rm -rf $HOME/.cache

# Default command.
CMD ["bash"]