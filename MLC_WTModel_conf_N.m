

        parameters.size=100;
        parameters.sensors=2;
        parameters.sensor_spec=0;
        parameters.controls=9;
        parameters.sensor_prob=0.33;
        parameters.leaf_prob=0.3;
        parameters.range=10;
        parameters.precision=4;
        parameters.opsetrange=1:3; 
        parameters.formal=1;
        parameters.end_character='';
        parameters.individual_type='tree';


        %%  GP algortihm parameters (CHANGE IF YOU KNOW WHAT YOU DO)
        parameters.maxdepth=15;
        parameters.maxdepthfirst=5;
        parameters.mindepth=2;
        parameters.mutmindepth=2;
        parameters.mutmaxdepth=15;% 3 zones model
% zone I in the center of the wake: 50% attenuation
% zone II 25% attenuation
% zone III 0% attenuation
%
% center of the wake is Wind direction + alpha/2
        parameters.mutsubtreemindepth=2;
        parameters.generation_method='mixed_ramped_gauss';
        parameters.gaussigma=3;
        parameters.ramp=[2:8];
        parameters.maxtries=10;
        parameters.mutation_types=1:4;


        %%  Optimization parameters
        parameters.elitism=10;
        parameters.probrep=0.1;
        parameters.probmut=0.4;
        parameters.probcro=0.5;
        parameters.selectionmethod='tournament';
        parameters.tournamentsize=7;
        parameters.lookforduplicates=1;
        parameters.simplify=0;
        parameters.cascade=[1 1];

        %%  Evaluator parameters 
        %parameters.evaluation_method='standalone_function';
        %parameters.evaluation_method='standalone_files';
        parameters.evaluation_method='mfile_multi';
        parameters.evaluation_function='Evaluate_WT_N';
        parameters.indfile='ind.dat';
        parameters.Jfile='J.dat';
        parameters.exchangedir=fullfile(pwd,'evaluator0');
        parameters.evaluate_all=0;
        parameters.ev_again_best=0;
        parameters.ev_again_nb=5;
        parameters.ev_again_times=5;
        parameters.artificialnoise=0;
        parameters.execute_before_evaluation='';
        parameters.badvalue=10^36;
        parameters.badvalues_elim='first';
        %parameters.badvalues_elim='none';
        %parameters.badvalues_elim='all';
        parameters.preevaluation=0;
        parameters.preev_function='';
        parameters.problem_variables.gamma=0.1;
        t=0:0.01:.1;
        Wind_angle=build_random_coherent_noise(t,10,5/180*pi);
        Wind_force=abs(3+build_random_coherent_noise(t,20,0.3));
        parameters.problem_variables.Wind_angle= Wind_angle;
        parameters.problem_variables.Wind_force= Wind_force;
        parameters.problem_variables.N=parameters.controls;
        parameters.problem_variables.geometry='square_intertwined';
        parameters.problem_variables.t=t;
        %% MLC behaviour parameters 
        parameters.save=1;
        parameters.saveincomplete=1;
        parameters.verbose=3;
        parameters.fgen=250; 
        parameters.show_best=1;


        parameters.savedir=fullfile(pwd,'save_GP');









