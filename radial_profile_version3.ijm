/*  This macro calculate the mean distance of bacteria to nucleus border  normalized by the max distance from centroid to extremity of the cell
 *   
 *  CIML : Centre d'Immunologie de Marseille Luminy
 *  Mathieu Fallet for Stephane Meresse  18/06/2021  
 *   
 *  input :  2D image of 2048*2048 pixels  must contain three channels in this order
 *   C1 = cells contour, C2 = bacteria or lyzozome, C3 = DAPI  
 *   
 *  output : x nucleus centroid, y nucleus centroid, max Cell radius, max nucleus radius, Db=  bacteria mean distance to nucleus border, 
 *  Df= "Db/(max CellRadius-max NucleusRadius), Dc=bacteria Distance to nucelus centroid, Dc/max CellRadius 
 *  Radial profile of  bacteria/ nucleus and cells cytoplasm (or other staining allowing the cell maximum radius calculation from nucleus centroid)
 *  
 *  In the article : calculation of Df (fractionnal distance)
 *  Rc = maximum radius of the cell  
 *  Rn = maximum radius of the nucleus
 *  Using the Euclidean Distance Map (EDM) in 16 bits of the nucleus contour, the organelles mean distance to nucleus border (D) is extracted
 *  The fractional distance, is the normalization of this value between 0 and 1 obtained by dividing D by Rc minus Rn
 *  Df = D/(Rc-Rn)
*/ 


// Find nucleus centroid position and save the radial profile of nucleus from this centroid

run("Options...", "iterations=1 count=1 black edm=16-bit");
setForegroundColor(255, 255, 255);
setBackgroundColor(0, 0, 0);
run("Properties...", "channels=3 slices=1 frames=1 unit=px pixel_width=1 pixel_height=1 voxel_depth=1.0000000");
run("Make Composite", "display=Composite");
Stack.setDisplayMode("composite");
run("Canvas Size...", "width=2048 height=2048 position=Center zero");
name=getTitle; 
print("Image processed="+name);

if (roiManager("count")>0) 
     roiManager("Delete");
run("Select None");
run("Duplicate...", "title=toto duplicate");
run("Split Channels");

selectWindow("C2-toto");
rename("DAPI");
setMinAndMax(0, 14);
run("Clear Results");

if (roiManager("count")>1) {roiManager("Delete");}
waitForUser("Draw a nucleus");
roiManager("Add");

run("Set Measurements...", "centroid redirect=None decimal=3");


// use only for one cell (otherwise need a loop here)
numberOfCells = roiManager("count");
xPosition=newArray(numberOfCells);	
yPosition=newArray(numberOfCells);

		       roiManager("select", 0);
			   run("Fill", "slice");
			   run("Clear Outside", "slice");
			   run("Measure");
			   xPosition[0] = round(getResult("X"));
			   yPosition[0] = round(getResult("Y"));
			   print("x centroid="+xPosition[0]);
			   print("y centroid="+yPosition[0]);

	

// by default the maximum radius for the profile is defined at 500
// need to be changed  depending of cell diameter. If too big, it cause bug (outside image)

// use the plugin radial profile (NN), install it before
run("Radial Profile NN", "x="+xPosition[0]+" y="+yPosition[0]+" radius=500");

// save radial profile DAPI
waitForUser("save dapi radial profile in Data/Save Data csv");
//saveAs("Results", radial_profile_dapi.csv");
selectWindow("Radial Profile Plot");
close();


// Find cell contour max from centroid (useful for normamisation of radial profile)
roiManager("Delete");
//run("Clear Results")

// select dapi (this channel here is able to find the cells contour by autofluorescence using contrast enhancement) otherwise use channel 1 if better
selectWindow("C3-toto");
setMinAndMax(0, 0);
selectWindow("C3-toto");
waitForUser("Draw the contour of the cell ");
roiManager("Add");
roiManager("select", 0);
run("Fill", "slice");
run("Clear Outside");
run("Radial Profile NN", "x="+xPosition[j]+" y="+yPosition[j]+" radius=500");
Plot.getValues(x, y);
waitForUser("Save radial profile cells contour in Data/Save Data csv");	   
			 

// find the maximum distance from the centroid using the radial profile (index correpsonding to value = 0)
count =0;
str = "";
var done = false;

				for (k = 0; k <501&&!done; k++ ) { 
				//str +=  "" + x[k] + "\t" + y[k] + "\n"; 
                if (y[k]==0) { 
                	indice = count;
                    done = true; // break 
                    }
                else  
                    count++;
                }
print("Max Cell Radius="+x[indice]);


// Define the good threshold on dapi (at 5 by default)
// measure the major axis of the nucleus (diameter)

selectWindow("DAPI");
setOption("BlackBackground", true);
setThreshold(5, 255);
//waitForUser("Threshold ok ?");
run("Convert to Mask");
run("Set Measurements...", "mean fit limit redirect=None decimal=3");
setAutoThreshold("Default dark");
run("Measure");
major=getResult("Major");
print("Major nucleus axis radius="+major/2);

// invert mask (depending on binary option)
run("Invert");
// Distance map in 16 bits (otherwide in 8 bits the distance <255)
run("Distance Map");
rename("Distance_map");

// multilpy by bacteria 
selectWindow("C1-toto");
roiManager("select", 0);
run("Clear Outside");
run("Grays");
setAutoThreshold("Otsu dark");

// check the bacteria mask is  ok 
waitForUser("Threshold ok ?");
setOption("BlackBackground", true);
run("Convert to Mask");
run("16-bit");
rename("Mask_Bacteria");

selectWindow("Mask_Bacteria");
roiManager("select", 0);
run("Radial Profile NN", "x="+xPosition[0]+" y="+yPosition[0]+" radius=500");

// save bacteria radial profile
waitForUser("save bacteria radial profile");
selectWindow("Radial Profile Plot");
close();


// calculate the mean distance of bacteria to nucleus border by EDM (euclidian distance map)
imageCalculator("Multiply create 32-bit", "Distance_map","Mask_Bacteria");
run("Divide...", "value=255");
rename("Distance_Bacteria");
run("Enhance Contrast", "saturated=0.35");
setMinAndMax(0, 255);
run("Set Measurements...", "mean standard limit redirect=None decimal=3");
setThreshold(1, 500);
run("Measure");
distance = getResult("Mean");
std_distance = getResult("StdDev");
Norm_distance = distance/(x[indice]-(major/2));

print("Bacteria Mean distance to nucleus border="+distance);
print("Bacteria Std distance to nucleus border="+std_distance);
print("Db/(CellRadius-NucleusRadius)=Distance normalized by (max cell distance minus nucleus radius)="+Norm_distance);

// measure distance from the centroid
newImage("Untitled", "8-bit black", 1024, 1024, 1);
makePoint(xPosition[0], yPosition[0]);
run("Draw", "slice");
run("Invert");
run("Distance Map");
rename("Distance_map_from_centroid");

//imageCalculator("AND create 32-bit", "Distance_map_from_centroid","Mask_Bacteria");
imageCalculator("Multiply create 32-bit", "Distance_map_from_centroid","Mask_Bacteria");
run("Divide...", "value=255");
setMinAndMax(0, 255);
//waitForUser("Image distance bacteria  from centroid ok?");
setThreshold(1, 500);
run("Clear Results");
run("Measure");
distance_from_centroid = getResult("Mean");
std_distance_from_centroid = getResult("StdDev");


print("Dc=Bacteria Mean distance to  nucleus centroid="+distance_from_centroid);
print("Bacteria Std distance to nucleus centroid="+std_distance_from_centroid);

Norm_distance_from_centroid = distance_from_centroid/x[indice];
print("Mean nucleus Centroid distance of bacteria normalized by max cell radius="+Norm_distance_from_centroid);

//close not useful images
selectWindow("Distance_map");
close();  
selectWindow("Mask_Bacteria");
close();  
selectWindow("Distance_Bacteria");
close();
selectWindow("DAPI");
close();
selectWindow("C3-toto");
close();
selectWindow("Radial Profile Plot"); 
close();
selectWindow("Distance_map_from_centroid");
close();
selectWindow("Result of Distance_map_from_centroid");
close();
selectWindow("Untitled");
close();




// save results for the calculation of DF (fractionnal distance)
selectWindow("Log");
run("Clear Results");	
row=0;	

setResult("Image name  ", row, name);   
setResult("x nucleus centroid  ", row, xPosition[0]);   
setResult("y nucleus centroid  ", row, yPosition[0]);  
 
setResult("Radius=MaxCellRadius", row, x[indice]); 
setResult("NucleusRadius=Max Nucleus Radius", row, major/2);  

setResult("Db=Bacteria Mean distance to nucleus border", row, distance); 
setResult("Db_std=Bacteria Std distance to nucleus border", row, std_distance); 

// Df calculation
setResult("Db/(CellRadius-NucleusRadius)", row, Norm_distance); 
setResult("Db_std/(CellRadius-NucleusRadius)", row, std_distance/(x[indice]-major/2)); 

// Other possibity of calculation from nucleus centroid (ot used)
setResult("Dc=bacteria Distance to nucelus centroid", row, distance_from_centroid);
setResult("Dc_std", row, std_distance_from_centroid); 
setResult("Dc/CellRadius", row, Norm_distance_from_centroid); 
setResult("Dc_std/CellRadius", row, std_distance_from_centroid/x[indice]); 

// end
print("Task complete!");  


