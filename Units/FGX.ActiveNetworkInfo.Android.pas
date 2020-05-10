unit FGX.ActiveNetworkInfo.Android;

interface

uses Android.Api.Network;

type
  TActiveNetworkInfo = class
  private
    class var FJConnectivityManager: TJConnectivityManager;
    class constructor Create;
  public
    /// <summary>Check permission "android.permission.ACCESS_NETWORK_STATE"</summary>
    class function CheckPermission: Boolean;
    /// <summary>Returns details about the currently active default data network.</summary>
    class function GetInfo: TJNetworkInfo;
    /// <summary>Indicates whether network connectivity exists and it is possible to establish connections and pass data.</summary>
    class function IsConnected: Boolean;
    /// <summary>Return a human-readable name describe the type of the network, for example "WIFI" or "MOBILE".</summary>
    class function GetTypeName: string;
    /// <summary>Is Wi-Fi connection?</summary>
    class function IsWifi: Boolean;
    /// <summary>Is Mobile connection?</summary>
    class function IsMobile: Boolean;
  end;

implementation

uses Java.Bridge.Helpers,
     System.SysUtils,
     Androidapi.JNI,
     Android.Api.JavaTypes,
     Android.Api.ActivityAndView,
     FGX.Platform.Android,
     FGX.Helpers.Android,
     FGX.Permissions;

{ TActiveNetworkInfo }

class function TActiveNetworkInfo.CheckPermission: Boolean;
const
  ACCESS_NETWORK_STATE = 'android.permission.ACCESS_NETWORK_STATE';
var
  LPermission: TArray<string>;
  LPermissions: TArray<TfgPermissionInfo>;
  LItem: TfgPermissionInfo;
  LCheckResult: TPermissionCheckResult;
begin
  LPermission := [ACCESS_NETWORK_STATE];
  LPermissions := TfgPermissionService.CheckPermissions(LPermission);
  LCheckResult := TPermissionCheckResult.Denied;
  for LItem in LPermissions do
    begin
      if (LItem.PermissionId = ACCESS_NETWORK_STATE) then
        begin
          LCheckResult := LItem.CheckResult;
          Break;
        end;
    end;
  Result := LCheckResult = TPermissionCheckResult.Granted;
end;

class constructor TActiveNetworkInfo.Create;
begin
  FJConnectivityManager := nil;
  if CheckPermission then
    FJConnectivityManager := TJConnectivityManager.Wrap
      (TfgAndroidHelper.Context.getSystemService(TJContext.CONNECTIVITY_SERVICE));
end;

class function TActiveNetworkInfo.GetInfo: TJNetworkInfo;
var
  NetworkInfo: TJNetworkInfo;
begin
  Result := nil;
  Create;
  if FJConnectivityManager <> nil then
    begin
      NetworkInfo := FJConnectivityManager.getActiveNetworkInfo();
      if NetworkInfo <> nil then
        Result := NetworkInfo;
    end;
end;

class function TActiveNetworkInfo.IsConnected: Boolean;
var
  NetworkInfo: TJNetworkInfo;
begin
  NetworkInfo := GetInfo;
  Result := (NetworkInfo <> nil) and NetworkInfo.IsConnected();
end;

class function TActiveNetworkInfo.IsMobile: Boolean;
var
  NetworkInfo: TJNetworkInfo;
begin
  NetworkInfo := GetInfo;
  Result := (NetworkInfo <> nil) and (NetworkInfo.getType() = TJConnectivityManager.TYPE_MOBILE);
end;

class function TActiveNetworkInfo.IsWifi: Boolean;
var
  NetworkInfo: TJNetworkInfo;
begin
  NetworkInfo := GetInfo;
  Result := (NetworkInfo <> nil) and (NetworkInfo.getType() = TJConnectivityManager.TYPE_WIFI);
end;

class function TActiveNetworkInfo.GetTypeName: string;
const
  RESULT_NONE = 'NONE';
var
  NetworkInfo: TJNetworkInfo;
begin
  NetworkInfo := GetInfo;
  if NetworkInfo <> nil then
    Result := JStringToString(NetworkInfo.GetTypeName())
  else
    Result := RESULT_NONE;
end;

end.
