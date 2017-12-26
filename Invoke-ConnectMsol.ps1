function Invoke-ConnectMsol {
    <#  
        .SYNOPSIS  
            Simple function to connect into Microsoft Online

        .NOTES  
            File Name    : Invoke-ConnectMsol.ps1
            Author       : Thomas ILLIET, contact@thomas-illiet.fr
            Date	     : 2017-08-06
            Last Update  : 2017-08-06
            Tested Date  : 2017-10-16
            Version	     : 1.0.2

            
        .REQUIRE
            Software :
                + Microsoft Online Services Sign-In Assistant
                    - https://www.microsoft.com/en-us/download/details.aspx?id=41950
                + Azure Active Directory PowerShell V1
                    - http://connect.microsoft.com/site1164
            
        .PARAMETER
            Config : Configuration Array

        .EXAMPLE
            #----------------------------------------------
            # Authentification : Plain Password
            #----------------------------------------------
            $OnlineConfig =@{
                Identity       = "unicorn@microsoft.fr"
                Password       = "BeatifullUnicorne!"
            }
            Invoke-ConnectMsol -Config $OnlineConfig

        .EXAMPLE
            #----------------------------------------------
            # Authentification : SecureString file
            #----------------------------------------------
            $OnlineConfig =@{
                Identity       = "unicorn@microsoft.fr"
                PasswordFile   = "c:\Securestring.txt"
            }
            Invoke-ConnectMsol -Config $OnlineConfig

        .EXAMPLE
            #----------------------------------------------
            # Authentification : SecureString file + Key
            #----------------------------------------------
            $OnlineConfig =@{
                Identity       = "unicorn@microsoft.fr"
                PasswordFile   = "C:\Securestring.txt"
                KeyFile        = "C:\MyCertificat.key"
            }
            Invoke-ConnectMsol -Config $OnlineConfig
    #>
    [CmdletBinding()]
    Param (
        [parameter(Mandatory=$true)]
        [Array]$Config
    )

    write-debug "| ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    write-debug "| + Connect to Microsoft Online Service"
    write-debug "| ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    
    # Load Credential
    if(-not([string]::IsNullOrEmpty($Config.PasswordFile)))
    {
        if(-not([string]::IsNullOrEmpty($Config.KeyFile)))
        {
            $Methode = "SecureString file + Key"
            $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Config.Identity, (Get-Content $Config.PasswordFile | ConvertTo-SecureString -Key (Get-Content $Config.KeyFile))
        } # END Credential with Key File
        else
        {
            $Methode = "SecureString file"
            $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Config.Identity, (Get-Content $Config.PasswordFile | ConvertTo-SecureString)
        } # END Credential without Key File
    }
    else
    {
        $Methode = "Plain password"
        $Secpasswd = ConvertTo-SecureString $Config.Password -AsPlainText -Force
        $Credential = New-Object -TypeName System.Management.Automation.PSCredential ($Config.Identity, $secpasswd)
    } # END Credential with plain password

    # Connect to Microsoft Online
    $error.clear();
    if($Credential -ne $null)
    {
        Write-Debug "| + Attempting Connection to Microsoft Online with $Methode"
        Connect-MsolService -Credential $Credential
    } # END connect with Credential
    else
    {
        Write-Debug "| + Attempting Connection to Microsoft Online"
        Connect-MsolService
    } # END connect without Credential
    
    # Return Management
    if([string]::IsNullOrEmpty($error))
    {
        Write-Debug "| + Connected to Microsoft Online"
        return $true
    }
    else
    {
        return $false
    } # END Return Management

} # END function Connect-Msol