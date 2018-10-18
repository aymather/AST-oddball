function trialseq = ASTPharma_sequence(settings,id,data)

    col = length(fieldnames(id));
    trialseq = [];

    for it = 1:settings.general.blocks
        
        for ib = 1:settings.general.trials
        
            if data.training == 0
            % Create a cluster
                cluster = zeros(10,col);
                cluster(1:8,id.sound) = 1; % standard freq
                cluster(9,id.sound) = 2; % oddball freq
                cluster(10,id.sound) = 3; % birdcall
            else
                cluster = zeros(10,col);
                cluster(1:9,id.sound) = 1; % standard freq
                cluster(10,id.sound) = 2; % oddball freq
            end
            
            % Shuffle
            cluster(:,id.trialNum) = randperm(size(cluster,1));
            cluster = sortrows(cluster);
        
            % Block num
            cluster(:,id.block) = it;
        
            % Merge
            trialseq = [trialseq; cluster];
            
        end
        
    end
    
    % Correct trial numbers
    trialseq(:,id.trialNum) = 1:size(trialseq,1);

end