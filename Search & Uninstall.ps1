##--Script will check if the applicaiton is installed on the computer and will ask user to confirm before going ahead with uninstallation-##

##--Ask user the name oif the application they want to search--##
$Input_App = Read-Host -Prompt "Enter the application name you want to search and uninstall"

Write-Host ""

##--Ask user to enter the location of the txt file which contains the computers--##
$Input_List = Read-Host -Prompt "Enter path and file name which contains the workstations"

$Computer = Get-content -Path $Input_List

Write-Host ""

##--Loop to go through all the computers on the txt file--##
$Device_List = foreach ($c in $Computer)

{

##--Check the each computer if te application is installed--##
Get-CimInstance -classname Win32_Product -ComputerName $C | where-object Name -Match $Input_App

}

$Device_List

##--Function to ask user to go ahead with the uninstallation--##
function Get-Answer
{
	Write-Host ""
    $Input_Answer= Read-Host "Do you want to uninstall the application: Yes, No ?
    "
    
	Switch ($Input_Answer)
	{
		yes {$Answer_Selected="Yes"}
		no {$Answer_Selected="No"}
	}
    return $Answer_Selected

}

##-Condition to start the uninstallation process--##
if ($Device_List -ne $null)

{

##--Ask user to go ahead with the uninstallation 
    $User_Answer = get-answer

    if ($User_Answer -eq "Yes")
    
        {
            $Input_Uninstall = Read-Host -Prompt "You have selected to Unintall the application, Press Enter to continue"
            Write-Host "Uninstalling.."
            $Device_List | Invoke-CimMethod -MethodName Uninstall
        }
        
    else 
        {
            Write-Host "" 
            Write-Host "Application uninstall stopped"  
        }

}

else

{
Write-Host "Application not found"
}