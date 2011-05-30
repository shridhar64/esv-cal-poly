function PLOT_OBJECTS(VEHICLE, VEHICLE_GEO, OBSTACLE, ROAD, PATH, TIME)

RT=[50;-5];   

THETA=PATH(TIME,3);
LENGTH=VEHICLE_GEO(1);
WIDTH=VEHICLE_GEO(2);


    %CALCULATE VERTICIES OF THE VEHICLE
    %LOCATION OF THE FRONT CENTER
    TIP(1)=-LENGTH*sin(THETA)+PATH(TIME,1);  
    TIP(2)=LENGTH*cos(THETA)+PATH(TIME,2);
    
    %CALCULATE THE FRONT LEFT CORNER
    KARTER(1,1)=TIP(1)-(WIDTH/2)*cos(THETA);
    KARTER(5,1)=KARTER(1,1);
    KARTER(1,2)=TIP(2)-(WIDTH/2)*sin(THETA);
    KARTER(5,2)=KARTER(1,2);
    %CALCULATE THE FRONT RIGHT CORNER
    KARTER(2,1)=TIP(1)+(WIDTH/2)*cos(THETA);
    KARTER(2,2)=TIP(2)+(WIDTH/2)*sin(THETA);
    %CALCULATE THE REAR RIGHT CORNER
    KARTER(3,1)=PATH(TIME,1)+(WIDTH/2)*cos(THETA);
    KARTER(3,2)=PATH(TIME,2)+(WIDTH/2)*sin(THETA);
    %CALCULATE THE REAR LEFT CORNER
    KARTER(4,1)=PATH(TIME,1)-(WIDTH/2)*cos(THETA);
    KARTER(4,2)=PATH(TIME,2)-(WIDTH/2)*sin(THETA);

    
    
    OBSTACLE(1)=OBSTACLE(1)+OBSTACLE(5)*PATH(TIME,5);
    
    %CALCULATE THE VERTICES OF THE OBSTACLE
    %FRONT LEFT
    OBSTACLER(1,1)=OBSTACLE(1)-OBSTACLE(4)/2;
    OBSTACLER(1,2)=OBSTACLE(2)+OBSTACLE(3)/2;
    OBSTACLER(5,1)=OBSTACLER(1,1);
    OBSTACLER(5,2)=OBSTACLER(1,2);
    
    %FRONT RIGHT
    OBSTACLER(2,1)=OBSTACLER(1,1)+OBSTACLE(4);
    OBSTACLER(2,2)=OBSTACLER(1,2);
    %REAR RIGHT
    OBSTACLER(3,1)=OBSTACLER(2,1);
    OBSTACLER(3,2)=OBSTACLER(2,2)-OBSTACLE(3);
    %REAR LEFT
    OBSTACLER(4,1)=OBSTACLER(1,1);
    OBSTACLER(4,2)=OBSTACLER(3,2);
    
    %OBSTACLER
    %KARTER
    
    

    %hold on
    
    axis([-10, 10, -10,50])
    
    %PLOT THE VEHICLE
    plot(KARTER(1:5,1),KARTER(1:5,2))
    hold on
    
    %PLOT OBSTACLE
    plot(OBSTACLER(1:5,1),OBSTACLER(1:5,2))
    hold on
    
    %PLOT ROAD
    %LEFT SIDE
    plot([ROAD(1);ROAD(1)],RT(1:2),'G')
    hold on
    %RIGHT SIDE
    plot([ROAD(2);ROAD(2)],RT(1:2),'G')
    hold on
    
    
    
end