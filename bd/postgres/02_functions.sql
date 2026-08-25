-- =====================================================================
-- TiendaRepuestos - procedimientos almacenados convertidos de MySQL a
-- funciones PL/pgSQL con parametro OUT, para preservar el patron de
-- llamada JDBC existente en las DAO (CallableStatement + prepareCall
-- "{call P_Nombre(?,?,...)}" + registerOutParameter + getObject).
--
-- Notas de la conversion:
--  - MySQL usaba START TRANSACTION / COMMIT dentro del procedimiento,
--    pero PostgreSQL no permite control transaccional dentro de una
--    funcion (solo dentro de PROCEDURE invocada con CALL, PG11+).
--    Esas sentencias se eliminan: el control real de la transaccion ya
--    lo hacia el codigo Java (Connection.setAutoCommit(false) +
--    commit()/rollback()), asi que el comportamiento se preserva.
--  - El "SELECT flag_exitoso;" final de MySQL tampoco es necesario: el
--    valor se devuelve por el parametro OUT, que es lo que lee el DAO
--    via cs.getObject(indice).
-- =====================================================================

CREATE OR REPLACE FUNCTION P_Actualizar_Cliente(
    IN _idCliente integer,
    IN _numeroDocumento varchar(13),
    IN _nombres varchar(150),
    IN _apellidos varchar(100),
    IN _razonSocial varchar(100),
    IN _direccion varchar(150),
    IN _telefono varchar(10),
    IN _email varchar(100),
    IN _idTipoDocumento integer,
    IN _idTipoCliente integer,
    OUT flag_exitoso integer
) AS $$
DECLARE
    _idPersona integer;
BEGIN
    flag_exitoso := 0;
    SELECT idPersona INTO _idPersona FROM Cliente WHERE idCliente = _idCliente LIMIT 1;

    UPDATE Persona SET numeroDocumento = _numeroDocumento, nombres = _nombres,
        direccion = _direccion, telefono = _telefono, email = _email,
        idTipoDocumento = _idTipoDocumento WHERE idPersona = _idPersona;

    UPDATE Cliente SET apellidos = _apellidos, razonSocial = _razonSocial,
        idTipoCliente = _idTipoCliente WHERE idCliente = _idCliente;

    flag_exitoso := 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Actualizar_Empleado(
    IN _idEmpleado integer,
    IN _numeroDocumento varchar(13),
    IN _nombres varchar(100),
    IN _apellidos varchar(100),
    IN _direccion varchar(150),
    IN _telefono varchar(10),
    IN _email varchar(100),
    IN _idTipoDocumento integer,
    IN _idTipoEmpleado varchar(6),
    OUT flag_exitoso integer
) AS $$
DECLARE
    _idPersona integer;
BEGIN
    flag_exitoso := 0;
    SELECT idPersona INTO _idPersona FROM Empleado WHERE idEmpleado = _idEmpleado LIMIT 1;

    UPDATE Persona SET numeroDocumento = _numeroDocumento, nombres = _nombres,
        direccion = _direccion, telefono = _telefono, email = _email,
        idTipoDocumento = _idTipoDocumento WHERE idPersona = _idPersona;

    UPDATE Empleado SET idTipoEmpleado = _idTipoEmpleado, apellidos = _apellidos
        WHERE idEmpleado = _idEmpleado;

    flag_exitoso := 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Actualizar_Proveedor(
    IN _idProveedor integer,
    IN _numeroDocumento varchar(13),
    IN _razonComercial varchar(150),
    IN _direccion varchar(150),
    IN _telefono varchar(10),
    IN _email varchar(100),
    IN _idTipoDocumento integer,
    OUT flag_exitoso integer
) AS $$
DECLARE
    _idPersona integer;
BEGIN
    flag_exitoso := 0;
    SELECT idPersona INTO _idPersona FROM Proveedor WHERE idProveedor = _idProveedor LIMIT 1;

    UPDATE Persona SET numeroDocumento = _numeroDocumento,
        direccion = _direccion, telefono = _telefono, email = _email,
        idTipoDocumento = _idTipoDocumento WHERE idPersona = _idPersona;

    UPDATE Proveedor SET razonComercial = _razonComercial WHERE idProveedor = _idProveedor;

    flag_exitoso := 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Actualizar_Repuesto(
    IN _idRepuesto integer,
    IN _descrip varchar(150),
    IN _stock integer,
    IN _precio numeric(6,2),
    IN _precioPorMayor numeric(6,2),
    OUT flag_exitoso integer
) AS $$
DECLARE
    _idProducto integer;
BEGIN
    flag_exitoso := 0;
    SELECT idProducto INTO _idProducto FROM Repuesto WHERE idRepuesto = _idRepuesto LIMIT 1;

    UPDATE Producto SET descripcion = _descrip,
        stock = _stock, precio = _precio, precioPorMayor = _precioPorMayor
        WHERE idProducto = _idProducto;

    flag_exitoso := 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Actualizar_TipoDocumento(
    IN _id integer,
    IN _descrip varchar(100),
    OUT flag_exitoso integer
) AS $$
BEGIN
    flag_exitoso := 0;
    UPDATE TipoDocumento SET descripcion = _descrip WHERE idTipoDocumento = _id;
    flag_exitoso := 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Actualizar_TipoEmpleado(
    IN _id varchar(6),
    IN _descrip varchar(100),
    OUT flag_exitoso integer
) AS $$
BEGIN
    flag_exitoso := 0;
    UPDATE TipoEmpleado SET descripcion = _descrip WHERE idTipoEmpleado = _id;
    flag_exitoso := 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Actualizar_TipoServicio(
    IN _id integer,
    IN _descrip varchar(100),
    OUT flag_exitoso integer
) AS $$
BEGIN
    flag_exitoso := 0;
    UPDATE TipoServicio SET descripcion = _descrip WHERE idTipoServicio = _id;
    flag_exitoso := 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Anular_ComprobanteVenta(
    IN _idComprobanteVenta integer,
    OUT flag_exitoso integer
) AS $$
DECLARE
    _estado boolean;
BEGIN
    SELECT estado INTO _estado FROM ComprobanteVenta WHERE idComprobanteVenta = _idComprobanteVenta;

    IF (_estado = true) THEN
        UPDATE ComprobanteVenta SET estado = false WHERE idComprobanteVenta = _idComprobanteVenta;
    ELSE
        UPDATE ComprobanteVenta SET estado = true WHERE idComprobanteVenta = _idComprobanteVenta;
    END IF;

    flag_exitoso := 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Eliminar_Cliente(
    IN _idCliente integer,
    OUT flag_exitoso integer
) AS $$
DECLARE
    _idPersona integer;
BEGIN
    flag_exitoso := 0;
    SELECT idPersona INTO _idPersona FROM Cliente WHERE idCliente = _idCliente LIMIT 1;

    DELETE FROM Cliente WHERE idCliente = _idCliente;
    DELETE FROM Persona WHERE idPersona = _idPersona;

    flag_exitoso := 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Eliminar_Empleado(
    IN _idEmpleado integer,
    OUT flag_exitoso integer
) AS $$
DECLARE
    _idPersona integer;
BEGIN
    flag_exitoso := 0;
    SELECT idPersona INTO _idPersona FROM Empleado WHERE idEmpleado = _idEmpleado LIMIT 1;

    DELETE FROM Empleado WHERE idEmpleado = _idEmpleado;
    DELETE FROM Persona WHERE idPersona = _idPersona;

    flag_exitoso := 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Eliminar_Proveedor(
    IN _idProveedor integer,
    OUT flag_exitoso integer
) AS $$
DECLARE
    _idPersona integer;
BEGIN
    flag_exitoso := 0;
    SELECT idPersona INTO _idPersona FROM Proveedor WHERE idProveedor = _idProveedor LIMIT 1;

    DELETE FROM Proveedor WHERE idProveedor = _idProveedor;
    DELETE FROM Persona WHERE idPersona = _idPersona;

    flag_exitoso := 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Insertar_Cliente(
    IN _numeroDocumento varchar(13),
    IN _nombres varchar(150),
    IN _apellidos varchar(100),
    IN _razonSocial varchar(100),
    IN _direccion varchar(150),
    IN _telefono varchar(10),
    IN _email varchar(100),
    IN _idTipoDocumento integer,
    IN _idTipoCliente integer,
    OUT flag_exitoso integer
) AS $$
DECLARE
    contadorPersona integer := 0;
    contadorCliente integer := 0;
    contador_rep integer := 0;
BEGIN
    flag_exitoso := 0;

    SELECT count(*) INTO contador_rep FROM Persona WHERE numeroDocumento = _numeroDocumento;

    IF (contador_rep != 0) THEN
        flag_exitoso := 2;
    ELSE
        SELECT idPersona INTO contadorPersona FROM Persona ORDER BY idPersona DESC LIMIT 1;
        SELECT idCliente INTO contadorCliente FROM Cliente ORDER BY idCliente DESC LIMIT 1;
        contadorPersona := COALESCE(contadorPersona, 0);
        contadorCliente := COALESCE(contadorCliente, 0);

        INSERT INTO Persona(idPersona,numeroDocumento,nombres,direccion,telefono,email,idTipoDocumento)
            VALUES(contadorPersona+1,_numeroDocumento,_nombres,_direccion,_telefono,_email,_idTipoDocumento);

        INSERT INTO Cliente(idCliente,apellidos,razonSocial,idPersona,idTipoCliente)
            VALUES(contadorCliente+1,_apellidos,_razonSocial,contadorPersona+1,_idTipoCliente);

        flag_exitoso := 1;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Insertar_Empleado(
    IN _numeroDocumento varchar(13),
    IN _nombres varchar(150),
    IN _apellidos varchar(150),
    IN _direccion varchar(150),
    IN _telefono varchar(10),
    IN _email varchar(100),
    IN _idTipoDocumento integer,
    IN _idTipoEmpleado varchar(6),
    OUT flag_exitoso integer
) AS $$
DECLARE
    contadorPersona integer := 0;
    contadorEmpleado integer := 0;
    contador_rep integer := 0;
BEGIN
    flag_exitoso := 0;

    SELECT count(*) INTO contador_rep FROM Persona WHERE numeroDocumento = _numeroDocumento;

    IF (contador_rep != 0) THEN
        flag_exitoso := 2;
    ELSE
        SELECT idPersona INTO contadorPersona FROM Persona ORDER BY idPersona DESC LIMIT 1;
        SELECT idEmpleado INTO contadorEmpleado FROM Empleado ORDER BY idEmpleado DESC LIMIT 1;
        contadorPersona := COALESCE(contadorPersona, 0);
        contadorEmpleado := COALESCE(contadorEmpleado, 0);

        INSERT INTO Persona(idPersona,numeroDocumento,nombres,direccion,telefono,email,idTipoDocumento)
            VALUES(contadorPersona+1,_numeroDocumento,_nombres,_direccion,_telefono,_email,_idTipoDocumento);

        INSERT INTO Empleado(idEmpleado,apellidos,idPersona,idTipoEmpleado)
            VALUES(contadorEmpleado+1,_apellidos,contadorPersona+1,_idTipoEmpleado);

        flag_exitoso := 1;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Insertar_Proveedor(
    IN _numeroDocumento varchar(13),
    IN _razonComercial varchar(150),
    IN _direccion varchar(150),
    IN _telefono varchar(10),
    IN _email varchar(100),
    IN _idTipoDocumento integer,
    OUT flag_exitoso integer
) AS $$
DECLARE
    contadorPersona integer := 0;
    contadorProveedor integer := 0;
    contador_rep integer := 0;
BEGIN
    flag_exitoso := 0;

    SELECT count(*) INTO contador_rep FROM Persona WHERE numeroDocumento = _numeroDocumento;

    IF (contador_rep != 0) THEN
        flag_exitoso := 2;
    ELSE
        SELECT idPersona INTO contadorPersona FROM Persona ORDER BY idPersona DESC LIMIT 1;
        SELECT idProveedor INTO contadorProveedor FROM Proveedor ORDER BY idProveedor DESC LIMIT 1;
        contadorPersona := COALESCE(contadorPersona, 0);
        contadorProveedor := COALESCE(contadorProveedor, 0);

        INSERT INTO Persona(idPersona,numeroDocumento,direccion,telefono,email,idTipoDocumento)
            VALUES(contadorPersona+1,_numeroDocumento,_direccion,_telefono,_email,_idTipoDocumento);

        INSERT INTO Proveedor(idProveedor,idPersona,razonComercial)
            VALUES(contadorProveedor+1,contadorPersona+1,_razonComercial);

        flag_exitoso := 1;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Insertar_Repuesto(
    IN _descrip varchar(150),
    IN _stock integer,
    IN _precio numeric(6,2),
    IN _precioPorMayor numeric(6,2),
    OUT flag_exitoso integer
) AS $$
DECLARE
    contadorProducto integer := 0;
    contadorRepuesto integer := 0;
    contador_rep integer := 0;
BEGIN
    flag_exitoso := 0;

    SELECT count(*) INTO contador_rep FROM Producto WHERE descripcion = _descrip;

    IF (contador_rep != 0) THEN
        flag_exitoso := 2;
    ELSE
        SELECT idProducto INTO contadorProducto FROM Producto ORDER BY idProducto DESC LIMIT 1;
        SELECT idRepuesto INTO contadorRepuesto FROM Repuesto ORDER BY idRepuesto DESC LIMIT 1;
        contadorProducto := COALESCE(contadorProducto, 0);
        contadorRepuesto := COALESCE(contadorRepuesto, 0);

        INSERT INTO Producto(idProducto,descripcion,stock,precio,precioPorMayor)
            VALUES(contadorProducto+1, _descrip, _stock, _precio, _precioPorMayor);

        INSERT INTO Repuesto(idRepuesto, idProducto)
            VALUES(contadorRepuesto+1, contadorProducto+1);

        flag_exitoso := 1;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Insertar_Servicio(
    IN _descrip varchar(150),
    IN _precio numeric(6,2),
    IN _idTipoServico integer,
    OUT flag_exitoso integer
) AS $$
DECLARE
    contadorProducto integer := 0;
    contadorServicio integer := 0;
    contador_rep integer := 0;
BEGIN
    flag_exitoso := 0;

    SELECT count(*) INTO contador_rep FROM Producto WHERE descripcion = _descrip;

    IF (contador_rep != 0) THEN
        flag_exitoso := 2;
    ELSE
        SELECT idProducto INTO contadorProducto FROM Producto ORDER BY idProducto DESC LIMIT 1;
        SELECT idServicio INTO contadorServicio FROM Servicio ORDER BY idServicio DESC LIMIT 1;
        contadorProducto := COALESCE(contadorProducto, 0);
        contadorServicio := COALESCE(contadorServicio, 0);

        INSERT INTO Producto(idProducto,descripcion,precio)
            VALUES(contadorProducto+1, _descrip, _precio);

        INSERT INTO Servicio(idServicio, idProducto,idTipoServicio)
            VALUES(contadorServicio+1, contadorProducto+1,_idTipoServico);

        flag_exitoso := 1;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Insertar_TipoDocumento(
    IN descrip varchar(100),
    OUT flag_exitoso integer
) AS $$
DECLARE
    contador integer := 0;
    contador_rep integer := 0;
BEGIN
    flag_exitoso := 0;

    SELECT count(*) INTO contador_rep FROM TipoDocumento WHERE descripcion = descrip;

    IF (contador_rep != 0) THEN
        flag_exitoso := 2;
    ELSE
        SELECT idTipoDocumento INTO contador FROM TipoDocumento ORDER BY idTipoDocumento DESC LIMIT 1;
        contador := COALESCE(contador, 0);
        INSERT INTO TipoDocumento(idTipoDocumento, descripcion) VALUES(contador+1, descrip);
        flag_exitoso := 1;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Insertar_TipoEmpleado(
    IN id varchar(6),
    IN descrip varchar(100),
    OUT flag_exitoso integer
) AS $$
DECLARE
    contador_rep integer := 0;
BEGIN
    flag_exitoso := 0;

    SELECT count(*) INTO contador_rep FROM tipoempleado WHERE descripcion = descrip OR idTipoEmpleado = id;

    IF (contador_rep != 0) THEN
        flag_exitoso := 2;
    ELSE
        INSERT INTO tipoempleado(idTipoEmpleado, descripcion) VALUES(id, descrip);
        flag_exitoso := 1;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Insertar_TipoServicio(
    IN descrip varchar(100),
    OUT flag_exitoso integer
) AS $$
DECLARE
    contador integer := 0;
    contador_rep integer := 0;
BEGIN
    flag_exitoso := 0;

    SELECT count(*) INTO contador_rep FROM tiposervicio WHERE descripcion = descrip;

    IF (contador_rep != 0) THEN
        flag_exitoso := 2;
    ELSE
        SELECT idTipoServicio INTO contador FROM TipoServicio ORDER BY idTipoServicio DESC LIMIT 1;
        contador := COALESCE(contador, 0);
        INSERT INTO tiposervicio(idTipoServicio, descripcion) VALUES(contador+1, descrip);
        flag_exitoso := 1;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Insertar_VentaRepuestos(
    IN _idOperacion integer,
    IN _idCliente integer,
    IN _idEmpleado integer,
    IN _idComprobanteVenta integer,
    IN _numero varchar(15),
    IN _fecha timestamp,
    IN _descripcion varchar(150),
    IN _importe numeric(7,2),
    IN _idTipoComprobanteVenta integer,
    OUT flag_exitoso integer
) AS $$
DECLARE
    contador_rep integer := 0;
    _idPersonaCliente integer;
    _idPersonaEmpleado integer;
BEGIN
    flag_exitoso := 0;

    SELECT count(*) INTO contador_rep FROM ComprobanteVenta WHERE numero = _numero;

    IF (contador_rep != 0) THEN
        flag_exitoso := 2;
    ELSE
        SELECT c.idPersona INTO _idPersonaCliente FROM Cliente c
            INNER JOIN Persona p ON c.idPersona = p.idPersona
            WHERE c.idCliente = _idCliente;

        SELECT e.idPersona INTO _idPersonaEmpleado FROM Empleado e
            INNER JOIN Persona p ON e.idPersona = p.idPersona
            WHERE e.idEmpleado = _idEmpleado;

        INSERT INTO ComprobanteVenta(idComprobanteVenta,numero,fecha,descripcion,importe,idTipoComprobanteVenta)
            VALUES(_idComprobanteVenta,_numero,_fecha,_descripcion,_importe,_idTipoComprobanteVenta);

        INSERT INTO Operacion(idOperacion,idPersonaCliente,idPersonaEmpleado)
            VALUES(_idOperacion,_idPersonaCliente,_idPersonaEmpleado);

        flag_exitoso := 1;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION P_Insertar_VentaRepuestos2(
    IN _cantidad integer,
    IN _precio numeric(7,2),
    IN _subtotal numeric(7,2),
    IN _idOperacion integer,
    IN _idComprobanteVenta integer,
    IN _idRepuesto integer,
    OUT flag_exitoso integer
) AS $$
DECLARE
    contadorDetalleOperacion integer := 0;
    contadorDetalleVenta integer := 0;
    _idProducto integer;
BEGIN
    flag_exitoso := 0;

    SELECT idDetalleOperacion INTO contadorDetalleOperacion FROM DetalleOperacion
        ORDER BY idDetalleOperacion DESC LIMIT 1;

    SELECT idDetalleVenta INTO contadorDetalleVenta FROM DetalleVenta
        ORDER BY idDetalleVenta DESC LIMIT 1;

    contadorDetalleOperacion := COALESCE(contadorDetalleOperacion, 0);
    contadorDetalleVenta := COALESCE(contadorDetalleVenta, 0);

    SELECT r.idProducto INTO _idProducto FROM Repuesto r
        INNER JOIN Producto p ON r.idProducto = p.idProducto
        WHERE r.idRepuesto = _idRepuesto;

    INSERT INTO DetalleOperacion(idDetalleOperacion,cantidad,precio,subTotal,idOperacion,idProducto)
        VALUES(contadorDetalleOperacion+1,_cantidad,_precio,_subtotal,_idOperacion,_idProducto);

    INSERT INTO DetalleVenta(idDetalleVenta,idComprobanteVenta,idDetalleOperacion)
        VALUES(contadorDetalleVenta+1,_idComprobanteVenta,contadorDetalleOperacion+1);

    flag_exitoso := 1;
END;
$$ LANGUAGE plpgsql;
