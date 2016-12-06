create user if NOT EXISTS "nelson"@"localhost" identified by '2222';
grant all privileges on *.* to "nelson"@"localhost";
flush privileges;


drop database if exists floreria;
create database	if not exists floreria;
use floreria;

drop table if exists usuarios;
create table usuarios(
	cuenta 				varchar(25) not null,
	nombre 				varchar(25) default 'sqlsin nombre',
	apellido			varchar(25)	default 'sqlsin apellido',
	cedula				varchar(20)	default 'registro sin cedula',
	numero				varchar(20)	default 'registro sin numero',
	direccion			varchar(100)default	'registro sin direccion',
	clave				varchar(50)	default 'registro sin clave',
	estado				varchar(15)	default 'activo',
	tipo 				varchar(15) default 'usuario',
	primary key(cuenta)
);

insert into usuarios values 
	('esmarlin_floreria','Esmarlin','Rosario','402-5345344-9','809-724-825','Pantoja','2222',default,default),
	('manuel_floreria','Manuel','Gutierrez','602-3531329-9','809-824-5375','Pantoja','2222',default,default),
	('juan_floreria','Juan','Martinez','632-0584801-9','849-284-255','Alcarrizos','2222',default,default)
;


#=============================================================
drop table if exists productos;
create table if not exists productos(
	id_producto			int zerofill not null auto_increment,
	nombre				varchar(20)  unique,
	precio				float(10,2)	 unsigned default 0,
	cantidad			int 		 unsigned default 0,
	stock				int 		 unsigned default 10,
	estado				varchar(15)	 default 'sqlsinestado',
	categoria 			int zerofill not null,
	registro 			date,
	primary key(id_producto)
);
#-------------------------------------------------------------
drop table if exists categorias;
create table if not exists categorias(
	id_categoria		int zerofill not null auto_increment,
	nombre				varchar(50) default 'sin categoria',
	estado				enum('activo','clausurado') default 'activo',
	primary key(id_categoria)
);

insert into categorias values 
	(default,'Flores Amarillas',default),
	(default,'Flores Roja',default),
	(default,'Flores Rosas',default),
	(default,'Decoracion',default)
;
#=============================================================

drop table if exists imagenes;
create table if not exists imagenes(
	id_imagen			int zerofill not null auto_increment,
	id_propietario		int default -1,
	tipo_imagen			varchar(15),
	url 				text,
	primary key(id_imagen)
);


drop table if exists facturas;
create table if not exists facturas(
	id_factura			int zerofill not null auto_increment,
	usuario 			varchar(25) not null,
	fecha				timestamp,
	primary key(id_factura),
	constraint foreign key(usuario) references usuarios(cuenta)			 on delete cascade on update cascade
);

drop table if exists detalles_facturas;
create table detalles_facturas(
	factura 			int zerofill not null,
	producto    		int zerofill not null,
	cantidad			int unsigned not null,
	precio				float(10,2)	unsigned default 0,
	constraint foreign key(producto) references productos(id_producto)			 on delete cascade on update cascade
);


drop trigger if exists restar_cantidad_producto;
delimiter //#
	create trigger restar_cantidad_producto before insert on detalles_facturas
		for each row begin 
			update productos set cantidad=cantidad-new.cantidad where id_producto=new.producto;
		end
// delimiter ;