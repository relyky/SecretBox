# SecretBox - C# Implementation

C# (.NET 8) 實作的 Windows DPAPI 加密工具。

## 需求

- .NET 8 SDK
- Windows OS (使用 DPAPI)

## 使用方式

### 加密 JSON 檔案

```bash
dotnet run --project csharp -- encrypt input.json output.b64
```

### 解密檔案

```bash
dotnet run --project csharp -- decrypt input.b64 output.json
```

## 編譯獨立執行檔

```bash
cd csharp
dotnet publish -c Release -r win-x64 --self-contained
```

執行檔位於: `bin/Release/net8.0/win-x64/publish/SecretBox.exe`

使用方式:
```bash
SecretBox.exe encrypt input.json output.b64
SecretBox.exe decrypt input.b64 output.json
```

## 與 PowerShell 版本的互通性

C# 版本與 PowerShell 版本完全互通:

- PowerShell 加密的檔案可用 C# 解密
- C# 加密的檔案可用 PowerShell 解密

## 技術特性

- 使用 `System.Security.Cryptography.ProtectedData`
- 加密綁定到當前 Windows 使用者 (`DataProtectionScope.CurrentUser`)
- Base64 輸出,每行 80 字元
- UTF-8 編碼,無 BOM
- JSON 格式驗證
