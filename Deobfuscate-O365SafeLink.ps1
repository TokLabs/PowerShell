function Deobfuscate-O365SafeLink{
	[CmdletBinding()] param(
		[parameter(Position = 0, Mandatory=$true)][string]$uri)
	[uri]::UnescapeDataString((($uri -replace "https://[a-zA-Z]{3}[0-9]{2}.safelinks.protection.outlook.com/\?url=","").split("&data"))[0])}