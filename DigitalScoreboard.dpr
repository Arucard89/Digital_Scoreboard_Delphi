program DigitalScoreboard;

uses
  Forms,
  Scoreboard in 'Scoreboard.pas' {MainWindow},
  SettingsForFight in 'SettingsForFight.pas' {FightSettings},
  About in 'About.pas' {InfoForm},
  Results in 'Results.pas' {ResultForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Цифровое табло';
  Application.HelpFile := '';
  Application.CreateForm(TMainWindow, MainWindow);
  //Application.CreateForm(TResultForm, ResultForm);
  //Application.CreateForm(TInfoForm, InfoForm);
  //Application.CreateForm(TFightSettings, FightSettings);
  Application.Run;
end.
