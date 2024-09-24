insert into tipos (cod_tipo, nombre, descripcion, activo) 
values('TIP001', 'Tipo 001', 'Tipo 001', 1);

insert into tipos (cod_tipo, nombre, descripcion, activo) 
values('TIP002', 'Tipo 002', 'Tipo 002', 1);

insert into tipos (cod_tipo, nombre, descripcion, activo) 
values('TIP003', 'Tipo 003', 'Tipo 003', 1);

--------------------------------------------------------------

insert into estados (cod_estado, nombre, descripcion, activo) 
values('EST001', 'Estado 001', 'Estado 001', 1);

insert into estados (cod_estado, nombre, descripcion, activo) 
values('EST002', 'Estado 002', 'Estado 002', 1);

insert into estados (cod_estado, nombre, descripcion, activo) 
values('EST003', 'Estado 003', 'Estado 003', 1);

---------------------------------------------------------------


insert into medicos (pr_nombre, sg_nombre, pr_apellido, sg_apellido, tip_docu, nro_docu, est_med)
values ('Medico', null, '001', null, 1, '1123455', 1);

insert into medicos (pr_nombre, sg_nombre, pr_apellido, sg_apellido, tip_docu, nro_docu, est_med)
values ('Medico', null, '003', null, 1, '1123456', 1);

insert into medicos (pr_nombre, sg_nombre, pr_apellido, sg_apellido, tip_docu, nro_docu, est_med)
values ('Medico', null, '002', null, 1, '1123457', 1);


-----------------------------------------------------------------

insert into pacientes (pr_nombre, sg_nombre, pr_apellido, sg_apellido, tip_docu, nro_docu, est_pac, fecha_nacimiento, peso)
values ('Paciente', null, '001', null, 1, '1123423423', 1, '1999-05-31', 78.6);

insert into pacientes (pr_nombre, sg_nombre, pr_apellido, sg_apellido, tip_docu, nro_docu, est_pac, fecha_nacimiento, peso)
values ('Paciente', null, '002', null, 1, '11234234', 1, '1992-05-31', 92.6);

insert into pacientes (pr_nombre, sg_nombre, pr_apellido, sg_apellido, tip_docu, nro_docu, est_pac, fecha_nacimiento, peso)
values ('Paciente', null, '003', null, 1, '1123423426', 1, '1998-03-31', 59.3);


-------------------------------------------------------------------------------------

exec pr_nueva_visita 1, 1, '2024-09-29 16:31', 'Diagnostico 003', 'Tratamiento 003';