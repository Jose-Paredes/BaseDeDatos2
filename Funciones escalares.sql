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

------
/*--------------------------- [OPCION 2] --------------------------*/
-- devuelve la 1era. y la �ltima letra en may�sculas
------
create function ejer1a(@palabra varchar(50))
returns varchar(50)
as
begin
declare @aux varchar(50)
set @palabra = LTRIM(@palabra)
set @aux =UPPER(SUBSTRING(@palabra, 1,1)) + LOWER (SUBSTRING(@palabra, 2, len(@palabra)-2)) + UPPER(SUBSTRING(@palabra, len(@palabra),1))
return @aux
end
--- 
select dbo.ejer1a('juan')

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
		if(@auxc like '0' or @auxiliar like '0')
	begin
		set @suma = 0
		break
	end
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
select dbo.ejer7(01255466) -- hay un error al enviar un 0 en 1er. lugar, se soluciona con la opcion 2

/***[OPCION 2]***/
alter function ejer7a(@numero varchar(20))
returns int
as
begin
declare @auxc char(1) = SUBSTRING(@numero, 1,1)
declare @pn int = CAST(@auxc as int)
declare @iterador int = 1, @itanidado int = 0, @suma int= 0
declare @auxiliar char
declare @longitud int = LEN(@numero)
if(@auxc = '0') set @iterador = @longitud + 1 -- incremento en 1 al iterador para que no ingrese al while
while(@iterador <= @longitud)
begin
	set @iterador += 1
	set @auxiliar = SUBSTRING(@numero, @iterador, 1)
	if(@auxiliar like '0')
	begin
		set @suma = 0
		break
	end
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
select dbo.ejer7a('543') -- 60
select dbo.ejer7a('322') -- 12
select dbo.ejer7a('523') -- 30
select dbo.ejer7a('555') -- 125
-- poniendo a prueba con ceros
select dbo.ejer7a('0327')
------------------------------------------------------------------------------------------------------------------------------------
--- 8.	Cree una funci�n que dado un string o atributo se�ale  V / F para indicar si hay una palabra dada, �JKILHOLAPP�, �HOLA� -> V
-------------------------------------------------------------------------------------------------------------------------------------
alter function ejer8(@string varchar(20), @palabra varchar(20))
returns char
as
begin
declare @haypalabra char = 'F'
declare @largostring int = LEN(@string)
declare @largopalabra int = LEN(@palabra)
declare @auxstring varchar(20)
declare @iterador int = 1
while(@iterador <= @largostring)
begin
	set @auxstring = SUBSTRING(@string, @iterador, @largopalabra)
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
select dbo.ejer8('31354546asdf14lm', 'asdf14l')

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
create function ejer9(@opcion int)
returns varchar(17)
as
begin
declare @op varchar(17)
set @op=( 
	case 
		when @opcion = 1 then 'Soltero/a'
		when @opcion = 2 then 'Casado/a'
		when @opcion = 3 then 'Viudo/a'
		when @opcion = 4 then 'Separado/a'
		when @opcion = 5 then 'Divorciado/a'
		when @opcion = 6 then 'Concubinado/a'
		else 'Opcion Incorrecta'
	end)
return @op
end
--
select dbo.ejer9(6)

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
create function ejer11(@numero int)
returns char(6)
as
begin
declare @paroimpar char(5)
if(@numero = 0) return 'Neutro'
if(@numero%2=0)
	set @paroimpar = 'Par'
else
	set @paroimpar = 'Impar'
return @paroimpar
end
--
select dbo.ejer11(16)
select dbo.ejer11(15)
select dbo.ejer11(0)

------------------------------------------------------------------------------------------------------------------------------------
--- 12.	Cree una funci�n que elimine todos los espacios en blanco de un string dado.
-------------------------------------------------------------------------------------------------------------------------------------
create function ejer12(@string varchar(50))
returns varchar(50)
as
begin
declare @cadenaLimpia varchar(50) = ''
declare @caracter char
declare @longitud int = LEN(@string)
declare @iterador int = 0
while(@iterador <= @longitud)
begin
	set @caracter = SUBSTRING(@string, @iterador, 1)
	if(@caracter <> '')
	begin
		set @cadenaLimpia = @cadenaLimpia + @caracter
	end
	set @iterador+=1
end
return @cadenaLimpia
end
---
select dbo.ejer12('      Unasur - 2016 ')

------------------------------------------------------------------------------------------------------------------------------------
--- 13.	Cree una funci�n que dada una cadena variable compuesta de nombre y apellido, 
---		devuelva el nombre solo en may�sculas y el apellido solo en min�sculas.
-------------------------------------------------------------------------------------------------------------------------------------
create function ejer13(@nombres varchar(50))
returns varchar(50)
as
begin
declare @posicion int
declare @upperlower varchar(50)
declare @longitud int = LEN(@nombres)
set @nombres = RTRIM(LTRIM(@nombres)) --Limpio la cadena de posibles espacios a los lados
	set @posicion = PATINDEX('% %', @nombres)
set @upperlower = UPPER(SUBSTRING(@nombres, 1, @posicion)) + LOWER(SUBSTRING(@nombres, @posicion, @longitud))
set @upperlower = (select dbo.ejer15(@upperlower)) --llamo a la funci�n ejer15 para que elimine todos los espacios en blanco 
return @upperlower
end
--
select dbo.ejer13('Jose Paredes')
select dbo.ejer13('  Ingenier�a Inform�tica 2016') --probando el RTRIM Y LTRIM

------------------------------------------------------------------------------------------------------------------------------------
--- 14.	Cree una funci�n que dada una frase convierta las vocales en numero seg�n su orden, (Juan Perez) -> J51n P2r2z
-------------------------------------------------------------------------------------------------------------------------------------
alter function ejer14(@string varchar(20))
returns varchar(20)
as
begin
set @string = RTRIM(LTRIM(@string))
declare @auxiliar char = ''
declare @conversion varchar(20) = ''
declare @longitud int = LEN(@string)
declare @iterador int = 1
while(@iterador < @longitud)
begin
	set @auxiliar = SUBSTRING(@string, @iterador,1)
	set @auxiliar=(
		case @auxiliar
			when 'a' then '1'
			when 'e' then '2'
			when 'i' then '3'
			when 'o' then '4'
			when 'u' then '5'
		else @auxiliar
		end
	)
set @conversion+=@auxiliar
set @iterador+=1
end
return @conversion
end
---
select dbo.ejer14('        Informatica      ')


------------------------------------------------------------------------------------------------------------------------------------
--- 15.	Cree una funci�n que dada una cadena variables que pueden contener los 2 (dos) nombres y los 2 (dos) apellido de una persona, 
--- separados por N espacios entre las palabras solo deje 1 (un) espacio para separar los nombres y apellidos.
-------------------------------------------------------------------------------------------------------------------------------------
create function ejer15(@string varchar(60))
returns varchar(60)
as
begin
set @string = RTRIM(LTRIM(@string))
declare @longitud int = LEN(@string)
declare @cadenaLimpia varchar(60) = ''
declare @caracter char
declare @iterador int = 0
declare @space int = 0
declare @posicion1 int = 0, @posicion2 int = 0
while(@iterador <= @longitud)
begin
	set @caracter = SUBSTRING(@string, @iterador, 1)
	if(@caracter <> '')
	begin
		set @cadenaLimpia = @cadenaLimpia + @caracter
	end
	else --si el car�cter es un espacio
	begin
		while(SUBSTRING(@string, @iterador + 1, 1)) like '% %'
			set @iterador+=1
			set @caracter = ''
			set @cadenaLimpia += @caracter						
	end
	set @iterador+=1
end
return @cadenaLimpia
end
---
select dbo.ejer15('  Juan     Roman         Riquelme     JR10  ')

------------------------------------------------------------------------------------------------------------------------------------
--- 16- Cree una funcion que recibe una letra del abecedario y le devuelva su posici�n
-------------------------------------------------------------------------------------------------------------------------------------
alter function ejer16(@abc char)
returns int
as
begin
declare @posicion int
set @posicion=(
	case @abc
	when 'a' then 1
	when 'b' then 2
	when 'c' then 3
	when 'd' then 4
	when 'e' then 5
	when 'f' then 6
	when 'g' then 7
	when 'h' then 8
	when 'i' then 9
	when 'j' then 10
	when 'k' then 11
	when 'l' then 12
	when 'm' then 13
	when 'n' then 14
	when '�' then 15
	when 'o' then 16
	when 'p' then 17
	when 'q' then 18
	when 'r' then 19
	when 's' then 20
	when 't' then 21
	when 'u' then 22
	when 'v' then 23
	when 'w' then 24
	when 'x' then 25
	when 'z' then 26
	else ' '
	end
)
return @posicion
end
---
select dbo.ejer16('s')

------------------------------------------------------------------------------------------------------------------------------------
--- 17- Cree una funci�n que dado unos n�meros, diga cual es el menor y mayor de todos
-------------------------------------------------------------------------------------------------------------------------------------
alter function ejer17(@numero varchar(6))
returns varchar(60)
as
begin
declare @long int = LEN(@numero)
declare @resultado varchar(60) 
declare @menor int, @mayor int,@char char, @it int = 1, @aux int
declare @men char, @may char
set @menor = cast(SUBSTRING(@numero,1 ,1) as int)
set @mayor = cast(SUBSTRING(@numero,1,1) as int)
while @it <= @long
begin
	set @char = SUBSTRING(@numero, @it,1)
	set @aux = CAST(@char as int)
	if(@aux like 0 or @aux < @menor)
	begin
		set @menor = @aux
	end
	else if(@char >@mayor)
	begin
		set @mayor = @aux
	end
	set @it+=1
end
set @men = CAST(@menor as char)
set @may = CAST(@mayor as char)
set @resultado= 'El menor de todos es ' + @men + ' y el mayor ' + @may
return @resultado
end
--s
select dbo.ejer17('02482543')

------------------------------------------------------------------------------------------------------------------------------------
--- 18- Cree una funcion que recibe una cadena con un nombre y apellido, que devuela el 1er. y �ltimo caracter del nombre y apellido
---		en may�sculas, separados por 1 espacio. 'Jose Paredes' -> JosE ParedeS
-------------------------------------------------------------------------------------------------------------------------------------
alter function ejer18(@string varchar(50))
returns varchar(50)
as
begin
declare @mayus varchar(50)
declare @pos int
set @string = LTRIM((select dbo.ejer15(@string))) --llamo a la func. ejer15 para que elimine los espacios 'sucios' y solo deje las necesarias.
declare @long int = LEN(@string) -- tomo la longitud de la nueva cadena libre de espacios 'sucios'
set @pos = patindex('% %', @string)--obtiene la pos del 1er. espacio
set @mayus = (select dbo.ejer1a(SUBSTRING(@string,1,@pos))) + SPACE(1) + (select dbo.ejer1a(SUBSTRING(@string, @pos+1, @long))) -- obtiene solo el nombre de la cadena; desde la pos 1 hasta la pos del espacio
return @mayus
end
----
select dbo.ejer18('  informatica       unasur   ')
select dbo.ejer18('  diego       casco  ')

----
/***************************************	[OPCI�N 2]	***********************************************/
-- Esta variante puede recibir como par�metro una cadena compuesta de varios nombres y apellidos --
/*****************************************************************************************************/
----
alter function ejer18a(@string varchar(50))
returns varchar(50)
as
begin
declare @stringul varchar(50) = ' '
declare @char char
declare @pos int, @iterador int = 0
set @string = LTRIM((select dbo.ejer15(@string))) --llamo a la func. ejer15 para que elimine los espacios 'sucios' y solo deje las necesarias.
declare @long int = LEN(@string) -- tomo la longitud de la nueva cadena libre de espacios 'sucios'
declare @auxiliar varchar(50) = ''
while @iterador <= @long
begin
	set @iterador+=1
	set @char = SUBSTRING(@string, @iterador,1)--
	if(@char not like ' ')
	begin
		set @auxiliar+=@char
	end
	else -- si el car�cter es un espacio en blanco
	begin
		set @stringul = RTRIM(@stringul) + space(1) + (select dbo.ejer1a(@auxiliar)) -- concateno las cadenas simples
		set @auxiliar = '' -- reseteo para poder alojar en ella otra cadena simple
	end
end
return @stringul
end
-----
select dbo.ejer18a('juan    roman   riquelme jr10  ')
select dbo.ejer18a('  universidad aut�noma   del   sur  UNASUR ')
select dbo.ejer18a('base de datos ii ing diego casco')
