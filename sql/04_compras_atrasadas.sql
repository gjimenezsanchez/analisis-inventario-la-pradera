/* =====================================================================
   04 - Compras recibidas en 2025 con mas de 20 dias de atraso (con su base)
   Decisiones:
   - El filtro del anio es un rango (>= inicio y < inicio del anio siguiente),
     no YEAR(), para no perder el uso de indices y evitar el borde del 31/12.
   - Se filtra por Fecha_Recibida: responde "que atrasos se observaron en 2025".
   - El WHERE solo filtra el periodo; el atraso se cuenta con SUM(CASE) para
     conservar la base (total de ordenes recibidas).
   Resultado validado: 16 de 400 ordenes recibidas en 2025 (4.0%).
     Extremos: Manufacturas Rapidas 5 de 71 (7.04%), ImportTex 2 de 76 (2.63%).
   Con 2 a 5 casos por proveedor nadie se distingue del azar.
   ===================================================================== */

SELECT
    Proveedor,
    COUNT(*) AS ordenes_recibidas,
    SUM(CASE WHEN DATEDIFF(DAY, Fecha_Esperada, Fecha_Recibida) > 20 THEN 1 ELSE 0 END)
        AS ordenes_con_atraso,
    CAST(SUM(CASE WHEN DATEDIFF(DAY, Fecha_Esperada, Fecha_Recibida) > 20 THEN 1.0 ELSE 0 END)
         * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS pct_con_atraso
FROM Compras
WHERE Fecha_Recibida >= '20250101'
  AND Fecha_Recibida <  '20260101'
GROUP BY Proveedor
ORDER BY pct_con_atraso DESC;
