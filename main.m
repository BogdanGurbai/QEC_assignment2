config.alpha   = 0.01;
config.winFrac = 0.10;
config.minWin  = 5;

config.minVal  = 0.5;
config.maxVal  = 5.0;

fprintf('\n=== Phase II: Two-Sample Welch t-test ===\n\n');
results_phase2 = phase2_mean_sample_test(robot_arm, config);

fprintf('\n=== Phase III: Beta Goodness-of-Fit ===\n\n');
results_phase3 = phase3_sample_goodness_of_fit(robot_arm, config);