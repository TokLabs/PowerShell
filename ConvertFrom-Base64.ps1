function ConvertFrom-Base64{
	<#
	.SYNOPSIS
	Converts a plaintext string from Base64.
	
	.DESCRIPTION
	
	
	.PARAMETER string
	Mandatory, specifies atleast 1 string to convert from Base64.
	
	.PARAMETER unicode
	Optional, by default this converts from Base64 using UTF8, Powershell encoding uses unicode.
	
	.EXAMPLE
	ConvertFrom-Base64 c3RyaW5nMQ==
	
	.EXAMPLE
	ConvertFrom-Base64 -string c3RyaW5nMQ==
	
	.EXAMPLE
	ConvertFrom-Base64 -string c3RyaW5nMQ==,c3RyaW5nMg==
	
	.EXAMPLE
	ConvertFrom-Base64 -string dABlAHMAdAA= -unicode
	
	.LINK
	https://github.com/TokLabs/Powershell/blob/master/ConvertFrom-Base64.ps1
	#>
	
	[CmdletBinding()] Param(
		[parameter(Position = 0, Mandatory=$True)][string[]]$string,
		[parameter()][switch]$unicode)
		
	if ($unicode -eq $true){
		$format = "unicode"}
	else{
		$format = "UTF8"}
	foreach($_ in $string){
		try{
			$encodedString = $_
			$value = [Convert]::FromBase64String($encodedString)
			$plainTextString = [System.Text.Encoding]::$format.GetString($value)
			$plainTextString}
		catch{
			Write-Warning "Invalid string"}
		}
	}