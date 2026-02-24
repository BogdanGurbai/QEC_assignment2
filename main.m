config.alpha   = 0.01;
config.winFrac = 0.10;
config.minWin  = 5;

config.minVal  = 0.5;
config.maxVal  = 5.0;
config.print = true;

fprintf('\n=== Phase II: Two-Sample Welch t-test ===\n\n');
results_phase2 = phase2_mean_sample_test(robot_arm, config);

fprintf('\n=== Phase III: Beta Goodness-of-Fit ===\n\n');
results_phase3 = phase3_sample_goodness_of_fit(robot_arm, config);

config.CL = 0.99;
config.sim.Nruns = 1000;
config.sim.nArms = numel(robot_arm);
config.sim.T = 200;
config.sim.a = 2;
config.sim.b = 5;
config.sim.seed = 123;
config.print = false;

fprintf('\n=== Phase IV: Monte-Carlo Validation ===\n\n');
out_phase4 = phase4_monte_carlo_test(config);