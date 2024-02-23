-- Creazione del database Toysgroup
CREATE DATABASE Toysgroup;

-- Selezione del database Toysgroup
USE Toysgroup;

-- Creazione della tabella Product
CREATE TABLE Product (
    Product_id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    Description TEXT,
    Category_id INT,
    Category_name VARCHAR(255)
);

-- Creazione della tabella Region
CREATE TABLE IF NOT EXISTS Region (
    Region_id INT AUTO_INCREMENT PRIMARY KEY,
    Country_id INT,
    Country_name VARCHAR(255)
    );
    
-- Creazione della tabella Sales
CREATE TABLE Sales (
    Transition_id INT AUTO_INCREMENT PRIMARY KEY,
    Document_Code INT,
    Product_id INT,
    Region_id INT,
    Transition_date DATE,
    Cost DECIMAL(10, 2),
    CONSTRAINT fk_product FOREIGN KEY (Product_id) REFERENCES Product(Product_id),
    CONSTRAINT fk_region FOREIGN KEY (Region_id) REFERENCES Region(Region_id)
);

-- Popolamento della tabella Product
INSERT INTO Product (Name, Description, Category_id) VALUES
('Action Figure', 'A posable character figurine', 1),
('Doll', 'A small model of a human figure, often a baby or girl, used as a child toy', 1),
('LEGO Set', 'A set of interlocking plastic building blocks', 2),
('Board Game', 'A game played on a board with counters or pieces', 3),
('Remote Control Car', 'A toy car that can be controlled remotely', 4),
('Puzzle', 'A game or toy that tests a person ingenuity or knowledge', 3),
('Teddy Bear', 'A stuffed toy bear', 1),
('Toy Kitchen Set', 'A miniature kitchen set for children to play with', 5),
('Toy Train Set', 'A set of toy trains and tracks', 6),
('Toy Musical Instrument', 'A miniature version of a musical instrument for children to play with', 7),
('Building Blocks', 'A set of small, wooden or plastic blocks used as a construction toy', 2),
('Stuffed Animal', 'A soft toy animal filled with stuffing', 1),
('RC Helicopter', 'A toy helicopter that can be controlled remotely', 4),
('Dollhouse', 'A miniature house for dolls to live in', 5),
('Play-Doh Set', 'A set of modeling compound and tools', 8);

-- Popolamento della tabella Region
INSERT INTO Region (Country_id, Country_name) VALUES
(1, 'USA'),
(2, 'UK'),
(3, 'Germany'),
(4, 'France'),
(5, 'Italy'),
(6, 'Japan'),
(7, 'China'),
(8, 'Australia'),
(9, 'Canada'),
(10, 'Brazil'),
(11, 'Spain'),
(12, 'India'),
(13, 'Russia'),
(14, 'South Korea'),
(15, 'Mexico');

-- Popolamento della tabella Sales
INSERT INTO Sales (Transition_date, Document_Code, Product_id, Region_id, Cost) 
SELECT  
    DATE_ADD('2009-01-01', INTERVAL FLOOR(RAND() * DATEDIFF('2017-12-31', '2009-01-01')) DAY),
    FLOOR(1 + RAND() * 15),
    FLOOR(1 + RAND() * 15),
    FLOOR(1 + RAND() * 15),
    ROUND(RAND() * 100, 2)
FROM 
    information_schema.tables 
LIMIT 
    15;
    
-- 1.1 Verificare che tutti i campi definiti com primary key siano univoci (tabella Product)
SELECT Product_id, COUNT(*) AS NumOccurrences
FROM Product
GROUP BY Product_id
HAVING COUNT(*) > 1;

-- 1.2 Verificare che tutti i campi definiti com primary key siano univoci (tabella Region)
SELECT Region_id, COUNT(*) AS NumOccurrences
FROM Region
GROUP BY Region_id
HAVING COUNT(*) > 1;

-- 1.3 Verificare che tutti i campi definiti com primary key siano univoci (tabella Sales)
SELECT Transition_id, COUNT(*) AS NumOccurrences
FROM Sales
GROUP BY Transition_id
HAVING COUNT(*) > 1;

-- 2. Esporre l'elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno --
SELECT *
FROM Product;
SELECT 
    YEAR(s.Transition_date) AS Year,
    p.Name AS Product,
    SUM(s.Cost) AS Total_Revenue
FROM 
    Sales s
JOIN 
    Product p ON s.Product_id = p.Product_id
GROUP BY 
    Year, Product;

-- 2. Esporre il fatturato totale per stato per anno. Ordina il fatturato per data e per fatturato descrescente
SELECT 
    YEAR(s.Transition_date) AS Year,
    r.Country_name AS Country,
    SUM(s.Cost) AS TotalRevenue
FROM 
    Sales s
JOIN 
    Region r ON s.Region_id = r.Region_id
GROUP BY 
    Year, Country
ORDER BY 
    Year ASC, TotalRevenue DESC;
    
-- 2. Qual è la categoria di articoli maggiormente richiesta dal mercato?
SELECT
    p.category_id AS Categoria,
    COUNT(*) AS Numero_Vendite
FROM
    Sales s
JOIN
    Product p ON s.Product_id = p.Product_id
GROUP BY
    p.category_id
ORDER BY
    Numero_Vendite DESC
LIMIT 1;
    
-- 3.1 Quali sono, se ci sono, i prodotti invenduti? PROPOSTA 1
SELECT 
    p.*
FROM 
    Product p
LEFT JOIN 
    Sales s ON p.Product_id = s.Product_id
WHERE 
    s.Product_id IS NULL;
    
-- 3.2 Quali sono, se ci sono, i prodotti invenduti? PROPOSTA 2
SELECT 
    *
FROM 
    Product
WHERE 
    Product_id NOT IN (SELECT Product_id FROM Sales);
    
-- Esporre l'elenco dei prodotti con la rispettiva ultima data di vendita (la data di vendita più recente)
SELECT 
    p.*,
    MAX(s.Transition_date) AS Latest_Sale_Date
FROM 
    Product p
LEFT JOIN 
    Sales s ON p.Product_id = s.Product_id
GROUP BY 
    p.Product_id;
    
/* BONUS: Esporre l'elenco delle transazioni indicando nel result set il codice documento, 
la data, il nome del prodotto, la categoria del prodotto, il nome dello stato,
il nome della region di vendita e un campo booleano valorizzato in base alla condizione 
che siano passati più di 180 giorni dalla data di vendita o meno 
(>180 True, <=180 False)*/
SELECT
    s.document_code AS Codice_Documento,
    s.Transition_date AS Data,
    p.Name AS Nome_Prodotto,
    p.category_ID AS Categoria_Prodotto,
    r.Country_name AS Stato,
    rg.Country_name AS Regione,
    IF(DATEDIFF(NOW(), s.Transition_date) > 180, TRUE, FALSE) AS Passati_180_Giorni
FROM
    Sales s
JOIN
    Product p ON s.Product_id = p.Product_id
JOIN
    Region r ON s.Region_id = r.Region_id
JOIN
    Region rg ON r.Country_id = rg.Country_id
ORDER BY
    s.Transition_date DESC;