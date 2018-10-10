#' Reference class to represent a clustering model
#' 
#' @field clusters list with the differente clusters with their parameters
#' @field fit assigned clusters to the data
#' @exportClass ClustersModel
setRefClass("ClustersModel",
            fields=list(clusters="list",fit="array")
)
