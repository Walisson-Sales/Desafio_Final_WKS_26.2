-- PARTE 1: DDL (DATA DEFINITION LANGUAGE) - CRIAÇÃO DO BANCO E TABELAS

-- Criação do Banco de Dados
DROP SCHEMA IF EXISTS clinica_care;
CREATE SCHEMA clinica_care;
USE clinica_care;

-- Criação da tabela Plano
CREATE TABLE Plano (
    id_plano INT AUTO_INCREMENT PRIMARY KEY,
    nome_plano VARCHAR(50) NOT NULL,
    tipo_plano VARCHAR(30) NOT NULL,
    descricao VARCHAR(150),
    percentual_cobertura DECIMAL(5,2) NOT NULL,
    valor_consulta_padrao DECIMAL(10,2) NOT NULL,
    telefone_contato VARCHAR(20),
    email_contato VARCHAR(100) UNIQUE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    data_cadastro DATE NOT NULL
);

-- Criação da tabela Paciente
CREATE TABLE Paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    id_plano INT NOT NULL,
    nome_completo VARCHAR(150) NOT NULL,
    cpf CHAR(14) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    genero VARCHAR(20),
    endereco VARCHAR(150),
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE,
    data_cadastro DATE NOT NULL,
    FOREIGN KEY (id_plano) REFERENCES Plano(id_plano)
);

-- Criação da tabela Medico
CREATE TABLE Medico (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(150) NOT NULL,
    crm VARCHAR(20) UNIQUE NOT NULL,
    data_nascimento DATE,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE,
    endereco VARCHAR(150),
    data_contratacao DATE,
    tipo_vinculo VARCHAR(30),
    status VARCHAR(20) NOT NULL DEFAULT 'Ativo'
);

-- Criação da tabela Especialidade
CREATE TABLE Especialidade (
    id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    descricao VARCHAR(200),
    codigo VARCHAR(20) UNIQUE,
    valor_base_consulta DECIMAL(10,2) NOT NULL,
    duracao_padrao_minutos INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Ativa',
    data_cadastro DATE NOT NULL
);

-- Criação da tabela Medico_especialidade (Resolução do relacionamento N:N)
CREATE TABLE Medico_especialidade (
    id_medico_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    id_medico INT NOT NULL,
    id_especialidade INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE,
    registro_principal BOOLEAN DEFAULT FALSE,
    valor_consulta DECIMAL(10,2) NOT NULL,
    observacao VARCHAR(200),
    status VARCHAR(20) NOT NULL DEFAULT 'Ativo',
    FOREIGN KEY (id_medico) REFERENCES Medico(id_medico),
    FOREIGN KEY (id_especialidade) REFERENCES Especialidade(id_especialidade),
    UNIQUE (id_medico, id_especialidade)
);

-- Criação da tabela Horario
CREATE TABLE Horario (
    id_horario INT AUTO_INCREMENT PRIMARY KEY,
    id_medico INT NOT NULL,
    dia_semana VARCHAR(15) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    tipo_atendimento VARCHAR(20),
    sala VARCHAR(20),
    status VARCHAR(20) NOT NULL DEFAULT 'Disponível',
    data_inicio_vigencia DATE,
    data_fim_vigencia DATE,
    FOREIGN KEY (id_medico) REFERENCES Medico(id_medico)
);

-- Criação da tabela Consulta
CREATE TABLE Consulta (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico_especialidade INT NOT NULL,
    data_consulta DATE NOT NULL,
    hora_consulta TIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Agendada',
    valor_consulta DECIMAL(10,2) NOT NULL,
    tipo_atendimento VARCHAR(30),
    observacao VARCHAR(200),
    data_agendamento DATE NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_medico_especialidade) REFERENCES Medico_especialidade(id_medico_especialidade)
);

-- Criação da tabela Prontuario
CREATE TABLE Prontuario (
    id_prontuario INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT UNIQUE NOT NULL,
    data_registro DATE NOT NULL,
    anotacoes TEXT NOT NULL,
    diagnostico VARCHAR(300),
    observacoes TEXT,
    retorno_recomendado DATE,
    pressao_arterial VARCHAR(15),
    temperatura DECIMAL(4,1),
    status VARCHAR(20) DEFAULT 'Aberto',
    FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta)
);

-- Criação da tabela Prescricao
CREATE TABLE Prescricao (
    id_prescricao INT AUTO_INCREMENT PRIMARY KEY,
    id_prontuario INT NOT NULL,
    nome_medicamento VARCHAR(150) NOT NULL,
    dosagem VARCHAR(50) NOT NULL,
    frequencia VARCHAR(50),
    duracao_tratamento VARCHAR(50),
    via_administracao VARCHAR(50),
    quantidade INT,
    orientacoes TEXT,
    data_prescricao DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Emitida',
    FOREIGN KEY (id_prontuario) REFERENCES Prontuario(id_prontuario)
);

-- Criação da tabela Pagamento
CREATE TABLE Pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT UNIQUE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_pagamento DATE,
    metodo_pagamento VARCHAR(30),
    status_pagamento VARCHAR(20) NOT NULL DEFAULT 'Pendente',
    data_vencimento DATE NOT NULL,
    data_cancelamento DATE,
    numero_recibo VARCHAR(50) UNIQUE,
    observacao VARCHAR(200),
    FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta)
);

-- PARTE 2: DML (DATA MANIPULATION LANGUAGE) - INSERÇÃO E ATUALIZAÇÃO

-- Inserção: Planos
INSERT INTO Plano (nome_plano, tipo_plano, descricao, percentual_cobertura, valor_consulta_padrao, telefone_contato, email_contato, ativo, data_cadastro) VALUES
('Particular', 'Sem Plano', 'Atendimento particular sem cobertura de convenio', 0.00, 200.00, NULL, NULL, TRUE, '2025-01-01'),
('Convenio X', 'Convenio', 'Plano com cobertura de 80 por cento', 80.00, 200.00, '8330001001', 'contato@conveniox.com.br', TRUE, '2025-01-05'),
('Convenio Y', 'Convenio', 'Plano com cobertura de 90 por cento', 90.00, 200.00, '8330001002', 'contato@convenioy.com.br', TRUE, '2025-01-10'),
('Particular Premium', 'Sem Plano', 'Atendimento particular diferenciado', 0.00, 300.00, NULL, NULL, TRUE, '2025-01-15'),
('Convenio X Empresarial', 'Convenio', 'Plano empresarial do Convenio X', 85.00, 220.00, '8330001003', 'empresarial@conveniox.com.br', TRUE, '2025-02-01'),
('Convenio Y Empresarial', 'Convenio', 'Plano empresarial do Convenio Y', 90.00, 220.00, '8330001004', 'empresarial@convenioy.com.br', TRUE, '2025-02-05'),
('Particular Executivo', 'Sem Plano', 'Atendimento particular executivo', 0.00, 350.00, NULL, NULL, TRUE, '2025-02-10'),
('Convenio X Plus', 'Convenio', 'Plano ampliado do Convenio X', 90.00, 250.00, '8330001005', 'plus@conveniox.com.br', TRUE, '2025-02-15'),
('Convenio Y Plus', 'Convenio', 'Plano ampliado do Convenio Y', 95.00, 250.00, '8330001006', 'plus@convenioy.com.br', TRUE, '2025-03-01'),
('Particular Basico', 'Sem Plano', 'Plano particular de entrada', 0.00, 150.00, NULL, NULL, TRUE, '2025-03-05'),
('Convenio X Senior', 'Convenio', 'Plano destinado ao publico senior', 90.00, 180.00, '8330001007', 'senior@conveniox.com.br', TRUE, '2025-03-10'),
('Convenio Y Senior', 'Convenio', 'Plano destinado ao publico senior', 95.00, 180.00, '8330001008', 'senior@convenioy.com.br', TRUE, '2025-03-15');

-- Inserção: Pacientes
INSERT INTO Paciente (id_plano, nome_completo, cpf, data_nascimento, genero, endereco, telefone, email, data_cadastro) VALUES
(1, 'Ana Clara Silva', '111.111.111-11', '1985-04-12', 'Feminino', 'Rua das Flores, 100', '83999990001', 'ana@email.com', '2025-01-10'),
(2, 'Joao Pedro Santos', '222.222.222-22', '1990-08-25', 'Masculino', 'Av. Central, 250', '83999990002', 'joao@email.com', '2025-01-15'),
(3, 'Maria Fernanda Costa', '333.333.333-33', '1978-11-05', 'Feminino', 'Rua do Sol, 80', '83999990003', 'maria@email.com', '2025-01-20'),
(4, 'Carlos Eduardo Souza', '444.444.444-44', '2005-02-14', 'Masculino', 'Rua das Palmeiras, 120', '83999990004', 'carlos@email.com', '2025-01-25'),
(5, 'Beatriz Lima', '555.555.555-55', '1995-07-30', 'Feminino', 'Av. Beira Mar, 400', '83999990005', 'beatriz@email.com', '2025-02-01'),
(6, 'Ricardo Alves', '666.666.666-66', '1982-12-01', 'Masculino', 'Rua Joao Pessoa, 150', '83999990006', 'ricardo@email.com', '2025-02-05'),
(7, 'Camila Ribeiro', '777.777.777-77', '1998-09-18', 'Feminino', 'Rua dos Ipes, 55', '83999990007', 'camila@email.com', '2025-02-10'),
(8, 'Felipe Monteiro', '888.888.888-88', '1970-03-15', 'Masculino', 'Av. Ruy Carneiro, 310', '83999990008', 'felipe@email.com', '2025-02-15'),
(9, 'Juliana Castro', '999.999.999-99', '1989-05-20', 'Feminino', 'Rua das Acacias, 90', '83999990009', 'juliana@email.com', '2025-02-20'),
(10, 'Lucas Martins', '101.101.101-10', '2000-10-10', 'Masculino', 'Rua do Comercio, 200', '83999990010', 'lucas@email.com', '2025-02-25'),
(11, 'Fernanda Gomes', '202.202.202-20', '1992-01-25', 'Feminino', 'Rua dos Girassois, 180', '83999990011', 'fernanda.g@email.com', '2025-03-01'),
(12, 'Thiago Rocha', '303.303.303-30', '1986-06-08', 'Masculino', 'Av. Epitacio Pessoa, 600', '83999990012', 'thiago@email.com', '2025-03-05'),
(1, 'Mariana Lopes', '404.404.404-40', '1993-03-17', 'Feminino', 'Rua das Acacias, 210', '83999990013', 'mariana@email.com', '2025-03-10'),
(2, 'Gustavo Ferreira', '505.505.505-50', '1981-09-23', 'Masculino', 'Rua do Sol, 310', '83999990014', 'gustavo@email.com', '2025-03-15'),
(3, 'Larissa Mendes', '606.606.606-60', '1997-12-11', 'Feminino', 'Av. Central, 500', '83999990015', 'larissa@email.com', '2025-03-20');

-- Inserção: Médicos
INSERT INTO Medico (nome_completo, crm, data_nascimento, telefone, email, endereco, data_contratacao, tipo_vinculo, status) VALUES
('Roberto Almeida', 'CRM-PB-1234', '1978-03-15', '83988880001', 'roberto@clinicacare.com', 'Rua das Acacias, 100', '2020-01-10', 'CLT', 'Ativo'),
('Silvia Moraes', 'CRM-PB-2345', '1982-07-22', '83988880002', 'silvia@clinicacare.com', 'Av. Central, 200', '2020-02-15', 'CLT', 'Ativo'),
('Paulo Mendes', 'CRM-PB-3456', '1975-11-09', '83988880003', 'paulo@clinicacare.com', 'Rua do Sol, 300', '2020-03-20', 'PJ', 'Ativo'),
('Fernanda Santos', 'CRM-PB-4567', '1985-01-30', '83988880004', 'fernanda@clinicacare.com', 'Rua das Flores, 150', '2021-01-10', 'CLT', 'Ativo'),
('Lucas Ferreira', 'CRM-PB-5678', '1980-05-18', '83988880005', 'lucas@clinicacare.com', 'Av. Beira Mar, 250', '2021-04-12', 'PJ', 'Ativo'),
('Juliana Rocha', 'CRM-PB-6789', '1990-09-12', '83988880006', 'juliana@clinicacare.com', 'Rua Joao Pessoa, 180', '2021-08-01', 'CLT', 'Ativo'),
('Pedro Souza', 'CRM-PB-7890', '1972-12-03', '83988880007', 'pedro@clinicacare.com', 'Rua dos Ipes, 90', '2022-01-15', 'PJ', 'Ativo'),
('Camila Melo', 'CRM-PB-8901', '1988-04-27', '83988880008', 'camila@clinicacare.com', 'Av. Ruy Carneiro, 350', '2022-03-10', 'CLT', 'Ativo'),
('Andre Barbosa', 'CRM-PB-9012', '1983-08-14', '83988880009', 'andre@clinicacare.com', 'Rua das Palmeiras, 400', '2022-07-01', 'PJ', 'Ativo'),
('Patricia Silva', 'CRM-PB-1123', '1991-02-25', '83988880010', 'patricia@clinicacare.com', 'Rua dos Girassois, 220', '2023-01-10', 'CLT', 'Ativo'),
('Gustavo Alves', 'CRM-PB-2234', '1979-06-19', '83988880011', 'gustavo@clinicacare.com', 'Av. Epitacio Pessoa, 500', '2023-04-01', 'PJ', 'Ativo'),
('Beatriz Mendes', 'CRM-PB-3345', '1986-10-31', '83988880012', 'beatriz@clinicacare.com', 'Rua do Comercio, 120', '2023-06-15', 'CLT', 'Ativo'),
('Marcelo Costa', 'CRM-PB-4456', '1981-01-08', '83988880013', 'marcelo@clinicacare.com', 'Rua das Flores, 500', '2024-01-10', 'PJ', 'Ativo'),
('Renata Oliveira', 'CRM-PB-5567', '1989-05-14', '83988880014', 'renata@clinicacare.com', 'Av. Central, 700', '2024-03-15', 'CLT', 'Ativo'),
('Daniel Martins', 'CRM-PB-6678', '1977-08-26', '83988880015', 'daniel@clinicacare.com', 'Rua do Sol, 700', '2024-06-01', 'PJ', 'Ativo');

-- Inserção: Especialidades
INSERT INTO Especialidade (nome, descricao, codigo, valor_base_consulta, duracao_padrao_minutos, status, data_cadastro) VALUES
('Cardiologia', 'Diagnostico e tratamento de doencas cardiovasculares', 'CARD', 250.00, 40, 'Ativa', '2025-01-01'),
('Pediatria', 'Atendimento medico para criancas e adolescentes', 'PED', 180.00, 30, 'Ativa', '2025-01-01'),
('Clinica Geral', 'Atendimento medico geral e preventivo', 'CLIN', 150.00, 30, 'Ativa', '2025-01-02'),
('Dermatologia', 'Diagnostico e tratamento de doencas da pele', 'DERM', 220.00, 40, 'Ativa', '2025-01-03'),
('Ortopedia', 'Tratamento de doencas musculoesqueleticas', 'ORT', 240.00, 40, 'Ativa', '2025-01-04'),
('Neurologia', 'Diagnostico e tratamento neurologico', 'NEUR', 280.00, 50, 'Ativa', '2025-01-05'),
('Ginecologia', 'Atendimento especializado em saude feminina', 'GINE', 230.00, 40, 'Ativa', '2025-01-06'),
('Endocrinologia', 'Tratamento de alteracoes hormonais e metabolicas', 'ENDO', 260.00, 40, 'Ativa', '2025-01-07'),
('Oftalmologia', 'Diagnostico e tratamento ocular', 'OFT', 210.00, 30, 'Ativa', '2025-01-08'),
('Psiquiatria', 'Acompanhamento em saude mental', 'PSIQ', 300.00, 50, 'Ativa', '2025-01-09'),
('Urologia', 'Tratamento de doencas do sistema urinario', 'URO', 240.00, 40, 'Ativa', '2025-01-10'),
('Otorrinolaringologia', 'Tratamento de ouvido, nariz e garganta', 'OTOR', 220.00, 40, 'Ativa', '2025-01-11'),
('Gastroenterologia', 'Diagnostico e tratamento do sistema digestivo', 'GASTRO', 250.00, 40, 'Ativa', '2025-01-12'),
('Pneumologia', 'Diagnostico e tratamento respiratorio', 'PNEU', 260.00, 40, 'Ativa', '2025-01-13'),
('Nefrologia', 'Diagnostico e tratamento das doencas renais', 'NEFRO', 270.00, 45, 'Ativa', '2025-01-14');

-- Inserção: Medico_especialidade
INSERT INTO Medico_especialidade (id_medico, id_especialidade, data_inicio, data_fim, registro_principal, valor_consulta, observacao, status) VALUES
(1, 1, '2020-01-10', NULL, TRUE, 250.00, 'Especialista principal em cardiologia', 'Ativo'),
(2, 2, '2020-02-15', NULL, TRUE, 180.00, 'Especialista em pediatria', 'Ativo'),
(3, 3, '2020-03-20', NULL, TRUE, 150.00, 'Clinica geral', 'Ativo'),
(4, 4, '2021-01-10', NULL, TRUE, 220.00, 'Especialista em dermatologia', 'Ativo'),
(5, 5, '2021-04-12', NULL, TRUE, 240.00, 'Especialista em ortopedia', 'Ativo'),
(6, 6, '2021-08-01', NULL, TRUE, 280.00, 'Especialista em neurologia', 'Ativo'),
(7, 7, '2022-01-15', NULL, TRUE, 230.00, 'Especialista em ginecologia', 'Ativo'),
(8, 8, '2022-03-10', NULL, TRUE, 260.00, 'Especialista em endocrinologia', 'Ativo'),
(9, 9, '2022-07-01', NULL, TRUE, 210.00, 'Especialista em oftalmologia', 'Ativo'),
(10, 10, '2023-01-10', NULL, TRUE, 300.00, 'Especialista em psiquiatria', 'Ativo'),
(11, 11, '2023-04-01', NULL, TRUE, 240.00, 'Especialista em urologia', 'Ativo'),
(12, 12, '2023-06-15', NULL, TRUE, 220.00, 'Especialista em otorrinolaringologia', 'Ativo'),
(13, 13, '2024-01-10', NULL, TRUE, 250.00, 'Especialista em gastroenterologia', 'Ativo'),
(14, 14, '2024-03-15', NULL, TRUE, 260.00, 'Especialista em pneumologia', 'Ativo'),
(15, 15, '2024-06-01', NULL, TRUE, 270.00, 'Especialista em nefrologia', 'Ativo');

-- Inserção: Horario
INSERT INTO Horario (id_medico, dia_semana, hora_inicio, hora_fim, tipo_atendimento, sala, status, data_inicio_vigencia, data_fim_vigencia) VALUES
(1, 'Segunda', '08:00:00', '12:00:00', 'Presencial', '101', 'Disponível', '2025-01-01', NULL),
(2, 'Segunda', '13:00:00', '17:00:00', 'Presencial', '102', 'Disponível', '2025-01-01', NULL),
(3, 'Terca', '08:00:00', '12:00:00', 'Presencial', '103', 'Disponível', '2025-01-01', NULL),
(4, 'Terca', '13:00:00', '17:00:00', 'Presencial', '104', 'Disponível', '2025-01-01', NULL),
(5, 'Quarta', '08:00:00', '12:00:00', 'Presencial', '105', 'Disponível', '2025-01-01', NULL),
(6, 'Quarta', '13:00:00', '18:00:00', 'Presencial', '106', 'Disponível', '2025-01-01', NULL),
(7, 'Quinta', '08:00:00', '12:00:00', 'Presencial', '107', 'Disponível', '2025-01-01', NULL),
(8, 'Quinta', '13:00:00', '17:00:00', 'Presencial', '108', 'Disponível', '2025-01-01', NULL),
(9, 'Sexta', '08:00:00', '12:00:00', 'Presencial', '109', 'Disponível', '2025-01-01', NULL),
(10, 'Sexta', '13:00:00', '18:00:00', 'Presencial', '110', 'Disponível', '2025-01-01', NULL),
(11, 'Sabado', '08:00:00', '12:00:00', 'Presencial', '111', 'Disponível', '2025-01-01', NULL),
(12, 'Sabado', '13:00:00', '17:00:00', 'Presencial', '112', 'Disponível', '2025-01-01', NULL),
(13, 'Segunda', '08:00:00', '12:00:00', 'Presencial', '113', 'Disponível', '2025-01-01', NULL),
(14, 'Quarta', '08:00:00', '12:00:00', 'Presencial', '114', 'Disponível', '2025-01-01', NULL),
(15, 'Sexta', '08:00:00', '12:00:00', 'Presencial', '115', 'Disponível', '2025-01-01', NULL);

-- Inserção: Consulta
INSERT INTO Consulta (id_paciente, id_medico_especialidade, data_consulta, hora_consulta, status, valor_consulta, tipo_atendimento, observacao, data_agendamento) VALUES
(1, 1, '2026-06-01', '09:00:00', 'Realizada', 250.00, 'Presencial', 'Consulta de rotina', '2026-05-20'),
(2, 2, '2026-06-02', '10:00:00', 'Realizada', 180.00, 'Presencial', 'Acompanhamento pediatrico', '2026-05-21'),
(3, 3, '2026-06-03', '14:00:00', 'Faltou', 150.00, 'Presencial', 'Paciente nao compareceu', '2026-05-22'),
(4, 4, '2026-06-04', '15:30:00', 'Realizada', 220.00, 'Presencial', 'Avaliacao dermatologica', '2026-05-23'),
(5, 5, '2026-06-05', '09:30:00', 'Realizada', 240.00, 'Presencial', 'Avaliacao ortopedica', '2026-05-24'),
(6, 6, '2026-06-06', '14:00:00', 'Cancelada', 280.00, 'Presencial', 'Cancelamento solicitado pelo paciente', '2026-05-25'),
(7, 7, '2026-06-08', '09:00:00', 'Realizada', 230.00, 'Presencial', 'Consulta ginecologica', '2026-05-26'),
(8, 8, '2026-06-09', '14:30:00', 'Faltou', 260.00, 'Presencial', 'Paciente nao compareceu', '2026-05-27'),
(9, 9, '2026-06-10', '10:00:00', 'Realizada', 210.00, 'Presencial', 'Avaliacao oftalmologica', '2026-05-28'),
(10, 10, '2026-06-11', '15:00:00', 'Realizada', 300.00, 'Presencial', 'Consulta psiquiatrica', '2026-05-29'),
(11, 11, '2026-06-12', '09:00:00', 'Realizada', 240.00, 'Presencial', 'Consulta urologica', '2026-05-30'),
(12, 12, '2026-06-13', '10:30:00', 'Faltou', 220.00, 'Presencial', 'Paciente nao compareceu', '2026-05-31'),
(13, 13, '2026-06-15', '08:30:00', 'Realizada', 250.00, 'Presencial', 'Consulta gastroenterologica', '2026-06-01'),
(14, 14, '2026-06-16', '09:30:00', 'Realizada', 260.00, 'Presencial', 'Avaliacao respiratoria', '2026-06-02'),
(15, 15, '2026-06-17', '10:00:00', 'Realizada', 270.00, 'Presencial', 'Avaliacao nefrologica', '2026-06-03');

-- Inserção: Prontuario (Apenas consultas realizadas)
INSERT INTO Prontuario (id_consulta, data_registro, anotacoes, diagnostico, observacoes, retorno_recomendado, pressao_arterial, temperatura, status) VALUES
(1, '2026-06-01', 'Paciente apresentou bom estado geral.', 'Avaliacao cardiologica sem alteracoes relevantes.', 'Manter acompanhamento preventivo.', '2026-12-01', '120/80', 36.5, 'Aberto'),
(2, '2026-06-02', 'Paciente acompanhado pelo responsavel.', 'Desenvolvimento dentro da normalidade.', 'Retorno conforme necessidade.', '2026-12-02', '110/70', 36.6, 'Aberto'),
(4, '2026-06-04', 'Lesoes cutaneas avaliadas.', 'Dermatite leve.', 'Orientado tratamento topico.', '2026-09-04', '118/76', 36.4, 'Aberto'),
(5, '2026-06-05', 'Paciente relatou dor no joelho.', 'Tendinite leve.', 'Recomendado repouso e fisioterapia.', '2026-08-05', '122/80', 36.7, 'Aberto'),
(7, '2026-06-08', 'Consulta ginecologica de rotina.', 'Sem alteracoes relevantes.', 'Acompanhamento preventivo.', '2026-12-08', '115/75', 36.5, 'Aberto'),
(9, '2026-06-10', 'Paciente apresentou dificuldade visual.', 'Miopia.', 'Encaminhamento para avaliacao complementar.', '2026-09-10', '118/78', 36.5, 'Aberto'),
(10, '2026-06-11', 'Paciente relatou ansiedade recorrente.', 'Transtorno de ansiedade.', 'Recomendado acompanhamento periodico.', '2026-07-11', '120/80', 36.3, 'Aberto'),
(11, '2026-06-12', 'Consulta urologica de rotina.', 'Sem alteracoes relevantes.', 'Manter acompanhamento anual.', '2027-06-12', '121/79', 36.5, 'Aberto'),
(13, '2026-06-15', 'Paciente relatou desconforto abdominal.', 'Gastrite leve.', 'Orientada adequacao alimentar.', '2026-08-15', '119/77', 36.6, 'Aberto'),
(14, '2026-06-16', 'Paciente apresentou tosse recorrente.', 'Bronquite leve.', 'Recomendado acompanhamento.', '2026-08-16', '118/76', 36.7, 'Aberto'),
(15, '2026-06-17', 'Avaliacao da funcao renal.', 'Sem alteracoes significativas.', 'Manter acompanhamento preventivo.', '2027-06-17', '120/80', 36.5, 'Aberto');

-- Inserção: Prescricao
INSERT INTO Prescricao (id_prontuario, nome_medicamento, dosagem, frequencia, duracao_tratamento, via_administracao, quantidade, orientacoes, data_prescricao, status) VALUES
(1, 'Losartana', '50 mg', '1 vez ao dia', '30 dias', 'Oral', 30, 'Tomar pela manha.', '2026-06-01', 'Emitida'),
(2, 'Paracetamol', '500 mg', 'A cada 8 horas', '5 dias', 'Oral', 15, 'Utilizar em caso de dor ou febre.', '2026-06-02', 'Emitida'),
(3, 'Hidratante dermatologico', 'Uso topico', '2 vezes ao dia', '30 dias', 'Topica', 1, 'Aplicar nas areas afetadas.', '2026-06-04', 'Emitida'),
(4, 'Ibuprofeno', '400 mg', 'A cada 8 horas', '5 dias', 'Oral', 15, 'Tomar apos alimentacao.', '2026-06-05', 'Emitida'),
(5, 'Acido folico', '5 mg', '1 vez ao dia', '30 dias', 'Oral', 30, 'Tomar conforme orientacao medica.', '2026-06-08', 'Emitida'),
(6, 'Lagrima artificial', '1 gota', '3 vezes ao dia', '30 dias', 'Oftalmica', 1, 'Aplicar conforme orientacao.', '2026-06-10', 'Emitida'),
(7, 'Sertralina', '50 mg', '1 vez ao dia', '30 dias', 'Oral', 30, 'Tomar pela manha.', '2026-06-11', 'Emitida'),
(8, 'Tansulosina', '0.4 mg', '1 vez ao dia', '30 dias', 'Oral', 30, 'Tomar apos o jantar.', '2026-06-12', 'Emitida'),
(9, 'Omeprazol', '20 mg', '1 vez ao dia', '30 dias', 'Oral', 30, 'Tomar antes do cafe da manha.', '2026-06-15', 'Emitida'),
(10, 'Salbutamol', '100 mcg', 'Conforme necessidade', '15 dias', 'Inalatoria', 1, 'Utilizar conforme orientacao medica.', '2026-06-16', 'Emitida'),
(11, 'Vitamina D', '1000 UI', '1 vez ao dia', '60 dias', 'Oral', 60, 'Tomar apos refeicao.', '2026-06-17', 'Emitida');

-- Inserção: Pagamento
INSERT INTO Pagamento (id_consulta, valor, data_pagamento, metodo_pagamento, status_pagamento, data_vencimento, data_cancelamento, numero_recibo, observacao) VALUES
(1, 50.00, '2026-06-01', 'PIX', 'Pago', '2026-06-01', NULL, 'REC-2026001', 'Valor correspondente a coparticipacao'),
(2, 36.00, '2026-06-02', 'Cartao', 'Pago', '2026-06-02', NULL, 'REC-2026002', 'Cobertura de 80 por cento do Convenio X'),
(3, 150.00, NULL, NULL, 'Pendente', '2026-06-03', NULL, NULL, 'Paciente faltou e gerou cobranca'),
(4, 44.00, '2026-06-04', 'PIX', 'Pago', '2026-06-04', NULL, 'REC-2026004', 'Coparticipacao do plano'),
(5, 48.00, '2026-06-05', 'Cartao', 'Pago', '2026-06-05', NULL, 'REC-2026005', 'Coparticipacao do plano'),
(6, 0.00, NULL, NULL, 'Cancelado', '2026-06-06', '2026-06-05', NULL, 'Consulta cancelada'),
(7, 23.00, '2026-06-08', 'PIX', 'Pago', '2026-06-08', NULL, 'REC-2026007', 'Coparticipacao do plano'),
(8, 260.00, NULL, NULL, 'Pendente', '2026-06-09', NULL, NULL, 'Paciente faltou e gerou cobranca'),
(9, 21.00, '2026-06-10', 'PIX', 'Pago', '2026-06-10', NULL, 'REC-2026009', 'Coparticipacao do plano'),
(10, 30.00, '2026-06-11', 'Cartao', 'Pago', '2026-06-11', NULL, 'REC-2026010', 'Coparticipacao do plano'),
(11, 24.00, '2026-06-12', 'Dinheiro', 'Pago', '2026-06-12', NULL, 'REC-2026011', 'Coparticipacao do plano'),
(12, 220.00, NULL, NULL, 'Pendente', '2026-06-13', NULL, NULL, 'Paciente faltou e gerou cobranca'),
(13, 25.00, '2026-06-15', 'PIX', 'Pago', '2026-06-15', NULL, 'REC-2026013', 'Coparticipacao do plano'),
(14, 26.00, '2026-06-16', 'Cartao', 'Pago', '2026-06-16', NULL, 'REC-2026014', 'Coparticipacao do plano'),
(15, 27.00, '2026-06-17', 'PIX', 'Pago', '2026-06-17', NULL, 'REC-2026015', 'Coparticipacao do plano');

-- Operações de UPDATE
-- Update 1: Atualização do status de uma consulta
UPDATE Consulta
SET status = 'Realizada', observacao = 'Consulta realizada apos confirmacao do paciente'
WHERE id_consulta = 1;

-- Update 2: Atualização de pagamento após confirmação
UPDATE Pagamento
SET status_pagamento = 'Pago', data_pagamento = '2026-06-03', metodo_pagamento = 'PIX', numero_recibo = 'REC-2026003', observacao = 'Pagamento realizado posteriormente'
WHERE id_consulta = 3;

-- Update 3: Correção dos dados de contato de um paciente
UPDATE Paciente
SET telefone = '83900001111', email = 'ana.clara.novo@email.com'
WHERE id_paciente = 1;

-- PARTE 3: DQL (DATA QUERY LANGUAGE) - CONSULTAS E ANÁLISES

-- 4 CONSULTAS DE AGREGAÇÃO / AGRUPAMENTO

-- 1. Quantidade de pacientes por plano (COUNT + GROUP BY)
SELECT p.nome_plano, COUNT(pac.id_paciente) AS total_pacientes
FROM Plano p
LEFT JOIN Paciente pac ON p.id_plano = pac.id_plano
GROUP BY p.id_plano, p.nome_plano
ORDER BY total_pacientes DESC;

-- 2. Total de valores por status de pagamento (SUM + GROUP BY)
SELECT status_pagamento, COUNT(id_pagamento) AS quantidade_pagamentos, SUM(valor) AS valor_total
FROM Pagamento
GROUP BY status_pagamento
ORDER BY valor_total DESC;

-- 3. Média do valor das consultas por especialidade (AVG + GROUP BY)
SELECT e.nome AS especialidade, COUNT(c.id_consulta) AS total_consultas, ROUND(AVG(c.valor_consulta), 2) AS media_valor_consulta
FROM Especialidade e
LEFT JOIN Medico_especialidade me ON e.id_especialidade = me.id_especialidade
LEFT JOIN Consulta c ON me.id_medico_especialidade = c.id_medico_especialidade
GROUP BY e.id_especialidade, e.nome
ORDER BY media_valor_consulta DESC;

-- 4. Maior e menor valor de consulta (MAX + MIN)
SELECT MAX(valor_consulta) AS consulta_mais_cara, MIN(valor_consulta) AS consulta_mais_barata
FROM Consulta;

-- 4 CONSULTAS COM JOIN

-- 1. Consultas com paciente, medico e especialidade (INNER JOIN)
SELECT c.id_consulta, c.data_consulta, c.hora_consulta, p.nome_completo AS paciente, m.nome_completo AS medico, e.nome AS especialidade, c.status, c.valor_consulta
FROM Consulta c
INNER JOIN Paciente p ON c.id_paciente = p.id_paciente
INNER JOIN Medico_especialidade me ON c.id_medico_especialidade = me.id_medico_especialidade
INNER JOIN Medico m ON me.id_medico = m.id_medico
INNER JOIN Especialidade e ON me.id_especialidade = e.id_especialidade
ORDER BY c.data_consulta;

-- 2. Histórico de pagamentos dos pacientes (INNER JOIN)
SELECT p.nome_completo AS paciente, c.data_consulta, c.valor_consulta, pag.valor AS valor_pago, pag.status_pagamento, pag.metodo_pagamento
FROM Pagamento pag
INNER JOIN Consulta c ON pag.id_consulta = c.id_consulta
INNER JOIN Paciente p ON c.id_paciente = p.id_paciente
ORDER BY c.data_consulta;

-- 3. Médicos e suas especialidades (INNER JOIN)
SELECT m.nome_completo AS medico, m.crm, e.nome AS especialidade, me.valor_consulta, me.status
FROM Medico m
INNER JOIN Medico_especialidade me ON m.id_medico = me.id_medico
INNER JOIN Especialidade e ON me.id_especialidade = e.id_especialidade
ORDER BY m.nome_completo;

-- 4. Pacientes e seus prontuários (LEFT JOIN)
SELECT p.nome_completo AS paciente, c.data_consulta, pr.diagnostico, pr.status AS status_prontuario
FROM Paciente p
LEFT JOIN Consulta c ON p.id_paciente = c.id_paciente
LEFT JOIN Prontuario pr ON c.id_consulta = pr.id_consulta
ORDER BY p.nome_completo;

-- CONSULTAS EXTRAS PARA AMPLIAR A ANÁLISE

-- 5. Taxa de no-show
SELECT COUNT(*) AS total_consultas, SUM(CASE WHEN status = 'Faltou' THEN 1 ELSE 0 END) AS total_no_show, ROUND(100.0 * SUM(CASE WHEN status = 'Faltou' THEN 1 ELSE 0 END) / COUNT(*), 2) AS taxa_no_show_percentual
FROM Consulta;

-- 6. Quantidade de consultas por status
SELECT status, COUNT(*) AS quantidade
FROM Consulta
GROUP BY status
ORDER BY quantidade DESC;

-- 7. Faturamento recebido por método de pagamento
SELECT metodo_pagamento, COUNT(*) AS quantidade_pagamentos, SUM(valor) AS faturamento
FROM Pagamento
WHERE status_pagamento = 'Pago'
GROUP BY metodo_pagamento
ORDER BY faturamento DESC;

-- 8. Faturamento por especialidade
SELECT e.nome AS especialidade, COUNT(c.id_consulta) AS quantidade_consultas, SUM(CASE WHEN pag.status_pagamento = 'Pago' THEN pag.valor ELSE 0 END) AS faturamento_recebido
FROM Especialidade e
INNER JOIN Medico_especialidade me ON e.id_especialidade = me.id_especialidade
INNER JOIN Consulta c ON me.id_medico_especialidade = c.id_medico_especialidade
LEFT JOIN Pagamento pag ON c.id_consulta = pag.id_consulta
GROUP BY e.id_especialidade, e.nome
ORDER BY faturamento_recebido DESC;

-- 9. Médicos com quantidade de consultas realizadas
SELECT m.nome_completo AS medico, COUNT(c.id_consulta) AS total_consultas, SUM(CASE WHEN c.status = 'Realizada' THEN 1 ELSE 0 END) AS consultas_realizadas
FROM Medico m
INNER JOIN Medico_especialidade me ON m.id_medico = me.id_medico
INNER JOIN Consulta c ON me.id_medico_especialidade = c.id_medico_especialidade
GROUP BY m.id_medico, m.nome_completo
ORDER BY consultas_realizadas DESC;

-- 10. Pacientes com histórico de faltas
SELECT p.nome_completo AS paciente, COUNT(c.id_consulta) AS total_consultas, SUM(CASE WHEN c.status = 'Faltou' THEN 1 ELSE 0 END) AS total_faltas
FROM Paciente p
INNER JOIN Consulta c ON p.id_paciente = c.id_paciente
GROUP BY p.id_paciente, p.nome_completo
HAVING total_faltas > 0
ORDER BY total_faltas DESC;
