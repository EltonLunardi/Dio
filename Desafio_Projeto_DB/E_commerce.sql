-- CRIAÇÃO DO DB PARA E-COMMERCE
CREATE DATABASE IF NOT EXISTS ECOMMERCE;
USE ECOMMERCE;

-- TABELA CLIENTE
CREATE TABLE IF NOT EXISTS Clients (
    IdClient INT AUTO_INCREMENT PRIMARY KEY,
    fname VARCHAR(10),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11),
    CNPJ CHAR(14),
    Address VARCHAR(45),
    CONSTRAINT unique_cpf_client UNIQUE (CPF),
    CONSTRAINT unique_cnpj_client UNIQUE (CNPJ),
    CONSTRAINT check_pf_pj_client CHECK (
        (CPF IS NOT NULL AND CNPJ IS NULL)
        OR (CPF IS NULL AND CNPJ IS NOT NULL)
    )
);

-- TABELA PRODUTO
CREATE TABLE IF NOT EXISTS Product (
    IdProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(10) NOT NULL,
    Classification_kids BOOL DEFAULT FALSE,
    Category ENUM('Eletronico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    Rate FLOAT DEFAULT 0,
    Size VARCHAR(10)
);

-- TABELA PAGAMENTO
CREATE TABLE IF NOT EXISTS Payments (
    IdPayment INT AUTO_INCREMENT PRIMARY KEY,
    IdClient INT,
    TypePayment ENUM('Boleto', 'Cartão', 'Dois cartões'),
    LimitAvaiable FLOAT,
    CONSTRAINT fk_Payments_Clients FOREIGN KEY (IdClient) REFERENCES Clients (IdClient)
);

-- TABELA PEDIDO
CREATE TABLE IF NOT EXISTS Orders (
    IdOrder INT AUTO_INCREMENT PRIMARY KEY,
    IdOrderClient INT,
    OrderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento') DEFAULT 'Em processamento',
    OrderDescription VARCHAR(255),
    SendValue FLOAT DEFAULT 10,
    PaymentCash BOOL DEFAULT FALSE,
    CONSTRAINT fk_Orders_Client FOREIGN KEY (IdOrderClient) REFERENCES Clients(IdClient)
);

-- TABELA ENTREGA
CREATE TABLE IF NOT EXISTS Entrega (
    IdEntrega INT AUTO_INCREMENT PRIMARY KEY,
    IdOrder INT,
    StatusEntrega ENUM('Saiu para entrega', 'Entregue', 'Pendente', 'Cancelado'),
    CodigoRastreio VARCHAR(20),
    CONSTRAINT fk_Entrega_Orders FOREIGN KEY (IdOrder) REFERENCES Orders (IdOrder)
);

-- TABELA TERCEIRO VENDEDOR
CREATE TABLE IF NOT EXISTS TerceiroVendedor (
    IdTerceiroVendedor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    BusinessName VARCHAR(45) NOT NULL,
    Location VARCHAR(45) NULL,
    FantasyName VARCHAR(45) NOT NULL,
    Address VARCHAR(45) NOT NULL COMMENT 'Constraint para restringir terceiros vendedores ao mesmo estado da empresa',
    UNIQUE INDEX BusinessName_UNIQUE (BusinessName ASC) VISIBLE,
    CONSTRAINT fk_TerceiroVendedor_Location_Client FOREIGN KEY (Location) REFERENCES Clients (Address)
);

-- TABELA FORNECEDOR
CREATE TABLE IF NOT EXISTS Supplier (
    IdSupplier INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    BusinessName VARCHAR(45) NOT NULL,
    CNPJ VARCHAR(45) NOT NULL
);

-- TABELA ESTOQUE
CREATE TABLE IF NOT EXISTS Stock (
    IdOrder INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Local VARCHAR(45) NULL
);

-- TABELA RELAÇÃO PRODUTO/PEDIDO
CREATE TABLE IF NOT EXISTS Relação_Product_Order (
    Product_IdProduct INT NOT NULL,
    Order_IdOrder INT NOT NULL,
    Amount VARCHAR(45) NOT NULL,
    Status ENUM("Disponivel", "Fora de Stock") NULL DEFAULT 'Disponivel',
    PRIMARY KEY (Product_IdProduct, Order_IdOrder),
    CONSTRAINT fk_DisponibilizandoProd FOREIGN KEY (Product_IdProduct) REFERENCES Product (IdProduct)
);

-- TABELA PRODUTOS POR VENDEDOR
CREATE TABLE IF NOT EXISTS Products_por_Vendedor (
    Product_IdProduct INT NOT NULL,
    TerceiroVendedor_IdTerceiroVendedor INT NOT NULL,
    Amount INT NULL,
    PRIMARY KEY (Product_IdProduct, TerceiroVendedor_IdTerceiroVendedor),
    CONSTRAINT fk_Product_por_Vendedor FOREIGN KEY (Product_IdProduct) REFERENCES Product (IdProduct),
    CONSTRAINT fk_Product_TerceiroVendedor FOREIGN KEY (TerceiroVendedor_IdTerceiroVendedor) REFERENCES TerceiroVendedor (IdTerceiroVendedor)
);

-- TABELA DISPONIBILIZANDO PRODUTO
CREATE TABLE IF NOT EXISTS Disponibilizando_Product (
    Supplier_IdSupplier INT NOT NULL,
    Product_IdProduct INT NOT NULL,
    PRIMARY KEY (Supplier_IdSupplier, Product_IdProduct),
    CONSTRAINT fk_Supplier_Fornece_Product FOREIGN KEY (Supplier_IdSupplier) REFERENCES Supplier (IdSupplier),
    CONSTRAINT fk_ProductDisponivel_Supplier FOREIGN KEY (Product_IdProduct) REFERENCES Product (IdProduct)
);

-- TABELA ESTOQUE
CREATE TABLE IF NOT EXISTS Stock (
    Product_IdProduct INT NOT NULL,
    Stock_IdOrder INT NOT NULL,
    PRIMARY KEY (Product_IdProduct, Stock_IdOrder),
    CONSTRAINT fk_Product_em_Stock FOREIGN KEY (Product_IdProduct) REFERENCES Product (IdProduct),
    CONSTRAINT fk_Stock_com_Product FOREIGN KEY (Stock_IdOrder) REFERENCES Stock (IdOrder)
);