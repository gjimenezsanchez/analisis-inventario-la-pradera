/* =====================================================================
   05 - Lead time real por proveedor contra el % de diferencia
   Tecnica: dos CTE (uno desde Compras, otro desde Inventario con JOIN a
   Productos) unidos por Proveedor. El * 1.0 evita que AVG de enteros trunque.
   Resultado validado de pct_diferencia (coincide con Excel):
     ImportTex 25.79 | Confecciones Andina 22.12 | Hilos y Telas CR 21.67
     Manufacturas Rapidas 17.44 | Textiles del Este 17.00
   Las 5 filas se copiaron a Excel para el CORREL:
     lead time real vs % diferencia: r = 0.833 (n = 5, p ~ 0.08)
     atraso promedio vs % diferencia: r = -0.32
   Lectura: pista a observar, no conclusion (5 proveedores).
   Nota: un JOIN por Proveedor devolvio 0 filas por un CHAR(13) oculto en
   Productos.Proveedor (BULK INSERT con ROWTERMINATOR '0x0a' en un CSV de Windows).
   Se corrigio con: UPDATE Productos SET Proveedor = REPLACE(Proveedor, CHAR(13), '');
   ===================================================================== */

WITH lead AS (
    SELECT
        Proveedor,
        AVG(DATEDIFF(DAY, Fecha_Pedido,   Fecha_Recibida) * 1.0) AS lead_time_real,
        AVG(DATEDIFF(DAY, Fecha_Esperada, Fecha_Recibida) * 1.0) AS atraso_promedio
    FROM Compras
    WHERE Fecha_Recibida IS NOT NULL
    GROUP BY Proveedor
),
dif AS (
    SELECT
        p.Proveedor,
        CAST(SUM(i.Diferencia) * 100.0 / NULLIF(SUM(i.Stock_Sistema), 0)
             AS DECIMAL(6,2)) AS pct_diferencia
    FROM Inventario AS i
    JOIN Productos  AS p ON p.SKU = i.SKU
    GROUP BY p.Proveedor
)
SELECT
    l.Proveedor,
    CAST(l.lead_time_real  AS DECIMAL(6,2)) AS lead_time_real,
    CAST(l.atraso_promedio AS DECIMAL(6,2)) AS atraso_promedio,
    d.pct_diferencia
FROM lead AS l
JOIN dif  AS d ON d.Proveedor = l.Proveedor
ORDER BY l.lead_time_real DESC;
