<#
.Synopsis
	Build script <https://github.com/nightroman/Invoke-Build>

.Example
	Invoke-Build Install

.Example
    Invoke-Build Publish -NuGetApiKey xyz
#>

param(
    [string] $NuGetApiKey # mandatory for Publish
)

. $PsScriptRoot\Tasks\Build.Tasks.ps1
. $PSScriptRoot\tasks\Testdata.Tasks.ps1
