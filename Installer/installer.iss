#define   Name       "Летняя практика"
#define   Version    "0.0.1"
#define   ExeName    "Practice.exe"
[Setup]

AppId={{8270B570-5D4D-40A2-BA29-B4107ED3997A}
AppName={#Name}
AppVersion={#Version}
; Путь установки по-умолчанию
DefaultDirName={commonpf}\{#Name}
; Имя группы в меню "Пуск"
DefaultGroupName={#Name}

; Каталог, куда будет записан собранный setup и имя исполняемого файла
OutputDir=D:\NDT
OutputBaseFileName=test-setup

SetupIconFile=C:\Users\Home\Desktop\ггг\Algos5\Practice\Practice\2240293.ico

; Параметры сжатия
Compression=lzma
SolidCompression=yes
[Languages]
Name: "russian"; MessagesFile: "D:\Inno Setup 6\Languages\Russian.isl"
;------------------------------------------------------------------------------
;   Опционально - некоторые задачи, которые надо выполнить при установке
;------------------------------------------------------------------------------
[Tasks]
; Создание иконки на рабочем столе
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
;------------------------------------------------------------------------------
;   Файлы, которые надо включить в пакет установщика
;------------------------------------------------------------------------------
[Files]

; Исполняемый файл
Source: "C:\Users\Home\Desktop\ггг\Algos5\Practice\Practice\bin\Debug\Practice.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Microsoft Visual Studio\2022\Community\dotnet\runtime\dotnet.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall; Check: not IsRequiredDotNetDetected
;------------------------------------------------------------------------------
;   Указываем установщику, где он должен взять иконки
;------------------------------------------------------------------------------ 
[Icons]

Name: "{group}\{#Name}"; Filename: "{app}\{#ExeName}"

Name: "{commondesktop}\{#Name}"; Filename: "{app}\{#ExeName}"; Tasks: desktopicon
[Code]
//-----------------------------------------------------------------------------
//  Проверка наличия нужного фреймворка
//-----------------------------------------------------------------------------
function IsDotNetDetected(version: string; release: cardinal): boolean;

var 
    reg_key: string; // Просматриваемый подраздел системного реестра
    success: boolean; // Флаг наличия запрашиваемой версии .NET
    release45: cardinal; // Номер релиза для версии 4.5.x
    key_value: cardinal; // Прочитанное из реестра значение ключа
    sub_key: string;

begin

    success := false;
    reg_key := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\';
    
    // Вресия 3.0
    if Pos('v3.0', version) = 1 then
      begin
          sub_key := 'v3.0';
          reg_key := reg_key + sub_key;
          success := RegQueryDWordValue(HKLM, reg_key, 'InstallSuccess', key_value);
          success := success and (key_value = 1);
      end;

    // Вресия 3.5
    if Pos('v3.5', version) = 1 then
      begin
          sub_key := 'v3.5';
          reg_key := reg_key + sub_key;
          success := RegQueryDWordValue(HKLM, reg_key, 'Install', key_value);
          success := success and (key_value = 1);
      end;

     // Вресия 4.0 клиентский профиль
     if Pos('v4.0 Client Profile', version) = 1 then
      begin
          sub_key := 'v4\Client';
          reg_key := reg_key + sub_key;
          success := RegQueryDWordValue(HKLM, reg_key, 'Install', key_value);
          success := success and (key_value = 1);
      end;

     // Вресия 4.0 расширенный профиль
     if Pos('v4.0 Full Profile', version) = 1 then
      begin
          sub_key := 'v4\Full';
          reg_key := reg_key + sub_key;
          success := RegQueryDWordValue(HKLM, reg_key, 'Install', key_value);
          success := success and (key_value = 1);
      end;

     // Вресия 4.5
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
//  Функция-обертка для детектирования конкретной нужной нам версии
//-----------------------------------------------------------------------------
function IsRequiredDotNetDetected(): boolean;
begin
    result := IsDotNetDetected('v4.0 Full Profile', 0);
end;
//-----------------------------------------------------------------------------
//    Callback-функция, вызываемая при инициализации установки
//-----------------------------------------------------------------------------
function InitializeSetup(): boolean;
begin

  // Если нет тербуемой версии .NET выводим сообщение о том, что инсталлятор
  // попытается установить её на данный компьютер
  if not IsDotNetDetected('v4.0 Full Profile', 0) then
    begin
      MsgBox('{#Name} requires Microsoft .NET Framework 4.0 Full Profile.'#13#13
             'The installer will attempt to install it', mbInformation, MB_OK);
    end;   

  result := true;
end;

[Run]
;------------------------------------------------------------------------------
;   Секция запуска после инсталляции
;------------------------------------------------------------------------------
Filename: {tmp}\dotNetFx40_Full_x86_x64.exe; Parameters: "/q:a /c:""install /l /q"""; Check: not IsRequiredDotNetDetected; StatusMsg: Microsoft Framework 4.0 is installed. Please wait...
