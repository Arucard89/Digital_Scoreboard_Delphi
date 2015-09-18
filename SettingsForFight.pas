unit SettingsForFight;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Spin, ExtCtrls;
 // сделать обработчик кнопки с установкой значений
type
  TFightSettings = class(TForm)
    ColorLabeledEdit: TLabeledEdit;
    WhiteLabeledEdit: TLabeledEdit;
    Label1: TLabel;
    RoundTimeSpinEdit: TSpinEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Procedure setCentralPosition; //установка окна по середине экрана
  public
    { Public declarations }
  end;

var
  FightSettings: TFightSettings;

implementation

{$R *.dfm}


procedure TFightSettings.FormCreate(Sender: TObject);
begin
  setCentralPosition;
end;

procedure TFightSettings.setCentralPosition;
begin
  self.Top := (screen.Height - self.Height) div 2;
  self.Left := (screen.Width - self.Width) div 2;
end;

end.
