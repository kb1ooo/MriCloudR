#library(httr)
#library(methods)
#source("R/T1SegData.r")

#' A wrapper around the AnatomyWorks MriCloud Web API
#'
#' This class makes the MriCloud API functionality available in R,
#' encapsulating the http communications so that it behaves like a standard R
#' interface.
#' 
#' @slot baseUrl The root URL of the MRICloud API.  Default is \url{https://braingps.mricloud.org}.
#' @slot verbose Verbose output
#' @import httr methods
#' @export
#' @export MriCloudR

MriCloudR <- setClass("MriCloudR", representation(baseUrl = "character", verbose = "logical"),
										 prototype(baseUrl = "https://braingps.mricloud.org", verbose = FALSE))

setGeneric(name = "login", def = function(theObject, username, password)
					 {
						 standardGeneric("login")
					 } 
)

#' Login to MriCloud
#'
#' \code{login} logs into the MriCloud Api, which must be done before calling
#' any subsequent methods. If you do not have an MriCloud account, go to 
#' \url{https://braingps.mricloud.org} to register or retrieve forgotton 
#' credentials.
#' 
#' @param username MriCloud username
#' @param password MriCloud password
#' @export 

setMethod(f = "login", signature(theObject = "MriCloudR", username = "character", password = "character"), 
					definition = function(theObject, username, password) 
					{

						# Login request.  For now, just do direct login.  Note the config
						# option (followlocation = 0L) so that redirection is not followed.
						# We need that because checking the redirect is the only way to
						# know if login was successful.

						# The returned cookie is used as the credential for subsequent
						# requests and are automatically propagated by httr

						httr::set_config( config( ssl_verifypeer = 0L ) )
						r <- POST(paste(theObject@baseUrl, "/login", sep = ''), body = list(login_email=username, login_password=password), encode = "form", config(followlocation = 0L));

						# throw error if there is an http error
					
						if(http_error(r))
							stop_for_status(r)
#						print(r)

						# Currently, only way to check if login was successful is if redirect is to /home
						# Also check that the Location header is set.
						
						if(!is.null(headers(r)$Location) && headers(r)$Location == paste(theObject@baseUrl, "/home", sep = ''))
						{
							if(theObject@verbose)
								print("Login SUCCESS")
						} else {
							stop("Login FAILED. Check credentials.")
						}

						return(theObject)

					}
					)

setGeneric(name = "dtiSeg", def = function(theObject, data = "DtiSegData")
					 {
						 standardGeneric("dtiSeg")
					 })

#' Submit a DTI segmentation request.
#'
#' \code{dtiMap} Submits an asynchronous DTI segmentation request, returning a
#' job ID as reference for subsequent requests to check and retreive results. 
#'
#' @param data A object of \code{\link{DtiSegData}} containing payload data and
#' metadata for the upload. 
#' @return Returns the job ID for the processing request.
#' @export

setMethod(f = "dtiSeg", signature(theObject = "MriCloudR", data = "DtiSegData"),
					definition = function(theObject, data)
					{
						sliceInt = which(data$sliceType[1] == data$sliceType@levels)[[1]] - 1
						atlasInt = which(data$atlas[1] == data$atlas@levels)[[1]] - 1

						body = list(slice_type = sliceInt,
												atlas_name = atlasInt,
												processing_serverid = data$processingServer, 
												zip = upload_file(data$dataZip),
												description = data$description);

						r <- POST(paste(theObject@baseUrl, "/dtimultiatlasseg", sep = ''), body = body, encode = "multipart", config(followlocation = 0L), progress(type = "up"));

						stop_for_status(r)
						parsed <- content(r, "parsed")
						if(!is.null(parsed$response$status) && (parsed$response$status == "submitted"))
						{
							if(theObject@verbose)
								print(paste("Job successfully submitted with jobId: ", parsed$response$jobId, sep = '')); 
							return(as.character(parsed$response$jobId));
						} else
						{
							stop("Error submitting job")
							return(0)
						}

					}
					)

setGeneric(name = "t1Seg", def = function(theObject, data = "T1SegData")
					 {
						 standardGeneric("t1Seg")
					 }
)

#' Submit a t1 segmentation request.
#'
#' \code{t1Seg} Submits an asynchronous t1 segmentation request, returning a
#' job ID as reference for subsequent requests to check and retreive results. 
#'
#' @param data A object of \code{\link{T1SegData}} containing payload data and
#' metadata for the upload. 
#' @return Returns the job ID for the processing request.
#' @export

setMethod(f = "t1Seg", signature(theObject = "MriCloudR", data = "T1SegData"),
					definition = function(theObject, data)
					{
						# I want a better way to do this.  I.e. like a real enum which
						# should get the integer representation.
						
						sliceInt = which(data$sliceType[1] == data$sliceType@levels)[[1]] - 1
						atlasInt = which(data$atlas[1] == data$atlas@levels)[[1]] - 1

						body = list(slice_type = sliceInt,
												atlas_name = atlasInt,
												target_hdr = upload_file(data$hdr),
												target_img = upload_file(data$img),
												processing_serverid = data$processingServer,
												age = data$age,
												gender = data$gender[1],
												description = data$description)

#						print(paste(theObject@baseUrl, "/t1prep", sep = ''))

						r <- POST(paste(theObject@baseUrl, "/t1prep", sep = ''), body = body, encode = "multipart", config(followlocation = 0L), progress(type = "up"));

						stop_for_status(r)
						parsed <- content(r, "parsed")
						if(!is.null(parsed$response$status) && (parsed$response$status == "submitted"))
						{
							if(theObject@verbose)
								print(paste("Job successfully submitted with jobId: ", parsed$response$jobId, sep = '')); 
							return(as.character(parsed$response$jobId));
						} else
						{
							stop("Error submitting job")
							return(0)
						}


					}
					)


setGeneric(name = "isJobFinished", def = function(theObject, jobId = "character")
					 {
						 standardGeneric("isJobFinished")
					 }
)

#' Check job status
#'
#' \code{isJobFinished} checks status of processing for \code{jobId}.
#' 
#' @param jobId The jobId of the request, obtained from a processing request such as \code{\link{t1Seg}}
#' @return \code{TRUE} if the job is completed, otherwise returns \code{FALSE}
#' @export

setMethod(f = "isJobFinished", signature(theObject = "MriCloudR", jobId = "character"),
					definition = function(theObject, jobId)
					{
						r <- GET(paste(c(theObject@baseUrl, "/jobstatus%3Fjobid=", jobId), collapse = ''))
#						str(headers(r))

						stop_for_status(r)
						parsed <- content(r, "parsed")
						if(is.null(parsed$status))
							stop(paste("Error: ", parsed, sep = ''))

						if(parsed$status == "finished")
							return(TRUE)
						else
							return(FALSE)


					}
					)

setGeneric(name = "downloadResult", def = function(theObject, jobId = "character", filename = "character", waitForJobToFinish = TRUE, ...)
					 {
						 downloadResult(theObject, jobId, filename, waitForJobToFinish);
					 }
)

#' Download result of processing request
#'
#' \code{downloadResult} downloads the result of a processing request
#' associated with \code{jobId}, such as from a \code{\link{t1Seg}} request.
#'
#' @param jobId The jobId of the request, obtained from a processing request such as \code{\link{t1Seg}}
#' @param filename Output filename for result.
#' @param waitForJobToFinish TRUE or FALSE.  If TRUE, \code{downloadResult}
#' will wait until the job is finished and then download the result (default
#' value is TRUE).  If FALSE, it will attempt to download the result but will
#' return if the job is not completed.
#' @return TRUE if download successful. FALSE otherwise
#' @export
#'

setMethod(f = "downloadResult", signature(theObject = "MriCloudR", jobId = "character", filename = "character", waitForJobToFinish = 'logical'),
					definition = function(theObject, jobId, filename, waitForJobToFinish)
					{
						if(waitForJobToFinish)
							while(!isJobFinished(theObject, jobId))
							{
								if(theObject@verbose)
									print(paste(c("Job ", jobId, " not completed.  Sleeping 30s"), collapse = ''))
								Sys.sleep(30)
							}

						if(isJobFinished(theObject, jobId))
						{
							r <- GET(paste(c(theObject@baseUrl, "/roivis/jobid=", jobId, "filename=Result.zip"), collapse = ''), progress(type = "down"), write_disk(filename))
							return(TRUE);
						} else {
							print(paste(c("Job ", jobId, " not completed. Can't download result!"), collapse = ''))
							return(FALSE);
						}

					}
					)


