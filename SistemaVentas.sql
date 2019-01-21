create database SistemaVentas
go
use SistemaVentas
go
create table cliente(
cod_cliente char(10) primary key,
nombres varchar(50),
apellidos varchar(50),
dni varchar(10),
sexo varchar(15),
direccion varchar(50),
telefono varchar(10),
estado char(1))
go
create table venta(
num_documento char(10) primary key ,
serie	char(4), ---Defecto 
fecha		date ,
cod_cliente	char(10),
dni varchar(10),
total decimal(18,2),
estado		char(1)
)
go
create table producto(
cod_producto char(10) primary key,
nombre		varchar(50),
precio		decimal(9,2) ,
stock		int ,
cod_categoria char(10),
estado		char(1),
)
go
create table detalleventa(
num_documento	char(10) ,
serie	char(4) ,
cod_producto char(10) ,
cantidad	int ,
precio		decimal(9,2) ,
)
go
create table categoria(
cod_categoria char(10) primary key,
descripcion varchar(50),
estado char(1))
go
create table usuario(
cod_usuario char(10) primary key,
usuario varchar(40),
contraseña varchar(40),
tipo_usuario varchar(20),
estado char(1))
go
----alterando tablas,agregando su llave foranea
alter table producto add foreign key(cod_categoria)
references categoria(cod_categoria)
go
alter table detalleventa add foreign key(num_documento)
references venta(num_documento)
go
alter table venta add foreign key(cod_cliente)
references cliente(cod_cliente)
go
alter table detalleventa add foreign key(cod_producto)
references producto(cod_producto)
go
------------------------creando procedimientos almacenados
create proc insertar_categoria(
@cod_categoria char(10) output,
@descripcion varchar(50))
as
declare @num int
	begin
		if(select max(CONVERT(int,substring(cod_categoria,4,10))) from categoria) is not null
			begin
				select @num=max(CONVERT(int,substring(cod_categoria,4,10))) from categoria
				select @cod_categoria='CAT' + REPLICATE('0',7-
				DATALENGTH(convert(varchar,@num+1)))+
					CONVERT(varchar,@num+1)
		end
		else
			select @cod_categoria = 'CAT0000001'
			insert into categoria(cod_categoria,descripcion,estado)
			values(@cod_categoria,@descripcion,'1')
	end
go
create proc edita_categoria(
@cod_categoria char(10),
@descripcion varchar(50)
)
as
update categoria set descripcion=@descripcion
where cod_categoria=@cod_categoria
go
create proc elimina_categoria(
@cod_categoria char(10)
)
as
update categoria set estado='0'
where cod_categoria=@cod_categoria
go
create proc mostrar_categoria
as
select cod_categoria as 'Codigo Categoria',descripcion,estado from categoria where estado = 1
go
create proc buscar_categoria(
@texto varchar(50) = '%')
as
select * from categoria where descripcion like '%'+@texto+'%' and estado = '1'

go
create proc insertar_producto(
@cod_producto char(10) output,
@nombre varchar(50),
@precio decimal(9,2),
@stock int,
@cod_categoria  char(10)
)
as
declare @num int
	begin
		if(select max(CONVERT(int,substring(cod_producto,4,10))) from producto) is not null
			begin
				select @num=max(CONVERT(int,substring(cod_producto,4,10))) from producto
				select @cod_producto='PRO' + REPLICATE('0',7-
				DATALENGTH(convert(varchar,@num+1)))+
					CONVERT(varchar,@num+1)
		end
		else
			select @cod_producto = 'PRO0000001'
			insert into producto(cod_producto,nombre,precio,stock,cod_categoria,estado)
			values(@cod_producto,@nombre,@precio,@stock,@cod_categoria,'1')
	end
go
create proc edita_producto(
@cod_producto char(10) ,
@nombre varchar(50),
@precio decimal(9,2),
@stock int,
@cod_categoria  char(10)
)
as
update producto set nombre=@nombre,precio=@precio,stock=@stock,cod_categoria=@cod_categoria
where cod_producto=@cod_producto
go
create proc eliminar_producto(
@cod_producto char(10))
as
update producto set estado='0' where cod_producto=@cod_producto
go
create proc mostrar_producto
as
select * from producto where estado = 1
go
create proc buscar_producto(
@texto varchar(50) = '%')
as
select * from producto where nombre like '%'+@texto+'%' and estado = '1'
go
create proc insertar_cliente(
@cod_cliente char(10) output,
@nombres varchar(50),
@apellidos varchar(50),
@dni varchar(10),
@sexo varchar(15),
@direccion varchar(50),
@telefeono varchar(10)
)
as
declare @num int
	begin
		if(select max(CONVERT(int,substring(cod_cliente,4,10))) from cliente) is not null
			begin
				select @num=max(CONVERT(int,substring(cod_cliente,4,10))) from cliente
				select @cod_cliente='CLI' + REPLICATE('0',7-
				DATALENGTH(convert(varchar,@num+1)))+
					CONVERT(varchar,@num+1)
		end
		else
			select @cod_cliente = 'CLI0000001'
			insert into cliente(cod_cliente,nombres,apellidos,dni,sexo,direccion,telefono,estado)
			values(@cod_cliente,@nombres,@apellidos,@dni,@sexo,@direccion,@telefeono,'1')
	end
go
create proc editar_cliente(
@cod_cliente char(10) ,
@nombres varchar(50),
@apellidos varchar(50),
@dni varchar(10),
@sexo varchar(15),
@direccion varchar(50),
@telefeono varchar(10)
)
as
update cliente set nombres=@nombres,apellidos=@apellidos,dni=@dni,sexo=@sexo,direccion=@direccion,telefono=@telefeono
where cod_cliente=@cod_cliente
go
create proc eliminar_cliente(
@cod_cliente char(10))
as
update cliente set estado='0' where cod_cliente=@cod_cliente
go
create proc mostrar_cliente
as
select * from cliente where estado='1'
go
create proc buscar_cliente(
@texto varchar(50) = '%')
as
select * from cliente where (nombres like '%'+@texto+'%' or apellidos like '%'+@texto+'%' ) and estado = '1'
go


create proc insertar_venta(
@num_documento char(10) output,
@fecha date,
@cod_cliente char(10),
@dni_cliente varchar(10),
@total decimal(18,2))
as
insert into venta(num_documento,serie,fecha,cod_cliente,dni,total,estado)
			values(@num_documento,'001',@fecha,@cod_cliente,@dni_cliente,@total,'1')
go
create proc ingresa_detalle(
@num_documento char(10) out,
@cod_producto char(10),
@cantidad int,
@precio decimal(9,2)
)
as
insert into detalleventa(num_documento,serie,cod_producto,cantidad,precio)
values(@num_documento,'001',@cod_producto,@cantidad,@precio)
go
create proc mostrar_ventas
as
select v.num_documento as 'Numero de Documento',v.serie as 'Numero de Serie',v.fecha,c.nombres +' ' + c.apellidos as 'Cliente',
v.total as 'Ganancia',v.estado from cliente c inner join venta v on c.cod_cliente=v.cod_cliente
go
create view ventasview
as
select v.num_documento as 'NumeroDocumento',v.serie as 'Numero de Serie',v.fecha,c.nombres +' ' + c.apellidos as 'Cliente',
v.total as 'Ganancia',v.estado from cliente c inner join venta v on c.cod_cliente=v.cod_cliente
go
create proc buscar_venta
(@texto varchar(50) = '%')
as
select * from ventasview where (NumeroDocumento like '%'+@texto+'%' or Cliente like '%'+@texto+'%') and estado = '1'
go
create proc validar_usuario(
@usuario varchar(50),
@contraseña varchar(50))
as
select * from usuario where usuario = @usuario and contraseña = @contraseña and estado='1'
go
create proc vertotal
as
select sum(total) as 'total' from venta where estado = '1'
go
insert into usuario values('USER000001','codigoparatodos','123456','Administrador','1')
go
create proc bajar_stock(
@cod_producto char(10),
@stock int)
as
declare @stocka int
set @stocka = (select stock from producto where cod_producto=@cod_producto)
set @stock = (@stocka - @stock)
update producto set stock= @stock where cod_producto=@cod_producto
go
select * from producto





select * from cliente