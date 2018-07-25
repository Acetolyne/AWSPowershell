﻿#Remove AWS Snapshots using CSV -- Drew Appling 07/25/2018
#Required CSV fields = SnapshotID, Region
#Fill in Access Key ID, Secret Access Key and Session Token

Import-Module AWSPowerShell

$aws_access_key_id = ""
$aws_secret_access_key = ""
$aws_session_token = ""
$OutFolder = "C:\temp"

$Snapshots = Import-Csv C:\temp\snapshot1.csv

Set-AWSCredential -AccessKey $aws_access_key_id -SecretKey $aws_secret_access_key -SessionToken $aws_session_token

$SnapshotStatusCollection = New-Object System.Collections.ArrayList

ForEach($Snapshot in $Snapshots){
    $Snapshot
    Try{
        Remove-EC2Snapshot -SnapshotId $Snapshot.SnapshotID -Region $Snapshot.Region -Confirm:$false
    }Catch{
        $SnapshotStatus = New-Object -TypeName PSobject
        $SnapshotStatus | add-member -MemberType NoteProperty -Name "SnapshotID" -Value $Snapshot.SnapshotID
        $SnapshotStatus | Add-Member -MemberType NoteProperty -Name "Region" -Value $Snapshot.Region
        $SnapshotStatus | Add-Member -MemberType NoteProperty -Name "AMI" -Value $_.ToString().split(' ')[8]
        $SnapshotStatusCollection.Add($Snapshotstatus) | Out-Null
     }
}

$SnapshotStatusCollection | export-csv $OutFolder\Snapshotreport.csv -notypeinformation