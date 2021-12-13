function Deobfuscate-O365SafeLink{
	<#
	.SYNOPSIS
	Deobfuscates Office 365 safe links.
	
	.DESCRIPTION
	Powershell cmdlet to debobfuscate Office 365's safe links.
	
	.PARAMETER Uri
	Specifies a safe link to deobfuscate.
	
	.EXAMPLE
	Deobfuscate-O365SafeLink -Uri "https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.toklabs.com&data=firstname.lastname%40domain.com&data=xxxx&reserved=0"
	
	.LINK
	https://github.com/TokLabs/Powershell/blob/master/Deobfuscate-O365SafeLink.ps1
	#>
	
	[CmdletBinding()] param(
		[parameter(Position = 0, Mandatory=$True)][string]$Uri)
		
	<#String is extracted through regex and spliting.
		Extracted string is decoded with UnescapeDataString method#>	
	[uri]::UnescapeDataString(($Uri -replace "https://[a-zA-Z]{2,3}[0-9]{2}.safelinks.protection.outlook.com/\?url=","") -split"&data").split(" ")[0]}
