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
$O = New-ScheduledJobOption -WakeToRun -StartIfIdle -MultipleInstancePolicy IgnoreNew
$T = New-JobTrigger -AtStartup -RandomDelay 00:00:30
if ($reboot -eq "true") {
    ToTG2("Server has been restarted")
    choco install visualstudio2022-workload-manageddesktop -y --package-parameters "--no-includeRecommended"
    ToTG2("Completed installing VS components")
    Disable-ScheduledJob -ID 1 -Passthru
    ToTG2("All done")
}else {
    ToTG("Installer Started")
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    ToTG("Choco installed, installing VS")
    choco install visualstudio2022community -y --package-parameters "--passive --locale ru-RU"
    Register-ScheduledJob -Name "InstallVS" -FilePath "C:\Users\Administrator\install.ps1" -ArgumentList "-reboot true" -ScheduledJobOption $O -Trigger $T
    ToTG("VS installed, rebooting")
    Restart-Computer
}
