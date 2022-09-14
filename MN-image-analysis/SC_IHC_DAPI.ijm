//Macro written by Eleni Christoforidou.

currentDir=getDir("Choose a Directory");
open("MAX_C1_grey.tif");
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

//Calculate the area of the cell ROIs
function calculateNucleusShape(i) {
	roiManager("Select", findIndexByName("nucleus"+i));
	run("Set Measurements...", "area redirect=None decimal=3");
	run("Measure");
}

//CALL THE FUNCTIONS
renameROIs();
cellCount=roiManager("count")/2;

for (i=0; i<cellCount; i++) {
	createCytoplasm(i+1);
}

for (i=0; i<cellCount; i++) {
	calculateNucleusShape(i+1);
}
saveAs("Results", currentDir+"/DAPIshape.csv");
close("Results");
close();
selectWindow("ROI Manager");
run("Close");