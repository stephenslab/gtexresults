# Docker container for running the analyses the GTEx data in Urbut,
# Wang & Stephens (2017).

# This is the base Docker image for a basic R + Python + SoS environment.
FROM gaow/base-notebook:1.0.0

MAINTAINER Gao Wang, wang.gao@columbia.edu

USER root
WORKDIR /tmp

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

# Additional packages needed for mashr analysis.
RUN Rscript -e 'install.packages(c("mclust", "plyr"), repos="https://cloud.r-project.org")'

# Install ebnm.
ENV EBNM_VERSION a3a20b01c1c2292d17fe26e15da04bbcb8c01082
RUN Rscript -e 'remotes::install_github("stephenslab/ebnm", ref = "'${EBNM_VERSION}'")' \
    && rm -rf *

# Install flashr.
ENV FLASHR_VERSION ae44e7d5d5b77c3cd70043ee4c74d801b524ec46
RUN Rscript -e 'remotes::install_github("stephenslab/flashr", ref = "'${FLASHR_VERSION}'")' \
    && rm -rf *

# Install mashr package, a fast implementation of MASH algorithm.

RUN wget ftp://ftp.gnu.org/gnu/gsl/gsl-1.7.tar.gz && tar -zxvf gsl-1.7.tar.gz && cd gsl-1.7 && ./configure && make && make install \
    && cd - && rm -rf *

ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH
ENV MASHR_VERSION ca00f16f6cd109765f184df316a28469fc6f2e03
RUN Rscript -e 'remotes::install_github("stephenslab/mashr", ref = "'${MASHR_VERSION}'")' \
    && rm -rf *

# Default command.
CMD ["bash"]

# docker build -t gaow/mash-paper -f mash.dockerfile .
