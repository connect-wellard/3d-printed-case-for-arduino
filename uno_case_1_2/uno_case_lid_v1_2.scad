//  ----------------------------------------------------------------------- LICENSE
//  This "3D Printed Case for Arduino Uno, Leonardo" by Zygmunt Wojcik is licensed
//  under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit
//  http://creativecommons.org/licenses/by-sa/3.0/
//  or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.


include <uno_case_param_v1_2.scad>

//------------------------------------------------------------------------- PARAMETERS
// lid holes dimensions

buttonSize = 4;
buttonXPos = 6.15;
buttonYPos = 50;
buttonBaseHeight = 2;
buttonBaseR = buttonSize/2 + 0.25 + layerWidth*3;

//------------------------------------------------------------------------- MODULES
module pcbLeg() {
	translate([0, 0, 0])
	difference() { 											
		cylinder(h = lidHeight - floorHeight - pcbPositionZ - pcbHeight, r = 5.7/2);
	}
}

module buttonFrame() {
	translate([0, 0, -0.05])
	cylinder(h=2, r1=buttonSize/2 + 0.5 + 1, r2=buttonSize/2 + 0.5);
}


//------------------------------------------------------------------------- MAIN BLOCK
difference()
{
																		// ADD
	union()
	{
		// Add Base
		linear_extrude(height = lidHeight + blockLockSize, convexity = 10)
		minkowski()
		{									
			square([width, wide], center = true);
			circle(roundR);
		}
	}
																		// SUBSTRACT
	union()
	{
		// lift floor height
		translate([0, 0, floorHeight])
		{
			// Cut base inner hole
			linear_extrude(height = lidHeight, convexity = 10)
			minkowski()
			{
				square([width, wide], center = true);
				circle(roundR - pillarSize);
			}
			// Cut block lock
			translate([0, 0, lidHeight - blockLockSize])
			linear_extrude(height = lidHeight, convexity = 10)
			minkowski()
			{
				square([width, wide], center = true);
				circle(roundR - layerWidth*3);
			}
			// Cut x panels 
			for (i = [0 : 180 : 180])				
			rotate([0, 0, i])
			translate([width/2 + roundR - pillarSize/2 - layerWidth*7, 0, 0])
			{
				// Cut X panel hole
				translate([0, 0, lidHeight/2])
				cube([pillarSize, sidePanelXWidth, lidHeight], center=true);

				// Cut X, Y srew holes
				for (i = [wide/2, -wide/2])
				{
					translate([-(roundR - pillarSize/2 - layerWidth*7), i, 0])
					if (i>0) 
					{
						rotate([0, 0, 45])
						translate([screwHoleRoundR, 0, 0])
						cylinder(h=lidHeight, r=verConnectionHoleR);
					}
					else
					{
						rotate([0, 0, -45])
						translate([screwHoleRoundR, 0, 0])
						cylinder(h=lidHeight, r=verConnectionHoleR);
					}
				}
			}
			// Cut Y panels 
			for (i = [90 : 180 : 270])
			rotate([0, 0, i])
			translate([wide/2 + roundR - pillarSize/2 - layerWidth*7, 0, 0])
			{
				// Cut Y panel hole
				translate([0, 0, lidHeight/2])
				cube([pillarSize, sidePanelYWidth, lidHeight], center=true);
			}
			
            // Cut USB and Power holes
			// Rotate due to panel upside down
			mirror([0, 1 , 0])
			      // Cut USB and Power holes
            
			// translate to pcb position
			translate([-pcbPositionX, -pcbWide/2, lidHeight - floorHeight*2 -pcbPositionZ-pcbHeight])
			{
				// button
				translate([buttonXPos, buttonYPos, -17])
				cylinder(h = 5, r = buttonSize/2 + 0.5);
				// buttonFrame
				translate([buttonXPos, buttonYPos, -(lidHeight - floorHeight -pcbPositionZ-pcbHeight)])
				buttonFrame();
			}
		}
	}
}
//------------------------------------------------------------------------- ADD PCB LEGS
// Rotate due to panel upside down
mirror([0, 1 , 0])

// Translate to pcbPositionX	
translate([-pcbPositionX, -pcbWide/2, 0])

difference()
{
																		// ADD
	union()
	{
		
		// button
		translate([buttonXPos, buttonYPos, 0])

		cylinder(h = lidHeight - floorHeight - pcbPositionZ - pcbHeight - 3 - buttonBaseHeight - layerHeight*2,
				r = buttonBaseR);
	}
																		// SUBSTRACT
	union()
	{
		// Cut connectors holes
		
		// buttonFrame
		translate([buttonXPos, buttonYPos, 0])
		buttonFrame();
	}
}