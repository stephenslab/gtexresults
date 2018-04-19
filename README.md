## What's included

This repo contains some of the original scripts used to produce results
from Urbut et al 2017. 

If you want to run the latest `mashr` for yourself, we suggest
starting with the new version of software available
[here](https://github.com/stephenslab/mashr).

## Before using this repo

We use a docker container to facilitate reproducing our computational
experiments and analysis procedures. Here is the
[docker file](workflows/Dockerfile) showing how the container is configured. Note
that it is built on top of another docker image
[gaow/lab-base](https://hub.docker.com/r/gaow/lab-base),
which is based on
[rocker/rbase](https://hub.docker.com/r/rocker/r-base).

*Note that these instructions will require that you have administrator
access to your computer.*

1. Install
[Docker community edition](https://www.docker.com/community-edition),
following the instructions provided on the Docker website, and
check that Docker is working correctly, again following the steps
given on the Docker website.

2. Run this command in the shell (this must be fit on one line):

```
alias docker-mash='docker run --rm --security-opt label:disable -v
  $USER:/home/docker -v /tmp:/tmp -v $PWD:$PWD -t -P -w $PWD -u 
  $UID:${GROUPS[0]} gaow/mash-paper'
```

*TO DO: Explain here what this command does.*

To test out this command, run:

```
docker-mash pwd 
```

Note that an automatic download for the `mash-paper` docker image will
start at this point if it is the first time you run it.

```
docker images
```

## Run MASH to reproduce GTEx results for Urbut et al 2017

Under the repo you will find `workflows/gtex6_mash_analysis.ipynb` 
to reproduce the GTEx results in Figures ? and ?.

```bash
mash-paper sos run workflows/gtex6_mash_analysis.ipynb
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

## License

*Add details of license here.*

## Contributors

*List people here who contributed to this project.*
