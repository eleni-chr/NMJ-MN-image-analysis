//Macro written by Eleni Christoforidou.

currentDir=getDir("Choose a Directory");
open("MAX_C4_grey.tif");
open("ManualROIs.zip");

//DECLARE FUNCTIONS

//Assign indices to ROIs
function findIndexByName(title) {
	count=roiManager("count");
	index=-1;
	for (i=0; i<count; i++){
		roiManager("select", i);
		if (getInfo("selection.name")==title){
			index=i;
		}
	}
	return index;
}

//Give a name to all the ROIs in the ROI Manager
function renameROIs() {
	count=roiManager("count");
	for (i=0; i<count; i++){
		roiManager("select", i);
		if (i%2==0){
			roiManager("Rename", "nucleus"+(i/2)+1)
		}
		else {
			roiManager("Rename", "cell"+Math.floor(i/2)+1)
		}
	}
}

//Create a new ROI outlining the cytoplasm, excluding the nucleus
function createCytoplasm(i) {
	roiManager("Select", newArray(findIndexByName("nucleus"+i),findIndexByName("cell"+i)));
	roiManager("XOR");
	roiManager("Add");
	roiManager("Select", roiManager("count")-1);
	roiManager("Rename", "cytoplasm"+i);
}

//Calculate the integrated density of the nucleus ROIs
function calculateIntDenNucleus(i) {
	roiManager("Select", findIndexByName("nucleus"+i));
	run("Set Measurements...", "area integrated redirect=None decimal=3");
	run("Measure");
}

//Calculate the integrated density of the cytoplasm ROIs
function calculateIntDenCytoplasm(i) {
	roiManager("Select", findIndexByName("cytoplasm"+i));
	run("Set Measurements...", "area integrated redirect=None decimal=3");
	run("Measure");
}

//CALL FUNCTIONS
renameROIs();
cellCount=roiManager("count")/2;

for (i=0; i<cellCount; i++) {
	createCytoplasm(i+1);
}

for (i=0; i<cellCount; i++) {
	calculateIntDenNucleus(i+1);
}
saveAs("Results", currentDir+"/NucleusIntDen.csv");
close("Results");

for (i=0; i<cellCount; i++) {
	calculateIntDenCytoplasm(i+1);
}
saveAs("Results", currentDir+"/CytoplasmIntDen.csv");
close("Results");

//Save the ROI Manager
roiManager("Save", currentDir+"/ROIs.zip");
selectWindow("ROI Manager");
run("Close");
close();