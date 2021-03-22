<#

Bitmap Converter for the lcdgfx library - multiple bitmaps edition

Version: 0.1 2021-03-22
Author: Andreas Exner


Description:

The lcdgfx library (https://github.com/lexus2k/lcdgfx) can handle up to 16 Bit RGB565 bitmaps. 
However, the library expects a little endian encoded uint_8 array of the bitmap while most of
the bitmap convertes (for example http://javl.github.io/image2cpp/) are providing a uint_16 
encoded output.

Due to the limited ressources of the desired hardware, it seems to be difficult and not very 
usefull to convert the data during runtime. This PS script does the job on ever Windows based 
PC. For other plattforms please feel free to adopt the process. 

THIS VERSIONS is for the conversation of multiple bitmaps in one file / output! 
For example numbers or glyphs.


How to use:

- create the bitmaps with a grafic tool of xour choice
- use the converter http://javl.github.io/image2cpp/ to export the code
    - upload all bitmaps at once
    - enter unique glyphs to identify the bitmaps
    - choose "plain bytes" and "Horizontal - 2 bytes per line(565) for the output
- copy & paste the output into a .mtxt file inside the source folder
    - the file name prefix will be used for the destination file and the name of the pointer!
    - you can convert multiple files from the source folder at the same time
    - existing files in the destionation folder are overwritten without warning!
- check and choose the parameters of this script to fit your requirements
- run the script (I recommend to use the ISE)
- the resulting .h and .cpp files can be used like documented in the lcdgfx library.       

  
MIT License
  
Copyright (c) 2021 Andreas Exner
  
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

#>

### parameters

$inputPath = "D:\04_OneDrive\OneDrive - exneran.de\Dokumente\Arduino\_F5\TubeAmpDisplayESP32\txt" # folder with sorce files (*.txt)
$outputPath = "D:\04_OneDrive\OneDrive - exneran.de\Dokumente\Arduino\_F5\TubeAmpDisplayESP32" # folder for destination files (*.cpp, *.h)


$inputFile = $inputPath + "\numbersYellowBig.mtxt"

$itemsPerLine = 16 # items (16 bit = 2x 8 bit) per line, for better human readable output

###################################################### Don not change anything below this line ##########################################

### functions ############

function createFiles {

    param ($outputPath, $bitmapName)

    ### create output files (overwrite if exist)

    ### write header file
    Write-Host ("Creating header file: " + $bitmapName + ".h")
    $outputString = '#include "lcdgfx.h"' + [Environment]::NewLine + [Environment]::NewLine
    $dump = New-Item -Path $outputPath -Name ($bitmapName + ".h") -ItemType "file" -Value $outputString -Force

    ### write code file
    Write-Host ("Creating code file: " + $bitmapName + ".cpp")
    $outputString = '#include "' + $bitmapName + '.h"' + [Environment]::NewLine + [Environment]::NewLine
    $dump = New-Item -Path $outputPath -Name ($bitmapName + ".cpp") -ItemType "file" -Value $outputString -Force
}

function appendBitmap {

    param ($outputPath, $bitmapName, $bitmapSubName, $bitmapArray, $itemsPerLine)

    ### append header file
    $outputFilePath = $outputPath + "\" + $bitmapName + ".h"
    $outputString = 'extern const uint8_t ' + $bitmapName +  $bitmapSubName + '[' + ($bitmapArray.Length * 2) + '] PROGMEM;' + [Environment]::NewLine
    Add-Content -Path  $outputFilePath -Value $outputString

    ### append code file
    $outputFilePath = $outputPath + "\" + $bitmapName + ".cpp"
    $outputString = 'const uint8_t ' + $bitmapName +  $bitmapSubName + '[' + ($bitmapArray.Length * 2) + '] PROGMEM = {' + [Environment]::NewLine
    Add-Content -Path  $outputFilePath -Value $outputString

    ### process array
    
    $LineCounter = 0
    $ByteCounter = 0
    $outputString = ""
    $firstLine = $true

    $bitmapArray | foreach-object {

        [uint16] $member = $_.Trim() # remove comma
        [byte] $msb = $member -band 255 # cast MSB
        [byte] $lsb = $member -shr 8 # cast LSB
        
        $outputString += ('0x' + "{0:x}" -f [int][char]$lsb + ", ") 
        $outputString += ('0x' + "{0:x}" -f [int][char]$msb)
        
        $ByteCounter++
        if ($ByteCounter -lt $ArraySize) {$outputString += ", "} # add comma except the last byte
        else {$outputString += [Environment]::NewLine + '};'} # add closing bracket after the last byte

        $LineCounter++
        if ($LineCounter -ge $itemsPerLine) { # break line every n-th byte

            Add-Content -Path $outputFilePath -Value $outputString
            $outputString = ""
            $LineCounter = 0
        }

    }
    
    if ($outputString -ne "") {Add-Content -Path $outputFilePath -Value $outputString} #write the last line if output buffer is not empty

    Add-Content -Path $outputFilePath -Value ([Environment]::NewLine)
}


### main ############

cls

### get all source files
$files = Get-ChildItem $inputPath -Filter "*.mtxt"

### process every file
$files | ForEach-Object {

    
    Write-Host ("Processing file: " + $_.name + [Environment]::NewLine)

    # get file name prefix
    $bitmapName = $_.BaseName 

    createFiles -outputPath $outputPath -bitmapName $bitmapName
    
        
    ### open and read file
    $content = Get-Content -Path $inputFile

    ### trim data
    $content = [string]::join("",($content.Split("`n"))) # remove cr/lf
    $content = $content.Replace(" ", ""); # remove space

    # split into single bitmaps
    $contentArray = $content.Split("/").Trim("/",","," ") # split between single bitmaps

    # process content array
    for ($x = 0; $x -lt $contentArray.Length; $x++) {
    
        if ($contentArray[$x].length -gt 0) {  # process only array members with data

            # get name of glyph / bitmap   
            $start = 1
            $length = $contentArray[$x].LastIndexOf("'") - $start
    
            $bitmapSubName = $contentArray[$x].Substring($start, $length)
            Write-Host ([Environment]::NewLine + "Processing glyphe: " + $bitmapSubName)

            # remove comment
            $start = $contentArray[$x].IndexOf("px") + 2
            $length = $contentArray[$x].Length - $start
            $bitmapArray = $contentArray[$x].Substring($start, $length).Split(",")

            $ArraySize = $bitmapArray.Length
            Write-Host ("Array size: " + $ArraySize + [Environment]::NewLine)

            appendBitmap -outputPath $outputPath -bitmapName $bitmapName -bitmapSubName $bitmapSubName -bitmapArray $bitmapArray -itemsPerLine $itemsPerLine

        }
    }
}  
    <#


    ### create output files (overwrite if exist)

    ### write header file
    Write-Host ("Creating header file: " + $bitmapName + ".h")
    $outputString = '#include "lcdgfx.h"' + ([Environment]::NewLine) + 'extern const uint8_t logo[' + ($contentArray.Length * 2) + '] PROGMEM;'
    $dump = New-Item -Path $outputPath -Name ($bitmapName + ".h") -ItemType "file" -Value $outputString -Force

    ### write code file
    Write-Host ("Creating code file: " + $bitmapName + ".cpp")
    $outputString = '#include "' + $bitmapName + '.h"' + ([Environment]::NewLine) + ([Environment]::NewLine) + 'const uint8_t logo[' + ($contentArray.Length * 2) + '] PROGMEM = {' + ([Environment]::NewLine)
    $dump = New-Item -Path $outputPath -Name ($bitmapName + ".cpp") -ItemType "file" -Value $outputString -Force

    $outputFilePath = $outputPath + "\" + $bitmapName + ".cpp"


    ### process array
    
    $LineCounter = 0
    $ByteCounter = 0
    $outputString = ""
    $firstLine = $true

    $contentArray | foreach-object {

        [uint16] $member = $_.Trim() # remove comma
        [byte] $msb = $member -band 255 # cast MSB
        [byte] $lsb = $member -shr 8 # cast LSB
        
        $outputString += ('0x' + "{0:x}" -f [int][char]$lsb + ", ") 
        $outputString += ('0x' + "{0:x}" -f [int][char]$msb)
        
        $ByteCounter++
        if ($ByteCounter -lt $ArraySize) {$outputString += ", "} # add comma except the last byte
        else {$outputString += ([Environment]::NewLine + '};')} # add closing bracket after the last byte

        $LineCounter++
        if ($LineCounter -ge $itemsPerLine) { # break line every n-th byte

            Add-Content -Path $outputFilePath -Value $outputString
            $outputString = ""
            $LineCounter = 0
        }

    }
    
    if ($outputString -ne "") {Add-Content -Path $outputFilePath -Value $outputString} #write the last line if output buffer is not empty

}#>