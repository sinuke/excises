program excise;



uses
  FGX.Application,
  FGX.Forms,
  Form.Main in 'Form.Main.pas' {fmMain: TfgForm},
  Form.Details in 'Form.Details.pas' {fmDetails: TfgForm},
  Form.About in 'Form.About.pas' {fmAbout: TfgForm},
  Data.Settings in 'Units\Data.Settings.pas',
  FGX.ActiveNetworkInfo.Android in 'Units\FGX.ActiveNetworkInfo.Android.pas',
  Data.Titles in 'Units\Data.Titles.pas',
  FGX.PanelAnimation in 'Units\FGX.PanelAnimation.pas',
  Data.Consts in 'Units\Data.Consts.pas',
  Assets.Consts in 'Assets.Consts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
