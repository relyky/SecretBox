# SecretBox
秘密盒子

### 暫時打開限制: 變更當前 PowerShell 工作階段的執行原則
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
 
### 加密 
.\ProtectSecret.ps1 -Mode Encrypt -InputFile secret_box.json -OutputFile secret_box.bin
 
### 解密
.\ProtectSecret.ps1 -Mode Decrypt -InputFile secret_box.bin -OutputFile secret_restored.json
