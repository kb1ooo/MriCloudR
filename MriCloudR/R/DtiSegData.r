#library(methods)
#library(objectProperties)

dtiSliceType <- setSingleEnum("dtiSlice", levels = c("Axial"))
dtiAtlasName <- setSingleEnum("dtiAtlas", levels = c("Pediatric_168labels_12atlases_V1", "Adult_168labels_8atlases_V1"))


#' DTI Data Payload Class
#'
#' This class is used to create an object payload for DTI mapping processing.
#'
#' @import objectProperties
#' @export
#' @export DtiSegData
#' 
#' @field processingServer processing server to use on backend 
#' @field dataZip zip payload filename.  The zip file must contain the following files with indicated naming convention :
#'   1)	b0 image (subjectname_b0.img, subjectname_b0.hdr)
#'  2)	Mean diffusion weighted images (subjectname_dwi.img, subjectname_dwi.hdr)
#'  3)	Tensor file (subjectname_tensor.dat), which is a raw matrix with 6xD1xD2xD3)
#' @field sliceType "Axial"
#' @field atlas  "Pediatric_168labels_12atlases_V1", "Adult_168labels_8atlases_V1". Defaults to "Adult_168labels_8atlases_V1".
#' @field description Any description of the dataset (OPTIONAL)

DtiSegData <- setRefClass("DtiSegData", 
												 properties(fields = list(
																									dataZip = "character",
																									processingServer = "character",
																									sliceType = "dtiSliceSingleEnum", 
																									atlas = "dtiAtlasSingleEnum", 
																									description = "character")),
													prototype = list(sliceType = dtiSliceType("Axial"), 
																					 atlas = dtiAtlasName("Adult_168labels_8atlases_V1")))
