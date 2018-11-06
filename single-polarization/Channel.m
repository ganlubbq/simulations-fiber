classdef Channel < matlab.mixin.Copyable
    %Channel class
    %   Data container of channel data
    % TODO:
    %   1. make Channel copyable, implement copyElement method
    %   2. Channel is used as a data container, so many move all methods to
    %       SinglePolarization?
    %   3. Power assignment for OOK and 16QAM
    
    %% Simulation parameters with set access control
    % These properties can be accessed everywhere, but can only be set by
    % SinglePolarization or Link objects
    properties (GetAccess=public, SetAccess={?SinglePolarization})
        modulation % {'OOK', '16QAM'}
        symbolRate % [Hz]
        centerFrequency % [Hz]
        powerdBm % power [dBm]
        powerW % power [W]
        
        % Filter parameters
        firFactor % bt of gaussdesign or beta of rcosdesign
        symbolInFir % number of symbols in FIR
        % FIR filter coefficients, a vector generated by gaussdesign or
        % rcosdesign
        fir
        
        % Parameters realted to simulations
        minSamplePerSymbol % minimum sample per symbol, can be higher
        actualSamplePerSymbol % actual sample per symbol in simulation
        minNumberSymbol % minimum number of symbols, can be higher
        actualNumberSymbol % actual number of symbols in simulation
        
        % Transmitted signals
        txBit % bit sequence
        txSymbol % symbol sequence
        txTime % time domain signal
        % dataSpectrum % spectrum domain signal
        % Number of samples to shift dataTime, [0, actualSamplePerSymbol),
        % generated randomly so that, channels are not overlapping in time
        % domain
        shiftNumberSample
        
        % Received signals
        rxTime
        rxBit
        % The optimal offset at the receiver side to sample the received
        % signal
        rxOptimalOffset 
        % Down sampled received signal, not the final symbols, because I
        % may remove some heads and tails to match the transmitted symbols
        rxSymbol
        % Transmitted symbols with some heads or tails removed, so that the
        % received symbols can match with it. Based this matched pair of tx
        % and rx symbols, the SER/SNR/EVM/Q are computed.
        txSymbolMatched
        % The matched received symbols
        rxSymbolMatched
        % centers of point clouds in the received constellation diagram
        rxCloudCenter
        % The roated received symbols
        rxSymbolRotated
        
        % SNR is based on Jochen's Python code. It also requires reference
        % signal. For each unique transmitted symbol, it computes the mean
        % and std of received symbols (or points on constellation diagram)
        % and the corresponding SNR. Then take a weighted average.
        SNR
        SNRdB
        SER
        % Referenced EVM, computed based on referenc symbols. I.e., I know
        % exactly what symbols are transmitted, in contrast to the blind
        % EVM, which do not know the reference symbols.
        EVM 
        % Relation between EVM and SNR: SNR~1/EVM^2
        % See: https://eprints.soton.ac.uk/263112/1/paper_101.pdf
    end
    
    properties (Dependent, SetAccess=private)
        constellationSize % number of points in the constellation diagram
        bitPerSymbol % bits per symbol
    end
    
    %% Methods have public access
    % Construct and dependent get access methods
    methods
        function obj = Channel(varargin)
            %Construct an instance of Channel
            %   Inputs are name-value pairs, default value is for OOK
            
            %% Parse input
            p = inputParser;
            
            validModulation = {'OOK', '16QAM'};
            checkModulation = @(x)any(validatestring(x, validModulation));
            addParameter(p, 'modulation', 'OOK', checkModulation);
            addParameter(p, 'symbolRate', 10e9, @isnumeric);
            addParameter(p, 'centerFrequency', 0e9, @isnumeric);
            addParameter(p, 'powerdBm', 0, @isnumeric);
            
            % Filter parameters
            addParameter(p, 'firFactor', 0.7, @isnumeric);
            addParameter(p, 'symbolInFir', 10, @isnumeric);
            
            % Simulation parameters
            addParameter(p, 'minSamplePerSymbol', 4, @isnumeric);
            addParameter(p, 'minNumberSymbol', 1024, @isnumeric);
            
            % Parse the inputs
            parse(p, varargin{:});
            
            %% Set parameters
            obj.modulation = p.Results.modulation;
            obj.symbolRate = p.Results.symbolRate;
            obj.centerFrequency = p.Results.centerFrequency;
            obj.powerdBm = p.Results.powerdBm;
            obj.powerW = 10.^(obj.powerdBm/10)/1e3;
            
            % Filter parameters
            obj.firFactor = p.Results.firFactor;
            obj.symbolInFir = p.Results.symbolInFir;
            
            % Simulation parameters
            obj.minSamplePerSymbol = p.Results.minSamplePerSymbol;
            obj.minNumberSymbol = p.Results.minNumberSymbol;
        end
        
        function constellationSize = get.constellationSize(obj)
            if strcmp(obj.modulation, 'OOK')
                constellationSize = 2;
            elseif strcmp(obj.modulation, '16QAM')
                constellationSize = 16;
            end
        end
        
        function bitPerSymbol = get.bitPerSymbol(obj)
            if strcmp(obj.modulation, 'OOK')
                bitPerSymbol = 1;
            elseif strcmp(obj.modulation, '16QAM')
                bitPerSymbol = 4;
            end
        end
    end
    
    methods (Access=protected)
        function newObj = copyElement(obj)
            % Copy Link object
            newObj = Channel();
            mc = ?Channel;
            for n = 1:length(mc.PropertyList)
                % Dependent and Constant properties cannot be copied
                if (mc.PropertyList(n).Dependent==0) && (mc.PropertyList(n).Constant==0)
                    propertyName = mc.PropertyList(n).Name;
                    newObj.(propertyName) = obj.(propertyName);
                end
            end
        end
    end
    
end
