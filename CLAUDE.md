# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SecretBox is a Windows-based secret file encryption utility using Windows DPAPI (Data Protection API). It encrypts/decrypts JSON configuration files with user-bound encryption.

## Commands

```powershell
# Encrypt JSON to binary (requires valid JSON input)
.\ProtectSecret.ps1 -Mode Encrypt -InputFile secret.json -OutputFile secret.bin

# Decrypt binary back to JSON
.\ProtectSecret.ps1 -Mode Decrypt -InputFile secret.bin -OutputFile secret.json
```

**Note:** If execution policy blocks scripts, use:
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

## Architecture

Single PowerShell script (`ProtectSecret.ps1`) with:
- `Test-JsonValid` function for JSON validation
- DPAPI encryption via `ConvertTo-SecureString` / `ConvertFrom-SecureString`
- Secure memory cleanup using `Marshal.ZeroFreeBSTR`

## Constraints

- Encrypted files are bound to the current Windows user account
- Only decryptable on the same machine by the same user
- Input must be valid JSON format
