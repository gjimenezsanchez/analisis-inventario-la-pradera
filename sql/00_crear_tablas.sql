/* =====================================================================
   00 - Crear las tablas del proyecto (Uniformes La Pradera S.A.)
   Ejecutar UNA sola vez, en una base de datos nueva.
   Decisiones:
   - Sin llaves foraneas: los datos ya venian limpios de Power Query.
   - VARCHAR (no NVARCHAR): el texto es latino, 1 byte por caracter alcanza.
   - Stock_Sistema sin restriccion: los valores negativos son parte del analisis.
   - Compras y Pedidos aceptan NULL en recepcion/entrega (ordenes pendientes).
   Carga de datos: Import Flat File a tablas *_staging y luego INSERT INTO ... SELECT
   con CONVERT(date, texto, 103) porque las fechas vienen como dd/mm/yyyy.
   ===================================================================== */

CREATE TABLE Productos (
    SKU            VARCHAR(10)   PRIMARY KEY,
    Producto       VARCHAR(100)  NOT NULL,
    [Categoría]    VARCHAR(50)   NOT NULL,
    [Subcategoría] VARCHAR(50)   NOT NULL,
    Talla          VARCHAR(10)   NOT NULL,
    Marca          VARCHAR(50)   NOT NULL,
    Costo_Unitario DECIMAL(10,2) NOT NULL,
    Precio_Venta   DECIMAL(10,2) NOT NULL,
    Stock_Minimo   INT           NOT NULL,
    Stock_Maximo   INT           NOT NULL,
    Lead_Time_Dias INT           NOT NULL,
    Proveedor      VARCHAR(50)   NOT NULL
);

CREATE TABLE Calendario (
    Fecha     DATE        PRIMARY KEY,
    Año       INT         NOT NULL,
    TrimNum   INT         NOT NULL,
    Trimestre VARCHAR(10) NOT NULL,
    Mes       INT         NOT NULL
);

CREATE TABLE Ventas (
    ID_Venta        INT           PRIMARY KEY,
    Fecha           DATE          NOT NULL,
    SKU             VARCHAR(10)   NOT NULL,
    Producto        VARCHAR(100)  NOT NULL,
    [Categoría]     VARCHAR(50)   NOT NULL,
    Talla           VARCHAR(10)   NOT NULL,
    Cantidad        INT           NOT NULL,
    Precio_Unitario DECIMAL(10,2) NOT NULL,
    Cliente         VARCHAR(100)  NOT NULL,
    Sucursal        VARCHAR(50)   NOT NULL
);

CREATE TABLE Inventario (
    InventarioID  INT IDENTITY(1,1) PRIMARY KEY,
    Fecha         DATE        NOT NULL,
    SKU           VARCHAR(10) NOT NULL,
    Stock_Sistema INT         NOT NULL,  -- puede ser negativo
    Stock_Fisico  INT         NOT NULL,
    Diferencia    INT         NOT NULL,  -- Stock_Fisico - Stock_Sistema
    [Ubicación]   VARCHAR(50) NOT NULL
);

CREATE TABLE Compras (
    ID_Compra           INT         PRIMARY KEY,
    Fecha_Pedido        DATE        NOT NULL,
    SKU                 VARCHAR(10) NOT NULL,
    Cantidad_Pedida     INT         NOT NULL,
    Proveedor           VARCHAR(50) NOT NULL,
    Fecha_Esperada      DATE        NOT NULL,
    Fecha_Recibida      DATE        NULL,  -- NULL = todavia no llego
    Cantidad_Recibida   INT         NULL,
    Lead_Time_Real_Dias INT         NULL
);

CREATE TABLE Pedidos (
    ID_Pedido       INT          PRIMARY KEY,
    Fecha_Pedido    DATE         NOT NULL,
    Cliente         VARCHAR(100) NOT NULL,
    SKU             VARCHAR(10)  NOT NULL,
    Cantidad        INT          NOT NULL,
    Fecha_Requerida DATE         NOT NULL,
    Fecha_Entrega   DATE         NULL,  -- NULL = pendiente o cancelado
    Estado          VARCHAR(20)  NOT NULL
);
