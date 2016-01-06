
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

#Run in Python 2 or Python 3.

import logging
import os
import hashlib
import sys

_logger = logging.getLogger(os.path.basename(__file__))

import Objects

def main():
    hash_mismatches = 0
    for (event, obj) in Objects.iterparse(args.xmlfile):
        if not isinstance(obj, Objects.FileObject):
            continue
        if not obj.filename:
            continue
        if not obj.filename.startswith("RAW/"):
            continue
        if obj.name_type != "r":
            continue

        if obj.sha1 is None:
            continue

        path = os.path.join(args.testdir, "partition_1", obj.filename)
        _logger.debug("Inspecting path: %r." % path)
        _logger.debug("Recreating SHA-1: %r." % obj.sha1)

        checker = hashlib.sha1()
        with open(path, "rb") as fh:
            while True:
                buf = fh.read(4096)
                if len(buf) == 0:
                    break
                checker.update(buf)
        checker_sha1 = checker.hexdigest().lower()
        _logger.debug("Hash of content read from file system: %r." % checker_sha1)

        if obj.sha1 != checker_sha1:
            hash_mismatches += 1
            _logger.error("Hash mismatch on path: %r." % path)
            _logger.debug("obj.id = %r." % obj.id)

    if hash_mismatches != 0:
        _logger.error("Read incorrect content on %d files." % hash_mismatches)
        sys.exit(1)

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("-d", "--debug", action="store_true")
    parser.add_argument("xmlfile")
    parser.add_argument("testdir")
    args = parser.parse_args()

    logging.basicConfig(level=logging.DEBUG if args.debug else logging.INFO)

    main()
