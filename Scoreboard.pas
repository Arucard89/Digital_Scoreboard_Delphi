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
    procedure Timer1Timer(Sender: TObject);//отсчет по таймеру

    //Обработка нажатий левой и правой кнопок мыши
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
    //очки цветного
    ColorPoints: integer;
    ColorPenalties: integer;
    ColorAdv: integer;
    //очки белого
    WhitePoints: integer;
    WhitePenalties: integer;
    WhiteAdv: integer;

    timeOnRound: integer; //количество минут в раунде
    mm:integer; //минуты
    ss:integer; //секунды

    roundIsGoing:bool; //раунд идет или нет

   // mayBeScaled : bool; // окно может масштабироваться(истина, когда начальные значения сохранены в переменных.)

    //начальные габаритные размеры элементов
    h:integer;                       //ширина и высота окна, на котором все разрабатывалось
    w :integer;
    PlH:integer;    //ш и в панелей имен
    PlW :integer;
    ScW :integer;    //ш и в окна очков
    ScH :integer;
    PAH :integer;    //высота панелей преимуществ и штрафов

    //начальные размеры шрифтов
    TF: integer;    //шрифт времени
    PNF: integer;   //шрифт имен
    SF:integer;     //шрифт очков
    PAF:integer;    //Шрифт пенальти и преимуществ

    //флаг мигания
    flashing : boolean; //устанавливается, когда остается меньше 10 секунд и панельки мигают(необходимо для паузы)

  protected

    procedure writeAllPointsToPanels; //запись очков во все панели
    procedure setConfig; //применить установки у форме
    Procedure pauseFight; // реализация паузы в поединке
    Procedure saveMainSizes; //сохранение основных размеров окна и элементов
    Procedure saveFontSizes;// сохранение начальных размеров шрифтов
    Procedure setFontsAfterResize(scale:double);    //установка масштабированных шрифтов
    Procedure readConfFile(Filename: string); //чтение конфигурауии из внешнего файла
    Procedure setCentralPosition; //установка окна по середине экрана

  public
    { Public declarations }

    procedure clearScores;  //чистим очки
    procedure WritePointsToPanel(points: integer; panel:TPanel); //Запись очков в конкретную панель
    procedure SetTime(minutes:integer; seconds:integer);  //Установка времени
    procedure stopFight; //остановка схватки

    function getTimeOfRound: integer; //получить продолжительность раунда
    function GetCurSec: integer;  //получить текущее кол-во секунд
    function GetCurMin: integer;  //получить текужее кол-во минут
  end;

var
  MainWindow: TMainWindow;

implementation



{$R *.dfm}


procedure TMainWindow.FormCreate(Sender: TObject);
begin
  saveMainSizes;  //сохраняем все размеры
  saveFontSizes; //Сохраняем начальные шрифты
  ClearScores;
  //убираем рамку объединя.щих панелей(на момент разработки она нужна, иначе не видно)
  ColorPanel.BevelOuter:=bvNone;
  WhitePanel.BevelOuter:=bvNone;
  //Записываем нули
  writeAllPointsToPanels;
  //выставляем время
  mm:=0;
  ss:=0;
  SetTime(mm, ss);

  //по умолчанию время = 5 мин
  timeOnRound := 5;

  StartButton.Enabled := False; //без настроек стартовать нельзя
  StopButton.Enabled := False;
  PauseButton.Enabled := false;

  roundIsGoing := false;

  //грузим картинки
  if FileExists ('./images/Image1.jpg') then
    CenterMMA12.Picture.LoadFromFile('./images/Image1.jpg');
    
  if FileExists ('./images/Image2.jpg') then
    BJJF.Picture.LoadFromFile('./images/Image2.jpg');

  //читаем конфигурацию из файла
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
    setTime(mm,ss);     //полное фуфло, потому что два раза. потом подумать. так некрасиво.
    stopFight;
  end;

  if ss < 0 then
  begin
    dec(mm);
    ss := 59;
  end;

  setTime(mm,ss);

  //Включаем мигание формы, если остается 10 секунд
  if (mm = 0 ) and (ss = 10) then
  begin
    Timer2.Enabled := true;
    flashing := true;
  end

end;


procedure TMainWindow.stopFight;   //конец схватки
begin

  Timer1.Enabled:=false;
  ConfigBitBtn.Enabled := true;
  roundIsGoing := false;
  flashing := false; //мерцание выключаем

  //выключаем мигание и таймер мигания
  Timer2.Enabled:=false;
  PlayerName1.Color := clWhite;
  PlayerName2.Color := clWhite;
  PlayerName1.Font.Color := clWindowText;
  PlayerName2.Font.Color := clWindowText;

  //Выключаем все кнопки
  StopButton.Enabled := false;
  PauseButton.Enabled := false;
  StartButton.Enabled := false;

  //сюда поставить показ формы результатов
  Application.CreateForm(TResultForm, ResultForm);
  resultForm.fullfillresultForm(PlayerName1.Caption, PlayerName2.Caption);
  ResultForm.ShowModal;
  ResultForm.writeResToFile(timeOnRound, mm, ss);
  ResultForm.Destroy;

end;


//Обработка нажатий левой и правой кнопок мыши

procedure TMainWindow.ColorPtsPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  points:integer;
begin
//Если раунд идет, то сразу выход
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
//Если раунд идет, то сразу выход
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
//Если раунд идет, то сразу выход
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
//Если раунд идет, то сразу выход
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
//Если раунд идет, то сразу выход
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
//Если раунд идет, то сразу выход
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


//обработка нажатия кнопки настроек
procedure TMainWindow.ConfigBitBtnClick(Sender: TObject);
begin

  //создаем форму конфигурации и выставляем текущие настройки в ней
  Application.CreateForm(TFightSettings, FightSettings);
  FightSettings.ColorLabeledEdit.Text := PlayerName1.Caption;
  FightSettings.WhiteLabeledEdit.Text := PlayerName2.Caption;
  FightSettings.RoundTimeSpinEdit.Value := timeOnRound;
  FightSettings.ShowModal;

  //если нажат ОК, то меняем настройки главного окна
  If FightSettings.ModalResult = mrOK then
  begin
    timeOnRound := FightSettings.RoundTimeSpinEdit.Value;
    setConfig;
    //Включаем кнопку Старт, потому что она была выключена
    StartButton.Enabled := true;
    //Стоп включаем на тот случай, если побеза до начала раунда.
    StopButton.Enabled := true;
  end;
  FightSettings.Destroy; //мочим форму,чтоб не занимала память

end;


//запись конфигурационных данных в поля формы
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


//после нажатия на старт кнопка становится недоступной и кнопка настроек тоже
procedure TMainWindow.StartButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

  Timer1.Enabled := true;
  (sender as TBitBtn).Enabled := false;
  roundIsGoing := true;
  ConfigBitBtn.Enabled := false;
  PauseButton.Enabled := true;
  flashing := false;//мигание отключено

end;

procedure TMainWindow.StopButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  StopFight;
  PauseButton.Caption := 'Пауза'; //на тот случай, если после паузы была остановка

  //if timeOnRound = mm then ShowMessage ('Flawless victory');
end;


//обработка нажатия на паузу
procedure TMainWindow.PauseButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pauseFight;

end;

procedure TMainWindow.FormKeyPress(Sender: TObject; var Key: Char); // остановка по пробелу.
begin
  if key = Char(32) then
    pauseFight;
end;

procedure TMainWindow.pauseFight;
begin

//Включаем/останавливаем таймер времени и мигания
  if Timer1.Enabled = true then
  Begin
    Timer1.Enabled := false;
    Timer2.Enabled := false;
    PauseButton.Caption := 'Продолжить';
  end
  else
  Begin
    Timer1.Enabled := True;
    if flashing = true then //если включено мерцание, то запускаем
      Timer2.Enabled := True ;
    PauseButton.Caption := 'Пауза';
  end


end;

procedure TMainWindow.BitBtn1Click(Sender: TObject);  //информация
begin
  Application.CreateForm(TInfoForm, InfoForm);
  InfoForm.Visible := false;
  Infoform.ShowModal;
  Infoform.Destroy;
end;

procedure TMainWindow.FormResize(Sender: TObject);
var
  HMultiplier,WMultiplier: double; //множитель масштаба высоты и ширины
begin
  //расчитываем множители
  HMultiplier := MainWindow.Height / h;
  WMultiplier := MainWindow.Width / w;
  //множим верхнюю панель.(высота автоматом ставится из-за выравнивания)
  PlayerName1.Width := round(PlW * WMultiplier);
  PlayerName2.Width := round(PlW * WMultiplier);
  ClockPanel.Height := round(PLH * HMultiplier);
  //средняя панель
    //высота всей панели
  MainPanel.Height := round(ScH * HMultiplier);
    //высота малой части
  LeftPenAdvPanel.Height := round(PAH * HMultiplier);
  RightPenAdvPanel.Height := round(PAH * HMultiplier);
    //ширина частей
  ColorPanel.Width := round(ScW * WMultiplier);
  WhitePanel.Width := round(ScW * WMultiplier);
      //ширина маленьких частей (преим-ва и штрафы)
  ColorPenPanel.Width := ColorPanel.Width div 2 - 3; //с запасом
  WhitePenPanel.Width := ColorPanel.Width div 2 - 3; //с запасом
  ColorAdvPanel.Width := ColorPanel.Width div 2 - 3; //с запасом
  WhiteAdvPanel.Width := ColorPanel.Width div 2 - 3; //с запасом
    //Высота картинок
  CenterMMA12.Height := (MainPanel.Height div 2) - 2; //небольшой запас
  BJJF.Height := (MainPanel.Height div 2) - 2; //небольшой запас

  setFontsAfterResize(HMultiplier);


end;

procedure TMainWindow.saveMainSizes;
begin
  h := MainWindow.Height;                       //ширина и высота окна, на котором все разрабатывалось
  w := MainWindow.Width;
  PlH := PlayerName1.Height;    //ш и в панелей имен
  PlW := PlayerName1.width;
  ScW := ColorPanel.Width;    //ш и в окна очков
  ScH := MainPanel.Height;
  PAH := LeftPenAdvPanel.Height;    //высота панелей преимуществ и штрафов
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
//делаем мигание красным цветом как только остается 10 секунд
//меняем цвет фона и шрифта
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
    Timer2.Interval := StrToInt(str); //количество милисекунд для таймера моргания.
    closeFile(f);
  end
end;

procedure TMainWindow.setCentralPosition;
begin
  self.Top := (screen.Height - self.Height) div 2;
  self.Left := (screen.Width - self.Width) div 2;
end;

end.
