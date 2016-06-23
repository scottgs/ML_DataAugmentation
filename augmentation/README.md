###Requirements
  1. Image Magick
  
###Instructions
  1. Point the script to the dataset you want to augment.
      
      ```shell
      cd path/containing/dataset
      ./generate_anyOfTheScripts UCMerced
      ```
      
      Here replace anyOfTheScripts with augmented, rotate, cropped, flips and any other 
      image dataset you wish to augment in place of UCMerced.
      
      If you want to use the RSDataset then you need to:
        1. run clean_rsd.sh
        2. run resize_images.sh
        3. run generate_anyOfTheScripts.sh
