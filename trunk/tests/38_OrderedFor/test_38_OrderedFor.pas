unit test_38_OrderedFor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmOderedForDemo = class(TForm)
    btnUnorderedPrimes: TButton;
    lbLog: TListBox;
    btnOrderedPrimes: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure btnUnorderedPrimesClick(Sender: TObject);
    procedure btnOrderedPrimesClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    function IsPrime(i: integer): boolean;
  public
  end;

var
  frmOderedForDemo: TfrmOderedForDemo;

implementation

uses
  OtlCommon,
  OtlCollections,
  OtlParallel;

{$R *.dfm}

function TfrmOderedForDemo.IsPrime(i: integer): boolean;
var
  j: integer;
begin
  Result := false;
  if i <= 0 then
    Exit;
  for j := 2 to Round(Sqrt(i)) do
    if (i mod j) = 0 then
      Exit;
  Result := true;
end;

procedure TfrmOderedForDemo.btnUnorderedPrimesClick(Sender: TObject);
var
  prime     : TOmniValue;
  primeQueue: IOmniBlockingCollection;
begin
  lbLog.Clear;
  primeQueue := TOmniBlockingCollection.Create;
  Parallel.ForEach(1, 1000).NoWait
    .OnStop(
      procedure
      begin
        primeQueue.CompleteAdding;
      end)
    .Execute(
      procedure (const value: integer)
      begin
        if IsPrime(value) then begin
          primeQueue.Add(value);
//          Sleep(200);
        end;
      end);
  for prime in primeQueue do begin
    lbLog.Items.Add(IntToStr(prime));
    lbLog.Update;
  end;
end;

procedure TfrmOderedForDemo.Button3Click(Sender: TObject);
var
  prime     : TOmniValue;
  primeQueue: IOmniBlockingCollection;
begin
  lbLog.Clear;
  primeQueue := TOmniBlockingCollection.Create;
  Parallel.ForEach(1, 1000).NoWait.Into(primeQueue).Execute(
    procedure (const value: integer; var res: TOmniValue)
    begin
      if IsPrime(value) then
        res := value;
    end);
  for prime in primeQueue do
    lbLog.Items.Add(IntToStr(prime));
end;

procedure TfrmOderedForDemo.btnOrderedPrimesClick(Sender: TObject);
var
  prime     : TOmniValue;
  primeQueue: IOmniBlockingCollection;
begin
  lbLog.Clear;
  primeQueue := TOmniBlockingCollection.Create;
  Parallel.ForEach(1, 1000).PreserveOrder.NoWait.Into(primeQueue).Execute(
    procedure (const value: integer; var res: TOmniValue)
    begin
      if IsPrime(value) then
        res := value;
    end);
  for prime in primeQueue do
    lbLog.Items.Add(IntToStr(prime));
end;

procedure TfrmOderedForDemo.Button1Click(Sender: TObject);
var
  prime      : TOmniValue;
  resultQueue: IOmniBlockingCollection;
begin
  lbLog.Clear;
  resultQueue := TOmniBlockingCollection.Create;
  Parallel.ForEach(1, 1000).NoWait.IntoNext.Execute(
    procedure (const value: integer; var res: TOmniValue)
    begin
      if IsPrime(value) then
        res := value;
    end
  )
  .ForEach.NoWait.Into(resultQueue).Execute(
    procedure (const value: integer; var res: TOmniValue)
    begin
      // Sophie Germain primes
      if IsPrime(2*value + 1) then
        res := value;
    end
  );
  for prime in resultQueue do
    lbLog.Items.Add(IntToStr(prime));
end;

procedure TfrmOderedForDemo.Button2Click(Sender: TObject);
var
  prime: TOmniValue;
begin
  lbLog.Clear;
  for prime in
    Parallel.ForEach(1, 1000).Enumerate.Execute(
      procedure (const value: TOmniValue; var res: TOmniValue)
      begin
        if IsPrime(value) then
          res := value;
      end
    )
  do
    lbLog.Items.Add(IntToStr(prime));
end;

end.