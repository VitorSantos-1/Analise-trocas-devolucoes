-- ============================================================
-- DDL real do banco MySQL `trocas` (exportado via SHOW CREATE TABLE)
-- Dados ficticios de demonstracao.
-- ============================================================

CREATE DATABASE IF NOT EXISTS trocas CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE trocas;

CREATE TABLE `dim_comprador` (
  `pk_comprador` int NOT NULL,
  `comprador` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`pk_comprador`),
  UNIQUE KEY `uq_comprador_nome` (`comprador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `dim_lojas` (
  `pk_loja` int NOT NULL,
  `loja` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`pk_loja`),
  UNIQUE KEY `uq_lojas_nome` (`loja`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `dim_mercadologico` (
  `pk_mercadologico` int NOT NULL,
  `mercadologico` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `fk_comprador` int DEFAULT NULL,
  PRIMARY KEY (`pk_mercadologico`),
  UNIQUE KEY `uq_mercadologico_nome` (`mercadologico`),
  KEY `fk_comprador` (`fk_comprador`),
  CONSTRAINT `dim_mercadologico_ibfk_1` FOREIGN KEY (`fk_comprador`) REFERENCES `dim_comprador` (`pk_comprador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `dim_produtos` (
  `pk_produto` int NOT NULL,
  `produto` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `fk_mercadologico` int DEFAULT NULL,
  PRIMARY KEY (`pk_produto`),
  KEY `fk_mercadologico` (`fk_mercadologico`),
  CONSTRAINT `dim_produtos_ibfk_1` FOREIGN KEY (`fk_mercadologico`) REFERENCES `dim_mercadologico` (`pk_mercadologico`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `fato_mensal` (
  `pk_meta` int NOT NULL AUTO_INCREMENT,
  `_data` date NOT NULL,
  `id_loja` int NOT NULL,
  `fk_comprador` int NOT NULL,
  `fk_mercadologico` int NOT NULL,
  `meta_faturamento` decimal(12,2) DEFAULT NULL,
  `tendencia_vendas` decimal(12,2) DEFAULT NULL,
  `limite_trocas` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`pk_meta`),
  KEY `id_loja` (`id_loja`),
  KEY `fk_comprador` (`fk_comprador`),
  KEY `fk_mercadologico` (`fk_mercadologico`),
  CONSTRAINT `fato_mensal_ibfk_1` FOREIGN KEY (`id_loja`) REFERENCES `dim_lojas` (`pk_loja`),
  CONSTRAINT `fato_mensal_ibfk_2` FOREIGN KEY (`fk_comprador`) REFERENCES `dim_comprador` (`pk_comprador`),
  CONSTRAINT `fato_mensal_ibfk_3` FOREIGN KEY (`fk_mercadologico`) REFERENCES `dim_mercadologico` (`pk_mercadologico`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `fato_movimentacao` (
  `pk_transacao_hash` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `_data` datetime NOT NULL,
  `fk_produto` int NOT NULL,
  `fk_loja` int NOT NULL,
  `estoque_anterior` decimal(12,2) NOT NULL,
  `quantidade_entrada` decimal(12,2) NOT NULL,
  `quantidade_saida` decimal(12,2) NOT NULL,
  `estoque_atual` decimal(12,2) NOT NULL,
  `custo_unitario` decimal(12,2) NOT NULL,
  `custo_total` decimal(12,2) NOT NULL,
  `motivo` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`pk_transacao_hash`),
  KEY `fk_produto` (`fk_produto`),
  KEY `fk_loja` (`fk_loja`),
  CONSTRAINT `fato_movimentacao_ibfk_1` FOREIGN KEY (`fk_produto`) REFERENCES `dim_produtos` (`pk_produto`),
  CONSTRAINT `fato_movimentacao_ibfk_2` FOREIGN KEY (`fk_loja`) REFERENCES `dim_lojas` (`pk_loja`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
