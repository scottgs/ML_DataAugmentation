### Plan
  * Generates a listing of files for fivefold execution in a text file to be read by fivefold.

  1. ```/path/to/fivefold_plan.sh <src_dir> <append_str>```
    * ```<src_dir>```: source directory where the images are located
    * ```<append_str>```: string appended to the beginning of the plan

### Create
  * Creates lmdb databases for fivefold execution

  1. ```/path/to/fivefold_create.sh <identifier> <path_to_data> <path_to_caffe_root>```
    * ```<identifier>```: this is the name of the database and needs to be the same as the ```<append_str>``` used in the previous command.
    * ```<path_to_data>```: source directory where the images are located
    * ```<path_to_caffe_root>```: use an absolute path for the caffe directory

### Execute
  * Creates and executes fivefold networks

  1. ```path/to/fivefold_execute.sh <template_path> <weights> <plan_dir> <plan_identifier> <gpus> <finished_dst> <caffe_root>```
   * ```<template_path>```: caffe templates i.e. network you would like to run (google and caffe are included in this git repo).
   * ```<weights>```: path to weights you would like use to when you start training.
   * ```<plan_dir>```: point this to the path where the ```fivefold_create.sh``` script created the databases
   * ```<plan_identifier>```: prefix which tells the script which database plan to read
   * ```<gpus>```: gpu you would like to use to run caffe goes here
   * ```<finished_dst>```: this is where the fivefolds will be copied to once they are completed.
   * ```<caffe_root>```: location of caffe

### Dry Run
  * Same directions as ```fivefold_execute.sh```, this script prints commands that would be used, useful for dividing or resuming work

 ### Generate files
   * These scripts are used by the fivefold_plan script and are not meant to be ran by themselves.
