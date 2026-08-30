# ClínicaCare — Data Analytics & Machine Learning 🏥📊

Projeto desenvolvido no **Desafio Final da Fábrica de Software — Dados 2026.2**, com foco em **Engenharia de Dados, Análise Exploratória, Machine Learning e Business Intelligence**.

O objetivo é analisar a operação da clínica, identificar padrões de atendimento e avaliar o risco de **No-Show**, transformando dados em informações úteis para apoiar a tomada de decisões.

## 🎯 Objetivo

Desenvolver uma solução completa de dados, desde a modelagem do banco até a análise e visualização dos resultados:

**Modelagem → SQL → Python → Machine Learning → Power BI → Insights**

## 📂 Estrutura do Projeto

- `1_Modelagem/` — MER, modelo lógico e dicionário de dados.
- `2_SQL/` — Scripts DDL, DML, DQL e análises realizadas.
- `3_Python_ML/` — Notebook com tratamento, EDA, engenharia de atributos e Machine Learning.
- `4_PowerBI/` — Dashboard e documentação dos insights.

## 🗄️ Banco de Dados

O banco foi desenvolvido em **MySQL** e possui 10 entidades principais:

- Médico
- Paciente
- Especialidade
- Consulta
- Prontuário
- Pagamento
- Plano
- Prescrição
- Médico_Especialidade
- Horário

## 🐍 Python e Machine Learning

A análise foi desenvolvida em **Python/Google Colab**, contemplando:

- Tratamento e preparação dos dados;
- Engenharia de atributos;
- Análise Exploratória de Dados (EDA);
- Visualização dos dados;
- Classificação supervisionada;
- Avaliação dos modelos.

### Modelos avaliados

- Regressão Logística;
- Random Forest.

### Métricas utilizadas

- Accuracy;
- Precision;
- Recall;
- F1-Score;
- Matriz de Confusão.

O objetivo do modelo é auxiliar na identificação de consultas com maior risco de **No-Show**.

## 📊 Power BI

O dashboard apresenta:

- Total de consultas;
- Total de faltas;
- Consultas por especialidade;
- Distribuição por plano;
- Evolução de consultas realizadas e No-Shows;
- Antecedência média dos agendamentos;
- Filtros interativos.

## 🔎 Principais Insights

- **200 consultas** foram analisadas, sendo **41 No-Shows**, correspondendo a aproximadamente **20,5%** dos registros.
- **Ortopedia** apresentou o maior volume de consultas, seguida por Dermatologia e Cardiologia.
- **Dermatologia** apresentou a maior antecedência média de agendamento, com aproximadamente **34,3 dias**.
- A distribuição das consultas entre os diferentes planos mostrou-se relativamente equilibrada.
- Os resultados indicam oportunidades para reduzir No-Shows por meio de estratégias de confirmação e lembretes.

## 💡 Recomendações

- Implementar lembretes automatizados antes das consultas;
- Priorizar confirmações para consultas agendadas com maior antecedência;
- Monitorar a taxa de No-Show por especialidade e período;
- Utilizar os indicadores de demanda no planejamento de médicos, salas e horários;
- Utilizar modelos preditivos como apoio à identificação de consultas com maior risco de No-Show.

## 🛠️ Tecnologias

- **MySQL**
- **MySQL Workbench**
- **Python**
- **Google Colab**
- **Pandas**
- **NumPy**
- **Scikit-Learn**
- **Matplotlib**
- **Seaborn**
- **Microsoft Power BI**
- **BRModelo**

## ⚠️ Limitações

Os resultados refletem o conjunto de dados utilizado no projeto e devem ser interpretados como apoio à tomada de decisão.

A utilização de dados sintéticos e as limitações do conjunto de dados podem afetar a generalização dos resultados. Além disso, resultados preditivos indicam padrões e associações, mas não estabelecem causalidade.

## 👤 Autor

**Wálisson**

Desafio Final — **Fábrica de Software | Dados 2026.2**