#define   Name       "Ëåòíÿÿ ïðàêòèêà"
#define   Version    "0.0.1"
#define   ExeName    "Practice.exe"
[Setup]

AppId={{8270B570-5D4D-40A2-BA29-B4107ED3997A}
AppName={#Name}
AppVersion={#Version}
; Ïóòü óñòàíîâêè ïî-óìîë÷àíèþ
DefaultDirName={commonpf}\{#Name}
; Èìÿ ãðóïïû â ìåíþ "Ïóñê"
DefaultGroupName={#Name}

; Êàòàëîã, êóäà áóäåò çàïèñàí ñîáðàííûé setup è èìÿ èñïîëíÿåìîãî ôàéëà
OutputDir=D:\NDT
OutputBaseFileName=test-setup

SetupIconFile=C:\Users\Home\Desktop\ããã\Algos5\Practice\Practice\2240293.ico

; Ïàðàìåòðû ñæàòèÿ
Compression=lzma
SolidCompression=yes
[Languages]
Name: "russian"; MessagesFile: "D:\Inno Setup 6\Languages\Russian.isl"
Name: "english"; MessagesFile: "D:\Inno Setup 6\Languages\English.isl"
;------------------------------------------------------------------------------
;   Îïöèîíàëüíî - íåêîòîðûå çàäà÷è, êîòîðûå íàäî âûïîëíèòü ïðè óñòàíîâêå
;------------------------------------------------------------------------------
[Tasks]
; Ñîçäàíèå èêîíêè íà ðàáî÷åì ñòîëå
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
;------------------------------------------------------------------------------
;   Ôàéëû, êîòîðûå íàäî âêëþ÷èòü â ïàêåò óñòàíîâùèêà
;------------------------------------------------------------------------------
[Files]

; Èñïîëíÿåìûé ôàéë
Source: "C:\Users\Home\Desktop\ããã\Algos5\Practice\Practice\bin\Debug\Practice.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Microsoft Visual Studio\2022\Community\dotnet\runtime\dotnet.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall; Check: not IsRequiredDotNetDetected
;------------------------------------------------------------------------------
;   Óêàçûâàåì óñòàíîâùèêó, ãäå îí äîëæåí âçÿòü èêîíêè
;------------------------------------------------------------------------------ 
[Icons]

Name: "{group}\{#Name}"; Filename: "{app}\{#ExeName}"

Name: "{commondesktop}\{#Name}"; Filename: "{app}\{#ExeName}"; Tasks: desktopicon
[Code]
//-----------------------------------------------------------------------------
//  Ïðîâåðêà íàëè÷èÿ íóæíîãî ôðåéìâîðêà
//-----------------------------------------------------------------------------
function IsDotNetDetected(version: string; release: cardinal): boolean;

var 
    reg_key: string; // Ïðîñìàòðèâàåìûé ïîäðàçäåë ñèñòåìíîãî ðååñòðà
    success: boolean; // Ôëàã íàëè÷èÿ çàïðàøèâàåìîé âåðñèè .NET
    release45: cardinal; // Íîìåð ðåëèçà äëÿ âåðñèè 4.5.x
    key_value: cardinal; // Ïðî÷èòàííîå èç ðååñòðà çíà÷åíèå êëþ÷à
    sub_key: string;

begin

    success := false;
    reg_key := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\';
    
    // Âðåñèÿ 3.0
    if Pos('v3.0', version) = 1 then
      begin
          sub_key := 'v3.0';
          reg_key := reg_key + sub_key;
          success := RegQueryDWordValue(HKLM, reg_key, 'InstallSuccess', key_value);
          success := success and (key_value = 1);
      end;

    // Âðåñèÿ 3.5
    if Pos('v3.5', version) = 1 then
      begin
          sub_key := 'v3.5';
          reg_key := reg_key + sub_key;
          success := RegQueryDWordValue(HKLM, reg_key, 'Install', key_value);
          success := success and (key_value = 1);
      end;

     // Âðåñèÿ 4.0 êëèåíòñêèé ïðîôèëü
     if Pos('v4.0 Client Profile', version) = 1 then
      begin
          sub_key := 'v4\Client';
          reg_key := reg_key + sub_key;
          success := RegQueryDWordValue(HKLM, reg_key, 'Install', key_value);
          success := success and (key_value = 1);
      end;

     // Âðåñèÿ 4.0 ðàñøèðåííûé ïðîôèëü
     if Pos('v4.0 Full Profile', version) = 1 then
      begin
          sub_key := 'v4\Full';
          reg_key := reg_key + sub_key;
          success := RegQueryDWordValue(HKLM, reg_key, 'Install', key_value);
          success := success and (key_value = 1);
      end;

     // Âðåñèÿ 4.5
     if Pos('v4.5', version) = 1 then
      begin
          sub_key := 'v4\Full';
          reg_key := reg_key + sub_key;
          success := RegQueryDWordValue(HKLM, reg_key, 'Release', release45);
          success := success and (release45 >= release);
      end;
        
    result := success;

end;
//-----------------------------------------------------------------------------
//  Ôóíêöèÿ-îáåðòêà äëÿ äåòåêòèðîâàíèÿ êîíêðåòíîé íóæíîé íàì âåðñèè
//-----------------------------------------------------------------------------
function IsRequiredDotNetDetected(): boolean;
begin
    result := IsDotNetDetected('v4.0 Full Profile', 0);
end;
//-----------------------------------------------------------------------------
//    Callback-ôóíêöèÿ, âûçûâàåìàÿ ïðè èíèöèàëèçàöèè óñòàíîâêè
//-----------------------------------------------------------------------------
function InitializeSetup(): boolean;
begin

  // Åñëè íåò òåðáóåìîé âåðñèè .NET âûâîäèì ñîîáùåíèå î òîì, ÷òî èíñòàëëÿòîð
  // ïîïûòàåòñÿ óñòàíîâèòü å¸ íà äàííûé êîìïüþòåð
  if not IsDotNetDetected('v4.0 Full Profile', 0) then
    begin
      MsgBox('{#Name} requires Microsoft .NET Framework 4.0 Full Profile.'#13#13
             'The installer will attempt to install it', mbInformation, MB_OK);
    end;   

  result := true;
end;

[Run]
;------------------------------------------------------------------------------
;   Ñåêöèÿ çàïóñêà ïîñëå èíñòàëëÿöèè
;------------------------------------------------------------------------------
Filename: {tmp}\dotNetFx40_Full_x86_x64.exe; Parameters: "/q:a /c:""install /l /q"""; Check: not IsRequiredDotNetDetected; StatusMsg: Microsoft Framework 4.0 is installed. Please wait...
