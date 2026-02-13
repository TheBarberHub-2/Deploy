CREATE DATABASE IF NOT EXISTS banco_barber;

USE banco_barber;

CREATE TABLE clientes (
    id 						BIGINT PRIMARY KEY AUTO_INCREMENT,
    login 					VARCHAR(50) NOT NULL UNIQUE,
    password 				VARCHAR(100) NOT NULL,
    nombre 					VARCHAR(50) NOT NULL,
    apellido1 				VARCHAR(50) NOT NULL,
    apellido2 				VARCHAR(50),
    dni 						VARCHAR(9) NOT NULL UNIQUE,
    api_token 				VARCHAR(255)
);

CREATE TABLE cuentas_bancarias (
    id 						BIGINT PRIMARY KEY AUTO_INCREMENT,
    cliente_id 			BIGINT NOT NULL,
    iban 					VARCHAR(50) NOT NULL UNIQUE,
    saldo 					DECIMAL(38,2) NOT NULL,
	 FOREIGN KEY 			(cliente_id) REFERENCES clientes(id) ON DELETE CASCADE
);

CREATE TABLE tarjetas_credito (
    id 						BIGINT PRIMARY KEY AUTO_INCREMENT,
    cuenta_id 				BIGINT NOT NULL,
    numero_tarjeta 		VARCHAR(30) NOT NULL UNIQUE,
    fecha_caducidad 		VARCHAR(10) NOT NULL,
    cvc 						VARCHAR(3) NOT NULL,
    nombre_completo 		VARCHAR(100) NOT NULL,
    FOREIGN KEY 			(cuenta_id) REFERENCES cuentas_bancarias(id) ON DELETE CASCADE
);

CREATE TABLE movimientos_bancarios (
    id 						BIGINT PRIMARY KEY AUTO_INCREMENT,
	 cuenta_id				BIGINT NOT NULL,
    tipo_movimiento 		ENUM('DEBE', 'HABER') NOT NULL,
    origen_movimiento 	ENUM('TRANSFERENCIA', 'DOMICILIACION', 'TARJETA_BANCARIA') NOT NULL,
    tarjeta_credito_id 	BIGINT,
    fecha 					DATETIME(6) NOT NULL,
    importe 				DECIMAL(38,2) NOT NULL,
    concepto 				VARCHAR(255) NOT NULL,
    FOREIGN KEY 			(tarjeta_credito_id) REFERENCES tarjetas_credito(id),
    FOREIGN KEY			(cuenta_id) REFERENCES cuentas_bancarias(id) ON DELETE CASCADE
);

CREATE TABLE sesion (
	id					BIGINT PRIMARY KEY AUTO_INCREMENT,
	usuario_id		BIGINT NOT NULL,
	token				VARCHAR(100) UNIQUE NOT NULL,
	expired_date	DATE,
	FOREIGN KEY		(usuario_id) REFERENCES clientes(id) ON DELETE CASCADE
);


INSERT INTO clientes (login, password, nombre, apellido1, apellido2, dni, api_token) VALUES
('TheBarberHub', '1234', 'Administrador', 'Administrador', NULL, '11111111A', 'token_barber_001'),
('Pel. Valencia', '1234', 'Barbería', 'Valencia', NULL, '22222222B', 'token_pelu_001'),
('Pel. Madrid', '1234', 'Barbería', 'Madrid', NULL, '33333333C', 'token_pelu_002'),
('juan123', '1234', 'Juan', 'Pérez', NULL, '44444444D', 'token_juan_002'),
('MariaCliente', '1234', 'María', 'López', NULL, '55555555E', 'token_maria_001'),
('Andreu Alfonso', '1234', 'Andreu', 'Alfonso', NULL, '66666666F', 'token_andreu_001');

INSERT INTO cuentas_bancarias (cliente_id, iban, saldo) VALUES
(1, 'ES12 3456 7890 1111 1111 1111', 2500.00),
(2, 'ES55 1234 5678 3333 3333 3333', 1200.75), -- Barbería Valencia
(3, 'ES44 8765 4321 4444 4444 4444', 3050.20), -- Barbería Madrid
(4, 'ES00 0000 0000 0000 0000 0004', 800.00),  -- Juan
(5, 'ES00 0000 0000 0000 0000 0005', 950.00),  -- María
(6, 'ES00 0000 0000 0000 0000 0006', 1100.00); -- Andreu

INSERT INTO tarjetas_credito (cuenta_id, numero_tarjeta, fecha_caducidad, cvc, nombre_completo) VALUES
(1, '4111 1111 1111 0001', '2030-12', '123', 'Administrador'),
(2, '4111 1111 1111 0002', '2030-12', '456', 'Barbería Valencia'),
(3, '4111 1111 1111 0003', '2030-12', '789', 'Barbería Madrid'),
(4, '4111 1111 1111 0004', '2030-12', '159', 'Juan Pérez'),
(5, '4111 1111 1111 0005', '2030-12', '753', 'María López'),
(6, '4111 1111 1111 0006', '2030-12', '951', 'Andreu Alfonso');