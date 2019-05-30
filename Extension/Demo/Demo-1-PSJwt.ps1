<#
    DON'T FORGET to collapse all regions in demo scripts
    Ctrl + K Ctrl +8

    #####################################################
    Demo 1 - PSJwt Module - 5 minutes
    #####################################################

    Demo the functions in the PSJwt PowerShell Module  
#>

#region Import PSJwt Module
Import-Module -Name PSJwt -Verbose
#endregion

#region show help

# JSON Web Token (JWT) is a JSON-based open standard (RFC 7519) for creating access tokens.
# JWT claims can be typically used to pass identity of authenticated users between an identity provider and a service provider.

Get-Help ConvertFrom-JWT -Full
Get-Help Convertto-JWT -Full
#endregion

#region Syntax of functions
Get-Command -Name Convertfrom-Jwt -Syntax
Get-Command -Name ConvertTo-Jwt -Syntax
#endregion

#region demo ConvertFrom-Jwt
$Token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkhCeGw5bUFlNmd4YXZDa2NvT1UyVEhzRE5hMCIsImtpZCI6IkhCeGw5bUFlNmd4YXZDa2NvT1UyVEhzRE5hMCJ9.eyJhdWQiOiJodHRwczovL2dyYXBoLndpbmRvd3MubmV0LyIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzcyZjk4OGJmLTg2ZjEtNDFhZi05MWFiLTJkN2NkMDExZGI0Ny8iLCJpYXQiOjE1NTc0ODc4ODQsIm5iZiI6MTU1NzQ4Nzg4NCwiZXhwIjoxNTU3NDkxNzg0LCJhaW8iOiI0MlpnWUpoNzY1ZngxZ3VIRTY0c0xNbjdPZWVRQ1FBPSIsImFwcGlkIjoiOTFkYjY4ZWEtYmEyYy00YTA1LWFmZjktMDRmMWRhYWI4NjkyIiwiYXBwaWRhY3IiOiIxIiwiaWRwIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvNzJmOTg4YmYtODZmMS00MWFmLTkxYWItMmQ3Y2QwMTFkYjQ3LyIsIm9pZCI6ImY3Y2JiYzhhLTAxMjctNDU3NC1hZDNhLTA1ZjJkNjMxOGRjMyIsInN1YiI6ImY3Y2JiYzhhLTAxMjctNDU3NC1hZDNhLTA1ZjJkNjMxOGRjMyIsInRlbmFudF9yZWdpb25fc2NvcGUiOiJXVyIsInRpZCI6IjcyZjk4OGJmLTg2ZjEtNDFhZi05MWFiLTJkN2NkMDExZGI0NyIsInV0aSI6IjFKM2dReUVTUjBpbEdwTDF5alFRQUEiLCJ2ZXIiOiIxLjAifQ.ojDJX_zNpT3DaXB1GKlLG6Ozsx_ZdZc-eqXNtKrheEI5xWlUhxyAG2iIyLRmL8ei4-7Bb_adhn1l1FxUYZmxcuz5MNhnHl1ltlp_ELjSvVPIMadIJZyXqtO8BdRXrr_sEIAktuhGl02OhiIismzBX9KaQUQbnPsDWNlmwusizSqWsZyOIEAIwQRVRYuE9iXzKAP_izC8sTO6cZYNhuueJpqchDsr49SHrVG1DPvUt_faikWu4qU9TaBAxDjwOiEHBea8wm99TDPA6hW0j29f_c2Tpf8D6zYnwRiQ4-z9C6neyU0d4ehrlsMLjzGuWZxeaj7c5UA8l56d-OLC36FQ6g'
ConvertFrom-Jwt -Token $Token

# Convert iat (issued at) and exp (expiration date to user friendly date)
[timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds((ConvertFrom-Jwt -Token $Token).iat))
[timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds((ConvertFrom-Jwt -Token $Token).exp))
#endregion

#region Converto-Jwt
$iat = [DateTimeOffset]::Now.ToUnixTimeSeconds(); ('Unix Issued at Date:  {0}. Local Time: {1} ' -f $iat, [DateTimeOffset]::Now)
$exp = [DateTimeOffset]::Now.AddHours(1).ToUnixTimeSeconds(); ('Unix Expiration Date: {0}. Local Time: {1}' -f $exp, [DateTimeOffset]::Now.AddHours(1))

@{'FirstName' = 'Stefan'; 'LastName' = 'Stranger'; 'Demo' = 'Encode Access Token'; 'exp' = $exp; 'iat' = $iat } | 
ConvertTo-Jwt -secret 'qwerty' -OutVariable CustomToken

ConvertFrom-JWT -Token $CustomToken
#endregion

[timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds(1559202761))
