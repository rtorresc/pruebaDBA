create database pruebadba;
go

/*Punto 1*/
create table tipos (
	tipoid int primary key identity (1, 1),
	cod_tipo varchar(10) constraint tipo_cod_tipo_unq unique,
	nombre varchar(50) not null,
	descripcion varchar(255) null,
	activo bit not null default 1
);
go

create table estados (
	estadoid int primary key identity (1, 1),
	cod_estado varchar(10) constraint tipo_cod_estado_unq unique,
	nombre varchar(50) not null,
	descripcion varchar(255) null,
	activo bit not null default 1
);
go

create table medicos (
	medicoid int primary key identity (1, 1),
	fecha_reg datetime not null default sysdatetime(),
	pr_nombre varchar(50) not null,
	sg_nombre varchar(50) null,
	pr_apellido varchar(50) not null,
	sg_apellido varchar(50) null,
	tip_docu int not null constraint medicos_tipo_documento_fk foreign key references tipos(tipoid),
	nro_docu varchar(50) not null constraint medicos_nro_documento_unq unique,
	est_med int not null constraint medicos_estado_medico_fk foreign key references estados(estadoid),
	activo bit not null default 1
);
go

create table pacientes (
	pacienteid int primary key identity (1, 1),
	fecha_reg datetime not null default sysdatetime(),
	pr_nombre varchar(50) not null,
	sg_nombre varchar(50) null,
	pr_apellido varchar(50) not null,
	sg_apellido varchar(50) null,
	tip_docu int not null constraint paciente_tipo_documento_fk foreign key references tipos(tipoid),
	nro_docu varchar(50) not null constraint paciente_nro_documento_unq unique,
	est_pac int not null constraint paciente_estado_paciente_fk foreign key references estados(estadoid),
	fecha_nacimiento date not null,
	peso numeric(5,2) not null,
	activo bit not null default 1
);
go

create table visitas (
	visitaid int primary key identity (1, 1),
	fecha_reg datetime not null default sysdatetime(),
	pacienteid int not null constraint visita_paciente_fk foreign key references pacientes(pacienteid),
	medicoid int not null constraint visita_medico_fk foreign key references medicos(medicoid),
	fecha_visita datetime not null,
	diagnostico varchar(255) not null,
	tratamiento varchar(255) not null
);
go


create table historiaClinica(
	historiaid int primary key identity (1, 1),
	pacienteid int not null constraint historia_paciente_fk foreign key references pacientes(pacienteid),
	ultimavisita int not null constraint historia_visita_fk foreign key references visitas(visitaid),
	fechaultimavisita datetime not null,
	ultimomedico int constraint historia_medico_fk foreign key references medicos(medicoid),
	diagnostico varchar(255) not null,
	tratamiento varchar(255) not null,
);
go


/*Punto 2*/
create procedure pr_nueva_visita (
	@pacienteid int,
	@medicoid int, 
	@fecha_visita datetime,
	@diagnostico varchar,
	@tratamiento varchar
) as 
BEGIN
		insert into visitas 
			(pacienteid, medicoid, fecha_visita, diagnostico, tratamiento)
		values (@pacienteid, @medicoid, @fecha_visita, @diagnostico, @tratamiento);
end;
go

/*Punto 3*/
create procedure pr_nueva_historia (@pacienteid int, @medicoid int, @visitaid int, @fecha datetime, @diagnostico varchar, @tratamiento varchar)
as
begin
begin transaction

	if not exists (select 1 from historiaClinica hc where hc.pacienteid = @pacienteid)
	begin 
		insert into historiaClinica (pacienteid, ultimavisita, fechaultimavisita, ultimomedico, diagnostico, tratamiento) 
		values (@pacienteid, @visitaid, @fecha, @medicoid, @diagnostico, @tratamiento);
	end
	else 
	begin
		update historiaClinica 
		set	ultimavisita = @visitaid,
			fechaultimavisita = @fecha,
			ultimomedico = @medicoid,
			diagnostico = @diagnostico,
			tratamiento = @tratamiento
		where pacienteid = @pacienteid;
	end
commit transaction;
end;
go



create trigger tr_nueva_visita 
on visitas 
after insert
as 
begin
	declare @pacienteid int; 
	declare @visitaid int;
	declare @fecha datetime;
	declare @medicoid int;
	declare @diagnostico varchar; 
	declare @tratamiento varchar;

	select 
		@pacienteid = i.pacienteid,
		@visitaid = i.visitaid,
		@fecha = i.fecha_visita,
		@medicoid = i.medicoid,
		@diagnostico = i.diagnostico,
		@tratamiento = i.tratamiento
	from inserted i;

	exec pr_nueva_historia @pacienteid, @medicoid, @visitaid, @fecha, @diagnostico, @tratamiento;
end;
go

/*Punto 4*/
select pa.pacienteid, pa.pr_nombre + ' ' + coalesce(pa.sg_nombre, '') nombres, pa.pr_apellido + ' ' + coalesce(pa.sg_apellido, '') apellidos, hc.fechaultimavisita
from pacientes pa 
inner join historiaClinica hc on hc.pacienteid = pa.pacienteid 
order by hc.fechaultimavisita desc;

/* Punto 5
	Para asegurar el rendimiento de la base de datos es importante la implementación de estrategias como la creación 
	de vistas materializadas para consultas de grandes volúmenes de datos que requieren validación cada cierto tiempo,
	como informes o estadísticas productos de estas. Otra estrategia útil es la implementación de índices en las 
	tablas y si el volumen de datos es muy grande se puede utilizar también partición en las tablas que manejan estos datos.

	Para mantenerla integridad de la información optaría por la no utilización de triggers en su lugar utilizar
	procedimientos almacenados y/o tareas programadas que cumplan con las mismas características, esto por facilidad
	de uso, control y lectura para el desarrollador a cargo. Algo importante a tener en cuenta es que tómese el método
	que se quiera usar es necesario que este cuente con todas las validaciones esperadas a fin de que no genere
	conflictos de información o de procedimiento.  

*/