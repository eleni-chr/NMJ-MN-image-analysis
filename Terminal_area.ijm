dir = getDirectory("Choose a Directory ");
   setBatchMode(true);
   count = 0;
   countFiles(dir);
   n = 0;
   processFiles(dir);
   saveAs("results",dir+"Terminal_area.csv");
   close("Results");
   
   function countFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }

   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (!endsWith(list[i], "/")){
             showProgress(n++, count);
             path = dir+list[i];
             File.makeDirectory(dir+"Terminal area");
             processFile(path, list[i]);
          }
      }
  }

  function processFile(path, filename) {
       if (endsWith(path, ".tif")) {
           open(path);
           fname=dir+"Terminal area\\"+filename;
           run("Set Scale...", "distance=1 known=0.1803751711 unit=um");
           setAutoThreshold("Default dark");
           run("Create Selection");
           run("Set Measurements...", "area min display add redirect=None decimal=3");
           run("Measure");
           saveAs("Tiff",fname);
           close();
      }
  }
