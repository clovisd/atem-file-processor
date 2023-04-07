### ATEM_FILE_PROCESSOR (AFP)
### https://github.com/clovisd/atem-file-processor
### License: Do whatever' just be nice.
###
### Badly written, badly concieved, and illogical. Sorry

$currentDirectory = $PSScriptRoot

### Config
#  Video ISO MP4 Files (can be the same as Audio)
#      $dir1 = "PUT_DIR_HERE" #Use Me when in running point-me.ps1 or you need to select a custom location.
      $dir1 = "$currentDirectory\Video ISO Files" #Use Me when running put-me.ps1 in a ATEM Project Folder.

#  Audio WAV Files (can be the same as Video)
#      $dir2 = "PUT_DIR_HERE" #Use Me when in running point-me.ps1 or you need to select a custom location.
      $dir2 = "$currentDirectory\Audio Source Files" #Use Me when running put-me.ps1 in a ATEM Project Folder.

#  Output for Final MP4 Files
      $outputDir = "$currentDirectory\export"
#  Set this to whereever you want the final files to be. Defualt is in the folder this script runs in.

#  Script Location
      $runDir = "C:\Users\admin\Downloads\atem-file-processor"
#  Set this to where the scripts for the different steps are. Defualt is to run out of this folder (as direct download from github)
#  If you want to use this script and place it in the ATEM root project directory, and run from there, then set runDir to the location of the step scripts (processor).

Write-Host "[AFP] ATEM File Cleanup - STARTING " -ForegroundColor White -BackgroundColor Green
Write-Host " " -ForegroundColor Black
Write-Host " " -ForegroundColor Black
Write-Host " " -ForegroundColor Black
Write-Host " " -ForegroundColor Black
Write-Host " " -ForegroundColor Black
Write-Host "Video Directory: $dir1" -ForegroundColor DarkGray
Write-Host "Audio Directory: $dir2" -ForegroundColor DarkGray
Write-Host "Export Directory: $outputDir" -ForegroundColor DarkGray

# Create the output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
    Write-Host "- Creating Directory Folder" -ForegroundColor DarkGray
}

Write-Host " " -ForegroundColor Black

$ScriptPaths = @(
    "$runDir\processor\step-0.ps1",
    "$runDir\processor\step-1.ps1",
    "$runDir\processor\step-2.ps1",
    "$runDir\processor\step-3.ps1",
    "$runDir\processor\step-4.ps1",
    "$runDir\processor\step-5.ps1"
)

$customMessages = @(
    "-  Step 1: Removing Junk Files",
    "-  Step 2: Creating FFMPEG Playlists",
    "-  Step 3: Merging Playlists Together",
    "-  Step 4: Stripping Audio Data",
    "-  Step 5: Merging Audio Track & Final Playlist",
    "-  Step 6: Cleaning Up Work Files"
)

foreach ($ScriptPath in $ScriptPaths) {
    # Update Step
    $index = $ScriptPaths.IndexOf($ScriptPath)

    Write-Host "$($customMessages[$index]) - STARTED" -ForegroundColor DarkGray

    $Process = Start-Process -FilePath "powershell.exe" -ArgumentList " -File `"$ScriptPath`" `"$dir1`" `"$dir2`" `"$outputDir`"" -PassThru -WindowStyle Minimized

    while (!$Process.HasExited) {
        Write-Progress -Activity "Running $ScriptPath" -Status "Elapsed Time: $([DateTime]::Now - $Process.StartTime)" -PercentComplete (($Process.TotalProcessorTime.Ticks / $Process.StartTime.Ticks) * 100)
        Start-Sleep -Milliseconds 100
    }

    # Check Exit Code
    if ($Process.ExitCode -eq 0) {
        Write-Host "$($customMessages[$index]) - COMPLETED" -ForegroundColor Green
    } else {
        Write-Host "$($customMessages[$index]) - FAILED" -ForegroundColor Red
        exit 1
        # Exit if Error Stage
    }
}

Write-Host "[AFP] ATEM File Cleanup - ENDED " -ForegroundColor White -BackgroundColor Green

exit 0