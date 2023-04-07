### ATEM_FILE_PROCESSOR (AFP)
### https://github.com/clovisd/atem-file-processor
### License: Do whatever' just be nice.
###
### Badly written, badly concieved, and illogical. Sorry

# Set the directory where the MP4 files are located
$dir1 = $args[0]
$dir2 = $args[1]
$outputDir = $args[2]

Write-Host "Step 6: Cleaning Up" -ForegroundColor White -BackgroundColor Green

### Move Final Export Files
# Get list of Final files
$finalFiles = Get-ChildItem $dir1 -Filter "*-FINAL.mp4" -File

# Loop through to Rename and Remove.
foreach ($file in $finalFiles) {
    # Get the CAM# from the filename
    $camNum = [regex]::Match($file.Name, "CAM(\d)").Groups[1].Value

    # Get new filename
    $newName = "CAM-0$camNum.mp4"

    # Rename with new filename
    $newPath = Join-Path $dir1 $newName
    Rename-Item $file.FullName -NewName $newName

    # Move the file to Final Directory
    $newPathOutput = Join-Path $outputDir $newName
    Move-Item $newPath -Destination $newPathOutput
}

### Delete Text Files
# Get list of Text files
$textFiles = Get-ChildItem -Path $dir1 -Filter "*.txt" -Recurse

# Delete Text Files
foreach ($file in $textFiles) {
    # Delete the file
    Remove-Item $file.FullName
}


### Delete MP4 Working Files
# Get a list of all the working MP4 files ("CAM#.mp4" and "CAM#-MUTE.mp4").
$mp4Files = Get-ChildItem -Path $dir1 -Include "CAM*.mp4", "CAM*-MUTE.mp4" -File -Recurse

# Loop through and Delete Files
foreach ($file in $mp4Files) {
    if ($file.Name -match '^CAM\d(\-MUTE)?\.mp4$') {
        # Delete the file
        Remove-Item $file.FullName
    }
}

exit 0