--- EJERCICIOS SOBRE FUNCIONES ESCALARES
-----Funciones definidas por el usuario

create database funciones_escalares;
use funciones_escalares;

--------------------------------------------------------------------------------------------------------------------------------------
-- 1.	Cree una funci�n que dado un string cualquiera continuo, devuelva el 1er. car�cter en may�scula y los restantes en min�sculas.
--------------------------------------------------------------------------------------------------------------------------------------
create function ejer1(@palabra varchar(50))
returns varchar(50)
as
begin
declare @aux varchar(50)
set @palabra = LTRIM(@palabra)
set @aux =UPPER(SUBSTRING(@palabra, 1,1)) + LOWER (SUBSTRING(@palabra, 2, len(@palabra)-1))
return @aux
end
--- 
select dbo.ejer1('juan')

----------------------------------------------------------------------------------------------
--- 2.	Cree una funci�n num�rica que calcule el valor de una potencia Y para un numero dado X
----------------------------------------------------------------------------------------------
create function ejer2(@numero int, @exponente int)
returns int
as
begin
declare @potencia int
set @potencia = 1
while(@exponente > 0)
begin
	set @potencia = @potencia * @numero --1 = 1 * 3  ///9= 3 * 3 
	set @exponente = @exponente - 1 -- 1 = 2 - 1
end
return @potencia
end

select dbo.ejer2(4,2)

--------------------------------------------------------------------------------------------------------------------------------------
--- 3.	Cree una funci�n que dado un string o atributo alfanum�rico de X longitud lo devuelva invertido, (�Juan Pedro�) -> ordeP nauJ.
--------------------------------------------------------------------------------------------------------------------------------------
create function ejer3(@string varchar(10))
returns varchar(10)
as
begin
declare @palabra varchar(10) = ''
declare @letra char(1)
declare @cantidad int = len(@string)
while(@cantidad > 0)
	begin
		set @letra = SUBSTRING(@string, @cantidad, 1)
		set @palabra = @palabra + @letra
		set @cantidad = @cantidad - 1
	end
return @palabra
end
----
select dbo.ejer3('juan')

-----------------------------------------------------------------------------------------------------------------------------------
--- 4.	Cree una funci�n que dado un string o atributo, se�ale V / F para indicar si hay un numero.
-----------------------------------------------------------------------------------------------------------------------------------
create function ejer4(@string varchar(10))
returns char(1)
as
begin
declare @haynumero char(1)
declare @cantidad int = len(@string)	
while(@cantidad > 0)
begin
	if(SUBSTRING(@string, @cantidad, 1)) between '0' and '9'
	begin 
		set @haynumero = 'V' 
		break
	end
	else 
		set @haynumero = 'F' 
		set @cantidad = @cantidad - 1
end
return @haynumero
end
---
select dbo.ejer4('juan')
select dbo.ejer4('ju8n')

----------------------------------------------------------------------------------------------------------------------------------
--- 5.	Cree una funci�n que dado un car�cter, indique cuantas veces se encuentra el mismo en un string, Ej.: �abracadabra�,�a� -> 5
----------------------------------------------------------------------------------------------------------------------------------
create function ejer5(@string varchar(15), @caracter char)
returns int
as
begin
declare @coincidencia int = 0
declare @longitud int = LEN(@string)
declare @letra char
while(@longitud > 0)
begin
	set @letra = SUBSTRING(@string, @longitud, 1)
	if(@letra = @caracter)
	begin
		set @coincidencia = @coincidencia + 1
	end
	set @longitud = @longitud - 1
end
return @coincidencia
end
---
select dbo.ejer5('abracadabra', 'a')
----------------------------------------------------------------------------------------------------------------------------------
--- 6.	Cree una funci�n que dado un valor o atributo num�rico, devuelva la sumatoria de sus componentes, (14) -> 5, (741) -> 12.
----------------------------------------------------------------------------------------------------------------------------------
create function ejer6(@numero int)
returns int
as
begin
declare @sumatoria int = 0
declare @longitud int= LEN(@numero)
declare @string char(5) = CAST(@numero as char(5)) --de int a char
declare @cadena char
declare @num int 
declare @iterador int = 0
while(@iterador < @longitud)
begin
	set @cadena = SUBSTRING(@string, @iterador + 1, 1)
	set @num = CAST(@cadena as int)
	set @sumatoria += @num
	set @iterador += 1
end
return @sumatoria
end
---
select dbo.ejer6(322)
----------------------------------------------------------------------------------------------------------------------------------
--- 7.	Cree una funci�n que dado un valor o atributo num�rico de X d�gitos, devuelva la multiplicaci�n de 
---		los d�gitos mediante sumas sucesivas, (523) --> (5+5)=10 | 10+10+10=[30] --------- (322) -> 3+3(6)-->6+6=12
-----------------------------------------------------------------------------------------------------------------------------------
alter function ejer7(@numero int)
returns int
as
begin
declare @string char(10) = CAST(@numero as char(10))
declare @auxc char = SUBSTRING(@string, 1,1)
declare @pn int = CAST(@auxc as int)
declare @iterador int = 1, @itanidado int = 0, @suma int= 0
declare @auxiliar char
declare @longitud int = LEN(@string)
while(@iterador <= @longitud)
begin
	set @iterador += 1
	set @auxiliar = SUBSTRING(@string, @iterador, 1)
	set @auxiliar = CAST(@auxiliar as int)
	while(@itanidado < @auxiliar)
	begin
		set @suma = @pn + @suma
		set @itanidado += 1 
	end
	set @pn = @suma
	set @itanidado = 1		-- reseteo el iterador anidado
end
return @suma
end
---
select dbo.ejer7(543) -- 60
select dbo.ejer7(322) -- 12
select dbo.ejer7(523) -- 30
select dbo.ejer7(1234567) -- 5040
select dbo.ejer7(530) 
------------------------------------------------------------------------------------------------------------------------------------
--- 8.	Cree una funci�n que dado un string o atributo se�ale  V / F para indicar si hay una palabra dada, �JKILHOLAPP�, �HOLA� -> V
-------------------------------------------------------------------------------------------------------------------------------------
alter function ejer8(@string varchar(20), @palabra varchar(4))
returns char
as
begin
declare @haypalabra char = 'F'
declare @largostring int = LEN(@string)
declare @auxstring varchar(4)
declare @iterador int = 1
while(@iterador <= @largostring)
begin
	set @auxstring = SUBSTRING(@string, @iterador, 4)
	if(@palabra = @auxstring)
	begin
		set @haypalabra = 'V'
		break
	end
	set @iterador += 1
	--set @auxstring = '' -- averiguar si es necesario limpiar la cadena en cada ciclo.
end
return @haypalabra
end

---
select dbo.ejer8('3dmHOL4APholA', 'HOLA')
select dbo.ejer8('JEJOPEHOLAP', 'JOPE')
select dbo.ejer8('31354546asdf14lm', 'asdf')

/*----------------------------------[ OPCI�N 2 PARA EL EJERCICIO 8 ]----------------------------------*/
-- Esta funci�n busca la palabra 'x' en la cadena y si no la encuentra, la arma con los car�cteres a disposici�n
-- si logra armarla devuelve 'V' si no 'F'
alter function ejer8a(@string varchar(15), @palabra varchar(4))
returns char
as
begin
declare @haypalabra char = 'F'
declare @largostring int = LEN(@string)
declare @largopalabra int = LEN(@palabra)
declare @auxiliarstring char
declare @auxiliarpalabra char
declare @coincidencia varchar(4) = ''
while(@largostring > 0)
begin
	set @auxiliarstring = SUBSTRING(@string, @largostring, 1)	-- separo la ultima letra de string
	set @auxiliarpalabra = SUBSTRING(@palabra, @largopalabra, 1)-- separo la ultima letrra de palabra
	if (@auxiliarstring = @auxiliarpalabra)						-- comparo las letras separadas
	begin 
		set @coincidencia = @auxiliarpalabra + @coincidencia	-- si coinciden, voy agrupando las letras para volver a armar la palabra
		if @palabra = @coincidencia								-- comparo si concide la palabra dada es igual al agrupamiento de letras, producto de las coincidencias
		begin
			set @haypalabra = 'V'								-- Asigno verdadero y salgo
			break
		end
		set @largopalabra = @largopalabra - 1					-- disminuimos en uno la longitud de palabra y seguimos en el ciclo
	end
	else
	begin
		set @largostring = @largostring - 1
	end
end
return @haypalabra
end

/*------------------------------------------------------------------------------------------------------------------------------------
9.	Cree una funci�n que dado el atributo de una tabla, visualice para los valores del ESTADO CIVIL:
	a.	1 -> Soltero/a
	b.	2 -> Casado/a
	c.	3 -> Viudo/a
	d.	4 -> Separado/a
	e.	5 -> Divorciado/a
	f.	6 -> Concubinado/a
-------------------------------------------------------------------------------------------------------------------------------------*/


------------------------------------------------------------------------------------------------------------------------------------
--- 10.	Cree una funci�n que calcule el factorial de un numero o atributo, (4) = 1*2*3*4 = [24]
-------------------------------------------------------------------------------------------------------------------------------------
create function ejer10(@numero int)
returns int
as
begin
declare @factorial int = 1
while(@numero > 0)
begin
	set @factorial *= @numero
	set @numero -= 1
end
return @factorial
end
--
select dbo.ejer10(4)
select dbo.ejer10(5)
------------------------------------------------------------------------------------------------------------------------------------
--- 11.	Cree una funci�n que indique si un n�mero o atributo es par o impar.
-------------------------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------------
--- 12.	Cree una funci�n que elimine todos los espacios en blanco de un string dado.
-------------------------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------------------
--- 13.	Cree una funci�n que dada una cadena variable compuesta de nombre y apellido, 
---		devuelva el nombre solo en may�sculas y el apellido solo en min�sculas.
-------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------
--- 14.	Cree una funci�n que dada una frase convierta las vocales en numero seg�n su orden, (Juan Perez) -> J51n P2r2z
-------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------
--- 15.	Cree una funci�n que dada una cadena variables que pueden contener los 2 (dos) nombres y los 2 (dos) apellido de una persona, 
--- separados por N espacios entre las palabras solo deje 1 (un) espacio para separar los nombres y apellidos.
-------------------------------------------------------------------------------------------------------------------------------------