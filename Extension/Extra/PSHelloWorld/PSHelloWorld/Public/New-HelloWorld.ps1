
Function New-HelloWorld {
    <#
    .SYNOPSIS
        Returns Hello world
    .DESCRIPTION
        Returns Hello world
    .PARAMETER FirstName
        First name for Hello World function
    .PARAMETER LastName
        Last name for Hello World function
    .EXAMPLE
        PS> New-HelloWorld -FirstName 'John' -LastName 'Stranger'

        Runs the command
    #>
    [CmdletBinding()]
    param ([Parameter(Mandatory = $true)]
        [string]$FirstName,
        [Parameter(Mandatory = $true)]
        [string]$LastName          
    )
    ('Hello {0} {1}' -f $FirstName, $LastName)
}