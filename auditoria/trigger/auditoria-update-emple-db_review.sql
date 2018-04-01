/*
	UPDATE emple
*/

use db_review;
go

alter trigger tr_u_auditoria_emple
on emple
for update
as
	begin
	declare @reg varchar(50);
	declare @fecha VARCHAR(10);
	declare @hora char(8);
	declare @colum varchar(70);
	declare @usu varchar(10);
	set @usu = (select SUSER_SNAME())
	set @fecha = (select CONVERT(VARCHAR(10),GETDATE(), 103));
	set @hora = (select convert(char(8), getdate(), 108) as [hh:mm:ss]);
	set @reg = (select top 1 emple_no from deleted)
	set @colum = (STUFF((SELECT ',' + name FROM sys.columns WHERE object_id = OBJECT_ID('dbo.emple') 
				  AND  COLUMNS_UPDATED() & (POWER(2, column_id - 1)) <> 0 FOR XML PATH('')), 1, 1, ''));	
	declare @tablas varchar(70)
	declare @posicion int
	declare @v1 varchar(70)
	declare @v2 varchar(70)
	declare @longitud int 
	set @tablas = @colum	
	set @tablas = RTRIM(LTRIM(@tablas)) 
	set @longitud = LEN(@tablas)
	set @posicion = PATINDEX('%,%', @tablas)
	if @posicion <> 0 -- si se actualiza más de una columna
		begin			
			SELECT count(*) FROM STRING_SPLIT(@tablas, ',')  
			WHERE RTRIM(value) <> '';  
			set @v1 = SUBSTRING(@tablas, 1, (@posicion-1)) -- apellido
			set @v2 = SUBSTRING(@tablas, (@posicion+1), @longitud) -- oficio

			if @v1 like 'oficio'
				insert AUDITORIA select @usu, @fecha, @hora, 'update', 'emple', @reg, @v1, d.oficio, i.oficio from inserted i, deleted d
			if @v2 like 'oficio'
				insert AUDITORIA select @usu, @fecha, @hora, 'update', 'emple', @reg, @v2, d.oficio, i.oficio from inserted i, deleted d
			if @v1 like 'apellido'
				insert AUDITORIA select @usu, @fecha, @hora, 'update', 'emple', @reg, @v1, d.apellido, i.apellido from inserted i, deleted d
			if @v2 like 'apellido' 
				insert AUDITORIA select @usu, @fecha, @hora, 'update', 'emple', @reg, @v2, d.apellido, i.apellido from inserted i, deleted d
		end
	else -- solo si se actualiza una columna
		begin
		if @colum like 'dir' -- verifica que columna fue actualizada
			insert AUDITORIA select @usu, @fecha, @hora, 'update', 'emple', @reg, @colum, d.dir, i.dir from inserted i, deleted d
		else if @colum like 'oficio'
			insert AUDITORIA select @usu, @fecha, @hora, 'update', 'emple', @reg, @colum, d.oficio, i.oficio from inserted i, deleted d
		else if @colum like 'salario'
			insert AUDITORIA select @usu, @fecha, @hora, 'update', 'emple', @reg, @colum, d.salario, i.salario from inserted i, deleted d
		else if @colum like 'comision'
			insert AUDITORIA select @usu, @fecha, @hora, 'update', 'emple', @reg, @colum, d.comision, i.comision from inserted i, deleted d
		else if @colum like 'apellido'
			insert AUDITORIA select @usu, @fecha, @hora, 'update', 'emple', @reg, @colum, d.apellido, i.apellido from inserted i, deleted d
		end
	end;
go
