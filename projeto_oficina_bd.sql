create database if not exists oficina;
use oficina;

-- criando tabela cliente
create table cliente(
	idCliente int auto_increment primary key,
    Fname varchar(10) not null,
    Lname varchar(10) not null,
    CPF char (11),
    Address varchar(45),
    Phone char(11)
);

-- criando tabela veiculo
create table veiculo(
	-- idVeiculo int auto_increment primary key,
    idCliente int,
    placa char(7) not null unique,
    cor enum('Branco', 'Preto', 'Vermelho', 'Cinza'),
    modelo enum('Motocicleta', 'Carro', 'Caminhão', 'Ônibus'),
    primary key(idCliente, placa),
    constraint fk_cliente_veiculo foreign key (idCliente) references cliente(idCliente)
);


-- criando tabela mecânico
create table mecanico(
	idMecanico int auto_increment primary key,
    MecName varchar(10) not null,
    Especialidade enum('Pintura', 'Elétrica', 'Consertos Gerais') default 'Consertos Gerais',
    Address varchar(45)
);

-- criando tabela peça
create table peca(
	idPeca int auto_increment primary key,
    valorPeca float,
    descricaoPeca varchar(30) not null
);

-- criando tabela serviço
create table servico(
	idServico int auto_increment primary key,
    idCliente int,
    idPeca int,
    tipoServico enum('Conserto', 'Revisão'),
    valorConserto float default 200.00,
    valorRevisao float default 100.00,
    constraint fk_cliente_servico foreign key (idCliente) references cliente(idCliente),
    constraint fk_peca_servico foreign key (idPeca) references peca(idPeca)
);

-- criando tabela ordem de serviço
create table ordem_servico(
	idOrdemServico int auto_increment primary key,
    idMecanico int,
    idServico int,
    dataEmissao date,
    dataEntrega date,
    valorServico float,
    statusServico enum('Iniciado', 'Em andamento', 'Finalizado'),
    constraint fk_mecanico_os foreign key (idMecanico) references mecanico(idMecanico),
    constraint fk_servico_os foreign key (idServico) references servico(idServico)
);


-- inserindo dados na tabela cliente
-- idCliente, Fname, Lname, CPF, Address, Phone
insert into cliente(Fname, Lname, CPF, Address, Phone) values
	('Maria', 'Silva', '00034759999', 'Rua Pintassilgo, 783', '68986722461'),
    ('Cauã', 'Nogueira', '75510102039', 'Avenida Taquarussu, 443', '63991371812'),
    ('Renan', 'Martins', '88972388904', 'Quadra A-D, 122', '82989466633'),
    ('Brenda', 'Fernandes', '44637381568', 'Travessa Dourado, 789', '68986975603'),
    ('Emanuelly', 'Aragão', '21134353227', 'Travessa Bom Jesus da Lapa, 439', '81996946597'),
    ('Liz', 'Neves', '98894883027', 'Travessa J, 100', '86988004311'),
    ('Teresinha', 'Mota', '57630010362', 'Rua Trinta e Nove, 839', '65992293268'),
    ('Heloise', 'Mendes', '59620118219', 'Rua Boulevard Augusto Monteiro, 557', '68989615052');

-- inserindo dados na tabela veiculo
-- idVeiculo, idCliente, placa, cor, modelo
insert into veiculo(idCliente, placa, cor, modelo) values
	(8, 'XPT0520', 'Vermelho', 'Carro'),
    (1, 'DFG0369', 'Branco', 'Carro'),
    (5, 'QWE5884', null, 'Carro'),
    (6, 'RTY2325', 'Vermelho', 'Motocicleta'),
    (7, 'UIO0014', 'Preto', 'Caminhão'),
    (3, 'ASD2256', 'Preto', 'Carro'),
    (4, 'FGH4785', 'Cinza', 'Carro'),
    (2, 'VBN5268', null, 'Ônibus');

-- inserindo dados na tabela mecânico
-- idMecanico, MecName, Especialidade, Address
insert into mecanico(MecName, Especialidade, Address) values
	('Cláudia', 'Pintura', 'Rua Treze, 20'),
    ('Leonardo', 'Elétrica', 'Rua Quatorze, 30'),
    ('Luiza', 'Consertos Gerais', 'Rua Quinze, 40'),
    ('Guilherme', default, 'Rua Dezesseis, 50');

-- inserindo dados na tabela peça
-- idPeca, valorPeca, descricaoPeca
insert into peca(valorPeca, descricaoPeca) values
	(100, 'Retrovisor'),
    (240, 'Pastilha de Freio'),
    (120, 'Óleo de Freio'),
    (50, 'Limpador de Parabrisa');
 update peca set valorPeca = 250 where descricaoPeca = 'Retrovisor';
 
-- inserindo dados na tabela serviço
-- idServico, idCliente, idPeca, tipoServico, valorConserto, valorRevisao
insert into servico(idCliente, idPeca, tipoServico, valorConserto, valorRevisao) values
	(5, 1, 'Conserto', default, null),
    (1, 2, 'Conserto', 500.00, null),
    (8, null, 'Revisão', null, default),
    (7, 3, 'Revisão',null, default);

-- inserindo dados na tabela ordem de serviço
-- idOrdemServico, idMecanico, idServico, dataEmissao, dataEntrega, valorServico, statusServico
insert into ordem_servico(idMecanico, idServico, dataEmissao, dataEntrega, valorServico, statusServico) values
	(3, 2, '2022-01-02', '2022-01-10', null, 'Finalizado'),
    (4, 1, '2022-09-20', null, null, 'Em andamento'),
    (1, 3, '2022-09-22', null, null, 'Iniciado'),
    (2, 4, '2022-05-15', '2022-05-25', null, 'Finalizado');
alter table ordem_servico drop column valorServico;


-- querys
--

show tables;
desc cliente;
select * from servico;

-- Qual serviço foi solicitado pelo cliente e para qual veículo? 
select concat(Fname, ' ', Lname) as Cliente, modelo as Veículo, tipoServico as Tipo_de_Serviço from cliente c
		inner join veiculo v on c.idCliente = v.idCliente
        inner join servico s on c.idCliente = s.idCliente
        order by c.Fname;

-- Lista de serviços e peças usadas, valor do serviço e da peça
select idOrdemServico, tipoServico, descricaoPeca, valorConserto, valorRevisao, valorPeca from servico s
		left outer join peca p on s.idPeca = p.idPeca
		inner join ordem_servico o on s.idServico = o.idServico
        order by idOrdemServico;
        
-- Lista apenas serviços que utilizaram peças, valor do serviço e da peça
select tipoServico as Tipo_de_Serviço, descricaoPeca as Peça, valorConserto, valorRevisao, valorPeca from servico s
		inner join ordem_servico o on s.idServico = o.idServico
        inner join peca p on s.idpeca = p.idPeca
        order by valorPeca desc;
        
-- Quantas carros constam no cadastro de clientes?
select count(*) as Total_de_Carros_Cadastrados from veiculo
		where modelo = 'carro';

-- Quantas vezes carro aparece nas solicitações de serviço?
select modelo, count(*) as Total_de_Carros_na_Oficina from veiculo v
		inner join cliente c on v.idCliente = c.idCliente
        inner join servico s on s.idCliente = c.idCliente
        where modelo = 'carro';
        
-- Quais cores de veículos aparecem mais de 1 vez?
select cor, count(*) from veiculo
		group by cor
        having count(cor) > 1;
        
-- Relação de mecânico e ordem de serviço emitida
select idOrdemServico, MecName as Mecânico, Especialidade, dataEmissao from mecanico m, ordem_servico o
		where m.idMecanico = o.idMecanico
        order by idOrdemServico;

-- Lista todos os clientes cadastrados e quais solicitaram serviços
select concat(Fname, ' ', Lname) Cliente, CPF, Address, Phone, tipoServico from cliente c
		left outer join servico s
        on c.idCliente = s.idCliente;

-- Relacao cliente, veículo, serviço, mecânico e status do serviço
select concat(Fname, ' ', Lname) Cliente, CPF, modelo, placa, tipoServico, MecName Mecânico, Especialidade, statusServico from cliente c
		inner join veiculo v on c.idCliente = v.idCliente
        inner join servico s on c.idCliente = s.idCliente
        inner join ordem_servico o on o.idServico = s.idServico
        inner join mecanico m on m.idMecanico = o.idMecanico
        order by Cliente;





