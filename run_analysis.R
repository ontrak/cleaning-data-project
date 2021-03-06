setwd('data/UCI HAR Dataset')

# 1. Merges the training and the test sets to create one data set.

train <- read.table('train/subject_train.txt', header=F, colClasses='numeric', comment.char='')
test  <- read.table('test/subject_test.txt',  header=F, colClasses='numeric', comment.char='')
subject <- rbind(train, test)

train <- read.table('train/X_train.txt', header=F, colClasses='numeric', comment.char='')
test  <- read.table('test/X_test.txt',  header=F, colClasses='numeric', comment.char='')
X <- rbind(train, test)

train <- read.table('train/y_train.txt', header=F, colClasses='numeric', comment.char='')
test  <- read.table('test/y_test.txt',  header=F, colClasses='numeric', comment.char='')
y <- rbind(train, test)

rm('train', 'test')

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table('features.txt',stringsAsFactors=F)[,2]

meanStdIndex <- grep('-mean()|-std()',features)

X <- X[,meanStdIndex]
names(X) <- features[meanStdIndex]

rm('features','meanStdIndex')

# 3. Uses descriptive activity names to name the activities in the data set
activity <- read.table('activity_labels.txt')

X$activity <- activity[y[,1],2]

rm('activity','y')

# 4. Appropriately labels the data set with descriptive variable names.
names(subject) <- 'subject'
data <- cbind(subject, X)
rm('subject', 'X')

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy <- aggregate(subset(data, select = -c(activity, subject)), by=list(activity = data$activity, subject = data$subject), mean)
write.table(tidy, 'tidy.txt', row.name=FALSE)
