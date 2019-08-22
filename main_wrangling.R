# INIT --------------------------------------------------------------------

  if (!require("rstudioapi")) install.packages("rstudioapi"); library("rstudioapi")

  # HDF5 Library for R
  # https://cran.r-project.org/web/packages/h5/vignettes/h5-Intro.html
  # configure: error: 'h5c++' does not seem to be installed on your platform.
  # sudo apt-get install libhdf5-dev
  if (!require("h5")) install.packages("h5"); library("h5")

  # for Ubuntu, TODO! for Windows

  # https://stackoverflow.com/questions/1815606/rscript-determine-path-of-the-executing-script
  
  full_path = rstudioapi::getActiveDocumentContext()$path
  
  if (!exists("full_path")) {
    warning(' The location of this file "clean_and_reconstruct_all_PLR.R" for some reason was not detected?\n')
  } else {
    paths = list()
    script.dir = strsplit(full_path, split = .Platform$file.sep, fixed=TRUE)[[1]]
    just_the_file = tail(script.dir,1)
    cat('   --- just_the_file = ', just_the_file, '\n')
    cat('   --- --- full_path_script = ', full_path, '\n\n')
    script.dir = gsub(just_the_file, '', full_path)
    
    # remove the last separator
    if (substr(script.dir, nchar(script.dir), nchar(script.dir)) == '/') {
      script.dir = substr(script.dir, 1, nchar(script.dir)-1)
    } else if (substr(script.dir, nchar(script.dir), nchar(script.dir)) == '/') { # TODO Windows?
      script.dir = substr(script.dir, 1, nchar(script.dir)-1)
    }
    paths[['code']] = script.dir
    paths[['main_file']] = file.path(paths[['code']], 'main_wrangling.R', fsep = .Platform$file.sep)
    paths[['data']] = file.path(paths[['code']], '..', 'KiMoRe', fsep = .Platform$file.sep)
    paths[['data_h5']] = file.path(paths[['data']], 'KiMoRe_outliersMasked.h5', fsep = .Platform$file.sep)
  }
  
# Import data from HDF5 ----------------------------------------------

  f <- h5file(paths[['data_h5']], "r")
  f["testgroup/testset"] <- rnorm(100)
  testattr <- LETTERS[round(runif(100, max=26))]
  h5attr(f["testgroup/testset"], "testattr") <- testattr
  f["testgroup/testset"]
  
  

# SUBFUNCTIONS ----------------------------------------------
  
list_the_files = function(paths) {
  
  
  
}
