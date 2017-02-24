#!/bin/bash
exec su $BASICUSER -c "env PATH=$PATH jupyter notebook --ip='*' --no-browser --NotebookApp.token='' --NotebookApp.base_url=/home/metatron/work $*"
