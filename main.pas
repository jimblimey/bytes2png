unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Spin, StdCtrls,
  ExtCtrls, Buttons, EditBtn, ExtDlgs;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnBgColour: TColorButton;
    btnFgColour: TColorButton;
    btnCreate: TButton;
    btnSave: TButton;
    checkRowsFirst: TCheckBox;
    listScale: TComboBox;
    imgPreview: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SavePictureDialog1: TSavePictureDialog;
    textBytes: TMemo;
    editWidth: TSpinEdit;
    editHeight: TSpinEdit;
    procedure btnCreateClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmMain: TfrmMain;

const
  scale = 2;

implementation

{$R *.lfm}

// http://delphiexamples.com/mathematics/bin2dec.html
function Pow(i, k: Integer): Integer;
var
  j, Count: Integer;
begin
  if k>0 then j:=2
    else j:=1;
  for Count:=1 to k-1 do
    j:=j*2;
  Result:=j;
end;

// http://delphiexamples.com/mathematics/bin2dec.html
function BinToDec(Str: string): Integer;
var
  Len, Res, i: Integer;
  Error: Boolean;
begin
  Error:=False;
  Len:=Length(Str);
  Res:=0;
  for i:=1 to Len do
    if (Str[i]='0')or(Str[i]='1') then
      Res:=Res+Pow(2, Len-i)*StrToInt(Str[i])
    else
    begin
      Error:=True;
      Break;
    end;
  if Error=True then Result:=0
    else Result:=Res;
end;

function DecToBin(Value: Byte): string;
var
  i: Integer;
begin
  SetLength(Result, 8);
  for i := 1 to 8 do
  begin
    if (Value shr (8-i)) and 1 = 0 then
    begin
      Result[i] := '0'
    end
    else
    begin
      Result[i] := '1';
    end;
  end;
end;

{ TfrmMain }

procedure TfrmMain.btnCreateClick(Sender: TObject);
var
  pngbmp: TPortableNetworkGraphic;
  w,h,sc: Integer;
  x,y,xs: Integer;
  s: String;
  values: Array of Byte;
  i: Integer;
  a: TStringArray;
begin
  if listScale.ItemIndex < 0 then listScale.ItemIndex := 0;
  sc := 0;
  w := editWidth.Value * 8;
  h := editHeight.Value * 8;
  s := textBytes.Text;
  a := s.Split(',');
  SetLength(values,Length(a));
  for i := 0 to Length(values)-1 do
  begin
    values[i] := trim(a[i]).ToInteger;
  end;
  pngbmp := TPortableNetworkGraphic.Create;
  pngbmp.SetSize(w,h);
  y := 0;
  xs := 0;
  for i := 0 to Length(values)-1 do
  begin
    s := DecToBin(values[i]);
    for x := 1 to 8 do
    begin
      if s[x] = '1' then
        pngbmp.Canvas.Pixels[xs+x-1,y] := btnFgColour.ButtonColor
      else
        pngbmp.Canvas.Pixels[xs+x-1,y] := btnBgColour.ButtonColor;
    end;
    inc(y);
    if y >= h then
    begin
      inc(xs,8);
      y := 0;
    end;
  end;
  case listScale.ItemIndex of
    0: sc := 1;
    1: sc := 2;
    2: sc := 3;
    3: sc := 4;
  end;
  imgPreview.Width := w * sc;
  imgPreview.Height := h * sc;
  imgPreview.Picture.Assign(pngbmp);
  pngbmp.Free;

end;

procedure TfrmMain.btnSaveClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
  begin
    imgPreview.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  SavePictureDialog1.Filter := 'Portable Network Graphic (*.png)|*.png';
end;

end.

