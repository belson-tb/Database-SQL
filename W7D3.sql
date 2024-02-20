USE CHINOOK;

-- Recuperate tutte le tracce che abbiano come genere "Pop" e "Rock".
SELECT 
    Track.Name AS Track_Name, Genre.Name AS Genre_Name
FROM
    Track
        JOIN
    genre ON Track.GenreId = Genre.GenreId
WHERE
    Genre.Name IN ('POP' , 'ROCK');

-- Elencate tutti gli artisti e/o album che iniziano con la lettera "A"alter
SELECT 
    Album.Title, Artist.Name
FROM
    Album
        RIGHT JOIN
    Artist ON Album.ArtistId = Artist.ArtistId
WHERE
    Album.Title LIKE 'A%'
        OR Artist.Name LIKE 'A%'
        AND Album.Title IS NOT NULL;

-- Recuperate i nomi degli album o degli artisti che abbiano pubblicazioni precedenti all'anno 2000.
SELECT 
    Album.Title, Artist.Name
FROM
    Album;

-- Elencate tutte le tracce che hanno come genere "Jazz" o che durano meno di 3 minuti.
SELECT 
    Track.Name AS Track_Name,
    Genre.Name AS Genre_Name,
    Track.Milliseconds / 60000 AS Min_Duration
FROM
    Track
        JOIN
    Genre ON Track.GenreId = Genre.GenreId
WHERE
    Genre.Name = 'Jazz'
        OR Track.Milliseconds / 60000 < 3;
        
-- Recuperate tutte le tracce più lunghe della durata media
SELECT Track.Name AS Track_Name, Track.Milliseconds/60000 AS Min_Duration
FROM Track
WHERE Milliseconds > (SELECT AVG(Milliseconds) FROM Track);

-- Individuate i generi con una durata media maggiore di 4 minuti
SELECT Genre.Name AS Genre_Name, AVG(Track.Milliseconds)/60000 AS avg_tracks
FROM Track
JOIN Genre ON Track.GenreId = Genre.GenreId
GROUP BY Genre.GenreId
HAVING AVG(Track.Milliseconds) > 240000;

-- Individuate gli artisti che hanno rilasciato più di un album
SELECT Artist.Name AS Artist_Name, COUNT(Album.AlbumId) AS Album_Title
FROM Artist
JOIN Album ON Artist.ArtistId = Album.ArtistId
GROUP BY Artist.Name
HAVING COUNT(Album.AlbumId) >1;

-- Trovate la traccia più lunga per ogni album OPZIONE1
SELECT Album.Title AS Album_Title, Track.Name as Track_Name, Track.Milliseconds/60000 AS DurationInMin
FROM Album
JOIN Track ON Album.AlbumId = Track.AlbumId
JOIN 
(SELECT AlbumId, MAX(Milliseconds) AS MaxDuration 
FROM Track 
GROUP BY AlbumId) AS MaxTrack
ON Track.AlbumId = MaxTrack.AlbumId AND Track.Milliseconds = MaxTrack.MaxDuration;

-- Trovate la traccia più lunga per ogni album OPZIONE2
SELECT Album.Title AS Album_Title, MAX(Track.Milliseconds) / 60000 AS Max_Duration
FROM Album
JOIN Track ON Album.AlbumId = Track.AlbumId
GROUP BY Album.AlbumId, Album.Title;

-- Individuate la durata media delle tracce per ogni album -- 
SELECT Album.Title AS Album_Title, AVG(Track.Milliseconds) / 60000 AS Avarage_Duration
FROM Album
JOIN Track ON Album.AlbumId = Track.AlbumId
GROUP BY Album.AlbumId, Album.Title;

