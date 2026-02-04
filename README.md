# SecretBox
秘密盒子

### 暫時打開限制: 變更當前 PowerShell 工作階段的執行原則
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
 
### 加密 
.\ProtectSecret.ps1 -Mode Encrypt -InputFile secret_box.json -OutputFile secret_box.b64

### 加密(CS) 
.\csharp\bin\Release\net8.0\win-x64\publish\SecretBox.exe encrypt secret_box.json secret_box.b64

### 解密
.\ProtectSecret.ps1 -Mode Decrypt -InputFile secret_box.b64 -OutputFile secret_restored.json

### 解密(CS) 
.\csharp\bin\Release\net8.0\win-x64\publish\SecretBox.exe decrypt secret_box.b64 secret_restored_cs.json

### 加密 with entropy
.\ProtectSecret.ps1 -Mode Encrypt -InputFile secret_box.json -OutputFile secret_box.b64 -Entropy "ABCDEF0123456789"

### 解密 with entropy
.\ProtectSecret.ps1 -Mode Decrypt -InputFile secret_box.b64 -OutputFile secret_restored.json -Entropy "ABCDEF0123456789"
