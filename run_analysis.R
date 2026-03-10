# Getting and Cleaning Data - Course Project
# run_analysis.R
# Este script limpia y ordena el dataset

# 1. Descargar y descomprimir dataset si no existe
if(!file.exists("dataset.zip")){
  download.file(
    "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
    destfile = "dataset.zip"
  )
}

if(!file.exists("UCI HAR Dataset")){
  unzip("dataset.zip")
}

# 2. Cargar archivos necesarios
features <- read.table("UCI HAR Dataset/features.txt",
                       col.names = c("id","feature"))
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",
                              col.names = c("id","activity"))

# Cargar TRAIN
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",
                      col.names = "activity")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",
                            col.names = "subject")

# Cargar TEST
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",
                     col.names = "activity")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",
                           col.names = "subject")

# 3. Asignar nombres de variables
colnames(x_train) <- features$feature
colnames(x_test) <- features$feature

# 4. Combinar datos TRAIN y TEST
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Dataset completo
data <- cbind(subject_data, y_data, x_data)

# 5. Extraer solo columnas con mean() y std()
mean_std_cols <- grepl("mean\\(\\)|std\\(\\)", features$feature)
selected_features <- features$feature[mean_std_cols]
tidy_data <- data[, c("subject","activity", selected_features)]

# 6. Usar nombres descriptivos de actividades
tidy_data$activity <- factor(
  tidy_data$activity,
  levels = activity_labels$id,
  labels = activity_labels$activity
)

# 7. Limpiar nombres de variables
names(tidy_data) <- gsub("\\(\\)", "", names(tidy_data))
names(tidy_data) <- gsub("-", "_", names(tidy_data))
names(tidy_data) <- gsub("^t", "time_", names(tidy_data))
names(tidy_data) <- gsub("^f", "freq_", names(tidy_data))

# 8. Crear dataset independiente con promedio por sujeto y actividad
final_dataset <- aggregate(. ~ subject + activity,
                           data = tidy_data,
                           FUN = mean)

# 9. Ordenar dataset
final_dataset <- final_dataset[order(final_dataset$subject,
                                     final_dataset$activity),]

# 10. Guardar dataset limpio
write.table(final_dataset,
            "tidy_dataset.txt",
            row.names = FALSE)