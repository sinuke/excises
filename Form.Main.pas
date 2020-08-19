unit Form.Main;

interface

{$SCOPEDENUMS ON}

uses
  System.Types, System.Classes, FGX.Forms, FGX.Forms.Types, FGX.Controls, FGX.Controls.Types, FGX.Layout, 
  FGX.Layout.Types, FGX.Button.Types, FGX.Memo, FGX.Button, FGX.StaticLabel, FGX.GraphicControl, FGX.Shape,
  FGX.Rectangle, FGX.Edit, FGX.CardPanel, FGX.Platform, FGX.Application.Events, FGX.Line,
  FGX.ActivityIndicator, FGX.Image, FGX.CollectionView,

  System.Net.HTTPClient, Data.Settings, Data.Titles;

type
  TfmMain = class(TfgForm)
    edCode: TfgEdit;
    edSerie: TfgEdit;
    edNumber: TfgEdit;
    cpCheckData: TfgCardPanel;
    btnGet: TfgButton;
    loCodeSerie: TfgLayout;
    aeApp: TfgApplicationEvents;
    lbTitle: TfgLabel;
    btnUpOrAbout: TfgButton;
    loSpacer: TfgLayout;
    loCheckBackground: TfgLayout;
    loTitle: TfgLayout;
    lnDivider: TfgLine;
    loLoading: TfgLayout;
    aiLoading: TfgActivityIndicator;
    lbLoadingTitle: TfgLabel;
    cvExcises_Style1: TfgCollectionViewStyle;
    cvExcises: TfgCollectionView;
    cvExcises_Style2: TfgCollectionViewStyle;
    fgImage1: TfgImage;
    fgLabel1: TfgLabel;
    fgLabel2: TfgLabel;
    fgLayout1: TfgLayout;
    fgLine1: TfgLine;
    fgLabel3: TfgLabel;
    fgLabel4: TfgLabel;
    fgLabel5: TfgLabel;
    fgLabel6: TfgLabel;
    fgLabel7: TfgLabel;
    fgLabel8: TfgLabel;
    fgLabel9: TfgLabel;
    cvExcises_Style3: TfgCollectionViewStyle;
    fgLabel10: TfgLabel;
    loCheck: TfgLayout;
    loMessasge: TfgLayout;
    btnMessageOK: TfgButton;
    imMessageIcon: TfgImage;
    lbMessageTitle: TfgLabel;
    lbMessageText: TfgLabel;
    cvExcises_Style4: TfgCollectionViewStyle;
    fgImage2: TfgImage;
    fgLabel11: TfgLabel;
    fgLabel12: TfgLabel;
    procedure edCodeEnter(Sender: TObject);
    procedure edCodeExit(Sender: TObject);
    procedure fgFormCreate(Sender: TObject);
    procedure fgFormDestroy(Sender: TObject);
    procedure aeAppSaveApplicationState(Sender: TObject);
    procedure fgFormShow(Sender: TObject);
    procedure edCodeChanging(Sender: TObject);
    procedure edSerieChanging(Sender: TObject);
    procedure fgFormVirtualKeyboardFrameChanged(Sender: TObject; const AVKFrame: TRectF);
    procedure loCheckBackgroundTap(Sender: TObject);
    procedure btnUpOrAboutTap(Sender: TObject);
    procedure btnGetTap(Sender: TObject);
    procedure fgFormSafeAreaChanged(Sender: TObject; const AScreenInsets: TRectF);
    function cvExcisesGetItemCount(Sender: TObject): Integer;
    function cvExcisesGetItemStyle(Sender: TObject; const AIndex: Integer): string;
    procedure cvExcisesBindItem(Sender: TObject; const AIndex: Integer; const AStyle: string;
      const AItem: TfgItemWrapper);
    procedure cvExcisesTapItem(Sender: TObject; const AIndex: Integer);
    procedure fgFormKey(Sender: TObject; const AKey: TfgKey; var AHandled: Boolean);
    procedure btnMessageOKTap(Sender: TObject);
  private
    { Private declarations }
    FSettings: TSettings;
    FTitles: TTitles;
    FSettingsFileName: string;
    FCheckIsShowing: Boolean;
    FLoading: Boolean;
    FStatusBarHeight: Single;
    FBackPressed: Int64;

    FCode: string;
    FSerie: string;
    FNumber: string;

    FHttpClient: THTTPClient;
    FAsyncResult: IAsyncResult;
    FRequestData: TStringStream;
    FRecievedData: TStringStream;
    FIsAnimating: Boolean;

    procedure ButtonChangeState;
    procedure LoadingHide;
    procedure LoadingShow;
    procedure ShowDetails(const AExcise: TExciseItem);
    procedure ShowAbout;
    procedure OnGetDataCallback(const AsyncResult: IAsyncResult);

    procedure SetCustomEnableState(const AEdit: TfgEdit; const AEnabled: Boolean);

    procedure MyMessageShow(const ATitle, AText, AIconName: string);
    procedure MyMessageHide;

    function ParseXml(const AXml: string; var ACompany, AUNP, ADate: string): Boolean;
  public
    { Public declarations }
    property IsAnimating: Boolean read FIsAnimating write FIsAnimating;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.xfm}

uses
  System.SysUtils,
  System.Threading,
  System.DateUtils,
  System.UITypes,
  System.IOUtils,
  System.NetConsts,
  System.Net.URLClient,
  FGX.Application,
  FGX.Animation,
  FGX.PanelAnimation,
  FGX.Dialogs,
  FGX.Log,
  FGX.Toasts,
  FGX.Controls.Android,
  FGX.Platform.Android,
  FGX.Helpers.Android,
  FGX.VirtualKeyboard,
  FGX.ActiveNetworkInfo.Android,
  Android.Api.ActivityAndView,
  Android.Api.FGX.Core,
  Android.Api.JavaTypes,
  Androidapi.Jni,
  Android.Api.Camera,
  Android.Api.Widgets,
  Java.Bridge,
  Assets.Consts,
  Form.Details,
  Form.About,
  Xml.XMLDoc,
  Xml.XMLIntf,
  Data.Consts;

procedure TfmMain.aeAppSaveApplicationState(Sender: TObject);
begin
  FSettings.LastCode := edCode.Text;
  FSettings.LastNumber := edNumber.Text;
  FSettings.LastSerie := string.UpperCase(edSerie.Text, loUserLocale);
  FSettings.SaveToFile(FSettingsFileName);
end;

procedure TfmMain.btnGetTap(Sender: TObject);
begin
  if not FCheckIsShowing then
    Exit;

  if TActiveNetworkInfo.IsConnected then
    begin
      LoadingShow;

      FCode := edCode.Text;
      FNumber := edNumber.Text;
      FSerie := edSerie.Text;

      FRecievedData.Clear;
      FRequestData.Clear;
      FRequestData.WriteString(Format(REQUEST_DATA, [FCode, FSerie, FNumber]));
      FRequestData.Position := 0;

      FAsyncResult := FHttpClient.BeginPost(OnGetDataCallback, URL, FRequestData, FRecievedData);
    end
  else
    begin
      TfgVirtualKeyboard.Hide;
      MyMessageShow(MSG_NO_CONNECTION_TITLE, MSG_NO_CONNECTION_TEXT, R.Bitmap.MESSAGES_NO_CONNECTION);
    end;
end;

procedure TfmMain.btnMessageOKTap(Sender: TObject);
begin
  if not IsAnimating then
    MyMessageHide;
end;

procedure TfmMain.btnUpOrAboutTap(Sender: TObject);
begin
  if btnUpOrAbout.ImageName = R.Bitmap.UP then
    begin
      if not FCheckIsShowing and (not FLoading) and (not IsAnimating) then
        begin
          IsAnimating := True;
          loCheckBackground.Opacity := 0;
          loCheckBackground.Visible := True;

          cpCheckData.BackgroundColorName := R.Color.COLORS_WHITE;
          TfgPanelAnimation.ShowPanel(cpCheckData, - 206, ANIMATION_DIRATION,
            procedure
            begin
              btnUpOrAbout.ImageName := R.Bitmap.ABOUT;
              loTitle.HitTest := True;
              cpCheckData.Margins.Bottom := -16;
              IsAnimating := False;
              FCheckIsShowing := True;
            end);

          TfgAnimationHelper.FadeIn(loCheckBackground, [TfgAnimationOption.StartFromCurrent], ANIMATION_DIRATION,
            procedure
            begin
              loCheckBackground.Opacity := 1;
            end);
        end;
    end
  else
  if (btnUpOrAbout.ImageName = R.Bitmap.ABOUT) and (not FLoading) and (not IsAnimating) and (Sender is TfgButton) then
    ShowAbout;
end;

procedure TfmMain.loCheckBackgroundTap(Sender: TObject);
begin
  if FCheckIsShowing and (not FLoading) and (not IsAnimating) then
    begin
      TfgVirtualKeyboard.Hide;
      FCheckIsShowing := False;

      IsAnimating := True;
      loTitle.HitTest := False;
      cpCheckData.Margins.Bottom := -16;
      TfgPanelAnimation.HidePanel(cpCheckData, 206, ANIMATION_DIRATION,
        procedure
        begin
          if loMessasge.Visible then
            begin
              loMessasge.Opacity := 0;
              loMessasge.Visible := False;
              loCheck.Visible := True;
              loTitle.Visible := True;
            end;

          cpCheckData.BackgroundColorName := R.Color.COLORS_COLOR1;
          btnUpOrAbout.ImageName := R.Bitmap.UP;
          cpCheckData.Margins.Bottom := -222;
          IsAnimating := False;
        end);

      TfgAnimationHelper.FadeOut(loCheckBackground, [TfgAnimationOption.StartFromCurrent], ANIMATION_DIRATION,
        procedure
        begin
          loCheckBackground.Visible := False;
        end);
    end;
end;

procedure TfmMain.cvExcisesBindItem(Sender: TObject; const AIndex: Integer; const AStyle: string;
  const AItem: TfgItemWrapper);
var
  LLabel: TfgLabel;
begin
  if AStyle = 'ExciseItemStyle' then
    begin
      AItem.GetControlByLookupName<TfgLabel>('Index').Text := AIndex.ToString;
      AItem.GetControlByLookupName<TfgLabel>('Company').Text := FSettings.Excises[FSettings.Excises.Count - AIndex].Company;

      LLabel := AItem.GetControlByLookupName<TfgLabel>('CodeTitle');
      LLabel.Size.Width := LLabel.MeasureSize(TfgMeasuringSpecification.Unspecified, 0, TfgMeasuringSpecification.Fixed, 24).Width;
      LLabel.Realign;

      LLabel := AItem.GetControlByLookupName<TfgLabel>('Code');
      LLabel.Text := FSettings.Excises[FSettings.Excises.Count - AIndex].Code;
      LLabel.Size.Width := LLabel.MeasureSize(TfgMeasuringSpecification.Unspecified, 0, TfgMeasuringSpecification.Fixed, 24).Width;
      LLabel.Realign;

      LLabel := AItem.GetControlByLookupName<TfgLabel>('SerieTitle');
      LLabel.Size.Width := LLabel.MeasureSize(TfgMeasuringSpecification.Unspecified, 0, TfgMeasuringSpecification.Fixed, 24).Width;
      LLabel.Realign;

      LLabel := AItem.GetControlByLookupName<TfgLabel>('Serie');
      LLabel.Text := FSettings.Excises[FSettings.Excises.Count - AIndex].Serie;
      LLabel.Size.Width := LLabel.MeasureSize(TfgMeasuringSpecification.Unspecified, 0, TfgMeasuringSpecification.Fixed, 24).Width;
      LLabel.Realign;

      LLabel := AItem.GetControlByLookupName<TfgLabel>('NumberTitle');
      LLabel.Size.Width := LLabel.MeasureSize(TfgMeasuringSpecification.Unspecified, 0, TfgMeasuringSpecification.Fixed, 24).Width;
      LLabel.Realign;

      LLabel := AItem.GetControlByLookupName<TfgLabel>('Number');
      LLabel.Text := FSettings.Excises[FSettings.Excises.Count - AIndex].Number;
      LLabel.Size.Width := LLabel.MeasureSize(TfgMeasuringSpecification.Unspecified, 0, TfgMeasuringSpecification.Fixed, 24).Width;
      LLabel.Realign;

      LLabel := AItem.GetControlByLookupName<TfgLabel>('Date');
      LLabel.Text := FormatDateTime('yyyy.mm.dd hh:nn:ss', FSettings.Excises[FSettings.Excises.Count - AIndex].CheckingDate);

      LLabel := AItem.GetControlByLookupName<TfgLabel>('Title');
      LLabel.Text := FSettings.Excises[FSettings.Excises.Count - AIndex].Title;
    end
  else
  if AStyle = 'TopItemStyle' then
    begin
      AItem.Item.Size.Height := FStatusBarHeight;
      AItem.Item.Realign;
    end
  else
  if AStyle = 'EmptyListStyle' then
    begin
      AItem.Item.Size.Height := Size.Height;
      AItem.Item.Realign;
    end;
end;

function TfmMain.cvExcisesGetItemCount(Sender: TObject): Integer;
begin
  if FSettings <> nil then
    begin
      if FSettings.Excises.Count = 0 then
        Result := 1
      else
        Result := FSettings.Excises.Count + 2
    end
  else
    Result := 0;
end;

function TfmMain.cvExcisesGetItemStyle(Sender: TObject; const AIndex: Integer): string;
begin
  if (FSettings <> nil) and (FSettings.Excises.Count = 0) then
    Result := 'EmptyListStyle'
  else
  if FSettings <> nil then
    begin
      if AIndex = 0 then
        Result := 'TopItemStyle'
      else
      if AIndex = FSettings.Excises.Count + 1 then
        Result := 'BottomItemStyle'
      else
        Result := 'ExciseItemStyle';
    end;
end;

procedure TfmMain.cvExcisesTapItem(Sender: TObject; const AIndex: Integer);
begin
  if (not FLoading) and (not IsAnimating) then
    ShowDetails(FSettings.Excises[FSettings.Excises.Count - AIndex]);
end;

procedure TfmMain.OnGetDataCallback(const AsyncResult: IAsyncResult);
var
  LAsyncResponse: IHTTPResponse;
  LExcise: TExciseItem;
  LCompany, LDate, LUNP, LTitle: string;
begin
  try
    try
      LAsyncResponse := THTTPClient.EndAsyncHTTP(AsyncResult);
    except
      TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          MyMessageShow(MSG_ERROR_TITLE, MSG_ERROR_TEXT, R.Bitmap.MESSAGES_ERROR);
        end);
    end;

    if AsyncResult.IsCancelled then
      TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          MyMessageShow(MSG_ERROR_TITLE, MSG_ERROR_TEXT, R.Bitmap.MESSAGES_ERROR);
        end)
    else
      begin
        if LAsyncResponse.StatusCode = 200 then
          TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
              if ParseXml(FRecievedData.DataString, LCompany, LUNP, LDate) then
                begin
                  LTitle := string.Empty;
                  LExcise := TExciseItem.Create;
                  LExcise.Code := FCode;
                  LExcise.Number := FNumber;
                  LExcise.Serie := FSerie;
                  if FTitles.TryGetValue(FCode, LTitle) then
                    LExcise.Title := LTitle;
                  LExcise.CheckingDate := Now;
                  LExcise.UNP := LUNP;
                  LExcise.Date := LDate;
                  LExcise.Company := LCompany;
                  FSettings.Excises.Add(LExcise);
                  cvExcises.ReloadItems;
                  ShowDetails(LExcise);
                end
              else
                MyMessageShow(MSG_NO_DATA_TITLE, MSG_NO_DATA_TEXT, R.Bitmap.MESSAGES_NO_DATA);
            end)
        else
          TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
              MyMessageShow(MSG_ERROR_TEXT, MSG_REQUEST_ERROR_TEXT, R.Bitmap.MESSAGES_ERROR);
            end);
      end;
  finally
    LAsyncResponse := nil;
    TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        LoadingHide;
      end);
  end;
end;

procedure TfmMain.edCodeChanging(Sender: TObject);
begin
  ButtonChangeState;
end;

procedure TfmMain.edCodeEnter(Sender: TObject);
var
  LEdit: TfgEdit absolute Sender;
begin
  LEdit.BackgroundName := R.Bitmap.EDIT_FOCUSED;
end;

procedure TfmMain.edCodeExit(Sender: TObject);
var
  LEdit: TfgEdit absolute Sender;
begin
  LEdit.BackgroundName := R.Bitmap.EDIT_UNFOCUSED;
end;

procedure TfmMain.edSerieChanging(Sender: TObject);
begin
  edSerie.Text := string.UpperCase(edSerie.Text, loUserLocale);
  edSerie.SelectionStart := edSerie.Text.Length;
  ButtonChangeState;
end;

procedure TfmMain.fgFormCreate(Sender: TObject);
begin
  FBackPressed := 0;

  FSettings := TSettings.Create;
  FSettingsFileName := TPath.Combine(Tpath.GetDocumentsPath, 'settings.txt');
  FSettings.LoadFromFile(FSettingsFileName);

  FTitles := TTitles.Create;
  FTitles.LoadFromAsset(R.Files.TITLES);

  FHttpClient := THTTPClient.Create;
  FHttpClient.ContentType := 'text/xml';
  FHttpClient.UserAgent := 'kSOAP/2.0';
  FHttpClient.Accept := 'text/xml';
  FHttpClient.AcceptCharSet := 'utf-8';
  FHttpClient.ConnectionTimeout := 5000;
  FHttpClient.ResponseTimeout := 5000;
  FHttpClient.CustomHeaders['SOAPAction'] := SOAP_ACTION;

  FRecievedData := TStringStream.Create(string.Empty, TEncoding.UTF8);
  FRequestData := TStringStream.Create(string.Empty, TEncoding.UTF8);

  FCheckIsShowing := True;
  FLoading := False;
  FIsAnimating := False;
end;

procedure TfmMain.fgFormDestroy(Sender: TObject);
begin
  FreeAndNil(FSettings);
  FreeAndNil(FTitles);
  FreeAndNil(FHttpClient);
  FreeAndNil(FRecievedData);
  FreeAndNil(FRequestData);
end;

procedure TfmMain.fgFormKey(Sender: TObject; const AKey: TfgKey; var AHandled: Boolean);
begin
  if (AKey.Action = TfgKeyAction.Up) and (AKey.Code = vkHardwareBack) then
    begin
      AHandled := True;
      if not IsAnimating then
        begin
          if loMessasge.Visible then
            MyMessageHide
          else
          if FBackPressed + 2000 < MilliSecondOfTheDay(Now) then
            begin
              FBackPressed := MilliSecondOfTheDay(Now);
              TfgToast.Show(MSG_TOAST);
            end
          else
          if FBackPressed + 2000 > MilliSecondOfTheDay(Now) then
            AHandled := False;
        end;
    end;
end;

procedure TfmMain.fgFormSafeAreaChanged(Sender: TObject; const AScreenInsets: TRectF);
begin
  FStatusBarHeight := AScreenInsets.Top;
end;

procedure TfmMain.fgFormShow(Sender: TObject);
var
  LEdit: JEditText;
begin
  edCode.Text := FSettings.LastCode;
  edNumber.Text := FSettings.LastNumber;
  edSerie.Text := FSettings.LastSerie;
  ButtonChangeState;

  LEdit := TJEditText.Wrap(edSerie.Handle.View);
  LEdit.setInputType(TJInputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS or TJInputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
end;

procedure TfmMain.fgFormVirtualKeyboardFrameChanged(Sender: TObject; const AVKFrame: TRectF);
begin
  loSpacer.Size.Height := AVKFrame.Size.Height;
end;

procedure TfmMain.ButtonChangeState;
begin
  btnGet.Enabled := (not edCode.Text.IsEmpty) and (not edSerie.Text.IsEmpty) and (not edNumber.Text.IsEmpty);
  btnGet.HitTest := btnGet.Enabled;
  if btnGet.Enabled then
    btnGet.BackgroundName := R.Bitmap.BUTTON_ENABLED
  else
    btnGet.BackgroundName := R.Bitmap.BUTTON_DISABLED;
end;

procedure TfmMain.LoadingHide;
begin
  SetCustomEnableState(edCode, True);
  SetCustomEnableState(edSerie, True);
  SetCustomEnableState(edNumber, True);

  btnUpOrAbout.Enabled := True;
  btnUpOrAbout.ImageName := R.Bitmap.ABOUT;

  loLoading.Visible := False;
  btnGet.Visible := True;

  FLoading := False;
end;

procedure TfmMain.LoadingShow;
begin
  FLoading := True;

  btnGet.Visible := False;
  loLoading.Visible := True;

  btnUpOrAbout.Enabled := False;
  btnUpOrAbout.ImageName := R.Bitmap.ABOUT_DISABLED;

  SetCustomEnableState(edCode, False);
  SetCustomEnableState(edSerie, False);
  SetCustomEnableState(edNumber, False);
end;

procedure TfmMain.SetCustomEnableState(const AEdit: TfgEdit; const AEnabled: Boolean);
begin
  AEdit.Enabled := AEnabled;
  if AEnabled then
    begin
      AEdit.BackgroundName := R.Bitmap.EDIT_UNFOCUSED;
      AEdit.ColorName := R.Color.COLORS_PRIMARYTEXT;
    end
  else
    begin
      AEdit.BackgroundName := R.Bitmap.EDIT_DISABLED;
      AEdit.ColorName := R.Color.COLORS_SECONDARYTEXT;
    end;
end;

procedure TfmMain.ShowAbout;
begin
  TfgVirtualKeyboard.Hide;

  fmAbout := TfmAbout.Create(Self);
  fmAbout.IsAnimating := True;
  TfgAnimationHelper.ShowForm(fmAbout, [TfgAnimationOption.StartFromCurrent], ANIMATION_DIRATION,
    procedure
    begin
      fmAbout.IsAnimating := False;
    end);
end;

procedure TfmMain.ShowDetails(const AExcise: TExciseItem);
begin
  fmDetails := TfmDetails.Create(Self);
  fmDetails.IsAnimating := True;
  fmDetails.Excise := AExcise;
  TfgAnimationHelper.ShowForm(fmDetails, [TfgAnimationOption.StartFromCurrent], ANIMATION_DIRATION,
    procedure
    begin
      fmDetails.IsAnimating := False;
    end);
end;

procedure TfmMain.MyMessageHide;
begin
  IsAnimating := True;
  TfgAnimationHelper.FadeOut(loMessasge, [TfgAnimationOption.StartFromCurrent], ANIMATION_DIRATION,
    procedure
    begin
      loMessasge.Visible := False;
      loCheck.Visible := True;
      loTitle.Visible := True;

      IsAnimating := False;
    end);
end;

procedure TfmMain.MyMessageShow(const ATitle, AText, AIconName: string);
begin
  LoadingHide;

  lbMessageTitle.Text := ATitle;
  lbMessageText.Text := AText;
  imMessageIcon.ImageName := AIconName;

  loMessasge.Visible := True;

  IsAnimating := True;
  TfgAnimationHelper.FadeIn(loMessasge, [TfgAnimationOption.StartFromCurrent], ANIMATION_DIRATION,
    procedure
    begin
      loCheck.Visible := False;
      loTitle.Visible := False;

      IsAnimating := False;
    end);
end;

function TfmMain.ParseXml(const AXml: string; var ACompany, AUNP, ADate: string): Boolean;
var
  XML: TXMLDocument;
  ResultNode: IXMLNode;
begin
  Result := False;
  XML := TXMLDocument.Create(Self);
  try
    try
      XML.LoadFromXML(AXml);
    except
      FreeAndNil(XML);
    end;

    XML.Active := True;

    try
      ResultNode := XML.ChildNodes[0].ChildNodes[0].ChildNodes[0].ChildNodes[0];
    except
      FreeAndNil(XML);
    end;

    if ResultNode.HasChildNodes then
      begin
        if string.ToInteger(ResultNode.ChildNodes['IsFound'].Text) > 0 then
          begin
            ACompany := ResultNode.ChildNodes['Rel'].ChildNodes['WSRel'].ChildNodes['Name'].Text;
            AUNP := ResultNode.ChildNodes['Rel'].ChildNodes['WSRel'].ChildNodes['UNP'].Text;
            ADate := ResultNode.ChildNodes['Rel'].ChildNodes['WSRel'].ChildNodes['Date'].Text;
            Result := True;
          end
      end;
  finally
    XML.Active := False;
    ResultNode := nil;
    FreeAndNil(XML);
  end;
end;

end.
