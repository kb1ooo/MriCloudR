library(MriCloudR)

# MriCloud object.  Submit requests and retrieve results.

mriCloudR <- MriCloudR(verbose = TRUE)

# Login using MriCloud credentials.  Currently, standard credentials are
# supported, not OpenId

login(mriCloudR, "kb1ooo@kb1ooo.com", "#######")

# Create DtiSegData object which contains payload information

DtiSegData <- DtiSegData()
DtiSegData$dataZip <- "./dtiexample/dtiexample.zip"
DtiSegData$description <- "Testing"
DtiSegData$sliceType <- "Axial"
DtiSegData$atlas <- "Adult_168labels_8atlases_V1"
DtiSegData$processingServer <- "remoteprocessstatus@anatomyworks.com"

# submit to perform DtiSeg.  Get back jobId.

jobId <- dtiSeg(mriCloudR, DtiSegData)

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

downloadResult(mriCloudR, jobId = jobId, filename = "./dtiResult.zip", waitForJobToFinish = TRUE)
