### ATEM_FILE_PROCESSOR (AFP)
### https://github.com/clovisd/atem-file-processor
### License: Do whatever' just be nice.
###
### Badly written, badly concieved, and illogical. Sorry

# Set the directory where the MP4 files are located
$dir1 = $args[0]
$dir2 = $args[1]
$outputDir = $args[2]

Write-Host "Step 1: Removing Junk Files" -ForegroundColor White -BackgroundColor Green

# Delete .dot files in both directories.
# Comment out  "Remove-Item" if you don't want to delete them.

Get-ChildItem -Path $dir1 -Filter ".*" | foreach { 
    Remove-Item $_.FullName -Force
}

Get-ChildItem -Path $dir2 -Filter ".*" | foreach { 
    Remove-Item $_.FullName -Force
}

exit 0