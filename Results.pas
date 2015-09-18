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
    Procedure setCentralPosition; //установка окна по середине экрана
  public
    { Public declarations }
    procedure fullfillReasonBox;//заполнение комбо для причин
    procedure fullfillresultForm ( pl1, pl2: string );//заполняем фрму результатов
    function calculateTimeOfFight(TimeOfRound,CurMin,CurSec: integer): string;
    procedure writeResToFile(TimeOfFight, mm, ss: integer); //запись результатов в файл
  end;

var
  ResultForm: TResultForm;

implementation

{$R *.dfm}



procedure TResultForm.fullfillresultForm ( pl1, pl2: string );
begin
//вставляем имена участников
  winnerBox.Clear;
  WinnerBox.items.Add(pl1);
  WinnerBox.items.Add(pl2);
  winnerBox.ItemIndex := 0;
  //записываем причины победы
  fullfillReasonBox;
end;

procedure TResultForm.fullfillReasonBox;
var f:TextFile;
  str:string;
begin
  reasonBox.Clear;
  If fileExists('./winreasons/winreasons.ini') then   //если файл на месте
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
  else //если нет, то урезанную версию даем
  begin
    reasonBox.Items.Add('Болевой');
    reasonBox.Items.Add('Травма');
    reasonBox.Items.Add('Дисквалификация');
  end;

  reasonBox.ItemIndex := 0;
end;

procedure TResultForm.writeResToFile(TimeOfFight, mm, ss: integer); //запись результатов в файл
var
  f:TextFile;
  Filename:string;
  str: string;
begin
  Filename := './results/'+ dateToStr(date) + '.txt';
  if not fileExists(Filename) then    //нет фала, создаем.
  begin
    AssignFile(f,Filename);
    rewrite(f);
  end
  else  //если есть, то просто дозаписываем
    AssignFile(f,Filename);
    Append(f);
//write result to file
  writeln(f,'Время окончания: ' + TimeToStr(Time));
  Writeln(f, 'Победитель: ' + WinnerBox.Items.Strings[WinnerBox.itemIndex]);
  Writeln(f, 'Время поединка: ' + calculateTimeOfFight(TimeOfFight, mm, ss));
  Writeln(f, 'Причина победы: ' + ReasonBox.Items.Strings[ReasonBox.itemIndex]);
  Writeln(f);
  closefile(f);
end;

function TResultForm.calculateTimeOfFight(TimeOfRound,CurMin,CurSec: integer): string;
Var mm,ss, ss1:integer;
begin
  mm := (TimeOfRound - 1) - CurMin;

  If mm < 0 then  //если сразу остановили
    mm := 0;

  if CurSec = 0 then
    ss :=0
  else
    ss := 60 - CurSec;

  //если полный поединок, то
  if (curMin = 0) and (curSec = 0) then
  begin
    mm := TimeOfRound;
    ss := 0;
  end;

  result := IntToStr(mm) + ' мин. ' + IntToStr(ss) + ' сек.';
end;

procedure TResultForm.setCentralPosition;
begin
  self.Top := (screen.Height - self.Height) div 2;
  self.Left := (screen.Width - self.Width) div 2;
end;

end.
