# Docker container for running the analyses the GTEx data in Urbut,
# Wang & Stephens (2017).

# This is the base Docker image for a basic R + Python + SoS environment.
FROM gaow/base-notebook:1.0.0

MAINTAINER Gao Wang, gaow@uchicago.edu

USER root
WORKDIR /tmp

# Install GSL (for SFA).
RUN apt-get update \
  && apt-get -y install libgsl-dev libgslcblas0 \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# Install MOSEK, Rmosek and REBayes (to set up running the analysis
# with the new mashr package).
ENV PATH /opt/mosek/8/tools/platform/linux64x86/bin:$PATH
ENV MOSEK_VERSION 8.1.0.49
RUN curl https://download.mosek.com/stable/${MOSEK_VERSION}/mosektoolslinux64x86.tar.bz2 -o mosek.tar.bz2 \
    && tar jxf mosek.tar.bz2 && mv mosek /opt && rm -rf *
RUN Rscript -e 'install.packages("Rmosek", type="source", INSTALL_opts="--no-multiarch",\
    configure.vars="PKG_MOSEKHOME=/opt/mosek/8/tools/platform/linux64x86 PKG_MOSEKLIB=mosek64",\
    repos="http://download.mosek.com/R/8")' \
    && Rscript -e 'install.packages("REBayes", repos="https://cloud.r-project.org")' && rm -rf *

# Install SFA.
ENV SFA_VERSION 1.0
RUN curl http://stephenslab.uchicago.edu/assets/software/sfa/sfa${SFA_VERSION}.tar.gz -o sfa.tar.gz \
    && ln -s /usr/lib/x86_64-linux-gnu/libgsl.so /usr/lib/x86_64-linux-gnu/libgsl.so.0 \
    && tar zxf sfa.tar.gz && mv sfa /opt && rm -rf *

# Install MASH code (to reproduce Urbut et al 2017 paper).
ENV PAPER_VERSION 0.2-1
RUN Rscript -e 'install.packages(c("mvtnorm", "SQUAREM", "gplots", "colorRamps"), repos="https://cloud.r-project.org")'
RUN curl -L https://github.com/stephenslab/mashr-paper/archive/v${PAPER_VERSION}.zip -o mash.zip \
    && unzip mash.zip && mv mashr-paper-${PAPER_VERSION}/R /opt/mash-paper && rm -rf *

# Install remotes package.
RUN Rscript -e 'install.packages(c("remotes"), repos="https://cloud.r-project.org")' \
    && rm -rf *

# Install mixSQP.
ENV MIXSQP_VERSION fce876ef8dacbb148650c6cdd788d3e6e453a8ba
RUN Rscript -e 'remotes::install_github("stephenslab/mixsqp", ref = "'${MIXSQP_VERSION}'")' \
    && rm -rf *

# Install ashr.
ENV ASHR_VERSION e8a7abc419b58efedca9010ccae5858c8a490876
RUN Rscript -e 'remotes::install_github("stephens999/ashr", ref = "'${ASHR_VERSION}'")' \
    && rm -rf *

# Install flashr.
ENV FLASHR_VERSION ae44e7d5d5b77c3cd70043ee4c74d801b524ec46
RUN Rscript -e 'remotes::install_github("stephenslab/flashr", ref = "'${FLASHR_VERSION}'")' \
    && rm -rf *

# Install mashr package, a fast implementation of MASH algorithm.
# and additional packages needed for mashr analysis.
RUN Rscript -e 'install.packages(c("mclust", "plyr"), repos="https://cloud.r-project.org")'
ENV MASHR_VERSION 054d4cdb9308d34cae7617506b9dea3bbb78cd7f
RUN Rscript -e 'remotes::install_github("stephenslab/mashr", ref = "'${MASHR_VERSION}'")' \
    && rm -rf *

ENV R_ENVIRON_USER ""
ENV R_PROFILE_USER ""
ENV R_LIBS_USER ""

# Default command.
CMD ["bash"]
