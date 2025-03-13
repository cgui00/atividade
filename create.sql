create database atividade
default character set utf8mb4
default collate utf8mb4_general_ci;

create table clients (
id_cliente int primary key not null unique auto_increment,
nome varchar(100),
gmail varchar(50) unique
);  

create table products (
id_produto int primary key not null unique auto_increment,
nomes varchar(30),
princes varchar(10)
);
    

create table orders (
id_orders int primary key not null unique auto_increment,
tld int,
cld int,
dates date,
statu varchar(30)
);

create table productsche (
sId int,
pId int,
quantitys int
);
