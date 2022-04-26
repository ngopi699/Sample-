param( 
    [Parameter(Mandatory=$true)] 
    [string] $GitFilePath,
    [Parameter(Mandatory=$true)] 
    [string] $OutFilePath,
    [Parameter(Mandatory=$true)] 
    [string] $RepoName,
    [string] $token,
    [string] $orgUrl,
    [string] $teamProject
)

if([String]::IsNullOrEmpty($token))
{
    if($env:SYSTEM_ACCESSTOKEN -eq $null)
    {
        Write-Error "you must either pass the -token parameter or use the BUILD_TOKEN environment variable"
        exit 1;
    }
    else
    {
        $token = $env:SYSTEM_ACCESSTOKEN;
    }
}


if([string]::IsNullOrEmpty($teamProject)){
    if($env:SYSTEM_TEAMPROJECT -eq $null)
    {
        Write-Error "you must either pass the -teampProject parameter or use the SYSTEM_TEAMPROJECT environment variable"
        exit 1;
    }
    else
    {
        $teamProject = $env:SYSTEM_TEAMPROJECT
    }
}

if([string]::IsNullOrEmpty($orgUrl)){
    if($env:SYSTEM_COLLECTIONURI -eq $null)
    {
        Write-Error "you must either pass the -orgUrl parameter or use the SYSTEM_COLLECTIONURI environment variable"
        exit 1;
    }
    else
    {
        $teamProject = $env:SYSTEM_COLLECTIONURI
    }
}

# Base64-encodes the Personal Access Token (PAT) appropriately  
$User='' 
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $User,$token)));  
$header = @{Authorization=("Basic {0}" -f $base64AuthInfo)};  
#---------------------------------------------------------------------- 

Write-Host "Download file" $GitFilePath "to" $OutFilePath
  
  #https://dev.azure.com/ngopi6990058/Gopi_Test/_git/Sample-.git   
$uriGetFile = "$orgUrl/$teamProject/_apis/git/repositories/$repoName/items?scopePath=$GitFilePath&download=true&api-version=6.1-preview.1"
  
Write-Host "Url:" $uriGetFile
    
$filecontent = Invoke-RestMethod -ContentType "application/json" -UseBasicParsing -Headers $header -Uri $uriGetFile
$filecontent | Out-File -Encoding utf8 $OutFilePath