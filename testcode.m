mkdir('E:\02_Project\03_HAD\01_DB\[170424]_[MIDAN]_[SENSOR]\DataAnalysis');

destination = 'E:\02_Project\03_HAD\01_DB\[170424]_[MIDAN]_[SENSOR]\DataAnalysis\';
root_dir_path = 'E:\02_Project\03_HAD\01_DB\[170424]_[MIDAN]_[SENSOR]\';
Dir_result = dir(root_dir_path);
for nIndex = 1:length(Dir_result)
    filepath = [root_dir_path, Dir_result(nIndex).name,'\SensorSyncData.mat'];
    
    if exist(filepath,'file') ~= 0
       copyfile(filepath, [destination,Dir_result(nIndex).name,'.mat']);
    end
end