function [value, m] = bandit_nonstat(action, m)
    v = normrnd(0, 0.01, [1, 10]);
    m = m + v;
    value = m(action);
end

Q = zeros(1, 10);
N = zeros(1, 10);
avg = zeros(1, 10000);
epsilon = 0.1;
m = ones(1, 10);
RR = 0;
actions_taken = zeros(1, 10000);

for i = 1:10000
    if rand > epsilon
        [~, id] = max(Q);
        A = id;
    else
        temp = randperm(10);
        A = temp(1);
    end
    actions_taken(i) = A;
    [RR, m] = bandit_nonstat(A, m);
    N(A) = N(A) + 1;
    Q(A) = Q(A) + (RR - Q(A)) / N(A);
    if i == 1
        avg(i) = RR;
    else
        avg(i) = ((i - 1) * avg(i - 1) + RR) / i;
    end
end

% Plotting actions taken
figure;
hold on; % To overlay multiple plots
for i = 1:10
    indices = find(actions_taken == i);
    plot(indices, actions_taken(indices), 'o-', 'MarkerSize', 3);
end
hold off;
xlabel('Iteration');
ylabel('Action taken');
title('Actions Taken in Each Iteration');
ylim([0.5 10.5]);
yticks(1:10);
legend('Action 1', 'Action 2', 'Action 3', 'Action 4', 'Action 5', 'Action 6', ...
    'Action 7', 'Action 8', 'Action 9', 'Action 10');

% Plotting running average rewards
figure;
plot(1:10000, avg, 'r');
xlabel('Iteration');
ylabel('Running Average Reward');
title('Running Average Reward Over Iterations');
