                                                                                 local v0=...;if  not  
                                                                        v0 then warn(                                   
                                                                    "Module harus di-load dari ZonIndex!");return;end getgenv().  
                                                                ScriptVersion="AutoClear v65 - Zero-Spin & Clean Stop";getgenv().       
                                                            AutoClearEnabled=false;getgenv().AC_StartX=0 + 0 ;getgenv().AC_EndX=269 -169  
                                                          ;getgenv().AC_StartY=37;getgenv().AC_EndY=6;getgenv().AC_MaxHits=72 -32 ;getgenv( 
                                                        ).AC_HoverHeight=5 + 1 ;getgenv().AC_HitDelay=1027 -(915 + 82) ;getgenv().GridSize=   
                                                      4.5;getgenv().GlideSpeed=5.5 -3 ;getgenv().AC_ResumeX=nil;getgenv().AC_ResumeY=nil;       
                                                    getgenv().AC_ArahKanan=nil;getgenv().AC_FixedZ=nil;getgenv().AC_Blacklist=getgenv().          
                                                  AC_Blacklist or {} ;local v17=game:GetService("Players");local v18=v17.LocalPlayer;local v19=game 
                                                  :GetService("ReplicatedStorage");local v20=game:GetService("UserInputService");local v21=game:      
                                                GetService("VirtualUser");v18.Idled:Connect(function() local v33=0 + 0 ;while true do if (v33==(0 -0))  
                                                then v21:CaptureController();v21:ClickButton2(Vector2.new());break;end end end);local v22;pcall(function( 
                                              ) v22=require(v18.PlayerScripts:WaitForChild("PlayerMovement"));end);local v23=v19:WaitForChild("Remotes");   
                                              local v24=v23:WaitForChild("PlayerFist");local v25={Item=Color3.fromRGB(1232 -(1069 + 118) ,101 -56 ,45),Text 
                                            =Color3.fromRGB(255,255,557 -302 ),Purple=Color3.fromRGB(140,14 + 66 ,453 -198 )};local function v26(v34,v35,v36) 
                                             local v37=Instance.new("TextButton",v34);v37.BackgroundColor3=v25.Item;v37.Size=UDim2.new(1 + 0 , -10,0,826 -(368  
                                          + 423) );v37.Text="";v37.AutoButtonColor=false;local v43=Instance.new("UICorner",v37);v43.CornerRadius=UDim.new(0 -0 ,  
                                          24 -(10 + 8) );local v45=Instance.new("TextLabel",v37);v45.Text=v35;v45.TextColor3=v25.Text;v45.Font=Enum.Font.           
                                          GothamSemibold;v45.TextSize=12;v45.Size=UDim2.new(3 -2 , -(482 -(416 + 26)),3 -2 ,0 + 0 );v45.Position=UDim2.new(0 -0 ,10,0 
                                          ,438 -(145 + 293) );v45.BackgroundTransparency=431 -(44 + 386) ;v45.TextXAlignment=Enum.TextXAlignment.Left;local v57=      
                                        Instance.new("Frame",v37);v57.Size=UDim2.new(0,1522 -(998 + 488) ,0,6 + 12 );v57.Position=UDim2.new(1 + 0 , -(817 -(201 + 571)) 
                                        ,0.5, -(1147 -(116 + 1022)));v57.BackgroundColor3=Color3.fromRGB(30,  --[[==============================]]124 -94 ,18 + 12 );     
                                        local v61=Instance.new("UICorner",v57);v61.CornerRadius=    --[[============================================]]UDim.new(3 -2 ,0);  
                                        local v63=Instance.new("Frame",v57);v63.Size=UDim2.new( --[[======================================================]]0,49 -35 ,0,14) 
                                      ;v63.Position=UDim2.new(859 -(814 + 45) ,4 -2 ,0.5 +  --[[==========================================================]]0 , -(3 + 4));v63 
                                      .BackgroundColor3=Color3.fromRGB(985 -(261 + 624) , --[[==============================================================]]100,177 -77 );  
                                      local v67=Instance.new("UICorner",v63);v67.         --[[================================================================]]CornerRadius=   
                                      UDim.new(1,1080 -(1020 + 60) );v37.                 --[[==================================================================]]              
                                      MouseButton1Click:Connect(function() getgenv()[v36] --[[==================================================================]]= not getgenv()   
                                    [v36];if getgenv()[v36] then local v150=1423 -(630 +  --[[====================================================================]]793) ;while   
                    true do if (v150==(3 -2)) then v57.BackgroundColor3=v25.Purple;break; --[[====================================================================]]end if (v150==( 
              0 -0)) then v63:TweenPosition(UDim2.new(1 + 0 , -16,0.5 -0 , -7),"Out",     --[[======================================================================]]"Quad",1747.2 
             -(760 + 987) ,true);v63.BackgroundColor3=Color3.new(1914 -(1789 + 124) ,1,   --[[======================================================================]]767 -(745 +   
          21) );v150=1 + 0 ;end end else local v151=0;while true do if (v151==(2 -1))     --[[======================================================================]]then v57.     
        BackgroundColor3=Color3.fromRGB(117 -87 ,30,30);break;end if (v151==(0 + 0)) then --[[======================================================================]] v63:         
        TweenPosition(UDim2.new(0,2 + 0 ,0.5, -(1062 -(87 + 968))),"Out","Quad",0.2 -0 ,  --[[======================================================================]]true);v63.    
      BackgroundColor3=Color3.fromRGB(91 + 9 ,226 -126 ,1513 -(447 + 966) );v151=2 -1 ;   --[[======================================================================]]end end end   
      end);end local function v27(v69,v70,v71,v72,v73,v74) local v75=Instance.new("Frame",  --[[==================================================================]]v69);v75.       
      BackgroundColor3=v25.Item;v75.Size=UDim2.new(1818 -(1703 + 114) , -(711 -(376 + 325)) --[[================================================================]],0 -0 ,45);local  
    v79=Instance.new("UICorner",v75);v79.CornerRadius=UDim.new(0 -0 ,2 + 4 );local v81=     --[[==============================================================]]Instance.new(     
    "TextLabel",v75);v81.Text=v70   .. ": "   .. v73 ;v81.TextColor3=v25.Text;v81.            --[[==========================================================]]                    
    BackgroundTransparency=2 -1 ;v81.Size=UDim2.new(15 -(9 + 5) ,376 -(85 + 291) ,0,20);v81.    --[[====================================================]]Position=UDim2.new(1265 
     -(243 + 1022) ,38 -28 ,0 + 0 ,2);v81.Font=Enum.Font.GothamSemibold;v81.TextSize=12;v81.      --[[==============================================]]TextXAlignment=Enum.      
    TextXAlignment.Left;local v93=Instance.new("TextButton",v75);v93.BackgroundColor3=Color3.fromRGB( --[[====================================]]1210 -(1123 + 57) ,25 + 5 ,   
    284 -(163 + 91) );v93.Position=UDim2.new(1930 -(1869 + 61) ,3 + 7 ,0 -0 ,42 -14 );v93.Size=UDim2.new( --[[========================]]1 + 0 , -(27 -7),0 + 0 ,1480 -(1329 + 
     145) );v93.Text="";v93.AutoButtonColor=false;local v99=Instance.new("UICorner",v93);v99.CornerRadius=UDim.new(972 -(140 + 831) ,1850 -(1409 + 441) );local v101=       
  Instance.new("Frame",v93);v101.BackgroundColor3=v25.Purple;v101.Size=UDim2.new((v73-v71)/(v72-v71) ,718 -(15 + 703) ,1 + 0 ,438 -(262 + 176) );local v105=Instance.new( 
  "UICorner",v101);v105.CornerRadius=UDim.new(1722 -(345 + 1376) ,688 -(198 + 490) );local v107=false;local function v108(v136) local v137=math.clamp((v136.Position.X- 
  v93.AbsolutePosition.X)/v93.AbsoluteSize.X ,0,1);local v138=math.floor(v71 + ((v72-v71) * v137) );v101.Size=UDim2.new(v137,0,4 -3 ,0 -0 );v81.Text=v70   .. ": "   ..   
  v138 ;getgenv()[v74]=v138;if (string.find(v74,"AC_Start") or string.find(v74,"AC_End")) then getgenv().AC_ResumeX=nil;getgenv().AC_ResumeY=nil;getgenv().AC_FixedZ=nil; 
  end end v93.InputBegan:Connect(function(v142) if ((v142.UserInputType==Enum.UserInputType.MouseButton1) or (v142.UserInputType==Enum.UserInputType.Touch)) then local   
  v155=0;while true do if (v155==0) then v107=true;v108(v142);break;end end end end);v20.InputEnded:Connect(function(v143) if ((v143.UserInputType==Enum.UserInputType.   
  MouseButton1) or (v143.UserInputType==Enum.UserInputType.Touch)) then v107=false;end end);v20.InputChanged:Connect(function(v144) if (v107 and ((v144.UserInputType==   
  Enum.UserInputType.MouseMovement) or (v144.UserInputType==Enum.UserInputType.Touch))) then v108(v144);end end);end v26(v0,"Start Auto Clear World","AutoClearEnabled"); 
  v27(v0,"Start X",1206 -(696 + 510) ,500,0,"AC_StartX");v27(v0,"End X",0,1048 -548 ,100,"AC_EndX");v27(v0,"Start Y",1262 -(1091 + 171) ,150,6 + 31 ,"AC_StartY");v27(v0, 
  "End Y",0,150,18 -12 ,"AC_EndY");v27(v0,"Max Hits",10,663 -463 ,414 -(123 + 251) ,"AC_MaxHits");v27(v0,"Hover Height",2,49 -39 ,704 -(208 + 490) ,"AC_HoverHeight");v27 
  (v0,"Hit Delay ms",0 + 0 ,45 + 55 ,866 -(660 + 176) ,"AC_HitDelay");local function v28(v109) local v110=v18.Character;local v111=v110 and v110:FindFirstChild(          
  "HumanoidRootPart") ;local v112=v110 and v110:FindFirstChildOfClass("Humanoid") ;local v113=workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(v18.   
  Name) ;if v112 then v112.PlatformStand=v109;end local v114={v111,v113};for v145,v146 in ipairs(v114) do if v146 then v146.Anchored=false;v146.RotVelocity=Vector3.zero;   
  v146.AssemblyAngularVelocity=Vector3.zero;if v109 then v146.CanCollide=false;local v176=v146:FindFirstChild("ZON_FlyBV") or Instance.new("BodyVelocity") ;v176.Name=      
  "ZON_FlyBV";v176.MaxForce=Vector3.new(1000000202 -(14 + 188) ,1000000000,1000000675 -(534 + 141) );v176.Velocity=Vector3.zero;v176.Parent=v146;else v146.CanCollide=true; 
  if v146:FindFirstChild("ZON_FlyBV") then v146.ZON_FlyBV:Destroy();end v146.CFrame=CFrame.new(v146.Position);end end end end local function v29(v115,v116) local v117=0 +  
  0 ;local v118;local v119;local v120;local v121;while true do if (v117==3) then for v168,v169 in ipairs(v121) do if v169:IsA("BasePart") then local v192=0 + 0 ;local v193 
  ;local v194;while true do if (v192==(1 + 0)) then if (string.find(v193,"bedrock") or string.find(v194,"bedrock") or string.find(v193,"door") or string.find(v194,"door")  
  or string.find(v193,"main")) then return true;end break;end if ((0 -0)==v192) then v193=string.lower(v169.Name);v194=(v169.Parent and string.lower(v169.Parent.Name)) or  
  "" ;v192=1;end end end end return false;end if ((1 -0)==v117) then v120=OverlapParams.new();v120.FilterDescendantsInstances={v18.Character,workspace.CurrentCamera};v117= 
  5 -3 ;end if (v117==(0 + 0)) then v118=getgenv().AC_FixedZ or 0 ;v119=Vector3.new(v115 * getgenv().GridSize ,v116 * getgenv().GridSize ,v118);v117=1 + 0 ;end if (v117==( 
  398 -(115 + 281))) then v120.FilterType=Enum.RaycastFilterType.Exclude;v121=workspace:GetPartBoundsInBox(CFrame.new(v119),Vector3.new(3,6 -3 ,42 + 8 ),v120);v117=3;end   
  end end local function v30(v122,v123) if getgenv().AC_Blacklist[v122   .. ","   .. v123 ] then return false;end local v124=getgenv().AC_FixedZ or (0 -0) ;local v125=     
  Vector3.new(v122 * getgenv().GridSize ,v123 * getgenv().GridSize ,v124);local v126=OverlapParams.new();v126.FilterDescendantsInstances={v18.Character,workspace.          
  CurrentCamera};v126.FilterType=Enum.RaycastFilterType.Exclude;local v130=workspace:GetPartBoundsInBox(CFrame.new(v125),Vector3.new(3,870 -(550 + 317) ,50),v126);for    
  v147,v148 in ipairs(v130) do if v148:IsA("BasePart") then local v163=0;local v164;local v165;while true do if (v163==0) then v164=string.lower(v148.Name);v165=(v148.   
  Parent and string.lower(v148.Parent.Name)) or "" ;v163=1;end if (v163==(1 -0)) then if (string.find(v164,"door") or string.find(v165,"door") or string.find(v164,       
    "spawn")) then continue;end return true;end end end end return false;end local function v31(v131) local v132=0;local v133;local v134;while true do if (v132==(1 -0))  
    then if ( not v133 or  not v134) then return;end while getgenv().AutoClearEnabled do local v170=v133.Position;local v171=(v131-v170).Magnitude;if (v171<=getgenv().   
    GlideSpeed) then v133.CFrame=CFrame.new(v131);v134.CFrame=CFrame.new(v131);if v22 then pcall(function() v22.Position=v131;end);end break;else local v197=0 -0 ;local  
    v198;while true do if (v197==(286 -(134 + 151))) then v134.CFrame=CFrame.new(v198);if v22 then pcall(function() v22.Position=v198;end);end break;end if (v197==0)     
      then v198=v170 + ((v131-v170).Unit * getgenv().GlideSpeed) ;v133.CFrame=CFrame.new(v198);v197=1;end end end task.wait();end break;end if (v132==(1665 -(970 + 695 
      ))) then v133=workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(v18.Name) ;v134=v18.Character and v18.Character:FindFirstChild(              
      "HumanoidRootPart") ;v132=1 -0 ;end end end local v32=false;task.spawn(function() while task.wait(1990.2 -(582 + 1408) ) do if (getgenv().AutoClearEnabled and    
        not v32) then v32=true;local v166=workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(v18.Name) ;if (getgenv().AC_ResumeX==nil) then local   
        v184=0 -0 ;while true do if (v184==(1 -0)) then getgenv().AC_ResumeX=getgenv().AC_StartX;if v166 then getgenv().AC_FixedZ=v166.Position.Z;end break;end if (    
        v184==(0 -0)) then getgenv().AC_ResumeY=getgenv().AC_StartY;getgenv().AC_ArahKanan=true;v184=1825 -(1195 + 629) ;end end end local v167=getgenv().AC_FixedZ or  
          0 ;v28(true);while getgenv().AutoClearEnabled and (getgenv().AC_ResumeY>=getgenv().AC_EndY)  do local v172=getgenv().AC_ResumeY-1 ;local v173=(getgenv().   
            AC_ArahKanan and (1 -0)) or  -1 ;local v174=getgenv().AC_ResumeY>=(278 -(187 + 54)) ;while getgenv().AutoClearEnabled do local v185=getgenv().AC_ResumeX; 
              if ((getgenv().AC_ArahKanan and (v185>getgenv().AC_EndX)) or ( not getgenv().AC_ArahKanan and (v185<getgenv().AC_StartX))) then break;end if v29(v185,  
                v172) then getgenv().AC_Blacklist[v185   .. ","   .. v172 ]=true;elseif v30(v185,v172) then local v211=workspace:FindFirstChild("Hitbox") and         
                  workspace.Hitbox:FindFirstChild(v18.Name) ;local v212=v18.Character and v18.Character:FindFirstChild("HumanoidRootPart") ;local v213;if v174 then 
                       v213=Vector3.new(v185 * getgenv().GridSize ,((v172 + (781 -(162 + 618))) * getgenv().GridSize) + getgenv().AC_HoverHeight ,v167);else v213=  
                                  Vector3.new((v185-v173) * getgenv().GridSize ,v172 * getgenv().GridSize ,v167);end v31(v213);if v211 then v211.Anchored=true;end  
                                      if v212 then v212.Anchored=true;end local v214=0 + 0 ;while v30(v185,v172) and getgenv().AutoClearEnabled  do if v211 then    
                                      v211.CFrame=CFrame.new(v213);end if v212 then v212.CFrame=            CFrame.new(v213);end if v22 then pcall(function() v22.  
                                      Position=v213;end);end if v29(v185,v172) then break;end v24:          FireServer(Vector2.new(v185,v172));v214=v214 + 1 + 0  
                                      ;if (v214>getgenv().AC_MaxHits) then getgenv().AC_Blacklist[          v185   .. ","   .. v172 ]=true;break;end task.wait(   
                                      getgenv().AC_HitDelay/(2132 -1132) );end if v211 then v211.           Anchored=false;end if v212 then v212.Anchored=false;  
                                      end end getgenv().AC_ResumeX=getgenv().AC_ResumeX + v173 ;end            if getgenv().AutoClearEnabled then getgenv().      
                                      AC_ResumeY=getgenv().AC_ResumeY-(1 -0) ;getgenv().                      AC_ArahKanan= not getgenv().AC_ArahKanan;getgenv(). 
                                      AC_ResumeX=(getgenv().AC_ArahKanan and getgenv().AC_StartX)             or getgenv().AC_EndX ;end end v32=false;v28(false 
                                        );end end end);
