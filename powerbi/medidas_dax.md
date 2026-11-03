# Medidas DAX del dashboard (Caso 1)

Todas las medidas viven en una tabla aparte llamada `_Medidas`, para no mezclarlas con las columnas de los datos.
Se calculan sobre la vista `vw_Inventario_Detalle` (ver `sql/06_vista_inventario_detalle.sql`).

Las medidas se construyen unas sobre otras: primero las básicas (Diferencia Neta, Stock Sistema, Registros) y después las que las reutilizan.

## Medidas básicas

**Diferencia Neta**: suma de la diferencia entre el stock físico y el del sistema. Los positivos y los negativos se compensan.
```dax
Diferencia Neta = SUM(vw_Inventario_Detalle[Diferencia])
```

**Stock Sistema**: unidades que marca el sistema.
```dax
Stock Sistema = SUM(vw_Inventario_Detalle[Stock_Sistema])
```

**Registros**: cantidad de registros del inventario.
```dax
Registros = COUNTROWS(vw_Inventario_Detalle)
```

## Porcentajes

**% Diferencia**: diferencia neta sobre el stock del sistema. Usa `DIVIDE` para devolver vacío en lugar de un error si el denominador es cero.
```dax
% Diferencia = DIVIDE([Diferencia Neta], [Stock Sistema])
```

**% Diferencia General**: el mismo porcentaje, pero ignorando el filtro de proveedor (`ALL`). Da el 20.32 % de todo el inventario y sirve como línea de referencia en el gráfico por proveedor.
```dax
% Diferencia General = 
CALCULATE([% Diferencia], ALL(Productos[Proveedor]))
```

## Registros grandes

Un registro es "Grande" cuando su diferencia es de 10 unidades o más en valor absoluto (columna `tipo_registro` de la vista).

**Registros Grandes**: cuántos registros hay de ese tipo (94).
```dax
Registros Grandes = 
    CALCULATE([Registros], vw_Inventario_Detalle[tipo_registro] = "Grande")
```

**% Neto Explicado por Grandes**: qué parte de la diferencia neta aportan los registros grandes (93 %).
```dax
% Neto Explicado por Grandes = 
    DIVIDE(
        CALCULATE([Diferencia Neta], vw_Inventario_Detalle[tipo_registro] = "Grande"),
        [Diferencia Neta]
    )
```

**Grandes Fisico Mayor**: de los registros grandes, cuántos tienen más mercadería física que la del sistema (88 de 94).
```dax
Grandes Fisico Mayor = 
    CALCULATE([Registros],
        vw_Inventario_Detalle[tipo_registro] = "Grande",
        vw_Inventario_Detalle[Diferencia] > 0)
```
