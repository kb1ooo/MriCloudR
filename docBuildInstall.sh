
#
# run roxygen
#

cd MriCloudR
R -e 'library(devtools);document()'
cd ..

#
# build package
#

R CMD build MriCloudR

#
# install package
#

R -e "install.packages('./MriCloudR_0.9.1.tar.gz', repos = NULL, type='source')"

#
# make pdf of documentation
#

rm MriCloudR.pdf
R CMD Rd2pdf MriCloudR
rm MriCloudR-manual-0.9.1.pdf
mv MriCloudR.pdf MriCloudR-manual-0.9.1.pdf
