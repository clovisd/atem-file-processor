### ATEM_FILE_PROCESSOR (AFP)
### https://github.com/clovisd/atem-file-processor
### License: Do whatever' just be nice.
###
### Badly written, badly concieved, and illogical. Sorry

# Set the directory where the MP4 files are located
$dir1 = $args[0]
$dir2 = $args[1]
$outputDir = $args[2]

Write-Host "Step 3: Merging Playlists Together" -ForegroundColor White -BackgroundColor Green
Write-Host "This process provides additional information." -ForegroundColor DarkGray -BackgroundColor Black
Write-Host " " -ForegroundColor Black
Write-Host " " -ForegroundColor Black
Write-Host " " -ForegroundColor Black
Write-Host " " -ForegroundColor Black
Write-Host " " -ForegroundColor Black

# Loop through each Camera file
for ($camNum = 1; $camNum -le 8; $camNum++) {

    Write-Host "-  $camNum. Merging Clips from CAM$camNum.txt" -ForegroundColor Green -BackgroundColor Black
    # Set Path Files
    $textFilePath = "$dir1\CAM$camNum.txt"
    
    Write-Host "   Writing to: $dir1\CAM$camNum.txt" -ForegroundColor DarkGray -BackgroundColor Black
    
    # Build the FFMPEG command to merge the files for the current camera. Adjust for your Encoding preference / needs.
    # $ffmpegCommand = "ffmpeg -f concat -safe 0 -threads 8 -cpuflags avx2 -i `"$textFilePath`" -c copy `"$dir1\CAM$camNum.mp4`""
    $ffmpegCommand = "ffmpeg -f concat -safe 0 -threads 8 -cpuflags avx2 -i `"$textFilePath`" -c:v h264_amf `"$dir1\CAM$camNum.mp4`""
    Write-Host "   Passing Command: $ffmpegCommand" -ForegroundColor DarkGray -BackgroundColor Black

    # Run the FFMPEG command
    #  Invoke-Expression $ffmpegCommand
    $subProcess = Start-Process "cmd.exe" "/c $ffmpegCommand" -PassThru -WindowStyle Minimized
    while (!$subProcess.HasExited) {
        Write-Progress -Activity "[FFMPEG] Merging from CAM$camNum.txt into CAM$camNum.mp4." -Status "Elapsed Time: $([DateTime]::Now - $subProcess.StartTime)" -PercentComplete (($subProcess.TotalProcessorTime.Ticks / $subProcess.StartTime.Ticks) * 100)
        Start-Sleep -Milliseconds 100
    }
    
    Write-Host "   Completed!" -ForegroundColor White -BackgroundColor Black

}

exit 0