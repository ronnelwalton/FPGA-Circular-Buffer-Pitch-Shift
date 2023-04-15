% SPDX-License-Identifier: MIT
% Copyright (c) 2022 Trevor Vannoy, Ross K. Snider  All rights reserved.
%--------------------------------------------------------------------------
% Description:  Matlab Function to create/set Simulation parameters for a
%               Simulink model simulation
%--------------------------------------------------------------------------
% Authors:      Ross K. Snider, Trevor Vannoy
% Company:      Montana State University
% Create Date:  April 5, 2022
% Revision:     1.0
% License: MIT  (opensource.org/licenses/MIT)
%--------------------------------------------------------------------------
function simParams = createSimParams(modelParams)

%--------------------------------------------------------------------------
% Audio file for simulation
%--------------------------------------------------------------------------
audioFile = 'Single Notes Clean Mono.wav'; % path/to/audio/file';

simParams.testSignal = AudioSource.fromFile(audioFile, modelParams.audio.sampleFrequency);

simParams.fxptAudio = simParams.testSignal.toFixedPoint(modelParams.audio.signed, modelParams.audio.wordLength, ...
    modelParams.audio.fractionLength);

%--------------------------------------------------------------------------
% Simulation Parameters
%--------------------------------------------------------------------------
simParams.verifySimulation = false;  
simParams.playOutput       = true;
simParams.stopTime         = 1; % seconds

%--------------------------------------------------------------------------
% Model Parameters for simulation
%--------------------------------------------------------------------------


