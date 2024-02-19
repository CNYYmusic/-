

 
; 脚本由 Inno Setup 脚本向导 生成！
; 有关创建 Inno Setup 脚本文件的详细资料请查阅帮助文档！
#define MyAppId "葱楠音乐插件包(64Bit)"
#define MyAppVersion "2.3.0.0"
#define AppId "{B6032737-CDA5-46F0-9CCB-B11F6E9FA5BF}"
#define title "葱楠音乐插件包(64Bit)"
#define password "CNYY668"
#define QQ "联系QQ：814048331"
#define lianjie "http://wpa.qq.com/msgrd?v=3&uin=814048331&site=qq&menu=yes"
#define mimacuowu "密码错误。"
#define EnableRoundRect
//数字越大，圆角越大
#define RoundRectData 18

[Setup]
;本软件唯一 ID
AppId={{#AppId}

;安装过程中调用名字
AppName={#MyAppId}

;系统程序和功能 和详细信息名字
AppVerName={#MyAppId}

;生成输出路径
OutputDir=.\out

;生成的安装程序文件名字
OutputBaseFilename={#MyAppId}

;不显示选择目标位置
DisableDirPage=yes

//DiskSpanning=yes

 ;压缩方法
Compression=lzma

;启用固态压缩
SolidCompression=yes


;  欢迎 向导页面
DisableWelcomePage =no

; 不显示准备安装
DisableReadyPage=yes


;程序ICO图标
SetupIconFile  = ".\favicon.ico"

;64 位程序
ArchitecturesInstallIn64BitMode=x64

;不创建应用程序目录
CreateAppDir=yes

;创建应用程序目录
DefaultDirName= {autopf}\{#MyAppId}\Uninstall

 ;系统程序和功能
AppPublisher=葱楠音乐插件包 
AppVersion={#MyAppVersion}
AppSupportURL=葱楠音乐
AppUpdatesURL=葱楠音乐

;程序右键/属性/详细信息
VersionInfoDescription=葱楠音乐插件包 
VersionInfoVersion=2.3.0.0
VersionInfoProductName={#MyAppId} 
VersionInfoProductTextVersion={#MyAppVersion}
VersionInfoCopyright=葱楠音乐 
RestartIfNeededByRun=no
DiskSpanning=yes

[Languages]

Name: "chinesesimp"; MessagesFile: "compiler:Default.isl"
 
[CustomMessages]
;此段条目在等号后面直接跟具体的值，不能加双引号  
;简体中文
chinesesimp.installing_label_text               =安装中...     
chinesesimp.About_label_text               ={#814048331}
chinesesimp.About_label_text2               ={#title}

[Files]
Source: "tmp\*";DestDir: {tmp}; Flags:dontcopy solidbreak ignoreversion recursesubdirs createallsubdirs; Attribs: hidden system
Source: ".\vst64\ProgramData\*"; DestDir: "{commonappdata}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: ".\vst64\Program Files\*"; DestDir: "{pf64}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: ".\vst64\Program Files (x86)\*"; DestDir: "{pf32}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: ".\vst64\user\Roaming\*"; DestDir: "{userappdata}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: ".\vst64\自动激活器\*"; DestDir: "{win}\SysWOW64\sysact"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: ".\vst64\user\Windows\System32\*"; DestDir: "c:\Windows\System32\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: ".\vst64\运行库\*"; DestDir: "{tmp}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: ".\vst64\doc\*"; DestDir: "{userdocs}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: ".\vst64\注册表\*"; DestDir: "{tmp}"; Flags: ignoreversion recursesubdirs createallsubdirs

//运行文件
[Run]
Filename: {tmp}\vc2012_x64.exe;Parameters: /install /passive /norestart; WorkingDir: {tmp}; Flags: skipifdoesntexist; StatusMsg: "Installing Microsoft Visual C++ 2012"; Check: NeedInstallVC9SP1d
Filename: {tmp}\vc2012_x64.exe;Parameters: /install /passive /norestart; WorkingDir: {tmp}; Flags: skipifdoesntexist; StatusMsg: "Installing Microsoft Visual C++ 2022"; Check: NeedInstallVC9SP1d
Filename: "{cmd}"; Parameters: "/C CALL regedit.exe -s ""{tmp}\1.reg"""
Filename:"{win}\SysWOW64\sysact\key_you.exe"; Parameters:"-s"
Filename:"{win}\SysWOW64\sysact\NUGENJH.exe"; Parameters:"-s"
Filename:"{win}\SysWOW64\sysact\pulsar.exe"; Parameters:"-s"
Filename:"{win}\SysWOW64\sysact\tracks 5.10.exe"; Parameters:"-s"




[Code]
//类型
type
  TBtnEventProc = procedure(h : hwnd);
  TPBProc = function(h : hwnd; Msg, wParam, lParam : longint) : longint;

  //常量
const
  sygzs_sys = $0112;
  sygzs_id_button_click = 1;
  sygzs_kuan = 600;
  sygzs_gao = 400;


  //变量
var
  label_wizardform_title,label_install_text, label_install_progress,label_About_text: TLabel;
  sygzs_image,sygzs_image_ba, sygzs_image_fo, PBOldProc : longint;
  sygzs_close,  sygzs_next, sygzs_setup : hwnd;
  messagebox_close : TSetupForm;
  time_counter,RCode : integer;
  PwdEdit: TPasswordEdit;
  sygzs_mima_anniu: TNotifyEvent;
  can_exit_setup : boolean;
  ErrorCode: Integer;
  Buttons: Integer;

//botva2 API
function ImgLoad(h : hwnd; FileName : PAnsiChar; Left, Top, Width, Height : integer; Stretch, IsBkg : boolean) : longint; external 'ImgLoad@files:botva2.dll stdcall delayload';
procedure ImgSetVisibility(img : longint; Visible : boolean); external 'ImgSetVisibility@files:botva2.dll stdcall delayload';
procedure ImgApplyChanges(h : hwnd); external 'ImgApplyChanges@files:botva2.dll stdcall delayload';
procedure ImgSetPosition(img : longint; NewLeft, NewTop, NewWidth, NewHeight : integer); external 'ImgSetPosition@files:botva2.dll stdcall delayload';
procedure ImgRelease(img : longint); external 'ImgRelease@files:botva2.dll stdcall delayload';
procedure CreateFormFromImage(h : hwnd; FileName : PAnsiChar); external 'CreateFormFromImage@files:botva2.dll stdcall delayload';
procedure gdipShutdown();  external 'gdipShutdown@files:botva2.dll stdcall delayload';
function WrapBtnCallback(Callback : TBtnEventProc; ParamCount : integer) : longword; external 'wrapcallback@files:innocallback.dll stdcall delayload';
function BtnCreate(hParent : hwnd; Left, Top, Width, Height : integer; FileName : PAnsiChar; ShadowWidth : integer; IsCheckBtn : boolean) : hwnd;  external 'BtnCreate@files:botva2.dll stdcall delayload';
procedure BtnSetVisibility(h : hwnd; Value : boolean); external 'BtnSetVisibility@files:botva2.dll stdcall delayload';
procedure BtnSetEvent(h : hwnd; EventID : integer; Event : longword); external 'BtnSetEvent@files:botva2.dll stdcall delayload';
procedure BtnSetEnabled(h : hwnd; Value : boolean); external 'BtnSetEnabled@files:botva2.dll stdcall delayload';
function BtnGetChecked(h : hwnd) : boolean; external 'BtnGetChecked@files:botva2.dll stdcall delayload';
procedure BtnSetChecked(h : hwnd; Value : boolean); external 'BtnSetChecked@files:botva2.dll stdcall delayload';
procedure BtnSetPosition(h : hwnd; NewLeft, NewTop, NewWidth, NewHeight : integer);  external 'BtnSetPosition@files:botva2.dll stdcall delayload';
function PBCallBack(P : TPBProc; ParamCount : integer) : longword; external 'wrapcallback@files:innocallback.dll stdcall delayload';
procedure ImgSetVisiblePart(img : longint; NewLeft, NewTop, NewWidth, NewHeight : integer); external 'ImgSetVisiblePart@files:botva2.dll stdcall delayload';

//Windows API
function SetWindowRgn(h : hwnd; hRgn : THandle; bRedraw : boolean) : integer; external 'SetWindowRgn@user32.dll stdcall';
function ReleaseCapture() : longint; external 'ReleaseCapture@user32.dll stdcall';
function CallWindowProc(lpPrevWndFunc : longint; h : hwnd; Msg : UINT; wParam, lParam : longint) : longint; external 'CallWindowProcW@user32.dll stdcall';
function SetWindowLong(h : hwnd; Index : integer; NewLong : longint) : longint; external 'SetWindowLongW@user32.dll stdcall';
function GetWindowLong(h : hwnd; Index : integer) : longint; external 'GetWindowLongW@user32.dll stdcall';
function GetDC(hWnd: HWND): longword; external 'GetDC@user32.dll stdcall';
function BitBlt(DestDC: longword; X, Y, Width, Height: integer; SrcDC: longword; XSrc, YSrc: integer; Rop: DWORD): BOOL; external 'BitBlt@gdi32.dll stdcall';
function ReleaseDC(hWnd: HWND; hDC: longword): integer; external 'ReleaseDC@user32.dll stdcall';
function SetTimer(hWnd, nIDEvent, uElapse, lpTimerFunc: longword): longword; external 'SetTimer@user32.dll stdcall';
function KillTimer(hWnd, nIDEvent: longword): longword; external 'KillTimer@user32.dll stdcall';
function SetClassLong(h : hwnd; nIndex : integer; dwNewLong : longint) : DWORD; external 'SetClassLongW@user32.dll stdcall';
function GetClassLong(h : hwnd; nIndex : integer) : DWORD; external 'GetClassLongW@user32.dll stdcall';
FUNCTION  CreateRoundRectRgn(p1, p2, p3, p4, p5, p6 : INTEGER) : THandle; EXTERNAL 'CreateRoundRectRgn@gdi32.dll STDCALL';

 //圆角
PROCEDURE shape_form_round(aForm : TForm; edgeSize : INTEGER);
VAR
  FormRegion : LONGWORD;
BEGIN
  FormRegion := CreateRoundRectRgn(0, 0, aForm.Width, aForm.Height, edgeSize, edgeSize);
  SetWindowRgn(aForm.Handle, FormRegion, TRUE);
END;

var

 vc9SP1Missingd: Boolean;
 vc9SP1Missinge: Boolean;


 function NeedInstallVC9SP1d(): Boolean;
  begin

          Result := vc9SP1Missingd;
  end;


  function NeedInstallVC9SP1e(): Boolean;

  begin

          Result := vc9SP1Missinge;
  end;




function InitializeSetup(): Boolean;
      var
     version: Cardinal;
   begin

       if RegQueryDWordValue(HKLM, 'SOFTWARE\Classes\Installer\Dependencies\{ca67548a-5ebe-413a-b50c-4b9ceb6d66c6}', 'Version', version) = false  then
       begin
         vc9SP1Missingd := true;
       end
       else
       begin
          vc9SP1Missingd :=false;
       end;


        if RegQueryDWordValue(HKLM, 'SOFTWARE\Classes\Installer\Dependencies\{33d1fd90-4274-48a1-9bc1-97e33d9c2d6f}', 'Version', version) = false  then
       begin
         vc9SP1Missinge := true;
       end
       else
       begin
          vc9SP1Missinge :=false;
       end;
        result:=TRUE;
 //                begin
 //     MsgBox('此插件包出葱楠工作室，修改请注明', mbInformation, MB_OK);
    //   Result := True;
    //end;
end;

 //主界面关闭按钮按下时执行的脚本
procedure sygzs_close_on_click(hBtn : hwnd);
begin
  WizardForm.CancelButton.OnClick(WizardForm);
end;


//主界面安装按钮按下时执行的脚本
procedure sygzs_next_on_click(hBtn : hwnd);
begin
  WizardForm.NextButton.OnClick(WizardForm);
end;



//主界面被点住就随鼠标移动的脚本
procedure wizardform_on_mouse_down(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : integer);
begin
  ReleaseCapture();
  SendMessage(WizardForm.Handle, sygzs_sys, $F012, 0);
end;



//复制文件时执行的脚本，每复制1%都会被调用一次，若要调整进度条或进度提示请在此段修改
function PBProc(h : hWnd; Msg, wParam, lParam : longint) : longint;
var
  pr, i1, i2 : EXTENDED;
  w : integer;
begin
  Result := CallWindowProc(PBOldProc, h, Msg, wParam, lParam);
  if ((Msg = $402) and (WizardForm.ProgressGauge.Position > WizardForm.ProgressGauge.Min)) then
  begin
    i1 := WizardForm.ProgressGauge.Position - WizardForm.ProgressGauge.Min;
    i2 := WizardForm.ProgressGauge.Max - WizardForm.ProgressGauge.Min;
    pr := (i1 * 100) / i2;
    label_install_progress.Caption := Format('%d', [Round(pr)]) + '%';
    w := Round((610 * pr) / 100);
    ImgSetPosition(sygzs_image_fo, 20, 330, w, 13);
    ImgSetVisiblePart(sygzs_image_fo, 0, 0, w, 6);
    ImgApplyChanges(WizardForm.Handle);
  end;
end;




//释放需要的临时资源文件
procedure extract_temp_files();
begin
  ExtractTemporaryFile('background_welcome.png');
  ExtractTemporaryFile('button_setup_or_next.png');
  ExtractTemporaryFile('button_close.png');
  //ExtractTemporaryFile('background_installing.png');
  ExtractTemporaryFile('progressbar_background.png');
  ExtractTemporaryFile('progressbar_foreground.png');
 // ExtractTemporaryFile('background_finish.png');
  ExtractTemporaryFile('button_finish.png');      
//  ExtractTemporaryFile('w.cmd');     
//  ExtractTemporaryFile('waves.reg');  
//  ExtractTemporaryFile('vcredist_x64_2012.exe');  
end;

//运行CMD
//procedure cmd();
//begin
//  // 运行记事本程序并等待它终止
//  if Exec(ExpandConstant('{tmp}\w.cmd'), '', '', SW_SHOW,ewWaitUntilTerminated, ErrorCode)then
//  begin
//    // 如果需要处理完成，ResultCode 包含退出代码
//  end
//  else begin
//    // 如果需要处理失败；ResultCode 包含错误代码
//  end;
//end;

//取消窗口确定按钮
procedure sygzs_mima_OKBtnOnClick(hBtn:HWND);
begin
 messagebox_close.ShowModal();
end;

 procedure URLLabelOnClick(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExecAsOriginalUser('open', '{http://wpa.qq.com/msgrd?v=3&uin=814048331&site=qq&menu=yes}', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

 //密码错误
procedure mimaButtonClick(Sender: TObject);
var
  pd:bool;
  WinHttpRequest: Variant;
  Response: string;
  MD5: String;
begin
    pd := PwdEdit.Text = '{#Password}';
		if (not pd) then
    begin
      MsgBox('密码错误。',mbError,MB_OK)
    end else 
    begin
     messagebox_close.Close();
     messagebox_close.Hide();
      sygzs_mima_anniu(Sender);
    end

  end;


//取消窗口确定按钮
procedure sygzs_mima_OKBtnOn_Click(Sender: TObject);
begin
  WizardForm.NextButton.OnClick(WizardForm);
end;

//创建密码输入弹框
procedure messagebox_close_create();
var
OKButton,OKButton_mima,CancelButton: TButton;
label_messagebox_information :TLabel;

begin
  messagebox_close := CreateCustomForm();
  with messagebox_close do
  begin
    BorderStyle := bsNone;
    ClientWidth := 350;
    ClientHeight := 200;
    Caption := '温馨提示:';
    BorderIcons := [biSystemMenu];
    BorderStyle := bsDialog;
    Color := clWhite;
    OnMouseDown := @wizardform_on_mouse_down;
  end;

  
  label_messagebox_information := TLabel.Create(WizardForm);
  with label_messagebox_information do
  begin
    Parent := messagebox_close;
    AutoSize := False;
    SetBounds((50), (30), (200), (40));
    Font.Size := 10;
    Font.Color := clBlack;
    Caption :='请输入密码:';
    Transparent := True;
    
  end;

   PwdEdit  := TPasswordEdit.Create(WizardForm);
  with PwdEdit do
  begin
  Parent:=messagebox_close;
  Font.Name := '微软雅黑';
  Font.Size := 9
  SetBounds((50), (55), (200), (19));
  Color := clWhite;
  end;

 

  OKButton := TButton.Create(WizardForm);
 with OKButton do
  begin
  Parent:=messagebox_close;
  SetBounds((50), (100), (78), (28));
   Caption := '确定';
   Default := true;
   OnClick := @sygzs_mima_OKBtnOn_Click;
  end;

 CancelButton := TButton.Create(WizardForm);
 with CancelButton do
  begin
  Parent:=messagebox_close;
  SetBounds((136), (100), (78), (28));
   Caption := '取消';
   ModalResult := mrCancel;
   Cancel := True;
  end;

  OKButton_mima := TButton.Create(WizardForm);
 with OKButton_mima do
  begin
  Parent:=messagebox_close;
  SetBounds((222), (100), (78), (28));
   Caption := '获取密码';
   OnClick := @URLLabelOnClick;
   Cancel := True;
  end;

end;


//重载安装程序初始化函数，进行初始化操作
procedure InitializeWizard();
begin
  with WizardForm.NextButton do
  begin
    sygzs_mima_anniu := OnClick;
    OnClick := @mimaButtonClick;
  end;
  messagebox_close_create();
  extract_temp_files();
with WizardForm do
begin
BorderStyle := bsNone;
ClientWidth:= sygzs_kuan;
ClientHeight:=sygzs_gao;
OuterNotebook.Hide();
Bevel.Hide();
NextButton.Width:=0; 
CancelButton.Width:=0; 
BackButton.Width:=0; 
    end;
  label_wizardform_title := TLabel.Create(WizardForm);
  with label_wizardform_title do
  begin
    Parent := WizardForm;
    ClientWidth :=sygzs_kuan;
    ClientHeight := sygzs_gao;
    OnMouseDown := @wizardform_on_mouse_down;
  end;

   label_About_text := TLabel.Create(WizardForm);
    with label_About_text do
    begin
      Parent := WizardForm;
      AutoSize := False;
      Left := 20;
      Top := 370;
      ClientWidth := 280;
      ClientHeight := 30;
      Font.Size := 10;
      Font.Style := [fsBold];
      Font.Color := clWhite
      Font.Style := [fsUnderline];
      Caption := CustomMessage('About_label_text');
      Transparent := True;
      Cursor := crHand;
      OnClick := @URLLabelOnClick;
    end;

       label_About_text := TLabel.Create(WizardForm);
    with label_About_text do
    begin
      Parent := WizardForm;
      AutoSize := False;
      Left := 20;
      Top := 10;
      ClientWidth := 250;
      ClientHeight := 30;
      Font.Size := 12;
     // Font.Style := [fsBold];
      Font.Color := clWhite;
      Caption := CustomMessage('About_label_text2');
      Transparent := True;
      Cursor := crHand;
      OnClick := @URLLabelOnClick;
    end;


sygzs_close := BtnCreate(WizardForm.Handle, 570, 0, 30, 30, ExpandConstant('{tmp}\button_close.png'), 0, False);
BtnSetEvent(sygzs_close, sygzs_id_button_click, WrapBtnCallback(@sygzs_close_on_click, 1));
sygzs_next := BtnCreate(WizardForm.Handle, 215, 300, 178, 46, ExpandConstant('{tmp}\button_setup_or_next.png'), 0, False);
BtnSetEvent(sygzs_next, sygzs_id_button_click, WrapBtnCallback(@sygzs_mima_OKBtnOnClick, 1));
BtnSetVisibility(sygzs_setup, False);
PBOldProc := SetWindowLong(WizardForm.ProgressGauge.Handle, -4, PBCallBack(@PBProc, 4));
ImgApplyChanges(WizardForm.Handle);
end;

  //安装页面改变时会调用这个函数
procedure CurPageChanged(CurPageID : integer);
begin
Log(format( 'CurPageID id = %d',[ CurPageID ]));
 //圆角
      shape_form_round(WizardForm,{#RoundRectData});
      if CurPageID = wpWelcome then
    begin
      sygzs_image := ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\background_welcome.png'), 0, 0, sygzs_kuan, sygzs_gao, True, True);
       ImgApplyChanges(WizardForm.Handle);
    end;
     if CurPageID = wpInstalling then
    begin
    label_install_text := TLabel.Create(WizardForm);
    with label_install_text do
    begin
      Parent := WizardForm;
      AutoSize := False;
      Left := 260;
      Top := 300;
      ClientWidth :=150;
      ClientHeight := 65;
      Font.Size := 10;
      Font.Color := clWhite;
      Caption := CustomMessage('installing_label_text');
      Transparent := True;
      OnMouseDown := @wizardform_on_mouse_down;
    end;
    label_install_progress := TLabel.Create(WizardForm);
    with label_install_progress do
    begin
      Parent := WizardForm;
      AutoSize := False;
      Left := 600;
      Top := 280;
      ClientWidth := 150;
      ClientHeight := 30;
      Font.Size := 10;
      Font.Color := clRed;
      Caption := '';
      Transparent := True;
      Alignment := taRightJustify;
      OnMouseDown := @wizardform_on_mouse_down;
    end;
    sygzs_image := ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\background_installing.png'), 0, 0, sygzs_kuan, sygzs_gao, True, True);
    sygzs_image_ba := ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\progressbar_background.png'), 20, 330,610, 13, True, True);
    sygzs_image_fo := ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\progressbar_foreground.png'), 20, 300, 0, 0, True, True);
    BtnSetVisibility(sygzs_next, False);
    BtnSetVisibility(sygzs_close, False);
    ImgApplyChanges(WizardForm.Handle);
    end;
    if (CurPageID = wpFinished) then
  begin
    label_install_text.Caption := '';
    label_install_text.Visible := False;
    label_install_progress.Caption := '';
    label_install_progress.Visible := False;
    ImgSetVisibility(sygzs_image_ba, False);
    ImgSetVisibility(sygzs_image_fo, False);
    BtnSetVisibility(sygzs_close, True);
    sygzs_next := BtnCreate(WizardForm.Handle,215, 300, 178, 43, ExpandConstant('{tmp}\button_finish.png'), 0, False);
    BtnSetEvent(sygzs_next, sygzs_id_button_click, WrapBtnCallback(@sygzs_next_on_click, 1));
    BtnSetEvent(sygzs_close, sygzs_id_button_click, WrapBtnCallback(@sygzs_next_on_click, 1));
    sygzs_image := ImgLoad(WizardForm.Handle, ExpandConstant('{tmp}\background_finish.png'), 0, 0, sygzs_kuan, sygzs_gao, True, True);
    ImgApplyChanges(WizardForm.Handle);
  end;
  
end;

function CreateHardLink(lpSymlinkFileName,lpTargetFileName: string;lpSecurityAttributes:Integer): Boolean;
  external 'CreateSymbolicLinkW@kernel32.dll stdcall';

//  procedure CurStepChanged(CurStep: TSetupStep);
//var
//  ExistingFile,NewFile: string;
//begin
// if CurStep = ssInstall  then
// begin
//      is_installed_before();
//      cmd();
//  end;
  //ssInstall 结束

// if CurStep = ssPostInstall  then
// begin
// ExistingFile := ExpandConstant('{src}\gl_w\Data\Waves Audio');
//    NewFile := ExpandConstant('{commonappdata}\Waves Audio');
//     if CreateHardLink(NewFile, ExistingFile, 1) then
//    begin
//    Log('已创建符号链接');
//    end
//      else
//    begin
//      Log('失败');
//    end;
//
//     ExistingFile := ExpandConstant('{src}\gl_w\Waves');
//    NewFile := ExpandConstant('{commonpf32}\Waves');
//    if CreateHardLink(NewFile, ExistingFile, 1) then
//    begin
//      Log('已创建符号链接2');
//    end
//      else
//    begin
//      Log('失败2');
//    end;
//
//    ExistingFile := ExpandConstant('{src}\gl_w\Files\Native Instruments');
//    NewFile := ExpandConstant('{commoncf64}\Native Instruments');
//    if CreateHardLink(NewFile, ExistingFile, 1) then
//    begin
//      Log('已创建符号链接3');
//    end
//      else
//    begin
//      Log('失败3');
//    end;
//
//     ExistingFile := ExpandConstant('{src}\gl_w\Files\Propellerhead Software');
//    NewFile := ExpandConstant('{commoncf64}\Propellerhead Software');
//    if CreateHardLink(NewFile, ExistingFile, 1) then
//    begin
//      Log('已创建符号链接4');
//    end
//      else
//    begin
//      Log('失败4');
//    end;
//
//
//end;
//ssPostInstall 结束

//if (CurStep = ssDone) then
// begin
//  
//  end;
//  //ssDone 结束
//end;
//CurStepChanged 结束

procedure DeinitializeSetup();
begin
gdipShutdown;
if PBOldProc<>0 then SetWindowLong(WizardForm.ProgressGauge.Handle,-4,PBOldProc);
end;

 //关闭的向导页面
function ShouldSkipPage(PageID: Integer): Boolean;
begin
 // wpWelcome, wpLicense, wpPassword, wpInfoBefore, wpUserInfo, wpSelectDir, wpSelectComponents, wpSelectProgramGroup, wpSelectTasks, wpReady, wpPreparing, wpInstalling, wpInfoAfter, wpFinished
  case PageID of
   wpWelcome:             result:=false; 
   wpLicense:             result:=true;  
   wpPassword:            result:=true;  
   wpInfoBefore:          result:=true;  
   wpUserInfo:            result:=true;  
   wpSelectDir:           result:=true; 
   wpSelectComponents:    result:=true;  
   wpSelectProgramGroup:  result:=true;  
   wpSelectTasks:         result:=true;  
   wpReady:               result:=true;  
   wpPreparing:           result:=true;  
   wpInstalling:          result:=false; 
   wpInfoAfter:           result:=true;  
   wpFinished:            result:=false; 
  else  result:=true;
  end;
end;


////卸载
//procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
//begin
//if CurUninstallStep = usUninstall then
//DelTree(ExpandConstant('{sd}\ProgramData\Waves Audio'), True, True, True);
//DelTree(ExpandConstant('{commonpf32}\Waves'), True, True, True);
//DelTree(ExpandConstant('{commoncf64}\Propellerhead Software'), True, True, True);
//DelTree(ExpandConstant('{commoncf64}\Native Instruments'), True, True, True);
//end;