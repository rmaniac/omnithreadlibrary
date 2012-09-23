program app_3_HelloWorld_with_package.XE3;

uses
  FastMM4,
  Forms,
  test_3_HelloWorld_with_package in 'test_3_HelloWorld_with_package.pas' {frmTestHelloWorld},
  OtlCommon in '..\..\OtlCommon.pas',
  OtlTask in '..\..\OtlTask.pas',
  OtlThreadPool in '..\..\OtlThreadPool.pas',
  OtlComm in '..\..\OtlComm.pas',
  DSiWin32 in '..\..\src\DSiWin32.pas',
  GpLists in '..\..\src\GpLists.pas',
  GpStuff in '..\..\src\GpStuff.pas',
  HVStringBuilder in '..\..\src\HVStringBuilder.pas',
  HVStringData in '..\..\src\HVStringData.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTestHelloWorld, frmTestHelloWorld);
  Application.Run;
end.
