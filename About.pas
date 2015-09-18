unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TInfoForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Procedure setCentralPosition; //установка окна по середине экрана
  public
    { Public declarations }
  end;

var
  InfoForm: TInfoForm;

implementation

{$R *.dfm}

procedure TInfoForm.FormCreate(Sender: TObject);
begin
  Label1.Caption:= 'Электронное табло для Бразильского Джиу Джитсу и Грэпплинга'+ #13#10+ #13#10+
  'Программа создана Ревенковым Кириллом'+ #13#10+ 'под руководством Азаркина Анатолия Геннадьевича'+ #13#10 + #13#10+
  'Распространяется только с согласия вышеуказанных лиц'+ #13#10 + #13#10+
  'Center MMA 12'+ #13#10+ #13#10+
  '2013 год'+ #13#10+ 
  'v 0.95';
  setCentralPosition
  //self.Show
end;

procedure TInfoForm.setCentralPosition;
begin
  self.Top := (screen.Height - self.Height) div 2;
  self.Left := (screen.Width - self.Width) div 2;
end;

end.
