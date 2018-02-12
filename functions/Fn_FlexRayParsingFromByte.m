function BrainFlexRayFrames = Fn_FlexRayParsingFromByte(BrainFlexRayFrames_Byte)
%%  File Name: Fn_FlexRayParsingFromByte.m
%  Description: Brain FlexRay data parsing
%  Copyright(C) 2014 ACE Lab, All Right Reserved.
% *************************************************************************
fprintf('\n\n  - Converting the byte order data to signal data...    ');
for nFrameIndex = 1:length(BrainFlexRayFrames_Byte)
    
    TempFrame = BrainFlexRayFrames_Byte{nFrameIndex};
    TempFrameData = TempFrame.Data;
    
    for nSigIndex = 1:length(TempFrame.Signal_Name)
        % Signal structure analysis
        nStartByte = floor(TempFrame.StartPos(nSigIndex)/8) + 1;
        nStartBit = mod(TempFrame.StartPos(nSigIndex),8) + 1;
        nSignalBit = TempFrame.Bit_Assign(nSigIndex);
        nEndBit = mod(nSignalBit+nStartBit-2,8)+1;
        nSignalByteUse = ceil((nSignalBit+nStartBit-1)/8);
        
        % Type size check
        switch TempFrame.Type{nSigIndex}
            case 'single'; nTypeByteSize = 4;
            case 'double'; nTypeByteSize = 8;
            case 'uint8'; nTypeByteSize = 1;
            case 'uint16'; nTypeByteSize = 2;
            case 'uint32'; nTypeByteSize = 4;
            case 'uint64'; nTypeByteSize = 8;
            case 'int8'; nTypeByteSize = 1;
            case 'int16'; nTypeByteSize = 2;
            case 'int32'; nTypeByteSize = 4;
            case 'int64'; nTypeByteSize = 8;
                
            otherwise; nTypeByteSize = 1;
        end
        
        Mask_ByteUse = zeros(1,8);
        ByteDivider = ones(1,8);
        ByteMultiplexer = zeros(1,8);
        ByteRest = (2^8)*ones(1,8);
        
        if strcmp(TempFrame.ByteOrder{nSigIndex},'true')
            % Motorola type
            Mask_ByteUse((nStartByte-nSignalByteUse+1):nStartByte) = ones(1,nSignalByteUse);
            ByteDivider(nStartByte) = 2^(nStartBit-1);
            ByteRest(nStartByte-nSignalByteUse+1) = 2^(nEndBit);
            
            ByteMultiplexer(nStartByte) = 1;
            for nMultiplexerCnt = 1:nSignalByteUse
                if nMultiplexerCnt ~= 1
                    ByteMultiplexer(nStartByte-nMultiplexerCnt+1) = (2^(9-nStartBit))*2^(8*(nMultiplexerCnt-2));
                end
            end
            
        else
            % Intel type (false)
            Mask_ByteUse(nStartByte:(nStartByte+nSignalByteUse-1)) = ones(1,nSignalByteUse);
            ByteDivider(nStartByte) = 2^(nStartBit-1);
            ByteRest(nStartByte+nSignalByteUse-1) = 2^(nEndBit);
            
            ByteMultiplexer(nStartByte) = 1;
            for nMultiplexerCnt = 1:nSignalByteUse
                if nMultiplexerCnt ~= 1
                    ByteMultiplexer(nStartByte+nMultiplexerCnt-1) = (2^(9-nStartBit))*2^(8*(nMultiplexerCnt-2));
                end
            end
        end
        
        
        TempSignalData = ByteMultiplexer(1)*floor(mod(TempFrameData(:,1)*Mask_ByteUse(1),ByteRest(1))/ByteDivider(1))...
            + ByteMultiplexer(2)*floor(mod(TempFrameData(:,2)*Mask_ByteUse(2),ByteRest(2))/ByteDivider(2))...
            + ByteMultiplexer(3)*floor(mod(TempFrameData(:,3)*Mask_ByteUse(3),ByteRest(3))/ByteDivider(3))...
            + ByteMultiplexer(4)*floor(mod(TempFrameData(:,4)*Mask_ByteUse(4),ByteRest(4))/ByteDivider(4))...
            + ByteMultiplexer(5)*floor(mod(TempFrameData(:,5)*Mask_ByteUse(5),ByteRest(5))/ByteDivider(5))...
            + ByteMultiplexer(6)*floor(mod(TempFrameData(:,6)*Mask_ByteUse(6),ByteRest(6))/ByteDivider(6))...
            + ByteMultiplexer(7)*floor(mod(TempFrameData(:,7)*Mask_ByteUse(7),ByteRest(7))/ByteDivider(7))...
            + ByteMultiplexer(8)*floor(mod(TempFrameData(:,8)*Mask_ByteUse(8),ByteRest(8))/ByteDivider(8));
        
        IndexNaN = isnan(TempSignalData);
        
        switch nTypeByteSize
            case 1; Casted_Data = TempFrame.Scale(nSigIndex)*double(typecast(uint8(TempSignalData),TempFrame.Type{nSigIndex}))+TempFrame.Offset(nSigIndex);
            case 2; Casted_Data = TempFrame.Scale(nSigIndex)*double(typecast(uint16(TempSignalData),TempFrame.Type{nSigIndex}))+TempFrame.Offset(nSigIndex);
            case 4; Casted_Data = TempFrame.Scale(nSigIndex)*double(typecast(uint32(TempSignalData),TempFrame.Type{nSigIndex}))+TempFrame.Offset(nSigIndex);
            case 8; Casted_Data = TempFrame.Scale(nSigIndex)*double(typecast(uint64(TempSignalData),TempFrame.Type{nSigIndex}))+TempFrame.Offset(nSigIndex);
            otherwise; Casted_Data = TempFrame.Scale(nSigIndex)*double(typecast(uint8(TempSignalData),TempFrame.Type{nSigIndex}))+TempFrame.Offset(nSigIndex);
        end
        Casted_Data(IndexNaN) = NaN;
        
        % Save the variable
        eval(['BrainFlexRayFrames.',TempFrame.Frame_Name,'.',TempFrame.Signal_Name{nSigIndex},' = Casted_Data;']);
    end
   
    fprintf('\b\b\b\b%3d%%',uint16(100.*nFrameIndex/length(BrainFlexRayFrames_Byte)));
end

eval('Time = BrainFlexRayFrames_Byte{1}.Time;');
fprintf('\n');
BrainFlexRayFrames.Time = Time;
end
