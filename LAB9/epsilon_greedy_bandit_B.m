function [value] = binaryBanditB(action)
    p = [0.8, 0.9];
    if rand < p(action)
        value = 1;
    else
        value = 0;
    end
end

% Epsilon greedy algorithm
Q = zeros(1, 2);
N = zeros(1, 2);
e = 0.1;
actions_taken = zeros(1, 1000);
avg = zeros(1, 1000);

for i = 1:1000
    if rand > e
        [~, id] = max(Q);
        A = id;
    else
        temp = randperm(2);
        A = temp(1);
    end
    actions_taken(i) = A; % Store the action taken in this iteration
    R = binaryBanditB(A); % reward
    N(A) = N(A) + 1;
    Q(A) = Q(A) + (R - Q(A)) / N(A);
    if i == 1
        avg(i) = R;
    else
        avg(i) = ((i - 1) * avg(i - 1) + R) / i;
    end
end

% Plotting actions taken with different colors and adding a legend
figure;
subplot(2, 1, 1);
% Plotting actions taken for action 1 (blue color)
plot(find(actions_taken == 1), actions_taken(actions_taken == 1), 'bo', 'MarkerSize', 3);
hold on;
% Plotting actions taken for action 2 (red color)
plot(find(actions_taken == 2), actions_taken(actions_taken == 2), 'ro', 'MarkerSize', 3);
xlabel('Iteration');
ylabel('Action taken');
title('Actions Taken in Each Iteration');
ylim([0.5 2.5]);
yticks([1 2]);
legend('Action 1', 'Action 2');

% Plotting running average of rewards
subplot(2, 1, 2);
plot(1:1000, avg, 'r');
xlabel('Iteration');
ylabel('Average Reward');
title('Running Average of Rewards');
