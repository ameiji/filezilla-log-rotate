#
#   Comress Filezilla Logs
#


$LogFolder = “C:\Program Files (x86)\FileZilla Server\Logs” 
$Arcfolder = "C:\Program Files (x86)\FileZilla Server\Logs\Archive”
$zipcmd = 'C:\Program Files\7-Zip\7z.exe'
$RotateDays = 30


# 1. Compress Files Older than 1 day and move to archive folder
If ($Logs = get-childitem -Path $LogFolder -filter "*.log" | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-1)} ){

   foreach ($L in $Logs){

        $FName = $L.FullName
        $FArchive = $FName + ".zip"

        Write-Host "Compressing $FName"
        & $zipcmd a -sdel -tzip $FArchive $FName
        
        Move-Item -Force $FArchive $Arcfolder
    }

}else{

    Write-Host "No files to archive in $LogFolder"

}

# 2. Delete Old Archives

Get-ChildItem -Path $Arcfolder -Filter "*.zip" | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-$RotateDays)} | Remove-Item 

