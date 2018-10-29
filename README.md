# evolvingClusteringR


A R package for evolving clustering that implements the evolving K-means and evolving EM algorithms described in "A novel and simple strategy for evolving prototype based clustering" [Paper](https://www.sciencedirect.com/science/article/pii/S0031320318301547) 

## Installation
Use install_github from **devtools** package

```r
library("devtools")
install_github("DavidGMarquez/evolvingClusteringR")
```

## Usage

There are two functions in the package `testEvolutiveDynamicConfluenceFastEM` and `testEvolutiveDynamicConfluenceFastEM`. Both functions take as arguments the path of a CSV file, the number of samples for the initialization and a list of parameters. 
The CSV file should have just numbers separated by commas, the last column must be the ground truth. 
In the list of parameters you should add the `memory` parameter of the algorithm (see [Paper](https://www.sciencedirect.com/science/article/pii/S0031320318301547) ) and the number of clusters for the initialization `KinitMclust`.

In the folder Scripts is also included the file `exampleMain.R`. This code executes the algorithms over the [**GaussianMotionData**](https://citius.usc.es/investigacion/datasets/gaussianmotiondata) dataset. 

### Examples
```r
 tf = tempfile()
 iris2 = iris
 iris2$Species = as.numeric(iris2$Species)
 iris2 <- iris2[sample(nrow(iris2)),]
 write.table(iris2,tf,row.names=FALSE, col.names=FALSE,sep=",")
 samplesToInitMeta=50
 parameters=list(memory=2,KinitMclust=3)
 resultsA=testEvolutiveDynamicConfluenceFastEM(tf,samplesToInitMeta,parameters)
 resultsA$clusterModel$fit
 plot(iris2[,-5],col=resultsA$clusterModel$fit)
 parameters<-list(memory=0.01,KinitMclust=3)
 resultsB=testEvolutiveDynamicConfluenceFastEM(tf,samplesToInitMeta,parameters)
 resultsB$clusterModel$fit
 plot(iris2[,-5],col=resultsB$clusterModel$fit)
```

```r
 tf = tempfile()
 iris2 = iris
 iris2$Species = as.numeric(iris2$Species)
 iris2 <- iris2[sample(nrow(iris2)),]
 write.table(iris2,tf,row.names=FALSE, col.names=FALSE,sep=",")
 samplesToInitMeta=50
 parameters=list(memory=2,KinitMclust=3)
 resultsA=testEvolutiveDynamicConfluenceFastKmeans(tf,samplesToInitMeta,parameters)
 resultsA$clusterModel$fit
 plot(iris2[,-5],col=resultsA$clusterModel$fit)
 parameters<-list(memory=0.01,KinitMclust=3)
 resultsB=testEvolutiveDynamicConfluenceFastKmeans(tf,samplesToInitMeta,parameters)
 resultsB$clusterModel$fit
 plot(iris2[,-5],col=resultsB$clusterModel$fit)
```

## Reference
 
Please cite this publication when referencing or using this material:
```
@article{MARQUEZ201816,
title = "A novel and simple strategy for evolving prototype based clustering",
journal = "Pattern Recognition",
volume = "82",
pages = "16 - 30",
year = "2018",
issn = "0031-3203",
doi = "https://doi.org/10.1016/j.patcog.2018.04.020",
url = "http://www.sciencedirect.com/science/article/pii/S0031320318301547",
author = "David G. Márquez and Abraham Otero and Paulo Félix and Constantino A. García",
keywords = "Evolving clustering, Data stream, Concept drift, Gaussian mixture models, K-means, Cluster evolution"
}
```


## License

The package is available under GNU General Public License v3.0 `gpl-3.0`.
We encourage other researchers to use it and send their feeback.

Maintained by David Gonzalez Marquez.
