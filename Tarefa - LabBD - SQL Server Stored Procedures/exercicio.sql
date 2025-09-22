CREATE DATABASE exercicio

USE exercicio

CREATE TABLE Pessoa (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tel_cel VARCHAR(15),
    tel_fixo VARCHAR(15),
    estado VARCHAR(2) NOT NULL
)
GO

CREATE PROCEDURE CadastrarPessoa(
     @p_nome VARCHAR(100),
     @p_tel_cel VARCHAR(15),
     @p_tel_fixo VARCHAR(15),
     @p_estado VARCHAR(2)
)
AS
BEGIN
    DECLARE @v_id INT;

    IF @p_estado <> 'SP'
    BEGIN
        RAISERROR('Cadastro permitido apenas para o estado de São Paulo', 16, 1);
        RETURN;
    END

    IF @p_tel_cel IS NULL AND @p_tel_fixo IS NULL
    BEGIN
        RAISERROR('É necessário cadastrar pelo menos um telefone (celular ou fixo)', 16, 1);
        RETURN;
    END

    IF @p_tel_cel IS NOT NULL AND LEN(@p_tel_cel) <> 9
    BEGIN
        RAISERROR('Telefone celular deve ter 9 dígitos', 16, 1);
        RETURN;
    END

    IF @p_tel_fixo IS NOT NULL AND LEN(@p_tel_fixo) <> 8
    BEGIN
        RAISERROR('Telefone fixo deve ter 8 dígitos', 16, 1);
        RETURN;
    END

    IF @p_tel_cel IS NOT NULL AND @p_tel_fixo IS NOT NULL
    BEGIN
        RAISERROR('Não é permitido cadastrar dois telefones do mesmo tipo (fixo ou celular)', 16, 1);
        RETURN;
    END

    SELECT @v_id = ISNULL(MAX(id), 0) + 1 FROM Pessoa;

    INSERT INTO Pessoa (id, nome, tel_cel, tel_fixo, estado)
    VALUES (@v_id, @p_nome, @p_tel_cel, @p_tel_fixo, @p_estado);

END

SELECT * FROM Pessoa

EXEC CadastrarPessoa 'João da Silva', '912345678', NULL, 'SP';

EXEC CadastrarPessoa 'Maria Oliveira', NULL, '32345678', 'SP';