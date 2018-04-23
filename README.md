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

## Setup instructions (simpler)

To reproduce the results of Urbut, Wang & Stephens (2017), please
follow these steps.

The complete analyses require installation of several programs and libraries.
To facilitate reproducing our results, we have developed a 
[Docker container](https://hub.docker.com/r/gaow/mash-paper)
for the required software components. Refer to the 
[Dockerfile](workflows/Dockerfile) to see how the Docker container was configured.
Note that this Docker container was developed on top of 
[gaow/lab-base](https://hub.docker.com/r/gaow/lab-base), a customized 
R and Python container.

If you prefer to run the analyses without Docker, please see the
"less simple" setup instructions below, which explain what software
and libraries need to be installed to run the analyses.

1. Install
[Docker community edition](https://www.docker.com/community-edition),
following the instructions provided on the Docker website, and
check that Docker is working correctly, again following the steps
given on the Docker website. *Note that setting up Docker
requires that you have administrator access to your computer.*

2. Run this command in the shell (this must be fit onto one line):

```bash
alias mash-docker='docker run --rm --security-opt label:disable -t -P -w $PWD -u $UID:${GROUPS[0]} -v $USER:/home/docker -v /tmp:/tmp -v $PWD:$PWD gaow/mash-paper'
```

*TO DO: Explain here what this command does.*

To test out this command, run:

```bash
mash-docker pwd 
```

An automatic download for the `mash-paper` docker image will
start at this point if it is the first time you run it.
To double-check the image is installed, run this:

```bash
docker images
```

> Note that on some systems you may get an error 
> `Cannot connect to the Docker daemon. Is the docker daemon running on this host?`. 
> This can be solved simply by running Docker command as `root` (eg, via `sudo docker run`). 
> However we strongly advice against it because it will produce files that only `root` can access.
> You may find online some tips (for [Linux](https://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo) and for [Mac](https://github.com/wodby/docker4drupal/issues/15)) to allow you run Docker without `sudo`

## Run MASH to reproduce GTEx results for Urbut et al 2017

Under the repo you will find `workflows/gtex6_mash_analysis.ipynb` 
to reproduce the GTEx results in Figures ? and ?.

To show what analysis are available,

```bash
mash-docker sos run workflows/gtex6_mash_analysis.ipynb -h
```

To run default (the MASH prototype) analysis,

```bash
mash-docker sos run workflows/gtex6_mash_analysis.ipynb
```

All intermediate and final output should be saved to a folder called
`gtex6_workflow_output`. Particularly you may want to checkout
`gtex6_workflow_output/gtex6_mash_analysis.html` which contains the
complete analysis procedure.

## Convert eQTL summary statistics to MASH format

Under the repo you will find `workflows/fastqtl_to_mash.ipynb` 
to convert eQTL summary statistics (default to `fastqtl` format) to MASH format. 
Computation is configured to run in parallel for eQTL results from multiple studies. Example data-set 
can be found at `data/eQTLDataDemo`. The workflow file is documented in itself, and has a few options 
to customize the input and output.

To read what's available, run:

```bash
mash-docker sos run workflows/fastqtl_to_mash.ipynb export
```

and read the HTML file `gtex6_workflow_output/fastqtl_to_mash.html`.

To run the conversion:

```bash
mash-docker sos run workflows/fastqtl_to_mash.ipynb \
  --data_list data/eQTLDataDemo/FastQTLSumStats.list \
  --gene_list data/eQTLDataDemo/GTEx_genes.txt
```

In practice for GTEx data the conversion is computationally intensive and is best done on a cluster environment with 
[configurations to run the workflow across different nodes](https://vatlab.github.io/sos-docs/doc/documentation/Remote_Execution.html).

## Setup instructions (less simple)

*Explain briefly what software/libraries need to be installed if you
prefer not to use Docker (or because you can't).*

Software involved for MASH analysis are SFA, ExtremeDeconvolution, MOSEK, 
OpenMP, OpenBLAS and the GNU Scientific Library. Software involved for summary statistics
formatting are HDF5 tools, pytables and rhdf5. Workflow system SoS is used to run the pipelines. 
An improved MASH implementation `mashr` is also installed.

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
