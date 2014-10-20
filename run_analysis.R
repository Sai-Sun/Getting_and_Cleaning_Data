feature<-read.table("./features.txt")

# Read in the training data

train<-read.table("./train/X_train.txt")                   # Read the measured data for group training
colnames(train)<-feature$V2                                # Set the names of the variables
subj.train<-read.table("./train/subject_train.txt")        # Read the numbers of the subjects
act.train<-read.table("./train/Y_train.txt")               # Read the numbers of the activities
group.train<-rep(1,nrow(train))                            # Create a new variable representing the group
data.train<-cbind(subj.train,group.train,act.train,train)  
colnames(data.train)[1:3]<-c("Subj","Group","Activity")

# Read in the test data

test<-read.table("./test/X_test.txt")
colnames(test)<-feature$V2
subj.test<-read.table("./test/subject_test.txt")
act.test<-read.table("./test/Y_test.txt")
group.test<-rep(2,nrow(test))
data.test<-cbind(subj.test,group.test,act.test,test)
colnames(data.test)[1:3]<-c("Subj","Group","Activity")

# Merge the two datasets

data<-rbind(data.train,data.test)


# Extracts only the measurements on the mean 
# and standard deviation for each measurement

logic1<-regexpr("mean",colnames(data))>0      # Extract the variables whose names include "mean"
logic2<-regexpr("meanFreq",colnames(data))>0  # Extract the variables whose names include "meanFreq"
logic3<-regexpr("std",colnames(data))>0       # Extract the variables whose names include "std"
logic<-logic1&!logic2|logic3                  # Show the logic values for the "std" variables
                                              # and the "mean" but not "meanFreq" variables
logic[1:3]<-TRUE                              # Ensure the first three variables will be included
subset<-data[,logic]

	
	#### Another way to do step 2

	try1<-c(1:3,grep("mean|std",colnames(data)))  # Ensure the first three variables will be included
	try2<-grep("meanFreq",colnames(data))
	for(i in 1:length(try2)){
		try1<-sub(try2[i],NA,try1) 	
	}
	try1<-as.numeric(na.omit(try1))
	subset<-data[,try1]

# Use descriptive activity names to name the activities in the data set

act.names<-read.table("./activity_labels.txt")
act.names<-as.character(act.names$V2)
subset$Activity<-as.factor(subset$Activity)
levels(subset$Activity)<-act.names
subset$Group<-as.factor(subset$Group)
levels(subset$Group)<-c("Training","Test")

# Label the data set with descriptive variable names

Name<-colnames(subset)[-(1:3)]
Name.sub<-strsplit(Name,"\\()")
Name.New<-as.character()
for(i in 1:length(Name.sub)){
	if (length(Name.sub[[i]])==2 ){
		Name.New[i]<-paste(Name.sub[[i]][1],Name.sub[[i]][2],sep="")
	}	
	else Name.New[i]<-Name.sub[[i]]
}
Name.New<-sub("tBody","Time_Body",Name.New)
Name.New<-sub("fBody","Freq_Body",Name.New)
Name.New<-sub("tGravity","Time_Gravity",Name.New)
Name.New<-sub("BodyBody","Body_Body",Name.New)
Name.New<-sub("Acc","_Acc",Name.New)
Name.New<-sub("Gyro","_Gyro",Name.New)
Name.New<-sub("Jerk","_Jerk",Name.New)
Name.New<-sub("Mag","_Mag",Name.New)
Name.New<-sub("-mean","_Mean",Name.New)
Name.New<-sub("-std","_Std",Name.New)
Name.New<-sub("-X","_X",Name.New)
Name.New<-sub("-Y","_Y",Name.New)
Name.New<-sub("-Z","_Z",Name.New)
colnames(subset)[-(1:3)]<-Name.New

# Compute the average of each variable for each activity and each subject

subset.new<-data.frame()
act.level<-levels(subset$Activity)
for(i in 1:30){
	for(j in 1:6){
		subset.new<-rbind(subset.new,colMeans(subset[subset$Subj==i&subset$Activity==act.level[j],-(1:3)]))
	}
}
colnames(subset.new)<-colnames(subset)[-(1:3)]
Subject_ID<-rep(1:30,each=6)
Activity<-as.factor(rep(act.level,30))
subset.new<-cbind(Subject_ID,Activity,subset.new)
tidy.data<-subset.new[,-(1:2)]

# Save the data sets as txt files

write.table(subset.new,file="D:/study/Coursera/Getting and Cleaning Data---JHU/Course Project/course_project.txt",row.names=F)
write.table(tidy.data,file="D:/study/Coursera/Getting and Cleaning Data---JHU/Course Project/tidy_data.txt",row.names=F,col.names=F)




