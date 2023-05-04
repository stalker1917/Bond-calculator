unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    Button1: TButton;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    LabeledEdit9: TLabeledEdit;
    LabeledEdit10: TLabeledEdit;
    LabeledEdit12: TLabeledEdit;
    LabeledEdit11: TLabeledEdit;
    LabeledEdit13: TLabeledEdit;
    Button2: TButton;
    LabeledEdit14: TLabeledEdit;
    LabeledEdit15: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
    procedure SetArrays;
    procedure DateToDays;
    function  Solve:Double;
    procedure SolveExt(D:Double);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  SData : Array[0..4] of String;
  SDays : Array[0..4] of Integer;
  Remains : Array[0..4] of Integer;
  NAmorts :  byte=0;
  Nominal : Integer;
  Price : Double;
  Percents : Double;

implementation

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
var
Period : Integer;
K,D : Double;
begin
  K := StrToFloat(LabeledEdit14.Text);
  Period := StrToInt(LabeledEdit15.Text);
  Nominal := StrToInt(LabeledEdit13.Text);
  D := ln((K+Nominal)/Nominal);
  D := (exp(D*Period)-1)*100;
  LabeledEdit11.Text := FloatToStrF(D,ffGeneral,3,5);
end;

procedure TForm1.DateToDays;
var i:Integer;
CDate:TDateTime;
begin
  CDate := Now; //Double
  FormatSettings.DateSeparator :='.';
  for I := 0 to NAmorts do
    SDays[i] := Trunc(StrToDateTime(SData[i])-Cdate);
end;

function TForm1.Solve:Double;
var
I: Integer;
Q,D:Double;
begin
  Q:=0;
  for I := 0 to NAmorts do
    if i=NAmorts then
      begin
        if i>0 then q:=q*Remains[i]/Nominal;
        q:=q+SDays[i]/365;
      end
    else
      begin
        if i>0 then q:=q*Remains[i]/Remains[i+1];
        q:=q+(SDays[i]-SDays[i+1])/365;
      end;
  D:=ln(100/Price)/Q+ln((100+Percents)/100);
  D:=(exp(D)-1)*100;   //Купонный доход относительно номинала , а не цены
  result:=D;
  //LabeledEdit4.Text := FloatToStrF(D,ffGeneral,3,5)+'%';
end;

procedure TForm1.SolveExt;
var Znak,ZnakOld,Stage:Boolean;
i:Integer;
BegPeriod,EndPeriod:Integer;
Price:Double;
begin
  Stage :=False;
  repeat
    if Stage then ZnakOld := Znak;
    Price := Unit1.Price;
    //Вычисляем знак
    for I := NAmorts downto 0 do
      begin
        if i=NAmorts then BegPeriod := 0
                     else BegPeriod := SDays[i+1];
        EndPeriod := SDays[i];
        while (EndPeriod-BegPeriod)>365 do
          begin
            Price := Price*(1+D/100)-Percents;
            BegPeriod := BegPeriod + 365;
          end;
        Price := Price*(1+D*(EndPeriod-BegPeriod)/(365*100))-Percents*(EndPeriod-BegPeriod)/365;
        if I>0 then
          if i=NAmorts then Price := 100*exp(ln(Price/100)*Nominal/Remains[i])
                       else Price := 100*exp(ln(Price/100)*Remains[i+1]/Remains[i])
      end;
    Znak := Price<100;
    if Znak then D:=D+0.01
            else D:=D-0.01;
    if not Stage then
      begin
        ZnakOld := Znak;
        Stage := True;
      end;
  until (Znak<>ZnakOld);
  LabeledEdit4.Text := FloatToStrF(D,ffGeneral,3,5)+'%';
end;

procedure TForm1.SetArrays;
begin
 Nominal := StrToInt(LabeledEdit13.Text);
 Price := StrToFloat(LabeledEdit12.Text);
 Percents := StrToFloat(LabeledEdit11.Text);
 NAmorts:=0;
 SData[0] := LabeledEdit1.Text;
 Remains[0] := 0;
  if (LabeledEdit2.Text<>'') and (LabeledEdit3.Text<>'') then
    begin
      NAmorts:=1;
      SData[1] := LabeledEdit2.Text;
      Remains[1] := StrToInt(LabeledEdit3.Text);
    end
  else exit;
   if (LabeledEdit5.Text<>'') and (LabeledEdit6.Text<>'') then
    begin
      NAmorts:=2;
      SData[2] := LabeledEdit5.Text;
      Remains[2] := StrToInt(LabeledEdit6.Text);
    end
  else exit;
   if (LabeledEdit7.Text<>'') and (LabeledEdit8.Text<>'') then
    begin
      NAmorts:=3;
      SData[3] := LabeledEdit7.Text;
      Remains[3] := StrToInt(LabeledEdit8.Text);
    end
  else exit;
   if (LabeledEdit9.Text<>'') and (LabeledEdit10.Text<>'') then
    begin
      NAmorts:=4;
      SData[4] := LabeledEdit9.Text;
      Remains[4] := StrToInt(LabeledEdit10.Text);
    end
  else exit;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  SetArrays;
  DateToDays;
  SolveExt(Solve);
end;

end.
