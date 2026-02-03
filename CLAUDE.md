# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SecretBox is a Windows-based secret file encryption utility using Windows DPAPI (Data Protection API). It encrypts/decrypts JSON configuration files with user-bound encryption, outputting base64 format.

## Commands

```powershell
# Encrypt JSON to base64 (requires valid JSON input)
.\ProtectSecret.ps1 -Mode Encrypt -InputFile secret.json -OutputFile secret.b64

# Decrypt base64 back to JSON
.\ProtectSecret.ps1 -Mode Decrypt -InputFile secret.b64 -OutputFile secret.json
```

**Note:** If execution policy blocks scripts, use:
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

## Architecture

Single PowerShell script (`ProtectSecret.ps1`) with:
- `Test-JsonValid` function for JSON validation
- DPAPI encryption via `System.Security.Cryptography.ProtectedData`
- Base64 output with 80-character line wrapping

## Constraints

- Encrypted files are bound to the current Windows user account
- Only decryptable on the same machine by the same user
- Input must be valid JSON format
