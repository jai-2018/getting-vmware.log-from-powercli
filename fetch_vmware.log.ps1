$targetpath="c:\users\jai\desktop\logs"
$entity=Read-Host "provide entity"
$fragments = @()


if((Get-VM -ErrorAction SilentlyContinue).Name -contains $entity){

   Write-host "It's a VM" -ForegroundColor Yellow
   }
  

   $vm = Get-VM -Name $entity

   $ds = Get-Datastore -RelatedObject $vm

   if($ds.count -gt 1)

   {

   Write-Host "vm is configured for "$ds.count "datastores"
   }

   foreach($d in $ds)
   {
   $d_name=get-datastore -Name $d

   $per_freespace_datastore=$d_name.freespaceGB/$d_name.capacityGB*100
   $per_freespace_round=[math]::Round($per_freespace_datastore)
   $datastores=$d_name|select name,@{N='freespacepercent';E={$per_freespace_round}}
   $datastores|Sort-Object -Property 'freespacepercent' -Descending
   $fragments += $d_name.Name
   $fragments += $per_freespace_round  
   }

  
         for ($i=0; $i -lt ($ds.name).count; $i++)
{
write-host "adding psdrive"$ds[$i] -ForegroundColor Blue
New-PSDrive -Location $ds[$i] -Name DS -PSProvider VimDatastore -Root '\' | Out-Null
#Get-ChildItem -Path DS:\
Set-Location DS:\
$dir=cd $vm
$desired_log=Get-ChildItem vmware.log
Copy-DatastoreItem -Item vmware.log -Destination $targetpath
write-host "removing ps drive" -ForegroundColor Blue
Remove-PSDrive -Name DS -Confirm:$false -Force

if($desired_log -ne $null)
{

write-host "desired datastore" $ds[$i] -ForegroundColor Green

}

else
{

write-host "vmware.log" not found in  $ds[$i] -ForegroundColor Red
}


   }
