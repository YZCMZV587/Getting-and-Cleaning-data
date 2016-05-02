
# 0.import data
features <- read.table("features.txt")
colnames(features) <- c("fea_no","fea_name")

train_set <- read.table("X_train.txt")
colnames(train_set) <- features[,2]

test_set <- read.table("X_test.txt")
colnames(test_set) <- features[,2]
train_label <- read.table("y_train.txt")
test_label <- read.table("y_test.txt")

#1.merges data

all_data <- rbind(train_set,test_set)

#2.extracts mean and sd variables
library(stringr)
col_idx <- which(str_detect(features[,2],"mean()")+str_detect(features[,2],"std()")>0)
etr_df <- all_data[,col_idx]

#3.add label and activity
sub_train <- read.table("subject_train.txt")
sub_test <- read.table("subject_test.txt")
sub_id <- rbind(sub_train,sub_test)
act_lab <- read.table("activity_labels.txt")
colnames(act_lab) <- c("label","activity")
label_id <- rbind(train_label,test_label)
etr_df <- cbind(sub_id,label_id,etr_df)
colnames(etr_df)[1] <- "subject"

library(dplyr)
tidy_df <- etr_df[,1:2] %>% inner_join(., act_lab,by="label") %>% subset(,c(1,3)) %>% cbind(etr_df[,3:81])

#4.average of each variable for each activity and each subject
library(plyr)
average_col_data <- ddply(tidy_df,.(subject,activity),numcolwise(mean))

