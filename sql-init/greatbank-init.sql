DROP DATABASE IF EXISTS db_greatbank;
CREATE DATABASE IF NOT EXISTS db_greatbank;

USE db_greatbank;

CREATE TABLE IF NOT EXISTS cuentas (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero_cuenta VARCHAR(20) NOT NULL UNIQUE,
    tipo_cuenta VARCHAR(20) NOT NULL,
    saldo DOUBLE NOT NULL,
    titular VARCHAR(200) NOT NULL,
    CONSTRAINT chk_tipo_cuenta CHECK (tipo_cuenta IN ('EMPRESA', 'PERSONAL'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: transferencias
-- ============================================
CREATE TABLE IF NOT EXISTS transferencias (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cuenta_origen VARCHAR(20) NOT NULL,
    cuenta_destino VARCHAR(20) NOT NULL,
    monto DOUBLE NOT NULL,
    fecha DATETIME NOT NULL,
    concepto VARCHAR(200),
    CONSTRAINT chk_monto CHECK (monto > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Mock Data - Cuentas EMPRESA
-- ============================================
INSERT INTO cuentas (numero_cuenta, tipo_cuenta, saldo, titular) VALUES
('1111111111', 'EMPRESA', 50000.00, 'Barbería Premium SL'),
('2222222222', 'EMPRESA', 75000.00, 'Salón de Belleza Elegance SA'),
('3333333333', 'EMPRESA', 120000.00, 'Peluquería El Corte Perfecto SL'),
('4444444444', 'EMPRESA', 35000.00, 'Barbershop Vintage & Co'),
('5555555555', 'EMPRESA', 90000.00, 'Centro Estético Deluxe SL');

-- ============================================
-- Mock Data - Cuentas PERSONAL
-- ============================================
INSERT INTO cuentas (numero_cuenta, tipo_cuenta, saldo, titular) VALUES
('6666666666', 'PERSONAL', 5000.00, 'Juan Pérez García'),
('7777777777', 'PERSONAL', 8500.00, 'María López Fernández'),
('8888888888', 'PERSONAL', 12000.00, 'Carlos Rodríguez Martínez'),
('9999999999', 'PERSONAL', 3200.00, 'Ana Sánchez Torres'),
('1010101010', 'PERSONAL', 15000.00, 'Pedro Gómez Ruiz');

-- ============================================
-- Mock Data - Transferencias históricas
-- ============================================
INSERT INTO transferencias (cuenta_origen, cuenta_destino, monto, fecha, concepto) VALUES
('1111111111', '6666666666', 1500.00, '2026-01-01 10:30:00', 'Pago de nómina - Enero'),
('2222222222', '7777777777', 2000.00, '2026-01-02 14:15:00', 'Salario mensual'),
('3333333333', '8888888888', 2500.00, '2026-01-03 09:45:00', 'Pago de servicios profesionales'),
('1111111111', '2222222222', 5000.00, '2026-01-04 11:20:00', 'Transferencia entre empresas'),
('6666666666', '7777777777', 500.00, '2026-01-05 16:30:00', 'Préstamo personal'),
('4444444444', '9999999999', 1200.00, '2026-01-05 17:00:00', 'Pago de comisiones'),
('5555555555', '1010101010', 3000.00, '2026-01-06 10:00:00', 'Bonus trimestral'),
('8888888888', '6666666666', 800.00, '2026-01-06 12:30:00', 'Devolución de préstamo'),
('3333333333', '5555555555', 10000.00, '2026-01-07 08:15:00', 'Inversión conjunta'),
('7777777777', '9999999999', 300.00, '2026-01-07 09:00:00', 'Regalo de cumpleaños');
