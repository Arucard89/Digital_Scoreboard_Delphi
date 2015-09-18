unit Results;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TResultForm = class(TForm)
    WinnerBox: TComboBox;
    ReasonBox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;


  private
    { Private declarations }
    Procedure setCentralPosition; //��������� ���� �� �������� ������
  public
    { Public declarations }
    procedure fullfillReasonBox;//���������� ����� ��� ������
    procedure fullfillresultForm ( pl1, pl2: string );//��������� ���� �����������
    function calculateTimeOfFight(TimeOfRound,CurMin,CurSec: integer): string;
    procedure writeResToFile(TimeOfFight, mm, ss: integer); //������ ����������� � ����
  end;

var
  ResultForm: TResultForm;

implementation

{$R *.dfm}



procedure TResultForm.fullfillresultForm ( pl1, pl2: string );
begin
//��������� ����� ����������
  winnerBox.Clear;
  WinnerBox.items.Add(pl1);
  WinnerBox.items.Add(pl2);
  winnerBox.ItemIndex := 0;
  //���������� ������� ������
  fullfillReasonBox;
end;

procedure TResultForm.fullfillReasonBox;
var f:TextFile;
  str:string;
begin
  reasonBox.Clear;
  If fileExists('./winreasons/winreasons.ini') then   //���� ���� �� �����
  begin
    assignFile(f,'./winreasons/winreasons.ini');
    reset(f);
    while not eof(f) do
    begin
      readln(f,str);
      reasonBox.Items.Add(str);
    end;
    closefile(f);
  end
  else //���� ���, �� ��������� ������ ����
  begin
    reasonBox.Items.Add('�������');
    reasonBox.Items.Add('������');
    reasonBox.Items.Add('���������������');
  end;

  reasonBox.ItemIndex := 0;
end;

procedure TResultForm.writeResToFile(TimeOfFight, mm, ss: integer); //������ ����������� � ����
var
  f:TextFile;
  Filename:string;
  str: string;
begin
  Filename := './results/'+ dateToStr(date) + '.txt';
  if not fileExists(Filename) then    //��� ����, �������.
  begin
    AssignFile(f,Filename);
    rewrite(f);
  end
  else  //���� ����, �� ������ ������������
    AssignFile(f,Filename);
    Append(f);
//write result to file
  writeln(f,'����� ���������: ' + TimeToStr(Time));
  Writeln(f, '����������: ' + WinnerBox.Items.Strings[WinnerBox.itemIndex]);
  Writeln(f, '����� ��������: ' + calculateTimeOfFight(TimeOfFight, mm, ss));
  Writeln(f, '������� ������: ' + ReasonBox.Items.Strings[ReasonBox.itemIndex]);
  Writeln(f);
  closefile(f);
end;

function TResultForm.calculateTimeOfFight(TimeOfRound,CurMin,CurSec: integer): string;
Var mm,ss, ss1:integer;
begin
  mm := (TimeOfRound - 1) - CurMin;

  If mm < 0 then  //���� ����� ����������
    mm := 0;

  if CurSec = 0 then
    ss :=0
  else
    ss := 60 - CurSec;

  //���� ������ ��������, ��
  if (curMin = 0) and (curSec = 0) then
  begin
    mm := TimeOfRound;
    ss := 0;
  end;

  result := IntToStr(mm) + ' ���. ' + IntToStr(ss) + ' ���.';
end;

procedure TResultForm.setCentralPosition;
begin
  self.Top := (screen.Height - self.Height) div 2;
  self.Left := (screen.Width - self.Width) div 2;
end;

end.
