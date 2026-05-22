# DW Ventes AdventureWorks

Plateforme décisionnelle - Analyse des Ventes
Architecture Medallion (Bronze → Silver → Gold)

## Stack technique
- SQL Server 2022
- AdventureWorks2022 (source)
- SSIS (ETL)
- SSAS (Cube OLAP)
- Power BI (Dashboards)

## Structure
sql-scripts/     → Scripts SQL par couche Medallion
ssis-packages/   → Packages ETL SSIS
ssas-cube/       → Solution SSAS
powerbi/         → Rapports Power BI
diagrams/        → Schémas architecture et MCD
docs/            → Documentation technique

## Prérequis
- SQL Server 2019 ou supérieur
- AdventureWorks2022 restaurée
- Visual Studio 2022 avec extension SSIS
- Power BI Desktop

## Instructions
1. Exécuter sql-scripts/01_Create_Database.sql
2. Exécuter sql-scripts/02_Bronze_Schema.sql
3. Exécuter sql-scripts/03_Bronze_Load.sql
4. Exécuter sql-scripts/04_Silver_Schema.sql
5. Exécuter sql-scripts/05_Silver_Load.sql
6. Exécuter sql-scripts/06_Gold_Schema.sql
7. Exécuter sql-scripts/07_Gold_Load.sql
