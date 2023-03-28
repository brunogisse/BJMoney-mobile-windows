object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 418
  Width = 412
  object conn: TFDConnection
    Params.Strings = (
      'Database=C:\PROGRAMAS\mobile-financeiro\fontes\DB\banco.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 24
    Top = 24
  end
end
