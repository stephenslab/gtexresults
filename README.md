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

Copyright (c) 2016-2018, Sarah Urbut.

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
libraries, and requires downloading several large data sets. To
facilitate reproducing our results, we have developed a
[Docker container](https://hub.docker.com/r/gaow/mash-paper) that
includes all software components necessary to run the analyses. Docker
can run on most popular operating systems (Mac, Windows and Linux) so
long as you have administrator access. It also runs on cloud computing
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
and other computing environment setup steps.*

### 1. Download and install Docker

Download [Docker](https://docs.docker.com/install) (note that a free
[community edition](https://www.docker.com/community-edition) of
Docker is available), and install it following the instructions
provided on the Docker website. Once you have installed Docker, check
that Docker is working correctly by working through the
[Part 1 of the Getting Started guide](https://docs.docker.com/get-started).
If you are using Docker for the first time, we recommend reading the
entire Getting Started guide. *Note that setting up Docker requires
that you have administrator access to your computer.*

### 2. Download and test Docker image

Run these commands in the shell, which will download the Docker
image if it has not already been downloaded, then run a simple command
in the Docker container to check that the container loads
successfully.

```bash
alias mash-docker='docker run --security-opt label:disable -t -P '\
'-w $PWD -v $HOME:/home/docker -v /tmp:/tmp -v $PWD:$PWD gaow/mash-paper'
mash-docker uname -a
```

The `-v` flags in this command map directories between the standard
computing environment and the Docker container. Since the analyses
below will write files to these directories, it is important to ensure
that:

  + Environment variables `$HOME` and `$PWD` are set to valid and
    writeable directories (usually your home and current working
    directories, respectively).

  + `/tmp` should also be a valid and writeable directory.

If any of these statements are not true, please adjust the `alias`
accordingly.

Additionally, we have found that the `-u $UID` option is sometimes
helpful to ensure that the new files are created under your user
account. If, after running the analyses, you encounter issues with
file permissions or file ownership, consider adding `-u $UID` to the
above `alias` command and re-run the analyses.

If the container was successfully run, you should see information
about the Linux operating system outputted to the screen, something
like this:

```
Linux gtex-results-for-mash-paper 3.16.0-4-amd64 #1 SMP 
Debian 3.16.43-2+deb8u2 (2017-06-26) x86_64 GNU/Linux
```

You can also run these commands to show the image downloaded to your
computer, and show the container that has ran (and exited):

```bash
docker image ls
docker container ls --all
```

*Note:* If you get error "Cannot connect to the Docker daemon. Is the
docker daemon running on this host?" in Linux or macOS, see
[here for Linux](https://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo)
or [here for Mac](https://github.com/wodby/docker4drupal/issues/15) for
suggestions on how to resolve this issue.

### 3. Clone or download this repository

Clone or download the `gtexresults` repository to your computer, then
change your working directory in the shell to the root of the
repository. After doing this, running `ls -1` should show the
top-level contents of this repository:

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

### 4. Add description of step 4 here.

Under the repo you will find `workflows/gtex6_mash_analysis.ipynb` 
to reproduce the GTEx results in Figures ? and ?.

To show what analysis are available,

```bash
mash-docker sos run workflows/gtex6_mash_analysis.ipynb -h
```

To read what's available, run:

```bash
mash-docker sos run workflows/gtex6_mash_analysis.ipynb export
```

and read the HTML files `gtex6_workflow_output/gtex6_mash_analysis.lite.html` and 
`gtex6_workflow_output/gtex6_mash_analysis.full.html`

To run default (the MASH prototype) analysis,

```bash
mash-docker sos run workflows/gtex6_mash_analysis.ipynb
```

All intermediate and final output should be saved to a folder called
`gtex6_workflow_output`. Particularly you may want to checkout
`gtex6_workflow_output/gtex6_mash_analysis.html` which contains the
complete analysis procedure.

*To do: Add instructions for pruning containers that have exited. See
 also
 [here](https://stackoverflow.com/questions/17014263/should-i-be-concerned-about-excess-non-running-docker-containers).*

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

## Instructions (less simple)

*Explain briefly what software/libraries need to be installed if you
prefer not to use Docker (or because you can't).*

Software involved for MASH analysis are SFA, ExtremeDeconvolution,
MOSEK, OpenMP, OpenBLAS and the GNU Scientific Library. Software
involved for summary statistics formatting are HDF5 tools, pytables
and rhdf5. Workflow system SoS is used to run the pipelines.  An
improved MASH implementation `mashr` is also installed.

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
