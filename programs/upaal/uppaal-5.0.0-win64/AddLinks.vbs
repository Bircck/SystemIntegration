Set WshShell = CreateObject("WScript.Shell")
menu = WshShell.SpecialFolders("StartMenu")
programfiles = WshShell.SpecialFolders("ProgramFiles")

' locate the current installation paths
Set fso = CreateObject("Scripting.FileSystemObject")
here = fso.GetParentFolderName(WScript.ScriptFullName)
vername = UCase(fso.GetFolder(here).Name)

Function readFromRegistry (strRegistryKey)
    Dim value
    On Error Resume Next
    value = WshShell.RegRead( strRegistryKey )
    If err.number <> 0 Then
        readFromRegistry=""
    Else
        readFromRegistry=value
    End If
End Function

Dim jdkVersion
jdkVersion = readFromRegistry("HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\JDK\CurrentVersion")
If (jdkVersion <> "") Then
	Dim regPath
	regPath = "HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\JDK\" & jdkVersion & "\JavaHome"
	jrePath = readFromRegistry(regPath)
End If
If (jrePath = "") Then
	WScript.Echo "Java Runtime Environment (JRE) was not found." & vbCr & vbCr _
	    & "Please make sure that Java 11 or later is installed with JavaSoft registry keys." & vbCr _
        & "E.g.: https://adoptium.net/ (select JavaSoft registry keys during install)" & vbCr _
        & "  or search for Open JDK vendor, see https://en.wikipedia.org/wiki/OpenJDK"
	WScript.Quit
End If

javawPath = jrePath & "\bin\javaw.exe"

' clean the PATH:
Set WSHUserEnv = WshShell.Environment("USER")
newpath = ""
For Each segment In Split(WSHUserEnv("PATH"), ";")
	If InStr(1, LCase(segment), "uppaal") = 0 Then
		If newpath = "" Then
			newpath = segment
		Else
			newpath = newpath & ";" & segment
		End If
	Else
		q = "An earlier UPPAAL installation has been found at" & vbCr & "  " _
			& segment & vbCr & vbCr & "Remove it from the PATH?"
		If WshShell.Popup(q,0,vername,4+32+4096+65536) = vbNo Then
			If newpath = "" Then
				newpath = segment
			Else
				newpath = newpath & ";" & segment
			End If
		End If
	End If
Next

targetDir = here
icondir = targetDir & "\res\uppaal.ico"
'working = WshShell.SpecialFolders("MyDocuments")
working = targetDir & "\demo"
descr = "Timed automata model-checking tool suite"

' add current installation:
thisInstall = targetDir & "\bin"
q = "Add this UPPAAL installation to the PATH?" & vbCr & thisInstall & vbCr _
    & vbCr & "(useful to run verifyta from command line)"
If WshShell.Popup( q,0,vername,4+32+4096+65536 ) = vbYes Then
	WSHUserEnv("PATH") = newpath & ";" & thisInstall
Else
	WSHUserEnv("PATH") = newpath
End If

Sub createLink (strLocation, linkName, arguments)
    Set oShellLink = WshShell.CreateShortcut(strLocation & "\" & linkName & ".lnk")
    oShellLink.TargetPath = javawPath
    oShellLink.Arguments = arguments
    oShellLink.WindowStyle = 1
    oShellLink.IconLocation = icondir
    oShellLink.Description = descr
    oShellLink.WorkingDirectory = working
    oShellLink.Save
End Sub

' check for proxy
javaArgs = ""
proxyEnable = readFromRegistry("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyEnable")
If proxyEnable>0 Then
	q = "Looks like proxy is used to access Internet." & vbCr & vbCr _
		& "Setup the proxy for UPPAAL too?" & vbCr & vbCr _
		& "(license check requires Internet access)"
	If WshShell.Popup(q,0,vername,4+32+4096+65536) = vbYes Then
		proxy = readFromRegistry("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyServer")
		if Len(proxy)>0 Then
			proxySettings = Split(proxy, ":")
			proxyHost = proxySettings(0)
			proxyPort = proxySettings(1)
		End If
		proxyHost = Trim(InputBox("Enter proxy host", vername, proxyHost))
		proxyPort = Trim(InputBox("Enter proxy port number", vername, proxyPort))
		proxyUser = Trim(InputBox("Enter proxy username", vername))
		proxyPass = Trim(InputBox("Enter proxy password", vername))
		If Len(proxyHost)+Len(proxyPort)+Len(proxyUser)+Len(proxyPass)>0 Then
			javaArgs = javaArgs & " -DproxySet=true"
		End If
		If Len(proxyHost)>0 Then
			javaArgs = javaArgs & " -Dhttp.proxyHost=" & proxyHost
		End If
		If Len(proxyPort)>0 Then
			javaArgs = javaArgs & " -Dhttp.proxyPort=" & proxyPort
		End If
		If Len(proxyUser)>0 Then
			javaArgs = javaArgs & " -Dhttp.proxyUser=" & proxyUser
		End If
		If Len(proxyPass)>0 Then
			javaArgs = javaArgs & " -Dhttp.proxyPassword=" & proxyPass
		End If
	End If
End If

javaArgs = javaArgs & " -jar """ & targetDir & "\uppaal.jar"""

' finished with Java arguments, start with Uppaal arguments:
uppaalArgs = ""

' add links:
programs = WshShell.SpecialFolders("Programs")
Call createLink (programs, vername, javaArgs & uppaalArgs)
msg = "A link to UPPAAL has been added in Programs."

q = "Create the same link on Desktop?"
If WshShell.Popup(q,0,vername,4+32+4096+65536) = vbYes Then
	desktop = WshShell.SpecialFolders("Desktop")
	Call createLink (desktop, vername, javaArgs & uppaalArgs)
	msg = "Links to UPPAAL have been added in Programs and Desktop."
End If

msg = msg & vbCr & vbCr & "Enjoy!"& vbCr & vbCr & "UPPAAL Team"
WshShell.Popup msg,15,vername,64+4096+65536+524288
