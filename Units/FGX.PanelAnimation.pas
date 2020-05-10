unit FGX.PanelAnimation;

interface

uses System.SysUtils,
     FGX.Controls,
     FGX.Types,
     Android.Api.ActivityAndView,
     Java.Bridge;

type
  TTranslateAnimationListener = class(TJavaLocal, JAnimation_AnimationListener)
  protected
    FFinishCallback: TfgCallback;
  public
    constructor Create(const AFinishCallback: TfgCallback);
    destructor Destroy; override;

    {JAnimation_AnimationListener}
    procedure onAnimationEnd(const AArg0: TJAnimation);
    procedure onAnimationRepeat(const AArg0: TJAnimation);
    procedure onAnimationStart(const AArg0: TJAnimation);
  end;

  TfgPanelAnimation = class
  public
    class procedure ShowPanel(const AControl: TfgControl; const AY: Single;
                              const ADuration: Integer; const AFinishCallback: TfgCallback = nil);

    class procedure HidePanel(const AControl: TfgControl; const AY: Single;
                              const ADuration: Integer; const AFinishCallback: TfgCallback = nil);
  end;

implementation

uses FGX.Animation,
     FGX.Helpers.Android,
     FGX.Controls.Android,
     FGX.Types.AutoreleasePool,
     Android.Api.Resources;

{ TMyAnimatorListener }

constructor TTranslateAnimationListener.Create(const AFinishCallback: TfgCallback);
begin
  inherited Create;

  FFinishCallback := AFinishCallback;
end;

destructor TTranslateAnimationListener.Destroy;
begin
  FFinishCallback := nil;
  inherited;
end;

procedure TTranslateAnimationListener.onAnimationEnd(const AArg0: TJAnimation);
begin
  if Assigned(FFinishCallback) then
    FFinishCallback;
end;

procedure TTranslateAnimationListener.onAnimationRepeat(const AArg0: TJAnimation);
begin
end;

procedure TTranslateAnimationListener.onAnimationStart(const AArg0: TJAnimation);
begin
end;

{ TfgPanelAnimation }

class procedure TfgPanelAnimation.HidePanel(const AControl: TfgControl; const AY: Single; const ADuration: Integer;
  const AFinishCallback: TfgCallback);
var
  View: TJView;
  Listener: TTranslateAnimationListener;
  Animation: TJTranslateAnimation;
  Interpolator: TJPathInterpolator;
  Scale: Single;
begin
  Scale := TfgAndroidHelper.ScreenScale;
  View := AControl.Handle.View;
  Animation := TJTranslateAnimation.Create(0, 0, 0, AY * Scale);
  if ADuration = PlatformDuration then
    Animation.setDuration(TJResources.getSystem.getInteger(TJR_integer.config_shortAnimTime))
  else
    Animation.setDuration(ADuration);
  Animation.setFillBefore(True);
  Animation.setFillAfter(False);

  Interpolator := TJPathInterpolator.Create(0.64, 0, 0.78, 0);

  Listener := TTranslateAnimationListener.Create(
    procedure
    begin
      if Assigned(AFinishCallback) then
        AFinishCallback();

      TfgAutoreleasePool.Release(Listener);
      TfgAutoreleasePool.Release(Interpolator);
      TfgAutoreleasePool.Release(Animation);
    end);

  TfgAutoreleasePool.Store(Listener);
  TfgAutoreleasePool.Store(Interpolator);
  TfgAutoreleasePool.Store(Animation);

  Animation.setInterpolator(Interpolator);
  Animation.setAnimationListener(Listener);

  View.startAnimation(Animation);
end;

class procedure TfgPanelAnimation.ShowPanel(const AControl: TfgControl; const AY: Single; const ADuration: Integer;
  const AFinishCallback: TfgCallback);
var
  View: TJView;
  Listener: TTranslateAnimationListener;
  Animation: TJTranslateAnimation;
  Interpolator: TJPathInterpolator;
  Scale: Single;
begin
  Scale := TfgAndroidHelper.ScreenScale;
  View := AControl.Handle.View;
  Animation := TJTranslateAnimation.Create(0, 0, 0, AY * Scale);
  if ADuration = PlatformDuration then
    Animation.setDuration(TJResources.getSystem.getInteger(TJR_integer.config_shortAnimTime))
  else
    Animation.setDuration(ADuration);
  Animation.setFillEnabled(True);

  Interpolator := TJPathInterpolator.Create(0.22, 1, 0.36, 1);

  Listener := TTranslateAnimationListener.Create(
    procedure
    begin
      if Assigned(AFinishCallback) then
        AFinishCallback();

      TfgAutoreleasePool.Release(Listener);
      TfgAutoreleasePool.Release(Interpolator);
      TfgAutoreleasePool.Release(Animation);
    end);

  TfgAutoreleasePool.Store(Listener);
  TfgAutoreleasePool.Store(Interpolator);
  TfgAutoreleasePool.Store(Animation);

  Animation.setInterpolator(Interpolator);
  Animation.setAnimationListener(Listener);

  View.startAnimation(Animation);
end;

end.
