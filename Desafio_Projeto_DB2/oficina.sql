-- Tabela Cliente
CREATE TABLE IF NOT EXISTS Cliente (
    IdCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Telefone VARCHAR(20) NOT NULL,
    Endereco VARCHAR(200) NOT NULL
);

-- Tabela Veículo
CREATE TABLE IF NOT EXISTS Veiculo (
    IdVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    IdCliente INT,
    Marca VARCHAR(50) NOT NULL,
    Modelo VARCHAR(50) NOT NULL,
    Ano INT NOT NULL,
    Cor VARCHAR(20),
    Placa VARCHAR(10) NOT NULL,
    CONSTRAINT fk_Veiculo_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)
);

-- Tabela Serviço
CREATE TABLE IF NOT EXISTS Servico (
    IdServico INT AUTO_INCREMENT PRIMARY KEY,
    IdCliente INT,
    Descricao VARCHAR(200) NOT NULL,
    DataServico DATE NOT NULL,
    Valor DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_Servico_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente (IdCliente)
);

-- Tabela Peça
CREATE TABLE IF NOT EXISTS Peca (
    IdPeca INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Marca VARCHAR(50) NOT NULL,
    Preco DECIMAL(10, 2) NOT NULL
);

-- Tabela Servico_Peca (Relacionamento N:M entre Servico e Peca)
CREATE TABLE IF NOT EXISTS Servico_Peca (
    IdServico INT,
    IdPeca INT,
    Quantidade INT NOT NULL,
    CONSTRAINT fk_Servico_Peca_Servico FOREIGN KEY (IdServico) REFERENCES Servico (IdServico),
    CONSTRAINT fk_Servico_Peca_Peca FOREIGN KEY (IdPeca) REFERENCES Peca (IdPeca),
    PRIMARY KEY (IdServico, IdPeca)
);

-- Recuperação simples de todos os clientes cadastrados:
SELECT * FROM Cliente;

-- Recuperação dos serviços realizados por um cliente específico:
SELECT * FROM Servico WHERE IdCliente = 1;

-- Criação de uma expressão para gerar um atributo derivado, calculando o valor total de um serviço (preço multiplicado pela quantidade de peças utilizadas):

SELECT s.IdServico, SUM(p.Preco * sp.Quantidade) AS ValorTotal
FROM Servico s
JOIN Servico_Peca sp ON s.IdServico = sp.IdServico
JOIN Peca p ON sp.IdPeca = p.IdPeca
GROUP BY s.IdServico;

-- Ordenação dos serviços por data de realização em ordem decrescente:
SELECT * FROM Servico ORDER BY DataServico DESC;

-- Condição de filtro para recuperar apenas os serviços com valor total acima de 500 reais:
SELECT s.IdServico, SUM(p.Preco * sp.Quantidade) AS ValorTotal
FROM Servico s
JOIN Servico_Peca sp ON s.IdServico = sp.IdServico
JOIN Peca p ON sp.IdPeca = p.IdPeca
GROUP BY s.IdServico
HAVING ValorTotal > 500;

-- Junção entre tabelas para recuperar informações completas sobre um serviço, incluindo o nome do cliente e as peças utilizadas:
SELECT s.IdServico, c.Nome AS NomeCliente, s.Descricao, p.Nome AS NomePeca, sp.Quantidade
FROM Servico s
JOIN Cliente c ON s.IdCliente = c.IdCliente
JOIN Servico_Peca sp ON s.IdServico = sp.IdServico
JOIN Peca p ON sp.IdPeca = p.IdPeca;

