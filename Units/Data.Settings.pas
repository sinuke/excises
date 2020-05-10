unit Data.Settings;

interface

uses System.Generics.Collections,
     System.Generics.Defaults;

type
  TExciseItem = class
  private
    FDate: string;
    FCode: string;
    FCompany: string;
    FSerie: string;
    FCheckingDate: TDateTime;
    FNumber: string;
    FUNP: string;
    FTitle: string;
  public
    constructor Create;

    property Code: string read FCode write FCode;
    property Serie: string read FSerie write FSerie;
    property Number: string read FNumber write FNumber;
    property UNP: string read FUNP write FUNP;
    property Date: string read FDate write FDate;
    property Company: string read FCompany write FCompany;
    property CheckingDate: TDateTime read FCheckingDate write FCheckingDate;
    property Title: string read FTitle write FTitle;

    function ToString: string; override;
    procedure LoadFormJsonObject(const AJson: string);
  end;
  {
  TExcisesList = TObjectList<TExciseItem>;

  TExcises = class(TExcisesList)
  end;
  }

  TExcises = TObjectList<TExciseItem>;

  TSettings = class
  private
    FExcises: TExcises;
    FLastCode: string;
    FLastSerie: string;
    FLastNumber: string;
  public
    constructor Create;
    destructor Destroy; override;

    property Excises: TExcises read FExcises write FExcises;
    property LastCode: string read FLastCode write FLastCode;
    property LastSerie: string read FLastSerie write FLastSerie;
    property LastNumber: string read FLastNumber write FLastNumber;

    procedure LoadFromFile(const AFileName: string);
    procedure SaveToFile(const AFileName: string);
  end;

implementation

{ TExciseItem }

uses System.SysUtils,
     System.IOUtils,
     System.DateUtils,
     System.JSON;

constructor TExciseItem.Create;
begin
  FDate := string.Empty;
  FCode := string.Empty;
  FCompany := string.Empty;
  FSerie := string.Empty;
  FCheckingDate := Now;
  FNumber := string.Empty;
  FUNP := string.Empty;
  FTitle := string.Empty;
end;

procedure TExciseItem.LoadFormJsonObject(const AJson: string);
var
  LJsonObj: TJSONObject;
  s: string;
begin
  LJsonObj := TJSONObject.ParseJSONValue(AJson, False, True) as TJSONObject;
  try
    if LJsonObj.TryGetValue('code', s) then
      FCode := s;

    if LJsonObj.TryGetValue('date', s) then
      FDate := s;

    if LJsonObj.TryGetValue('company', s) then
      FCompany := s;

    if LJsonObj.TryGetValue('serie', s) then
      FSerie := s;

    if LJsonObj.TryGetValue('checking', s) then
      FCheckingDate := ISO8601ToDate(s, True);

    if LJsonObj.TryGetValue('number', s) then
      FNumber := s;

    if LJsonObj.TryGetValue('unp', s) then
      FUNP := s;

    if LJsonObj.TryGetValue('title', s) then
      FTitle := s;
  finally
    FreeAndNil(LJsonObj);
  end;
end;

function TExciseItem.ToString: string;
var
  LJsonObj: TJSONObject;
begin
  Result := '{}';
  LJsonObj := TJSONObject.Create;
  try
    LJsonObj.AddPair('code', FCode);
    LJsonObj.AddPair('date', FDate);
    LJsonObj.AddPair('company', FCompany);
    LJsonObj.AddPair('serie', FSerie);
    LJsonObj.AddPair('checking', DateToISO8601(TTimeZone.Local.ToUniversalTime(FCheckingDate), True));
    LJsonObj.AddPair('number', FNumber);
    LJsonObj.AddPair('unp', FUNP);
    LJsonObj.AddPair('title', FTitle);
    Result := LJsonObj.ToString;
  finally
    FreeAndNil(LJsonObj);
  end;
end;

{ TSettings }

constructor TSettings.Create;
begin
  FExcises := TExcises.Create;
  FLastCode := string.Empty;
  FLastSerie := string.Empty;
  FLastNumber := string.Empty;
end;

destructor TSettings.Destroy;
begin
  FreeAndNil(FExcises);
  inherited;
end;

procedure TSettings.LoadFromFile(const AFileName: string);
var
  LJsonObj: TJSONObject;
  LJsonArr: TJSONArray;
  LExciseItem: TExciseItem;
  i: Integer;
  s: string;
begin
  if TFile.Exists(AFileName) then
    begin
      LJsonObj := TJSONObject.ParseJSONValue(TFile.ReadAllText(AFileName), False, True) as TJSONObject;
      try
        if LJsonObj.TryGetValue('lastcode', s) then
          FLastCode := s;

        if LJsonObj.TryGetValue('lastserie', s) then
          FLastSerie := s;

         if LJsonObj.TryGetValue('lastnumber', s) then
          FLastNumber := s;

         if LJsonObj.TryGetValue('excises', LJsonArr) then
           begin
             for i := 0 to LJsonArr.Count - 1 do
               begin
                 LExciseItem := TExciseItem.Create;
                 LExciseItem.LoadFormJsonObject(LJsonArr.Items[i].ToString);
                 FExcises.Add(LExciseItem);
               end;
           end;
      finally
        FreeAndNil(LJsonObj);
      end;
    end;
end;

procedure TSettings.SaveToFile(const AFileName: string);
var
  LJsonObj: TJSONObject;
  LJsonArr: TJSONArray;
  LJsonArrObj: TJSONObject;
  i: Integer;
begin
  LJsonObj := TJSONObject.Create;
  LJsonArr := TJSONArray.Create;
  try
    LJsonObj.AddPair('lastcode', FLastCode);
    LJsonObj.AddPair('lastserie', FLastSerie);
    LJsonObj.AddPair('lastnumber', FLastNumber);

    for i := 0 to FExcises.Count - 1 do
      begin
        LJsonArrObj := TJSONObject.ParseJSONValue(FExcises[i].ToString, False, True) as TJSONObject;
        LJsonArr.AddElement(LJsonArrObj);
      end;
    LJsonObj.AddPair('excises', LJsonArr);

    TFile.WriteAllText(AFileName, LJsonObj.ToString, TEncoding.UTF8);
  finally
    FreeAndNil(LJsonObj);
    FreeAndNil(LJsonArr);
  end;
end;

end.
