# This script is for enumerating wifi password on the device, and exporting the result to a text file.
# Show registered Wi-Fi AP SSIDs to external files
$aup   = "    All User Profile     : "
$kc    = "    Key Content            : "
$aup_jp = "    すべてのユーザー プロファイル     : "
$kc_jp = "    主要なコンテンツ       : "

netsh wlan show profiles | find " : "|Out-File ./SSIDs.txt 
# clean up the data and delete unecessary parts.
$SSID_list = Get-Content ./SSIDs.txt | ForEach-Object {$_ -replace $aup, ""} |ForEach-Object {$_ -replace $aup_jp, ""}
$SSID_list | Out-File ./SSIDs.txt
# Get-Content ./SSIDs.txt

# Function to provide a password: argument: SSID
$SSIDs = Get-Content ./SSIDs.txt
function show_pw {
    param (
        $temp_SSID 
    )
    netsh wlan show profile name=$temp_SSID key=clear | find "Key Content"
}

# repeat show_pw and append to a csv file
# read each line of ./SSIDs.txt and use it as argument: SSID'

ForEach ($SSID in $SSIDs) {
    $pw = show_pw $SSID
    $pair = $SSID + "," + $pw -replace $kc, "" | ForEach-Object {$_ -replace $kc_jp, ""}
    $pair | Add-Content ./wlanpass.csv
}

Write-Output "EdiFi: PW extraction Completed."