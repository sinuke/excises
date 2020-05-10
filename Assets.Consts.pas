{*********************************************************************
 *
 * Даннный модуль сгенерирован автоматически!
 *
 * НЕ ВНОСИТЕ изменения в этот файл, так как они будут потеряны после обновления ассетов в 
 * Project -> FGX Assets Manager.
 *
 * Используйте эти константы вместо того, чтобы вписывать названия ассетов в коде. Это поможет вам поймать
 * ситуации изменения ассетов (удаление, переименование) в дизайнере на этапе комплияции.
 *
 *********************************************************************}

unit Assets.Consts;

interface

{$SCOPEDENUMS ON}

type

  /// <summary>Константы с идентификаторами ресурсов приложения.</summary>
  TfgAssetsConstants = record
  private type

    TfgColors = record
    const
      COLORS_COLOR1 = 'Colors\Color1';
      COLORS_COLOR2 = 'Colors\Color2';
      COLORS_COLOR3 = 'Colors\Color3';
      COLORS_DIVIDER = 'Colors\Divider';
      COLORS_PRIMARYTEXT = 'Colors\PrimaryText';
      COLORS_SECONDARYTEXT = 'Colors\SecondaryText';
      COLORS_SHADOWTRANSPARENT = 'Colors\ShadowTransparent';
      COLORS_WHITE = 'Colors\White';
    end;

    TfgBitmaps = record
    const
      ABOUT = 'About';
      ABOUT_DISABLED = 'About_Disabled';
      BACK = 'Back';
      BUTTON_DISABLED = 'Button\Disabled';
      BUTTON_ENABLED = 'Button\Enabled';
      CIRCLE = 'Circle';
      EDIT_DISABLED = 'Edit\Disabled';
      EDIT_FOCUSED = 'Edit\Focused';
      EDIT_UNFOCUSED = 'Edit\Unfocused';
      EXCISE_256 = 'Excise_256';
      EXCISE_40 = 'Excise_40';
      FGX = 'FGX';
      LIST = 'List';
      LOGO_192 = 'Logo_192';
      MESSAGES_ERROR = 'Messages\Error';
      MESSAGES_NO_CONNECTION = 'Messages\No_Connection';
      MESSAGES_NO_DATA = 'Messages\No_Data';
      UP = 'Up';
    end;

    TfgFonts = record
    const
      PRODUCT_SANS_BOLD = 'Product Sans Bold';
      PRODUCT_SANS_BOLD_ITALIC = 'Product Sans Bold Italic';
      PRODUCT_SANS_ITALIC = 'Product Sans Italic';
      PRODUCT_SANS_REGULAR = 'Product Sans Regular';
    end;

    TfgFiles = record
    const
      TITLES = 'Titles';
    end;
  public
    /// <summary>Идентификаторы ресурсов с цветами.</summary>
    class var Color: TfgColors;

    /// <summary>Идентификаторы ресурсов с картинками.</summary>
    class var Bitmap: TfgBitmaps;

    /// <summary>Идентификаторы ресурсов с пользовательскими файлами шрифтов.</summary>
    class var Fonts: TfgFonts;

    /// <summary>Идентификаторы ресурсов с пользовательскими файлами.</summary>
    class var Files: TfgFiles;
  end;

var
  R: TfgAssetsConstants;

implementation

end.
