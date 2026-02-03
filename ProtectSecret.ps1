<#
.SYNOPSIS
    Encrypt/Decrypt JSON secret files

.DESCRIPTION
    Uses Windows DPAPI to encrypt or decrypt JSON files.
    Encrypted content is bound to the current Windows user.

.PARAMETER Mode
    Operation mode: Encrypt or Decrypt

.PARAMETER InputFile
    Input file path

.PARAMETER OutputFile
    Output file path

.EXAMPLE
    .\ProtectSecret.ps1 -Mode Encrypt -InputFile secret.json -OutputFile secret.bin

.EXAMPLE
    .\ProtectSecret.ps1 -Mode Decrypt -InputFile secret.bin -OutputFile secret.json
#>

param(
    [Parameter(Mandatory)]
    [ValidateSet("Encrypt", "Decrypt")]
    [string]$Mode,

    [Parameter(Mandatory)]
    [string]$InputFile,

    [Parameter(Mandatory)]
    [string]$OutputFile
)

$ErrorActionPreference = "Stop"

function Test-JsonValid {
    param([string]$Content)
    try {
        $null = $Content | ConvertFrom-Json
        return $true
    }
    catch {
        return $false
    }
}

if (-not (Test-Path $InputFile)) {
    Write-Error "Input file not found: $InputFile"
    exit 1
}

Add-Type -AssemblyName System.Security

if ($Mode -eq "Encrypt") {
    $content = Get-Content -Path $InputFile -Raw -Encoding UTF8

    if (-not (Test-JsonValid -Content $content)) {
        Write-Error "Input file is not valid JSON"
        exit 1
    }

    $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
    $encryptedBytes = [System.Security.Cryptography.ProtectedData]::Protect(
        $bytes, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser
    )
    $base64 = [Convert]::ToBase64String($encryptedBytes)
    $wrapped = $base64 -replace "(.{80})", "`$1`n"
    $wrapped = $wrapped.TrimEnd("`n")

    $wrapped | Out-File -FilePath $OutputFile -Encoding UTF8 -NoNewline

    Write-Host "Encrypted: $OutputFile"
}
else {
    $base64 = Get-Content -Path $InputFile -Raw -Encoding UTF8
    $base64 = $base64 -replace "`r`n|`n|`r", ""

    try {
        $encryptedBytes = [Convert]::FromBase64String($base64)
        $bytes = [System.Security.Cryptography.ProtectedData]::Unprotect(
            $encryptedBytes, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser
        )
    }
    catch {
        Write-Error "Decryption failed. Invalid encrypted file or different user."
        exit 1
    }

    $content = [System.Text.Encoding]::UTF8.GetString($bytes)

    if (-not (Test-JsonValid -Content $content)) {
        Write-Error "Decrypted content is not valid JSON"
        exit 1
    }

    $content | Out-File -FilePath $OutputFile -Encoding UTF8 -NoNewline

    Write-Host "Decrypted: $OutputFile"
}
