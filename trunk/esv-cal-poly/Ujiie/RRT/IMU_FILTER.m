function IMU_FILTER(block)
% Level-2 M file S-Function for unit delay demo.
%   Copyright 1990-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $ 

  setup(block);
  
%endfunction

function setup(block)
  
  block.NumDialogPrms  = 1;
  
  %% Register number of input and output ports
  block.NumInputPorts  = 3;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).Dimensions        = [1 16];     %IMU data in 8 bit ints
  block.InputPort(1).DirectFeedthrough = false;
  
  block.InputPort(2).Dimensions        = [1 10];      %OLD DATA
  block.InputPort(2).DirectFeedthrough = false;
  
  block.InputPort(3).Dimensions        = [1 1];      %GO FLAG
  block.InputPort(3).DirectFeedthrough = false;
  
  block.OutputPort(1).Dimensions       = [1 10];    %IMU data in 16 bit ints
  
  %block.OutputPort(2).Dimensions       = 1;
  
  %% Set block sample time to inherited
  block.SampleTimes = [0 0];
  
  %% Register methods
  block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
  block.RegBlockMethod('InitializeConditions',    @InitConditions);  
  block.RegBlockMethod('Outputs',                 @Output);  
  block.RegBlockMethod('Update',                  @Update);  
  
%endfunction

function DoPostPropSetup(block)

  %% Setup Dwork
  block.NumDworks = 1;
  block.Dwork(1).Name = 'x0'; 
  block.Dwork(1).Dimensions      = 1;
  block.Dwork(1).DatatypeID      = 0;
  block.Dwork(1).Complexity      = 'Real';
  block.Dwork(1).UsedAsDiscState = true;

%endfunction

function InitConditions(block)

  %% Initialize Dwork
  block.Dwork(1).Data = block.DialogPrm(1).Data;
  
%endfunction

function Output(block)

    %GET GO FLAG
    GOFLAG = block.InputPort(3).Data;

  %GET THE IMU ARRAY
  IMUsmall = block.InputPort(1).Data;
  
   %CONCATINATE DATA
  
     IMUlarge(1) = IMUsmall(1) * (2^8) + IMUsmall(2);
     IMUlarge(2) = IMUsmall(3) * (2^8) + IMUsmall(4);
     IMUlarge(3) = IMUsmall(5) * (2^8) + IMUsmall(6);
     IMUlarge(4) = IMUsmall(7) * (2^8) + IMUsmall(8);
     IMUlarge(5) = IMUsmall(9) * (2^8) + IMUsmall(10);
     IMUlarge(6) = IMUsmall(11) * (2^8) + IMUsmall(12);
     IMUlarge(7) = IMUsmall(13);    %Encoder 1
     IMUlarge(8) = IMUsmall(14);    %Encoder 2
     IMUlarge(9) = IMUsmall(15);    %Encoder 3
     IMUlarge(10) = IMUsmall(16);   %Encoder 4
     
   %GET OLD DATA
  if GOFLAG > 0
   IMUold = block.InputPort(2).Data;
  else
      IMUold = IMUlarge;
  end
      
    %COMPARE SIGNALS
%     x = 1;
%     
%     while x <= 10
%         if abs(IMUlarge(x) - IMUold(x)) > 150
%             IMUlarge(x) = IMUold(x);
%         end
%         x = x + 1;
%     end
  
    block.OutputPort(1).Data = IMUlarge;
 
%endfunction

function Update(block)

  %block.Dwork(1).Data = block.InputPort(1).Data(1);
  
%endfunction
