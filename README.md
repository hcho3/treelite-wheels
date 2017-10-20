treelite wheel builder
======================

[![Build Status (Travis CI)](https://api.travis-ci.org/hcho3/treelite-wheels.svg?branch=master)](https://travis-ci.org/hcho3/treelite-wheels)
[![Build Status (Appveyor)](https://ci.appveyor.com/api/projects/status/1rw7jxn4355xa3xc/branch/master?svg=true)](https://ci.appveyor.com/project/hcho3/treelite-wheels)

[Get latest wheels here](http://treelite-wheels.s3.amazonaws.com/list.html)

This repository contains scripts to build [Python wheels](https://pythonwheels.com/)
for the [treelite](https://github.com/dmlc/treelite) project. Python wheels
contain **pre-compiled binaries**, so that users no longer have to compile from
the source. Thanks to Python wheels, one can install treelite by typing
```bash
pip install treelite
```

To build a Python wheel, the following steps are carried out:
1. Compile [Protobuf](https://github.com/google/protobuf) library.
2. Build the C++ library portion of treelite. 
3. Bundle the C++ library with Python files to build a Python wheel. 

To build platform-specific wheels, this repo takes advantage of continuous
integration platforms such as [Travis CI](https://travis-ci.org/) and
[Appveyor](https://www.appveyor.com/). For now, it builds wheels for the
following platforms:

* Windows (32-bit / 64-bit)
  - Python 2.7
  - Python 3.4, 3.5, 3.6
* Mac OS X (64-bit)
  - Python 2.7
  - Python 3.4, 3.5, 3.6
* Linux (32-bit / 64-bit)
  - Python 2.7 with &ldquo;narrow&rdquo; Unicode
    (see &ldquo;Notes on Unicode variations&rdquo; below)
  - Python 2.7 with &ldquo;wide&rdquo; Unicode
    (see &ldquo;Notes on Unicode variations&rdquo; below)
  - Python 3.4, 3.5, 3.6

The completed wheels get stored to an S3 bucket, until the repository owner
shall manually upload them to PyPI.

Acknowledgement
---------------
We are indebted to the trailblazing works of the
[multibuild](https://github.com/matthew-brett/multibuild) project, which made
cross-platform compilation much less painful. We also thank the maintainers of
[manylinux1](https://github.com/pypa/manylinux) Docker image, without which it
would be impractical to build widely compatible Linux binaries.

Notes on Linux wheels
---------------------
Unlike Mac OS X and Windows, Linux comes in many varieties, each distribution
shipping with different versions of core system libraries. As a result,
compiled Python extension modules built on one Linux distribution often do not
work on other Linux distributions.

To enable portability among a wide range of Linux distributions, Python defines
the [manylinux1 platform tag](https://www.python.org/dev/peps/pep-0513), which
mandates that Python wheel rely on a very small set of system libraries and
only &ldquo;old&rdquo; versions of them. To produce such compatible wheels, we
have to build them using CentOS 5, a very old distro. The build script uses the
[manylinux Docker image](https://github.com/pypa/manylinux), which ships with
CentOS 5 and multiple Python versions.

Notes on Unicode variations
---------------------------

Python 2.x interpreters come in two variations, one compiled with
&ldquo;wide&rdquo; Unicode and another with &ldquo;narrow&rdquo; Unicode. The
wide Unicode build uses four bytes to store a Unicode letter internally, whereas
the narrow build uses only two. No such distiction exists for Python 3.x.
