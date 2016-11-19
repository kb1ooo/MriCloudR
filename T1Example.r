library(MriCloudR)

# MriCloud object.  Submit requests and retrieve results.

mriCloudR <- MriCloudR(verbose = TRUE)

# Login using MriCloud credentials.  Currently, standard credentials are
# supported, not OpenId

login(mriCloudR, "kb1ooo@kb1ooo.com", "######")

# Create T1SegData object which contains payload information

t1SegData <- T1SegData()
t1SegData$hdr <- "./103111_T1w_acpc_dc/103111_T1w_acpc_dc.hdr"
t1SegData$img <- "./103111_T1w_acpc_dc/103111_T1w_acpc_dc.img"
t1SegData$age <- 40
t1SegData$gender <- "Female"
t1SegData$description <- "Testing"
t1SegData$sliceType <- "Sagittal"
t1SegData$atlas <- "Adult_286labels_10atlases_V5L"
t1SegData$processingServer <- "remoteprocessstatus@anatomyworks.com"

# submit to perform t1Seg.  Get back jobId.

jobId <- t1Seg(mriCloudR, t1SegData)

# isJobFinished checks status of job

if(isJobFinished(mriCloudR, jobId = jobId))
{
	print("Finished");
} else
{
	print(paste(c("Job ", jobId, " not completed yet!"), collapse = ''))
}

# downloadResult will download the result if the jobId is finished.  If the
# argument waitForJobToFinish is TRUE, then downloadResult will wait until the
# job is completed (checking every minute), and then download the result.   

downloadResult(mriCloudR, jobId = jobId, filename = "./result.zip", waitForJobToFinish = TRUE)
