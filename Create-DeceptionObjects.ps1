Function Create-DeceptionObjects{
    <#
    .SYNOPSIS
    Creates pocket lint for HoneyPots based on a specified directory

    .DESCRIPTION
    Creates garbage files based on a specified folder/file structure, including file/directory names and timestamps.


    .PARAMETER MirrorSource
    Specifies the location to copy it's structure from.

    .PARAMETER MirrorDestination
    Specifies the location to create pocket lint directories and files.
    
    .EXAMPLE
    Create-DeceptionObjects -MirrorSource C:\Users\Example\Documents -MirrorDestination E:\HoneyPotFiles

    .LINK
    https://github.com/TokLabs/Powershell/blob/main/Create-DeceptionObjects.ps1


    #>
    [CmdletBinding()] Param(
        [Parameter(Position = 0,Mandatory = $True)]
        [String]
        $MirrorSource,

        [Parameter(Position = 1,Mandatory = $True)]
        [String]
        $MirrorDestination)

    Write-Host "Enumerating files and directories to fake..."
    $Files = Get-ChildItem -LiteralPath $MirrorSource -File -Recurse
    #Checking if destination has enough storage for fake files
    $SourceSpace = (($Files | Measure-Object Length -Sum -ErrorAction Stop).sum /1MB)
    $DestinationFreeSpace = ((Get-WmiObject win32_logicaldisk | where {$_.DeviceID -eq (Get-Item $MirrorDestination | Select -ExpandProperty Root).name.trimend("\")}).freespace / 1MB)
    if (($DestinationFreeSpace+1) -lt $SourceSpace){
        $SpaceRequired = (($DestinationFreeSpace - $SourceSpace).ToString("#.##")).trimstart("-")+"MB"
        Write-Error "Not enough storage space available on the destination to create objects." -RecommendedAction "An Additional $SpaceRequired needs to be made available on the destination drive to continue."}
    else{
        $Directories = (($Files).Directory | Select -Unique).FullName
        $Files = $Files | select FullName, Length, CreationTimeUtc, LastAccessTimeUtc, LastWriteTimeUtc
        $MirrorDirectories = @()
        $MirrorFiles = @()
        Foreach ($Directory in $Directories){
            $MirrorDirectories += ($Directory).replace($MirrorSource,$MirrorDestination)}
        Foreach ($File in $files){
            $TempObject = New-Object PSObject
            Add-Member -InputObject $TempObject -MemberType NoteProperty -Name FullName -Value ($File.FullName)
            Add-Member -InputObject $TempObject -MemberType NoteProperty -Name Length -Value ($File.Length)
            Add-Member -InputObject $TempObject -MemberType NoteProperty -Name CreationTimeUtc -Value ($File.CreationTimeUtc)
            Add-Member -InputObject $TempObject -MemberType NoteProperty -Name LastAccessTimeUtc -Value ($File.LastAccessTimeUtc)
            Add-Member -InputObject $TempObject -MemberType NoteProperty -Name LastWriteTimeUtc -Value ($File.LastWriteTimeUtc)
            $MirrorFiles += $TempObject}
        Foreach ($MirrorFile in $MirrorFiles){
            $MirrorFile.FullName = $MirrorFile.FullName.replace($MirrorSource,$MirrorDestination)}
        Write-Host "Creating fake directories"
        Foreach ($MirrorDirectory in $MirrorDirectories){
            mkdir $MirrorDirectory | Out-Null -ErrorAction SilentlyContinue}
        Write-Host "Creating fake files"
        Foreach ($MirrorFile in $MirrorFiles){
            if($MirrorFile.length -lt 4KB){
                New-Item $MirrorFile.FullName | Out-Null
                $TempFile = $MirrorFile.FullName | Get-Item
                $Buffer = [byte[]]::new($MirrorFile.Length)
                $RandomContent = [System.Security.Cryptography.RNGCryptoServiceProvider]::Create()
                $FileStream = $TempFile.OpenWrite()
                do{
                    $RandomContent.getbytes($Buffer)
                    $FileStream.Write($Buffer, 0, $Buffer.Length)}
                while ($FileStream.length -lt $MirrorFile.length)
                $FileStream.Dispose()
                $RandomContent.Dispose()}
            else{
                New-Item $MirrorFile.FullName | Out-Null
                $TempFile = $MirrorFile.FullName | Get-Item
                $Buffer = [byte[]]::new(4KB)
                $RandomContent = [System.Security.Cryptography.RNGCryptoServiceProvider]::Create()
                $FileStream = $TempFile.OpenWrite()
                do{
                    $RandomContent.getbytes($Buffer)
                    $FileStream.Write($Buffer, 0, $Buffer.Length)
                    $BufferLength = $MirrorFile.Length - $FileStream.Length}
                while ($FileStream.length -lt $MirrorFile.length-4KB)
                $FileStream.Dispose()
                $RandomContent.Dispose()
                #Hack to take advantage of .Net Crypto's speed and a 4KB buffer whilst aiming to keep the file size accurate.
                $FakeFile = New-Object byte[] $BufferLength
                (New-Object Random).NextBytes($FakeFile)
                Add-Content -LiteralPath $MirrorFile.FullName -Value $FakeFile -Encoding Byte | Out-Null}
            (Get-Item $MirrorFile.FullName).CreationTimeUtc = $MirrorFile.CreationTimeUtc
            (Get-Item $MirrorFile.FullName).LastAccessTimeUtc = $MirrorFile.LastAccessTimeUtc
            (Get-Item $MirrorFile.FullName).LastWriteTimeUtc = $MirrorFile.LastWriteTimeUtc}
        }
    }
