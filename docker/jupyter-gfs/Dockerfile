FROM ubuntu:16.04
LABEL maintainer jerryjung@sk.com

RUN apt-get update -yqq  && apt-get install -yqq \
  wget \
  bzip2 \
  git \
  libglib2.0-0 \
  && rm -rf /var/lib/apt/lists/*

# Configure environment
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Create a non-priviledge user that will run the services
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV BASICUSER metatron
ENV BASICUSER_UID 1000
ENV HOME /home/$BASICUSER
RUN mkdir -p $HOME/work && \
    useradd -m -d $HOME/work -s /bin/bash -N -u $BASICUSER_UID $BASICUSER && \
    mkdir -p $CONDA_DIR && \
    chown $BASICUSER $CONDA_DIR
RUN chown $BASICUSER $HOME/work
USER $BASICUSER

# Deactivate basic user to make it easier to deal with volume permissions
# for now
# ENV BASICUSER root
WORKDIR $HOME/work

# Install Python 3 from miniconda
RUN cd /tmp && \
        mkdir -p $CONDA_DIR && \
        wget -O miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  && bash miniconda.sh -f -b -p $CONDA_DIR \
  && rm miniconda.sh \
  && ls $CONDA_DIR

# Install matplotlib and scikit-image without Qt
RUN conda update -y python conda && \
  conda install -y --no-deps \
  matplotlib \
  cycler \
  freetype \
  libpng \
  pyparsing \
  pytz \
  python-dateutil \
  scikit-image \
  networkx \
  pillow \
  six \
  && conda clean -tipsy

RUN conda install -y \
  pip \
  setuptools \
  notebook \
  ipywidgets \
  terminado \
  psutil \
  numpy \
  scipy \
  pandas \
  bokeh \
  scikit-learn \
  statsmodels \
  && conda clean -tipsy


# Install the master branch of distributed and dask
COPY requirements.txt .
RUN pip install -r requirements.txt && rm -rf ~/.cache/pip/ && rm requirements.txt

# Add local files at the end of the Dockerfule to limit cache busting
COPY start-notebook.sh /usr/local/bin/
COPY start-dworker.sh  /usr/local/bin/
COPY start-dscheduler.sh  /usr/local/bin/

# Configure matplotlib to avoid using QT
COPY matplotlibrc $HOME/work/.config/matplotlib/matplotlibrc

# Trigger creation of the matplotlib font cache
ENV MATPLOTLIBRC $HOME/work/.config/matplotlib
RUN python -c "import matplotlib.pyplot"

# Switch back to root to make it possible to do interactive admin/debug as
# root tasks with docker exec
USER root
# Files added via COPY need a manual chown
RUN chown $BASICUSER:users -R $HOME/work/.config

# Install Tini that necessary to properly run the notebook service in a docker
# container:
# http://jupyter-notebook.readthedocs.org/en/latest/public_server.html#docker-cmd
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]