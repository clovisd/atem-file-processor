### ATEM_FILE_PROCESSOR (AFP)
### https://github.com/clovisd/atem-file-processor
### License: Do whatever' just be nice.
###
### Badly written, badly concieved, and illogical. Sorry

# Set the directory where the MP4 files are located
$dir1 = $args[0]
$dir2 = $args[1]
$outputDir = $args[2]

Write-Host "Step 2: Creating FFMPG Playlists" -ForegroundColor White -BackgroundColor Green
# Get a list of all the MP4 files in the directory
$mp4Files = Get-ChildItem -Path $dir1 -Filter "*.mp4"

# Loop through each MP4 file
foreach ($file in $mp4Files) {

    # Extract Info from File
    # $cameraNum = [regex]::Match($file.Name, "CAM (\d)").Groups[1].Value
    # $episodeNum = [regex]::Match($file.Name, "Episode (\d)").Groups[1].Value

    $match = [regex]::Match($file.Name, "CAM (\d+) (\d+)\.mp4")
    $cameraNum = $match.Groups[1].Value
    # $partNum = $match.Groups[2].Value

    # Add / Append to Text File
    $textFilePath = "$dir1\CAM$cameraNum.txt"
    $text = "file '$($file.FullName)'"
    Add-Content $textFilePath $text

    # Sort Text Lines Alphabetically
    (Get-Content $textFilePath) | Sort | Set-Content $textFilePath
}

exit 0