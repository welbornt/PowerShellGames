<#
.SYNOPSIS
Play a game of Tic-Tac-Toe in your terminal - written in PowerShell.

.DESCRIPTION
A simple game of Tic-Tac-Toe written in PowerShell.
#>

$global:PlayerWins = 0
$global:ComputerWins = 0
$global:Ties = 0

# Print the current game board
function PrintBoard {
    Write-Output "$($BoardEntries[0])|$($BoardEntries[1])|$($BoardEntries[2])"
    Write-Output "_____"
    Write-Output "$($BoardEntries[3])|$($BoardEntries[4])|$($BoardEntries[5])"
    Write-Output "_____"
    Write-Output "$($BoardEntries[6])|$($BoardEntries[7])|$($BoardEntries[8])`n"
}

# Ask the player for their move
function GetPlayerMove {
    Clear-Host
    PrintBoard
    while ($true){
        try {
            $response = [int](Read-Host -Prompt 'Where do you want to move? [1-9]')
            if (' ' -eq $BoardEntries[$response - 1]){
                $global:BoardEntries[$response - 1] = $global:PlayerLetter
                break
            }
            else {
                Write-Output 'You cannot go here. This space is already taken.'
            }
        } catch {
            Write-Output 'Invalid response. Please choose a number between 1 and 9.'
        }
    }
    Clear-Host
    PrintBoard
    CheckWinConditions
}

# Generate a random move for the computer
function GetComputerMove {
    Clear-Host
    PrintBoard
    Write-Output 'Your opponent is thinking.'
    Start-Sleep -Seconds 3
    Clear-Host
    while ($true){
        $choice = Get-Random -Minimum 0 -Maximum 9
        if (' ' -eq $BoardEntries[$choice]){
            $global:BoardEntries[$choice] = $PlayerLetter -eq 'x' ? 'o' : 'x'
            break
        }
    }
    PrintBoard
    Write-Output "Your opponent takes their turn."
    CheckWinConditions
}

# Add the score based on the letter passed to the function
function Score($Letter){
    # Player wins
    if ($Letter -eq $PlayerLetter){
        Write-Output 'You won!'
        $global:PlayerWins++
    }
    # Tied game
    elseif ($Letter -eq 't'){
        Write-Output "Cat's game! (tie)"
        $global:Ties++
    }
    # Computer wins
    else {
        Write-Output 'You lost!'
        $global:ComputerWins++
    }
    PrintScore
    $global:GameOver = $true
}

# Check if any win conditions have been met or if the game has tied
function CheckWinConditions {
    # Check rows
    if (($BoardEntries[0] -ne ' ') -and ($BoardEntries[0] + $BoardEntries[1] -eq $BoardEntries[2] * 2)) {Score($BoardEntries[0])}
    elseif (($BoardEntries[3] -ne ' ') -and ($BoardEntries[3] + $BoardEntries[4] -eq $BoardEntries[5] * 2)) {Score($BoardEntries[3])}
    elseif (($BoardEntries[6] -ne ' ') -and ($BoardEntries[6] + $BoardEntries[7] -eq $BoardEntries[8] * 2)) {Score($BoardEntries[6])}
    # Check columns
    elseif (($BoardEntries[0] -ne ' ') -and ($BoardEntries[0] + $BoardEntries[3] -eq $BoardEntries[6] * 2)) {Score($BoardEntries[0])}
    elseif (($BoardEntries[1] -ne ' ') -and ($BoardEntries[1] + $BoardEntries[4] -eq $BoardEntries[7] * 2)) {Score($BoardEntries[1])}
    elseif (($BoardEntries[2] -ne ' ') -and ($BoardEntries[2] + $BoardEntries[5] -eq $BoardEntries[8] * 2)) {Score($BoardEntries[2])}
    # Check diagonals
    elseif (($BoardEntries[0] -ne ' ') -and ($BoardEntries[0] + $BoardEntries[4] -eq $BoardEntries[8] * 2)) {Score($BoardEntries[0])}
    elseif (($BoardEntries[2] -ne ' ') -and ($BoardEntries[2] + $BoardEntries[4] -eq $BoardEntries[6] * 2)) {Score($BoardEntries[2])}

    # Check for tied game
    elseif (!$BoardEntries.Contains(' ')) {Score('t')}
}

# Ask the player if they would like to be X's or O's
function GetPlayerLetter {
    while ($true){
        $response  = (Read-Host -Prompt "Would you like to be X's or O's (X's go first!)? [x/o]").ToLower()
        if (@('x','o').Contains($response)){
            $global:PlayerLetter = $response
            break
        }
        else {
            Write-Output 'Invalid response.'
        }
    }
}

# Print the current score
function PrintScore {
    Write-Output "Player wins: $PlayerWins`nComputer wins: $ComputerWins`nTies: $Ties"
}

# Main gameplay loop
function PlayGame {
    Clear-Host
    $global:GameOver = $false
    $global:BoardEntries = 1..9 | ForEach-Object { ' ' }
    GetPlayerLetter
    PrintBoard
    if ('x' -eq $PlayerLetter){
        while (!$GameOver){
            GetPlayerMove
            if ($GameOver) {break} # Needed to prevent accumulation of multiple points
            GetComputerMove
        }
    }
    else {
        while (!$GameOver){
            GetComputerMove
            if ($GameOver) {break} # Needed to prevent accumulation of multiple points
            GetPlayerMove
        }
    }
    AskToPlayAgain
}

# Print the final score and determine the overall winner
function PrintFinalScore {
    Clear-Host
    PrintScore
    if ($PlayerWins -gt $ComputerWins){
        Write-Output 'You won! Congratulations!'
    }
    elseif ($PlayerWins -lt $ComputerWins){
        Write-Output "You lost. Don't give up!"
    }
    else {
        Write-Output "It's a tie. Keep practicing!"
    }
}

# Ask the player if they would like to play another game
function AskToPlayAgain {
    while ($true){
        $response = (Read-Host -Prompt 'Would you like to play again? [y/n]').ToLower()
        if ('y' -eq $response){
            PlayGame
            break
        }
        elseif ('n' -eq $response){
            PrintFinalScore
            break
        }
        else {
            Write-Output 'Invalid response.'
        }
    }
}

# Entry point
PlayGame
