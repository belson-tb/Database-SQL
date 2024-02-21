USE Chinook;

-- Elencate il numero di tracce per ogni genere in ordine discendente, escludendo quel genere che hanno meno di 10 tracce
SELECT Genre.Name AS Genre_Name, COUNT(*) AS CountTrack
FROM Genre
JOIN Track ON Genre.GenreId = Track.GenreId
GROUP BY Genre.GenreId
HAVING CountTrack  >= 10
ORDER BY CountTrack DESC;

-- Trovate le tre canzoni più costose
SELECT Track.Name, Track.UnitPrice AS MAXPrice
FROM Track
ORDER BY MAXPrice DESC
LIMIT 3;

-- Elencate gli artisti che hanno canzoni più lunghe di 6 minuti OPZIONE1
SELECT Artist.Name FROM Artist
JOIN Album ON Artist.ArtistId = Album.ArtistId
JOIN Track ON Track.AlbumId = Album.AlbumId
WHERE Track.Milliseconds > 360000
GROUP BY Artist.Name;

-- Elencate gli artisti che hanno canzoni più lunghe di 6 minuti OPZIONE1
SELECT Name
FROM Artist
WHERE ArtistId IN (SELECT Track.AlbumId FROM Track WHERE Track.Milliseconds/60000 > 6);

-- Individuate la durata media delle tracce per ogni genere
SELECT Genre.Name Genre_Name, ROUND(AVG(Track.Milliseconds/60000),2) AS AvgMinTime
FROM Genre
JOIN Track ON Track.GenreId = Genre.GenreId
GROUP BY Genre.Name;

-- Elencate tutte le canzoni con la parola "Love" nel titolo, ordinandole alfabeticamente prima per genere e poi per nome
SELECT Track.Name
FROM Track
JOIN Genre ON Genre.GenreId = Track.GenreId
WHERE Track.Name LIKE '%love%'
ORDER BY Genre.Name ASC;

-- Trovate il costo medio per ogni tipologia di media
SELECT Track.MediaTypeId AS Media, ROUND(AVG(UnitPrice),2) Avg_Media_Type_Cost
FROM Track
GROUP BY Track.MediaTypeId
ORDER BY Track.MediaTypeId ASC;

-- Individuate il genere con più tracce
SELECT Genre.Name AS Genre_Name, COUNT(Track.Name) AS Track_Count
FROM Genre
JOIN Track ON Track.GenreId = Genre.GenreId
GROUP BY Genre.Name 
ORDER BY Track_Count DESC
LIMIT 1;

-- Trovate il numero di artisti che hanno lo stesso numero di album dei Rolling Stones
SELECT Album.Title 
FROM Album
JOIN Artist ON Album.ArtistId = Artist.ArtistId
WHERE Artist.Name = 'The Rolling Stones';

-- Trovate l'artista con l'album più costoso
SELECT Artist.Name, Track.UnitPrice
FROM Artist
JOIN Album ON Album.ArtistId = Artist.ArtistId
JOIN Track ON Album.AlbumId = Track.AlbumId
ORDER BY Track.UnitPrice DESC
LIMIT 1;


