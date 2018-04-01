use db_review;
go

-- drop table auditoria

create table AUDITORIA (
	codigoAuditoria int identity primary key,
	usuarioAuditoria VARCHAR(10) not null,
	fecha VARCHAR(10) not null,
	hora char(8) not null,
	accion varchar(20) not null,
	tabla varchar(20) not null,
	registroNro varchar(50) not null,
	nombreColumna varchar(70) not null,
	antiguaDescripcion varchar(50),
	nuevaDescripcion varchar(50) not null
);
go