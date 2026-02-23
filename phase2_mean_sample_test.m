alpha = 0.01;
winFrac = 0.10;
minWin = 5;

N = numel(robot_arm);
Arm = (1:N)';

p_ttest = nan(N,1);
h_ttest = false(N,1);
nStart = zeros(N,1);
nEnd = zeros(N,1);
meanStart = nan(N,1);
meanEnd = nan(N,1);

for k = 1:N
    v = robot_arm(k).sampleset(:);
    T = numel(v);
    w = max(minWin, round(winFrac * T));

    if 2*w > T
        w = floor(T/2);
    end

    x = v(1:w);
    y = v((T-w+1):T);

    nStart(k) = numel(x);
    nEnd(k) = numel(y);
    meanStart(k) = mean(x);
    meanEnd(k) = mean(y);

    % two-sample t-test (unequal variances)
    [h_t, p_t] = ttest2(x, y, 'Alpha', alpha, 'Vartype', 'unequal');

    p_ttest(k) = p_t;
    h_ttest(k) = logical(h_t);
end

idxBad = (h_ttest);
Status = repmat("OK", N, 1);
Status(idxBad) = "OUT-OF-SPEC";

for k = 1:N
    fprintf('Arm %3d: n(start)=%3d n(end)=%3d mean(start)=%.4g mean(end)=%.4g | t p=%.4g h=%d --> %s\n', ...
        Arm(k), nStart(k), nEnd(k), meanStart(k), meanEnd(k), p_ttest(k), h_ttest(k), char(Status(k)));
end

badArms = find(idxBad);
if isempty(badArms)
    fprintf('\nAll arms: OK at %.2f%% confidence.\n', (1-alpha)*100);
else
    fprintf('\nArms out-of-spec (indices): %s\n', mat2str(badArms));
end
