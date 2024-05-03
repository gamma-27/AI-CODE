import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import confusion_matrix, f1_score
import numpy as np

def run_experiment(criterion, test_size, num_repeats=20):
    # Load the car dataset from CSV
    url = 'D:/AI CODE/LAB7/car.csv'
    car_data = pd.read_csv(url)

    # Convert categorical variables to numerical using one-hot encoding
    features = ['buying', 'maint', 'doors', 'person', 'lug_boot', 'safety']

    # Separate features (X) and target variable (y)
    y = car_data.cls
    X = pd.get_dummies(car_data[features])

    f1_scores = []
    conf_matrices = []

    for _ in range(num_repeats):
        # Split the data into training and testing sets
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=test_size, stratify=y)

        # Create a Decision Tree classifier
        clf = DecisionTreeClassifier(criterion=criterion, random_state=42)

        # Train the classifier on the training data
        clf.fit(X_train, y_train)

        # Make predictions on the test data
        y_pred = clf.predict(X_test)

        # Evaluate the performance using confusion matrix and F1-score
        conf_matrix = confusion_matrix(y_test, y_pred)
        f1 = f1_score(y_test, y_pred, average='weighted')

        # Store results
        conf_matrices.append(conf_matrix)
        f1_scores.append(f1)

    # Calculate and print the average F1-score and confusion matrix
    average_f1 = np.mean(f1_scores, axis=0)
    average_conf_matrix = np.mean(conf_matrices, axis=0)
    print("Average Confusion Matrix:")
    print(average_conf_matrix.astype(int))
    print("\nAverage F1 Score:", average_f1)

# Problem Statement 1 and 2: Entropy Measure with 60% training dataset and 40% testing
run_experiment(criterion="entropy", test_size=0.4)

# Problem Statement 3: Gini Index Measure with 60% training dataset and 40% testing
run_experiment(criterion="gini", test_size=0.4)

# Additional experiments
run_experiment(criterion="entropy", test_size=0.3)
run_experiment(criterion="entropy", test_size=0.2)
run_experiment(criterion="gini", test_size=0.3)
run_experiment(criterion="gini", test_size=0.2)
