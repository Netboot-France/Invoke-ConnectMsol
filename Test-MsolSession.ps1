Function Test-MsolSession {
    <#  
        .SYNOPSIS  
            Simple function to test Microsoft Online Session

        .NOTES  
            File Name   : Test-MsolSession.ps1
            Author      : Thomas ILLIET, contact@thomas-illiet.fr
            Date        : 2017-08-06
            Last Update : 2017-08-06
            Tested Date : 2017-10-16
            Version     : 1.0.1
            
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
           Test-MsolSession -Config $OnlineConfig

        .EXAMPLE
            #----------------------------------------------
            # Authentification : SecureString file
            #----------------------------------------------
            $OnlineConfig =@{
                Identity       = "unicorn@microsoft.fr"
                PasswordFile   = "c:\Securestring.txt"
            }
            Test-MsolSession -Config $OnlineConfig

        .EXAMPLE
            #----------------------------------------------
            # Authentification : SecureString file + Key
            #----------------------------------------------
            $OnlineConfig =@{
                Identity       = "unicorn@microsoft.fr"
                PasswordFile   = "C:\Securestring.txt"
                KeyFile        = "C:\MyCertificat.key"
            }
            Test-MsolSession -Config $OnlineConfig
    #>
    Param (
    [parameter(Mandatory=$true)]
        [Array]$Config
    )

    try
    {
        Get-MsolDomain -ErrorAction Stop > $null
    }
    catch 
    {
        Write-Output "Connecting to Office 365..."
        Invoke-ConnectMsol -Config $Config
    }

}