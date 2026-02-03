using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

if (args.Length != 3)
{
    Console.WriteLine("Usage: SecretBox <encrypt|decrypt> <input-file> <output-file>");
    return 1;
}

var mode = args[0].ToLower();
var inputFile = args[1];
var outputFile = args[2];

if (mode != "encrypt" && mode != "decrypt")
{
    Console.WriteLine($"Error: Invalid mode '{args[0]}'. Use 'encrypt' or 'decrypt'.");
    return 1;
}

if (!File.Exists(inputFile))
{
    Console.WriteLine($"Error: Input file not found: {inputFile}");
    return 1;
}

try
{
    if (mode == "encrypt")
    {
        Encrypt(inputFile, outputFile);
        Console.WriteLine($"Encrypted: {outputFile}");
    }
    else
    {
        Decrypt(inputFile, outputFile);
        Console.WriteLine($"Decrypted: {outputFile}");
    }
    return 0;
}
catch (Exception ex)
{
    Console.WriteLine($"Error: {ex.Message}");
    return 1;
}

static void Encrypt(string inputFile, string outputFile)
{
    var content = File.ReadAllText(inputFile, Encoding.UTF8);

    if (!IsValidJson(content))
    {
        throw new InvalidOperationException("Input file is not valid JSON");
    }

    var bytes = Encoding.UTF8.GetBytes(content);
    var encryptedBytes = ProtectedData.Protect(bytes, null, DataProtectionScope.CurrentUser);
    var base64 = Convert.ToBase64String(encryptedBytes);
    var wrapped = WrapBase64(base64, 80);

    File.WriteAllText(outputFile, wrapped, new UTF8Encoding(false));
}

static void Decrypt(string inputFile, string outputFile)
{
    var base64 = File.ReadAllText(inputFile, Encoding.UTF8);
    base64 = base64.Replace("\r\n", "").Replace("\n", "").Replace("\r", "");

    byte[] encryptedBytes;
    byte[] bytes;

    try
    {
        encryptedBytes = Convert.FromBase64String(base64);
        bytes = ProtectedData.Unprotect(encryptedBytes, null, DataProtectionScope.CurrentUser);
    }
    catch
    {
        throw new InvalidOperationException("Decryption failed. Invalid encrypted file or different user.");
    }

    var content = Encoding.UTF8.GetString(bytes);

    if (!IsValidJson(content))
    {
        throw new InvalidOperationException("Decrypted content is not valid JSON");
    }

    File.WriteAllText(outputFile, content, new UTF8Encoding(false));
}

static bool IsValidJson(string content)
{
    try
    {
        using var doc = JsonDocument.Parse(content);
        return true;
    }
    catch (JsonException)
    {
        return false;
    }
}

static string WrapBase64(string base64, int lineLength)
{
    var lines = new List<string>();
    for (int i = 0; i < base64.Length; i += lineLength)
    {
        var length = Math.Min(lineLength, base64.Length - i);
        lines.Add(base64.Substring(i, length));
    }
    return string.Join('\n', lines);
}
