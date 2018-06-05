#!/bin/sh
export VOLK_GENERIC=1
export GR_DONT_LOAD_PREFS=1
export srcdir=/media/jonathan/ea2eea90-b89c-4e24-b854-05970b317ba4/M0ZJO-GNURadio-Block-Building-Tutorial/gr-tutorial/python
export PATH=/media/jonathan/ea2eea90-b89c-4e24-b854-05970b317ba4/M0ZJO-GNURadio-Block-Building-Tutorial/gr-tutorial/build/python:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH
export PYTHONPATH=/media/jonathan/ea2eea90-b89c-4e24-b854-05970b317ba4/M0ZJO-GNURadio-Block-Building-Tutorial/gr-tutorial/build/swig:$PYTHONPATH
/usr/bin/python2 /media/jonathan/ea2eea90-b89c-4e24-b854-05970b317ba4/M0ZJO-GNURadio-Block-Building-Tutorial/gr-tutorial/python/qa_amp_py_cc.py 
