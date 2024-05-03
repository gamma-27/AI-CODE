# Installs pacman ("package manager") if needed
if (!require("pacman")) install.packages("pacman")

# Use pacman to load add-on packages as desired
pacman::p_load(pacman, bnlearn, bnclassify) 

#BiocManager package to install two additional packages: "graph" and "Rgraphviz"
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("graph")
BiocManager::install("Rgraphviz")

# Read the data file using read.table function
data <- read.table("https://raw.githubusercontent.com/pratikiiitv/graphicalmodels/main/2020_bn_nb_data.txt", header = TRUE, col.names = c("EC100", "EC160", "IT101","IT161","MA101","PH100","PH160","HS101", "QP"))

# Convert character variables to factor variables
data[sapply(data, is.character)] <- lapply(data[sapply(data, is.character)], as.factor)

# Convert the data frame into a Bayesian network object
bn<- hc(data[,-9],score = 'k2')

# Inspect the learned Bayesian network structure
plot(bn)
bn

# fit the Bayesian network to the data
fitted_bn <- bn.fit(bn, data[,-9]) 
fitted_bn$EC100
fitted_bn$EC160
fitted_bn$IT101
fitted_bn$IT161
fitted_bn$MA101
fitted_bn$PH100
fitted_bn$HS101

# Plot the CPTs of each node as a dot plot (similar to bar chart) using bn.fit.dotplot
bn.fit.dotplot(fitted_bn$EC100)
bn.fit.dotplot(fitted_bn$EC100)
bn.fit.dotplot(fitted_bn$EC160)
bn.fit.dotplot(fitted_bn$IT101)
bn.fit.dotplot(fitted_bn$IT161)
bn.fit.dotplot(fitted_bn$MA101)
bn.fit.dotplot(fitted_bn$PH100)
bn.fit.dotplot(fitted_bn$HS101)

# What grade will a student get in PH100 if he earns DD in EC100, CC in IT101 and CD in MA101:

# Predict the grade in PH100 based on evidence provided
prediction.PH100 <- data.frame(cpdist(fitted_bn, nodes = c("PH100"), evidence = (EC100 == "DD" & IT101 == "CC" & MA101 == "CD")))

# plot(prediction.PH100)
my_table <- table(prediction.PH100)
my_table
barp <- barplot(my_table, col = hsv(seq(0, 1, length.out = 8), 1, 1), ylim = c(0, 120))
text(barp, my_table + 6, labels = my_table)

# Set the seed for reproducibility
set.seed(101)

# Initialize an empty vector to store accuracy results
accuracy_results <- c()

# Loop 20 times
for (i in 1:20) {
  
  # Split the data into training and testing sets using the sample function
  sample <- sample.int(n = nrow(data), size = floor(.7*nrow(data)), replace = F)
  data.train <-data[sample,]
  data.test<- data[-sample,]
  
  # Build the naive Bayes classifier on the training data using the nb function from the bnlearn package.
  nb.grades <- nb(class = "QP",dataset= data.train)
  
  #Fit the naive Bayes classifier to the training data using the lp function
  nb.grades<-lp(nb.grades, data.train, smooth=0)
  #nb.grades$.params
  
  #Use the predict function to predict the grades of the test data
  p<-predict(nb.grades, data.test)
  #Compute the confusion matrix using the table function
  cm<-table(predicted=p, true=data.test$QP)
  cm
  
  #Compute the accuracy of the prediction using the accuracy function from the bnclassify package
  accuracy <- bnclassify:::accuracy(p, data.test$QP)
  
  # Store the accuracy in the vector
  accuracy_results <- c(accuracy_results, accuracy)
  
}

plot(nb.grades)

# Report the mean accuracy of the classifier (when courses are independent of each other)
mean(accuracy_results)

accuracy_results2 <- c()

for (i in 1:20) {
  
  #Build the TAN classifier on the training data using the tan_cl function from the bnlearn package.
  tn <- tan_cl("QP", data.train)
  #Fit the TAN classifier to the training data using the lp function
  tn <- lp(tn, data.train, smooth = 1)
  
  
  #Use the predict function to predict the grades of the test data.
  p <- predict(tn, data.test)
  
  #Compute the confusion matrix using the table function
  cm1<-table(predicted=p, true=data.test$QP)
  cm1
  
  #Compute the accuracy of the prediction using the accuracy function from the bnclassify package
  accuracy2 <- bnclassify:::accuracy(p, data.test$QP)
  
  # Store the accuracy in the vector
  accuracy_results2 <- c(accuracy_results, accuracy2)
}

plot(tn)
# Report the mean accuracy of the classifier (considering that the grades earned in different courses may be dependent)
mean(accuracy_results2)

#Clear Console
cat("\014")  
#Clear all plots
dev.off()