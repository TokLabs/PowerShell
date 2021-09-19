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
	ConvertTo-Base64 Test
	
	.EXAMPLE
	ConvertTo-Base64 -string Test
	
	.EXAMPLE
	ConvertTo-Base64 -string "This is a test"
	
	.EXAMPLE
	ConvertTo-Base64 -string test1,test2,test3
	
	.EXAMPLE
	ConvertTo-Base64 -string test -unicode
	
	.LINK
	https://github.com/TokLabs/Powershell/blob/master/ConvertTo-Base64.ps1
	#>
	
	[CmdletBinding()] Param(
		[parameter(Position = 0, Mandatory=$True)][string[]]$string,
		[parameter()][switch]$unicode)
		
	if($unicode -eq $true){
		$format = "unicode"}
	else{
		$format = "UTF8"}
	foreach($_ in $string){
		$plainTextString = $_
		$value = [System.Text.Encoding]::$format.GetBytes($plainTextString)
		$convertedString = [Convert]::ToBase64String($value)
		$convertedString}
	}