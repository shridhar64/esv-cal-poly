function IMU_DATA(block)
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
 
<<<<<<< .mine
  block.InputPort(1).Dimensions        = [1 10];     %IMU data in 8 bit ints
=======
  block.InputPort(1).Dimensions        = [1 12];     %IMU data in 8 bit ints
>>>>>>> .r107
  block.InputPort(1).DirectFeedthrough = false;
  
<<<<<<< .mine
  block.InputPort(2).Dimensions        = [1 1];      %GO FLAG
  block.InputPort(2).DirectFeedthrough = false;
=======
  block.OutputPort(1).Dimensions       = [1 6];    %IMU data in 16 bit ints
>>>>>>> .r107
  
  block.InputPort(3).Dimensions        = [1 7];      %constants
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

  %GET CALIBRATION VALUES
  constants = block.InputPort(3).Data;

  %GET GO FLAG
  GOFLAG = block.InputPort(2).Data;
  
  %GET THE IMU ARRAY
  IMUlarge = block.InputPort(1).Data;
  
<<<<<<< .mine
  if (GOFLAG >0)
      
  %SCALE DATA
=======
     IMUlarge(1) = IMUsmall(1) * (2^8) + IMUsmall(2);
     IMUlarge(2) = IMUsmall(3) * (2^8) + IMUsmall(4);
     IMUlarge(3) = IMUsmall(5) * (2^8) + IMUsmall(6);
     IMUlarge(4) = IMUsmall(7) * (2^8) + IMUsmall(8);
     IMUlarge(5) = IMUsmall(9) * (2^8) + IMUsmall(10);
     IMUlarge(6) = IMUsmall(11) * (2^8) + IMUsmall(12);
      
  %SCALE DATA
%   
%        xshift = 487;
%        yshift = 481;
%        zshift = 541;
%        xscale = .0416;
%        yscale = .0404;
%        zscale = .0403;
%     
%      IMUlarge(1) = xscale*(IMUlarge(1) - xshift);
%      IMUlarge(2) = yscale*(IMUlarge(2) - yshift);
%      IMUlarge(3) = zscale*(IMUlarge(3) - zshift);
%      
%      IMUlarge(4) = 0;
%      IMUlarge(5) = 0;
%      IMUlarge(6) = 0;
>>>>>>> .r107
  
  xshift = constants(1);
  yshift = constants(2);
  zshift = constants(3);
  rollshift = constants(4);    
  pitchshift = constants(5);
  yawshift = constants(6);
    
  xscale = .0403;   %FROM DATASHEET
  yscale = .0403;
  zscale = .0403;
  gyroscale = .977;
    
     IMUlarge(1) = xscale*(IMUlarge(1) - xshift);
     IMUlarge(2) = yscale*(IMUlarge(2) - yshift);
     IMUlarge(3) = zscale*(IMUlarge(3) - zshift);
     
      IMUlarge(4) = gyroscale*(3.142/180)*(IMUlarge(4) - rollshift);
      IMUlarge(5) = gyroscale*(3.142/180)*(IMUlarge(5) - pitchshift);
      
      if abs(IMUlarge(6) - yawshift) < 1.5
          IMUlarge(6) = yawshift;
      end
      
      IMUlarge(6) = gyroscale*(3.142/180)*(IMUlarge(6) - yawshift);
     
     %IMUlarge(7) = IMUlarge(7)*(1/32)*(4*pi())*(1/12);
     %IMUlarge(8) = IMUlarge(8)*(1/32)*(4*pi())*(1/12);
     %IMUlarge(9) = IMUlarge(9)*(1/32)*(4*pi())*(1/12);
     %IMUlarge(10) = IMUlarge(10)*(1/32)*(4*pi())*(1/12);
     
    %TESTING
     
%      IMUlarge(6) = 0;
%      IMUlarge(9) = 4;
%      IMUlarge(10) = 4;
  
    block.OutputPort(1).Data = IMUlarge;
     else
         
     block.OutputPort(1).Data = zeros(1, 10);
     end
     
  %end
 
%endfunction

function Update(block)

  %block.Dwork(1).Data = block.InputPort(1).Data(1);
  
%endfunction

