create database revenda_rebecaCoelho 

CREATE TABLE vendedores (
    id_vendedor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    id_vendedor_cadastro INT,
    FOREIGN KEY (id_vendedor_cadastro) REFERENCES vendedores(id_vendedor)
);

CREATE TABLE formas_pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
);


CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT
);

CREATE TABLE produtos (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    id_categoria INT,
    tamanho VARCHAR(10) CHECK (tamanho IN ('P', 'M', 'G', 'GG', 'Único')),
    preco DECIMAL(10,2) NOT NULL CHECK (preco > 0),
    estoque INT NOT NULL DEFAULT 0,
    descricao TEXT,
    fabricante VARCHAR(100),
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE vendas (
    id_venda SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_vendedor INT NOT NULL,
    id_pagamento INT NOT NULL,
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Concluída' CHECK (status IN ('Pendente', 'Concluída', 'Cancelada')),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor),
    FOREIGN KEY (id_pagamento) REFERENCES formas_pagamento(id_pagamento)
);


CREATE TABLE alugueis (
    id_aluguel SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_vendedor INT NOT NULL,
    id_pagamento INT NOT NULL,
    data_aluguel TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_devolucao DATE NOT NULL,
    valor_caucao DECIMAL(10,2) DEFAULT 0.00,
    status VARCHAR(20) DEFAULT 'Ativo' CHECK (status IN ('Ativo', 'Devolvido', 'Atrasado')),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor),
    FOREIGN KEY (id_pagamento) REFERENCES formas_pagamento(id_pagamento)
);

CREATE VIEW view_vendas_detalhadas AS
SELECT 
    v.id_venda,
    c.nome AS cliente,
    ven.nome AS vendedor,
    fp.descricao AS forma_pagamento,
    v.data_venda,
    v.status
FROM vendas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN vendedores ven ON v.id_vendedor = ven.id_vendedor
JOIN formas_pagamento fp ON v.id_pagamento = fp.id_pagamento;

CREATE VIEW view_produtos_categorias AS
SELECT 
    p.id_produto,
    p.nome AS produto,
    c.nome AS categoria,
    p.tamanho,
    p.preco,
    p.estoque,
    p.fabricante
FROM produtos p
JOIN categorias c ON p.id_categoria = c.id_categoria;

CREATE VIEW view_alugueis_detalhados AS
SELECT 
    a.id_aluguel,
    c.nome AS cliente,
    ven.nome AS vendedor,
    fp.descricao AS forma_pagamento,
    a.data_aluguel,
    a.data_devolucao,
    a.valor_caucao,
    a.status
FROM alugueis a
JOIN clientes c ON a.id_cliente = c.id_cliente
JOIN vendedores ven ON a.id_vendedor = ven.id_vendedor
JOIN formas_pagamento fp ON a.id_pagamento = fp.id_pagamento;

CREATE VIEW view_clientes_vendedores AS
SELECT 
    cl.id_cliente,
    cl.nome AS cliente,
    cl.email,
    cl.telefone,
    v.nome AS vendedor_cadastro
FROM clientes cl
LEFT JOIN vendedores v ON cl.id_vendedor_cadastro = v.id_vendedor;

CREATE VIEW view_estoque_baixo AS
SELECT 
    p.id_produto,
    p.nome AS produto,
    c.nome AS categoria,
    p.estoque,
    p.preco
FROM produtos p
JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE p.estoque < 5;


INSERT INTO vendedores (nome, email) VALUES
('Ana Costureira', 'ana@cosplaystore.com'),
('Carlos Cosplayer', 'carlos@cosplaystore.com'),
('María Fantasias', 'maria@cosplaystore.com'),
('João Acessórios', 'joao@cosplaystore.com'),
('Pedro Cosplays', 'pedro@cosplaystore.com'),
('Laura Fantasias', 'laura@cosplaystore.com'),
('Ricardo Acessórios', 'ricardo@cosplaystore.com'),
('Fernanda Costureira', 'fernanda@cosplaystore.com'),
('Bruno Cosplayer', 'bruno@cosplaystore.com'),
('Juliana Fantasias', 'juliana@cosplaystore.com');

INSERT INTO formas_pagamento (descricao) VALUES
('Dinheiro'),
('PIX'),
('Cartão Débito'),
('Cartão Crédito'),
('Cartão Crédito'),
('Cartão Crédito'),
('Boleto Bancário'),
('Transferência Bancária'),
('PayPal'),
('PicPay');

INSERT INTO categorias (nome, descricao) VALUES
('Anime', 'Cosplays de personagens de anime'),
('Games', 'Cosplays de personagens de jogos'),
('Filmes', 'Cosplays de personagens de filmes'),
('Séries', 'Cosplays de personagens de séries'),
('Acessórios', 'Acessórios e complementos para cosplay'),
('Quadrinhos', 'Cosplays de personagens de quadrinhos'),
('Fantasia', 'Cosplays de fantasia medieval e épica'),
('Ficção Científica', 'Cosplays de ficção científica'),
('Super Heróis', 'Cosplays de super heróis'),
('Vintage', 'Cosplays de personagens vintage e retro');


INSERT INTO clientes (nome, email, telefone, id_vendedor_cadastro) VALUES
('Lucas Otaku', 'lucas@email.com', '11999990001', 1),
('Sakura Chan', 'sakura@email.com', '11999990002', 2),
('Naruto Kun', 'naruto@email.com', '11999990003', 3),
('Goku San', 'goku@email.com', '11999990004', 1),
('Mario Bros', 'mario@email.com', '11999990005', 2),
('Hinata Hyuga', 'hinata@email.com', '11999990006', 4),
('Sasuke Uchiha', 'sasuke@email.com', '11999990007', 5),
('Vegeta Prince', 'vegeta@email.com', '11999990008', 6),
('Luigi Bros', 'luigi@email.com', '11999990009', 7),
('Princess Peach', 'peach@email.com', '11999990010', 8);

INSERT INTO produtos (nome, id_categoria, tamanho, preco, estoque, descricao, fabricante) VALUES
('Cosplay Naruto Shippuden', 1, 'M', 299.90, 5, 'Cosplay completo do Naruto', 'AnimeCostumes'),
('Cosplay Sakura Haruno', 1, 'P', 279.90, 3, 'Vestido médico da Sakura', 'CosplayWorld'),
('Cosplay Goku Ultra Instinct', 1, 'G', 459.90, 2, 'Cosplay completo Goku UI', 'DragonBallStore'),
('Cosplay Mario Bros', 2, 'GG', 199.90, 8, 'Macacão do Mario completo', 'GameCosplays'),
('Cosplay Wonder Woman', 3, 'M', 389.90, 4, 'Traje da Mulher Maravilha', 'DCFantasias'),
('Espada do Ichigo', 5, 'Único', 89.90, 15, 'Réplica da Zangetsu', 'AnimeAcessorios'),
('Pistola do Resident Evil', 5, 'Único', 129.90, 10, 'Réplica da Samurai Edge', 'GameAcessorios'),
('Coroa da Daenerys', 4, 'Único', 69.90, 20, 'Réplica da coroa de ferro', 'GoTStore'),
('Cosplay Homem de Ferro', 8, 'G', 899.90, 2, 'Armadura completa do Homem de Ferro', 'MarvelStore'),
('Cosplay Capitã Marvel', 8, 'M', 659.90, 3, 'Traje completo da Capitã Marvel', 'MarvelStore');

INSERT INTO vendas (id_cliente, id_vendedor, id_pagamento, status) VALUES
(1, 1, 1, 'Concluída'),
(2, 2, 3, 'Concluída'),
(3, 3, 4, 'Concluída'),
(4, 1, 2, 'Concluída'),
(5, 4, 5, 'Concluída'),
(6, 5, 6, 'Concluída'),
(7, 6, 7, 'Pendente'),
(8, 7, 8, 'Concluída'),
(9, 8, 9, 'Cancelada'),
(10, 9, 10, 'Concluída');

INSERT INTO alugueis (id_cliente, id_vendedor, id_pagamento, data_devolucao, valor_caucao, status) VALUES
(1, 1, 1, '2024-02-15', 100.00, 'Devolvido'),
(2, 2, 2, '2024-02-20', 150.00, 'Ativo'),
(3, 3, 3, '2024-02-10', 200.00, 'Atrasado'),
(4, 4, 4, '2024-02-25', 120.00, 'Ativo'),
(5, 5, 5, '2024-02-18', 180.00, 'Devolvido'),
(6, 6, 6, '2024-02-22', 90.00, 'Ativo'),
(7, 7, 7, '2024-02-12', 160.00, 'Atrasado'),
(8, 8, 8, '2024-02-28', 140.00, 'Ativo'),
(9, 9, 9, '2024-02-16', 110.00, 'Devolvido'),
(10, 1, 10, '2024-02-30', 170.00, 'Ativo');

select * from view_estoque_baixo;

select * from view_alugueis_detalhados;



select * from clientes where nome like '%sakura%';

explain select * from clientes where nome like '%sakura%';

create index idx_clientes_nome on clientes(nome);

explain select * from clientes where nome like '%sakura%';

alter table clientes alter column nome type integer;

alter table produtos alter column preco type varchar(20);

create user rebeca_coelho with password 'senha123';
grant all privileges on database revenda_rebecacoelho to rebeca_coelho;
grant all privileges on all tables in schema public to rebeca_coelho;

create user colega_rebeca with password 'colega123';
grant select on clientes to colega_rebeca;

set role colega_rebeca;
select * from vendedores;
select * from clientes;
reset role;

select c.nome as cliente, v.nome as vendedor
from clientes c
inner join vendedores v on c.id_vendedor_cadastro = v.id_vendedor;

select c.nome as cliente, v.nome as vendedor
from clientes c
left join vendedores v on c.id_vendedor_cadastro = v.id_vendedor;

select c.nome as cliente, v.nome as vendedor
from clientes c
right join vendedores v on c.id_vendedor_cadastro = v.id_vendedor;

select p.nome as produto, c.nome as categoria
from produtos p
inner join categorias c on p.id_categoria = c.id_categoria;

select p.nome as produto, c.nome as categoria
from produtos p
left join categorias c on p.id_categoria = c.id_categoria;

select p.nome as produto, c.nome as categoria
from produtos p
right join categorias c on p.id_categoria = c.id_categoria;

select v.id_venda, c.nome as cliente, ven.nome as vendedor
from vendas v
inner join clientes c on v.id_cliente = c.id_cliente
inner join vendedores ven on v.id_vendedor = ven.id_vendedor;

select v.id_venda, c.nome as cliente, ven.nome as vendedor
from vendas v
left join clientes c on v.id_cliente = c.id_cliente
left join vendedores ven on v.id_vendedor = ven.id_vendedor;

select v.id_venda, c.nome as cliente, ven.nome as vendedor
from vendas v
right join clientes c on v.id_cliente = c.id_cliente
right join vendedores ven on v.id_vendedor = ven.id_vendedor;

select a.id_aluguel, c.nome as cliente, p.descricao as pagamento
from alugueis a
inner join clientes c on a.id_cliente = c.id_cliente
inner join formas_pagamento p on a.id_pagamento = p.id_pagamento;

select a.id_aluguel, c.nome as cliente, p.descricao as pagamento
from alugueis a
left join clientes c on a.id_cliente = c.id_cliente
left join formas_pagamento p on a.id_pagamento = p.id_pagamento;

select a.id_aluguel, c.nome as cliente, p.descricao as pagamento
from alugueis a
right join clientes c on a.id_cliente = c.id_cliente
right join formas_pagamento p on a.id_pagamento = p.id_pagamento;

update clientes set id_vendedor_cadastro = null where id_cliente in (1, 3, 5);

select c.nome as cliente, v.nome as vendedor
from clientes c
inner join vendedores v on c.id_vendedor_cadastro = v.id_vendedor;

select c.nome as cliente, v.nome as vendedor
from clientes c
left join vendedores v on c.id_vendedor_cadastro = v.id_vendedor;

select c.nome as cliente, v.nome as vendedor
from clientes c
right join vendedores v on c.id_vendedor_cadastro = v.id_vendedor;

