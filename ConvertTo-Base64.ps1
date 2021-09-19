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
	
	$primaryTablev = @()	
	if($unicode -eq $true){
		$format = "unicode"}
	else{
		$format = "UTF8"}
	Write-Verbose "Format: $format"
	$stringCount = $string.count
	Write-Verbose "Amount of items to encode: $stringCount"
	$i = [int]0
	foreach($_ in $string){
		$i++	
		Write-Verbose "String $i"
		$plainTextString = $_
		Write-Verbose "Plaintext: $plainTextString"
		$value = [System.Text.Encoding]::$format.GetBytes($plainTextString)
		Write-Verbose "Value: $value"
		$convertedString = [Convert]::ToBase64String($value)
		$tempObject = [PSCustomObject]@{
			PlainText = $plainTextString
			Base64 = $convertedString}
		$primaryTable += $tempObject
		$primaryTable}
	}