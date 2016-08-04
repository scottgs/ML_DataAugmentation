### Requirements
  1. Image Magick
  
### General Instructions
  1. Point the script to the dataset you want to augment.
      
      ```shell
      cd /location/of/ML_DataAugmentation
      ./generate_<operation> /path/to/UCMerced
      ```
      
      Here replace ```<operation>``` with augmented, rotate, cropped, flips and any other 
      image dataset you wish to augment in place of UCMerced.
      
### Operations 
   1.  Crop Images: This script crops the images so that they are 227x227
   2.  Horizontal and Vertical Flips: This script flips each picture across the X and Y axis resulting in 3x data augmentation.
   3.  Rotate: This script generates the +7 through -7 degree rotations for the original image, then rotates the image 90, 180, and 270 and generates the +7 through -7 degree rotations for each.
   4.  Augment: This script generates the full augmented dataset in the GRSL paper resulting in 120x data augmentation.

##WARNING: 
  If you want to produce the fully augmented dataset use the ```generate_augmented.sh``` file if you run both flip and rotate you will have duplicate images.

### RSData Set Pre-processing
      If you want to use the RSDataset then you need to:
      1. run clean_rsd.sh
      2. run resize_images.sh

Then commence with generate_<operation>.sh scripts
