<#
.SYNOPSIS
Used to launch games that are included in the module.

.DESCRIPTION
A simple module to launch game scripts included in the module directory.

.NOTES
Start a new game with the New-Game cmdlet followed by the name of the game. For example: New-Game -GameName TicTacToe

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