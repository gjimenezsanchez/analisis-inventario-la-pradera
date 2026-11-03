/* =====================================================================
   06 - Vista que alimenta Power BI
   Una vista es una consulta guardada con nombre que se comporta como una
   tabla; no cambia ningun dato. Une Inventario con Productos (por SKU) y con
   Calendario (por Fecha) y agrega tipo_registro (Negativo / Grande / Normal).
   CREATE VIEW debe ser la unica instruccion de su bloque (ejecutar sola).
   Chequeo (en otra ejecucion):
     SELECT COUNT(*) AS filas, SUM(Diferencia) AS neta FROM vw_Inventario_Detalle;
     -- esperado: 2,464 filas y neta = 2,018
   ===================================================================== */

CREATE OR ALTER VIEW vw_Inventario_Detalle AS
SELECT i.InventarioID, i.Fecha, c.Trimestre, i.SKU,
       p.[Categoría], p.Marca, p.Proveedor, i.[Ubicación],
       i.Stock_Sistema, i.Stock_Fisico, i.Diferencia,
       CASE WHEN i.Stock_Sistema < 0     THEN 'Negativo'
            WHEN ABS(i.Diferencia) >= 10 THEN 'Grande'
            ELSE 'Normal' END AS tipo_registro
FROM Inventario AS i
JOIN Productos  AS p ON p.SKU   = i.SKU
JOIN Calendario AS c ON c.Fecha = i.Fecha;
