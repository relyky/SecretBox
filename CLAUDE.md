# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SecretBox is a Windows-based secret file encryption utility using Windows DPAPI (Data Protection API). It encrypts/decrypts JSON configuration files with user-bound encryption, outputting base64 format.

## Commands

### PowerShell Version

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

### C# Version (.NET 8)

```bash
# Using dotnet run
dotnet run --project csharp -- encrypt secret.json secret.b64
dotnet run --project csharp -- decrypt secret.b64 secret.json

# Using compiled executable
.\csharp\bin\Release\net8.0\win-x64\publish\SecretBox.exe encrypt secret.json secret.b64
.\csharp\bin\Release\net8.0\win-x64\publish\SecretBox.exe decrypt secret.b64 secret.json
```

Compile standalone executable:
```bash
cd csharp
dotnet publish -c Release -r win-x64 --self-contained
```

## Architecture

### PowerShell Implementation
Single PowerShell script (`ProtectSecret.ps1`) with:
- `Test-JsonValid` function for JSON validation
- DPAPI encryption via `System.Security.Cryptography.ProtectedData`
- Base64 output with 80-character line wrapping

### C# Implementation
Console application (`csharp/main.cs`) with:
- .NET 8 / C# 12 (top-level statements, file-scoped namespaces)
- `System.Text.Json` for JSON validation
- `System.Security.Cryptography.ProtectedData` for DPAPI encryption
- UTF-8 encoding without BOM
- Fully compatible with PowerShell version

## Constraints

- Encrypted files are bound to the current Windows user account
- Only decryptable on the same machine by the same user
- Input must be valid JSON format
