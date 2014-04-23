rm(list=ls()) #will remove ALL objects 
setwd("G:/Data_Science_JH/Getting_and_Cleaning_Data/") #change this to your working directory
#if (!file.exists("data")){dir.create("data")}
##read test data
data<-scan("./UCI HAR Dataset/test/X_test.txt",strip.white=TRUE)
n=length(data)/561
data<-matrix(data,nrow=n,ncol=561,byrow=T)
subjid<-read.table("./UCI HAR Dataset/test/subject_test.txt")
activity<-read.table("./UCI HAR Dataset/test/y_test.txt")
data<-cbind(subjid,activity,data)
testdata<-as.data.frame(data)
#done with test

#read train data
data<-scan("./UCI HAR Dataset/train/X_train.txt",strip.white=TRUE)
n=length(data)/561
data<-matrix(data,nrow=n,ncol=561,byrow=T)
subjid<-read.table("./UCI HAR Dataset/train/subject_train.txt")
activity<-read.table("./UCI HAR Dataset/train/y_train.txt")
data<-cbind(subjid,activity,data)
traindata<-as.data.frame(data)
#done with train
#ls()
data<-rbind(traindata,testdata)
rm(testdata)
rm(traindata)
rm(activity)
rm(subjid)
#get feature names from featurex.txt
colnames<-read.table("./UCI HAR Dataset/features.txt",sep="")
colnames<-colnames[,2]
colnames<-as.character(colnames)
colnames<-c("subjid","activity",colnames)
names(data)<-colnames

#find column index for mean and std
?grep
idx1<-grep("mean",colnames)
idx1
idx2<-grep("std",colnames)
idx2
idx<-c(1,2,idx1,idx2)
idx
data<-data[,idx]
act_label<-read.table("./UCI HAR Dataset/activity_labels.txt")
names(act_label)<-c("label","activity")
#str(act_label)
data$activity<-factor(data$activity,labels=act_label$activity,levels=act_label$label)
write.table(data, file = "data.txt")
#?read.table
#dat<-read.table("data.txt",header=T)


#creat data2 as independent tidy data set with the average of each variable for each 
#activity and each subject.
tmp<-interaction(data$subjid,data$activity)
#length(tmp)
s <- split(data,tmp)
data2<-sapply(s,function(x) colMeans(x[,3:81]))
data2.T <- t(data2[,1:ncol(data2)])
nametmp<-rownames(data2.T)
subjid<-gsub("[^0-9*]","",nametmp)
subjid<-as.numeric(subjid)
activity<-gsub("[0-9*.]","",nametmp)
activity
subjid
data2.T<-data.frame(subjid,activity,data2.T)
write.table(data2.T, file = "data2.txt")

