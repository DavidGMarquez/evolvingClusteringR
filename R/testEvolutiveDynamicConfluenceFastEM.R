#' Evolving Clustering Dynamic Weights
#' EM algorithm
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
#' tf = tempfile()
#' iris2 = iris
#' iris2$Species = as.numeric(iris2$Species)
#' iris2 <- iris2[sample(nrow(iris2)),]
#' write.table(iris2,tf,row.names=FALSE, col.names=FALSE,sep=",")
#' samplesToInitMeta=50
#' parameters=list(memory=2,KinitMclust=3)
#' resultsA=testEvolutiveDynamicConfluenceFastEM(tf,samplesToInitMeta,parameters)
#' resultsA$clusterModel$fit
#' plot(iris2[,-5],col=resultsA$clusterModel$fit)
#' parameters<-list(memory=0.01,KinitMclust=3)
#' resultsB=testEvolutiveDynamicConfluenceFastEM(tf,samplesToInitMeta,parameters)
#' resultsB$clusterModel$fit
#' plot(iris2[,-5],col=resultsB$clusterModel$fit)
#' 
#' @import mclust mvtnorm
#' @importFrom utils read.csv
#' @importFrom stats dist
#' @importFrom methods new
#' @export
testEvolutiveDynamicConfluenceFastEM <-
  function(file,
           samplesToInitMeta,
           parameters)
  {
    experiment=read.csv(file = file,header=FALSE)
    dataExperiment=as.matrix(experiment[,-ncol(experiment)])
 
    samplesToInit = samplesToInitMeta
    
    cat(" Starting algorithm... ")
    init.time = as.numeric(Sys.time())
    clusterModel = mclustInitializationK(dataExperiment, samplesToInit, parameters)
    indexData = samplesToInit + 1
    
    #Create
    for (indexClusterAux in 1:length(clusterModel$clusters)) {
      cluster = clusterModel$clusters[[indexClusterAux]]
      n = sum(clusterModel$fit == indexClusterAux)
      clusterPoints = dataExperiment[which(clusterModel$fit == indexClusterAux), ]
      cat(" Creating Temp Variables ")
      Wn = 0
      Wn2 = 0
      A = 0
      b = 0
      for (i in 1:n) {
        xn = clusterPoints[i, ]
        wn = weightSample(i, parameters$memory)
        Wn = Wn + wn
        Wn2 = Wn2 + wn ^ 2
        A = A + crossprod(t(xn), (xn)) * wn
        b = b + xn * wn
      }
      cluster$parameters$temp$A = A
      cluster$parameters$temp$b = b
      cluster$parameters$temp$Wn = Wn
      cluster$parameters$temp$Wn2 = Wn2
      clusterModel$clusters[[indexClusterAux]] = cluster
    }
    
    
    
    
    
    
    
    while (indexData <= nrow(dataExperiment)) {
      dataPoint = dataExperiment[indexData, ]
      #  cat(paste("Data ",indexData))

  #          nearClusterNumber=searchClusterNearestKmeans(clusterModel,dataPoint,parameters)
           nearClusterNumber=searchClusterBiggestProbability(clusterModel,dataPoint,parameters)
  clusterModel$fit[indexData]=nearClusterNumber
  
  cluster=clusterModel$clusters[[nearClusterNumber]]
  n=sum(clusterModel$fit==nearClusterNumber)
  
    A=cluster$parameters$temp$A
    b=cluster$parameters$temp$b
    Wn=cluster$parameters$temp$Wn
    Wn2=cluster$parameters$temp$Wn2
    xn=dataPoint
    wn=weightSample(n,parameters$memory)
    Wn=Wn+wn
    Wn2=Wn2+wn^2
    A=A+crossprod(t(xn),(xn))*wn
    b=b+xn*wn 
  
  
  mean=(1/(Wn))*b
  
  aux=(Wn)/((Wn)^2-Wn2)
  Cov=aux*(A-mean%*%t(b)-b%*%t(mean)+(Wn)*(mean%*%t(mean)))
  
  cluster$parameters$mean=mean
  cluster$parameters$variance$Sigma=Cov
  cluster$parameters$temp$A=A
  cluster$parameters$temp$b=b
  cluster$parameters$temp$Wn=Wn
  cluster$parameters$temp$Wn2=Wn2
  clusterModel$clusters[[nearClusterNumber]]=cluster
  
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