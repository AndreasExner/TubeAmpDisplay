# TubeAmpDisplay

THIS IS A DRAFT

OLED display for a vacuum tube amplifier






## Tools

Bitmap Converter for the lcdgfx library
Version: 0.2 2021-03-22
Author: Andreas Exner

Description:

The lcdgfx library (https://github.com/lexus2k/lcdgfx) can handle up to 16 Bit RGB565 bitmaps. 
However, the library expects a little endian encoded uint_8 array of the bitmap while most of
the bitmap convertes (for example http://javl.github.io/image2cpp/) are providing a uint_16 
encoded output.

Due to the limited ressources of the desired hardware, it seems to be difficult and not very 
usefull to convert the data during runtime. This PS script does the job on every Windows based 
PC. For other plattforms please feel free to adopt the process. 

How to use:
- create a bitmap with a grafic tool of your choice
- use the converter http://javl.github.io/image2cpp/ to export the code
    - choose "plain bytes" and "Horizontal - 2 bytes per line(565) for the output
- copy & paste the output into a .txt file inside the source folder
    - the file name prefix will be used for the destination file and the name of the pointer!
    - you can convert multiple files from the source folder at the same time
    - existing files in the destionation folder are overwritten without warning!
- check and choose the parameters of this script to fit your requirements
- run the script (I recommend to use the ISE)
- the resulting .h and .cpp files can be used like documented in the lcdgfx library.  


