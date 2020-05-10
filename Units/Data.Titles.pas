unit Data.Titles;

interface

uses System.Generics.Collections,
     System.Generics.Defaults;

type
  TTitles = class(TDictionary<string, string>)
  protected
    procedure Parse(const AData: string);
  public
    procedure LoadFromResource(const AResName: string);
    procedure LoadFromFile(const AFileName: string);
    procedure LoadFromAsset(const AAssetName: string);
  end;

implementation

uses System.SysUtils,
     System.IOUtils,
     System.Classes,
     System.Types,
     System.JSON,
     FGX.Assets,
     FGX.Assets.CustomFile;

{ TTitles }

procedure TTitles.LoadFromAsset(const AAssetName: string);
var
  Asset: TfgAssetFile;
begin
  if TfgAssetsManager.Current.Find<TfgAssetFile>(AAssetName, Asset) then
    LoadFromFile(Asset.FileName);
end;

procedure TTitles.LoadFromFile(const AFileName: string);
begin
  if TFile.Exists(AFileName) then
    Parse(TFile.ReadAllText(AFileName));
end;

procedure TTitles.LoadFromResource(const AResName: string);
var
  ResStream: TResourceStream;
  StrStream: TStreamReader;
begin
  if FindResource(HInstance, PWideChar(AResName), RT_RCDATA) <> 0 then
    begin
      ResStream := TResourceStream.Create(HInstance, AResName, RT_RCDATA);
      StrStream := TStreamReader.Create(ResStream);
      try
        Parse(StrStream.ReadToEnd);
      finally
        FreeAndNil(ResStream);
        FreeAndNil(StrStream);
      end;
    end
end;

procedure TTitles.Parse(const AData: string);
var
  LJsonObj: TJSONObject;
  LJsonEnum: TJSONObject.TEnumerator;
begin
  LJsonObj := TJSONObject.ParseJSONValue(AData, False, True) as TJSONObject;
  try
    LJsonEnum := LJsonObj.GetEnumerator;
    while LJsonEnum.MoveNext do
      Add(LJsonEnum.Current.JsonString.Value, LJsonEnum.Current.JsonValue.Value);;
  finally
    FreeAndNil(LJsonObj);
  end;
end;

end.
