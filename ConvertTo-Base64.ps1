function ConvertTo-Base64{
	<#
	.SYNOPSIS
	Converts a plaintext string to Base64.
	
	.DESCRIPTION
	PowerShell cmdlet to convert 1 or more strings from Base64. This is compatible with both UTF8 and UTF-16LE (PowerShell Base64 encoding) flavours of Base64.
	
	.PARAMETER String
	Mandatory, specifies atleast 1 string to convert to Base64, to include spaces, wrap string in quotations or specify a variable.
	
	.PARAMETER Unicode
	Optional, by default this converts to Base64 using UTF8, PowerShell encoding uses unicode.
	
	.EXAMPLE
	ConvertTo-Base64 Test
	
	.EXAMPLE
	ConvertTo-Base64 -String Test
	
	.EXAMPLE
	ConvertTo-Base64 -String "This is a test"
	
	.EXAMPLE
	ConvertTo-Base64 -String test1,test2,test3
	
	.EXAMPLE
	ConvertTo-Base64 -String test -Unicode
	
	.LINK
	https://github.com/TokLabs/PowerShell/blob/master/ConvertTo-Base64.ps1
	#>
	
	[CmdletBinding()] Param(
		[parameter(Position = 0, Mandatory=$True)][string[]]$String,
		[parameter()][switch]$Unicode)
	
	if($Unicode -eq $True){
		$Format = "unicode"}
	else{
		$Format = "UTF8"}
	Write-Verbose "Format: $Format"
	$StringCount = $String.count
	Write-Verbose "Amount of items to encode: $StringCount"
	$i = [int]0
	foreach($_ in $String){
		$i++	
		Write-Verbose "String $i"
		$PlainTextString = $_
		Write-Verbose "Plaintext: $PlainTextString"
		$Value = [System.Text.Encoding]::$Format.GetBytes($PlainTextString)
		Write-Verbose "Value: $Value"
		$ConvertedString = [Convert]::ToBase64String($Value)
		$OutputTable = New-Object -TypeName psobject
		$OutputTable | Add-Member -MemberType NoteProperty -name PlainText -value $PlainTextString
		$OutputTable | Add-Member -MemberType NoteProperty -name Base64 -value $ConvertedString
		$OutputTable}
	}
