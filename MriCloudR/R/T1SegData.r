#library(methods)
#library(objectProperties)

sliceType <- setSingleEnum("slice", levels = c("Axial", "Sagittal", "SagittalToAxial"))
atlasName <- setSingleEnum("atlas", levels = c("Adult_286labels_10atlases_V5L", "Pediatric_286labels_11atlases_V5L", "Cortical_13Labels_30atlases_V1", "ADNI_297labels_9atlases_non_bifurcated_V1", "ADNI_297labels_9atlases_non_bifurcated_M2_V1", "Connectome_297labels_10atlases_V1", "Connectome_297labels_10atlases_M2_V1"))
gender <- setSingleEnum("gender", levels = c("Male", "Female"))


#' T1 Segmentation Data Payload Class
#'
#' This class is used to create an object payload for T1 segmentation processing.
#'
#' @import objectProperties
#' @export
#' @export T1SegData
#' 
#' @field processingServer processing server to use for segmentatino processing
#' @field hdr hdr data filename
#' @field img imd data filename
#' @field sliceType "Axial", "Sagital", or "SagittalToAxial". Defaults to "Sagital".
#' @field atlas "Adult_286labels_10atlases_V5L", "Pediatric_286labels_11atlases_V5L", "Cortical_13Labels_30atlases_V1", "ADNI_297labels_9atlases_non_bifurcated_V1", "ADNI_297labels_9atlases_non_bifurcated_M2_V1", "Connectome_297labels_10atlases_V1", "Connectome_297labels_10atlases_M2_V1".  Defaults to "Adult_286labels_10atlases_V5L".
#' @field gender "Male", or "Female" (OPTIONAL)
#' @field age Age of subject (OPTIONAL)
#' @field description Any description of the dataset (OPTIONAL)

T1SegData <- setRefClass("T1SegData", 
												 properties(fields = list(
																									processingServer = "character",
																									hdr = "character", 
																									img = "character", 
																									age = "numeric",  
																									gender = "genderSingleEnum", 
																									sliceType = "sliceSingleEnum", 
																									atlas = "atlasSingleEnum", 
																									description = "character")),
												 prototype = list(sliceType = sliceType("Sagittal"), 
																					atlas = atlasName("Adult_286labels_10atlases_V5L")))




