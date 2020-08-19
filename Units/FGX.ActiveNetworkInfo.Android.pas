unit FGX.ActiveNetworkInfo.Android;

interface

uses Android.Api.Network;

type
  TActiveNetworkInfo = class
  private
    class var FJConnectivityManager: JConnectivityManager;
    class constructor Create;
    class function GetNetwork: JNetwork;
  public
    /// <summary>Check permission "android.permission.ACCESS_NETWORK_STATE"</summary>
    class function CheckPermission: Boolean;
    /// <summary>Indicates whether network connectivity exists and it is possible to establish connections and pass data.</summary>
    class function IsConnected: Boolean;
    /// <summary>Is Wi-Fi connection?</summary>
    class function IsWifi: Boolean;
    /// <summary>Is Mobile connection?</summary>
    class function IsMobile: Boolean;
    /// <summary>Is VPN connection?</summary>
  end;

implementation

uses Java.Bridge,
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

class function TActiveNetworkInfo.GetNetwork: JNetwork;
var
  Network: JNetwork;
begin
  Result := nil;
  Create;
  if FJConnectivityManager <> nil then
    begin
      Network := FJConnectivityManager.getActiveNetwork();
      if Network <> nil then
        Result := Network;
    end;
end;

class function TActiveNetworkInfo.IsConnected: Boolean;
begin
  Result := IsMobile or IsWifi;
end;


class function TActiveNetworkInfo.IsMobile: Boolean;
var
  Network: JNetwork;
  NetworkCapabilities: JNetworkCapabilities;
begin
  Network := GetNetwork;
  if Network <> nil then
    begin
      NetworkCapabilities := FJConnectivityManager.getNetworkCapabilities(Network);
      Result := (NetworkCapabilities <> nil) and (NetworkCapabilities.hasTransport(TJNetworkCapabilities.TRANSPORT_CELLULAR()));
    end
  else
    Result := False;
end;

class function TActiveNetworkInfo.IsWifi: Boolean;
var
  Network: JNetwork;
  NetworkCapabilities: JNetworkCapabilities;
begin
  Network := GetNetwork;
  if Network <> nil then
    begin
      NetworkCapabilities := FJConnectivityManager.getNetworkCapabilities(Network);
      Result := (NetworkCapabilities <> nil) and (NetworkCapabilities.hasTransport(TJNetworkCapabilities.TRANSPORT_WIFI()));
    end
  else
    Result := False;
end;

end.
