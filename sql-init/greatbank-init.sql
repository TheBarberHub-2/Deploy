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
('TheBarberHub', '1234', 'TheBarberHub', 'Store', 'Main', '12345678A', 'token_barber_001'),
('juan123', '1234', 'Juan', 'Pérez', 'García', '12345678B', 'token_juan_001');

INSERT INTO cuentas_bancarias (cliente_id, iban, saldo) VALUES
(1, 'ES12 3456 7890 1111 1111 1111', 2500.00),
(1, 'ES98 7654 3210 2222 2222 2222', 4800.50),
(2, 'ES55 1234 5678 3333 3333 3333', 1200.75),
(2, 'ES44 8765 4321 4444 4444 4444', 3050.20);

INSERT INTO tarjetas_credito (cuenta_id, numero_tarjeta, fecha_caducidad, cvc, nombre_completo) VALUES
(1, '4111 1111 1111 1111', '2028-12', '123', 'TheBarberHub Store'),
(1, '5500 0000 0000 0004', '2029-07', '456', 'TheBarberHub Store'),
(2, '4000 1234 1234 1234', '2027-03', '321', 'TheBarberHub Store'),
(2, '5100 5100 5100 5100', '2030-11', '654', 'TheBarberHub Store'),
(3, '4111 2222 3333 4444', '2028-09', '987', 'Juan Pérez García'),
(3, '5500 9999 8888 7777', '2029-01', '741', 'Juan Pérez García'),
(4, '4000 9999 1111 2222', '2027-05', '852', 'Juan Pérez García'),
(4, '5100 1234 1234 1234', '2030-01', '369', 'Juan Pérez García');