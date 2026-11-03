# Análisis de inventario — Uniformes La Pradera S.A.

Proyecto de portafolio: auditoría de inventario con Excel, SQL Server y Power BI.
Los datos son ficticios, creados para practicar.

## Hallazgo principal

El inventario no cuadra: el stock físico es 20.32 % mayor que el del sistema, una diferencia neta de 2,018 unidades en 2,464 registros.
Casi toda esa diferencia (93 %) viene de solo 94 registros (3.8 %) con diferencias de 10 unidades o más, y en 88 de ellos el físico es mayor que el del sistema.
Estos registros no se concentran en una sucursal, una fecha ni un SKU: están repartidos por todo el inventario, lo que descarta un problema puntual en un lugar.
La causa exacta aún no la conocemos; una hipótesis es la forma en que se registran los movimientos, pero con estos datos no podemos confirmarla.

## Dashboard

![Dashboard del Caso 1](images/dashboard-caso-1.png.png)
