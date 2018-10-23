function data = ASTPharma_data

    disp('Welcome to our Experiment!');
    data.nr = input('Subject Number?: ');
    data.experiment = input('Run full experiment?: ');
    data.eeg = input('EEG? (0/1): ');
    data.training = input('Training? (0/1): ');
    if data.training == 0
        data.age = input('Age?: ');
        data.gender = input('Gender? (m/f): ','s');
        data.handedness = input('Handedness? (r/l): ','s');
    end

end