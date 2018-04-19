# Source to reproduce results from Urbut, Wang & Stephens (2017)

This repository contains source code to produce results from Urbut,
Wang & Stephens (2017). If you are primarily interested in applying
the statistical methods to your own data, please see the
[mashr package](https://github.com/stephenslab/mashr).

## Citing this work

If you find any of the source code in this repository useful for your
work, please cite our paper:

> Sarah M. Urbut, Gao Wang and Matthew Stephens (2017). *Flexible
> statistical methods for estimating and testing effects in genomic
> studies with multiple conditions.* bioRxiv
> [doi:10.1101/096552](http://dx.doi.org/10.1101/096552).

## License

Copyright (c) 2017-2018, Sarah Urbut.

All source code and software in this repository are made available
under the terms of the
[MIT license](https://opensource.org/licenses/mit-license.html). See
the [LICENSE](LICENSE) file for the full text of the license.

## Instructions

We use a docker container to facilitate reproducing our computational
experiments and analysis procedures. Here is the
[docker file](workflows/Dockerfile) showing how the container is
configured. Note that it is built on top of another docker image
[gaow/lab-base](https://hub.docker.com/r/gaow/lab-base), which is
based on [rocker/rbase](https://hub.docker.com/r/rocker/r-base).

*Note that these instructions will require that you have administrator
access to your computer.*

1. Install
[Docker community edition](https://www.docker.com/community-edition),
following the instructions provided on the Docker website, and
check that Docker is working correctly, again following the steps
given on the Docker website.

2. Run this command in the shell (this must be fit onto one line):

```
alias docker-mash='docker run --rm --security-opt label:disable -t -P -w $PWD -u $UID:${GROUPS[0]} -v $USER:/home/docker -v /tmp:/tmp -v $PWD:$PWD gaow/mash-paper'
```

*TO DO: Explain here what this command does.*

To test out this command, run:

```
mash-docker pwd 
```

Note that an automatic download for the `mash-paper` docker image will
start at this point if it is the first time you run it.
To double-check the image is installed,

```
docker images
```

## Run MASH to reproduce GTEx results for Urbut et al 2017

Under the repo you will find `workflows/gtex6_mash_analysis.ipynb` 
to reproduce the GTEx results in Figures ? and ?.

To show what analysis are available,

```bash
mash-docker sos run workflows/gtex6_mash_analysis.ipynb -h
```

To run default (all) analysis,

```bash
mash-docker sos run workflows/gtex6_mash_analysis.ipynb
```

All intermediate and final output should be saved to a folder called
`gtex6_workflow_output`. Particularly you may want to checkout
`gtex6_workflow_output/gtex6_mash_analysis.html` which contains the
complete analysis procedure.


**FIXME: update figure plotting instructions**

### Figure plotting

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

*List people here who contributed to this project.*
