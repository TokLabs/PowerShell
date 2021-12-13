function ConvertFrom-Base64{
	<#
	.SYNOPSIS
	Converts a plaintext string from Base64.
	
	.DESCRIPTION
	Powershell cmdlet to convert one or more Base64 strings and output to a table. This cmdlet can convert both UTF8 and UTF-16LE(Powershell's Base64 encoding)
	
	.PARAMETER string
	Mandatory, specifies atleast 1 string to convert from Base64.
	
	.PARAMETER unicode
	Optional, by default this converts from Base64 using UTF8, Powershell encoding uses unicode.
	
	.EXAMPLE
	ConvertFrom-Base64 c3RyaW5nMQ==
	
	.EXAMPLE
	ConvertFrom-Base64 -String c3RyaW5nMQ==
	
	.EXAMPLE
	ConvertFrom-Base64 -String c3RyaW5nMQ==,c3RyaW5nMg==
	
	.EXAMPLE
	ConvertFrom-Base64 -String dABlAHMAdAA= -Unicode
	
	.LINK
	https://github.com/TokLabs/Powershell/blob/master/ConvertFrom-Base64.ps1
	#>
	
	[CmdletBinding()] Param(
		[parameter(Position = 0, Mandatory=$True)][string[]]$String,
		[parameter()][switch]$Unicode)
		
	if ($Unicode -eq $True){
		$Format = "unicode"}
	else{
		$Format = "UTF8"}
	Write-Verbose "format: $Format"
	$StringCount = $String.count
	Write-Verbose "Amount of items in string: $StringCount"
	$i = [int]0
	foreach($_ in $String){
		$i++	
		try{
			$EncodedString = $_
			Write-Verbose "String: $i"
			Write-Verbose "Encoded string: $EncodedString"
			$value = [Convert]::FromBase64String($EncodedString)
			Write-Verbose "Value: $Value"
			$PlainTextString = [System.Text.Encoding]::$Format.GetString($value)
			$OutputTable = New-Object -TypeName psobject
		$OutputTable | Add-Member -MemberType NoteProperty -name PlainText -value $PlainTextString
		$OutputTable | Add-Member -MemberType NoteProperty -name Base64 -value $EncodedString}
		catch{
			$OutputTable = New-Object -TypeName psobject
		$OutputTable | Add-Member -MemberType NoteProperty -name PlainText -value "Invalid string"
		$OutputTable | Add-Member -MemberType NoteProperty -name Base64 -value $EncodedString}
		$OutputTable}
	}
