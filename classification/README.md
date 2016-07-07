# Classify


###Apply classifier patch to caffe

Apply patch with `git apply full_classifier.patch`

### Run classify data script
  - Use absolute paths for the classify data script (no . or .. are allowed). This script moves around and relative paths can cause unknown errors to occur.
  - Pushes fivefold data through the fivefold networks
  - Run the following command.
``` shell
    /location/to/classify_data.sh <plan_dir> <plan_id> <network_root> <network_id> <classifier_bin> <img_root> <gpu> <filename>
```
  - Description of Variables:
    * ```<plan_dir>```: Location of the plans created by ```fivefold_create.sh```
    * ```<plan_id>```: keyword used when running ```fivefold_create.sh```
    * ```<network_root>```: location of networks created by ```fivefold_execute.sh```
    * ```<network_id>```: prefix of networks created by ```fivefold_execute.sh``` (should be the same as the network id when you ran fivefold_execute.sh
    * ```<classifier_bin>```: /path/to/caffe/build/examples/classifier.bin
    * ```<img_root>```: /path/to/image/set (UCMERCED, RSD, or whatever else).
    * ```<gpu>```: # indicating which gpu you would like the ```classify_data.sh``` script to use
    * ```<filename>```: this is used to create two files ```<filename>_accuracies.csv``` and ```<filename>_labels.csv```

 
### Description of other scripts:
  1. accuracy_to_confusion.sh
    * This script takes the .csv file created by ```classify_data.sh``` and outputs a confusion matrix which can be piped to a .csv file.
  2. accuray_to_perclass.sh
    * This script takes the .csv file created by ```classify_data.sh```and outputs the class, number correct for each class and the total number of correct classifications.
  3. reinterpret_data.sh
    * This script reads the .csv file created by ```classify_data.sh``` and using a new cutoff (use a decimal i.e. 0.95 for 95% or 0 for argmax) and pipe this into a new .csv file and use the previous two scripts with it.
