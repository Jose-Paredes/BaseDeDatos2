use db_review;
-- [1] --
select * from EMPLE 
where dept_no = (select dept_no from emple where apellido = 'gil')

-- [1 v2] --
declare @deptoGil varchar(20);
select @deptoGil = dept_no from emple where apellido = 'gil'
select * from EMPLE 
where dept_no = @deptoGil

-- [2] --
select * from EMPLE
where oficio = (select oficio from emple where apellido = 'cerezo')
order by apellido

-- [3] --
select apellido, oficio, salario, fecha_alta from emple
where oficio = (select oficio from emple where apellido = 'jiménez')
   or salario >= (select salario from emple where apellido = 'fernández')
-- [3] -- v2

declare @o varchar(20) -- Aloja el oficio de Jimenez
declare @s decimal (10,2) -- Aloja el salario de Fernandez
select @o = oficio from emple where apellido like 'jiménez'
select @s = salario from emple where apellido = 'fernández'
select apellido, oficio, salario, fecha_alta from emple
where oficio like @o
or salario >= @s

-- [4] --
declare @d int -- Aloja el depto de fernandez
declare @sf decimal (10,2) -- Aloja el salario de fernandez
select @d = dept_no from emple where apellido like 'fernández'
select @sf = salario from emple where apellido like 'fernández'
select apellido, oficio, salario from emple 
where dept_no = @d and salario = @sf

-- [5] --
declare @sg int -- Aloja los salarios mayores que Gil
select @sg = salario from emple where apellido = 'Gil'
select * from emple
where salario > @sg 
and dept_no like 10

-- [6] --
select apellido, oficio, loc[localidad] from emple as e
inner join depart as d
on e.dept_no=d.dept_no

-- [7] --
select apellido, oficio, loc[localidad] from emple as e
inner join depart as d
on e.dept_no=d.dept_no
where e.oficio = 'analista'

-- [8] --
select apellido, oficio, salario from emple as e
inner join depart as d
on e.dept_no=d.dept_no
where d.loc like 'Madrid'

-- [9] --
select apellido, salario, loc[localidad] from emple as e 
inner join depart as d
on e.dept_no=d.dept_no
where salario between 700000 and 2500000

-- [10] --
declare @oficioG varchar (20) -- Aloja los salarios mayores que Gil
select @oficioG = oficio from emple where apellido = 'Gil'
select apellido, salario, dnombre[departamento] from emple as e 
inner join depart as d
on e.dept_no=d.dept_no
where oficio = @oficioG

-- [11] --
declare @og varchar (20) -- Aloja los salarios mayores que Gil
select @og = oficio from emple where apellido = 'Gil'
select apellido, salario, dnombre from emple as e 
inner join depart as d
on e.dept_no=d.dept_no
where oficio = @og
and comision is null

-- [12] --
select * from emple as e 
inner join depart as d
on e.dept_no=d.dept_no
where d.dnombre = 'contabilidad'
order by apellido

-- [13] --
select apellido from emple as e 
inner join depart as d
on e.dept_no=d.dept_no
where loc = 'sevilla'
and oficio = 'analista' or oficio = 'empleado'

-- [14] --
select AVG(salario)[Salario medio] from emple

-- [15] --
select MAX(salario)[Salario maximo] from emple 
where dept_no = 10

-- [16] --
select MIN(salario)[Salario mínimo] from emple e
inner join depart d
on e.dept_no=d.dept_no
where d.dnombre like 'ventas'

-- [17] --
select AVG(salario)[Salario promedio] from emple e
inner join depart d
on e.dept_no=d.dept_no
where d.dnombre like 'contabilidad'

-- [18] --
declare @sp decimal(10,2)
select @sp = AVG(salario) from emple
select * from emple
where salario > @sp

-- [19] --
select COUNT(*)[Cantidad de empleados] from emple
where dept_no like 10

-- [20] --
select COUNT(*)[Cantidad de empleados] from emple e
join depart d
on e.dept_no=d.dept_no
where d.dnombre like 'ventas'

select COUNT(*)[Cantidad de empleados] 
from emple e, depart d
where e.dept_no=d.dept_no 
and d.dnombre like 'ventas'

-- [21] --
select COUNT(*)[Empleados sin comisión] from emple 
where comision is NULL

-- [22] --
declare @sm decimal(10,2) 
select @sm = MAX(salario) from emple
select apellido from emple
where salario like @sm

-- [23] --
declare @sb decimal(10,2)
select @sb = MIN(salario) from emple
select apellido from emple
where salario like @sb

-- [24] --
declare @sa decimal(10,2) -- Aloja el salario mas alto del depto. de ventas
select @sa = MAX(salario) from emple e
join depart d
on e.dept_no=d.dept_no
where d.dnombre like 'ventas'
select * from emple
where salario like @sa

-- [25] --
select COUNT(*)[Cantidad de apellidos 'A'] from emple
where apellido like 'A%'

-- [26] --
select AVG(salario)[Salario medio], 
	   COUNT(comision)[Comision no nulas], 
	   MAX(salario)[Sueldo máximo], 
	   MIN(salario)[Sueldo mínimo] 
	   from emple
where dept_no like 30


