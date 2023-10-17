unit untUtils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, forms, StdCtrls, Base64,Graphics, LCLType,ExtCtrls ;
          procedure SalvarIni(key, value :String);
          Function LerIni(key :String):String;
          function listBoxToStr(listbox: TListBox): string;

          procedure LoadBase64ToImage(const Base64Str: string; AImage: TImage);

implementation

function Base64ToStream(const Base64Str: string): TMemoryStream;
var
  DecodedStr: RawByteString;
begin
  DecodedStr := DecodeBase64(Base64Str);
  Result := TMemoryStream.Create;
  Result.Write(DecodedStr[1], Length(DecodedStr));
  Result.Position := 0;
end;


procedure LoadBase64ToImage(const Base64Str: string; AImage: TImage);
var
  Stream: TMemoryStream;
begin
  Stream := Base64ToStream(Base64Str);
  try
    AImage.Picture.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure SalvarIni(key, value: String);
var
  ConfigFile: TIniFile;
  FileName: string;
begin
  // Obtém o diretório do executável
  FileName := ExtractFilePath(Application.ExeName) + 'config.ini';

  // Cria um objeto TIniFile para acessar o arquivo INI
  ConfigFile := TIniFile.Create(FileName);
  try
    // Grava a chave e o valor no arquivo INI
    ConfigFile.WriteString('Config', Key, Value);
  finally
    // Libera o objeto TIniFile
    ConfigFile.Free;
  end;
end;

function LerIni(Key: string): string;
var
  ConfigFile: TIniFile;
  FileName: string;
begin
  result := '';

  if not FileExists(ExtractFilePath(Application.ExeName) + 'config.ini') then
     exit;

  // Obtém o diretório do executável
  FileName := ExtractFilePath(Application.ExeName) + 'config.ini';

  // Cria um objeto TIniFile para acessar o arquivo INI
  ConfigFile := TIniFile.Create(FileName);
  try
    // Lê o valor da chave especificada
    Result := ConfigFile.ReadString('Config', Key, '');
  finally
    // Libera o objeto TIniFile
    ConfigFile.Free;
  end;
end;

function listBoxToStr(listbox: TListBox): string;
var
  i: Integer;
  delimiter : string;
begin
    result := '';

    if listbox.Items.Count = 0 then
       Exit;

  for i := 0 to listbox.Items.Count - 1 do
  begin
      Result := Result + delimiter + '"'+listbox.Items[i]+'"';
      delimiter := ',';
  end;

end;


end.

