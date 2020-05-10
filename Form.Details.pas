unit Form.Details;

interface

{$SCOPEDENUMS ON}

uses
  System.Types, System.Classes, FGX.Forms, FGX.Forms.Types, FGX.Controls, FGX.Controls.Types, FGX.Layout, 
  FGX.Layout.Types, FGX.Button.Types, FGX.Button, FGX.Image, FGX.StaticLabel, Data.Settings, FGX.Spacer;

type
  TfmDetails = class(TfgForm)
    loNav: TfgLayout;
    btnBack: TfgButton;
    loExcise: TfgLayout;
    imExcise: TfgImage;
    loExciseCenter: TfgLayout;
    loInfo: TfgLayout;
    lbCodeSerie: TfgLabel;
    lbNumber: TfgLabel;
    lbTitle: TfgLabel;
    lbUNPTitle: TfgLabel;
    lbUNP: TfgLabel;
    lbDateTitle: TfgLabel;
    lbDate: TfgLabel;
    lbCompanyTitle: TfgLabel;
    lbCompany: TfgLabel;
    spSpacer: TfgSpacer;
    lbCheckDate: TfgLabel;
    procedure fgFormSafeAreaChanged(Sender: TObject; const AScreenInsets: TRectF);
    procedure fgFormCreate(Sender: TObject);
    procedure btnBackTap(Sender: TObject);
    procedure fgFormKey(Sender: TObject; const AKey: TfgKey; var AHandled: Boolean);
    procedure fgFormDestroy(Sender: TObject);
    procedure fgFormShow(Sender: TObject);
  private
    FIsAnimating: Boolean;
    FExcise: TExciseItem;
    { Private declarations }
  public
    { Public declarations }

    property IsAnimating: Boolean read FIsAnimating write FIsAnimating;
    property Excise: TExciseItem read FExcise write FExcise;

    procedure CloseForm;
  end;

var
  fmDetails: TfmDetails;

implementation

{$R *.xfm}

uses
  System.SysUtils,
  System.UITypes,
  FGX.Application,
  FGX.Dialogs,
  FGX.Log,
  FGX.Animation,
  Data.Consts;

procedure TfmDetails.btnBackTap(Sender: TObject);
begin
  if not IsAnimating then
    CloseForm;
end;

procedure TfmDetails.CloseForm;
begin
  IsAnimating := True;
  TfgAnimationHelper.HideForm(Self, [TfgAnimationOption.StartFromCurrent, TfgAnimationOption.ReleaseOnFinish],
    ANIMATION_DIRATION,
    procedure
    begin
    end);
end;

procedure TfmDetails.fgFormCreate(Sender: TObject);
begin
  IsAnimating := False;
  FExcise := nil;
end;

procedure TfmDetails.fgFormDestroy(Sender: TObject);
begin
  FExcise := nil;
end;

procedure TfmDetails.fgFormKey(Sender: TObject; const AKey: TfgKey; var AHandled: Boolean);
begin
  if (AKey.Action = TfgKeyAction.Up) and (AKey.Code = vkHardwareBack) then
    begin
      AHandled := True;
      if not IsAnimating then
        CloseForm;
    end;
end;

procedure TfmDetails.fgFormSafeAreaChanged(Sender: TObject; const AScreenInsets: TRectF);
begin
  loNav.Size.Height := AScreenInsets.Top + 56;
  loNav.Padding.Top := AScreenInsets.Top;
  loNav.Realign;
end;

procedure TfmDetails.fgFormShow(Sender: TObject);
var
  h: Single;
begin
  if FExcise <> nil then
    begin
      lbCodeSerie.Text := Format('%s / %s', [FExcise.Code, FExcise.Serie]);
      lbCodeSerie.Size.Height := lbCodeSerie.MeasureSize(TfgMeasuringSpecification.Fixed, 224,
                                                         TfgMeasuringSpecification.Unspecified, 0).Height;
      lbCodeSerie.Realign;

      lbNumber.Text := FExcise.Number;
      lbNumber.Size.Height := lbNumber.MeasureSize(TfgMeasuringSpecification.Fixed, 224,
                                                   TfgMeasuringSpecification.Unspecified, 0).Height;
      lbNumber.Realign;

      lbTitle.Text := FExcise.Title;
      lbTitle.Size.Height := lbTitle.MeasureSize(TfgMeasuringSpecification.Fixed, 224,
                                                 TfgMeasuringSpecification.Unspecified, 0).Height;
      lbTitle.Realign;

      h := lbTitle.Size.Height + 4 + lbCodeSerie.Size.Height + 4 + lbNumber.Size.Height;
      lbTitle.RelativePosition.Top := (256 - h) / 2;
      lbCodeSerie.RelativePosition.Top := lbTitle.RelativePosition.Top + lbTitle.Size.Height + 4;
      lbNumber.RelativePosition.Top := lbCodeSerie.RelativePosition.Top + lbCodeSerie.Size.Height + 4;

      lbUNP.Text := FExcise.UNP;
      lbDate.Text := FExcise.Date;
      lbCompany.Text := FExcise.Company;
      lbCompany.Size.Height := lbCompany.MeasureSize(TfgMeasuringSpecification.Fixed, lbCompany.Size.Width,
                                                     TfgMeasuringSpecification.Unspecified, 0).Height;
      lbCompany.Realign;

      lbCheckDate.Text := 'Проверка: ' + FormatDateTime('yyyy.mm.dd hh:nn:ss', FExcise.CheckingDate);
    end;
end;

end.
