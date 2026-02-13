CREATE DATABASE IF NOT EXISTS thebarberhub;

USE thebarberhub;

CREATE TABLE usuarios (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
	email VARCHAR(50) NOT NULL UNIQUE,
	contrasenya VARCHAR(100) NOT NULL,
	nombre VARCHAR(25) NOT NULL,
	rol ENUM('Admin','Peluqueria','Cliente') NOT NULL
);

CREATE TABLE peluquerias (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
	usuario_id BIGINT UNIQUE NOT NULL,
	municipio VARCHAR(15),
	direccion VARCHAR(100) NOT NULL,
	telefono VARCHAR(20) NOT NULL,
	iban VARCHAR(50) NOT NULL,
	FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE peluquerias_horarios (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
	peluqueria_id BIGINT NOT NULL,
	dia_semana TINYINT NOT NULL,
	hora_apertura TIME NOT NULL,
	hora_cierre TIME NOT NULL,
	FOREIGN KEY (peluqueria_id) REFERENCES peluquerias(id) ON DELETE CASCADE
);

CREATE TABLE categorias (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(20) NOT NULL,
	descripcion VARCHAR(100)
);

CREATE TABLE productos (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
	categoria_id BIGINT NOT NULL,
	peluqueria_id BIGINT NOT NULL,
	nombre VARCHAR(20) NOT NULL,
	precio DECIMAL(10,2) NOT NULL,
	duracion INT NOT NULL,
	FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE CASCADE,
	FOREIGN KEY (peluqueria_id) REFERENCES peluquerias(id) ON DELETE CASCADE
);

CREATE TABLE sesion (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
	usuario_id BIGINT NOT NULL,
	token VARCHAR(100) UNIQUE NOT NULL,
	expired_date DATE,
	FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE solicitudes (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
	usuario_id BIGINT NOT NULL,
	tipo ENUM('Peluqueria','Producto') NOT NULL,
	estado ENUM('Pendiente','Aprobada','Rechazada','Confirmada')
	       DEFAULT 'Pendiente' NOT NULL,
	fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

CREATE TABLE solicitudes_peluqueria (
	id BIGINT PRIMARY KEY,
	municipio VARCHAR(15),
	direccion VARCHAR(100) NOT NULL,
	telefono VARCHAR(20) NOT NULL,
	FOREIGN KEY (id) REFERENCES solicitudes(id) ON DELETE CASCADE
);

CREATE TABLE solicitudes_producto (
	id BIGINT PRIMARY KEY,
	categoria_id BIGINT NOT NULL,
	nombre VARCHAR(20) NOT NULL,
	precio DECIMAL(10,2) NOT NULL,
	duracion INT NOT NULL,
	tipo ENUM('Crear','Modificar'),
	FOREIGN KEY (id) REFERENCES solicitudes(id) ON DELETE CASCADE,
	FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

CREATE TABLE reservas (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
	cliente_id BIGINT NOT NULL,
	peluqueria_id BIGINT NOT NULL,
	dia_semana TINYINT NOT NULL,
	fecha_reserva DATE NOT NULL,
	hora_inicio TIME NOT NULL,
	hora_final TIME,
	precio_total DECIMAL(10,2) DEFAULT 0.00 NOT NULL,
	estado ENUM('Pendiente','Completada','Cancelada')
	       DEFAULT 'Pendiente' NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME,
	iban VARCHAR(50) NOT NULL,
	FOREIGN KEY (cliente_id) REFERENCES usuarios(id) ON DELETE CASCADE,
	FOREIGN KEY (peluqueria_id) REFERENCES peluquerias(id) ON DELETE CASCADE
);

CREATE TABLE reservas_productos (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
	reserva_id BIGINT NOT NULL,
	producto_id BIGINT NOT NULL,
	FOREIGN KEY (reserva_id) REFERENCES reservas(id) ON DELETE CASCADE,
	FOREIGN KEY (producto_id) REFERENCES productos(id)
);

INSERT INTO usuarios (email, contrasenya, nombre, rol) VALUES
('admin@thebarberhub.com', '1234', 'Administrador', 'Admin'),
('peluqueria_valencia@gmail.com', '1234', 'Barbería Valencia', 'Peluqueria'),
('peluqueria_madrid@gmail.com', '1234', 'Barbería Madrid', 'Peluqueria'),
('juan.cliente@gmail.com', '1234', 'Juan Pérez', 'Cliente'),
('maria.cliente@gmail.com', '1234', 'María López', 'Cliente'),
('andreualfonso05@gmail.com', '1234', 'Andreu Alfonso', 'Cliente');

INSERT INTO peluquerias (usuario_id, municipio, direccion, telefono, iban) VALUES
(2, 'Valencia', 'Calle Colón 25', '600123456', 'ES55 1234 5678 3333 3333 3333'),
(3, 'Madrid', 'Gran Vía 100', '611987654', 'ES44 8765 4321 4444 4444 4444');

INSERT INTO categorias (nombre, descripcion) VALUES
('Corte de pelo', 'Servicio de corte y peinado'),
('Corte de barba', 'Arreglo y perfilado de barba'),
('Tinte', 'Aplicación de color en el cabello'),
('Afeitado clásico', 'Afeitado con toalla caliente y navaja');

-- Productos de Barbería Valencia
INSERT INTO productos (categoria_id, peluqueria_id, nombre, precio, duracion) VALUES
(1, 1, 'Corte clásico', 12.00, 30),
(1, 1, 'Corte moderno', 15.00, 40),
(2, 1, 'Arreglo barba', 10.00, 20),
(3, 1, 'Tinte completo', 25.00, 60),
(4, 1, 'Afeitado premium', 18.00, 35);

-- Productos de Barbería Madrid
INSERT INTO productos (categoria_id, peluqueria_id, nombre, precio, duracion) VALUES
(1, 2, 'Corte rápido', 10.00, 20),
(1, 2, 'Corte estilizado', 18.00, 45),
(2, 2, 'Perfilado barba', 12.00, 25),
(3, 2, 'Mechas', 30.00, 75),
(4, 2, 'Afeitado clásico', 15.00, 30);

-- Lunes a miércoles: turno partido
INSERT INTO peluquerias_horarios (peluqueria_id, dia_semana, hora_apertura, hora_cierre) VALUES
(1, 1, '10:00:00', '14:00:00'),
(1, 1, '16:00:00', '20:00:00'),
(1, 2, '10:00:00', '14:00:00'),
(1, 2, '16:00:00', '20:00:00'),
(1, 3, '10:00:00', '14:00:00'),
(1, 3, '16:00:00', '20:00:00'),
(1, 4, '10:00:00', '20:00:00'),
(1, 5, '10:00:00', '20:00:00'),
(1, 6, '10:00:00', '14:00:00'),
(2, 1, '10:00:00', '14:00:00'),
(2, 1, '16:00:00', '20:00:00'),
(2, 2, '10:00:00', '14:00:00'),
(2, 2, '16:00:00', '20:00:00'),
(2, 3, '10:00:00', '20:00:00'),
(2, 4, '10:00:00', '20:00:00'),
(2, 5, '10:00:00', '20:00:00'),
(2, 6, '10:00:00', '14:00:00');