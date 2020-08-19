unit Form.About;

interface

{$SCOPEDENUMS ON}

uses
  System.Types, System.Classes, System.SysUtils, FGX.Forms, FGX.Forms.Types, FGX.Controls, FGX.Controls.Types, FGX.Layout,
  FGX.Layout.Types, FGX.Button.Types, FGX.Button, FGX.Image, FGX.StaticLabel;

type
  TfmAbout = class(TfgForm)
    loBackground: TfgLayout;
    imFGX: TfgImage;
    loFGX: TfgLayout;
    lbCopyright: TfgLabel;
    lbVersion: TfgLabel;
    lbMailTo: TfgLabel;
    loNav: TfgLayout;
    btnBack: TfgButton;
    lbAboutTitle: TfgLabel;
    loLogo: TfgLayout;
    imLogo: TfgImage;
    lbTitle: TfgLabel;
    fgLabel1: TfgLabel;
    procedure fgFormSafeAreaChanged(Sender: TObject; const AScreenInsets: TRectF);
    procedure fgFormCreate(Sender: TObject);
    procedure fgFormKey(Sender: TObject; const AKey: TfgKey; var AHandled: Boolean);
    procedure lbMailToTap(Sender: TObject);
    procedure btnBackTap(Sender: TObject);
    procedure imFGXTap(Sender: TObject);
  private
    { Private declarations }
    FIsAnimating: Boolean;
  public
    { Public declarations }
    property IsAnimating: Boolean read FIsAnimating write FIsAnimating;

    procedure CloseForm;
  end;

var
  fmAbout: TfmAbout;

implementation

{$R *.xfm}

uses
  System.UITypes,
  System.DateUtils,
  FGX.Animation,
  FGX.Application,
  FGX.Dialogs,
  FGX.Log,
  Data.Consts;

procedure TfmAbout.btnBackTap(Sender: TObject);
begin
  if not IsAnimating then
    CloseForm;
end;

procedure TfmAbout.CloseForm;
begin
  IsAnimating := True;
  TfgAnimationHelper.HideForm(Self, [TfgAnimationOption.StartFromCurrent, TfgAnimationOption.ReleaseOnFinish],
    ANIMATION_DIRATION);
end;

procedure TfmAbout.fgFormCreate(Sender: TObject);
begin
  IsAnimating := False;
  lbCopyright.Text := Format(COPYRIGHT, [YearOf(Now)]);
  lbVersion.Text := Format(VERSION, [Application.Info.Version]);
end;

procedure TfmAbout.fgFormKey(Sender: TObject; const AKey: TfgKey; var AHandled: Boolean);
begin
  if (AKey.Action = TfgKeyAction.Up) and (AKey.Code = vkHardwareBack) then
    begin
      AHandled := True;
      if not IsAnimating then
        CloseForm;
    end;
end;

procedure TfmAbout.fgFormSafeAreaChanged(Sender: TObject; const AScreenInsets: TRectF);
begin
  loNav.Size.Height := AScreenInsets.Top + 56;
  loNav.Padding.Top := AScreenInsets.Top;
  loNav.Realign;
end;

procedure TfmAbout.imFGXTap(Sender: TObject);
begin
  Application.OpenURL(FGX_URL);
end;

procedure TfmAbout.lbMailToTap(Sender: TObject);
begin
  Application.OpenURL(MAIL_TO);
end;

end.
