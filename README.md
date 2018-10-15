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
 tf <- tempfile()
 iris2 <- iris
 iris2$Species <- as.numeric(iris2$Species)
 write.table(iris2,tf,row.names=FALSE, col.names=FALSE,sep=",")
 samplesToInitMeta=50
 parameters<-list(memory=1,KinitMclust=3)
 results=testEvolutiveDynamicConfluenceFastEM(tf,samplesToInitMeta,parameters)
 results$clusterModel$fit
```

```r
 tf <- tempfile()
 iris2 <- iris
 iris2$Species <- as.numeric(iris2$Species)
 write.table(iris2,tf,row.names=FALSE, col.names=FALSE,sep=",")
 samplesToInitMeta=50
 parameters<-list(memory=1,KinitMclust=3)
 results=testEvolutiveDynamicConfluenceFastKmeans(tf,samplesToInitMeta,parameters)
 results$clusterModel$fit
```

## License

The package is available under GNU General Public License v3.0 `gpl-3.0`.
We encourage other researchers to use it and send their feeback.

Maintained by David Gonzalez Marquez.
