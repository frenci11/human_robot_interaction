clc
clear

%{

----------------Gradient Descent for Classification in 2D Space----------------

this script implement linear and a quadratic classifier to separate a dataset of 2
dimensional features.

the linear classifier, uses the decision function to create the margin boundary,
calculates analitically the gradient w.r.t the weights, and update it iteratively
based on number of steps and learning rate.

the quadratic classifier does the same thing, but, expands the 2 dimensional feature vector in a 4th
dimensional one, (free to choose any data combination for the other 2 dimensions)
and aims to find a linear decision boundary on that 4th dimension, which then, if
evaluated back on the 2 dimensional data, results in a more complex shape decision
boundary, that should better separate the 2 dataclass

in this script, only the training phase is implemented, to see the gradient descent
approach in action.

for an eventual evaluation pahse, you just need to evaluate the function with the
found weights, to another dataset.

this approach of augmenting the feature space into a higher dimension so to find a
linear boundary in that dimension, is essentially what a neural network does. The
only difference is in this case we are forcing a certain function and mapping
strategy, werelse a neural network, sort of finds it's own mapping function and
weights for augmenting the data dimension, but in the end, the last layer finds a
linear separation surface in that n dimension.

%}




% Parameters
n_points = 200; % Number of points per class
learning_rate = 0.01; % Learning rate
num_iterations = 300; % Number of gradient descent iterations

% Generate synthetic data
%you can uncomment class2 to generate different data distributions
rng(1)
class1 = randn(2, n_points) + 2; % Class 1 points
%class2 = randn(2, n_points) - 1; % Class 2 points
theta=randn(1,n_points);
class2 = [(0.1.*randn(1,n_points)+3).*cos(theta)+2; (3*0.1.*randn(1,n_points)+3).*sin(theta)+2];


% Combine data
%we know that the first 100 points have label 1, and the latter 100, label -1
X = [class1, class2]; % Feature vectors
Y = [ones(1, n_points), -ones(1, n_points)]; % true Labels (1 for class1, -1 for class2)

%this grid will be utilized to evaluate the decision boundary across all the 2D
%feature space
x1_range = linspace(min(X(1, :)), max(X(1, :)), 100);
x2_range = linspace(min(X(2, :)), max(X(2, :)), 100);
[X1, X2] = meshgrid(x1_range, x2_range);
grid_points = [X1(:), X2(:)]';

% Plot data
figure(1);
clf
hold on
scatter(class1(1, :), class1(2, :), 'r', 'filled'); hold on;
scatter(class2(1, :), class2(2, :), 'b', 'filled');
title('2D Feature Vectors');
xlabel('Feature 1'); ylabel('Feature 2');
grid on;

% Initialize weights and bias
rng("shuffle")
W = randn(2,1); % Weight vector
b = randn(1,1); % Bias

% Gradient Descent
for iter = 1:num_iterations
    % Compute gradients
    %the margin should always give >0 for correctly classified points (if Y=-1, and
    %(W' * X + b) <0, correctly classified -> margin >0, if Y=1 ....)
    margin = Y .* (W' * X + b);
    %we filter only missclassified points so, (margin < 0) we take only
    %missclassified, then .*Y so we know the corresponding true label value.
    gradient_w = -sum(((margin < 0) .* Y) .* X, 2); % Gradient w.r.t W
    gradient_b = -sum((margin < 0) .* Y); % Gradient w.r.t b

    % Update weights and bias
    W = W - learning_rate * gradient_w;
    b = b - learning_rate * gradient_b;

    % Plot decision boundary iteratively   
        decision_values= W'*grid_points+b;
        decision_values = reshape(decision_values, size(X1));
        contour(X1, X2, decision_values, [0, 0], 'k:', 'LineWidth', 1);
        
end

%plot last decision boundary in another color
decision_values= W'*grid_points+b;
%reshape because for every 2D point, i recive 1 decision number, in total i will have
%1*n decisions, i need to reshape to a n*n so i know where is that decision in space
decision_values = reshape(decision_values, size(X1));
contour(X1, X2, decision_values, [0, 0], 'b', 'LineWidth', 2);

%count misclassified points by evaluating the margin function and comparing true
%labels Y
disp("misclassified datapoints linear:")
disp(sum((Y .* (W' * X + b)<0)))

title('2D Feature Vectors with Decision Boundaries');
hold off


%% now let's try to produce a 4th order decision boundary

%this function maps the 2D feature vector to a 4D one
X_augmented=feature_map(X);
%weight initialization, notive now W is a 4D
W=randn(4,1);
b=randn(1,1);

figure(2);
clf
hold on

for iter= 1:num_iterations

    %same as before, but using augmented feature vector
    margin = Y .* (W' * X_augmented + b);

    gradient_w = -sum(((margin < 0) .* Y) .* X_augmented, 2); % Gradient w.r.t W
    gradient_b = -sum((margin < 0) .* Y); % Gradient w.r.t b

    W = W - learning_rate * gradient_w;
    b = b - learning_rate * gradient_b;


    %we are essentially creating a 2D grid point across all the 2 axis,
    %expanding it to 4D like they are features point
    %and then using the contour to pick only the points where the decision
    %function gives 0, so exactly at the boundary
    grid_points=feature_map(grid_points);
    decision_values= W'*grid_points+b;
    %reshape it because the functions gives 1*n decision values (for every 4D point i
    %recive 1 decision number) i need to reshape back to a n*n grid so i can plot
    %where that decision is located in 2D space
    decision_values = reshape(decision_values, size(X1));
    contour(X1, X2, decision_values, [0, 0], 'k:', 'LineWidth', 1);


end

%same as before, evaluating of the function
disp("misclassified datapoints quadratic:")
disp(sum((Y .* (W' * X_augmented + b)<0)))


%plot again the last boundary
scatter(class1(1, :), class1(2, :), 'r', 'filled'); hold on;
scatter(class2(1, :), class2(2, :), 'b', 'filled');
title('2D Feature Vectors');
xlabel('Feature 1'); ylabel('Feature 2');
grid on;

grid_points=feature_map(grid_points);
decision_values= W'*grid_points+b;
decision_values = reshape(decision_values, size(X1));
contour(X1, X2, decision_values, [0, 0], 'b', 'LineWidth', 2);
hold off



function feature_mapping= feature_map(X)

    x1 = X(1, :);
    x2 = X(2, :);
    %try to augment the feature to a 4th dimensional vector
    feature_mapping = [x1; x2; x1+x2; x1.^2+x2.^2];
    %feature_mapping = [x1; x2; x1.^2+x2.^2; x1.*x2];
end










