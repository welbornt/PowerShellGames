<#
.SYNOPSIS
Used to launch games that are included in the module.

.DESCRIPTION
A simple module to launch game scripts included in the module directory.

.PARAMETER GameName
The name of the game you want to play - must be defined in the validation set.
#>

function New-Game{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet(
            'TicTacToe'
        )]
        [string] $GameName
    )
    Invoke-Expression "$($((Get-Module PS-Games).Path -replace 'PS-Games.psm1', `"$GameName.ps1`"))"
}