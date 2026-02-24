function results = phase3_sample_goodness_of_fit(robot_arm, config)
    
    alpha   = config.alpha;
    winFrac = config.winFrac;
    minWin  = config.minWin;
    minVal  = config.minVal;
    maxVal  = config.maxVal;
    
    N = numel(robot_arm);
    
    results.N = N;
    results.p = nan(N,1);
    results.h = false(N,1);
    results.nStart = zeros(N,1);
    results.nEnd   = zeros(N,1);
    results.alpha_hat = nan(N,1);
    results.beta_hat  = nan(N,1);
    
    for k = 1:N
        v = robot_arm(k).sampleset(:);
        T = numel(v);
        w = max(minWin, round(winFrac * T));
    
        if 2*w > T
            w = floor(T/2);
        end
    
        x = v(1:w);
        y = v((T-w+1):T);
    
        results.nStart(k) = numel(x);
        results.nEnd(k)   = numel(y);
    
        if numel(x) < 5 || numel(y) < 5
            continue
        end
    
        % Scale to [0,1]
        x_scaled = (x - minVal) / (maxVal - minVal);
        y_scaled = (y - minVal) / (maxVal - minVal);
    
        % Fit Beta to start window
        phat = betafit(x_scaled);
        a_hat = phat(1);
        b_hat = phat(2);
    
        results.alpha_hat(k) = a_hat;
        results.beta_hat(k)  = b_hat;
    
        pd = makedist('Beta','a',a_hat,'b',b_hat);
    
        [h,p] = kstest(y_scaled, 'CDF', pd, 'Alpha', alpha);
    
        results.p(k) = p;
        results.h(k) = logical(h);
    end
    
    idxBad = results.h;
    
    if config.print
        for k = 1:N
            status = "OK";
            if idxBad(k)
                status = "MAINTENANCE NEEDED";
            end
        
            fprintf('Arm %3d: nS=%3d nE=%3d a=%.3f b=%.3f | p=%.4g h=%d --> %s\n', ...
                k, results.nStart(k), results.nEnd(k), ...
                results.alpha_hat(k), results.beta_hat(k), ...
                results.p(k), results.h(k), status);
        end
    end
    
    badArms = find(idxBad);
    if isempty(badArms)
        fprintf('\nAll arms OK at %.2f%% confidence.\n', (1-alpha)*100);
    else
        fprintf('\nMaintenance needed for arms: %s\n', mat2str(badArms));
    end

end