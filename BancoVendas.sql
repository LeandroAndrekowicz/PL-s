CREATE TABLE Categorias(
	id serial primary key,
	descricao varchar(50),
	id_pai integer REFERENCES Categorias(id),
	caminho_busca text
)

CREATE TABLE Produtos (
    id serial primary key,
    descricao VARCHAR(100),
    unidade VARCHAR(3),
    categoria integer REFERENCES Categorias(id),
    preco numeric(15,2)
);

CREATE TABLE Historico_preco(
	id_produto integer REFERENCES Produtos(id),
	momento timestamp,
	preco numeric(15,2),
	constraint pk_historico_preco primary key (id_produto, momento)
);

CREATE TABLE Empresa(
	cnpj cpf_cnpj primary key,
	razao_social varchar(80)
);

CREATE TABLE Clientes(
	cliente_cpf_cnpj cpf_cnpj primary key,
	nome varchar(80) not null
);

CREATE TABLE Fornecedores(
	fornecedor_cnpj cpf_cnpj primary key,
	nome varchar(80)
);

CREATE TABLE Vendas(
	id serial primary key,
	cliente_cpf_cnpj cpf_cnpj not null references Clientes(cliente_cpf_cnpj),
	empresa_cnpj cpf_cnpj not null references Empresa(cnpj),
	data timestamp default current_timestamp,
	total_compra numeric(15, 2)
);

CREATE TABLE Compras(
	id serial primary key,
	fornecedor_cpf_cnpj cpf_cnpj not null references Fornecedores(fornecedor_cnpj),
	empresa_cnpj cpf_cnpj not null references Empresa(cnpj),
	data timestamp default current_timestamp,
	total_compra numeric(15, 2)
);

CREATE TABLE Itens_vendas(
	id serial primary key,
	id_produto integer not null REFERENCES Produtos(id),
	id_venda integer not null REFERENCES Vendas(id),
	quantidade integer not null default 1,
	preco numeric(15, 2) not null default 0.00,
	total_item numeric(15, 2)
);

CREATE TABLE Itens_compras(
	id serial primary key,
	id_produto integer not null REFERENCES Produtos(id),
	id_compra integer not null REFERENCES Compras(id),
	quantidade integer not null default 1,
	preco numeric(15, 2) not null default 0.00,
	total_item numeric(15, 2)
);

CREATE TABLE Movimento_estoque (
	id bigserial not null primary key,
	id_produto integer not null references Produtos(id),
	tipo char(1) check (tipo in ('E', 'S')),
	quantidade integer not null,
	preco numeric(15,2) not null default 0.00,
	fonte varchar(50),
	referencia varchar(20)
);




CREATE or REPLACE FUNCTION Cria_caminho_busca (p_id integer) returns text
AS
	$corpo$
DECLARE
	_cat record;
	_aux text = '';
BEGIN
	SELECT id, id_pai from Categorias where id = p_id into _cat;
	
	if _cat.id_pai is not null then
		_aux =Cria_caminho_busca(_cat.id_pai);
	end if;
	
	_aux = _aux || '.' || _cat.id::text;
	
	return trim(_aux, '.');
END;
	$corpo$
LANGUAGE PLPGSQL;

select Cria_caminho_busca(3);

drop function Cria_caminho_busca