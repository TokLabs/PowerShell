Function Get-StringHash{
    <#
    .SYNOPSIS
    Creates a hash of a string.

    .DESCRIPTION
    Powershell cmdlet to hash a single string input and output it to a table. This can create SHA1, SHA256 and MD5 hashes. Cmdlets and variables can be used to input strings. some special characters may need to be escaped if entered into the input directly.

    .PARAMETER String
    Mandatory, specifies a string to hash.

    .PARAMETER Algorithm
    Defaults to SHA256, this can be changed by specifying "MD5" or "SHA1" with this switch.

    .EXAMPLE
    Get-StringHash Test

    .EXAMPLE
    Get-StringHash "This is a test"

    .EXAMPLE
    Get-StrngHash $Variable
    
    .EXAMPLE
    Get-StringHash (Get-Random)
    
    .EXAMPLE
    Get-StringHash -String Test
    
    .EXAMPLE
    Get-StringHash -String Test -Algorithm SHA1
    
    .EXAMPLE
    Get-Random | Get-StringHash -Algorithm MD5
    
    .LINK
    https://github.com/TokLabs/PowerShell/blob/master/Get-StringHash.ps1

    #>
    [CmdletBinding()]Param(
        [Parameter(
            Position = 0,
            Mandatory=$True,
            ValueFromPipeline=$True)]
        [string]
        $String,

        [ValidateSet("SHA1", "SHA256", "MD5")]
        [System.String]
        $Algorithm="SHA256")

    $Hash = [System.Security.Cryptography.HashAlgorithm]::Create($Algorithm).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))
    $Hash = ([System.BitConverter]::ToString($Hash) -replace "-","").ToLower()
    $OutputTable = New-Object PSObject
    Add-Member -InputObject $OutputTable -MemberType NoteProperty -Name Algorithm -Value $Algorithm
    Add-Member -InputObject $OutputTable -MemberType NoteProperty -Name Hash -Value $Hash
    Add-Member -InputObject $OutputTable -MemberType NoteProperty -Name String -Value $String
    $OutputTable}
