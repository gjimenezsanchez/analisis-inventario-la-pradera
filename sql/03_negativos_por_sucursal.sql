/* =====================================================================
   03 - Stock_Sistema negativo por sucursal (con su base)
   Tecnica: SUM(CASE WHEN ...) en vez de WHERE, para conservar el total de
   registros y poder calcular el porcentaje. 1.0 y 100.0 fuerzan division
   con decimales (con enteros SQL Server trunca).
   Resultado validado:
     Cartago 27 de 616 (4.38%) | San Jose Centro 23 (3.73%)
     Heredia 19 (3.08%)        | Alajuela 11 (1.79%)      -> total 80 de 2,464 (3.25%)
   Lectura: chi-cuadrado 7.0 contra umbral 7.8 -> sin concentracion distinguible
   del azar. El mismo patron se repitio por fecha, SKU y categoria. En los 80
   registros el Stock_Fisico es 0: error de registro, no mercaderia perdida.
   ===================================================================== */

SELECT
    [Ubicación],
    SUM(CASE WHEN Stock_Sistema < 0 THEN 1 ELSE 0 END) AS cantidad_negativos,
    COUNT(*) AS total_registros,
    CAST(
        SUM(CASE WHEN Stock_Sistema < 0 THEN 1.0 ELSE 0 END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS porcentaje_negativo
FROM Inventario
GROUP BY [Ubicación]
ORDER BY porcentaje_negativo DESC;

-- Verificacion: Stock_Fisico en los negativos (resultado: 80 y 80)
SELECT COUNT(*) AS negativos,
       SUM(CASE WHEN Stock_Fisico = 0 THEN 1 ELSE 0 END) AS con_fisico_cero
FROM Inventario
WHERE Stock_Sistema < 0;
