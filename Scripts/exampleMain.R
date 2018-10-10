# defines -----------------------------------------------------------------
INIT_SAMPLES = 80
MEMORY=0.05

RESULTPATH= 'D:\\Sir_D\\Dropbox\\Code\\R\\evolvingClusteringR\\results\\'
RESULTNAME= 'testGaussianDataMotion'


parameters<-list(memory=MEMORY)
samplesToInitMeta=INIT_SAMPLES

#Name Files
namesFiles=c("a_1C2D1kLinear","b_4C2D800Linear","c_4C2D3200Linear","d_3C2D2400Spiral","e_4C3D20kLinear","f_5C5D1kLinear","g_2C3D4kHelix","h_2C2D200kHelix","i_4C2D4kStatic")
#ClustersInit
numClustersList=c(1,4,4,3,4,5,2,2,4)


write("StartResultsKmeans",file=paste(RESULTPATH,RESULTNAME,sep=""),append = TRUE)

for(i in 1:length(namesFiles)){
  fileName=namesFiles[i]
  parameters$KinitMclust=numClustersList[i]
  
  write(namesFiles[i],file=paste(RESULTPATH,RESULTNAME,sep=""),append = TRUE)
  #Path File
  file <- system.file("extdata", paste0("SamplesFile_", fileName, '.csv'), package="evolvingClusteringR")
  result=testEvolutiveDynamicConfluenceFastKmeans(file,samplesToInitMeta,parameters)
  resultPrint=cbind(result$errorP,result$elapse.time)
  write(resultPrint,ncolumns=length(resultPrint),file=paste(RESULTPATH,RESULTNAME,sep=""),append = TRUE)
}

write("StartResultsEM",file=paste(RESULTPATH,RESULTNAME,sep=""),append = TRUE)

for(i in 1:length(namesFiles)){
  fileName=namesFiles[i]
  parameters$KinitMclust=numClustersList[i]
  
  write(namesFiles[i],file=paste(RESULTPATH,RESULTNAME,sep=""),append = TRUE)
  #Path File
  file <- system.file("extdata", paste0("SamplesFile_", fileName, '.csv'), package="evolvingClusteringR")
  result=testEvolutiveDynamicConfluenceFastEM(file,samplesToInitMeta,parameters)
  resultPrint=cbind(result$errorP,result$elapse.time)
  write(resultPrint,ncolumns=length(resultPrint),file=paste(RESULTPATH,RESULTNAME,sep=""),append = TRUE)
}
