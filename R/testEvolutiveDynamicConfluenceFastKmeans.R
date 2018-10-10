#' Evolving Clustering Dynamic Weights
#' K-means algorithm
#' 
#' @description Evolving Clustering
#' 
#' @param file path to CSV file with the data
#' @param samplesToInitMeta number of samples to init the data
#' @param parameters parameters to use
#' 
#' @return A list with the error, the elapsed time and the final clusterModel
#' 
#' @examples
#' tf <- tempfile()
#' iris2 <- iris
#' iris2$Species <- as.numeric(iris2$Species)
#' write.table(iris2,tf,row.names=FALSE, col.names=FALSE,sep=",")
#' samplesToInitMeta=50
#' parameters<-list(memory=1,KinitMclust=3)
#' results=testEvolutiveDynamicConfluenceFastKmeans(tf,samplesToInitMeta,parameters)
#' results$clusterModel$fit
#' 
#' @import mclust 
#' @importFrom utils read.csv
#' @importFrom stats dist
#' @importFrom methods new
#' @export
testEvolutiveDynamicConfluenceFastKmeans<-function(file,samplesToInitMeta,parameters)
{


experiment=read.csv(file = file,header=FALSE)
dataExperiment=experiment[,-ncol(experiment)]





samplesToInit=samplesToInitMeta

cat(" Starting algorithm... ")
init.time=as.numeric(Sys.time())
clusterModel=mclustInitializationK(dataExperiment,samplesToInit,parameters)
indexData=samplesToInit+1

#Create
for(indexClusterAux in 1:length(clusterModel$clusters)){
  cluster=clusterModel$clusters[[indexClusterAux]]
  n=sum(clusterModel$fit==indexClusterAux)
  clusterPoints=dataExperiment[which(clusterModel$fit==indexClusterAux),]
  cat(" Creating Temp Variables ")
  Wn=0
  b=0
  for(i in 1:n){
    xn=clusterPoints[i,]
    wn=weightSample(i,parameters$memory)
    Wn=Wn+wn
    b=b+xn*wn
  }
  mean=(1/(Wn))*b
  
  
  cluster$parameters$mean=mean
  cluster$parameters$temp$b=b
  cluster$parameters$temp$Wn=Wn
  clusterModel$clusters[[indexClusterAux]]=cluster
}  







while(indexData<=nrow(dataExperiment)){
  dataPoint=dataExperiment[indexData,]
#  cat(paste("Data ",indexData))

            nearClusterNumber=searchClusterNearestKmeans(clusterModel,dataPoint,parameters)
  clusterModel$fit[indexData]=nearClusterNumber
  
    b=clusterModel$clusters[[nearClusterNumber]]$parameters$temp$b
    Wn=clusterModel$clusters[[nearClusterNumber]]$parameters$temp$Wn
    xn=dataPoint
    wn=weightSample(n,parameters$memory)
    Wn=Wn+wn
    b=b+xn*wn 
    mean=(1/(Wn))*b
  
  
    clusterModel$clusters[[nearClusterNumber]]$parameters$mean=mean
    clusterModel$clusters[[nearClusterNumber]]$parameters$temp$b=b
    clusterModel$clusters[[nearClusterNumber]]$parameters$temp$Wn=Wn
  
  indexData=indexData+1;
}
end.time=as.numeric(Sys.time())
elapse.time=end.time-init.time
TRUTH=experiment[,ncol(experiment)]
FIT=clusterModel$fit

differentClusters=unique(FIT)
error=0
for(iClust in 1:length(differentClusters)){
  repetitions=TRUTH[which(FIT==iClust)]
  repetitionsTable=as.data.frame(table(repetitions))
  maxRep=max(repetitionsTable[,2])
  error=error+length(repetitions)-maxRep
}
errorP=error/length(FIT)
errorP

errorMclust=classError(FIT, TRUTH)
results=list()
results$errorP=errorP
results$errorRate=errorMclust$errorRate
results$elapse.time=elapse.time
results$clusterModel=clusterModel
return(results)
}

