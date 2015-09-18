unit Scoreboard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, Buttons, SettingsForFight, About, Results;

type
  TMainWindow = class(TForm)
    Timer1: TTimer;
    MainPanel: TPanel;
    ColorPanel: TPanel;
    ColorPtsPanel: TPanel;
    LeftPenAdvPanel: TPanel;
    ColorAdvPanel: TPanel;
    ColorPenPanel: TPanel;
    imagesPanel: TPanel;
    BJJF: TImage;
    CenterMMA12: TImage;
    WhitePanel: TPanel;
    WhitePtsPanel: TPanel;
    RightPenAdvPanel: TPanel;
    WhitePenPanel: TPanel;
    WhiteAdvPanel: TPanel;
    ButtonsPanel: TPanel;
    StartPauseStopPanel: TPanel;
    StartButton: TBitBtn;
    PauseButton: TBitBtn;
    StopButton: TBitBtn;
    SettingsPanel: TPanel;
    ConfigBitBtn: TBitBtn;
    BitBtn1: TBitBtn;
    ClockPanel: TPanel;
    TimePanel: TStaticText;
    PlayerName1: TLabel;
    PlayerName2: TLabel;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);//������ �� �������

    //��������� ������� ����� � ������ ������ ����
    procedure ColorPtsPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure ColorPenPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure ColorAdvPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure WhitePtsPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure WhitePenPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure WhiteAdvPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure ConfigBitBtnClick(Sender: TObject);
    procedure StartButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure StopButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure PauseButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);

  private
    { Private declarations }
    //���� ��������
    ColorPoints: integer;
    ColorPenalties: integer;
    ColorAdv: integer;
    //���� ������
    WhitePoints: integer;
    WhitePenalties: integer;
    WhiteAdv: integer;

    timeOnRound: integer; //���������� ����� � ������
    mm:integer; //������
    ss:integer; //�������

    roundIsGoing:bool; //����� ���� ��� ���

   // mayBeScaled : bool; // ���� ����� ����������������(������, ����� ��������� �������� ��������� � ����������.)

    //��������� ���������� ������� ���������
    h:integer;                       //������ � ������ ����, �� ������� ��� ���������������
    w :integer;
    PlH:integer;    //� � � ������� ����
    PlW :integer;
    ScW :integer;    //� � � ���� �����
    ScH :integer;
    PAH :integer;    //������ ������� ����������� � �������

    //��������� ������� �������
    TF: integer;    //����� �������
    PNF: integer;   //����� ����
    SF:integer;     //����� �����
    PAF:integer;    //����� �������� � �����������

    //���� �������
    flashing : boolean; //���������������, ����� �������� ������ 10 ������ � �������� ������(���������� ��� �����)

  protected

    procedure writeAllPointsToPanels; //������ ����� �� ��� ������
    procedure setConfig; //��������� ��������� � �����
    Procedure pauseFight; // ���������� ����� � ��������
    Procedure saveMainSizes; //���������� �������� �������� ���� � ���������
    Procedure saveFontSizes;// ���������� ��������� �������� �������
    Procedure setFontsAfterResize(scale:double);    //��������� ���������������� �������
    Procedure readConfFile(Filename: string); //������ ������������ �� �������� �����
    Procedure setCentralPosition; //��������� ���� �� �������� ������

  public
    { Public declarations }

    procedure clearScores;  //������ ����
    procedure WritePointsToPanel(points: integer; panel:TPanel); //������ ����� � ���������� ������
    procedure SetTime(minutes:integer; seconds:integer);  //��������� �������
    procedure stopFight; //��������� �������

    function getTimeOfRound: integer; //�������� ����������������� ������
    function GetCurSec: integer;  //�������� ������� ���-�� ������
    function GetCurMin: integer;  //�������� ������� ���-�� �����
  end;

var
  MainWindow: TMainWindow;

implementation



{$R *.dfm}


procedure TMainWindow.FormCreate(Sender: TObject);
begin
  saveMainSizes;  //��������� ��� �������
  saveFontSizes; //��������� ��������� ������
  ClearScores;
  //������� ����� ��������.��� �������(�� ������ ���������� ��� �����, ����� �� �����)
  ColorPanel.BevelOuter:=bvNone;
  WhitePanel.BevelOuter:=bvNone;
  //���������� ����
  writeAllPointsToPanels;
  //���������� �����
  mm:=0;
  ss:=0;
  SetTime(mm, ss);

  //�� ��������� ����� = 5 ���
  timeOnRound := 5;

  StartButton.Enabled := False; //��� �������� ���������� ������
  StopButton.Enabled := False;
  PauseButton.Enabled := false;

  roundIsGoing := false;

  //������ ��������
  if FileExists ('./images/Image1.jpg') then
    CenterMMA12.Picture.LoadFromFile('./images/Image1.jpg');
    
  if FileExists ('./images/Image2.jpg') then
    BJJF.Picture.LoadFromFile('./images/Image2.jpg');

  //������ ������������ �� �����
  readConfFile('config.cfg');

  setCentralPosition;

end;


procedure TMainWindow.ClearScores() ;
begin
  ColorPoints := 0;
  ColorPenalties := 0;
  ColorAdv := 0;

  WhitePoints := 0;
  WhitePenalties := 0;
  WhiteAdv := 0;

end;


procedure TMainWindow.writeAllPointsToPanels;
begin
  WritePointsToPanel( ColorPoints, ColorPtsPanel );
  WritePointsToPanel( ColorPenalties, ColorPenPanel );
  WritePointsToPanel( ColorAdv, ColorAdvPanel );

  WritePointsToPanel( WhitePoints, WhitePtsPanel );
  WritePointsToPanel( WhitePenalties, WhitePenPanel );
  WritePointsToPanel( WhiteAdv, WhiteAdvPanel );
end;


procedure TMainWindow.WritePointsToPanel(points: integer; panel: TPanel);
var str:string;
begin
  str:=IntToStr(points);
  if ((points div 10) = 0) and (panel.Color <> clRed) then
    str:='0'+str;
  panel.Caption:=str;
  panel.Invalidate;
end;


procedure TMainWindow.SetTime(minutes, seconds: integer);
var
  mstr,sstr: string;
begin
  mstr := IntToStr(minutes);
  if (minutes div 10) = 0 then
    mstr := '0' + mstr;

  sstr:=IntToStr(seconds);
  if (seconds div 10) = 0 then
    sstr := '0' + sstr;
  timePanel.Caption := mstr + ':' + sstr;
  //timePanel.Invalidate;

end;


procedure TMainWindow.Timer1Timer(Sender: TObject);
begin

  Dec(ss);

  if (ss = 0) and (mm = 0) then
  begin
    setTime(mm,ss);     //������ �����, ������ ��� ��� ����. ����� ��������. ��� ���������.
    stopFight;
  end;

  if ss < 0 then
  begin
    dec(mm);
    ss := 59;
  end;

  setTime(mm,ss);

  //�������� ������� �����, ���� �������� 10 ������
  if (mm = 0 ) and (ss = 10) then
  begin
    Timer2.Enabled := true;
    flashing := true;
  end

end;


procedure TMainWindow.stopFight;   //����� �������
begin

  Timer1.Enabled:=false;
  ConfigBitBtn.Enabled := true;
  roundIsGoing := false;
  flashing := false; //�������� ���������

  //��������� ������� � ������ �������
  Timer2.Enabled:=false;
  PlayerName1.Color := clWhite;
  PlayerName2.Color := clWhite;
  PlayerName1.Font.Color := clWindowText;
  PlayerName2.Font.Color := clWindowText;

  //��������� ��� ������
  StopButton.Enabled := false;
  PauseButton.Enabled := false;
  StartButton.Enabled := false;

  //���� ��������� ����� ����� �����������
  Application.CreateForm(TResultForm, ResultForm);
  resultForm.fullfillresultForm(PlayerName1.Caption, PlayerName2.Caption);
  ResultForm.ShowModal;
  ResultForm.writeResToFile(timeOnRound, mm, ss);
  ResultForm.Destroy;

end;


//��������� ������� ����� � ������ ������ ����

procedure TMainWindow.ColorPtsPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  points:integer;
begin
//���� ����� ����, �� ����� �����
  if roundIsGoing = false then
    Exit;

  points := colorPoints;

  if Button = mbLeft then
    Inc(points);
    
  if (Button = mbRight) and (points > 0) then
    Dec(points);
  WritePointsToPanel( points, ColorPtsPanel );

  colorPoints := points;
end;


procedure TMainWindow.ColorPenPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  points:integer;
begin
//���� ����� ����, �� ����� �����
  if roundIsGoing = false then
    Exit;

  points := colorPenalties;

  if Button = mbLeft then
    Inc(points);
  if (Button = mbRight) and (points > 0) then
    Dec(points);
  WritePointsToPanel( points, ColorPenPanel );

  colorPenalties := points;
end;


procedure TMainWindow.ColorAdvPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  points:integer;
begin
//���� ����� ����, �� ����� �����
  if roundIsGoing = false then
    Exit;

  points := colorAdv;

  if Button = mbLeft then
    Inc(points);
  if (Button = mbRight) and (points > 0) then
    Dec(points);
  WritePointsToPanel( points, ColorAdvPanel );

  colorAdv := points;
end;


procedure TMainWindow.WhitePtsPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  points:integer;
begin
//���� ����� ����, �� ����� �����
  if roundIsGoing = false then
    Exit;

  points := whitePoints;

  if Button = mbLeft then
    Inc(points);
  if (Button = mbRight) and (points > 0) then
    Dec(points);
  WritePointsToPanel( points, WhitePtsPanel );

  WhitePoints := points;
end;


procedure TMainWindow.WhitePenPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  points:integer;
begin
//���� ����� ����, �� ����� �����
  if roundIsGoing = false then
    Exit;

  points := whitePenalties;

  if Button = mbLeft then
    Inc(points);
  if (Button = mbRight) and (points > 0) then
    Dec(points);
  WritePointsToPanel( points, whitePenPanel );

  whitePenalties := points;
end;


procedure TMainWindow.WhiteAdvPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  points:integer;
begin
//���� ����� ����, �� ����� �����
  if roundIsGoing = false then
    Exit;

  points := whiteAdv;

  if Button = mbLeft then
    Inc(points);
  if (Button = mbRight) and (points > 0) then
    Dec(points);
  WritePointsToPanel( points, whiteAdvPanel );

  whiteAdv := points;
end;


//��������� ������� ������ ��������
procedure TMainWindow.ConfigBitBtnClick(Sender: TObject);
begin

  //������� ����� ������������ � ���������� ������� ��������� � ���
  Application.CreateForm(TFightSettings, FightSettings);
  FightSettings.ColorLabeledEdit.Text := PlayerName1.Caption;
  FightSettings.WhiteLabeledEdit.Text := PlayerName2.Caption;
  FightSettings.RoundTimeSpinEdit.Value := timeOnRound;
  FightSettings.ShowModal;

  //���� ����� ��, �� ������ ��������� �������� ����
  If FightSettings.ModalResult = mrOK then
  begin
    timeOnRound := FightSettings.RoundTimeSpinEdit.Value;
    setConfig;
    //�������� ������ �����, ������ ��� ��� ���� ���������
    StartButton.Enabled := true;
    //���� �������� �� ��� ������, ���� ������ �� ������ ������.
    StopButton.Enabled := true;
  end;
  FightSettings.Destroy; //����� �����,���� �� �������� ������

end;


//������ ���������������� ������ � ���� �����
procedure TMainWindow.setConfig;
begin
  clearScores;
  WriteAllPointsToPanels;
  mm := timeOnRound;
  ss := 0;
  SetTime(mm,ss);
  PlayerName1.Caption := FightSettings.ColorLabeledEdit.Text;
  PlayerName2.Caption := FightSettings.WhiteLabeledEdit.Text;
end;


//����� ������� �� ����� ������ ���������� ����������� � ������ �������� ����
procedure TMainWindow.StartButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

  Timer1.Enabled := true;
  (sender as TBitBtn).Enabled := false;
  roundIsGoing := true;
  ConfigBitBtn.Enabled := false;
  PauseButton.Enabled := true;
  flashing := false;//������� ���������

end;

procedure TMainWindow.StopButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  StopFight;
  PauseButton.Caption := '�����'; //�� ��� ������, ���� ����� ����� ���� ���������

  //if timeOnRound = mm then ShowMessage ('Flawless victory');
end;


//��������� ������� �� �����
procedure TMainWindow.PauseButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pauseFight;

end;

procedure TMainWindow.FormKeyPress(Sender: TObject; var Key: Char); // ��������� �� �������.
begin
  if key = Char(32) then
    pauseFight;
end;

procedure TMainWindow.pauseFight;
begin

//��������/������������� ������ ������� � �������
  if Timer1.Enabled = true then
  Begin
    Timer1.Enabled := false;
    Timer2.Enabled := false;
    PauseButton.Caption := '����������';
  end
  else
  Begin
    Timer1.Enabled := True;
    if flashing = true then //���� �������� ��������, �� ���������
      Timer2.Enabled := True ;
    PauseButton.Caption := '�����';
  end


end;

procedure TMainWindow.BitBtn1Click(Sender: TObject);  //����������
begin
  Application.CreateForm(TInfoForm, InfoForm);
  InfoForm.Visible := false;
  Infoform.ShowModal;
  Infoform.Destroy;
end;

procedure TMainWindow.FormResize(Sender: TObject);
var
  HMultiplier,WMultiplier: double; //��������� �������� ������ � ������
begin
  //����������� ���������
  HMultiplier := MainWindow.Height / h;
  WMultiplier := MainWindow.Width / w;
  //������ ������� ������.(������ ��������� �������� ��-�� ������������)
  PlayerName1.Width := round(PlW * WMultiplier);
  PlayerName2.Width := round(PlW * WMultiplier);
  ClockPanel.Height := round(PLH * HMultiplier);
  //������� ������
    //������ ���� ������
  MainPanel.Height := round(ScH * HMultiplier);
    //������ ����� �����
  LeftPenAdvPanel.Height := round(PAH * HMultiplier);
  RightPenAdvPanel.Height := round(PAH * HMultiplier);
    //������ ������
  ColorPanel.Width := round(ScW * WMultiplier);
  WhitePanel.Width := round(ScW * WMultiplier);
      //������ ��������� ������ (�����-�� � ������)
  ColorPenPanel.Width := ColorPanel.Width div 2 - 3; //� �������
  WhitePenPanel.Width := ColorPanel.Width div 2 - 3; //� �������
  ColorAdvPanel.Width := ColorPanel.Width div 2 - 3; //� �������
  WhiteAdvPanel.Width := ColorPanel.Width div 2 - 3; //� �������
    //������ ��������
  CenterMMA12.Height := (MainPanel.Height div 2) - 2; //��������� �����
  BJJF.Height := (MainPanel.Height div 2) - 2; //��������� �����

  setFontsAfterResize(HMultiplier);


end;

procedure TMainWindow.saveMainSizes;
begin
  h := MainWindow.Height;                       //������ � ������ ����, �� ������� ��� ���������������
  w := MainWindow.Width;
  PlH := PlayerName1.Height;    //� � � ������� ����
  PlW := PlayerName1.width;
  ScW := ColorPanel.Width;    //� � � ���� �����
  ScH := MainPanel.Height;
  PAH := LeftPenAdvPanel.Height;    //������ ������� ����������� � �������
end;

procedure TMainWindow.setFontsAfterResize(scale: double);
begin
  TimePanel.Font.Size := round ( TF * Scale) ;

  PlayerName1.Font.Size := round ( PNF * Scale) ;
  PlayerName2.Font.Size := round ( PNF * Scale) ;

  ColorPtsPanel.Font.Size := round ( SF * Scale) ;
  WhitePtsPanel.Font.Size := round ( SF * Scale) ;

  ColorPenPanel.Font.Size := round ( PAF * Scale) ;
  WhitePenPanel.Font.Size := round ( PAF * Scale) ;
  ColorAdvPanel.Font.Size := round ( PAF * Scale) ;
  WhiteAdvPanel.Font.Size := round ( PAF * Scale) ;
end;

procedure TMainWindow.saveFontSizes;
begin
  TF := TimePanel.Font.Size;
  PNF := PlayerName1.Font.Size;
  SF := ColorPtsPanel.Font.Size;
  PAF := ColorPenPanel.Font.Size;
end;

function TMainWindow.GetCurMin: integer;
begin
  result := mm;
end;

function TMainWindow.GetCurSec: integer;
begin
    result := ss;
end;

function TMainWindow.getTimeOfRound: integer;
begin
  result := timeOnRound
end;

procedure TMainWindow.Timer2Timer(Sender: TObject);
begin
//������ ������� ������� ������ ��� ������ �������� 10 ������
//������ ���� ���� � ������
  if PlayerName1.Color = clWhite then
  begin
    PlayerName1.Color := clRed;
    PlayerName2.Color := clRed;
    PlayerName1.Font.Color := clWhite;
    PlayerName2.Font.Color := clWhite;
  end
  else
  begin
    PlayerName1.Color := clWhite;
    PlayerName2.Color := clWhite;
    PlayerName1.Font.Color := clWindowText;
    PlayerName2.Font.Color := clWindowText;
  end;
  PlayerName1.Repaint;
end;

procedure TMainWindow.readConfFile(Filename: string);
var
  f:textfile;
  str: string;
begin
  If fileExists(fileName) then
  begin
    assignFile(f,FileName);
    reset(f);
    While not eof(f) do
      readln(f, str);
    Timer2.Interval := StrToInt(str); //���������� ���������� ��� ������� ��������.
    closeFile(f);
  end
end;

procedure TMainWindow.setCentralPosition;
begin
  self.Top := (screen.Height - self.Height) div 2;
  self.Left := (screen.Width - self.Width) div 2;
end;

end.
