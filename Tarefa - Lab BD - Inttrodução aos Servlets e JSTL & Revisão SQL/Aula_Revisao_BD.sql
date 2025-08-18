﻿CREATE DATABASE ESCOLA
GO
USE ESCOLA

CREATE TABLE Aluno(
RA INT NOT NULL,
Nome VARCHAR(100),
Idade INT NOT NULL CHECK (idade > 0),
PRIMARY KEY (RA)
)

CREATE TABLE Disciplina(
Codigo INT NOT NULL,
Nome VARCHAR(80),
Carga_Horaria INT NOT NULL CHECK (Carga_Horaria >= 32),
PRIMARY KEY (Codigo)
)

CREATE TABLE Curso(
Codigo INT NOT NULL,
Nome VARCHAR(50),
Area VARCHAR(80),
PRIMARY KEY (Codigo)
)

CREATE TABLE Titulacao(
Codigo INT NOT NULL,
Titulo VARCHAR(40),
PRIMARY KEY (Codigo)
)

CREATE TABLE Professor(
Registro INT NOT NULL,
Nome VARCHAR(100),
Titulacao INT NOT NULL,
PRIMARY KEY (Registro),
FOREIGN KEY (Titulacao) REFERENCES Titulacao(Codigo)
)

CREATE TABLE Aluno_Disciplina(
AlunoRA INT NOT NULL,
DisciplinaCodigo INT NOT NULL,
PRIMARY KEY (AlunoRA, DisciplinaCodigo),
FOREIGN KEY (AlunoRA) REFERENCES Aluno(RA),
FOREIGN KEY (DisciplinaCodigo) REFERENCES Disciplina(Codigo)
)

CREATE TABLE Curso_Disciplina(
CursoCodigo INT NOT NULL,
DisciplinaCodigo INT NOT NULL,
FOREIGN KEY (CursoCodigo) REFERENCES Curso(Codigo),
FOREIGN KEY (DisciplinaCodigo) REFERENCES Disciplina(Codigo)
)

CREATE TABLE Disciplina_Professor(
DisciplinaCodigo INT NOT NULL,
ProfessorRegistro INT NOT NULL,
FOREIGN KEY (DisciplinaCodigo) REFERENCES Disciplina(Codigo),
FOREIGN KEY (ProfessorRegistro) REFERENCES Professor(Registro)
)
GO
SELECT * FROM Aluno
SELECT * FROM Disciplina
SELECT * FROM Titulacao
SELECT * FROM Professor
SELECT * FROM Curso
SELECT * FROM Aluno_Disciplina
SELECT * FROM Curso_Disciplina
SELECT * FROM Disciplina_Professor

--Fazer uma pesquisa que permita gerar as listas de chamadas, com RA e nome por disciplina?
SELECT Aluno.RA,Aluno.Nome, Disciplina.Nome
FROM Aluno INNER JOIN Aluno_Disciplina ON RA = AlunoRA INNER JOIN Disciplina ON DisciplinaCodigo = Codigo
WHERE Codigo = 1 -- s� colocar o codigo da lista que deseja
ORDER BY Aluno.Nome ASC

--Fazer uma pesquisa que liste o nome das disciplinas e o nome dos professores que as ministram
SELECT Disciplina.Nome, Professor.Nome
FROM Disciplina INNER JOIN Disciplina_Professor ON Codigo = DisciplinaCodigo INNER JOIN Professor ON Registro = ProfessorRegistro 

--Fazer uma pesquisa que , dado o nome de uma disciplina, retorne o nome do curso
SELECT Curso.Nome
FROM Disciplina INNER JOIN Curso_Disciplina ON DisciplinaCodigo = Codigo INNER JOIN Curso ON CursoCodigo = Curso.Codigo
WHERE Disciplina.Nome LIKE 'Labo%'

--Fazer uma pesquisa que , dado o nome de uma disciplina, retorne sua Area
SELECT Curso.Area
FROM Disciplina INNER JOIN Curso_Disciplina ON DisciplinaCodigo = Codigo INNER JOIN Curso ON CursoCodigo = Curso.Codigo
WHERE Disciplina.Nome LIKE 'Labo%'

--Fazer uma pesquisa que , dado o nome de uma disciplina, retorne o titulo do professor que a ministra
SELECT Titulacao.Titulo
FROM Disciplina INNER JOIN Disciplina_Professor ON DisciplinaCodigo = Codigo INNER JOIN Professor ON Registro =	ProfessorRegistro INNER JOIN Titulacao 
ON Titulacao = Titulacao.Codigo
WHERE Disciplina.Nome LIKE 'Pro%'

--Fazer uma pesquisa que retorne o nome da disciplina e quantos alunos estao matriculados em cada uma delas
SELECT Disciplina.Nome, COUNT(RA) AS Matriculados
FROM Disciplina INNER JOIN Aluno_Disciplina ON Codigo = DisciplinaCodigo INNER JOIN Aluno ON RA = AlunoRA
WHERE Disciplina.Nome LIKE 'Rede%'
GROUP BY Disciplina.Nome

--Fazer uma pesquisa que, dado o nome de uma disciplina, retorne o nome do professor.  S� deve retornar de disciplinas que tenham, no minimo, 5 alunos matriculados
SELECT Professor.nome, COUNT(RA)  AS Matriculados 
FROM Disciplina INNER JOIN Disciplina_Professor ON Codigo = DisciplinaCodigo INNER JOIN  Professor ON Registro = ProfessorRegistro INNER JOIN Aluno_Disciplina
ON Codigo = Aluno_Disciplina.DisciplinaCodigo INNER JOIN Aluno ON RA = AlunoRA
WHERE Disciplina.Nome LIKE 'Gestao%'
GROUP BY Professor.Nome, Disciplina.Nome HAVING COUNT(RA) >= 5

--Fazer uma pesquisa que retorne o nome do curso e a quantidade de professores cadastrados que ministram aula nele. A coluna de ve se chamar quantidade
SELECT Curso.nome, COUNT(Registro)  AS Quantidade
FROM Curso INNER JOIN Curso_Disciplina ON Codigo = CursoCodigo INNER JOIN Disciplina ON Disciplina.Codigo = Curso_Disciplina.DisciplinaCodigo INNER JOIN Disciplina_Professor
ON Disciplina.Codigo  = Disciplina_Professor.DisciplinaCodigo INNER JOIN Professor ON Registro = ProfessorRegistro
WHERE Curso.Nome = 'ADS'
GROUP BY Curso.nome