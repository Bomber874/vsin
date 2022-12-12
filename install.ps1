Param (
[string]$reboot
)
function ToTG {

    [CmdletBinding()] #<<-- This turns a regular function into an advanced function
    param (
        $text
    )
    $bot_token = "5466249030:AAFnmqwmnvkNnTk97tNsMm0cr4wM8H-ZQHg"
    $uri = "https://api.telegram.org/bot$bot_token/sendMessage"
    $id = "-788615025"
    Invoke-WebRequest -UseBasicParsing -Method Post -Uri $uri -ContentType "application/json;charset=utf-8" `
    -Body (ConvertTo-Json -Compress -InputObject @{chat_id=$id; text=$text})

}
$O = New-ScheduledJobOption -WakeToRun -MultipleInstancePolicy IgnoreNew
$T = New-JobTrigger -AtStartup -RandomDelay 00:00:30
if ($reboot -eq "+") {
    ToTG("Server has been restarted")
    choco install visualstudio2022-workload-manageddesktop -y --package-parameters "--no-includeRecommended"
    ToTG("Completed installing VS components")
    Disable-ScheduledJob -ID 1 -Passthru
    ToTG("Remove Task From TaskManager")
    $Resp = Invoke-WebRequest -URI https://raw.githubusercontent.com/Bomber874/vsin/main/users.txt -UseBasicParsing
    $Users = $Resp.Content -split "\n"
    ToTG("Found "+(($Users.Count-1)/2)+" users")
    for ($i = 0; $i -lt $Users.Count-1;) {
        New-LocalUser $Users[$i] -Password $Users[$i+1] -FullName $Users[$i]
        $i = $i + 2
    }
    ToTG("Finished adding users, all done")
}else {
    ToTG("Installer Started")
    Register-ScheduledJob -Name "InstallVS" -FilePath "C:\Users\Administrator\install.ps1" -ArgumentList "+" -ScheduledJobOption $O -Trigger $T
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    ToTG("Choco installed, installing VS")
    choco install visualstudio2022community -y --package-parameters "--passive --locale ru-RU"
    
    ToTG("VS installed, rebooting")
    Restart-Computer
}
