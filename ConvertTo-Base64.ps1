function ConvertTo-Base64{
	<#
	.SYNOPSIS
	Converts a plaintext string to Base64.
	
	.DESCRIPTION
	
	
	.PARAMETER string
	Mandatory, specifies atleast 1 string to convert to Base64, to include spaces, wrap string in quotations or specify a variable.
	
	.PARAMETER unicode
	Optional, by default this converts to Base64 using UTF8, Powershell encoding uses unicode.
	
	.EXAMPLE
	ConvertTo-Base64
	
	.EXAMPLE
	ConvertTo-Base64
	
	.EXAMPLE
	ConvertTo-Base64
	
	.LINK
	https://github.com/TokLabs/Powershell/blob/master/ConvertTo-Base64.ps1
	#>
	
	[CmdletBinding()] Param(
		[parameter(Mandatory=$True)][string]$string,
		[parameter()][switch]$unicode)
		
	if($unicode -eq $true){
		$format = "unicode"}
	else{
		$format = "UTF8"}
	foreach($_ in $string){
		$plainTextString = $_
		$value = [System.Text.Encoding]::$format.GetBytes($plainTextString)
		$convertedString = [Convert]::ToBase64String($value)}
	}