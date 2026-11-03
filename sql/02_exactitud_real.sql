/* =====================================================================
   02 - Exactitud real del inventario (tres definiciones)
   La diferencia NETA deja que positivos y negativos se compensen; por eso
   se mide tambien con valor absoluto. En el reporte hay que decir cual
   definicion se usa.
   Resultado validado (2,464 registros):
     pct_exactos          20.21   (Diferencia = 0)
     pct_dentro_de_2      91.44   (tolerancia holgada: stock promedio ~4 u por registro)
     pct_error_absoluto   51.88   (error absoluto sobre el stock en sistema)
   Referencia: diferencia neta = 20.32% (SUM(Diferencia) / SUM(Stock_Sistema)).
   ===================================================================== */

SELECT
    COUNT(*) AS registros,
    CAST(SUM(CASE WHEN Diferencia = 0 THEN 1.0 ELSE 0 END) * 100.0 / COUNT(*)
         AS DECIMAL(5,2)) AS pct_exactos,
    CAST(SUM(CASE WHEN ABS(Diferencia) <= 2 THEN 1.0 ELSE 0 END) * 100.0 / COUNT(*)
         AS DECIMAL(5,2)) AS pct_dentro_de_2,
    SUM(ABS(Diferencia)) AS diferencia_absoluta,
    CAST(SUM(ABS(Diferencia)) * 100.0 / NULLIF(SUM(Stock_Sistema), 0)
         AS DECIMAL(6,2)) AS pct_error_absoluto
FROM Inventario;
