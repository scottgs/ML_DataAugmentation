### Requirements
  1. Image Magick
  
### Instructions
  1. Point the script to the dataset you want to augment.
      
      ```shell
      cd path/containing/dataset
      ./generate_<operation> UCMerced
      ```
      
      Here replace __<operation>__ with augmented, rotate, cropped, flips and any other 
      image dataset you wish to augment in place of UCMerced.
      
### RSData Set Pre-processing
      If you want to use the RSDataset then you need to:
      1. run clean_rsd.sh
      2. run resize_images.sh

Then commence with generate_<operation>.sh scripts
