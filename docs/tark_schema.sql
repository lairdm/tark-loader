-- MySQL Script generated by MySQL Workbench
-- Mon 21 Mar 2016 14:58:38 GMT
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema tark
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema tark
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tark` ;
USE `tark` ;

-- -----------------------------------------------------
-- Table `tark`.`session`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`session` ;

CREATE TABLE IF NOT EXISTS `tark`.`session` (
  `session_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `client_id` VARCHAR(128) NULL,
  `start_date` DATETIME NULL,
  `status` VARCHAR(45) NULL,
  PRIMARY KEY (`session_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tark`.`genome`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`genome` ;

CREATE TABLE IF NOT EXISTS `tark`.`genome` (
  `genome_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NULL,
  `tax_id` INT(10) UNSIGNED NULL,
  `session_id` INT(10) UNSIGNED NULL,
  PRIMARY KEY (`genome_id`),
  CONSTRAINT `fk_genome_1`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_genome_1_idx` ON `tark`.`genome` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `tark`.`assembly`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`assembly` ;

CREATE TABLE IF NOT EXISTS `tark`.`assembly` (
  `assembly_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `genome_id` INT UNSIGNED NULL,
  `assembly_name` VARCHAR(128) NULL,
  `assembly_version` INT UNSIGNED NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`assembly_id`),
  CONSTRAINT `fk_assembly_1`
    FOREIGN KEY (`genome_id`)
    REFERENCES `tark`.`genome` (`genome_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assembly_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_assembly_1_idx` ON `tark`.`assembly` (`genome_id` ASC);

CREATE INDEX `fk_assembly_2_idx` ON `tark`.`assembly` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `tark`.`gene`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`gene` ;

CREATE TABLE IF NOT EXISTS `tark`.`gene` (
  `gene_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stable_id` VARCHAR(64) NOT NULL,
  `stable_id_version` TINYINT UNSIGNED NOT NULL,
  `assembly_id` INT UNSIGNED NULL,
  `loc_start` INT UNSIGNED NULL,
  `loc_end` INT UNSIGNED NULL,
  `loc_strand` TINYINT UNSIGNED NULL,
  `loc_region` VARCHAR(8) NULL,
  `loc_checksum` BINARY(16) NULL,
  `gene_checksum` BINARY(20) NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`gene_id`),
  CONSTRAINT `fk_gene_1`
    FOREIGN KEY (`assembly_id`)
    REFERENCES `tark`.`assembly` (`assembly_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gene_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_gene_1_idx` ON `tark`.`gene` (`assembly_id` ASC);

CREATE INDEX `stable_id` ON `tark`.`gene` (`stable_id` ASC, `stable_id_version` ASC);

CREATE INDEX `fk_gene_2_idx` ON `tark`.`gene` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `tark`.`sequence`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`sequence` ;

CREATE TABLE IF NOT EXISTS `tark`.`sequence` (
  `seq_checksum` BINARY(16) NOT NULL,
  `sequence` LONGTEXT NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`seq_checksum`),
  CONSTRAINT `fk_sequence_1`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_sequence_1_idx` ON `tark`.`sequence` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `tark`.`transcript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`transcript` ;

CREATE TABLE IF NOT EXISTS `tark`.`transcript` (
  `transcript_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stable_id` VARCHAR(64) NOT NULL,
  `stable_id_version` TINYINT UNSIGNED NOT NULL,
  `assembly_id` INT UNSIGNED NULL,
  `loc_start` INT UNSIGNED NULL,
  `loc_end` INT UNSIGNED NULL,
  `loc_strand` TINYINT NULL,
  `loc_region` VARCHAR(8) NULL,
  `loc_checksum` BINARY(20) NULL,
  `transcript_checksum` BINARY(20) NULL,
  `seq_checksum` BINARY(16) NULL,
  `gene_id` INT UNSIGNED NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`transcript_id`),
  CONSTRAINT `fk_transcript_1`
    FOREIGN KEY (`assembly_id`)
    REFERENCES `tark`.`assembly` (`assembly_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transcript_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transcript_3`
    FOREIGN KEY (`seq_checksum`)
    REFERENCES `tark`.`sequence` (`seq_checksum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transcript_4`
    FOREIGN KEY (`gene_id`)
    REFERENCES `tark`.`gene` (`gene_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'loc_str includes sets of exon start-stop locations: 1000,200' /* comment truncated */ /*0,4000,5000*/;

CREATE INDEX `fk_transcript_2_idx` ON `tark`.`transcript` (`session_id` ASC);

CREATE INDEX `loc_chk` ON `tark`.`transcript` (`transcript_checksum` ASC);

CREATE INDEX `fk_transcript_3_idx` ON `tark`.`transcript` (`seq_checksum` ASC);

CREATE INDEX `gene_group_idx` ON `tark`.`transcript` (`gene_id` ASC);

CREATE INDEX `fk_transcript_1_idx` ON `tark`.`transcript` (`assembly_id` ASC);

CREATE INDEX `stable_id_version` ON `tark`.`transcript` (`stable_id` ASC, `stable_id_version` ASC);


-- -----------------------------------------------------
-- Table `tark`.`exon`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`exon` ;

CREATE TABLE IF NOT EXISTS `tark`.`exon` (
  `exon_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stable_id` VARCHAR(64) NOT NULL,
  `stable_id_version` TINYINT UNSIGNED NOT NULL,
  `assembly_id` INT UNSIGNED NULL,
  `loc_start` INT UNSIGNED NULL,
  `loc_end` INT UNSIGNED NULL,
  `loc_strand` TINYINT NULL,
  `loc_region` VARCHAR(8) NULL,
  `loc_checksum` BINARY(20) NULL,
  `exon_checksum` BINARY(20) NULL,
  `seq_checksum` BINARY(16) NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`exon_id`),
  CONSTRAINT `fk_exon_1`
    FOREIGN KEY (`assembly_id`)
    REFERENCES `tark`.`assembly` (`assembly_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exon_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exon_3`
    FOREIGN KEY (`seq_checksum`)
    REFERENCES `tark`.`sequence` (`seq_checksum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_exon_2_idx` ON `tark`.`exon` (`session_id` ASC);

CREATE INDEX `loc_chk` ON `tark`.`exon` (`exon_checksum` ASC);

CREATE INDEX `fk_exon_3_idx` ON `tark`.`exon` (`seq_checksum` ASC);

CREATE INDEX `fk_exon_1_idx` ON `tark`.`exon` (`assembly_id` ASC);

CREATE INDEX `stable_id_version` ON `tark`.`exon` (`stable_id` ASC, `stable_id_version` ASC);


-- -----------------------------------------------------
-- Table `tark`.`translation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`translation` ;

CREATE TABLE IF NOT EXISTS `tark`.`translation` (
  `translation_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stable_id` VARCHAR(64) NOT NULL,
  `stable_id_version` TINYINT UNSIGNED NOT NULL,
  `assembly_id` INT UNSIGNED NULL,
  `transcript_id` INT UNSIGNED NULL,
  `loc_start` INT UNSIGNED NULL,
  `loc_end` INT UNSIGNED NULL,
  `loc_strand` TINYINT NULL,
  `loc_region` VARCHAR(8) NULL,
  `loc_checksum` BINARY(20) NULL,
  `translation_checksum` BINARY(20) NULL,
  `seq_checksum` BINARY(16) NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`translation_id`),
  CONSTRAINT `fk_translation_1`
    FOREIGN KEY (`assembly_id`)
    REFERENCES `tark`.`assembly` (`assembly_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_translation_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_translation_3`
    FOREIGN KEY (`seq_checksum`)
    REFERENCES `tark`.`sequence` (`seq_checksum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_translation_4`
    FOREIGN KEY (`transcript_id`)
    REFERENCES `tark`.`transcript` (`transcript_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_translation_2_idx` ON `tark`.`translation` (`session_id` ASC);

CREATE INDEX `fk_translation_3_idx` ON `tark`.`translation` (`seq_checksum` ASC);

CREATE INDEX `fk_translation_4_idx` ON `tark`.`translation` (`transcript_id` ASC);

CREATE INDEX `fk_translation_1_idx` ON `tark`.`translation` (`assembly_id` ASC);

CREATE INDEX `stable_id_version` ON `tark`.`translation` (`stable_id` ASC, `stable_id_version` ASC);


-- -----------------------------------------------------
-- Table `tark`.`tagset`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`tagset` ;

CREATE TABLE IF NOT EXISTS `tark`.`tagset` (
  `tagset_id` INT UNSIGNED NOT NULL,
  `tag_shortname` VARCHAR(45) NULL,
  `description` VARCHAR(255) NULL,
  `version` VARCHAR(20) NULL,
  `is_current` TINYINT(1) NULL,
  `session_id` INT UNSIGNED NULL,
  `tagset_checksum` BINARY(16) NULL,
  PRIMARY KEY (`tagset_id`),
  CONSTRAINT `fk_Tagset_1`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `name_version_idx` ON `tark`.`tagset` (`tag_shortname` ASC, `version` ASC);

CREATE INDEX `fk_Tagset_1_idx` ON `tark`.`tagset` (`session_id` ASC);

CREATE INDEX `short_name_idx` ON `tark`.`tagset` (`tag_shortname` ASC);


-- -----------------------------------------------------
-- Table `tark`.`tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`tag` ;

CREATE TABLE IF NOT EXISTS `tark`.`tag` (
  `transcript_id` INT UNSIGNED NOT NULL,
  `tagset_id` INT UNSIGNED NOT NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`transcript_id`, `tagset_id`),
  CONSTRAINT `fk_Tag_1`
    FOREIGN KEY (`tagset_id`)
    REFERENCES `tark`.`tagset` (`tagset_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Tag_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Tag_3`
    FOREIGN KEY (`transcript_id`)
    REFERENCES `tark`.`transcript` (`transcript_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `transcript_id` ON `tark`.`tag` (`transcript_id` ASC);

CREATE INDEX `fk_Tag_2_idx` ON `tark`.`tag` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `tark`.`release`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`release` ;

CREATE TABLE IF NOT EXISTS `tark`.`release` (
  `release_id` INT ZEROFILL UNSIGNED NOT NULL,
  `short_name` VARCHAR(24) NULL,
  `description` VARCHAR(256) NULL,
  `assembly_id` INT UNSIGNED NULL,
  `release_date` DATE NULL,
  `session_id` INT UNSIGNED NULL,
  `release_checksum` BINARY(16) NULL,
  PRIMARY KEY (`release_id`),
  CONSTRAINT `fk_release_1`
    FOREIGN KEY (`assembly_id`)
    REFERENCES `tark`.`assembly` (`assembly_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_release_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `short_name_idx` ON `tark`.`release` (`short_name` ASC);

CREATE INDEX `fk_release_1_idx` ON `tark`.`release` (`assembly_id` ASC);

CREATE INDEX `fk_release_2_idx` ON `tark`.`release` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `tark`.`release_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`release_tag` ;

CREATE TABLE IF NOT EXISTS `tark`.`release_tag` (
  `feature_id` INT UNSIGNED NOT NULL,
  `feature_type` TINYINT UNSIGNED NOT NULL,
  `release_id` INT UNSIGNED NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`feature_id`, `feature_type`),
  CONSTRAINT `fk_release_tag_1`
    FOREIGN KEY (`release_id`)
    REFERENCES `tark`.`release` (`release_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_release_tag_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_release_tag_1_idx` ON `tark`.`release_tag` (`release_id` ASC);

CREATE INDEX `fk_release_tag_2_idx` ON `tark`.`release_tag` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `tark`.`operon`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`operon` ;

CREATE TABLE IF NOT EXISTS `tark`.`operon` (
  `operon_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stable_id` VARCHAR(64) NULL,
  `stable_id_version` TINYINT UNSIGNED NULL,
  `assembly_id` INT UNSIGNED NULL,
  `loc_start` INT UNSIGNED NULL,
  `loc_end` INT UNSIGNED NULL,
  `loc_strand` TINYINT NULL,
  `loc_region` VARCHAR(8) NULL,
  `loc_checksum` BINARY(20) NULL,
  `seq_checksum` BINARY(16) NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`operon_id`),
  CONSTRAINT `fk_operon_1`
    FOREIGN KEY (`assembly_id`)
    REFERENCES `tark`.`assembly` (`assembly_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_operon_2`
    FOREIGN KEY (`seq_checksum`)
    REFERENCES `tark`.`sequence` (`seq_checksum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_operon_3`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `stable_id_version_idx` ON `tark`.`operon` (`stable_id` ASC, `stable_id_version` ASC);

CREATE INDEX `fk_operon_1_idx` ON `tark`.`operon` (`assembly_id` ASC);

CREATE INDEX `fk_operon_2_idx` ON `tark`.`operon` (`seq_checksum` ASC);

CREATE INDEX `fk_operon_3_idx` ON `tark`.`operon` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `tark`.`operon_transcript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`operon_transcript` ;

CREATE TABLE IF NOT EXISTS `tark`.`operon_transcript` (
  `operon_transcript_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stable_id` VARCHAR(64) NULL,
  `stable_id_version` INT UNSIGNED NULL,
  `operon_id` INT UNSIGNED NULL,
  `transcript_id` INT UNSIGNED NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`operon_transcript_id`),
  CONSTRAINT `fk_operon_transcript_1`
    FOREIGN KEY (`operon_id`)
    REFERENCES `tark`.`operon` (`operon_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_operon_transcript_2`
    FOREIGN KEY (`transcript_id`)
    REFERENCES `tark`.`transcript` (`transcript_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_operon_transcript_3`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `stable_id_version_idx` ON `tark`.`operon_transcript` (`stable_id` ASC, `stable_id_version` ASC);

CREATE INDEX `fk_operon_transcript_1_idx` ON `tark`.`operon_transcript` (`operon_id` ASC);

CREATE INDEX `fk_operon_transcript_2_idx` ON `tark`.`operon_transcript` (`transcript_id` ASC);

CREATE INDEX `fk_operon_transcript_3_idx` ON `tark`.`operon_transcript` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `tark`.`gene_names`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`gene_names` ;

CREATE TABLE IF NOT EXISTS `tark`.`gene_names` (
  `gene_names_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(32) NULL,
  `gene_id` INT UNSIGNED NULL,
  `assembly_id` INT UNSIGNED NULL,
  `source` VARCHAR(32) NULL,
  `primary_id` TINYINT(1) NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`gene_names_id`),
  CONSTRAINT `fk_gene_names_1`
    FOREIGN KEY (`gene_id`)
    REFERENCES `tark`.`gene` (`gene_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gene_names_2`
    FOREIGN KEY (`assembly_id`)
    REFERENCES `tark`.`assembly` (`assembly_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gene_names_3`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `name_idx` ON `tark`.`gene_names` (`name` ASC, `assembly_id` ASC);

CREATE INDEX `gene_id_idx` ON `tark`.`gene_names` (`gene_id` ASC);

CREATE INDEX `index4` ON `tark`.`gene_names` (`source` ASC);

CREATE INDEX `fk_gene_names_2_idx` ON `tark`.`gene_names` (`assembly_id` ASC);

CREATE INDEX `fk_gene_names_3_idx` ON `tark`.`gene_names` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `tark`.`exon_transcript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tark`.`exon_transcript` ;

CREATE TABLE IF NOT EXISTS `tark`.`exon_transcript` (
  `exon_transcript_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `transcript_id` INT UNSIGNED NULL,
  `exon_id` INT UNSIGNED NULL,
  `exon_order` SMALLINT UNSIGNED NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`exon_transcript_id`),
  CONSTRAINT `fk_exon_transcript_1`
    FOREIGN KEY (`transcript_id`)
    REFERENCES `tark`.`transcript` (`transcript_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exon_transcript_2`
    FOREIGN KEY (`exon_id`)
    REFERENCES `tark`.`exon` (`exon_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exon_transcript_3`
    FOREIGN KEY (`session_id`)
    REFERENCES `tark`.`session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_exon_transcript_1_idx` ON `tark`.`exon_transcript` (`transcript_id` ASC);

CREATE INDEX `fk_exon_transcript_2_idx` ON `tark`.`exon_transcript` (`exon_id` ASC);

CREATE INDEX `fk_exon_transcript_3_idx` ON `tark`.`exon_transcript` (`session_id` ASC);

CREATE INDEX `transcript_id_idx` ON `tark`.`exon_transcript` (`transcript_id` ASC);

CREATE INDEX `index6` ON `tark`.`exon_transcript` (`exon_id` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
