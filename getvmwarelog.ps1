$targetpath="c:\users\user1\desktop\logs"
#above is eaxample target path 
$entity=Read-Host "provide entity"



if((Get-VM -ErrorAction SilentlyContinue).Name -contains $entity){

   Write-host "It's a VM" -ForegroundColor Yellow
   }
  

   $vm = Get-VM -Name $entity

   $ds = Get-Datastore -RelatedObject $vm

   if($ds.count -gt 1)

   {

   Write-Host "vm is configured for "$ds.count "datastores"
   write-host "logs residing in following datastore."
   #$d=$vm.ExtensionData.Config.Files.LogDirectory
   $d
   
   $datastore=$d.Split(' ')[0].Trim('[]')
   $datastore

   $datastore_desired=Get-Datastore -Name $($datastore)


   write-host "adding psdrive"$datastore_desired.name -ForegroundColor Blue
New-PSDrive -Location $datastore_desired  -Name DS -PSProvider VimDatastore -Root '\' | Out-Null
#Get-ChildItem -Path DS:\
Set-Location DS:\
$dir=cd $vm
$desired_log=Get-ChildItem vmware.log
Copy-DatastoreItem -Item vmware.log -Destination $targetpath
write-host "removing ps drive" -ForegroundColor Blue
Remove-PSDrive -Name DS -Confirm:$false -Force




   }


   if($ds.Count -eq 1)
   {


   Write-Host "vm is configured for "$ds.count "datastores"
   

   $datastore_desired=Get-Datastore -Name $ds


   write-host "adding psdrive"$datastore_desired.name -ForegroundColor Blue
New-PSDrive -Location $datastore_desired  -Name DS -PSProvider VimDatastore -Root '\' | Out-Null
#Get-ChildItem -Path DS:\
Set-Location DS:\
$dir=cd $vm
$desired_log=Get-ChildItem vmware.log
Copy-DatastoreItem -Item vmware.log -Destination $targetpath
write-host "removing ps drive" -ForegroundColor Blue
Remove-PSDrive -Name DS -Confirm:$false -Force




   }