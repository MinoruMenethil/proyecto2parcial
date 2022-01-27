-- Consulta 1
-- Se desea realizar una consulta que muestre las cantidad de clientes que fueron atendidos por los empleados y que hallan comprado alguna pista del género del ROCK
SELECT Count(customers.CustomerId) AS Total_Clientes,
       employees.FirstName || " " || employees.LastName AS Empleado,
       tracks.TrackId AS Pista_Comprada,
       genres.Name AS Genero
  FROM tracks
       INNER JOIN
       invoice_items ON tracks.TrackId = invoice_items.TrackId
       INNER JOIN
       invoices ON invoice_items.InvoiceId = invoices.InvoiceId
       INNER JOIN
       customers ON invoices.CustomerId = customers.CustomerId
       INNER JOIN
       employees ON customers.SupportRepId = employees.EmployeeId
       INNER JOIN
       genres ON tracks.GenreId = genres.GenreId
 WHERE genres.Name LIKE "Rock"
 GROUP BY Empleado;


-- Consulta 2
-- Se desea realizar una consulta que muestre cual es la pista mas popular y cuantos usuarios compraron esas pista y en que playlist se encuentra disponible
SELECT count(tracks.TrackId) AS Cantidad,
       tracks.Name AS Nombre_Pista,
       customers.CustomerId AS Usuarios,
       playlists.Name AS Playlisit
  FROM playlists
       INNER JOIN
       playlist_track ON playlist_track.PlaylistId = playlists.PlaylistId
       INNER JOIN
       tracks ON playlist_track.TrackId = tracks.TrackId
       INNER JOIN
       invoice_items ON tracks.TrackId = invoice_items.TrackId
       INNER JOIN
       invoices ON invoice_items.InvoiceId = invoices.InvoiceId
       INNER JOIN
       customers ON invoices.CustomerId = customers.CustomerId
 GROUP BY tracks.Name
 ORDER BY customers.CustomerId DESC;


-- Consulta 3
-- Se desea realizan una consulta que muestre a todos los clientes 
-- que hayan comprado mas de 6 pistas y que el total de la venta 
-- sea mayor a $400
SELECT customers.FirstName || " " || customers.LastName AS Cliente,
       count(invoices.InvoiceId) AS Pistas,
       ROUND(sum(invoices.Total), 2) AS Total
  FROM tracks
       INNER JOIN
       invoice_items ON tracks.TrackId = invoice_items.TrackId
       INNER JOIN
       invoices ON invoice_items.InvoiceId = invoices.InvoiceId
       INNER JOIN
       customers ON invoices.CustomerId = customers.CustomerId
 GROUP BY Cliente
HAVING sum(invoices.Total) > 400
 ORDER BY Cliente ASC;


-- Consulta 4
-- Se desea realizar una consulta que muestre la canción y el género 
-- mas escuchado en cada año
SELECT COUNT(tracks.TrackId) AS Cantidad_Pista,
       tracks.Name AS Cancion,
       COUNT(genres.GenreId) AS Cantidad_Genero,
       genres.Name AS Genero,
       invoices.InvoiceDate AS Año
  FROM invoice_items
       INNER JOIN
       tracks ON tracks.TrackId = invoice_items.TrackId
       INNER JOIN
       genres ON genres.GenreId = tracks.GenreId
       INNER JOIN
       invoices ON invoices.InvoiceId = invoice_items.InvoiceId
 GROUP BY invoices.InvoiceDate,
          genres.Name
 ORDER BY Cantidad_Genero DESC,
          invoices.InvoiceDate DESC;
        

-- Consulta 5
-- Se desea realizar una consulta que muestre las ventas totales 
-- realizadas por cada cliente mensualmente en todos los anos y 
-- cual es el que mas ha consumido mas contenido y muestre a los 
-- empleados que lo atendieron
SELECT ROUND(sum(invoices.Total), 2) AS Total,
       customers.FirstName || " " || customers.LastName AS Cliente,
       invoices.InvoiceDate AS Fecha,
       employees.FirstName || " " || employees.LastName AS Empleado
  FROM invoices
       INNER JOIN
       customers ON invoices.CustomerId = customers.CustomerId
       INNER JOIN
       employees ON customers.SupportRepId = employees.EmployeeId
 GROUP BY invoices.InvoiceDate
 ORDER BY Cliente,
          invoices.InvoiceDate;


-- Consulta 6
-- Se desea realizar una consulta que muestre a todos los empleados 
--que hayan vendido al menos 30 canciones de cada genero musical y 
-- mueste el monto total de esas ventas
SELECT employees.FirstName || " " || employees.LastName AS Empleado,
       count(tracks.TrackId) AS Cantidad,
       genres.Name AS Genero,
       ROUND(SUM(invoices.Total), 2) AS Venta_Total
  FROM invoices
       INNER JOIN
       customers ON customers.CustomerId = invoices.CustomerId
       INNER JOIN
       employees ON employees.EmployeeId = customers.SupportRepId
       INNER JOIN
       invoice_items ON invoice_items.InvoiceId = invoices.InvoiceId
       INNER JOIN
       tracks ON tracks.TrackId = invoice_items.TrackId
       INNER JOIN
       genres ON genres.GenreId = tracks.GenreId
 GROUP BY genres.Name
HAVING Cantidad > 30
 ORDER BY Cantidad ASC;


-- Consulta 7
-- Se desea realizar una consulta que agrupe cada artista que haya 
-- vendido al menos 3 albunes en cada pais y muestre la cantidad de 
-- pista de cada album
SELECT artists.Name AS Artista,
       count(albums.AlbumId) AS Albunes,
       invoices.BillingCountry AS Pais,
       tracks.TrackId AS Pistas
  FROM tracks
       INNER JOIN
       artists ON artists.ArtistId = albums.ArtistId
       INNER JOIN
       albums ON albums.AlbumId = tracks.AlbumId
       INNER JOIN
       invoice_items ON tracks.TrackId = invoice_items.TrackId
       INNER JOIN
       invoices ON invoice_items.InvoiceId = invoices.InvoiceId
 GROUP BY Artista
 ORDER BY invoices.BillingCountry ASC;


-- Consulta 8
-- Se desea realizar una consulta que muestre al empleado que haya 
-- tenido mas clientes en el año 2010 y muestre a que país pertenece
SELECT employees.FirstName || " " || employees.LastName AS Empleado,
       customers.CustomerId AS Clientes,
       invoices.InvoiceDate AS Fecha,
       customers.Country AS Pais
  FROM invoices
       INNER JOIN
       customers ON invoices.CustomerId = customers.CustomerId
       INNER JOIN
       employees ON customers.SupportRepId = employees.EmployeeId
 WHERE invoices.InvoiceDate LIKE "2010%"
 GROUP BY Empleado,
          Pais
 ORDER BY Clientes DESC
 LIMIT 1;


-- Consulta 9
-- Se desea ralizar una consulta que muestre a todos los empleados, 
-- los clientes que atendieron en cada pais y el total de compras que hayan hecho con el genero Metal 
SELECT employees.FirstName || " " || employees.LastName AS Empleado,
       employees.BirthDate AS Fecha_Nac,
       customers.FirstName || " " || customers.LastName AS Clientes,
       customers.Country AS Pais,
       round(sum(invoices.Total), 2) AS Compra_Total,
       genres.Name AS Genero
  FROM invoices
       INNER JOIN
       customers ON invoices.CustomerId = customers.CustomerId
       INNER JOIN
       employees ON customers.SupportRepId = employees.EmployeeId
       INNER JOIN
       invoice_items ON invoice_items.InvoiceId = invoices.InvoiceId
       INNER JOIN
       tracks ON invoice_items.TrackId = tracks.TrackId
       INNER JOIN
       genres ON tracks.GenreId = genres.GenreId
 WHERE genres.Name LIKE "Metal"
 GROUP BY customers.Country
 ORDER BY Compra_Total DESC;


-- Consulta 10
-- Se desea realizar cuantos artistas existen en cada genero y 
-- en que pais se escucha el genero con mas artistas
SELECT count(artists.ArtistId) AS Cantidad_Artistas,
       genres.Name AS Genero,
       invoices.BillingCountry AS Pais
  FROM invoices
       INNER JOIN
       artists ON artists.ArtistId = albums.ArtistId
       INNER JOIN
       albums ON albums.AlbumId = tracks.AlbumId
       INNER JOIN
       tracks ON tracks.TrackId = invoice_items.TrackId
       INNER JOIN
       invoice_items ON invoice_items.InvoiceId = invoices.InvoiceId
       INNER JOIN
       genres ON genres.GenreId = tracks.GenreId
 GROUP BY Genero
 ORDER BY Cantidad_Artistas DESC;