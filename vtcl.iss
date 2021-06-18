[Setup]
AppName=Visual Tcl
AppVerName=Visual Tcl 1.6.2
AppPublisher=http://vtcl.org
AppPublisherURL=http://vtcl.org
AppSupportURL=http://vtcl.org
AppUpdatesURL=http://vtcl.org
DefaultDirName={pf}\vtcl
DefaultGroupName=Visual Tcl
AllowNoIcons=yes
OutputDir=D:\
OutputBaseFilename=VisualTclSetup
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Languages\English.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "D:\vtcl\vtcl.tcl"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\vtcl\demo\*"; DestDir: "{app}\demo"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "D:\vtcl\doc\*"; DestDir: "{app}\doc"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "D:\vtcl\freewrap\*"; DestDir: "{app}\freewrap"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "D:\vtcl\images\*"; DestDir: "{app}\images"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "D:\vtcl\lib\*"; DestDir: "{app}\lib"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "D:\vtcl\sample\*"; DestDir: "{app}\sample"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "D:\vtcl\ChangeLog"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\vtcl\configure"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\vtcl\LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\vtcl\README"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\vtcl\vtcl.iss"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\vtcl\vtcl.tcl"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\vtcl\vtclmac"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\Visual Tcl"; Filename: "{app}\vtcl.tcl"
Name: "{group}\{cm:UninstallProgram,Visual Tcl}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\Visual Tcl"; Filename: "{app}\vtcl.tcl"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\Visual Tcl"; Filename: "{app}\vtcl.tcl"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\vtcl.tcl"; Description: "{cm:LaunchProgram,Visual Tcl}"; Flags: shellexec postinstall skipifsilent

