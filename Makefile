
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

all: check

check: test.xml
	./test.sh || ./cleanup.sh

#Run check-data target to test against known disk image contents
check-data: check-testdata

check-testdata: \
  check-testdata-ntfs-gen1 \
  check-testdata-ntfs-gen2

check-testdata-ntfs-gen1:
	$(MAKE) -C testdata/nps-2009-ntfs1/ntfs-gen1 check

check-testdata-ntfs-gen2:
	$(MAKE) -C testdata/nps-2009-ntfs1/ntfs-gen2 check

debug:
	grep --color DEBUG stderr.log

download: download-testdata

download-testdata: \
  download-testdata-ntfs-gen1 \
  download-testdata-ntfs-gen2

download-testdata-ntfs-gen1:
	$(MAKE) -C testdata/nps-2009-ntfs1/ntfs-gen1 download

download-testdata-ntfs-gen2:
	$(MAKE) -C testdata/nps-2009-ntfs1/ntfs-gen2 download

test.xml: deps/dfxml/samples/difference_test_0.xml
	ln -s $< $@
