function Output = Fn_IdTracker(IdList, DistList, Input)

if isempty(IdList); return; end

% Configration
DecayRatio = 0.99;
ChangeProb = 0.7;

[~,Idx] = min(DistList);
if sum(IdList == Input.ID)
    if IdList(Idx) ~= Input.ID
        tmp_Prob = Input.Prob * DecayRatio;
        
        if tmp_Prob < ChangeProb
            Output.ID = IdList(Idx);
            Output.Prob = 1.0;
        else
            Output.ID = Input.ID;
            Output.Prob = tmp_Prob;
        end
    else
        Output.ID = Input.ID;
        Output.Prob = Input.Prob * (1+(1-DecayRatio));
%         if Output.Prob > 1.0
%             Output.Prob = 1.0;
%         end
%         
    end
else
    Output.ID = IdList(Idx);
    Output.Prob = 1.0;
end



end