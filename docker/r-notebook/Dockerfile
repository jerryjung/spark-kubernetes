FROM jerryjung/jupyter-notebook-gfs

LABEL maintainer jerryjung@sk.com

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    python-qt4 \
    gfortran \
    gcc && \
    rm -rf /var/lib/apt/lists/*

USER $BASICUSER
WORKDIR $HOME/work

# R packages
RUN conda update --all -y && \
    conda config --add channels r && \
    conda install --quiet --yes \
    'r-base=3.3.2' \
    'r-irkernel=0.7*' \
    'r-plyr=1.8*' \
    'r-devtools=1.12*' \
    'r-tidyverse=1.0*' \
    'r-shiny=0.14*' \
    'r-rmarkdown=1.2*' \
    'r-forecast=7.3*' \
    'r-rsqlite=1.1*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=0.2*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*' \
    && conda clean -tipsy
