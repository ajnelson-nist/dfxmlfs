#!/bin/bash

# This software was developed at the National Institute of Standards
# and Technology by employees of the Federal Government in the course
# of their official duties. Pursuant to title 17 Section 105 of the
# United States Code this software is not subject to copyright
# protection and is in the public domain. NIST assumes no
# responsibility whatsoever for its use by other parties, and makes
# no guarantees, expressed or implied, about its quality,
# reliability, or any other characteristic.
#
# We would appreciate acknowledgement if the software is used.

set -e
set -x

if [ ! -d testdir ]; then
  mkdir testdir
fi

#Debug implies foreground mode, so sleep to allow mount to finish before using directory.
python2.7 dfxmlfs.py \
  -d \
  -o xmlfile=ntfs1-gen1.E01.dfxml \
  -o imgfile=ntfs1-gen1.E01 \
  testdir \
  >stdout.log 2>stderr.log &
sleep 1

#Disable halt-on-errors here to allow cleanup script to run.
set +e

python test_reads.py --debug ntfs1-gen1.E01.dfxml testdir
rc=$?

./cleanup.sh
sleep 1

exit $rc
