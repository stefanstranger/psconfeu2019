<#
    Demo Request form calling REST API

    Open webbrowser http://localhost:80 and enter the following values in the fields
    'Email Address'       = 'johndoe@sstranger.onmicrosoft.com'
    'Group Name'       = 'PPSConfEu-Demo-Group'
    'Members'           = 'janedoe@sstranger.onmicrosoft.com'

    Remark: Make sure the REST API is running!!!

    Collapse regions - Ctrl K + Ctrl 8
#>

#region Create new Request Dashboard
$RequestDashboard = New-UDDashboard -Title 'Request Group' -Content {
    New-UDInput -Title 'Request form for Azure Active Directory Groups' -Id 'Form' -Content {
        New-UDInputField -Type 'textbox' -Name 'UserPrincipalName' -Placeholder 'Email Address'
        New-UDInputField -Type 'textbox' -Name 'DisplayName' -Placeholder 'Group Name'
        New-UDInputField -Type 'textbox' -Name 'Members' -Placeholder 'Member email address'
    } -Endpoint {
        param($UserPrincipalName, $DisplayName, $Members)
        #region Call REST API to Create Group
        $body = @{
            'DisplayName'       = $DisplayName
            'Description'       = 'PSConfEu Demo Group'
            'MailNickName'      = 'psconfeudemogroup'
            'UserPrincipalName' = $UserPrincipalName
            'Members'           = $Members
        }
      
        $Result = Invoke-RestMethod -Uri http://localhost:8080/api/newgroup -Method POST -Body $body

        New-UDInputAction -Toast ($Result | convertto-json) -Duration 10000
        #endregion
    }    
}
#endregion

#region Start Dashboard
Start-UDDashboard -port 80 -Dashboard $RequestDashboard -Name Request
#endregion

#region Stop Dashboard
Stop-UDDashboard -Name Request
#endregion
