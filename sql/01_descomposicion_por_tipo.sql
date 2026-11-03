/* =====================================================================
   01 - De donde sale la diferencia neta (hallazgo principal)
   Pregunta: de las 2,018 unidades de diferencia neta, cuanto aporta cada
   tipo de registro?
   Tecnica: CASE como etiqueta para agrupar. Gana la primera condicion que
   se cumple, y la expresion se repite en el GROUP BY (no se permiten alias).
   Resultado validado:
     1 negativo |   80 registros | neta   293 | absoluta   293
     2 grande   |   94 registros | neta 1,870 | absoluta 2,010
     3 normal   | 2,290 registros | neta  -145 | absoluta 2,849
   Chequeos: 80 + 94 + 2,290 = 2,464 registros; 293 + 1,870 - 145 = 2,018.
   Los 94 registros grandes (3.8%) explican el 93% de la diferencia NETA.
   ===================================================================== */

SELECT
    CASE
        WHEN Stock_Sistema < 0     THEN '1 negativo'
        WHEN ABS(Diferencia) >= 10 THEN '2 grande'
        ELSE '3 normal'
    END                     AS tipo,
    COUNT(*)                AS registros,
    SUM(Diferencia)         AS diferencia_neta,
    SUM(ABS(Diferencia))    AS diferencia_absoluta
FROM Inventario
GROUP BY
    CASE
        WHEN Stock_Sistema < 0     THEN '1 negativo'
        WHEN ABS(Diferencia) >= 10 THEN '2 grande'
        ELSE '3 normal'
    END
ORDER BY tipo;

-- Los tipos no se solapan (resultado: 0)
SELECT COUNT(*) AS negativos_y_grandes
FROM Inventario
WHERE Stock_Sistema < 0 AND ABS(Diferencia) >= 10;

-- Sentido de los registros grandes (resultado: 88 con fisico mayor, 6 con fisico menor;
-- +1,940 y -70 unidades; 1,940 - 70 = 1,870)
SELECT
    SUM(CASE WHEN Diferencia >=  10 THEN 1 ELSE 0 END)          AS grandes_fisico_mayor,
    SUM(CASE WHEN Diferencia <= -10 THEN 1 ELSE 0 END)          AS grandes_fisico_menor,
    SUM(CASE WHEN Diferencia >=  10 THEN Diferencia ELSE 0 END) AS unidades_positivas,
    SUM(CASE WHEN Diferencia <= -10 THEN Diferencia ELSE 0 END) AS unidades_negativas
FROM Inventario
WHERE ABS(Diferencia) >= 10;
