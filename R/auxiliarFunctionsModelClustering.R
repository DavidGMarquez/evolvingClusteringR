mclustInitializationK <- function(dataExperiment,numberOfSamples,parameters){
  maxClusters=ceiling(sqrt(numberOfSamples))
  clusterModel=createEmptyClusterModel(dataExperiment,parameters) 
  
  mClustResult <-
    Mclust(dataExperiment[1:numberOfSamples, ], G = parameters$KinitMclust)
  
  newClusters=mClustResult$G
  
  for(indexCluster in 1:newClusters) {
    clusterElement <-
      createClusterFromData(dataExperiment[which(mClustResult$classification ==
                                                   indexCluster), ], parameters)
    clusterModel = addClusterToClusterModel(
      clusterModel,
      clusterElement,
      which(mClustResult$classification == indexCluster),
      parameters
    )
  }
  return(clusterModel
  )
}

createEmptyClusterModel<-function(dataExperiment,parameters){  
  fitExperiment=array(-1,nrow(dataExperiment))
  clusterModel<-new("ClustersModel",clusters=list(),fit=fitExperiment)
  return(clusterModel)
}

addClusterToClusterModel<-function(clusterModel,clusterElement,dataCluster,parameters){
  newClusterNumber=length(clusterModel$clusters)+1
  clusterModel$clusters[[newClusterNumber]]<-clusterElement
  clusterModel$fit[dataCluster]=newClusterNumber
  return(clusterModel)
}

createClusterFromData<- function(dataCluster,parameters){
  clusterMClust=Mclust(dataCluster,G=1,modelNames=parameters$modelMclust)
  clusterMClust$stabilityIndex<- 0
  return(clusterMClust)
}