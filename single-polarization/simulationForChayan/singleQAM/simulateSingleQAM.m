function simulateSingleQAM(powerQAM, symbolRate)
%% Simulation of 16QAM
% Variables:
% power: -20:1:10
% channel spacing: [50, 100, 150, 200] GHz
% OOK symbol rate: 10 GHz
% 16QAM symbol rate: 32 and 64 GHz

%% Define links and channels
% S = 0.06 ps/(nm^2*km) = 60 s/m^3
linkArray = [...
    Link('spanLength', 82e3, 'DCFLength', 80e3, 'S', 60); ...
    Link('spanLength', 82e3, 'DCFLength', 80e3, 'S', 60); ...
    Link('spanLength', 82e3, 'DCFLength', 80e3, 'S', 60); ...
    Link('spanLength', 82e3, 'DCFLength', 80e3, 'S', 60); ...
    Link('spanLength', 82e3, 'DCFLength', 90e3, 'S', 60)];

channelArray = [...
    Channel('modulation', '16QAM', ...
    'centerFrequency', 0e9, ...
    'symbolRate', symbolRate, ...
    'powerdBm', powerQAM, ...
    'minNumberSymbol', 2^17)];

%%
simulationName = sprintf('singleQAMPowerdBm%dSymbolRateGHz%d', ...
    powerQAM, symbolRate/1e9);

sp = SinglePolarization(...
    'simulationName', simulationName, ...
    'simulationId', 1, ...
    'linkArray', linkArray, ...
    'channelArray', channelArray, ...
    'useParallel', false);
sp.simulate();
sp.saveSimulationResult();

end