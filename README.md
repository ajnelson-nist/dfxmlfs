# DFXMLFS

Some disks use storage systems that lack support from standard sources.  In these cases, to read the disk you need working knowledge of:

* The disk's partition manager;
* The disk's file system(s);
* A way to present the file system contents, whether through a forensic tool, a kernel-level file system, or a userspace-level file system.

Some tools exist to deal with partition managers (e.g. [Disktype](https://github.com/kamwoods/disktype), [The SleuthKit](https://github.com/sleuthkit/sleuthkit).

This tool exists to deal with the file system presentation.  Conceptually, you could equate this tool to running `ls -lR`, capturing its output to a text file, shipping that text file to another computer, and navigating that file *as a mounted file system*.  The difference is, instead of the output of `ls -l`, this tool uses [Digital Forensics XML](http://forensicswiki.org/wiki/DFXML), a well-structured language for file system metadata.


## Usage

Use a Python version that has [`fuse-python`](http://sourceforge.net/p/fuse/fuse-python/ci/master/tree/) available.  `fuse-python` is a Python 2 module at the moment, so this example uses `python2.7`:

    python2.7 dfxmlfs.py \
      -o xmlfile=$path_to_dfxml_file \
      [-o imgfile=$path_to_image_file] \
      $mount_point

(The `xmlfile` option will eventually be an argument.)

The `imgfile` option provides the path to the disk image that the XML file represents.  The disk image is not used for any metadata accesses, but instead is for extracting file contents.


## State of the code

* Mounting works.
* Walking the directory tree works.
* Extracting file contents doesn't work.