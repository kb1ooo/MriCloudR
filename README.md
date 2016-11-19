
# MRICloudR

This is an R package which wraps the MRICloud API so that it can be accessed from R.

## Build

To build release and documentation and install, run:

	sh docBuildInstall.sh

## Installation

To install from a release build run (note the docBuildInstall.sh script already performs this step):

	R -e "install.packages('./MriCloudR_0.9.1.tar.gz', repos = NULL, type='source')"

## Make a release

To make a release run (note, you will need the example data directories which are not currently stored in the repo):

  sh makeInstall.sh	

## Documentation

Please see MriCloudR-manual-0.9.1.pdf for documentation.  

## Example code

Please see T1Example.r and DtiExample.r for examples on using the interfaces.  They may be run via Rscript:

	Rscript T1Example.r

and

	Rscript DtiExample.r 

## Release Notes

0.9.0  Initial release supporting T1 segmentation  
0.9.1  Added Dti segmentation and adjusted default mricloud URL
