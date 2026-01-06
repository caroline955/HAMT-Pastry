-- Bật SQL Authentication
USE master;
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2;
GO

-- Tạo login
CREATE LOGIN hamtuser WITH PASSWORD = 'HamtPass123!';
GO