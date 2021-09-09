
##Get the directory for the Get-acl command, this is dependant on what directory you are in on powershell when running the script
$directory=Get-ChildItem

## $item is the variable that determines each file in said directory, using this for loop it runs a Get-Acl on each $item within $directory
foreach ($item in $directory) {
   Get-Acl $item
}