# Docker container for running the analyses the GTEx data in Urbut,
# Wang & Stephens (2017).

# This is the base Docker image for a basic R and Python environment.
FROM gaow/lab-base

MAINTAINER Gao Wang, gaow@uchicago.edu

# These are the versions of the software used to run the analyses.
ENV PATH /opt/mosek/8/tools/platform/linux64x86/bin:$PATH
WORKDIR /tmp

# Install GSL (for SFA).
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

# Install SoS for workflow execution.
RUN pip install --no-cache-dir sos sos-pbs sos-notebook sos-bash jupyter_contrib_nbextensions && rm -rf $HOME/.cache

# Install mixSQP.
ENV MIXSQP_VERSION a6b817e327fdc3f33fe06eb97da29958c9b3883f
RUN Rscript -e 'devtools::install_github("stephenslab/mixsqp", ref = "'${MIXSQP_VERSION}'")' \
    && rm -rf *

# Install ashr.
ENV ASHR_VERSION 53830effe3db7ba61683de7a0b0f268a90c662cf
RUN Rscript -e 'devtools::install_github("stephens999/ashr", ref = "'${ASHR_VERSION}'")' \
    && rm -rf *

# Install flashr.
ENV FLASHR_VERSION f9407735986ae644ce0e60c4264d48dbc13f0b95
RUN Rscript -e 'devtools::install_github("stephenslab/flashr", ref = "'${FLASHR_VERSION}'")' \
    && rm -rf *

# Install mashr package, a fast implementation of MASH algorithm.
# and additional packages needed for mashr analysis.
RUN install.R mclust plyr
ENV MASHR_VERSION 790036f16622b4dd66cf16a4be5c24e97043b0ea
RUN Rscript -e 'devtools::install_github("stephenslab/mashr", ref = "'${MASHR_VERSION}'")' \
    && rm -rf *

# Prevent local packages from being loaded
ENV R_LIBS_USER ' '

# Default command.
CMD ["bash"]
