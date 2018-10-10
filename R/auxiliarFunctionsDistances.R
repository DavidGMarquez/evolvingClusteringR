searchClusterNearestKmeans<-function(clusterModel,dataPoint,parameters){
  distanceAcc=distancePoints(dataPoint,(clusterModel$clusters[[1]]$parameters$mean),parameters)
  clusterAcc=1
  for(indexClusterAux in 1:length(clusterModel$clusters)){
    distancePointCluster=distancePoints(dataPoint,clusterModel$clusters[[indexClusterAux]]$parameters$mean,parameters)
    if(distancePointCluster<distanceAcc){
      distanceAcc=distancePointCluster
      clusterAcc=indexClusterAux
    }
  }  
  return (clusterAcc)
}

distancePoints<-function(dataPointA,dataPointB,parameters){
  distance=dist(rbind(dataPointA,dataPointB))[1]  
  return (distance)
}

searchClusterBiggestProbability<-function(clusterModel,dataPoint,parameters){
  probabilityAcc=-1
  clusterAcc=-1
  for(indexClusterAux in 1:length(clusterModel$clusters)){
    probability=calculateProbabilityMultiNormal(dataPoint,
                                                clusterModel$clusters[[indexClusterAux]],parameters)
    if(probability>probabilityAcc){
      probabilityAcc=probability
      clusterAcc=indexClusterAux
    }
  }  
  return (clusterAcc)
}

calculateProbabilityMultiNormal<- function(dataPoint,cluster,parameters){  
  probability=dmvnorm(as.numeric(dataPoint),mean=as.numeric(cluster$parameters$mean),sigma=(cluster$parameters$variance$Sigma+diag(rep(1e-6,nrow(cluster$parameters$variance$Sigma)))))
  return(probability)
}

