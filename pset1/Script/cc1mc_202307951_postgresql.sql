--Aluno: Eduardo Godio Rodrigues
--Matrícula: 202307951
--Turma: cc1mc

/* VERIFICAR EXISTÊNCIA */
/* DO BANCO DE DADOS    */
/* E DO USUÁRIO         */

--Excluir o banco de dados "uvv" caso exista.

DROP DATABASE IF EXISTS uvv;

--Excluir o usuário "eduardo_godio" caso exista.

DROP USER IF EXISTS eduardo_godio;

/* CRIAR        */
/* USUÁRIO      */
/* PROPRIETÁRIO */

--Criar usuário "eduardo_godio" com a senha.

CREATE USER        eduardo_godio 
WITH               CREATEDB CREATEROLE 
ENCRYPTED PASSWORD 'computacao@raiz';

--Conectar ao usuário "eduardo_godio".

SET ROLE eduardo_godio;

/* CRIAR */
/* BANCO */
/* DE    */
/* DADOS */

--Criar o banco de dados "uvv", definindo o usuário "eduardo_godio" como proprietário.

CREATE DATABASE     uvv
WITH OWNER        = eduardo_godio
TEMPLATE          = template0
ENCODING          = 'UTF8'
LC_COLLATE        = 'pt_BR.UTF8'
LC_CTYPE          = 'pt_BR.UTF8'
ALLOW_CONNECTIONS = true;

--Criar comentário do banco de dados "uvv".

COMMENT ON DATABASE uvv IS 'Esse banco de dados é utilizado para armazenar informações da UVV. Esse banco de dados armazena diversas informações como cadastro dos clientes, informações das lojas, pedidos realizados, entre outras funcionalidades';

/* CONECTAR AO */
/* BANCO       */
/* DE          */
/* DADOS       */

--Inserir a senha do usuário.

\setenv PGPASSWORD computacao@raiz

--Conectar ao banco de dados "uvv".

\c uvv eduardo_godio

/* CRIAR   */
/* ESQUEMA */

--Criar esquema "lojas".

CREATE SCHEMA lojas AUTHORIZATION eduardo_godio;

--Criar comentário do esquema "lojas".

COMMENT ON SCHEMA lojas IS 'Esse esquema representa as lojas da UVV.';

--Alterar o caminho(search_path) para o esquema lojas do usuário "eduardo_godio" para sessões futuras.

ALTER USER eduardo_godio
SET SEARCH_PATH TO lojas, "$user", public;

--Alterar o caminho(search_path) para o esquema lojas na sessão atual.

SET SEARCH_PATH TO lojas, "$user", public;

/* CRIAR        */
/* TABELAS      */
/* COM          */
/* COMENTÁRIOS  */
/* E RESTRIÇÕES */

/* CRIAR TABELA */
/* PRODUTOS     */

--Criar tabela produtos.

CREATE TABLE lojas.produtos (
                produto_id                NUMERIC(38)   NOT NULL,
                nome                      VARCHAR(255)  NOT NULL,
                preco_unitario            NUMERIC(10,2) NOT NULL,
                detalhes                  BYTEA,
                imagem                    BYTEA,
                imagem_mime_type          VARCHAR(512),
                imagem_arquivo            VARCHAR(512),
                imagem_charset            VARCHAR(512),
                imagem_ultima_atualizacao DATE
);

--Criar PK da tabela produtos.

ALTER TABLE    lojas.produtos
ADD CONSTRAINT pk_produtos
PRIMARY KEY   (produto_id);

--Criar restrição do preço unitário.

ALTER TABLE    lojas.produtos
ADD CONSTRAINT cc_produtos_preco_unitario
CHECK         (preco_unitario >= 0);

-- Criar comentários da tabela produtos.

COMMENT ON TABLE  lojas.produtos                           IS 'Essa tabela registra os produtos.';
COMMENT ON COLUMN lojas.produtos.produto_id                IS 'Essa coluna contém o id do produto, sendo a PK da tabela "produtos". Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.produtos.nome                      IS 'Essa coluna contém o nome do produto. Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.produtos.preco_unitario            IS 'Essa coluna contém o preço unitário do produto. Apenas valores maiores ou iguais a 0 podem ser inseridos. Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.produtos.detalhes                  IS 'Essa coluna contém os detalhes do produto.';
COMMENT ON COLUMN lojas.produtos.imagem                    IS 'Essa coluna contém a imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type          IS 'Essa coluna contém o mime type da imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo            IS 'Essa coluna contém o arquivo da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_charset            IS 'Essa coluna contém o charset da imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Essa coluna contém a ultima atualização na imagem do produto.';


/* CRIAR TABELA */
/* LOJAS        */

--Criar tabela lojas.

CREATE TABLE lojas.lojas (
                loja_id                 NUMERIC(38)  NOT NULL,
                nome                    VARCHAR(255) NOT NULL,
                endereco_web            VARCHAR(100),
                endereco_fisico         VARCHAR(512),
                latitude                NUMERIC,
                longitude               NUMERIC,
                logo                    BYTEA,
                logo_mime_type          VARCHAR(512),
                logo_arquivo            VARCHAR(512),
                logo_charset            VARCHAR(512),
                logo_ultima_atualizacao DATE
);

--Criar PK da tabela lojas.

ALTER TABLE    lojas.lojas
ADD CONSTRAINT pk_lojas
PRIMARY KEY   (loja_id);

--Criar restrição das colunas "endereco_fisico" e "endereco_web", fazendo com que orbigatoriamente uma delas não seja nula.

ALTER TABLE    lojas.lojas
ADD CONSTRAINT cc_endereco_fisico_web
CHECK         (COALESCE(endereco_web, '') <> '' 
OR             COALESCE(endereco_fisico, '') <> '');

--Criar comentários da tabela lojas.

COMMENT ON TABLE  lojas.lojas                         IS 'Essa tabela registra as lojas existentes.';
COMMENT ON COLUMN lojas.lojas.loja_id                 IS 'Essa coluna contém o id da loja, sendo a PK da tabela "lojas". Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.lojas.nome                    IS 'Essa coluna contém o nome da loja. Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.lojas.endereco_web            IS 'Essa coluna contém o endereço web relacionado a loja. Essa coluna pode ser nula apenas se a coluna "endereco_fisico" tiver algum valor inserido.';
COMMENT ON COLUMN lojas.lojas.endereco_fisico         IS 'Essa coluna contém o endereço físico da loja. Essa coluna pode ser nula apenas se a coluna "endereco_web" tiver algum valor inserido.';
COMMENT ON COLUMN lojas.lojas.latitude                IS 'Essa coluna contém a latitude da loja.';
COMMENT ON COLUMN lojas.lojas.longitude               IS 'Essa coluna contém a longitude da loja.';
COMMENT ON COLUMN lojas.lojas.logo                    IS 'Essa coluna contém a logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_mime_type          IS 'Essa coluna contém o mime type do logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_arquivo            IS 'Essa coluna contém o arquivo do logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_charset            IS 'Essa coluna contém o charset usado no logo da loja.';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'Essa coluna contém a data da ultima atualização no logo da loja.';

/* CRIAR TABELA */
/* ESTOQUES     */

--Criar tabela estoques.

CREATE TABLE lojas.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id    NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL
);

--Criar PK da tabela estoques.

ALTER TABLE    lojas.estoques
ADD CONSTRAINT pk_estoques
PRIMARY KEY   (estoque_id);

--Criar restrição do valor da quantidade.

ALTER TABLE    lojas.estoques
ADD CONSTRAINT cc_estoques_quantidade
CHECK         (quantidade >= 0);

--Criar comentários da tabela estoques.

COMMENT ON TABLE  lojas.estoques            IS 'Essa tabela registra o estoque de produtos em cada loja.';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'Essa coluna contém o id do estoque, sendo a PK da tabela "estoques". Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.estoques.loja_id    IS 'Essa coluna contém o id da loja, sendo FK da tabela "lojas" para a tabela "estoques". Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'Essa coluna contém o id do produto, sendo FK da tabela "produtos" para a tabela "estoques". Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'Essa coluna contém a quantidade de produtos no estoque. Apenas valores maiores ou iguais a 0 podem ser inseridos. Essa coluna não pode conter valor null.';

/* CRIAR TABELA */
/* CLIENTES     */

--Criar tabela clientes.

CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38)  NOT NULL,
                email      VARCHAR(255) NOT NULL,
                nome       VARCHAR(255) NOT NULL,
                telefone1  VARCHAR(20),
                telefone2  VARCHAR(20),
                telefone3  VARCHAR(20)
);

--Criar PK da tabela clientes.

ALTER TABLE    lojas.clientes
ADD CONSTRAINT pk_clientes
PRIMARY KEY   (cliente_id);

--Criar comentários da tabela clientes.

COMMENT ON TABLE  lojas.clientes            IS 'Essa tabela registra o cadastro dos clientes.';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'Essa coluna contém o id do cliente, sendo a PK da tabela "clientes". Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.clientes.email      IS 'Essa coluna contém o email do cliente. Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.clientes.nome       IS 'Essa coluna contém o nome do cliente. Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.clientes.telefone1  IS 'Essa coluna contém espaço para um número de telefone.';
COMMENT ON COLUMN lojas.clientes.telefone2  IS 'Essa coluna contém um espaço para um segundo número de telefone.';
COMMENT ON COLUMN lojas.clientes.telefone3  IS 'Essa coluna contém espaço para um terceiro número de telefone.';

/* CRIAR TABELA */
/* ENVIOS       */

--Criar tabela envios.

CREATE TABLE lojas.envios (
                envio_id         NUMERIC(38)  NOT NULL,
                loja_id          NUMERIC(38)  NOT NULL,
                cliente_id       NUMERIC(38)  NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status           VARCHAR(15)  NOT NULL
);

--Criar PK da tabela envios.

ALTER TABLE    lojas.envios
ADD CONSTRAINT pk_envios
PRIMARY KEY   (envio_id);

--Criar restrição do valor do status da tabela envios.

ALTER TABLE    lojas.envios
ADD CONSTRAINT cc_envios_status
CHECK         (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

--Criar comentários da tabela envios.

COMMENT ON TABLE  lojas.envios                  IS 'Essa tabela registra os envios.';
COMMENT ON COLUMN lojas.envios.envio_id         IS 'Essa coluna contém o id do envio, sendo PK da tabela "envios". Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.envios.loja_id          IS 'Essa coluna contém o id do envio, sendo FK da tabela "lojas" para a tabela "envios". Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.envios.cliente_id       IS 'Essa coluna contém o id do cliente, sendo FK da tabela "clientes" para a tabela "envios". Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'Essa coluna contém o endereço de entrega do envio. Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.envios.status           IS 'Essa coluna contém o status do envio. Apenas valores "CRIADO","ENVIADO","TRANSITO" e "ENTREGUE" podem ser inseridos na tabela.Essa coluna não pode conter valor null.';

/* CRIAR TABELA */
/* PEDIDOS      */

--Criar tabela pedidos.

CREATE TABLE lojas.pedidos (
                pedido_id  NUMERIC(38) NOT NULL,
                data_hora  TIMESTAMP   NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status     VARCHAR(15) NOT NULL,
                loja_id    NUMERIC(38) NOT NULL
);

--Criar PK da tabela pedidos.

ALTER TABLE    lojas.pedidos
ADD CONSTRAINT pk_pedidos
PRIMARY KEY   (pedido_id);

--Criar restrição do valor do status da tabela pedidos.

ALTER TABLE    lojas.pedidos
ADD CONSTRAINT cc_pedidos_status
CHECK         (status IN ('CANCELADO', 'COMPLETO','ABERTO','PAGO','REEMBOLSADO','ENVIADO'));

--Criar comentários da tabela pedidos.

COMMENT ON TABLE  lojas.pedidos            IS 'Essa tabela registra os pedidos realizados.';
COMMENT ON COLUMN lojas.pedidos.pedido_id  IS 'Essa coluna contém o id do pedido, sendo a PK da tabela "pedidos". Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.pedidos.data_hora  IS 'Essa coluna representa a data e a hora que o pedido foi feito. Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'Essa coluna contém o id do cliente, sendo uma FK da tabela "clientes" para a tabela "pedidos". Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.pedidos.status     IS 'Essa coluna contém o status do pedido. Apenas valores "CANCELADO", "COMPLETO", "ABERTO", "PAGO", "REEMBOLSADO" e "ENVIADO". Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.pedidos.loja_id    IS 'Essa coluna contém o id da loja, sendo FK da tabela "lojas" para a tabela "pedidos". Essa coluna não pode conter valor null.';

/* CRIAR TABELA  */
/* PEDIDOS_ITENS */

--Criar tabela pedidos_itens.

CREATE TABLE lojas.pedidos_itens (
                pedido_id       NUMERIC(38)   NOT NULL,
                produto_id      NUMERIC(38)   NOT NULL,
                numero_da_linha NUMERIC(38)   NOT NULL,
                preco_unitario  NUMERIC(10,2) NOT NULL,
                quantidade      NUMERIC(38)   NOT NULL,
                envio_id        NUMERIC(38)
);

--Criar PK da tabela pedidos_itens, para formar uma PFK.

ALTER TABLE    lojas.pedidos_itens
ADD CONSTRAINT pk_pedidos_itens
PRIMARY KEY   (pedido_id, produto_id);

--Criar restrição do preço unitário.

ALTER TABLE    lojas.pedidos_itens
ADD CONSTRAINT cc_pedidos_itens_preco_unitario
CHECK         (preco_unitario >= 0);

--Criar restrição do valor da quantidade.

ALTER TABLE    lojas.pedidos_itens
ADD CONSTRAINT cc_pedidos_itens_quantidade
CHECK         (quantidade >= 0);


--Criar comentários da tabela pedidos_itens.

COMMENT ON TABLE  lojas.pedidos_itens                 IS 'Essa tabela registra o itens em cada pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id       IS 'Essa coluna contém o id do pedido, sendo PFK da tabela "pedidos_itens" utilizando a tabela "pedidos". Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id      IS 'Essa coluna contém o id do produto, sendo PFK da tabela "pedidos_itens" utilizando a tabela "produtos". Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'Essa coluna contém o número da linha dos itens do pedido. Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario  IS 'Essa coluna contém o preço unitário de dos itens no pedido. Apenas valores maiores ou iguais a 0 podem ser inseridos. Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade      IS 'Essa coluna contém a quantidade de cada item no pedido. Apenas valores maiores ou iguais a 0 podem ser inseridos. Essa coluna não pode conter valor null.';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id        IS 'Essa coluna contém o id do envio, sendo FK da tabela "envios" para a tabela "pedidos_itens".';

/* CRIAÇÃO      */
/* DAS          */
/* CHAVES       */
/* ESTRANGEIRAS */
/* (FK)         */

--Criar FK da tabela produtos para a tabela estoques.

ALTER TABLE    lojas.estoques 
ADD CONSTRAINT fk_produtos_estoques
FOREIGN KEY   (produto_id)
REFERENCES     lojas.produtos (produto_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT            DEFERRABLE;

--Criar FK da tabela pedidos_itens para a tabela produtos, para formar uma PFK.

ALTER TABLE    lojas.pedidos_itens 
ADD CONSTRAINT fk_produtos_pedidos_itens
FOREIGN KEY   (produto_id)
REFERENCES     lojas.produtos (produto_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT            DEFERRABLE;

--Criar FK da tabela pedidos para a tabela lojas.

ALTER TABLE    lojas.pedidos 
ADD CONSTRAINT fk_lojas_pedidos
FOREIGN KEY   (loja_id)
REFERENCES     lojas.lojas (loja_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT            DEFERRABLE;

--Criar FK da tabela estoques para a tabela lojas.

ALTER TABLE    lojas.estoques 
ADD CONSTRAINT fk_lojas_estoques
FOREIGN KEY   (loja_id)
REFERENCES     lojas.lojas (loja_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT            DEFERRABLE;

--Criar FK da tabela envios para a tabela lojas.

ALTER TABLE    lojas.envios 
ADD CONSTRAINT fk_lojas_envios
FOREIGN KEY   (loja_id)
REFERENCES     lojas.lojas (loja_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT            DEFERRABLE;

--Criar FK da tabela pedidos para a tabela clientes.

ALTER TABLE    lojas.pedidos 
ADD CONSTRAINT fk_clientes_pedidos
FOREIGN KEY   (cliente_id)
REFERENCES     lojas.clientes (cliente_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT            DEFERRABLE;

--Criar FK da tabela envios para a tabela clientes.

ALTER TABLE    lojas.envios 
ADD CONSTRAINT fk_clientes_envios
FOREIGN KEY   (cliente_id)
REFERENCES     lojas.clientes (cliente_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT            DEFERRABLE;

--Criar FK da tabela pedidos_itens para a tabela envios.

ALTER TABLE    lojas.pedidos_itens 
ADD CONSTRAINT fk_envios_pedidos_itens
FOREIGN KEY   (envio_id)
REFERENCES     lojas.envios (envio_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT            DEFERRABLE;

--Criar FK da tabela pedidos_itens para a tabela pedidos, para formar uma PFK.

ALTER TABLE    lojas.pedidos_itens 
ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY   (pedido_id)
REFERENCES     lojas.pedidos (pedido_id)
ON DELETE      NO ACTION
ON UPDATE      NO ACTION
NOT            DEFERRABLE;
