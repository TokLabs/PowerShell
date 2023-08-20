function Get-AzureBearerToken{
	<#
	.SYNOPSIS
	Fetches a Bearer token from Azure.
	
	.DESCRIPTION
	PowerShell cmdlet to retreive a bearer token from Azure.

	.PARAMETER TenantID
    	Specifies Tenant (Directory) ID.

	.PARAMETER ClientID
    	Specifies Client (Application) ID that is assign to the app registered for use with this.

	.PARAMETER ClientSecret
    	Specifies Client Secret associated with the Client ID. (Any solutions that are logging PowerShell commandline WILL capture this.)

	.PARAMETER Conf
    	Path to an XML formatted configuration file that contains TenantID, ClientID and ClientSecret.
	
	.EXAMPLE
	Get-AzureBearerToken -TenantID x0xxx10-00x0-0x01-0xxx-x0x0x01xx100 -ClientID x0x1010x-xx01-1101-0x1x-xx0xxx101xx -ClientSecret Xx_Xx0XXX1Xxx.1x0XXxXxXxxX][x1X:xX01.XXx

    	.EXAMPLE
	Get-AzureBearerToken -Conf C:\Users\User\conf.ini

    	.EXAMPLE
	Get-AzureBearerToken x0xxx10-00x0-0x01-0xxx-x0x0x01xx100 x0x1010x-xx01-1101-0x1x-xx0xxx101xx Xx_Xx0XXX1Xxx.1x0XXxXxXxxX][x1X:xX01.XXx
	
	.LINK
	https://github.com/TokLabs/PowerShell/blob/main/Get-AzureBearerToken.ps1
	#>
	
    [CmdletBinding()]Param(
    [Parameter(
        Position = 0,
        Mandatory=$false)]
    [string]
    $TenantID,

    [Parameter(
        Position = 1,
        Mandatory=$false)]
    [string]
    $ClientID,

    [Parameter(
        Position = 2,
        Mandatory=$false)]
    [string]
    $ClientSecret,

    [Parameter(
        Mandatory=$false)]
    [string]
    $Conf)

    if($TenantID -and $ClientID -and $ClientSecret){
        }
    else{
        if ($Conf){
            if (Test-Path -Path $Conf){
                $Configuration = Import-Clixml $Conf
                $TenantID = $Configuration.TenantID
                $ClientID = $Configuration.ClientID
                $ClientSecret = $Configuration.ClientSecret}
            else {
                Write-Error "Configuration file not found."
                return}
            }
        else{
            Write-Error  "Missing configuration parameters." -RecommendedAction 'Specify paremeters with either:
1. Get-AzureBearerToken -TenantID {TenantID} -ClientID {ClientID} -ClientSecret {ClientSecret}
2. Get-AzureBearerToken -Conf "C:\Users\User\conf.ini"'
            return}
        }
    $URI = [uri]"https://login.microsoftonline.com/$TenantID/oauth2/token"
    $GrantType = "client_credentials"
    $Resource = "https://management.azure.com/"
    $Method = "POST"
    $ContentType = "application/x-www-form-urlencoded"
    $Request = @{
        Method = $Method
        Uri = $URI.AbsoluteUri
        ContentType = $ContentType
        Body = @{
            client_id = $ClientID
            client_secret = $ClientSecret
            grant_type = $GrantType
            resource = $Resource}
        }
    Invoke-RestMethod @Request
    }
