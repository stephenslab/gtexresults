# Source to reproduce results from Urbut, Wang & Stephens (2017)

This repository contains source code to produce results from Urbut,
Wang & Stephens (2017). If you are primarily interested in applying
the statistical methods to your own data, please see the
[mashr package](https://github.com/stephenslab/mashr).

If you find a bug, please post an
[issue](https://github.com/stephenslab/gtexresults/issues).

This code has been tested in...

## Citing this work

If you find any of the source code in this repository useful for your
work, please cite our paper:

> Sarah M. Urbut, Gao Wang and Matthew Stephens (2017). *Flexible
> statistical methods for estimating and testing effects in genomic
> studies with multiple conditions.* bioRxiv
> [doi:10.1101/096552](http://dx.doi.org/10.1101/096552).

## License

Copyright (c) 2016-2018, Sarah Urbut, Gao Wang, Peter Carbonetto and
Matthew Stephens.

All source code and software in this repository are made available
under the terms of the
[MIT license](https://opensource.org/licenses/mit-license.html). See
the [LICENSE](LICENSE) file for the full text of the license.

## What's included

*Give brief overview of the files in this repository.*

## Instructions

To reproduce the results of Urbut, Wang & Stephens (2017), please
follow these steps.

The complete analyses require installation of several programs and
libraries, and requires several large data sets. To facilitate 
reproducing our results, we provide pre-processed data for use with 
the core analysis, and a bioinformatics pipeline with a small toy 
data-set to demonstrate the pre-processing step. We have also developed a
[Docker container](https://hub.docker.com/r/gaow/mash-paper) that
includes all software components necessary to run the analyses. Docker
can run on most popular operating systems (Mac, Windows and Linux).
It also runs on cloud computing
services such as Amazon Web Services and Microsoft Azure. If you have
not used Docker before, you might want to read
[this](https://docs.docker.com/engine/docker-overview) to learn the
basic concepts and understand the benefits of Docker.

For details on how the Docker image was configured, see the
[Dockerfile](workflows/Dockerfile). The Docker image used for our
analyses is based on
[gaow/lab-base](https://hub.docker.com/r/gaow/lab-base), a Docker
image for development with R and Python.

If you prefer to run the analyses without Docker, *add a few details
about where you can find out more about software and libraries used,
and other computing environment setup steps (mention Python 3.x, R, SFA,
ExtremeDeconvolution, MOSEK, OpenMP, OpenBLAS, GSL, HDF5 tools,
pytables rhdf5, and for an improved MASH implementation mashr is also
installed).*

### 1. Download and install Docker

Download [Docker](https://docs.docker.com/install) (note that a free
[community edition](https://www.docker.com/community-edition) of
Docker is available), and install it following the instructions
provided on the Docker website. Once you have installed Docker, check
that Docker is working correctly by following
[Part 1 of the Getting Started guide](https://docs.docker.com/get-started).
If you are using Docker for the first time, we recommend reading the
entire Getting Started guide. *Note that setting up Docker requires
that you have administrator access to your computer.*
([Singularity](https://singularity.lbl.gov/docs-docker) is an
alternative that accepts Docker images and does not require
administrator access.)

### 2. Download and test Docker image

Run this `alias` command in the shell, which will be used below to run
commands inside the Docker container:

```bash
alias mash-docker='docker run --security-opt label:disable -t -P -h MASH '\
'-w $PWD -v $HOME:/home/$USER -v /tmp:/tmp -v $PWD:$PWD '\
'-u $UID:${GROUPS[0]} -e HOME=/home/$USER -e USER=$USER gaow/mash-paper'
```

The `-v` flags in this command map directories between the standard
computing environment and the Docker container. Since the analyses
below will write files to these directories, it is important to ensure
that:

  + Environment variables `$HOME`, `$USER` and `$PWD` are set to valid and
    writeable directories (usually your home and current working
    directories, respectively).

  + `/tmp` should also be a valid and writeable directory.

If any of these statements are not true, please adjust the `alias`
accordingly. The remaining options only affect operation of the
container, and so should function the same regardless of your operating
system.

Next, run a simple command in the Docker container to check that has
loaded successfully:

```
mash-docker uname -sn
```

This command will download the Docker image if it has not already been
downloaded.

If the container was successfully run, you should see this information
about the Docker container outputted to the screen:

```
Linux MASH
```

You can also run these commands to show the information about the
image downloaded to your computer and the container that has run
(and exited):

```bash
docker image list
docker container list --all
```

*Note:* If you get error "Cannot connect to the Docker daemon. Is the
docker daemon running on this host?" in Linux or macOS, see
[here for Linux](https://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo)
or [here for Mac](https://github.com/wodby/docker4drupal/issues/15) for
suggestions on how to resolve this issue.

### 3. Clone or download this repository

Clone or download the `gtexresults` repository to your computer, then
change your working directory in the shell to the root of the
repository, e.g.,

```bash
cd gtexresults
```

After doing this, running `ls -1` should show the top-level contents
of this repository:

```
LICENSE
README.md
TODO.txt
analysis
data
docs
output
workflows
```

All commands below will be run from this directory.

### 4. Add title of step 4 here.

Assuming your working directory is the root of the git repository (you
can check by running `pwd`), run all the steps of the analysis with
this command:

```bash
mash-docker sos run workflows/gtex6_mash_analysis.ipynb
```

This command will take several hours to run—see below for more
information on the individual steps. All outputs generated by this
command will be saved to folder `gtex6_workflow_output` inside the
repository.

Note that you may recognize this file as a Jupyter notebook. Indeed,
you may open this notebook in Jupyter. However, you should not step
through the code sequentially as you would in a typical Jupyter
notebook; this is because the code in this notebook is meant to be run
using the [Script of Scripts (SoS)](https://github.com/vatlab/SoS)
framework.

This command will execute

+ Compute a sparse factorization of the (centered) z-scores using the
  [SFA software](http://stephenslab.uchicago.edu/software.html#sfa),
  with K = 5 factors, and save the factors in an `.rds` file. This
  will be used to construct the mixture-of-multivariate normals
  prior.

+ Compute additional "data-driven" prior matrices by computing a
  singular value decomposition of the (centered) z-scores and
  low-rank approximations to the empirical covariance matrices. *TO
  DO: Explain where results/outputs are saved.*

Finally, note that all containers that have run and exited will still
be retained in the Docker system. Run `docker container list --all` to
list all previous run containers. To clear these previously run
containers, run `docker container prune`. See
[here](https://stackoverflow.com/questions/17014263/should-i-be-concerned-about-excess-non-running-docker-containers)
for more information.

## More detailed usage notes

Above we have given the minimal instructions necessary to reproduce
the results of. Here are some additional details about the 

Things that will go here:

+ Explain how to get a summary of the possible analysis steps that can
  be run.

+ See the Jupyter notebook to get more details; how the notebook
  should be interpreted.

+ Explain how to run the analysis using the improved (faster)
  implementation of the [mashr R
  package](https://github.com/stephenslab/mashr).

## Convert eQTL summary statistics to MASH format

Under the repo you will find `workflows/fastqtl_to_mash.ipynb` to
convert eQTL summary statistics (default to `fastqtl` format) to MASH
format.  Computation is configured to run in parallel for eQTL results
from multiple studies. Example data-set can be found at
`data/eQTLDataDemo`. The workflow file is documented in itself, and
has a few options to customize the input and output.

To read what's available, run:

```bash
mash-docker sos run workflows/fastqtl_to_mash.ipynb export
```

and read the HTML files `gtex6_workflow_output/fastqtl_to_mash.lite.html` and 
`gtex6_workflow_output/fastqtl_to_mash.full.html`

To run the conversion:

```bash
mash-docker sos run workflows/fastqtl_to_mash.ipynb \
  --data_list data/eQTLDataDemo/FastQTLSumStats.list \
  --gene_list data/eQTLDataDemo/GTEx_genes.txt
```

In practice for GTEx data the conversion is computationally intensive
and is best done on a cluster environment with
[configurations to run the workflow across different nodes](https://vatlab.github.io/sos-docs/doc/documentation/Remote_Execution.html).

## Other setup notes

Run the following command to update the Docker image:

```bash
docker pull gaow/mash-paper
```

### Figure plotting

**FIXME: update figure plotting instructions**

The input data necessary to run this analysis is
all available under inputs. This may take some time to run.
We have provided
the outputs of running mash in `Data_vhat`.

This repo is organized so that you can run Mash using the gteX data
contained in **Inputs** to produce the parameters and posteriors from
mashr.

The directory **Plots_for_Paper_vmat** contains .Rmd files to plot figures from the paper,
using our results which are provided in **Results_Data**. 

[Here is the link to the index](https://stephenslab.github.io/gtexresults_mash)
discussing the reproduction of all of the plots.

## Contributors

This project was developed by
[Sarah Urbut](https://github.com/surbut),
[Gao Wang](https://github.com/gaow) and
[Matthew Stephens](stephenslab.uchicago.edu) at the University of
Chicago, with contributions from [Peter Carbonetto](http://pcarbo.github.io).
