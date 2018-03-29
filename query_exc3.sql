use db_review;
-- [1] --
select d.dnombre[Departamento], count(*)[Cantidad de Empeados] from emple e
join depart d
on e.dept_no=d.dept_no
group by d.dnombre

-- [2] --
select d.dnombre[Departamento], count(*)[+ de 5 Empleados] from emple e
join depart d
on e.dept_no=d.dept_no
group by d.dnombre
having count(*) > 5

-- [3] --
select d.dnombre[Departamento], avg(e.salario)[Salario medio] from emple e
join depart d
on e.dept_no=d.dept_no
group by d.dnombre

-- [4] --
select e.apellido from emple e
join depart d
on e.dept_no=d.dept_no
where dnombre like 'ventas' 
and oficio like 'vendedor'

-- [5] --
select count(*)[Cantidad de vendedores] from emple e
join depart d
on e.dept_no=d.dept_no
where dnombre like 'ventas' 
and oficio like 'vendedor'

-- [6] --
select e.oficio[Oficios de depto. ventas] from emple e
join depart d
on e.dept_no=d.dept_no
where dnombre like 'ventas' 
group by e.oficio

-- [7] --
select d.dnombre[Departamento], count(*)[Oficio empleado] from emple e
join depart d
on e.dept_no=d.dept_no
and oficio like 'empleado'
group by d.dnombre

-- [8] -- 
/*
	Un SELECT anidado despliega el total de empleados agrupados por depto. asignado con el alias totalEmplePorDepto.
	Otro SELECT recorre c/fila de totalEmplePorDepto y retorna la cantidad maxima de empleado de un depto.
	Ese valor es utilizado por HAVING para encontrar cual es el depto con mayor cantidad de empleados
*/
select d.dnombre[Departamento], count(*) as [Cantidad de Empeados] from emple e
join depart d
on e.dept_no=d.dept_no
group by d.dnombre
having count(*) like 
(select max(totalEmplePorDepto.cantEmpleados) from 
(select d.dnombre[Departamento], count(*) as cantEmpleados from emple e
join depart d
on e.dept_no=d.dept_no
group by d.dnombre) as totalEmplePorDepto)
-- v2
/*
	con WITH TIES, despliega más de una fila si es que contiene el mismo numero de empleados.
	sin importar el TOP 1
*/
SELECT TOP 1 WITH TIES d.dnombre[Departamento], count(*) as [Cantidad de Empeados] 
FROM emple e join depart d
on e.dept_no=d.dept_no 
GROUP BY d.dnombre 
ORDER BY COUNT(*) DESC;


-- [9] --
declare @salarioMedio money;
select @salarioMedio = avg(salario) from emple; -- 1.298.963,68
select d.dnombre[Departamento], sum(salario)[Salario por depto.] from emple e
join depart d
on e.dept_no=d.dept_no
group by d.dnombre
having sum(salario) > @salarioMedio

-- [10] --
select oficio, sum(salario)[Suma de salarios] from emple
group by oficio

-- [11] --
select oficio, sum(salario)[Suma de salario] from emple e
join depart d
on e.dept_no=d.dept_no
where dnombre like 'ventas'
group by oficio

-- [12] --
select top 1 with TIES d.dept_no, count(*) as [Cantidad de Empeados] 
from emple e join depart d
on e.dept_no=d.dept_no 
where oficio like 'empleado'
group by d.dept_no 
order by count(*) desc;

-- [13] --
select dnombre, count(distinct oficio)[Números de oficios distintos] from emple e
join depart d
on e.dept_no=d.dept_no
group by dnombre

-- [14] --
select dnombre, oficio, count(*)[Número de empleados]
from emple e 
join depart d
on e.dept_no=d.dept_no
group by dnombre, oficio
having count(*) > 2

-- [15] --
select estanteria, sum(unidades)[Suma de Uds.] from herramientas
group by estanteria

-- [16] --
select top 1 with ties estanteria, sum(unidades)[Suma de Uds.] from herramientas
group by estanteria
order by sum(unidades) desc

-- v2
/*
	Un SELECT anidado devuelve todas las sumas de unidades de herramientas asignado con el alias sumaCantidades.
	Otro SELECT recorre cada fila de sumaCantidades y retorna la fila con valor maximo.
	Ese valor es utilizado en HAVING para encontrar la estanteria con más unidades
*/
select estanteria, sum(unidades)[Suma de Uds.] from herramientas
group by estanteria
having sum(unidades) like 
(select max(sumaCantidades.suma) from 
(select sum(unidades) as suma from herramientas
group by estanteria) as sumaCantidades)

-- [17] --
select h.cod_hospital, nombre[Hospital], count(*)[Nros. de médicos] from Medicos m
join Hospitales h
on m.cod_hospital=h.cod_hospital
group by h.cod_hospital, nombre
order by h.cod_hospital desc

-- [18] --
select nombre[Hospital], especialidad from Medicos m
join Hospitales h
on m.cod_hospital=h.cod_hospital
group by nombre, especialidad

-- [19] --
select nombre[Hospital], especialidad, count(*)[Nros. de médicos] from Medicos m
inner join Hospitales h
on m.cod_hospital=h.cod_hospital
group by especialidad, nombre

-- [20] --
select nombre[Hospital], count(*)[Nros. de empleados] from Personas p
inner join Hospitales h
on p.cod_hospital=h.cod_hospital
group by nombre

-- [21] --
select especialidad, count(*)[Nro. de trabajadores] from Medicos
group by especialidad
order by count(*)

-- [22] --
select top 1 with ties especialidad, count(*)[Cantidad de médicos] from Medicos
group by especialidad
order by count(*) desc

-- [23] --
select top 1 with ties nombre, num_plazas from Hospitales
order by num_plazas desc

-- [24] --
select distinct(estanteria) from Herramientas
order by estanteria desc

-- [25] --
select distinct(estanteria), sum(unidades)[Unidades] from Herramientas
group by estanteria

-- [26] --
select distinct(estanteria), sum(unidades)[Unidades] from Herramientas
group by estanteria
having sum(unidades) > 15

-- [27] --
select top 1 with ties estanteria, sum(unidades)[Unidades] from Herramientas
group by estanteria
order by sum(unidades) desc

-- [28] --
select * from depart d
where dept_no not in (select dept_no from emple);

-- [29] --
select dnombre, count(e.dept_no)[Nro. de empleados] from depart d
left join emple e
on d.dept_no=e.dept_no
group by dnombre
order by count(e.dept_no)

-- [30] --
select d.dept_no, sum(salario)[Suma de salarios], dnombre from emple e
right join depart d
on e.dept_no=d.dept_no
group by d.dept_no, dnombre

-- [31] --
select d.dept_no,isnull(sum(salario),'0')[Suma de salarios], dnombre from emple e 
right join depart d 
on e.dept_no=d.dept_no
group by d.dept_no, dnombre

-- [32] --
select h.cod_hospital, nombre, count(m.dni)[Nros. de médicos] from Medicos m
right join Hospitales h
on h.cod_hospital=m.cod_hospital
group by h.cod_hospital, nombre

