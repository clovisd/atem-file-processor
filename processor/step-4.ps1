### ATEM_FILE_PROCESSOR (AFP)
### https://github.com/clovisd/atem-file-processor
### License: Do whatever' just be nice.
###
### Badly written, badly concieved, and illogical. Sorry

# Set the directory where the MP4 files are located
$dir1 = $args[0]
$dir2 = $args[1]
$outputDir = $args[2]

Write-Host "Step 5: Merging Audio Track & Final Playlist " -ForegroundColor White -BackgroundColor Green
Write-Host " " -ForegroundColor Black
Write-Host " " -ForegroundColor Black
Write-Host " " -ForegroundColor Black
Write-Host " " -ForegroundColor Black
Write-Host " " -ForegroundColor Black
Write-Host " " -ForegroundColor Black

# Loop through each camera
for ($camNum = 1; $camNum -le 8; $camNum++) {

    Write-Host "-  $camNum. Merging  Video & Audio from CAM$camNum-FINAL.mp4" -ForegroundColor Green -BackgroundColor Black
    # Set Path Files
    $videoFilePath = "$dir1\CAM$camNum-MUTE.mp4"
    $audioFileName = Get-ChildItem -Path $dir2 -Filter "*CAM $camNum*.wav"
    $audioFilePath = Get-ChildItem -Path $dir2 -Filter "*CAM $camNum*.wav" | Select-Object -ExpandProperty FullName

    Write-Host "   Merge Audio from CAM$camNum-MUTE.mp4 & Video from $audioFileName."
    Write-Host "   Writing to $dir1\CAM$camNum-FINAL.mp4." -ForegroundColor DarkGray -BackgroundColor Black

    # Build the FFMPEG command to merge the files for the current camera. Adjust for your Encoding preference / needs.
    $outputFilePath = "$dir1\CAM$camNum-FINAL.mp4"
    $ffmpegCommand = "ffmpeg  -threads 8 -cpuflags avx2 -i `"$videoFilePath`" -i `"$audioFilePath`" -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 `"$outputFilePath`""
    Write-Host "   Passing Command: $ffmpegCommand" -ForegroundColor DarkGray -BackgroundColor Black

    # Run the FFMPEG command
    #  Invoke-Expression $ffmpegCommand
    $subProcess = Start-Process "cmd.exe" "/c $ffmpegCommand" -PassThru -WindowStyle Minimized
    while (!$subProcess.HasExited) {
        Write-Progress -Activity "[FFMPEG] Merge Audio using CAM$camNum-MUTE.mp4 & $audioFileName." -Status "Elapsed Time: $([DateTime]::Now - $subProcess.StartTime)" -PercentComplete (($subProcess.TotalProcessorTime.Ticks / $subProcess.StartTime.Ticks) * 100)
        Start-Sleep -Milliseconds 100
    }
    
    Write-Host "   Completed!" -ForegroundColor White -BackgroundColor Black

}

exit 0