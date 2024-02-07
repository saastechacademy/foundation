-- MySQL dump 10.13  Distrib 8.2.0, for macos14.0 (arm64)
--
-- Host: localhost    Database: ootb_ofbiz
-- ------------------------------------------------------
-- Server version	8.2.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `country_code`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country_code` (
  `COUNTRY_CODE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COUNTRY_ABBR` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COUNTRY_NUMBER` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COUNTRY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COUNTRY_CODE`),
  KEY `CNTR_CD_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `CNTR_CD_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `country_tele_code`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country_tele_code` (
  `COUNTRY_CODE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TELE_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COUNTRY_CODE`),
  KEY `CNTRY_TELE_TO_CODE` (`COUNTRY_CODE`),
  KEY `CNTR_TL_CD_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `CNTR_TL_CD_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CNTRY_TELE_TO_CODE` FOREIGN KEY (`COUNTRY_CODE`) REFERENCES `country_code` (`COUNTRY_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `custom_method`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_method` (
  `CUSTOM_METHOD_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CUSTOM_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOM_METHOD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUSTOM_METHOD_ID`),
  KEY `CME_TO_TYPE` (`CUSTOM_METHOD_TYPE_ID`),
  KEY `CSTM_MTHD_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `CSTM_MTHD_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CME_TO_TYPE` FOREIGN KEY (`CUSTOM_METHOD_TYPE_ID`) REFERENCES `custom_method_type` (`CUSTOM_METHOD_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `custom_method_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_method_type` (
  `CUSTOM_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUSTOM_METHOD_TYPE_ID`),
  KEY `CME_TYPE_PARENT` (`PARENT_TYPE_ID`),
  KEY `CSTM_MTD_TP_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `CSTM_MTD_TP_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CME_TYPE_PARENT` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `custom_method_type` (`CUSTOM_METHOD_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `custom_screen`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_screen` (
  `CUSTOM_SCREEN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CUSTOM_SCREEN_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOM_SCREEN_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOM_SCREEN_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUSTOM_SCREEN_ID`),
  KEY `CSCR_TO_TYPE` (`CUSTOM_SCREEN_TYPE_ID`),
  KEY `CSTM_SCRN_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `CSTM_SCRN_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CSCR_TO_TYPE` FOREIGN KEY (`CUSTOM_SCREEN_TYPE_ID`) REFERENCES `custom_screen_type` (`CUSTOM_SCREEN_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `custom_screen_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_screen_type` (
  `CUSTOM_SCREEN_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUSTOM_SCREEN_TYPE_ID`),
  KEY `CSTM_SCN_TP_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `CSTM_SCN_TP_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `custom_time_period`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_time_period` (
  `CUSTOM_TIME_PERIOD_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_PERIOD_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PERIOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PERIOD_NUM` decimal(20,0) DEFAULT NULL,
  `PERIOD_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `IS_CLOSED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `ORGANIZATION_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`CUSTOM_TIME_PERIOD_ID`),
  KEY `ORG_PRD_PARPER` (`PARENT_PERIOD_ID`),
  KEY `ORG_PRD_PERTYP` (`PERIOD_TYPE_ID`),
  KEY `ORG_PRD_PARTY` (`ORGANIZATION_PARTY_ID`),
  KEY `CSTM_TM_PRD_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `CSTM_TM_PRD_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORG_PRD_PARPER` FOREIGN KEY (`PARENT_PERIOD_ID`) REFERENCES `custom_time_period` (`CUSTOM_TIME_PERIOD_ID`),
  CONSTRAINT `ORG_PRD_PARTY` FOREIGN KEY (`ORGANIZATION_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `ORG_PRD_PERTYP` FOREIGN KEY (`PERIOD_TYPE_ID`) REFERENCES `period_type` (`PERIOD_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `allocation_plan_header`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `allocation_plan_header` (
  `PLAN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PLAN_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PLAN_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PLAN_ID`,`PRODUCT_ID`),
  KEY `ALC_PLN_HDR_TYP` (`PLAN_TYPE_ID`),
  KEY `ALC_PLN_HDR_STS` (`STATUS_ID`),
  KEY `ALC_PLN_HDR_CBUL` (`CREATED_BY_USER_LOGIN`),
  KEY `ALC_PLN_HDR_LMUL` (`LAST_MODIFIED_BY_USER_LOGIN`),
  key `ALN_PLN_HDR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ALN_PLN_HDR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ALC_PLN_HDR_CBUL` FOREIGN KEY (`CREATED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `ALC_PLN_HDR_LMUL` FOREIGN KEY (`LAST_MODIFIED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `ALC_PLN_HDR_STS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `ALC_PLN_HDR_TYP` FOREIGN KEY (`PLAN_TYPE_ID`) REFERENCES `allocation_plan_type` (`PLAN_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `allocation_plan_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `allocation_plan_item` (
  `PLAN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PLAN_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PLAN_METHOD_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ALLOCATED_QUANTITY` decimal(18,6) DEFAULT NULL,
  `PRIORITY_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PLAN_ID`,`PLAN_ITEM_SEQ_ID`,`PRODUCT_ID`),
  KEY `ALC_PLN_ITM_HDR` (`PLAN_ID`,`PRODUCT_ID`),
  KEY `ALC_PLN_ITM_ODRHDR` (`ORDER_ID`),
  KEY `ALC_PLN_ITM_ODRITM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `ALC_PLN_ITM_STS` (`STATUS_ID`),
  KEY `ALC_PLN_ITM_ENUM` (`PLAN_METHOD_ENUM_ID`),
  KEY `ALC_PLN_ITM_CBUL` (`CREATED_BY_USER_LOGIN`),
  KEY `ALC_PLN_ITM_LMUL` (`LAST_MODIFIED_BY_USER_LOGIN`),
  key `ALN_PLN_ITM_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ALN_PLN_ITM_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ALC_PLN_ITM_CBUL` FOREIGN KEY (`CREATED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `ALC_PLN_ITM_ENUM` FOREIGN KEY (`PLAN_METHOD_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `ALC_PLN_ITM_HDR` FOREIGN KEY (`PLAN_ID`, `PRODUCT_ID`) REFERENCES `allocation_plan_header` (`PLAN_ID`, `PRODUCT_ID`),
  CONSTRAINT `ALC_PLN_ITM_LMUL` FOREIGN KEY (`LAST_MODIFIED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `ALC_PLN_ITM_ODRHDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ALC_PLN_ITM_ODRITM` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `ALC_PLN_ITM_STS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `allocation_plan_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `allocation_plan_type` (
  `PLAN_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PLAN_TYPE_ID`),
  key `ALN_PLN_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ALN_PLN_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cart_abandoned_line`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_abandoned_line` (
  `VISIT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CART_ABANDONED_LINE_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PROD_CATALOG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `RESERV_START` datetime(3) DEFAULT NULL,
  `RESERV_LENGTH` decimal(18,6) DEFAULT NULL,
  `RESERV_PERSONS` decimal(18,6) DEFAULT NULL,
  `UNIT_PRICE` decimal(18,2) DEFAULT NULL,
  `RESERV2ND_P_P_PERC` decimal(18,6) DEFAULT NULL,
  `RESERV_NTH_P_P_PERC` decimal(18,6) DEFAULT NULL,
  `CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TOTAL_WITH_ADJUSTMENTS` decimal(18,2) DEFAULT NULL,
  `WAS_RESERVED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`VISIT_ID`,`CART_ABANDONED_LINE_SEQ_ID`),
  KEY `CART_ABLN_PRD` (`PRODUCT_ID`),
  KEY `CART_ABLN_PRDCAT` (`PROD_CATALOG_ID`),
  key `CRT_ABD_LN_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CRT_ABD_LN_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CART_ABLN_PRD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `CART_ABLN_PRDCAT` FOREIGN KEY (`PROD_CATALOG_ID`) REFERENCES `prod_catalog` (`PROD_CATALOG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event_order`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event_order` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COMMUNICATION_EVENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`COMMUNICATION_EVENT_ID`),
  KEY `COMEV_ORDER_ORDER` (`ORDER_ID`),
  KEY `COMEV_ORDER_CMEV` (`COMMUNICATION_EVENT_ID`),
  key `CMN_EVT_ORR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CMN_EVT_ORR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `COMEV_ORDER_CMEV` FOREIGN KEY (`COMMUNICATION_EVENT_ID`) REFERENCES `communication_event` (`COMMUNICATION_EVENT_ID`),
  CONSTRAINT `COMEV_ORDER_ORDER` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event_return`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event_return` (
  `RETURN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COMMUNICATION_EVENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ID`,`COMMUNICATION_EVENT_ID`),
  KEY `COMEV_ORDER_RETURN` (`RETURN_ID`),
  KEY `COMEV_RETURN_CMEV` (`COMMUNICATION_EVENT_ID`),
  key `CMN_EVT_RTN_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CMN_EVT_RTN_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `COMEV_ORDER_RETURN` FOREIGN KEY (`RETURN_ID`) REFERENCES `return_header` (`RETURN_ID`),
  CONSTRAINT `COMEV_RETURN_CMEV` FOREIGN KEY (`COMMUNICATION_EVENT_ID`) REFERENCES `communication_event` (`COMMUNICATION_EVENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cust_request`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_request` (
  `CUST_REQUEST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CUST_REQUEST_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUST_REQUEST_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIORITY` decimal(20,0) DEFAULT NULL,
  `CUST_REQUEST_DATE` datetime(3) DEFAULT NULL,
  `RESPONSE_REQUIRED_DATE` datetime(3) DEFAULT NULL,
  `CUST_REQUEST_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MAXIMUM_AMOUNT_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SALES_CHANNEL_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FULFILL_CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OPEN_DATE_TIME` datetime(3) DEFAULT NULL,
  `CLOSED_DATE_TIME` datetime(3) DEFAULT NULL,
  `INTERNAL_COMMENT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REASON` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CUST_ESTIMATED_MILLI_SECONDS` double DEFAULT NULL,
  `CUST_SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `PARENT_CUST_REQUEST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BILLED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_ID`),
  KEY `CUST_REQ_TYPE` (`CUST_REQUEST_TYPE_ID`),
  KEY `CUST_REQ_CAT` (`CUST_REQUEST_CATEGORY_ID`),
  KEY `CUST_REQ_STATUS` (`STATUS_ID`),
  KEY `CUST_REQ_FRMPTY` (`FROM_PARTY_ID`),
  KEY `CUST_REQ_AUOM` (`MAXIMUM_AMOUNT_UOM_ID`),
  KEY `CUST_REQ_PRDS` (`PRODUCT_STORE_ID`),
  KEY `CUST_REQ_CHANNEL` (`SALES_CHANNEL_ENUM_ID`),
  KEY `CUST_REQ_FULCM` (`FULFILL_CONTACT_MECH_ID`),
  KEY `CUST_REQ_CUOM` (`CURRENCY_UOM_ID`),
  KEY `CUST_REQ_PARENT` (`PARENT_CUST_REQUEST_ID`),
  key `orr_CST_RQT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_CST_RQT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CUST_REQ_AUOM` FOREIGN KEY (`MAXIMUM_AMOUNT_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `CUST_REQ_CAT` FOREIGN KEY (`CUST_REQUEST_CATEGORY_ID`) REFERENCES `cust_request_category` (`CUST_REQUEST_CATEGORY_ID`),
  CONSTRAINT `CUST_REQ_CHANNEL` FOREIGN KEY (`SALES_CHANNEL_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `CUST_REQ_CUOM` FOREIGN KEY (`CURRENCY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `CUST_REQ_FRMPTY` FOREIGN KEY (`FROM_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `CUST_REQ_FULCM` FOREIGN KEY (`FULFILL_CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `CUST_REQ_PARENT` FOREIGN KEY (`PARENT_CUST_REQUEST_ID`) REFERENCES `cust_request` (`CUST_REQUEST_ID`),
  CONSTRAINT `CUST_REQ_PRDS` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `CUST_REQ_STATUS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `CUST_REQ_TYPE` FOREIGN KEY (`CUST_REQUEST_TYPE_ID`) REFERENCES `cust_request_type` (`CUST_REQUEST_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cust_request_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_request_attribute` (
  `CUST_REQUEST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_ID`,`ATTR_NAME`),
  KEY `CUST_REQ_ATTR` (`CUST_REQUEST_ID`),
  key `CST_RQT_ATT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CST_RQT_ATT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CUST_REQ_ATTR` FOREIGN KEY (`CUST_REQUEST_ID`) REFERENCES `cust_request` (`CUST_REQUEST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cust_request_category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_request_category` (
  `CUST_REQUEST_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CUST_REQUEST_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_CATEGORY_ID`),
  KEY `CUST_RQCT_TYPE` (`CUST_REQUEST_TYPE_ID`),
  key `CST_RQT_CTR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CST_RQT_CTR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CUST_RQCT_TYPE` FOREIGN KEY (`CUST_REQUEST_TYPE_ID`) REFERENCES `cust_request_type` (`CUST_REQUEST_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cust_request_comm_event`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_request_comm_event` (
  `CUST_REQUEST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COMMUNICATION_EVENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_ID`,`COMMUNICATION_EVENT_ID`),
  KEY `CUSTREQ_CEV_CRQ` (`CUST_REQUEST_ID`),
  KEY `CUSTREQ_CEV_CEV` (`COMMUNICATION_EVENT_ID`),
  key `RQT_CMM_EVT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RQT_CMM_EVT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CUSTREQ_CEV_CEV` FOREIGN KEY (`COMMUNICATION_EVENT_ID`) REFERENCES `communication_event` (`COMMUNICATION_EVENT_ID`),
  CONSTRAINT `CUSTREQ_CEV_CRQ` FOREIGN KEY (`CUST_REQUEST_ID`) REFERENCES `cust_request` (`CUST_REQUEST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cust_request_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_request_item` (
  `CUST_REQUEST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CUST_REQUEST_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CUST_REQUEST_RESOLUTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIORITY` decimal(20,0) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `REQUIRED_BY_DATE` datetime(3) DEFAULT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `SELECTED_AMOUNT` decimal(18,6) DEFAULT NULL,
  `MAXIMUM_AMOUNT` decimal(18,2) DEFAULT NULL,
  `RESERV_START` datetime(3) DEFAULT NULL,
  `RESERV_LENGTH` decimal(18,6) DEFAULT NULL,
  `RESERV_PERSONS` decimal(18,6) DEFAULT NULL,
  `CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STORY` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_ID`,`CUST_REQUEST_ITEM_SEQ_ID`),
  KEY `CUST_REQITM_CREQ` (`CUST_REQUEST_ID`),
  KEY `CUST_REQITM_STTS` (`STATUS_ID`),
  KEY `CUST_REQITM_RES` (`CUST_REQUEST_RESOLUTION_ID`),
  KEY `CUST_REQITM_PRD` (`PRODUCT_ID`),
  key `CST_RQT_ITM_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CST_RQT_ITM_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CUST_REQITM_CREQ` FOREIGN KEY (`CUST_REQUEST_ID`) REFERENCES `cust_request` (`CUST_REQUEST_ID`),
  CONSTRAINT `CUST_REQITM_PRD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `CUST_REQITM_RES` FOREIGN KEY (`CUST_REQUEST_RESOLUTION_ID`) REFERENCES `cust_request_resolution` (`CUST_REQUEST_RESOLUTION_ID`),
  CONSTRAINT `CUST_REQITM_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cust_request_item_note`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_request_item_note` (
  `CUST_REQUEST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CUST_REQUEST_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `NOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_ID`,`CUST_REQUEST_ITEM_SEQ_ID`,`NOTE_ID`),
  KEY `CUST_REQ_ITNT` (`CUST_REQUEST_ID`,`CUST_REQUEST_ITEM_SEQ_ID`),
  KEY `CUST_REQ_NOTE` (`NOTE_ID`),
  key `RQT_ITM_NT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RQT_ITM_NT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CUST_REQ_ITNT` FOREIGN KEY (`CUST_REQUEST_ID`, `CUST_REQUEST_ITEM_SEQ_ID`) REFERENCES `cust_request_item` (`CUST_REQUEST_ID`, `CUST_REQUEST_ITEM_SEQ_ID`),
  CONSTRAINT `CUST_REQ_NOTE` FOREIGN KEY (`NOTE_ID`) REFERENCES `note_data` (`NOTE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cust_request_item_work_effort`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_request_item_work_effort` (
  `CUST_REQUEST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CUST_REQUEST_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_ID`,`CUST_REQUEST_ITEM_SEQ_ID`,`WORK_EFFORT_ID`),
  KEY `WORK_REQFL_CSTRQ` (`CUST_REQUEST_ID`,`CUST_REQUEST_ITEM_SEQ_ID`),
  KEY `CUST_REQ_WEFF` (`WORK_EFFORT_ID`),
  key `ITM_WRK_EFT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ITM_WRK_EFT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CUST_REQ_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`),
  CONSTRAINT `WORK_REQFL_CSTRQ` FOREIGN KEY (`CUST_REQUEST_ID`, `CUST_REQUEST_ITEM_SEQ_ID`) REFERENCES `cust_request_item` (`CUST_REQUEST_ID`, `CUST_REQUEST_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cust_request_note`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_request_note` (
  `CUST_REQUEST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `NOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_ID`,`NOTE_ID`),
  KEY `CRQ_CR` (`CUST_REQUEST_ID`),
  KEY `CRQ_NOTE` (`NOTE_ID`),
  key `CST_RQT_NT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CST_RQT_NT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CRQ_CR` FOREIGN KEY (`CUST_REQUEST_ID`) REFERENCES `cust_request` (`CUST_REQUEST_ID`),
  CONSTRAINT `CRQ_NOTE` FOREIGN KEY (`NOTE_ID`) REFERENCES `note_data` (`NOTE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cust_request_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_request_party` (
  `CUST_REQUEST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`FROM_DATE`),
  KEY `CREQ_RL_CRQST` (`CUST_REQUEST_ID`),
  KEY `CREQ_RL_PARTY` (`PARTY_ID`),
  KEY `CREQ_RL_PROLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  key `CST_RQT_PRT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CST_RQT_PRT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CREQ_RL_CRQST` FOREIGN KEY (`CUST_REQUEST_ID`) REFERENCES `cust_request` (`CUST_REQUEST_ID`),
  CONSTRAINT `CREQ_RL_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `CREQ_RL_PROLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cust_request_resolution`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_request_resolution` (
  `CUST_REQUEST_RESOLUTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CUST_REQUEST_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_RESOLUTION_ID`),
  KEY `CUST_RQRS_TYPE` (`CUST_REQUEST_TYPE_ID`),
  key `CST_RQT_RSN_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CST_RQT_RSN_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CUST_RQRS_TYPE` FOREIGN KEY (`CUST_REQUEST_TYPE_ID`) REFERENCES `cust_request_type` (`CUST_REQUEST_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cust_request_status`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_request_status` (
  `CUST_REQUEST_STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUST_REQUEST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUST_REQUEST_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_DATE` datetime(3) DEFAULT NULL,
  `CHANGE_BY_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_STATUS_ID`),
  KEY `CUST_REQST_STTS` (`STATUS_ID`),
  KEY `CUST_REQ_STRQ` (`CUST_REQUEST_ID`),
  KEY `CUST_RQSTTS_USRLGN` (`CHANGE_BY_USER_LOGIN_ID`),
  key `CST_RQT_STS_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CST_RQT_STS_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CUST_REQ_STRQ` FOREIGN KEY (`CUST_REQUEST_ID`) REFERENCES `cust_request` (`CUST_REQUEST_ID`),
  CONSTRAINT `CUST_REQST_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `CUST_RQSTTS_USRLGN` FOREIGN KEY (`CHANGE_BY_USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cust_request_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_request_type` (
  `CUST_REQUEST_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_TYPE_ID`),
  KEY `CUST_REQ_TYPE_PAR` (`PARENT_TYPE_ID`),
  KEY `CUST_PTY_PARTY` (`PARTY_ID`),
  key `CST_RQT_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CST_RQT_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CUST_PTY_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `CUST_REQ_TYPE_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `cust_request_type` (`CUST_REQUEST_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cust_request_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_request_type_attr` (
  `CUST_REQUEST_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_TYPE_ID`,`ATTR_NAME`),
  KEY `CUST_REQ_TYPE_ATTR` (`CUST_REQUEST_TYPE_ID`),
  key `RQT_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RQT_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CUST_REQ_TYPE_ATTR` FOREIGN KEY (`CUST_REQUEST_TYPE_ID`) REFERENCES `cust_request_type` (`CUST_REQUEST_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cust_request_work_effort`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cust_request_work_effort` (
  `CUST_REQUEST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_ID`,`WORK_EFFORT_ID`),
  KEY `CSTREQ_WF_CREQ` (`CUST_REQUEST_ID`),
  KEY `CSTREQ_WF_WEFF` (`WORK_EFFORT_ID`),
  key `RQT_WRK_EFT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RQT_WRK_EFT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CSTREQ_WF_CREQ` FOREIGN KEY (`CUST_REQUEST_ID`) REFERENCES `cust_request` (`CUST_REQUEST_ID`),
  CONSTRAINT `CSTREQ_WF_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `desired_feature`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `desired_feature` (
  `DESIRED_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `REQUIREMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OPTIONAL_IND` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DESIRED_FEATURE_ID`,`REQUIREMENT_ID`),
  KEY `DES_FEAT_REQ` (`REQUIREMENT_ID`),
  KEY `DES_FEAT_PFEAT` (`PRODUCT_FEATURE_ID`),
  key `orr_DSD_FTR_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_DSD_FTR_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `DES_FEAT_PFEAT` FOREIGN KEY (`PRODUCT_FEATURE_ID`) REFERENCES `product_feature` (`PRODUCT_FEATURE_ID`),
  CONSTRAINT `DES_FEAT_REQ` FOREIGN KEY (`REQUIREMENT_ID`) REFERENCES `requirement` (`REQUIREMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_adjustment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_adjustment` (
  `ORDER_ADJUSTMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ADJUSTMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AMOUNT` decimal(18,3) DEFAULT NULL,
  `RECURRING_AMOUNT` decimal(18,3) DEFAULT NULL,
  `AMOUNT_ALREADY_INCLUDED` decimal(18,3) DEFAULT NULL,
  `PRODUCT_PROMO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PROMO_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PROMO_ACTION_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CORRESPONDING_PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TAX_AUTHORITY_RATE_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SOURCE_REFERENCE_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SOURCE_PERCENTAGE` decimal(18,6) DEFAULT NULL,
  `CUSTOMER_REFERENCE_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIMARY_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SECONDARY_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXEMPT_AMOUNT` decimal(18,2) DEFAULT NULL,
  `TAX_AUTH_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TAX_AUTH_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OVERRIDE_GL_ACCOUNT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INCLUDE_IN_TAX` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INCLUDE_IN_SHIPPING` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_MANUAL` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGINAL_ADJUSTMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ADJUSTMENT_ID`),
  KEY `ORDER_ADJ_TYPE` (`ORDER_ADJUSTMENT_TYPE_ID`),
  KEY `ORDER_ADJ_OHEAD` (`ORDER_ID`),
  KEY `ORDER_ADJ_USERL` (`CREATED_BY_USER_LOGIN`),
  KEY `ORDER_ADJ_PROMO` (`PRODUCT_PROMO_ID`),
  KEY `ORDER_ADJ_PRGEO` (`PRIMARY_GEO_ID`),
  KEY `ORDER_ADJ_SCGEO` (`SECONDARY_GEO_ID`),
  KEY `ORDER_ADJ_TXA` (`TAX_AUTH_GEO_ID`,`TAX_AUTH_PARTY_ID`),
  KEY `ORDER_ADJ_OGLA` (`OVERRIDE_GL_ACCOUNT_ID`),
  KEY `ORDER_ADJ_TARP` (`TAX_AUTHORITY_RATE_SEQ_ID`),
  key `orr_ORR_ADJT_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_ORR_ADJT_TXS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ADJ_OHEAD` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_ADJ_PRGEO` FOREIGN KEY (`PRIMARY_GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `ORDER_ADJ_PROMO` FOREIGN KEY (`PRODUCT_PROMO_ID`) REFERENCES `product_promo` (`PRODUCT_PROMO_ID`),
  CONSTRAINT `ORDER_ADJ_SCGEO` FOREIGN KEY (`SECONDARY_GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `ORDER_ADJ_TYPE` FOREIGN KEY (`ORDER_ADJUSTMENT_TYPE_ID`) REFERENCES `order_adjustment_type` (`ORDER_ADJUSTMENT_TYPE_ID`),
  CONSTRAINT `ORDER_ADJ_USERL` FOREIGN KEY (`CREATED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_adjustment_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_adjustment_attribute` (
  `ORDER_ADJUSTMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ADJUSTMENT_ID`,`ATTR_NAME`),
  KEY `ORDER_ADJ_ATTR` (`ORDER_ADJUSTMENT_ID`),
  key `ORR_ADT_ATT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_ADT_ATT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ADJ_ATTR` FOREIGN KEY (`ORDER_ADJUSTMENT_ID`) REFERENCES `order_adjustment` (`ORDER_ADJUSTMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_adjustment_billing`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_adjustment_billing` (
  `ORDER_ADJUSTMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AMOUNT` decimal(18,2) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ADJUSTMENT_ID`,`INVOICE_ID`,`INVOICE_ITEM_SEQ_ID`),
  KEY `ORDER_ADJBLNG_OA` (`ORDER_ADJUSTMENT_ID`),
  KEY `ORDER_ADJBLNG_IITM` (`INVOICE_ID`,`INVOICE_ITEM_SEQ_ID`),
  key `ORR_ADT_BLG_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_ADT_BLG_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ADJBLNG_OA` FOREIGN KEY (`ORDER_ADJUSTMENT_ID`) REFERENCES `order_adjustment` (`ORDER_ADJUSTMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_adjustment_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_adjustment_type` (
  `ORDER_ADJUSTMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ADJUSTMENT_TYPE_ID`),
  KEY `ORDER_ADJ_TYPPAR` (`PARENT_TYPE_ID`),
  key `ORR_ADT_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_ADT_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ADJ_TYPPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `order_adjustment_type` (`ORDER_ADJUSTMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_adjustment_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_adjustment_type_attr` (
  `ORDER_ADJUSTMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ADJUSTMENT_TYPE_ID`,`ATTR_NAME`),
  KEY `ORDER_ADJ_TYPATTR` (`ORDER_ADJUSTMENT_TYPE_ID`),
  key `ADT_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ADT_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ADJ_TYPATTR` FOREIGN KEY (`ORDER_ADJUSTMENT_TYPE_ID`) REFERENCES `order_adjustment_type` (`ORDER_ADJUSTMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_attribute` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ATTR_NAME`),
  KEY `ORDER_ATTR_HDR` (`ORDER_ID`),
  key `orr_ORR_ATT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_ORR_ATT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ATTR_HDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_contact_mech` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_PURPOSE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`CONTACT_MECH_PURPOSE_TYPE_ID`,`CONTACT_MECH_ID`),
  KEY `ORDER_CMECH_HDR` (`ORDER_ID`),
  KEY `ORDER_CMECH_CM` (`CONTACT_MECH_ID`),
  KEY `ORDER_CMECH_CMPT` (`CONTACT_MECH_PURPOSE_TYPE_ID`),
  key `ORR_CNT_MCH_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_CNT_MCH_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_CMECH_CM` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `ORDER_CMECH_CMPT` FOREIGN KEY (`CONTACT_MECH_PURPOSE_TYPE_ID`) REFERENCES `contact_mech_purpose_type` (`CONTACT_MECH_PURPOSE_TYPE_ID`),
  CONSTRAINT `ORDER_CMECH_HDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_content_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_content_type` (
  `ORDER_CONTENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_CONTENT_TYPE_ID`),
  KEY `ORDCT_TYP_PARENT` (`PARENT_TYPE_ID`),
  key `ORR_CNT_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_CNT_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDCT_TYP_PARENT` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `order_content_type` (`ORDER_CONTENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_delivery_schedule`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_delivery_schedule` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ESTIMATED_READY_DATE` datetime(3) DEFAULT NULL,
  `CARTONS` decimal(20,0) DEFAULT NULL,
  `SKIDS_PALLETS` decimal(20,0) DEFAULT NULL,
  `UNITS_PIECES` decimal(18,6) DEFAULT NULL,
  `TOTAL_CUBIC_SIZE` decimal(18,6) DEFAULT NULL,
  `TOTAL_CUBIC_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TOTAL_WEIGHT` decimal(18,6) DEFAULT NULL,
  `TOTAL_WEIGHT_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `ORDER_DELSCH_OHDR` (`ORDER_ID`),
  KEY `ORDER_DELSCH_TCUOM` (`TOTAL_CUBIC_UOM_ID`),
  KEY `ORDER_DELSCH_TWUOM` (`TOTAL_WEIGHT_UOM_ID`),
  KEY `ORDER_DELSCH_STTS` (`STATUS_ID`),
  key `ORR_DLR_SCL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_DLR_SCL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_DELSCH_OHDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_DELSCH_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `ORDER_DELSCH_TCUOM` FOREIGN KEY (`TOTAL_CUBIC_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `ORDER_DELSCH_TWUOM` FOREIGN KEY (`TOTAL_WEIGHT_UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_denylist`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_denylist` (
  `DENYLIST_STRING` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_DENYLIST_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DENYLIST_STRING`,`ORDER_DENYLIST_TYPE_ID`),
  KEY `ORDER_DNY_TYPE` (`ORDER_DENYLIST_TYPE_ID`),
  key `orr_ORR_DNT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_ORR_DNT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_DNY_TYPE` FOREIGN KEY (`ORDER_DENYLIST_TYPE_ID`) REFERENCES `order_denylist_type` (`ORDER_DENYLIST_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_denylist_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_denylist_type` (
  `ORDER_DENYLIST_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_DENYLIST_TYPE_ID`),
  key `ORR_DNT_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_DNT_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_header`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_header` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXTERNAL_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SALES_CHANNEL_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_DATE` datetime(3) DEFAULT NULL,
  `PRIORITY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENTRY_DATE` datetime(3) DEFAULT NULL,
  `PICK_SHEET_PRINTED_DATE` datetime(3) DEFAULT NULL,
  `VISIT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_BY` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIRST_ATTEMPT_ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CURRENCY_UOM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SYNC_STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BILLING_ACCOUNT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WEB_SITE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TERMINAL_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRANSACTION_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTO_ORDER_SHOPPING_LIST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NEEDS_INVENTORY_ISSUANCE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_RUSH_ORDER` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INTERNAL_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REMAINING_SUB_TOTAL` decimal(18,2) DEFAULT NULL,
  `GRAND_TOTAL` decimal(18,2) DEFAULT NULL,
  `IS_VIEWED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVOICE_PER_SHIPMENT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`),
  KEY `ORDER_HDR_TYPE` (`ORDER_TYPE_ID`),
  KEY `ORDER_HDR_SCENUM` (`SALES_CHANNEL_ENUM_ID`),
  KEY `ORDER_HDR_OFAC` (`ORIGIN_FACILITY_ID`),
  KEY `ORDER_HDR_BACCT` (`BILLING_ACCOUNT_ID`),
  KEY `ORDER_HDR_PDSTR` (`PRODUCT_STORE_ID`),
  KEY `ORDER_HDR_AOSHLST` (`AUTO_ORDER_SHOPPING_LIST_ID`),
  KEY `ORDER_HDR_CBUL` (`CREATED_BY`),
  KEY `ORDER_HDR_STTS` (`STATUS_ID`),
  KEY `ORDER_HDR_SYST` (`SYNC_STATUS_ID`),
  KEY `ORDER_HDR_CUOM` (`CURRENCY_UOM`),
  KEY `ORDER_HDR_WS` (`WEB_SITE_ID`),
  key `orr_ORR_HDR_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_ORR_HDR_TXCS` (`CREATED_TX_STAMP`),
  KEY `ORDEREXT_ID_IDX` (`EXTERNAL_ID`),
  CONSTRAINT `ORDER_HDR_AOSHLST` FOREIGN KEY (`AUTO_ORDER_SHOPPING_LIST_ID`) REFERENCES `shopping_list` (`SHOPPING_LIST_ID`),
  CONSTRAINT `ORDER_HDR_CBUL` FOREIGN KEY (`CREATED_BY`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `ORDER_HDR_CUOM` FOREIGN KEY (`CURRENCY_UOM`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `ORDER_HDR_OFAC` FOREIGN KEY (`ORIGIN_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `ORDER_HDR_PDSTR` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `ORDER_HDR_SCENUM` FOREIGN KEY (`SALES_CHANNEL_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `ORDER_HDR_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `ORDER_HDR_SYST` FOREIGN KEY (`SYNC_STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `ORDER_HDR_TYPE` FOREIGN KEY (`ORDER_TYPE_ID`) REFERENCES `order_type` (`ORDER_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_header_note`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_header_note` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `NOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INTERNAL_NOTE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`NOTE_ID`),
  KEY `ORDER_HDRNT_HDR` (`ORDER_ID`),
  KEY `ORDER_HDRNT_NOTE` (`NOTE_ID`),
  key `ORR_HDR_NT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_HDR_NT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_HDRNT_HDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_HDRNT_NOTE` FOREIGN KEY (`NOTE_ID`) REFERENCES `note_data` (`NOTE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_header_work_effort`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_header_work_effort` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`WORK_EFFORT_ID`),
  KEY `ORDERHDWE_OH` (`ORDER_ID`),
  KEY `ORDERHDWE_WEFF` (`WORK_EFFORT_ID`),
  key `HDR_WRK_EFT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `HDR_WRK_EFT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDERHDWE_OH` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDERHDWE_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `EXTERNAL_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_ITEM_GROUP_PRIMARY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BUDGET_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BUDGET_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUPPLIER_PRODUCT_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PROD_CATALOG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_PROMO` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUOTE_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHOPPING_LIST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHOPPING_LIST_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUBSCRIPTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `CANCEL_QUANTITY` decimal(18,6) DEFAULT NULL,
  `SELECTED_AMOUNT` decimal(18,6) DEFAULT NULL,
  `UNIT_PRICE` decimal(18,3) DEFAULT NULL,
  `UNIT_LIST_PRICE` decimal(18,3) DEFAULT NULL,
  `UNIT_AVERAGE_COST` decimal(18,2) DEFAULT NULL,
  `UNIT_RECURRING_PRICE` decimal(18,2) DEFAULT NULL,
  `IS_MODIFIED_PRICE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECURRING_FREQ_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ITEM_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CORRESPONDING_PO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SYNC_STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ESTIMATED_SHIP_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_DELIVERY_DATE` datetime(3) DEFAULT NULL,
  `AUTO_CANCEL_DATE` datetime(3) DEFAULT NULL,
  `DONT_CANCEL_SET_DATE` datetime(3) DEFAULT NULL,
  `DONT_CANCEL_SET_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIP_BEFORE_DATE` datetime(3) DEFAULT NULL,
  `SHIP_AFTER_DATE` datetime(3) DEFAULT NULL,
  `RESERVE_AFTER_DATE` datetime(3) DEFAULT NULL,
  `CANCEL_BACK_ORDER_DATE` datetime(3) DEFAULT NULL,
  `OVERRIDE_GL_ACCOUNT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SALES_OPPORTUNITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGE_BY_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `ORDER_ITEM_HDR` (`ORDER_ID`),
  KEY `ORDER_ITEM_ORTYP` (`ORDER_ITEM_TYPE_ID`),
  KEY `ORDER_ITEM_ITGRP` (`ORDER_ID`,`ORDER_ITEM_GROUP_SEQ_ID`),
  KEY `ORDER_ITEM_PRODUCT` (`PRODUCT_ID`),
  KEY `ORDER_ITEM_FMINV` (`FROM_INVENTORY_ITEM_ID`),
  KEY `ORDER_ITEM_RFUOM` (`RECURRING_FREQ_UOM_ID`),
  KEY `ORDER_ITEM_STTS` (`STATUS_ID`),
  KEY `ORDER_ITEM_SYST` (`SYNC_STATUS_ID`),
  KEY `ORDER_ITEM_DCUL` (`DONT_CANCEL_SET_USER_LOGIN`),
  KEY `ORDER_ITEM_QUIT` (`QUOTE_ID`,`QUOTE_ITEM_SEQ_ID`),
  KEY `ORDER_ITEM_OGLA` (`OVERRIDE_GL_ACCOUNT_ID`),
  KEY `ORDER_ITEM_SLSOPP` (`SALES_OPPORTUNITY_ID`),
  KEY `ORDER_ITEM_USRLGN` (`CHANGE_BY_USER_LOGIN_ID`),
  key `orr_ORR_ITM_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_ORR_ITM_TXCS` (`CREATED_TX_STAMP`),
  KEY `ORDITMEXT_ID_IDX` (`EXTERNAL_ID`),
  CONSTRAINT `ORDER_ITEM_DCUL` FOREIGN KEY (`DONT_CANCEL_SET_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `ORDER_ITEM_FMINV` FOREIGN KEY (`FROM_INVENTORY_ITEM_ID`) REFERENCES `inventory_item` (`INVENTORY_ITEM_ID`),
  CONSTRAINT `ORDER_ITEM_HDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_ITEM_ITGRP` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_GROUP_SEQ_ID`) REFERENCES `order_item_group` (`ORDER_ID`, `ORDER_ITEM_GROUP_SEQ_ID`),
  CONSTRAINT `ORDER_ITEM_ORTYP` FOREIGN KEY (`ORDER_ITEM_TYPE_ID`) REFERENCES `order_item_type` (`ORDER_ITEM_TYPE_ID`),
  CONSTRAINT `ORDER_ITEM_PRODUCT` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `ORDER_ITEM_QUIT` FOREIGN KEY (`QUOTE_ID`, `QUOTE_ITEM_SEQ_ID`) REFERENCES `quote_item` (`QUOTE_ID`, `QUOTE_ITEM_SEQ_ID`),
  CONSTRAINT `ORDER_ITEM_RFUOM` FOREIGN KEY (`RECURRING_FREQ_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `ORDER_ITEM_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `ORDER_ITEM_SYST` FOREIGN KEY (`SYNC_STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `ORDER_ITEM_USRLGN` FOREIGN KEY (`CHANGE_BY_USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_assoc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_assoc` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TO_ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TO_ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TO_SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_ASSOC_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`,`SHIP_GROUP_SEQ_ID`,`TO_ORDER_ID`,`TO_ORDER_ITEM_SEQ_ID`,`TO_SHIP_GROUP_SEQ_ID`,`ORDER_ITEM_ASSOC_TYPE_ID`),
  KEY `ORDER_ITASS_TYPE` (`ORDER_ITEM_ASSOC_TYPE_ID`),
  KEY `ORDER_ITASS_FRHD` (`ORDER_ID`),
  KEY `ORDER_ITASS_TOHD` (`TO_ORDER_ID`),
  key `ORR_ITM_ASC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_ITM_ASC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ITASS_FRHD` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_ITASS_TOHD` FOREIGN KEY (`TO_ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_ITASS_TYPE` FOREIGN KEY (`ORDER_ITEM_ASSOC_TYPE_ID`) REFERENCES `order_item_assoc_type` (`ORDER_ITEM_ASSOC_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_assoc_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_assoc_type` (
  `ORDER_ITEM_ASSOC_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ITEM_ASSOC_TYPE_ID`),
  KEY `ORDER_ITAS_TYPPAR` (`PARENT_TYPE_ID`),
  key `ITM_ASC_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ITM_ASC_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ITAS_TYPPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `order_item_assoc_type` (`ORDER_ITEM_ASSOC_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_attribute` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`,`ATTR_NAME`),
  KEY `ORDER_ITEM_ATTR` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  key `ORR_ITM_ATT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_ITM_ATT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ITEM_ATTR` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_billing`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_billing` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ITEM_ISSUANCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_RECEIPT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `AMOUNT` decimal(18,2) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`,`INVOICE_ID`,`INVOICE_ITEM_SEQ_ID`),
  KEY `ORDER_ITBLNG_OHDR` (`ORDER_ID`),
  KEY `ORDER_ITBLNG_OITM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `ORDER_ITBLNG_IITM` (`INVOICE_ID`,`INVOICE_ITEM_SEQ_ID`),
  KEY `ORDER_ITBL_SHIPRCP` (`SHIPMENT_RECEIPT_ID`),
  KEY `ORDER_ITBLNG_IISS` (`ITEM_ISSUANCE_ID`),
  key `ORR_ITM_BLG_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_ITM_BLG_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ITBL_SHIPRCP` FOREIGN KEY (`SHIPMENT_RECEIPT_ID`) REFERENCES `shipment_receipt` (`RECEIPT_ID`),
  CONSTRAINT `ORDER_ITBLNG_IISS` FOREIGN KEY (`ITEM_ISSUANCE_ID`) REFERENCES `item_issuance` (`ITEM_ISSUANCE_ID`),
  CONSTRAINT `ORDER_ITBLNG_OHDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_ITBLNG_OITM` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_change`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_change` (
  `ORDER_ITEM_CHANGE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGE_TYPE_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGE_DATETIME` datetime(3) DEFAULT NULL,
  `CHANGE_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `CANCEL_QUANTITY` decimal(18,6) DEFAULT NULL,
  `UNIT_PRICE` decimal(18,2) DEFAULT NULL,
  `ITEM_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REASON_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGE_COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ITEM_CHANGE_ID`),
  KEY `ORDER_ITCH_OITM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `ORDER_ITCH_TYPE` (`CHANGE_TYPE_ENUM_ID`),
  KEY `ORDER_ITCH_REAS` (`REASON_ENUM_ID`),
  KEY `ORDER_ITCH_USER` (`CHANGE_USER_LOGIN`),
  key `ORR_ITM_CHG_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_ITM_CHG_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ITCH_OITM` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `ORDER_ITCH_REAS` FOREIGN KEY (`REASON_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `ORDER_ITCH_TYPE` FOREIGN KEY (`CHANGE_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `ORDER_ITCH_USER` FOREIGN KEY (`CHANGE_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_contact_mech` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_PURPOSE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`,`CONTACT_MECH_PURPOSE_TYPE_ID`),
  KEY `ORDER_ITCM_OITM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `ORDER_ITCM_CMECH` (`CONTACT_MECH_ID`),
  KEY `ORDER_ITCM_CMPT` (`CONTACT_MECH_PURPOSE_TYPE_ID`),
  key `ITM_CNT_MCH_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ITM_CNT_MCH_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ITCM_CMECH` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `ORDER_ITCM_CMPT` FOREIGN KEY (`CONTACT_MECH_PURPOSE_TYPE_ID`) REFERENCES `contact_mech_purpose_type` (`CONTACT_MECH_PURPOSE_TYPE_ID`),
  CONSTRAINT `ORDER_ITCM_OITM` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_group` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GROUP_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_GROUP_SEQ_ID`),
  KEY `ORDERITMGRP_HDR` (`ORDER_ID`),
  KEY `ORDERITMGRP_PGRP` (`ORDER_ID`,`PARENT_GROUP_SEQ_ID`),
  key `ORR_ITM_GRP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_ITM_GRP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDERITMGRP_HDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDERITMGRP_PGRP` FOREIGN KEY (`ORDER_ID`, `PARENT_GROUP_SEQ_ID`) REFERENCES `order_item_group` (`ORDER_ID`, `ORDER_ITEM_GROUP_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_group_order`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_group_order` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GROUP_ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`,`GROUP_ORDER_ID`),
  KEY `OIGO_ORDER_ITEM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `OIGO_GROUP_ORDER` (`GROUP_ORDER_ID`),
  key `ITM_GRP_ORR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ITM_GRP_ORR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `OIGO_GROUP_ORDER` FOREIGN KEY (`GROUP_ORDER_ID`) REFERENCES `product_group_order` (`GROUP_ORDER_ID`),
  CONSTRAINT `OIGO_ORDER_ITEM` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_price_info`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_price_info` (
  `ORDER_ITEM_PRICE_INFO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PRICE_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PRICE_ACTION_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MODIFY_AMOUNT` decimal(18,3) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RATE_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ITEM_PRICE_INFO_ID`),
  KEY `ORDER_OIPI_OITM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `ORDER_OIPI_PRAI` (`PRODUCT_PRICE_RULE_ID`,`PRODUCT_PRICE_ACTION_SEQ_ID`),
  key `ITM_PRC_INF_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ITM_PRC_INF_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_OIPI_OITM` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `ORDER_OIPI_PRAI` FOREIGN KEY (`PRODUCT_PRICE_RULE_ID`, `PRODUCT_PRICE_ACTION_SEQ_ID`) REFERENCES `product_price_action` (`PRODUCT_PRICE_RULE_ID`, `PRODUCT_PRICE_ACTION_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_role` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `ORDER_ITRL_OHDR` (`ORDER_ID`),
  KEY `ORDER_ITRL_OITM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `ORDER_ITRL_PARTY` (`PARTY_ID`),
  KEY `ORDER_ITRL_PTRLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  key `ORR_ITM_RL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_ITM_RL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ITRL_OHDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_ITRL_OITM` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `ORDER_ITRL_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `ORDER_ITRL_PTRLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_ship_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_ship_group` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUPPLIER_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUPPLIER_AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VENDOR_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TELECOM_CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRACKING_NUMBER` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPPING_INSTRUCTIONS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MAY_SPLIT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GIFT_MESSAGE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_GIFT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIP_AFTER_DATE` datetime(3) DEFAULT NULL,
  `SHIP_BY_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_SHIP_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_DELIVERY_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`SHIP_GROUP_SEQ_ID`),
  KEY `ORDER_ITSG_ORDH` (`ORDER_ID`),
  KEY `ORDER_ITSG_SPRTY` (`SUPPLIER_PARTY_ID`),
  KEY `ORDER_ITSG_SAGR` (`SUPPLIER_AGREEMENT_ID`),
  KEY `ORDER_ITSG_VPRTY` (`VENDOR_PARTY_ID`),
  KEY `ORDER_ITSG_CSHM` (`SHIPMENT_METHOD_TYPE_ID`,`CARRIER_PARTY_ID`,`CARRIER_ROLE_TYPE_ID`),
  KEY `ORDER_ITSG_CPRTY` (`CARRIER_PARTY_ID`),
  KEY `ORDER_ITSG_CPRLE` (`CARRIER_PARTY_ID`,`CARRIER_ROLE_TYPE_ID`),
  KEY `ORDER_ITSG_FAC` (`FACILITY_ID`),
  KEY `ORDER_ITSG_SHMTP` (`SHIPMENT_METHOD_TYPE_ID`),
  KEY `ORDER_ITSG_CNTM` (`CONTACT_MECH_ID`),
  KEY `ORDER_ITSG_PADR` (`CONTACT_MECH_ID`),
  KEY `ORDER_ITSG_TCNT` (`TELECOM_CONTACT_MECH_ID`),
  KEY `ORDER_ITSG_TCNB` (`TELECOM_CONTACT_MECH_ID`),
  key `ITM_SHP_GRP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ITM_SHP_GRP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ITSG_CNTM` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `ORDER_ITSG_CPRLE` FOREIGN KEY (`CARRIER_PARTY_ID`, `CARRIER_ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `ORDER_ITSG_CPRTY` FOREIGN KEY (`CARRIER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `ORDER_ITSG_CSHM` FOREIGN KEY (`SHIPMENT_METHOD_TYPE_ID`, `CARRIER_PARTY_ID`, `CARRIER_ROLE_TYPE_ID`) REFERENCES `carrier_shipment_method` (`SHIPMENT_METHOD_TYPE_ID`, `PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `ORDER_ITSG_FAC` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `ORDER_ITSG_ORDH` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_ITSG_PADR` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `postal_address` (`CONTACT_MECH_ID`),
  CONSTRAINT `ORDER_ITSG_SAGR` FOREIGN KEY (`SUPPLIER_AGREEMENT_ID`) REFERENCES `agreement` (`AGREEMENT_ID`),
  CONSTRAINT `ORDER_ITSG_SHMTP` FOREIGN KEY (`SHIPMENT_METHOD_TYPE_ID`) REFERENCES `shipment_method_type` (`SHIPMENT_METHOD_TYPE_ID`),
  CONSTRAINT `ORDER_ITSG_SPRTY` FOREIGN KEY (`SUPPLIER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `ORDER_ITSG_TCNB` FOREIGN KEY (`TELECOM_CONTACT_MECH_ID`) REFERENCES `telecom_number` (`CONTACT_MECH_ID`),
  CONSTRAINT `ORDER_ITSG_TCNT` FOREIGN KEY (`TELECOM_CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `ORDER_ITSG_VPRTY` FOREIGN KEY (`VENDOR_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_ship_group_assoc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_ship_group_assoc` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `CANCEL_QUANTITY` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`,`SHIP_GROUP_SEQ_ID`),
  KEY `ORDER_ISGA_ORDH` (`ORDER_ID`),
  KEY `ORDER_ISGA_ORDI` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `ORDER_ISGA_OISG` (`ORDER_ID`,`SHIP_GROUP_SEQ_ID`),
  key `SHP_GRP_ASC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHP_GRP_ASC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ISGA_OISG` FOREIGN KEY (`ORDER_ID`, `SHIP_GROUP_SEQ_ID`) REFERENCES `order_item_ship_group` (`ORDER_ID`, `SHIP_GROUP_SEQ_ID`),
  CONSTRAINT `ORDER_ISGA_ORDH` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_ISGA_ORDI` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_ship_grp_inv_res`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_ship_grp_inv_res` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RESERVE_ORDER_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `QUANTITY_NOT_AVAILABLE` decimal(18,6) DEFAULT NULL,
  `RESERVED_DATETIME` datetime(3) DEFAULT NULL,
  `CREATED_DATETIME` datetime(3) DEFAULT NULL,
  `PROMISED_DATETIME` datetime(3) DEFAULT NULL,
  `CURRENT_PROMISED_DATE` datetime(3) DEFAULT NULL,
  `PRIORITY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_ID` decimal(20,0) DEFAULT NULL,
  `PICK_START_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`SHIP_GROUP_SEQ_ID`,`ORDER_ITEM_SEQ_ID`,`INVENTORY_ITEM_ID`),
  KEY `ORDER_ITIR_OITM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `ORDER_ITIR_INVITM` (`INVENTORY_ITEM_ID`),
  key `GRP_INV_RS_TP` (`LAST_UPDATED_TX_STAMP`),
  key `GRP_INV_RS_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ITIR_INVITM` FOREIGN KEY (`INVENTORY_ITEM_ID`) REFERENCES `inventory_item` (`INVENTORY_ITEM_ID`),
  CONSTRAINT `ORDER_ITIR_OITM` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_type` (
  `ORDER_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ITEM_TYPE_ID`),
  KEY `ORDER_ITEM_TYPPAR` (`PARENT_TYPE_ID`),
  key `ORR_ITM_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_ITM_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ITEM_TYPPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `order_item_type` (`ORDER_ITEM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_type_attr` (
  `ORDER_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ITEM_TYPE_ID`,`ATTR_NAME`),
  KEY `ORDER_ITEM_TYPATR` (`ORDER_ITEM_TYPE_ID`),
  key `ITM_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ITM_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ITEM_TYPATR` FOREIGN KEY (`ORDER_ITEM_TYPE_ID`) REFERENCES `order_item_type` (`ORDER_ITEM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_notification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_notification` (
  `ORDER_NOTIFICATION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_TYPE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NOTIFICATION_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_NOTIFICATION_ID`),
  KEY `ORD_NOTIFY_ORDHDR` (`ORDER_ID`),
  KEY `ORD_NOTIFY_ENUM` (`EMAIL_TYPE`),
  key `orr_ORR_NTN_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_ORR_NTN_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORD_NOTIFY_ENUM` FOREIGN KEY (`EMAIL_TYPE`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `ORD_NOTIFY_ORDHDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_payment_preference`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_payment_preference` (
  `ORDER_PAYMENT_PREFERENCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PRICE_PURPOSE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PAYMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PAYMENT_METHOD_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIN_ACCOUNT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SECURITY_CODE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRACK2` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRESENT_FLAG` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SWIPED_FLAG` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OVERFLOW_FLAG` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MAX_AMOUNT` decimal(18,2) DEFAULT NULL,
  `PROCESS_ATTEMPT` decimal(20,0) DEFAULT NULL,
  `BILLING_POSTAL_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MANUAL_AUTH_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MANUAL_REF_NUM` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NEEDS_NSF_RETRY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_PAYMENT_PREFERENCE_ID`),
  KEY `ORDER_PMPRF_OHDR` (`ORDER_ID`),
  KEY `ORDER_PMPRF_PPRP` (`PRODUCT_PRICE_PURPOSE_ID`),
  KEY `ORDER_PMPRF_PMTP` (`PAYMENT_METHOD_TYPE_ID`),
  KEY `ORDER_PMPRF_PMETH` (`PAYMENT_METHOD_ID`),
  KEY `ORDER_PMPRF_FINACT` (`FIN_ACCOUNT_ID`),
  KEY `ORDER_PMPRF_STTS` (`STATUS_ID`),
  KEY `ORDER_PMPRF_USRL` (`CREATED_BY_USER_LOGIN`),
  key `ORR_PMT_PRC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_PMT_PRC_TS` (`CREATED_TX_STAMP`),
  KEY `NSF_RETRY_CHECK` (`NEEDS_NSF_RETRY`),
  CONSTRAINT `ORDER_PMPRF_OHDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_PMPRF_PMTP` FOREIGN KEY (`PAYMENT_METHOD_TYPE_ID`) REFERENCES `payment_method_type` (`PAYMENT_METHOD_TYPE_ID`),
  CONSTRAINT `ORDER_PMPRF_PPRP` FOREIGN KEY (`PRODUCT_PRICE_PURPOSE_ID`) REFERENCES `product_price_purpose` (`PRODUCT_PRICE_PURPOSE_ID`),
  CONSTRAINT `ORDER_PMPRF_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `ORDER_PMPRF_USRL` FOREIGN KEY (`CREATED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_product_promo_code`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_product_promo_code` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_CODE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`PRODUCT_PROMO_CODE_ID`),
  KEY `ORDER_PPCD_ORD` (`ORDER_ID`),
  KEY `ORDER_PPCD_PPC` (`PRODUCT_PROMO_CODE_ID`),
  key `PRT_PRM_CD_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRM_CD_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_PPCD_ORD` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_PPCD_PPC` FOREIGN KEY (`PRODUCT_PROMO_CODE_ID`) REFERENCES `product_promo_code` (`PRODUCT_PROMO_CODE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_requirement_commitment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_requirement_commitment` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `REQUIREMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`,`REQUIREMENT_ID`),
  KEY `ORDREQ_CMT_ORD` (`ORDER_ID`),
  KEY `ORDREQ_CMT_OITM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `ORDREQ_CMT_REQ` (`REQUIREMENT_ID`),
  key `ORR_RQT_CMT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_RQT_CMT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDREQ_CMT_OITM` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `ORDREQ_CMT_ORD` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDREQ_CMT_REQ` FOREIGN KEY (`REQUIREMENT_ID`) REFERENCES `requirement` (`REQUIREMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_role` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `ORDER_ROLE_OHDR` (`ORDER_ID`),
  KEY `ORDER_ROLE_PARTY` (`PARTY_ID`),
  KEY `ORDER_ROLE_PROLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  key `orr_ORR_RL_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_ORR_RL_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_ROLE_OHDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_ROLE_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `ORDER_ROLE_PROLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_shipment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_shipment` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`,`SHIP_GROUP_SEQ_ID`,`SHIPMENT_ID`,`SHIPMENT_ITEM_SEQ_ID`),
  KEY `ORDER_SHPMT_OHDR` (`ORDER_ID`),
  KEY `ORDER_SHPMT_SHPMT` (`SHIPMENT_ID`),
  key `orr_ORR_SHT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_ORR_SHT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_SHPMT_OHDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_SHPMT_SHPMT` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_status`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_status` (
  `ORDER_STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_PAYMENT_PREFERENCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_DATETIME` datetime(3) DEFAULT NULL,
  `STATUS_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGE_REASON` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_STATUS_ID`),
  KEY `ORDER_STTS_STTS` (`STATUS_ID`),
  KEY `ORDER_STTS_OHDR` (`ORDER_ID`),
  KEY `ORDER_STTS_USER` (`STATUS_USER_LOGIN`),
  key `orr_ORR_STS_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_ORR_STS_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_STTS_OHDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_STTS_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `ORDER_STTS_USER` FOREIGN KEY (`STATUS_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_summary_entry`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_summary_entry` (
  `ENTRY_DATE` date NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TOTAL_QUANTITY` decimal(18,6) DEFAULT NULL,
  `GROSS_SALES` decimal(18,2) DEFAULT NULL,
  `PRODUCT_COST` decimal(18,2) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENTRY_DATE`,`PRODUCT_ID`,`FACILITY_ID`),
  KEY `ORDER_SMENT_PROD` (`PRODUCT_ID`),
  KEY `ORDER_SMENT_FAC` (`FACILITY_ID`),
  key `ORR_SMR_ENR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_SMR_ENR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_SMENT_FAC` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `ORDER_SMENT_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_term`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_term` (
  `TERM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TERM_VALUE` decimal(18,2) DEFAULT NULL,
  `TERM_DAYS` decimal(20,0) DEFAULT NULL,
  `TEXT_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`TERM_TYPE_ID`,`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `ORDER_TERM_UOM` (`UOM_ID`),
  KEY `ORDER_TERM_OHDR` (`ORDER_ID`),
  KEY `ORDER_TERM_TTYPE` (`TERM_TYPE_ID`),
  key `orr_ORR_TRM_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_ORR_TRM_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_TERM_OHDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `ORDER_TERM_TTYPE` FOREIGN KEY (`TERM_TYPE_ID`) REFERENCES `term_type` (`TERM_TYPE_ID`),
  CONSTRAINT `ORDER_TERM_UOM` FOREIGN KEY (`UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_term_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_term_attribute` (
  `TERM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`TERM_TYPE_ID`,`ORDER_ID`,`ORDER_ITEM_SEQ_ID`,`ATTR_NAME`),
  KEY `ORDER_TATTR_OTRM` (`TERM_TYPE_ID`,`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  key `ORR_TRM_ATT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_TRM_ATT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_TATTR_OTRM` FOREIGN KEY (`TERM_TYPE_ID`, `ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_term` (`TERM_TYPE_ID`, `ORDER_ID`, `ORDER_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_type` (
  `ORDER_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_TYPE_ID`),
  KEY `ORDER_TYPE_PARENT` (`PARENT_TYPE_ID`),
  key `orr_ORR_TP_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_ORR_TP_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_TYPE_PARENT` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `order_type` (`ORDER_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_type_attr` (
  `ORDER_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_TYPE_ID`,`ATTR_NAME`),
  KEY `ORDER_TPAT_ORTYP` (`ORDER_TYPE_ID`),
  key `ORR_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ORDER_TPAT_ORTYP` FOREIGN KEY (`ORDER_TYPE_ID`) REFERENCES `order_type` (`ORDER_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_order_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_order_item` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENGAGEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENGAGEMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`,`ENGAGEMENT_ID`,`ENGAGEMENT_ITEM_SEQ_ID`),
  KEY `PROD_OITEM_OHDR` (`ORDER_ID`),
  KEY `PROD_OITEM_OITEM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `PROD_OITEM_PROD` (`PRODUCT_ID`),
  KEY `PROD_OITEM_ENOHDR` (`ENGAGEMENT_ID`),
  KEY `PROD_OITEM_ENOITM` (`ENGAGEMENT_ID`,`ENGAGEMENT_ITEM_SEQ_ID`),
  key `PRT_ORR_ITM_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_ORR_ITM_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_OITEM_ENOHDR` FOREIGN KEY (`ENGAGEMENT_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `PROD_OITEM_ENOITM` FOREIGN KEY (`ENGAGEMENT_ID`, `ENGAGEMENT_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `PROD_OITEM_OHDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `PROD_OITEM_OITEM` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `PROD_OITEM_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quote`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote` (
  `QUOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUOTE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ISSUE_DATE` datetime(3) DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SALES_CHANNEL_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VALID_FROM_DATE` datetime(3) DEFAULT NULL,
  `VALID_THRU_DATE` datetime(3) DEFAULT NULL,
  `QUOTE_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`QUOTE_ID`),
  KEY `QUOTE_QTTYP` (`QUOTE_TYPE_ID`),
  KEY `QUOTE_PRTY` (`PARTY_ID`),
  KEY `QUOTE_STATUS` (`STATUS_ID`),
  KEY `QUOTE_CUOM` (`CURRENCY_UOM_ID`),
  KEY `QUOTE_PRDS` (`PRODUCT_STORE_ID`),
  KEY `QUOTE_CHANNEL` (`SALES_CHANNEL_ENUM_ID`),
  key `ordr_QT_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `ordr_QT_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `QUOTE_CHANNEL` FOREIGN KEY (`SALES_CHANNEL_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `QUOTE_CUOM` FOREIGN KEY (`CURRENCY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `QUOTE_PRDS` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `QUOTE_PRTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `QUOTE_QTTYP` FOREIGN KEY (`QUOTE_TYPE_ID`) REFERENCES `quote_type` (`QUOTE_TYPE_ID`),
  CONSTRAINT `QUOTE_STATUS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quote_adjustment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote_adjustment` (
  `QUOTE_ADJUSTMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUOTE_ADJUSTMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUOTE_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AMOUNT` decimal(18,2) DEFAULT NULL,
  `PRODUCT_PROMO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PROMO_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PROMO_ACTION_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CORRESPONDING_PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SOURCE_REFERENCE_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SOURCE_PERCENTAGE` decimal(18,6) DEFAULT NULL,
  `CUSTOMER_REFERENCE_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIMARY_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SECONDARY_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXEMPT_AMOUNT` decimal(18,2) DEFAULT NULL,
  `TAX_AUTH_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TAX_AUTH_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OVERRIDE_GL_ACCOUNT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INCLUDE_IN_TAX` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INCLUDE_IN_SHIPPING` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`QUOTE_ADJUSTMENT_ID`),
  KEY `QUOTE_ADJ_TYPE` (`QUOTE_ADJUSTMENT_TYPE_ID`),
  KEY `QUOTE_ADJ_OHEAD` (`QUOTE_ID`),
  KEY `QUOTE_ADJ_USERL` (`CREATED_BY_USER_LOGIN`),
  KEY `QUOTE_ADJ_PROMO` (`PRODUCT_PROMO_ID`),
  KEY `QUOTE_ADJ_PRGEO` (`PRIMARY_GEO_ID`),
  KEY `QUOTE_ADJ_SCGEO` (`SECONDARY_GEO_ID`),
  KEY `QUOTE_ADJ_TXA` (`TAX_AUTH_GEO_ID`,`TAX_AUTH_PARTY_ID`),
  KEY `QUOTE_ADJ_OGLA` (`OVERRIDE_GL_ACCOUNT_ID`),
  key `orr_QT_ADJST_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_QT_ADJST_TXS` (`CREATED_TX_STAMP`),
  CONSTRAINT `QUOTE_ADJ_OHEAD` FOREIGN KEY (`QUOTE_ID`) REFERENCES `quote` (`QUOTE_ID`),
  CONSTRAINT `QUOTE_ADJ_PRGEO` FOREIGN KEY (`PRIMARY_GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `QUOTE_ADJ_PROMO` FOREIGN KEY (`PRODUCT_PROMO_ID`) REFERENCES `product_promo` (`PRODUCT_PROMO_ID`),
  CONSTRAINT `QUOTE_ADJ_SCGEO` FOREIGN KEY (`SECONDARY_GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `QUOTE_ADJ_TYPE` FOREIGN KEY (`QUOTE_ADJUSTMENT_TYPE_ID`) REFERENCES `order_adjustment_type` (`ORDER_ADJUSTMENT_TYPE_ID`),
  CONSTRAINT `QUOTE_ADJ_USERL` FOREIGN KEY (`CREATED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quote_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote_attribute` (
  `QUOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`QUOTE_ID`,`ATTR_NAME`),
  KEY `QUOTE_ATTR` (`QUOTE_ID`),
  key `orr_QT_ATTT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_QT_ATTT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `QUOTE_ATTR` FOREIGN KEY (`QUOTE_ID`) REFERENCES `quote` (`QUOTE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quote_coefficient`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote_coefficient` (
  `QUOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COEFF_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COEFF_VALUE` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`QUOTE_ID`,`COEFF_NAME`),
  KEY `QUOTE_COEFF` (`QUOTE_ID`),
  key `orr_QT_CFFT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_QT_CFFT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `QUOTE_COEFF` FOREIGN KEY (`QUOTE_ID`) REFERENCES `quote` (`QUOTE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quote_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote_item` (
  `QUOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUOTE_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DELIVERABLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SKILL_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUST_REQUEST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUST_REQUEST_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `SELECTED_AMOUNT` decimal(18,6) DEFAULT NULL,
  `QUOTE_UNIT_PRICE` decimal(18,2) DEFAULT NULL,
  `RESERV_START` datetime(3) DEFAULT NULL,
  `RESERV_LENGTH` decimal(18,6) DEFAULT NULL,
  `RESERV_PERSONS` decimal(18,6) DEFAULT NULL,
  `CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ESTIMATED_DELIVERY_DATE` datetime(3) DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_PROMO` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LEAD_TIME_DAYS` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`QUOTE_ID`,`QUOTE_ITEM_SEQ_ID`),
  KEY `QUOTE_ITM_QTE` (`QUOTE_ID`),
  KEY `QUOTE_ITM_PROD` (`PRODUCT_ID`),
  KEY `QUOTE_ITM_PFEAT` (`PRODUCT_FEATURE_ID`),
  KEY `QUOTE_ITM_DELT` (`DELIVERABLE_TYPE_ID`),
  KEY `QUOTE_ITM_SKLT` (`SKILL_TYPE_ID`),
  KEY `QUOTE_ITM_UOM` (`UOM_ID`),
  KEY `QUOTE_ITM_WKEFF` (`WORK_EFFORT_ID`),
  KEY `QUOTE_ITM_CSRQ` (`CUST_REQUEST_ID`),
  KEY `QUOTE_ITM_CSRITM` (`CUST_REQUEST_ID`,`CUST_REQUEST_ITEM_SEQ_ID`),
  key `orr_QT_ITM_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_QT_ITM_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `QUOTE_ITM_CSRITM` FOREIGN KEY (`CUST_REQUEST_ID`, `CUST_REQUEST_ITEM_SEQ_ID`) REFERENCES `cust_request_item` (`CUST_REQUEST_ID`, `CUST_REQUEST_ITEM_SEQ_ID`),
  CONSTRAINT `QUOTE_ITM_CSRQ` FOREIGN KEY (`CUST_REQUEST_ID`) REFERENCES `cust_request` (`CUST_REQUEST_ID`),
  CONSTRAINT `QUOTE_ITM_DELT` FOREIGN KEY (`DELIVERABLE_TYPE_ID`) REFERENCES `deliverable_type` (`DELIVERABLE_TYPE_ID`),
  CONSTRAINT `QUOTE_ITM_PFEAT` FOREIGN KEY (`PRODUCT_FEATURE_ID`) REFERENCES `product_feature` (`PRODUCT_FEATURE_ID`),
  CONSTRAINT `QUOTE_ITM_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `QUOTE_ITM_QTE` FOREIGN KEY (`QUOTE_ID`) REFERENCES `quote` (`QUOTE_ID`),
  CONSTRAINT `QUOTE_ITM_UOM` FOREIGN KEY (`UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `QUOTE_ITM_WKEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quote_note`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote_note` (
  `QUOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `NOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`QUOTE_ID`,`NOTE_ID`),
  KEY `QUOTE_NT_QTE` (`QUOTE_ID`),
  KEY `QUOTE_NT_NOTE` (`NOTE_ID`),
  key `orr_QT_NT_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_QT_NT_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `QUOTE_NT_NOTE` FOREIGN KEY (`NOTE_ID`) REFERENCES `note_data` (`NOTE_ID`),
  CONSTRAINT `QUOTE_NT_QTE` FOREIGN KEY (`QUOTE_ID`) REFERENCES `quote` (`QUOTE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quote_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote_role` (
  `QUOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`QUOTE_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `QUOTE_RL_QUOTE` (`QUOTE_ID`),
  KEY `QUOTE_RL_PARTY` (`PARTY_ID`),
  KEY `QUOTE_RL_PROLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  key `orr_QT_RL_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_QT_RL_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `QUOTE_RL_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `QUOTE_RL_PROLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `QUOTE_RL_QUOTE` FOREIGN KEY (`QUOTE_ID`) REFERENCES `quote` (`QUOTE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quote_term`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote_term` (
  `TERM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUOTE_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TERM_VALUE` decimal(20,0) DEFAULT NULL,
  `UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TERM_DAYS` decimal(20,0) DEFAULT NULL,
  `TEXT_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`TERM_TYPE_ID`,`QUOTE_ID`,`QUOTE_ITEM_SEQ_ID`),
  KEY `QUOTE_TERM_QTE` (`QUOTE_ID`),
  KEY `QUOTE_TERM_TTYPE` (`TERM_TYPE_ID`),
  key `orr_QT_TRM_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_QT_TRM_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `QUOTE_TERM_QTE` FOREIGN KEY (`QUOTE_ID`) REFERENCES `quote` (`QUOTE_ID`),
  CONSTRAINT `QUOTE_TERM_TTYPE` FOREIGN KEY (`TERM_TYPE_ID`) REFERENCES `term_type` (`TERM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quote_term_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote_term_attribute` (
  `TERM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUOTE_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`TERM_TYPE_ID`,`QUOTE_ID`,`QUOTE_ITEM_SEQ_ID`,`ATTR_NAME`),
  KEY `QUOTE_TERM_ATTR` (`TERM_TYPE_ID`,`QUOTE_ID`,`QUOTE_ITEM_SEQ_ID`),
  key `QT_TRM_ATT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `QT_TRM_ATT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `QUOTE_TERM_ATTR` FOREIGN KEY (`TERM_TYPE_ID`, `QUOTE_ID`, `QUOTE_ITEM_SEQ_ID`) REFERENCES `quote_term` (`TERM_TYPE_ID`, `QUOTE_ID`, `QUOTE_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quote_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote_type` (
  `QUOTE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`QUOTE_TYPE_ID`),
  KEY `QUOTE_TYPE_PAR` (`PARENT_TYPE_ID`),
  key `orr_QT_TP_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_QT_TP_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `QUOTE_TYPE_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `quote_type` (`QUOTE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quote_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote_type_attr` (
  `QUOTE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`QUOTE_TYPE_ID`,`ATTR_NAME`),
  KEY `QUOTE_TPAT_QTYP` (`QUOTE_TYPE_ID`),
  key `orr_QT_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_QT_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `QUOTE_TPAT_QTYP` FOREIGN KEY (`QUOTE_TYPE_ID`) REFERENCES `quote_type` (`QUOTE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quote_work_effort`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote_work_effort` (
  `QUOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`QUOTE_ID`,`WORK_EFFORT_ID`),
  KEY `QUOTE_WE_QUOTE` (`QUOTE_ID`),
  KEY `QUOTE_WE_WEFF` (`WORK_EFFORT_ID`),
  key `QT_WRK_EFT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `QT_WRK_EFT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `QUOTE_WE_QUOTE` FOREIGN KEY (`QUOTE_ID`) REFERENCES `quote` (`QUOTE_ID`),
  CONSTRAINT `QUOTE_WE_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `requirement`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requirement` (
  `REQUIREMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `REQUIREMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DELIVERABLE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIXED_ASSET_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIREMENT_START_DATE` datetime(3) DEFAULT NULL,
  `REQUIRED_BY_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_BUDGET` decimal(18,2) DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `USE_CASE` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `REASON` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`REQUIREMENT_ID`),
  KEY `REQ_TYPE` (`REQUIREMENT_TYPE_ID`),
  KEY `REQ_FACILITY` (`FACILITY_ID`),
  KEY `REQ_DELIVERABLE` (`DELIVERABLE_ID`),
  KEY `REQ_FIXED_ASSET` (`FIXED_ASSET_ID`),
  KEY `REQ_PRODUCT` (`PRODUCT_ID`),
  KEY `REQ_STTS` (`STATUS_ID`),
  key `orr_RQRMT_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_RQRMT_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `REQ_DELIVERABLE` FOREIGN KEY (`DELIVERABLE_ID`) REFERENCES `deliverable` (`DELIVERABLE_ID`),
  CONSTRAINT `REQ_FACILITY` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `REQ_PRODUCT` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `REQ_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `REQ_TYPE` FOREIGN KEY (`REQUIREMENT_TYPE_ID`) REFERENCES `requirement_type` (`REQUIREMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `requirement_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requirement_attribute` (
  `REQUIREMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`REQUIREMENT_ID`,`ATTR_NAME`),
  KEY `REQ_ATTR` (`REQUIREMENT_ID`),
  key `orr_RQT_ATT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_RQT_ATT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `REQ_ATTR` FOREIGN KEY (`REQUIREMENT_ID`) REFERENCES `requirement` (`REQUIREMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `requirement_budget_allocation`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requirement_budget_allocation` (
  `BUDGET_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `BUDGET_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `REQUIREMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AMOUNT` decimal(18,2) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`BUDGET_ID`,`BUDGET_ITEM_SEQ_ID`,`REQUIREMENT_ID`),
  KEY `REQ_BDGTAL_BITM` (`BUDGET_ID`,`BUDGET_ITEM_SEQ_ID`),
  KEY `REQ_BDGTAL_REQ` (`REQUIREMENT_ID`),
  key `RQT_BDT_ALN_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RQT_BDT_ALN_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `REQ_BDGTAL_REQ` FOREIGN KEY (`REQUIREMENT_ID`) REFERENCES `requirement` (`REQUIREMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `requirement_cust_request`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requirement_cust_request` (
  `CUST_REQUEST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CUST_REQUEST_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `REQUIREMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CUST_REQUEST_ID`,`CUST_REQUEST_ITEM_SEQ_ID`,`REQUIREMENT_ID`),
  KEY `REQ_CSREQ_CRITM` (`CUST_REQUEST_ID`,`CUST_REQUEST_ITEM_SEQ_ID`),
  KEY `REQ_CSREQ_REQ` (`REQUIREMENT_ID`),
  key `RQT_CST_RQT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RQT_CST_RQT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `REQ_CSREQ_CRITM` FOREIGN KEY (`CUST_REQUEST_ID`, `CUST_REQUEST_ITEM_SEQ_ID`) REFERENCES `cust_request_item` (`CUST_REQUEST_ID`, `CUST_REQUEST_ITEM_SEQ_ID`),
  CONSTRAINT `REQ_CSREQ_REQ` FOREIGN KEY (`REQUIREMENT_ID`) REFERENCES `requirement` (`REQUIREMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `requirement_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requirement_role` (
  `REQUIREMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`REQUIREMENT_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`FROM_DATE`),
  KEY `REQ_ROLE_REQ` (`REQUIREMENT_ID`),
  KEY `REQ_ROLE_PRTY` (`PARTY_ID`),
  KEY `REQ_ROLE_PROLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  key `orr_RQRT_RL_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_RQRT_RL_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `REQ_ROLE_PROLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `REQ_ROLE_PRTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `REQ_ROLE_REQ` FOREIGN KEY (`REQUIREMENT_ID`) REFERENCES `requirement` (`REQUIREMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `requirement_status`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requirement_status` (
  `REQUIREMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_DATE` datetime(3) DEFAULT NULL,
  `CHANGE_BY_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`REQUIREMENT_ID`,`STATUS_ID`),
  KEY `REQ_STTS_REQ` (`REQUIREMENT_ID`),
  KEY `REQ_STTS_STTS` (`STATUS_ID`),
  KEY `REQ_STTS_USRLGN` (`CHANGE_BY_USER_LOGIN_ID`),
  key `orr_RQT_STS_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_RQT_STS_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `REQ_STTS_REQ` FOREIGN KEY (`REQUIREMENT_ID`) REFERENCES `requirement` (`REQUIREMENT_ID`),
  CONSTRAINT `REQ_STTS_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `REQ_STTS_USRLGN` FOREIGN KEY (`CHANGE_BY_USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `requirement_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requirement_type` (
  `REQUIREMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`REQUIREMENT_TYPE_ID`),
  KEY `REQ_TYPE_PARENT` (`PARENT_TYPE_ID`),
  key `orr_RQRT_TP_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_RQRT_TP_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `REQ_TYPE_PARENT` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `requirement_type` (`REQUIREMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `requirement_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requirement_type_attr` (
  `REQUIREMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`REQUIREMENT_TYPE_ID`,`ATTR_NAME`),
  KEY `REQ_TYPE_ATTR` (`REQUIREMENT_TYPE_ID`),
  key `RQT_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RQT_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `REQ_TYPE_ATTR` FOREIGN KEY (`REQUIREMENT_TYPE_ID`) REFERENCES `requirement_type` (`REQUIREMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `responding_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `responding_party` (
  `RESPONDING_PARTY_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CUST_REQUEST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DATE_SENT` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RESPONDING_PARTY_SEQ_ID`,`CUST_REQUEST_ID`,`PARTY_ID`),
  KEY `RESP_PTY_CSREQ` (`CUST_REQUEST_ID`),
  KEY `RESP_PTY_PARTY` (`PARTY_ID`),
  KEY `RESP_PTY_CMECH` (`CONTACT_MECH_ID`),
  key `orr_RSPG_PRT_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_RSPG_PRT_TXS` (`CREATED_TX_STAMP`),
  CONSTRAINT `RESP_PTY_CMECH` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `RESP_PTY_CSREQ` FOREIGN KEY (`CUST_REQUEST_ID`) REFERENCES `cust_request` (`CUST_REQUEST_ID`),
  CONSTRAINT `RESP_PTY_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_adjustment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_adjustment` (
  `RETURN_ADJUSTMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RETURN_ADJUSTMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ADJUSTMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AMOUNT` decimal(18,3) DEFAULT NULL,
  `PRODUCT_PROMO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PROMO_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PROMO_ACTION_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CORRESPONDING_PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TAX_AUTHORITY_RATE_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SOURCE_REFERENCE_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SOURCE_PERCENTAGE` decimal(18,6) DEFAULT NULL,
  `CUSTOMER_REFERENCE_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIMARY_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SECONDARY_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXEMPT_AMOUNT` decimal(18,2) DEFAULT NULL,
  `TAX_AUTH_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TAX_AUTH_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OVERRIDE_GL_ACCOUNT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INCLUDE_IN_TAX` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INCLUDE_IN_SHIPPING` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ADJUSTMENT_ID`),
  KEY `RETURN_ADJ_TYPE` (`RETURN_ADJUSTMENT_TYPE_ID`),
  KEY `RETURN_ADJ_RHEAD` (`RETURN_ID`),
  KEY `RETURN_ADJ_USERL` (`CREATED_BY_USER_LOGIN`),
  KEY `RETURN_ADJ_PROMO` (`PRODUCT_PROMO_ID`),
  KEY `RETURN_ADJ_PRGEO` (`PRIMARY_GEO_ID`),
  KEY `RETURN_ADJ_SCGEO` (`SECONDARY_GEO_ID`),
  KEY `RETURN_ADJ_TXA` (`TAX_AUTH_GEO_ID`,`TAX_AUTH_PARTY_ID`),
  KEY `RETURN_ADJ_OGLA` (`OVERRIDE_GL_ACCOUNT_ID`),
  KEY `RET_ADJ_RTN_TYPE` (`RETURN_TYPE_ID`),
  KEY `RETURN_ADJ_ORDADJ` (`ORDER_ADJUSTMENT_ID`),
  KEY `RETURN_ADJ_TARP` (`TAX_AUTHORITY_RATE_SEQ_ID`),
  key `orr_RTN_ADJT_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_RTN_ADJT_TXS` (`CREATED_TX_STAMP`),
  CONSTRAINT `RET_ADJ_RTN_TYPE` FOREIGN KEY (`RETURN_TYPE_ID`) REFERENCES `return_type` (`RETURN_TYPE_ID`),
  CONSTRAINT `RETURN_ADJ_ORDADJ` FOREIGN KEY (`ORDER_ADJUSTMENT_ID`) REFERENCES `order_adjustment` (`ORDER_ADJUSTMENT_ID`),
  CONSTRAINT `RETURN_ADJ_PRGEO` FOREIGN KEY (`PRIMARY_GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `RETURN_ADJ_PROMO` FOREIGN KEY (`PRODUCT_PROMO_ID`) REFERENCES `product_promo` (`PRODUCT_PROMO_ID`),
  CONSTRAINT `RETURN_ADJ_RHEAD` FOREIGN KEY (`RETURN_ID`) REFERENCES `return_header` (`RETURN_ID`),
  CONSTRAINT `RETURN_ADJ_SCGEO` FOREIGN KEY (`SECONDARY_GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `RETURN_ADJ_TYPE` FOREIGN KEY (`RETURN_ADJUSTMENT_TYPE_ID`) REFERENCES `return_adjustment_type` (`RETURN_ADJUSTMENT_TYPE_ID`),
  CONSTRAINT `RETURN_ADJ_USERL` FOREIGN KEY (`CREATED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_adjustment_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_adjustment_type` (
  `RETURN_ADJUSTMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ADJUSTMENT_TYPE_ID`),
  KEY `RETURN_ADJ_TYPPAR` (`PARENT_TYPE_ID`),
  key `RTN_ADT_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RTN_ADT_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `RETURN_ADJ_TYPPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `return_adjustment_type` (`RETURN_ADJUSTMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_contact_mech` (
  `RETURN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_PURPOSE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ID`,`CONTACT_MECH_PURPOSE_TYPE_ID`,`CONTACT_MECH_ID`),
  KEY `RETURN_CMECH_HDR` (`RETURN_ID`),
  KEY `RETURN_CMECH_CM` (`CONTACT_MECH_ID`),
  KEY `RETURN_CMECH_CMPT` (`CONTACT_MECH_PURPOSE_TYPE_ID`),
  key `RTN_CNT_MCH_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RTN_CNT_MCH_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `RETURN_CMECH_CM` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `RETURN_CMECH_CMPT` FOREIGN KEY (`CONTACT_MECH_PURPOSE_TYPE_ID`) REFERENCES `contact_mech_purpose_type` (`CONTACT_MECH_PURPOSE_TYPE_ID`),
  CONSTRAINT `RETURN_CMECH_HDR` FOREIGN KEY (`RETURN_ID`) REFERENCES `return_header` (`RETURN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_header`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_header` (
  `RETURN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RETURN_HEADER_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_BY` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PAYMENT_METHOD_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIN_ACCOUNT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BILLING_ACCOUNT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENTRY_DATE` datetime(3) DEFAULT NULL,
  `ORIGIN_CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESTINATION_FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NEEDS_INVENTORY_RECEIVE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUPPLIER_RMA_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ID`),
  KEY `RTN_HEAD_TYPE` (`RETURN_HEADER_TYPE_ID`),
  KEY `RTN_FROM_PARTY` (`FROM_PARTY_ID`),
  KEY `RTN_TO_PARTY` (`TO_PARTY_ID`),
  KEY `RTN_TO_BACT` (`BILLING_ACCOUNT_ID`),
  KEY `RTN_TO_FACT` (`FIN_ACCOUNT_ID`),
  KEY `RTN_TO_PAYMETH` (`PAYMENT_METHOD_ID`),
  KEY `RTN_TO_FACILITY` (`DESTINATION_FACILITY_ID`),
  KEY `RTN_FROM_CTM` (`ORIGIN_CONTACT_MECH_ID`),
  KEY `RTN_STTS_ITEM` (`STATUS_ID`),
  KEY `RTN_HDR_CUOM` (`CURRENCY_UOM_ID`),
  key `orr_RTN_HDR_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_RTN_HDR_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `RTN_FROM_CTM` FOREIGN KEY (`ORIGIN_CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `RTN_FROM_PARTY` FOREIGN KEY (`FROM_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `RTN_HDR_CUOM` FOREIGN KEY (`CURRENCY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `RTN_HEAD_TYPE` FOREIGN KEY (`RETURN_HEADER_TYPE_ID`) REFERENCES `return_header_type` (`RETURN_HEADER_TYPE_ID`),
  CONSTRAINT `RTN_STTS_ITEM` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `RTN_TO_FACILITY` FOREIGN KEY (`DESTINATION_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `RTN_TO_PARTY` FOREIGN KEY (`TO_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_header_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_header_type` (
  `RETURN_HEADER_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_HEADER_TYPE_ID`),
  KEY `RTHEAD_TYPE_PARENT` (`PARENT_TYPE_ID`),
  key `RTN_HDR_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RTN_HDR_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `RTHEAD_TYPE_PARENT` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `return_header_type` (`RETURN_HEADER_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_item` (
  `RETURN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RETURN_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RETURN_REASON_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXPECTED_ITEM_STATUS` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_QUANTITY` decimal(18,6) DEFAULT NULL,
  `RECEIVED_QUANTITY` decimal(18,6) DEFAULT NULL,
  `RETURN_PRICE` decimal(18,2) DEFAULT NULL,
  `RETURN_ITEM_RESPONSE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ID`,`RETURN_ITEM_SEQ_ID`),
  KEY `RTN_ITEM_RTN` (`RETURN_ID`),
  KEY `RTN_ITEM_REASON` (`RETURN_REASON_ID`),
  KEY `RTN_TYPE` (`RETURN_TYPE_ID`),
  KEY `RTN_ITEM_TYPE` (`RETURN_ITEM_TYPE_ID`),
  KEY `RTN_ITEM_RESP` (`RETURN_ITEM_RESPONSE_ID`),
  KEY `RTN_ITEM_ODR` (`ORDER_ID`),
  KEY `RTN_ITEM_ODRIT` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `RTN_ITEM_STTSIT` (`STATUS_ID`),
  KEY `RTN_ITEM_ITSTT` (`EXPECTED_ITEM_STATUS`),
  KEY `RTN_ITEM_PROD` (`PRODUCT_ID`),
  key `orr_RTN_ITM_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_RTN_ITM_TXCS` (`CREATED_TX_STAMP`),
  KEY `RTN_ITM_BYORDITM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `RTN_ITEM_ITSTT` FOREIGN KEY (`EXPECTED_ITEM_STATUS`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `RTN_ITEM_ODR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `RTN_ITEM_ODRIT` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `RTN_ITEM_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `RTN_ITEM_REASON` FOREIGN KEY (`RETURN_REASON_ID`) REFERENCES `return_reason` (`RETURN_REASON_ID`),
  CONSTRAINT `RTN_ITEM_RESP` FOREIGN KEY (`RETURN_ITEM_RESPONSE_ID`) REFERENCES `return_item_response` (`RETURN_ITEM_RESPONSE_ID`),
  CONSTRAINT `RTN_ITEM_RTN` FOREIGN KEY (`RETURN_ID`) REFERENCES `return_header` (`RETURN_ID`),
  CONSTRAINT `RTN_ITEM_STTSIT` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `RTN_ITEM_TYPE` FOREIGN KEY (`RETURN_ITEM_TYPE_ID`) REFERENCES `return_item_type` (`RETURN_ITEM_TYPE_ID`),
  CONSTRAINT `RTN_TYPE` FOREIGN KEY (`RETURN_TYPE_ID`) REFERENCES `return_type` (`RETURN_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_item_billing`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_item_billing` (
  `RETURN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RETURN_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_RECEIPT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `AMOUNT` decimal(18,2) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ID`,`RETURN_ITEM_SEQ_ID`,`INVOICE_ID`,`INVOICE_ITEM_SEQ_ID`),
  KEY `RTN_ITBLNG_RHDR` (`RETURN_ID`),
  KEY `RTN_ITBLNG_RITM` (`RETURN_ID`,`RETURN_ITEM_SEQ_ID`),
  KEY `RETURN_ITBLNG_IITM` (`INVOICE_ID`,`INVOICE_ITEM_SEQ_ID`),
  KEY `RITBL_SHIPRCPT` (`SHIPMENT_RECEIPT_ID`),
  key `RTN_ITM_BLG_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RTN_ITM_BLG_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `RITBL_SHIPRCPT` FOREIGN KEY (`SHIPMENT_RECEIPT_ID`) REFERENCES `shipment_receipt` (`RECEIPT_ID`),
  CONSTRAINT `RTN_ITBLNG_RHDR` FOREIGN KEY (`RETURN_ID`) REFERENCES `return_header` (`RETURN_ID`),
  CONSTRAINT `RTN_ITBLNG_RITM` FOREIGN KEY (`RETURN_ID`, `RETURN_ITEM_SEQ_ID`) REFERENCES `return_item` (`RETURN_ID`, `RETURN_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_item_response`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_item_response` (
  `RETURN_ITEM_RESPONSE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_PAYMENT_PREFERENCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REPLACEMENT_ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PAYMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BILLING_ACCOUNT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIN_ACCOUNT_TRANS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESPONSE_AMOUNT` decimal(18,2) DEFAULT NULL,
  `RESPONSE_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ITEM_RESPONSE_ID`),
  KEY `RTN_PAY_ORDPAYPF` (`ORDER_PAYMENT_PREFERENCE_ID`),
  KEY `RTN_RESP_NEWORD` (`REPLACEMENT_ORDER_ID`),
  KEY `RTN_PAY_PAYMENT` (`PAYMENT_ID`),
  KEY `RTN_PAY_BACT` (`BILLING_ACCOUNT_ID`),
  KEY `RTN_PAY_FINACTTX` (`FIN_ACCOUNT_TRANS_ID`),
  key `RTN_ITM_RSS_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RTN_ITM_RSS_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `RTN_PAY_ORDPAYPF` FOREIGN KEY (`ORDER_PAYMENT_PREFERENCE_ID`) REFERENCES `order_payment_preference` (`ORDER_PAYMENT_PREFERENCE_ID`),
  CONSTRAINT `RTN_RESP_NEWORD` FOREIGN KEY (`REPLACEMENT_ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_item_shipment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_item_shipment` (
  `RETURN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RETURN_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ID`,`RETURN_ITEM_SEQ_ID`,`SHIPMENT_ID`,`SHIPMENT_ITEM_SEQ_ID`),
  KEY `RIT_SHPMT_RHDR` (`RETURN_ID`),
  KEY `RIT_SHPMT_RITM` (`RETURN_ID`,`RETURN_ITEM_SEQ_ID`),
  KEY `RIT_SHPMT_SHPMT` (`SHIPMENT_ID`),
  KEY `RIT_SHPMT_SHPITM` (`SHIPMENT_ID`,`SHIPMENT_ITEM_SEQ_ID`),
  key `RTN_ITM_SHT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RTN_ITM_SHT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `RIT_SHPMT_RHDR` FOREIGN KEY (`RETURN_ID`) REFERENCES `return_header` (`RETURN_ID`),
  CONSTRAINT `RIT_SHPMT_RITM` FOREIGN KEY (`RETURN_ID`, `RETURN_ITEM_SEQ_ID`) REFERENCES `return_item` (`RETURN_ID`, `RETURN_ITEM_SEQ_ID`),
  CONSTRAINT `RIT_SHPMT_SHPITM` FOREIGN KEY (`SHIPMENT_ID`, `SHIPMENT_ITEM_SEQ_ID`) REFERENCES `shipment_item` (`SHIPMENT_ID`, `SHIPMENT_ITEM_SEQ_ID`),
  CONSTRAINT `RIT_SHPMT_SHPMT` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_item_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_item_type` (
  `RETURN_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ITEM_TYPE_ID`),
  KEY `RETURN_ITEM_TYPPAR` (`PARENT_TYPE_ID`),
  key `RTN_ITM_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RTN_ITM_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `RETURN_ITEM_TYPPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `return_item_type` (`RETURN_ITEM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_item_type_map`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_item_type_map` (
  `RETURN_ITEM_MAP_KEY` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RETURN_HEADER_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RETURN_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ITEM_MAP_KEY`,`RETURN_HEADER_TYPE_ID`),
  KEY `RETITMMAP_RETTYP` (`RETURN_HEADER_TYPE_ID`),
  key `RTN_ITM_TP_MP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `RTN_ITM_TP_MP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `RETITMMAP_RETTYP` FOREIGN KEY (`RETURN_HEADER_TYPE_ID`) REFERENCES `return_header_type` (`RETURN_HEADER_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_reason`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_reason` (
  `RETURN_REASON_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_REASON_ID`),
  key `orr_RTN_RSN_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_RTN_RSN_TXCS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_status`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_status` (
  `RETURN_STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGE_BY_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_DATETIME` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_STATUS_ID`),
  KEY `RTN_STTS_STTS` (`STATUS_ID`),
  KEY `RTN_STTS_RTN` (`RETURN_ID`),
  KEY `RTN_STTS_USRLGN` (`CHANGE_BY_USER_LOGIN_ID`),
  key `orr_RTN_STS_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_RTN_STS_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `RTN_STTS_RTN` FOREIGN KEY (`RETURN_ID`) REFERENCES `return_header` (`RETURN_ID`),
  CONSTRAINT `RTN_STTS_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `RTN_STTS_USRLGN` FOREIGN KEY (`CHANGE_BY_USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_type` (
  `RETURN_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_TYPE_ID`),
  key `orr_RTN_TP_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_RTN_TP_TXCRS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shopping_list`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_list` (
  `SHOPPING_LIST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHOPPING_LIST_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_SHOPPING_LIST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VISITOR_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LIST_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_PUBLIC` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_ACTIVE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CURRENCY_UOM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PAYMENT_METHOD_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECURRENCE_INFO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_ORDERED_DATE` datetime(3) DEFAULT NULL,
  `LAST_ADMIN_MODIFIED` datetime(3) DEFAULT NULL,
  `PRODUCT_PROMO_CODE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHOPPING_LIST_ID`),
  KEY `SHLIST_PARENT` (`PARENT_SHOPPING_LIST_ID`),
  KEY `SHLIST_TYPE` (`SHOPPING_LIST_TYPE_ID`),
  KEY `SHLIST_PRDS` (`PRODUCT_STORE_ID`),
  KEY `SHLIST_PTY` (`PARTY_ID`),
  KEY `SHLIST_CSSM` (`SHIPMENT_METHOD_TYPE_ID`,`CARRIER_PARTY_ID`,`CARRIER_ROLE_TYPE_ID`),
  KEY `SHLIST_CMECH` (`CONTACT_MECH_ID`),
  KEY `SHLIST_PYMETH` (`PAYMENT_METHOD_ID`),
  KEY `SHLIST_RECINFO` (`RECURRENCE_INFO_ID`),
  KEY `SHLIST_PRMCD` (`PRODUCT_PROMO_CODE_ID`),
  key `orr_SHG_LST_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `orr_SHG_LST_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHLIST_CMECH` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `SHLIST_CSSM` FOREIGN KEY (`SHIPMENT_METHOD_TYPE_ID`, `CARRIER_PARTY_ID`, `CARRIER_ROLE_TYPE_ID`) REFERENCES `carrier_shipment_method` (`SHIPMENT_METHOD_TYPE_ID`, `PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `SHLIST_PARENT` FOREIGN KEY (`PARENT_SHOPPING_LIST_ID`) REFERENCES `shopping_list` (`SHOPPING_LIST_ID`),
  CONSTRAINT `SHLIST_PRDS` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `SHLIST_PRMCD` FOREIGN KEY (`PRODUCT_PROMO_CODE_ID`) REFERENCES `product_promo_code` (`PRODUCT_PROMO_CODE_ID`),
  CONSTRAINT `SHLIST_PTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `SHLIST_RECINFO` FOREIGN KEY (`RECURRENCE_INFO_ID`) REFERENCES `recurrence_info` (`RECURRENCE_INFO_ID`),
  CONSTRAINT `SHLIST_TYPE` FOREIGN KEY (`SHOPPING_LIST_TYPE_ID`) REFERENCES `shopping_list_type` (`SHOPPING_LIST_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shopping_list_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_list_item` (
  `SHOPPING_LIST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHOPPING_LIST_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `MODIFIED_PRICE` decimal(18,3) DEFAULT NULL,
  `RESERV_START` datetime(3) DEFAULT NULL,
  `RESERV_LENGTH` decimal(18,6) DEFAULT NULL,
  `RESERV_PERSONS` decimal(18,6) DEFAULT NULL,
  `QUANTITY_PURCHASED` decimal(18,6) DEFAULT NULL,
  `CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHOPPING_LIST_ID`,`SHOPPING_LIST_ITEM_SEQ_ID`),
  KEY `SHLIST_ITEM_LIST` (`SHOPPING_LIST_ID`),
  KEY `SHLIST_ITEM_PROD` (`PRODUCT_ID`),
  key `SHG_LST_ITM_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHG_LST_ITM_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHLIST_ITEM_LIST` FOREIGN KEY (`SHOPPING_LIST_ID`) REFERENCES `shopping_list` (`SHOPPING_LIST_ID`),
  CONSTRAINT `SHLIST_ITEM_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shopping_list_item_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_list_item_attribute` (
  `SHOPPING_LIST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHOPPING_LIST_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHOPPING_LIST_ID`,`SHOPPING_LIST_ITEM_SEQ_ID`,`ATTR_NAME`),
  KEY `SHLIST_ITEM_ATTR` (`SHOPPING_LIST_ID`,`SHOPPING_LIST_ITEM_SEQ_ID`),
  key `LST_ITM_ATT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `LST_ITM_ATT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHLIST_ITEM_ATTR` FOREIGN KEY (`SHOPPING_LIST_ID`, `SHOPPING_LIST_ITEM_SEQ_ID`) REFERENCES `shopping_list_item` (`SHOPPING_LIST_ID`, `SHOPPING_LIST_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shopping_list_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_list_type` (
  `SHOPPING_LIST_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHOPPING_LIST_TYPE_ID`),
  key `SHG_LST_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHG_LST_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shopping_list_work_effort`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_list_work_effort` (
  `SHOPPING_LIST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHOPPING_LIST_ID`,`WORK_EFFORT_ID`),
  KEY `SHLISTWE_SHLST` (`SHOPPING_LIST_ID`),
  KEY `SHLISTWE_WEFF` (`WORK_EFFORT_ID`),
  key `LST_WRK_EFT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `LST_WRK_EFT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHLISTWE_SHLST` FOREIGN KEY (`SHOPPING_LIST_ID`) REFERENCES `shopping_list` (`SHOPPING_LIST_ID`),
  CONSTRAINT `SHLISTWE_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_order_item_fulfillment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_order_item_fulfillment` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `WORDER_ITFMT_OHDR` (`ORDER_ID`),
  KEY `WORDER_ITFMT_OITM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `WORDER_ITFMT_WEFRT` (`WORK_EFFORT_ID`),
  key `ORR_ITM_FLT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ORR_ITM_FLT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WORDER_ITFMT_OHDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `WORDER_ITFMT_OITM` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `WORDER_ITFMT_WEFRT` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_req_fulf_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_req_fulf_type` (
  `WORK_REQ_FULF_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_REQ_FULF_TYPE_ID`),
  key `WRK_RQ_FLF_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `WRK_RQ_FLF_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_requirement_fulfillment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_requirement_fulfillment` (
  `REQUIREMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_REQ_FULF_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`REQUIREMENT_ID`,`WORK_EFFORT_ID`),
  KEY `WORK_REQFL_REQ` (`REQUIREMENT_ID`),
  KEY `WORK_REQFL_WEFF` (`WORK_EFFORT_ID`),
  KEY `WORK_REQFL_WRFT` (`WORK_REQ_FULF_TYPE_ID`),
  key `WRK_RQT_FLT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `WRK_RQT_FLT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WORK_REQFL_REQ` FOREIGN KEY (`REQUIREMENT_ID`) REFERENCES `requirement` (`REQUIREMENT_ID`),
  CONSTRAINT `WORK_REQFL_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`),
  CONSTRAINT `WORK_REQFL_WRFT` FOREIGN KEY (`WORK_REQ_FULF_TYPE_ID`) REFERENCES `work_req_fulf_type` (`WORK_REQ_FULF_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `addendum`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addendum` (
  `ADDENDUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AGREEMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ADDENDUM_CREATION_DATE` datetime(3) DEFAULT NULL,
  `ADDENDUM_EFFECTIVE_DATE` datetime(3) DEFAULT NULL,
  `ADDENDUM_TEXT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ADDENDUM_ID`),
  KEY `ADDNDM_AGRMNT` (`AGREEMENT_ID`),
  KEY `ADDNDM_AGRMNT_ITM` (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`),
  key `pat_ADDNM_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_ADDNM_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ADDNDM_AGRMNT` FOREIGN KEY (`AGREEMENT_ID`) REFERENCES `agreement` (`AGREEMENT_ID`),
  CONSTRAINT `ADDNDM_AGRMNT_ITM` FOREIGN KEY (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`) REFERENCES `agreement_item` (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `address_match_map`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address_match_map` (
  `MAP_KEY` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MAP_VALUE` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`MAP_KEY`,`MAP_VALUE`),
  key `ADS_MTH_MP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ADS_MTH_MP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `affiliate`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `affiliate` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AFFILIATE_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AFFILIATE_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `YEAR_ESTABLISHED` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SITE_TYPE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SITE_PAGE_VIEWS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SITE_VISITORS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DATE_TIME_CREATED` datetime(3) DEFAULT NULL,
  `DATE_TIME_APPROVED` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`),
  KEY `AFFILIATE_PARTY` (`PARTY_ID`),
  KEY `AFFILIATE_PGRP` (`PARTY_ID`),
  key `part_AFFT_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `part_AFFT_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AFFILIATE_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `AFFILIATE_PGRP` FOREIGN KEY (`PARTY_ID`) REFERENCES `party_group` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement` (
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROLE_TYPE_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROLE_TYPE_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AGREEMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AGREEMENT_DATE` datetime(3) DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TEXT_DATA` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ID`),
  KEY `AGRMNT_PRODUCT` (`PRODUCT_ID`),
  KEY `AGRMNT_FPRTYRLE` (`PARTY_ID_FROM`,`ROLE_TYPE_ID_FROM`),
  KEY `AGRMNT_TPRTYRLE` (`PARTY_ID_TO`,`ROLE_TYPE_ID_TO`),
  KEY `AGRMNT_TYPE` (`AGREEMENT_TYPE_ID`),
  key `pat_AGRMT_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_AGRMT_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_FPRTYRLE` FOREIGN KEY (`PARTY_ID_FROM`, `ROLE_TYPE_ID_FROM`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `AGRMNT_PRODUCT` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `AGRMNT_TPRTYRLE` FOREIGN KEY (`PARTY_ID_TO`, `ROLE_TYPE_ID_TO`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `AGRMNT_TYPE` FOREIGN KEY (`AGREEMENT_TYPE_ID`) REFERENCES `agreement_type` (`AGREEMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_attribute` (
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ID`,`ATTR_NAME`),
  KEY `AGRMNT_ATTR` (`AGREEMENT_ID`),
  key `pat_AGT_ATT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_AGT_ATT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_ATTR` FOREIGN KEY (`AGREEMENT_ID`) REFERENCES `agreement` (`AGREEMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_content_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_content_type` (
  `AGREEMENT_CONTENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_CONTENT_TYPE_ID`),
  KEY `AGCT_TYP_PARENT` (`PARENT_TYPE_ID`),
  key `AGT_CNT_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `AGT_CNT_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGCT_TYP_PARENT` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `agreement_content_type` (`AGREEMENT_CONTENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_employment_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_employment_appl` (
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AGREEMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `AGREEMENT_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`,`PARTY_ID_TO`,`PARTY_ID_FROM`,`ROLE_TYPE_ID_TO`,`ROLE_TYPE_ID_FROM`,`FROM_DATE`),
  KEY `AGRMNT_EMPL_APPL` (`ROLE_TYPE_ID_FROM`,`ROLE_TYPE_ID_TO`,`PARTY_ID_FROM`,`PARTY_ID_TO`,`FROM_DATE`),
  KEY `AGRMNT_EMPL_AITM` (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`),
  key `AGT_EMT_APL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `AGT_EMT_APL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_EMPL_AITM` FOREIGN KEY (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`) REFERENCES `agreement_item` (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_facility_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_facility_appl` (
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AGREEMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`,`FACILITY_ID`),
  KEY `AGRMNT_FACLT_AITM` (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`),
  KEY `AGRMNT_FACLT_PRD` (`FACILITY_ID`),
  key `AGT_FCT_APL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `AGT_FCT_APL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_FACLT_AITM` FOREIGN KEY (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`) REFERENCES `agreement_item` (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`),
  CONSTRAINT `AGRMNT_FACLT_PRD` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_geographical_applic`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_geographical_applic` (
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AGREEMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`,`GEO_ID`),
  KEY `AGRMNT_GEOAP_AGR` (`AGREEMENT_ID`),
  KEY `AGRMNT_GEOAP_AGRI` (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`),
  KEY `AGRMNT_GEOAP_GEO` (`GEO_ID`),
  key `AGT_GGL_APC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `AGT_GGL_APC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_GEOAP_AGR` FOREIGN KEY (`AGREEMENT_ID`) REFERENCES `agreement` (`AGREEMENT_ID`),
  CONSTRAINT `AGRMNT_GEOAP_AGRI` FOREIGN KEY (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`) REFERENCES `agreement_item` (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`),
  CONSTRAINT `AGRMNT_GEOAP_GEO` FOREIGN KEY (`GEO_ID`) REFERENCES `geo` (`GEO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_item` (
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AGREEMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AGREEMENT_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AGREEMENT_TEXT` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `AGREEMENT_IMAGE` longblob,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`),
  KEY `AGRMNT_ITEM_AGR` (`AGREEMENT_ID`),
  KEY `AGRMNT_ITEM_TYPE` (`AGREEMENT_ITEM_TYPE_ID`),
  key `pat_AGT_ITM_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_AGT_ITM_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_ITEM_AGR` FOREIGN KEY (`AGREEMENT_ID`) REFERENCES `agreement` (`AGREEMENT_ID`),
  CONSTRAINT `AGRMNT_ITEM_TYPE` FOREIGN KEY (`AGREEMENT_ITEM_TYPE_ID`) REFERENCES `agreement_item_type` (`AGREEMENT_ITEM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_item_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_item_attribute` (
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AGREEMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`,`ATTR_NAME`),
  KEY `AGRMNT_ITEM_ATTR` (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`),
  key `AGT_ITM_ATT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `AGT_ITM_ATT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_ITEM_ATTR` FOREIGN KEY (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`) REFERENCES `agreement_item` (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_item_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_item_type` (
  `AGREEMENT_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ITEM_TYPE_ID`),
  KEY `AGRMNT_TYPEPAR` (`PARENT_TYPE_ID`),
  key `AGT_ITM_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `AGT_ITM_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_TYPEPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `agreement_item_type` (`AGREEMENT_ITEM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_item_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_item_type_attr` (
  `AGREEMENT_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ITEM_TYPE_ID`,`ATTR_NAME`),
  KEY `AGRMNT_ITEM_TYPATR` (`AGREEMENT_ITEM_TYPE_ID`),
  key `ITM_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ITM_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_ITEM_TYPATR` FOREIGN KEY (`AGREEMENT_ITEM_TYPE_ID`) REFERENCES `agreement_item_type` (`AGREEMENT_ITEM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_party_applic`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_party_applic` (
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AGREEMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`,`PARTY_ID`),
  KEY `AGRMNT_PTYA_AGR` (`AGREEMENT_ID`),
  KEY `AGRMNT_PTYA_PTY` (`PARTY_ID`),
  key `AGT_PRT_APC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `AGT_PRT_APC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_PTYA_AGR` FOREIGN KEY (`AGREEMENT_ID`) REFERENCES `agreement` (`AGREEMENT_ID`),
  CONSTRAINT `AGRMNT_PTYA_PTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_product_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_product_appl` (
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AGREEMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRICE` decimal(18,3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`,`PRODUCT_ID`),
  KEY `AGRMNT_PRDA_AITM` (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`),
  KEY `AGRMNT_PRDA_PRD` (`PRODUCT_ID`),
  key `AGT_PRT_APL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `AGT_PRT_APL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_PRDA_AITM` FOREIGN KEY (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`) REFERENCES `agreement_item` (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`),
  CONSTRAINT `AGRMNT_PRDA_PRD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_promo_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_promo_appl` (
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AGREEMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`,`PRODUCT_PROMO_ID`,`FROM_DATE`),
  KEY `AGRMNT_PROM_PRO` (`PRODUCT_PROMO_ID`),
  KEY `AGRMNT_PROM_AITM` (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`),
  key `AGT_PRM_APL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `AGT_PRM_APL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_PROM_AITM` FOREIGN KEY (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`) REFERENCES `agreement_item` (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`),
  CONSTRAINT `AGRMNT_PROM_PRO` FOREIGN KEY (`PRODUCT_PROMO_ID`) REFERENCES `product_promo` (`PRODUCT_PROMO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_role` (
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `AGRMNT_ROLE_AGR` (`AGREEMENT_ID`),
  KEY `AGRMNT_ROLE_PTY` (`PARTY_ID`),
  KEY `AGRMNT_ROLE_PRLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  key `pat_AGRT_RL_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_AGRT_RL_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_ROLE_AGR` FOREIGN KEY (`AGREEMENT_ID`) REFERENCES `agreement` (`AGREEMENT_ID`),
  CONSTRAINT `AGRMNT_ROLE_PRLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `AGRMNT_ROLE_PTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_status`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_status` (
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_DATE` datetime(3) NOT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGE_BY_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ID`,`STATUS_ID`,`STATUS_DATE`),
  KEY `AGRMNT_STTS_AGRMNT` (`AGREEMENT_ID`),
  KEY `AGRMNT_STTS_STTS` (`STATUS_ID`),
  KEY `AGRMNT_STTS_USRLGN` (`CHANGE_BY_USER_LOGIN_ID`),
  key `pat_AGT_STS_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_AGT_STS_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_STTS_AGRMNT` FOREIGN KEY (`AGREEMENT_ID`) REFERENCES `agreement` (`AGREEMENT_ID`),
  CONSTRAINT `AGRMNT_STTS_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `AGRMNT_STTS_USRLGN` FOREIGN KEY (`CHANGE_BY_USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_term`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_term` (
  `AGREEMENT_TERM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TERM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AGREEMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVOICE_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `TERM_VALUE` decimal(18,3) DEFAULT NULL,
  `TERM_DAYS` decimal(20,0) DEFAULT NULL,
  `TEXT_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MIN_QUANTITY` double DEFAULT NULL,
  `MAX_QUANTITY` double DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_TERM_ID`),
  KEY `AGRMNT_TERM_TTYP` (`TERM_TYPE_ID`),
  KEY `AGRMNT_TERM_AGR` (`AGREEMENT_ID`),
  KEY `AGRMNT_TERM_AITM` (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`),
  KEY `AGRMNT_TERM_IIT` (`INVOICE_ITEM_TYPE_ID`),
  key `pat_AGT_TRM_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_AGT_TRM_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_TERM_AGR` FOREIGN KEY (`AGREEMENT_ID`) REFERENCES `agreement` (`AGREEMENT_ID`),
  CONSTRAINT `AGRMNT_TERM_AITM` FOREIGN KEY (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`) REFERENCES `agreement_item` (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`),
  CONSTRAINT `AGRMNT_TERM_TTYP` FOREIGN KEY (`TERM_TYPE_ID`) REFERENCES `term_type` (`TERM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_term_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_term_attribute` (
  `AGREEMENT_TERM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_TERM_ID`,`ATTR_NAME`),
  KEY `AGRMNT_TERM_ATTR` (`AGREEMENT_TERM_ID`),
  key `AGT_TRM_ATT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `AGT_TRM_ATT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_TERM_ATTR` FOREIGN KEY (`AGREEMENT_TERM_ID`) REFERENCES `agreement_term` (`AGREEMENT_TERM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_type` (
  `AGREEMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_TYPE_ID`),
  KEY `AGRMNT_TYPE_PAR` (`PARENT_TYPE_ID`),
  key `pat_AGRT_TP_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_AGRT_TP_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_TYPE_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `agreement_type` (`AGREEMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_type_attr` (
  `AGREEMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_TYPE_ID`,`ATTR_NAME`),
  KEY `AGRMNT_TYPE_ATTR` (`AGREEMENT_TYPE_ID`),
  key `AGT_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `AGT_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_TYPE_ATTR` FOREIGN KEY (`AGREEMENT_TYPE_ID`) REFERENCES `agreement_type` (`AGREEMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `agreement_work_effort_applic`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_work_effort_applic` (
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AGREEMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`,`WORK_EFFORT_ID`),
  KEY `AGRMNT_WEA_AGRMNT` (`AGREEMENT_ID`),
  KEY `AGRMNT_WEA_WE` (`WORK_EFFORT_ID`),
  key `WRK_EFT_APC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `WRK_EFT_APC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `AGRMNT_WEA_AGRMNT` FOREIGN KEY (`AGREEMENT_ID`) REFERENCES `agreement` (`AGREEMENT_ID`),
  CONSTRAINT `AGRMNT_WEA_WE` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `comm_content_assoc_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comm_content_assoc_type` (
  `COMM_CONTENT_ASSOC_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COMM_CONTENT_ASSOC_TYPE_ID`),
  key `CNT_ASC_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CNT_ASC_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event` (
  `COMMUNICATION_EVENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COMMUNICATION_EVENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIG_COMM_EVENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_COMM_EVENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTACT_MECH_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTACT_MECH_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTACT_MECH_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROLE_TYPE_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROLE_TYPE_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENTRY_DATE` datetime(3) DEFAULT NULL,
  `DATETIME_STARTED` datetime(3) DEFAULT NULL,
  `DATETIME_ENDED` datetime(3) DEFAULT NULL,
  `SUBJECT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_MIME_TYPE_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `NOTE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REASON_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTACT_LIST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HEADER_STRING` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `FROM_STRING` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `TO_STRING` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `CC_STRING` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `BCC_STRING` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `MESSAGE_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COMMUNICATION_EVENT_ID`),
  UNIQUE KEY `COMMEVT_MSG_ID` (`MESSAGE_ID`),
  KEY `COM_EVNT_TYPE` (`COMMUNICATION_EVENT_TYPE_ID`),
  KEY `COM_EVNT_TPTY` (`PARTY_ID_TO`),
  KEY `COM_EVNT_TRTYP` (`ROLE_TYPE_ID_TO`),
  KEY `COM_EVNT_FPTY` (`PARTY_ID_FROM`),
  KEY `COM_EVNT_FRTYP` (`ROLE_TYPE_ID_FROM`),
  KEY `COM_EVNT_STTS` (`STATUS_ID`),
  KEY `COM_EVNT_CMTP` (`CONTACT_MECH_TYPE_ID`),
  KEY `COM_EVNT_FCM` (`CONTACT_MECH_ID_FROM`),
  KEY `COM_EVNT_TCM` (`CONTACT_MECH_ID_TO`),
  KEY `COM_EVNT_CLST` (`CONTACT_LIST_ID`),
  KEY `COM_EVNT_MIMETYPE` (`CONTENT_MIME_TYPE_ID`),
  KEY `COM_EVNT_RESENUM` (`REASON_ENUM_ID`),
  key `pat_CMMN_EVT_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_CMMN_EVT_TXS` (`CREATED_TX_STAMP`),
  CONSTRAINT `COM_EVNT_CMTP` FOREIGN KEY (`CONTACT_MECH_TYPE_ID`) REFERENCES `contact_mech_type` (`CONTACT_MECH_TYPE_ID`),
  CONSTRAINT `COM_EVNT_FCM` FOREIGN KEY (`CONTACT_MECH_ID_FROM`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `COM_EVNT_FPTY` FOREIGN KEY (`PARTY_ID_FROM`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `COM_EVNT_FRTYP` FOREIGN KEY (`ROLE_TYPE_ID_FROM`) REFERENCES `role_type` (`ROLE_TYPE_ID`),
  CONSTRAINT `COM_EVNT_RESENUM` FOREIGN KEY (`REASON_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `COM_EVNT_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `COM_EVNT_TCM` FOREIGN KEY (`CONTACT_MECH_ID_TO`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `COM_EVNT_TPTY` FOREIGN KEY (`PARTY_ID_TO`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `COM_EVNT_TRTYP` FOREIGN KEY (`ROLE_TYPE_ID_TO`) REFERENCES `role_type` (`ROLE_TYPE_ID`),
  CONSTRAINT `COM_EVNT_TYPE` FOREIGN KEY (`COMMUNICATION_EVENT_TYPE_ID`) REFERENCES `communication_event_type` (`COMMUNICATION_EVENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event_product`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event_product` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COMMUNICATION_EVENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`COMMUNICATION_EVENT_ID`),
  KEY `COMEV_PROD_PROD` (`PRODUCT_ID`),
  KEY `COMEV_PROD_CMEV` (`COMMUNICATION_EVENT_ID`),
  key `CMN_EVT_PRT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CMN_EVT_PRT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `COMEV_PROD_CMEV` FOREIGN KEY (`COMMUNICATION_EVENT_ID`) REFERENCES `communication_event` (`COMMUNICATION_EVENT_ID`),
  CONSTRAINT `COMEV_PROD_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event_prp_typ`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event_prp_typ` (
  `COMMUNICATION_EVENT_PRP_TYP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COMMUNICATION_EVENT_PRP_TYP_ID`),
  KEY `COM_EVNT_PRP_TYP` (`PARENT_TYPE_ID`),
  key `EVT_PRP_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EVT_PRP_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `COM_EVNT_PRP_TYP` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `communication_event_prp_typ` (`COMMUNICATION_EVENT_PRP_TYP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event_purpose`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event_purpose` (
  `COMMUNICATION_EVENT_PRP_TYP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COMMUNICATION_EVENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COMMUNICATION_EVENT_PRP_TYP_ID`,`COMMUNICATION_EVENT_ID`),
  KEY `COM_EVNT_PRP_EVNT` (`COMMUNICATION_EVENT_ID`),
  KEY `COM_EVNT_PRP_TYPE` (`COMMUNICATION_EVENT_PRP_TYP_ID`),
  key `CMN_EVT_PRS_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CMN_EVT_PRS_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `COM_EVNT_PRP_EVNT` FOREIGN KEY (`COMMUNICATION_EVENT_ID`) REFERENCES `communication_event` (`COMMUNICATION_EVENT_ID`),
  CONSTRAINT `COM_EVNT_PRP_TYPE` FOREIGN KEY (`COMMUNICATION_EVENT_PRP_TYP_ID`) REFERENCES `communication_event_prp_typ` (`COMMUNICATION_EVENT_PRP_TYP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event_role` (
  `COMMUNICATION_EVENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COMMUNICATION_EVENT_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `COM_EVRL_CMEV` (`COMMUNICATION_EVENT_ID`),
  KEY `COM_EVRL_PTY` (`PARTY_ID`),
  KEY `COM_EVRL_PRLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `COM_EVRL_CMCH` (`CONTACT_MECH_ID`),
  KEY `COM_EVRL_STTS` (`STATUS_ID`),
  key `CMN_EVT_RL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CMN_EVT_RL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `COM_EVRL_CMCH` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `COM_EVRL_CMEV` FOREIGN KEY (`COMMUNICATION_EVENT_ID`) REFERENCES `communication_event` (`COMMUNICATION_EVENT_ID`),
  CONSTRAINT `COM_EVRL_PRLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `COM_EVRL_PTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `COM_EVRL_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event_type` (
  `COMMUNICATION_EVENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTACT_MECH_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COMMUNICATION_EVENT_TYPE_ID`),
  KEY `COM_EVNT_TYPE_PAR` (`PARENT_TYPE_ID`),
  KEY `COM_EVNT_TYPE_CMT` (`CONTACT_MECH_TYPE_ID`),
  key `CMN_EVT_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CMN_EVT_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `COM_EVNT_TYPE_CMT` FOREIGN KEY (`CONTACT_MECH_TYPE_ID`) REFERENCES `contact_mech_type` (`CONTACT_MECH_TYPE_ID`),
  CONSTRAINT `COM_EVNT_TYPE_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `communication_event_type` (`COMMUNICATION_EVENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_mech` (
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INFO_STRING` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_ID`),
  KEY `CONT_MECH_TYPE` (`CONTACT_MECH_TYPE_ID`),
  key `pat_CNT_MCH_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_CNT_MCH_TXCS` (`CREATED_TX_STAMP`),
  KEY `INFO_STRING_IDX` (`INFO_STRING`),
  CONSTRAINT `CONT_MECH_TYPE` FOREIGN KEY (`CONTACT_MECH_TYPE_ID`) REFERENCES `contact_mech_type` (`CONTACT_MECH_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contact_mech_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_mech_attribute` (
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_ID`,`ATTR_NAME`),
  KEY `CONT_MECH_ATTR` (`CONTACT_MECH_ID`),
  key `CNT_MCH_ATT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CNT_MCH_ATT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CONT_MECH_ATTR` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contact_mech_link`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_mech_link` (
  `CONTACT_MECH_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_ID_FROM`,`CONTACT_MECH_ID_TO`),
  KEY `CONT_MECH_FCMECH` (`CONTACT_MECH_ID_FROM`),
  KEY `CONT_MECH_TCMECH` (`CONTACT_MECH_ID_TO`),
  key `CNT_MCH_LNK_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CNT_MCH_LNK_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CONT_MECH_FCMECH` FOREIGN KEY (`CONTACT_MECH_ID_FROM`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `CONT_MECH_TCMECH` FOREIGN KEY (`CONTACT_MECH_ID_TO`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contact_mech_purpose_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_mech_purpose_type` (
  `CONTACT_MECH_PURPOSE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_PURPOSE_TYPE_ID`),
  key `MCH_PRS_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `MCH_PRS_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contact_mech_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_mech_type` (
  `CONTACT_MECH_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_TYPE_ID`),
  KEY `CONT_MECH_TYP_PAR` (`PARENT_TYPE_ID`),
  key `CNT_MCH_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CNT_MCH_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CONT_MECH_TYP_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `contact_mech_type` (`CONTACT_MECH_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contact_mech_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_mech_type_attr` (
  `CONTACT_MECH_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_TYPE_ID`,`ATTR_NAME`),
  KEY `CONT_MECH_TYP_ATR` (`CONTACT_MECH_TYPE_ID`),
  key `MCH_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `MCH_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CONT_MECH_TYP_ATR` FOREIGN KEY (`CONTACT_MECH_TYPE_ID`) REFERENCES `contact_mech_type` (`CONTACT_MECH_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contact_mech_type_purpose`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_mech_type_purpose` (
  `CONTACT_MECH_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_PURPOSE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_TYPE_ID`,`CONTACT_MECH_PURPOSE_TYPE_ID`),
  KEY `CONT_MECH_TP_TYPE` (`CONTACT_MECH_TYPE_ID`),
  KEY `CONT_MECH_TP_PRPTP` (`CONTACT_MECH_PURPOSE_TYPE_ID`),
  key `MCH_TP_PRS_TP` (`LAST_UPDATED_TX_STAMP`),
  key `MCH_TP_PRS_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CONT_MECH_TP_PRPTP` FOREIGN KEY (`CONTACT_MECH_PURPOSE_TYPE_ID`) REFERENCES `contact_mech_purpose_type` (`CONTACT_MECH_PURPOSE_TYPE_ID`),
  CONSTRAINT `CONT_MECH_TP_TYPE` FOREIGN KEY (`CONTACT_MECH_TYPE_ID`) REFERENCES `contact_mech_type` (`CONTACT_MECH_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_address_verification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_address_verification` (
  `EMAIL_ADDRESS` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VERIFY_HASH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXPIRE_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`EMAIL_ADDRESS`),
  UNIQUE KEY `EMAIL_VERIFY_HASH` (`VERIFY_HASH`),
  key `EML_ADS_VRN_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EML_ADS_VRN_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ftp_address`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ftp_address` (
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `HOSTNAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PORT` decimal(20,0) DEFAULT NULL,
  `USERNAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FTP_PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BINARY_TRANSFER` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FILE_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ZIP_FILE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PASSIVE_MODE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_TIMEOUT` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_ID`),
  KEY `FTP_SRV_CMECH` (`CONTACT_MECH_ID`),
  key `pat_FTP_ADS_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_FTP_ADS_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FTP_SRV_CMECH` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `need_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `need_type` (
  `NEED_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`NEED_TYPE_ID`),
  key `pat_ND_TP_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_ND_TP_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXTERNAL_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PREFERRED_CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DATA_SOURCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_UNREAD` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`),
  KEY `PARTY_PTY_TYP` (`PARTY_TYPE_ID`),
  KEY `PARTY_CUL` (`CREATED_BY_USER_LOGIN`),
  KEY `PARTY_LMCUL` (`LAST_MODIFIED_BY_USER_LOGIN`),
  KEY `PARTY_PREF_CRNCY` (`PREFERRED_CURRENCY_UOM_ID`),
  KEY `PARTY_STATUSITM` (`STATUS_ID`),
  KEY `PARTY_DATSRC` (`DATA_SOURCE_ID`),
  key `part_PRT_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `part_PRT_TXCRTS` (`CREATED_TX_STAMP`),
  KEY `PARTYEXT_ID_IDX` (`EXTERNAL_ID`),
  CONSTRAINT `PARTY_CUL` FOREIGN KEY (`CREATED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PARTY_DATSRC` FOREIGN KEY (`DATA_SOURCE_ID`) REFERENCES `data_source` (`DATA_SOURCE_ID`),
  CONSTRAINT `PARTY_LMCUL` FOREIGN KEY (`LAST_MODIFIED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PARTY_PREF_CRNCY` FOREIGN KEY (`PREFERRED_CURRENCY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PARTY_PTY_TYP` FOREIGN KEY (`PARTY_TYPE_ID`) REFERENCES `party_type` (`PARTY_TYPE_ID`),
  CONSTRAINT `PARTY_STATUSITM` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_attribute` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`ATTR_NAME`),
  KEY `PARTY_ATTR` (`PARTY_ID`),
  key `pat_PRT_ATT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_PRT_ATT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_ATTR` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_carrier_account`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_carrier_account` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CARRIER_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `ACCOUNT_NUMBER` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`CARRIER_PARTY_ID`,`FROM_DATE`),
  KEY `PARTY_CRRACT_PTY` (`PARTY_ID`),
  KEY `PARTY_CRRACT_CPT` (`CARRIER_PARTY_ID`),
  key `PRT_CRR_ACT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CRR_ACT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_CRRACT_CPT` FOREIGN KEY (`CARRIER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `PARTY_CRRACT_PTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_classification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_classification` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_CLASSIFICATION_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`PARTY_CLASSIFICATION_GROUP_ID`,`FROM_DATE`),
  KEY `PARTY_CLASS_PARTY` (`PARTY_ID`),
  KEY `PARTY_CLASS_GRP` (`PARTY_CLASSIFICATION_GROUP_ID`),
  key `pat_PRT_CLSN_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_PRT_CLSN_TXS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_CLASS_GRP` FOREIGN KEY (`PARTY_CLASSIFICATION_GROUP_ID`) REFERENCES `party_classification_group` (`PARTY_CLASSIFICATION_GROUP_ID`),
  CONSTRAINT `PARTY_CLASS_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_classification_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_classification_group` (
  `PARTY_CLASSIFICATION_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_CLASSIFICATION_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_CLASSIFICATION_GROUP_ID`),
  KEY `PARTY_CLASS_GRPPAR` (`PARENT_GROUP_ID`),
  KEY `PARTY_CLSGRP_TYPE` (`PARTY_CLASSIFICATION_TYPE_ID`),
  key `PRT_CLN_GRP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CLN_GRP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_CLASS_GRPPAR` FOREIGN KEY (`PARENT_GROUP_ID`) REFERENCES `party_classification_group` (`PARTY_CLASSIFICATION_GROUP_ID`),
  CONSTRAINT `PARTY_CLSGRP_TYPE` FOREIGN KEY (`PARTY_CLASSIFICATION_TYPE_ID`) REFERENCES `party_classification_type` (`PARTY_CLASSIFICATION_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_classification_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_classification_type` (
  `PARTY_CLASSIFICATION_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_CLASSIFICATION_TYPE_ID`),
  KEY `PARTY_CLASS_TYPPAR` (`PARENT_TYPE_ID`),
  key `PRT_CLN_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CLN_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_CLASS_TYPPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `party_classification_type` (`PARTY_CLASSIFICATION_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_contact_mech` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOW_SOLICITATION` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXTENSION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VERIFIED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `YEARS_WITH_CONTACT_MECH` decimal(20,0) DEFAULT NULL,
  `MONTHS_WITH_CONTACT_MECH` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`CONTACT_MECH_ID`,`FROM_DATE`),
  KEY `PARTY_CMECH_PARTY` (`PARTY_ID`),
  KEY `PARTY_CMECH_PROLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `PARTY_CMECH_ROLE` (`ROLE_TYPE_ID`),
  KEY `PARTY_CMECH_CMECH` (`CONTACT_MECH_ID`),
  key `PRT_CNT_MCH_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CNT_MCH_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_CMECH_CMECH` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `PARTY_CMECH_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `PARTY_CMECH_PROLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `PARTY_CMECH_ROLE` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_contact_mech_purpose`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_contact_mech_purpose` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_PURPOSE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`CONTACT_MECH_ID`,`CONTACT_MECH_PURPOSE_TYPE_ID`,`FROM_DATE`),
  KEY `PARTY_CMPRP_TYPE` (`CONTACT_MECH_PURPOSE_TYPE_ID`),
  KEY `PARTY_CMPRP_PARTY` (`PARTY_ID`),
  KEY `PARTY_CMPRP_CMECH` (`CONTACT_MECH_ID`),
  key `CNT_MCH_PRS_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CNT_MCH_PRS_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_CMPRP_CMECH` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `PARTY_CMPRP_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `PARTY_CMPRP_TYPE` FOREIGN KEY (`CONTACT_MECH_PURPOSE_TYPE_ID`) REFERENCES `contact_mech_purpose_type` (`CONTACT_MECH_PURPOSE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_content_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_content_type` (
  `PARTY_CONTENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_CONTENT_TYPE_ID`),
  KEY `PARTYCNT_TP_PAR` (`PARENT_TYPE_ID`),
  key `PRT_CNT_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CNT_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTYCNT_TP_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `party_content_type` (`PARTY_CONTENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_data_source`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_data_source` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DATA_SOURCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `VISIT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_CREATE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`DATA_SOURCE_ID`,`FROM_DATE`),
  KEY `PARTY_DATSRC_PTY` (`PARTY_ID`),
  KEY `PARTY_DATSRC_DSC` (`DATA_SOURCE_ID`),
  key `PRT_DT_SRC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_DT_SRC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_DATSRC_DSC` FOREIGN KEY (`DATA_SOURCE_ID`) REFERENCES `data_source` (`DATA_SOURCE_ID`),
  CONSTRAINT `PARTY_DATSRC_PTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_geo_point`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_geo_point` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_POINT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`GEO_POINT_ID`,`FROM_DATE`),
  KEY `PARTYGEOPT_PARTY` (`PARTY_ID`),
  KEY `PARTYGEOPT_GEOPT` (`GEO_POINT_ID`),
  key `pat_PRT_G_PNT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_PRT_G_PNT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTYGEOPT_GEOPT` FOREIGN KEY (`GEO_POINT_ID`) REFERENCES `geo_point` (`GEO_POINT_ID`),
  CONSTRAINT `PARTYGEOPT_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_group` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GROUP_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GROUP_NAME_LOCAL` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OFFICE_SITE_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ANNUAL_REVENUE` decimal(18,2) DEFAULT NULL,
  `NUM_EMPLOYEES` decimal(20,0) DEFAULT NULL,
  `TICKER_SYMBOL` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOGO_IMAGE_URL` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`),
  KEY `PARTY_GRP_PARTY` (`PARTY_ID`),
  key `pat_PRT_GRP_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_PRT_GRP_TXCS` (`CREATED_TX_STAMP`),
  KEY `GROUP_NAME_IDX` (`GROUP_NAME`),
  CONSTRAINT `PARTY_GRP_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_ics_avs_override`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_ics_avs_override` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AVS_DECLINE_STRING` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`),
  KEY `PARTY_ICSAVS_PARTY` (`PARTY_ID`),
  key `ICS_AVS_OVD_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ICS_AVS_OVD_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_ICSAVS_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_identification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_identification` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_IDENTIFICATION_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ID_VALUE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`PARTY_IDENTIFICATION_TYPE_ID`),
  KEY `PARTY_ID_TYPE` (`PARTY_IDENTIFICATION_TYPE_ID`),
  KEY `PARTY_ID_PRODUCT` (`PARTY_ID`),
  key `pat_PRT_IDNN_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_PRT_IDNN_TXS` (`CREATED_TX_STAMP`),
  KEY `PARTY_ID_VALIDX` (`ID_VALUE`),
  CONSTRAINT `PARTY_ID_PRODUCT` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `PARTY_ID_TYPE` FOREIGN KEY (`PARTY_IDENTIFICATION_TYPE_ID`) REFERENCES `party_identification_type` (`PARTY_IDENTIFICATION_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_identification_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_identification_type` (
  `PARTY_IDENTIFICATION_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_IDENTIFICATION_TYPE_ID`),
  KEY `PARTY_ID_TYPE_PAR` (`PARENT_TYPE_ID`),
  key `PRT_IDN_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_IDN_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_ID_TYPE_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `party_identification_type` (`PARTY_IDENTIFICATION_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_invitation`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_invitation` (
  `PARTY_INVITATION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_ADDRESS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_INVITE_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_INVITATION_ID`),
  KEY `PTYINV_PTY` (`PARTY_ID_FROM`),
  KEY `PTYINV_STTS` (`STATUS_ID`),
  key `pat_PRT_INN_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_PRT_INN_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PTYINV_PTY` FOREIGN KEY (`PARTY_ID_FROM`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `PTYINV_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_invitation_group_assoc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_invitation_group_assoc` (
  `PARTY_INVITATION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_INVITATION_ID`,`PARTY_ID_TO`),
  KEY `PTYINVGA_PTYGRP` (`PARTY_ID_TO`),
  KEY `PTYINVGA_PTYTO` (`PARTY_ID_TO`),
  KEY `PTYINVGA_PTYINV` (`PARTY_INVITATION_ID`),
  key `INN_GRP_ASC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `INN_GRP_ASC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PTYINVGA_PTYGRP` FOREIGN KEY (`PARTY_ID_TO`) REFERENCES `party_group` (`PARTY_ID`),
  CONSTRAINT `PTYINVGA_PTYINV` FOREIGN KEY (`PARTY_INVITATION_ID`) REFERENCES `party_invitation` (`PARTY_INVITATION_ID`),
  CONSTRAINT `PTYINVGA_PTYTO` FOREIGN KEY (`PARTY_ID_TO`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_invitation_role_assoc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_invitation_role_assoc` (
  `PARTY_INVITATION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_INVITATION_ID`,`ROLE_TYPE_ID`),
  KEY `PTYINVROLE_ROLET` (`ROLE_TYPE_ID`),
  KEY `PTYINVROLE_PTYINV` (`PARTY_INVITATION_ID`),
  key `INN_RL_ASC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `INN_RL_ASC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PTYINVROLE_PTYINV` FOREIGN KEY (`PARTY_INVITATION_ID`) REFERENCES `party_invitation` (`PARTY_INVITATION_ID`),
  CONSTRAINT `PTYINVROLE_ROLET` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_name_history`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_name_history` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CHANGE_DATE` datetime(3) NOT NULL,
  `GROUP_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIRST_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MIDDLE_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PERSONAL_TITLE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUFFIX` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`CHANGE_DATE`),
  KEY `PTY_NMHIS_PARTY` (`PARTY_ID`),
  key `PRT_NM_HSR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_NM_HSR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PTY_NMHIS_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_need`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_need` (
  `PARTY_NEED_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NEED_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMUNICATION_EVENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VISIT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DATETIME_RECORDED` datetime(3) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_NEED_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `PARTY_NEED_NDTP` (`NEED_TYPE_ID`),
  KEY `PARTY_NEED_PTY` (`PARTY_ID`),
  KEY `PARTY_NEED_RTYP` (`ROLE_TYPE_ID`),
  KEY `PARTY_NEED_PTTP` (`PARTY_TYPE_ID`),
  KEY `PARTY_NEED_CMEV` (`COMMUNICATION_EVENT_ID`),
  KEY `PARTY_NEED_PROD` (`PRODUCT_ID`),
  KEY `PARTY_NEED_PCAT` (`PRODUCT_CATEGORY_ID`),
  key `pat_PRT_ND_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_PRT_ND_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_NEED_CMEV` FOREIGN KEY (`COMMUNICATION_EVENT_ID`) REFERENCES `communication_event` (`COMMUNICATION_EVENT_ID`),
  CONSTRAINT `PARTY_NEED_NDTP` FOREIGN KEY (`NEED_TYPE_ID`) REFERENCES `need_type` (`NEED_TYPE_ID`),
  CONSTRAINT `PARTY_NEED_PCAT` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `PARTY_NEED_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `PARTY_NEED_PTTP` FOREIGN KEY (`PARTY_TYPE_ID`) REFERENCES `party_type` (`PARTY_TYPE_ID`),
  CONSTRAINT `PARTY_NEED_PTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `PARTY_NEED_RTYP` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_note`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_note` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `NOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`NOTE_ID`),
  KEY `PARTY_NOTE_PARTY` (`PARTY_ID`),
  KEY `PARTY_NOTE_NOTE` (`NOTE_ID`),
  key `pat_PRT_NT_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_PRT_NT_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_NOTE_NOTE` FOREIGN KEY (`NOTE_ID`) REFERENCES `note_data` (`NOTE_ID`),
  CONSTRAINT `PARTY_NOTE_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_profile_default`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_profile_default` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DEFAULT_SHIP_ADDR` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_BILL_ADDR` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_PAY_METH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_SHIP_METH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`PRODUCT_STORE_ID`),
  KEY `PARTY_PROF_PARTY` (`PARTY_ID`),
  KEY `PARTY_PROF_PSTORE` (`PRODUCT_STORE_ID`),
  key `PRT_PRL_DFT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRL_DFT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_PROF_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `PARTY_PROF_PSTORE` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_relationship`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_relationship` (
  `PARTY_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RELATIONSHIP_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SECURITY_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIORITY_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_RELATIONSHIP_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PERMISSIONS_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `POSITION_TITLE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID_FROM`,`PARTY_ID_TO`,`ROLE_TYPE_ID_FROM`,`ROLE_TYPE_ID_TO`,`FROM_DATE`),
  KEY `PARTY_REL_FPROLE` (`PARTY_ID_FROM`,`ROLE_TYPE_ID_FROM`),
  KEY `PARTY_REL_TPROLE` (`PARTY_ID_TO`,`ROLE_TYPE_ID_TO`),
  KEY `PARTY_REL_STTS` (`STATUS_ID`),
  KEY `PARTY_REL_PRTYP` (`PRIORITY_TYPE_ID`),
  KEY `PARTY_REL_TYPE` (`PARTY_RELATIONSHIP_TYPE_ID`),
  KEY `PARTY_REL_SECGRP` (`SECURITY_GROUP_ID`),
  key `pat_PRT_RLTP_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_PRT_RLTP_TXS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_REL_FPROLE` FOREIGN KEY (`PARTY_ID_FROM`, `ROLE_TYPE_ID_FROM`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `PARTY_REL_PRTYP` FOREIGN KEY (`PRIORITY_TYPE_ID`) REFERENCES `priority_type` (`PRIORITY_TYPE_ID`),
  CONSTRAINT `PARTY_REL_SECGRP` FOREIGN KEY (`SECURITY_GROUP_ID`) REFERENCES `security_group` (`GROUP_ID`),
  CONSTRAINT `PARTY_REL_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `PARTY_REL_TPROLE` FOREIGN KEY (`PARTY_ID_TO`, `ROLE_TYPE_ID_TO`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `PARTY_REL_TYPE` FOREIGN KEY (`PARTY_RELATIONSHIP_TYPE_ID`) REFERENCES `party_relationship_type` (`PARTY_RELATIONSHIP_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_relationship_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_relationship_type` (
  `PARTY_RELATIONSHIP_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_RELATIONSHIP_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROLE_TYPE_ID_VALID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROLE_TYPE_ID_VALID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_RELATIONSHIP_TYPE_ID`),
  KEY `PARTY_RELTYP_PAR` (`PARENT_TYPE_ID`),
  KEY `PARTY_RELTYP_VFRT` (`ROLE_TYPE_ID_VALID_FROM`),
  KEY `PARTY_RELTYP_VTRT` (`ROLE_TYPE_ID_VALID_TO`),
  key `PRT_RLP_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_RLP_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_RELTYP_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `party_relationship_type` (`PARTY_RELATIONSHIP_TYPE_ID`),
  CONSTRAINT `PARTY_RELTYP_VFRT` FOREIGN KEY (`ROLE_TYPE_ID_VALID_FROM`) REFERENCES `role_type` (`ROLE_TYPE_ID`),
  CONSTRAINT `PARTY_RELTYP_VTRT` FOREIGN KEY (`ROLE_TYPE_ID_VALID_TO`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_role` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `PARTY_RLE_PARTY` (`PARTY_ID`),
  KEY `PARTY_RLE_ROLE` (`ROLE_TYPE_ID`),
  key `pat_PRT_RL_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_PRT_RL_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_RLE_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `PARTY_RLE_ROLE` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_status`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_status` (
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_DATE` datetime(3) NOT NULL,
  `CHANGE_BY_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`STATUS_ID`,`PARTY_ID`,`STATUS_DATE`),
  KEY `PARTY_STS_STSITM` (`STATUS_ID`),
  KEY `PARTY_STS_PARTY` (`PARTY_ID`),
  KEY `PARTY_STTS_USRLGN` (`CHANGE_BY_USER_LOGIN_ID`),
  key `pat_PRT_STS_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_PRT_STS_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_STS_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `PARTY_STS_STSITM` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `PARTY_STTS_USRLGN` FOREIGN KEY (`CHANGE_BY_USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_type` (
  `PARTY_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_TYPE_ID`),
  KEY `PARTY_TYPE_PAR` (`PARENT_TYPE_ID`),
  key `pat_PRT_TP_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_PRT_TP_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_TYPE_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `party_type` (`PARTY_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_type_attr` (
  `PARTY_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_TYPE_ID`,`ATTR_NAME`),
  KEY `PARTY_TYP_ATTR` (`PARTY_TYPE_ID`),
  key `PRT_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PARTY_TYP_ATTR` FOREIGN KEY (`PARTY_TYPE_ID`) REFERENCES `party_type` (`PARTY_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `person`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SALUTATION` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIRST_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MIDDLE_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PERSONAL_TITLE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUFFIX` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NICKNAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIRST_NAME_LOCAL` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MIDDLE_NAME_LOCAL` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_NAME_LOCAL` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OTHER_LOCAL` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MEMBER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GENDER` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BIRTH_DATE` date DEFAULT NULL,
  `DECEASED_DATE` date DEFAULT NULL,
  `HEIGHT` double DEFAULT NULL,
  `WEIGHT` double DEFAULT NULL,
  `MOTHERS_MAIDEN_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MARITAL_STATUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MARITAL_STATUS_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SOCIAL_SECURITY_NUMBER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PASSPORT_NUMBER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PASSPORT_EXPIRE_DATE` date DEFAULT NULL,
  `TOTAL_YEARS_WORK_EXPERIENCE` double DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMPLOYMENT_STATUS_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESIDENCE_STATUS_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OCCUPATION` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `YEARS_WITH_EMPLOYER` decimal(20,0) DEFAULT NULL,
  `MONTHS_WITH_EMPLOYER` decimal(20,0) DEFAULT NULL,
  `EXISTING_CUSTOMER` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARD_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`),
  UNIQUE KEY `CARD_ID_IDX` (`CARD_ID`),
  KEY `PERSON_PARTY` (`PARTY_ID`),
  KEY `PERSON_EMPS_ENUM` (`EMPLOYMENT_STATUS_ENUM_ID`),
  KEY `PERSON_RESS_ENUM` (`RESIDENCE_STATUS_ENUM_ID`),
  KEY `PERSON_MARITAL` (`MARITAL_STATUS_ENUM_ID`),
  key `part_PRSN_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `part_PRSN_TXCRTS` (`CREATED_TX_STAMP`),
  KEY `FIRST_NAME_IDX` (`FIRST_NAME`),
  KEY `LAST_NAME_IDX` (`LAST_NAME`),
  CONSTRAINT `PERSON_EMPS_ENUM` FOREIGN KEY (`EMPLOYMENT_STATUS_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PERSON_MARITAL` FOREIGN KEY (`MARITAL_STATUS_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PERSON_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `PERSON_RESS_ENUM` FOREIGN KEY (`RESIDENCE_STATUS_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `postal_address`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `postal_address` (
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TO_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTN_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ADDRESS1` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ADDRESS2` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOUSE_NUMBER` decimal(20,0) DEFAULT NULL,
  `HOUSE_NUMBER_EXT` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DIRECTIONS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CITY` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CITY_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `POSTAL_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `POSTAL_CODE_EXT` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COUNTRY_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATE_PROVINCE_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COUNTY_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MUNICIPALITY_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `POSTAL_CODE_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_POINT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_ID`),
  KEY `POST_ADDR_CMECH` (`CONTACT_MECH_ID`),
  KEY `POST_ADDR_CGEO` (`COUNTRY_GEO_ID`),
  KEY `POST_ADDR_SPGEO` (`STATE_PROVINCE_GEO_ID`),
  KEY `POST_ADDR_CNTG` (`COUNTY_GEO_ID`),
  KEY `POST_ADDR_MNCP` (`MUNICIPALITY_GEO_ID`),
  KEY `POST_ADDR_CITY` (`CITY_GEO_ID`),
  KEY `POST_ADDR_PCGEO` (`POSTAL_CODE_GEO_ID`),
  KEY `POST_ADDR_GEOPT` (`GEO_POINT_ID`),
  key `pat_PSL_ADS_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_PSL_ADS_TXCS` (`CREATED_TX_STAMP`),
  KEY `ADDRESS1_IDX` (`ADDRESS1`),
  KEY `ADDRESS2_IDX` (`ADDRESS2`),
  KEY `CITY_IDX` (`CITY`),
  KEY `POSTAL_CODE_IDX` (`POSTAL_CODE`),
  CONSTRAINT `POST_ADDR_CGEO` FOREIGN KEY (`COUNTRY_GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `POST_ADDR_CITY` FOREIGN KEY (`CITY_GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `POST_ADDR_CMECH` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `POST_ADDR_CNTG` FOREIGN KEY (`COUNTY_GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `POST_ADDR_GEOPT` FOREIGN KEY (`GEO_POINT_ID`) REFERENCES `geo_point` (`GEO_POINT_ID`),
  CONSTRAINT `POST_ADDR_MNCP` FOREIGN KEY (`MUNICIPALITY_GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `POST_ADDR_PCGEO` FOREIGN KEY (`POSTAL_CODE_GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `POST_ADDR_SPGEO` FOREIGN KEY (`STATE_PROVINCE_GEO_ID`) REFERENCES `geo` (`GEO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `postal_address_boundary`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `postal_address_boundary` (
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_ID`,`GEO_ID`),
  KEY `POST_ADDR_BNDRY` (`CONTACT_MECH_ID`),
  KEY `POST_ADDR_BNDRYGEO` (`GEO_ID`),
  key `PSL_ADS_BNR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PSL_ADS_BNR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `POST_ADDR_BNDRY` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `postal_address` (`CONTACT_MECH_ID`),
  CONSTRAINT `POST_ADDR_BNDRYGEO` FOREIGN KEY (`GEO_ID`) REFERENCES `geo` (`GEO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `priority_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `priority_type` (
  `PRIORITY_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRIORITY_TYPE_ID`),
  key `pat_PRT_TP_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_PRT_TP_TXCRS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_type` (
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ROLE_TYPE_ID`),
  KEY `ROLE_TYPE_PAR` (`PARENT_TYPE_ID`),
  key `pat_RL_TP_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_RL_TP_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ROLE_TYPE_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_type_attr` (
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ROLE_TYPE_ID`,`ATTR_NAME`),
  KEY `ROLE_TYPATR_RTYP` (`ROLE_TYPE_ID`),
  key `pat_RL_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_RL_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ROLE_TYPATR_RTYP` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `telecom_number`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `telecom_number` (
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COUNTRY_CODE` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AREA_CODE` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTACT_NUMBER` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASK_FOR_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_ID`),
  KEY `TEL_NUM_CMECH` (`CONTACT_MECH_ID`),
  key `pat_TLM_NMR_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_TLM_NMR_TXCS` (`CREATED_TX_STAMP`),
  KEY `COUNTRY_CODE_IDX` (`COUNTRY_CODE`),
  KEY `AREA_CODE_IDX` (`AREA_CODE`),
  KEY `CONTACT_NUMBER_IDX` (`CONTACT_NUMBER`),
  CONSTRAINT `TEL_NUM_CMECH` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `term_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `term_type` (
  `TERM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`TERM_TYPE_ID`),
  KEY `TERM_TYPE_PAR` (`PARENT_TYPE_ID`),
  key `pat_TRM_TP_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `pat_TRM_TP_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `TERM_TYPE_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `term_type` (`TERM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `term_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `term_type_attr` (
  `TERM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`TERM_TYPE_ID`,`ATTR_NAME`),
  KEY `TERM_TYPATR_TTYP` (`TERM_TYPE_ID`),
  key `TRM_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `TRM_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `TERM_TYPATR_TTYP` FOREIGN KEY (`TERM_TYPE_ID`) REFERENCES `term_type` (`TERM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `valid_contact_mech_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `valid_contact_mech_role` (
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ROLE_TYPE_ID`,`CONTACT_MECH_TYPE_ID`),
  KEY `VAL_CMRLE_ROLE` (`ROLE_TYPE_ID`),
  KEY `VAL_CMRLE_CMTYPE` (`CONTACT_MECH_TYPE_ID`),
  key `CNT_MCH_RL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CNT_MCH_RL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `VAL_CMRLE_CMTYPE` FOREIGN KEY (`CONTACT_MECH_TYPE_ID`) REFERENCES `contact_mech_type` (`CONTACT_MECH_TYPE_ID`),
  CONSTRAINT `VAL_CMRLE_ROLE` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vendor`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendor` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MANIFEST_COMPANY_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MANIFEST_COMPANY_TITLE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MANIFEST_LOGO_URL` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MANIFEST_POLICIES` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`),
  KEY `VENDOR_PARTY` (`PARTY_ID`),
  key `part_VNDR_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `part_VNDR_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `VENDOR_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `config_option_product_option`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config_option_product_option` (
  `CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONFIG_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) NOT NULL,
  `CONFIG_OPTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_OPTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONFIG_ID`,`CONFIG_ITEM_ID`,`CONFIG_OPTION_ID`,`SEQUENCE_NUM`,`PRODUCT_ID`),
  KEY `PROD_OPTN_CONF` (`CONFIG_ID`,`CONFIG_ITEM_ID`,`CONFIG_OPTION_ID`,`SEQUENCE_NUM`),
  KEY `PROD_OPTN_PROD` (`CONFIG_ITEM_ID`,`CONFIG_OPTION_ID`,`PRODUCT_ID`),
  key `OPN_PRT_OPN_TP` (`LAST_UPDATED_TX_STAMP`),
  key `OPN_PRT_OPN_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_OPTN_CONF` FOREIGN KEY (`CONFIG_ID`, `CONFIG_ITEM_ID`, `CONFIG_OPTION_ID`, `SEQUENCE_NUM`) REFERENCES `product_config_config` (`CONFIG_ID`, `CONFIG_ITEM_ID`, `CONFIG_OPTION_ID`, `SEQUENCE_NUM`),
  CONSTRAINT `PROD_OPTN_PROD` FOREIGN KEY (`CONFIG_ITEM_ID`, `CONFIG_OPTION_ID`, `PRODUCT_ID`) REFERENCES `product_config_product` (`CONFIG_ITEM_ID`, `CONFIG_OPTION_ID`, `PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `container`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `container` (
  `CONTAINER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTAINER_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTAINER_ID`),
  KEY `CONTAINER_CTTYP` (`CONTAINER_TYPE_ID`),
  KEY `CONTAINER_FACILITY` (`FACILITY_ID`),
  key `prdt_CNTR_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `prdt_CNTR_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CONTAINER_CTTYP` FOREIGN KEY (`CONTAINER_TYPE_ID`) REFERENCES `container_type` (`CONTAINER_TYPE_ID`),
  CONSTRAINT `CONTAINER_FACILITY` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `container_geo_point`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `container_geo_point` (
  `CONTAINER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_POINT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTAINER_ID`,`GEO_POINT_ID`,`FROM_DATE`),
  KEY `CONTNRGEOPT_CONTNR` (`CONTAINER_ID`),
  KEY `CONTNRGEOPT_GEOPT` (`GEO_POINT_ID`),
  key `prt_CNR_G_PNT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_CNR_G_PNT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CONTNRGEOPT_CONTNR` FOREIGN KEY (`CONTAINER_ID`) REFERENCES `container` (`CONTAINER_ID`),
  CONSTRAINT `CONTNRGEOPT_GEOPT` FOREIGN KEY (`GEO_POINT_ID`) REFERENCES `geo_point` (`GEO_POINT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `container_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `container_type` (
  `CONTAINER_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTAINER_TYPE_ID`),
  key `prt_CNR_TP_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_CNR_TP_TXCRS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cost_component`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost_component` (
  `COST_COMPONENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COST_COMPONENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIXED_ASSET_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COST_COMPONENT_CALC_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `COST` decimal(18,6) DEFAULT NULL,
  `COST_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COST_COMPONENT_ID`),
  KEY `COST_COMP_TYPE` (`COST_COMPONENT_TYPE_ID`),
  KEY `COST_COMP_PRODUCT` (`PRODUCT_ID`),
  KEY `COST_COMP_PRODFEAT` (`PRODUCT_FEATURE_ID`),
  KEY `COST_COMP_PARTY` (`PARTY_ID`),
  KEY `COST_COMP_GEO` (`GEO_ID`),
  KEY `COST_COMP_WEFF` (`WORK_EFFORT_ID`),
  KEY `COST_COMP_FXADSST` (`FIXED_ASSET_ID`),
  KEY `COST_COMP_CALC` (`COST_COMPONENT_CALC_ID`),
  KEY `COST_COMP_CUOM` (`COST_UOM_ID`),
  key `prt_CST_CMT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_CST_CMT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `COST_COMP_CALC` FOREIGN KEY (`COST_COMPONENT_CALC_ID`) REFERENCES `cost_component_calc` (`COST_COMPONENT_CALC_ID`),
  CONSTRAINT `COST_COMP_CUOM` FOREIGN KEY (`COST_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `COST_COMP_GEO` FOREIGN KEY (`GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `COST_COMP_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `COST_COMP_PRODFEAT` FOREIGN KEY (`PRODUCT_FEATURE_ID`) REFERENCES `product_feature` (`PRODUCT_FEATURE_ID`),
  CONSTRAINT `COST_COMP_PRODUCT` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `COST_COMP_TYPE` FOREIGN KEY (`COST_COMPONENT_TYPE_ID`) REFERENCES `cost_component_type` (`COST_COMPONENT_TYPE_ID`),
  CONSTRAINT `COST_COMP_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cost_component_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost_component_attribute` (
  `COST_COMPONENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COST_COMPONENT_ID`,`ATTR_NAME`),
  KEY `COST_COMP_ATTR` (`COST_COMPONENT_ID`),
  key `CST_CMT_ATT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CST_CMT_ATT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `COST_COMP_ATTR` FOREIGN KEY (`COST_COMPONENT_ID`) REFERENCES `cost_component` (`COST_COMPONENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cost_component_calc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost_component_calc` (
  `COST_COMPONENT_CALC_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COST_GL_ACCOUNT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OFFSETTING_GL_ACCOUNT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIXED_COST` decimal(18,2) DEFAULT NULL,
  `VARIABLE_COST` decimal(18,2) DEFAULT NULL,
  `PER_MILLI_SECOND` decimal(20,0) DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COST_CUSTOM_METHOD_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COST_COMPONENT_CALC_ID`),
  KEY `COST_COM_CGLAT` (`COST_GL_ACCOUNT_TYPE_ID`),
  KEY `COST_COM_OGLAT` (`OFFSETTING_GL_ACCOUNT_TYPE_ID`),
  KEY `COST_COM_CUOM` (`CURRENCY_UOM_ID`),
  KEY `COST_COM_CMET` (`COST_CUSTOM_METHOD_ID`),
  key `CST_CMT_CLC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CST_CMT_CLC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `COST_COM_CMET` FOREIGN KEY (`COST_CUSTOM_METHOD_ID`) REFERENCES `custom_method` (`CUSTOM_METHOD_ID`),
  CONSTRAINT `COST_COM_CUOM` FOREIGN KEY (`CURRENCY_UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cost_component_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost_component_type` (
  `COST_COMPONENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COST_COMPONENT_TYPE_ID`),
  KEY `COST_COMP_TYPE_PAR` (`PARENT_TYPE_ID`),
  key `CST_CMT_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CST_CMT_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `COST_COMP_TYPE_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `cost_component_type` (`COST_COMPONENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cost_component_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cost_component_type_attr` (
  `COST_COMPONENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COST_COMPONENT_TYPE_ID`,`ATTR_NAME`),
  KEY `COST_COMP_TATTR` (`COST_COMPONENT_TYPE_ID`),
  key `CMT_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CMT_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `COST_COMP_TATTR` FOREIGN KEY (`COST_COMPONENT_TYPE_ID`) REFERENCES `cost_component_type` (`COST_COMPONENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility` (
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OWNER_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_INVENTORY_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIMARY_FACILITY_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SQUARE_FOOTAGE` decimal(20,0) DEFAULT NULL,
  `FACILITY_SIZE` decimal(18,6) DEFAULT NULL,
  `FACILITY_SIZE_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_DAYS_TO_SHIP` decimal(20,0) DEFAULT NULL,
  `OPENED_DATE` datetime(3) DEFAULT NULL,
  `CLOSED_DATE` datetime(3) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_DIMENSION_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_WEIGHT_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_POINT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_LEVEL` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`),
  KEY `FACILITY_FCTYP` (`FACILITY_TYPE_ID`),
  KEY `FACILITY_PARENT` (`PARENT_FACILITY_ID`),
  KEY `FACILITY_PGRP` (`PRIMARY_FACILITY_GROUP_ID`),
  KEY `FACILITY_OWNER` (`OWNER_PARTY_ID`),
  KEY `FAC_INVITM_TYPE` (`DEFAULT_INVENTORY_ITEM_TYPE_ID`),
  KEY `FAC_DEF_DUOM` (`DEFAULT_DIMENSION_UOM_ID`),
  KEY `FAC_DEF_WUOM` (`DEFAULT_WEIGHT_UOM_ID`),
  KEY `FACILITY_GEOPT` (`GEO_POINT_ID`),
  KEY `FACILITY_SUOM` (`FACILITY_SIZE_UOM_ID`),
  key `prdct_FCT_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `prdct_FCT_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FAC_DEF_DUOM` FOREIGN KEY (`DEFAULT_DIMENSION_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `FAC_DEF_WUOM` FOREIGN KEY (`DEFAULT_WEIGHT_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `FAC_INVITM_TYPE` FOREIGN KEY (`DEFAULT_INVENTORY_ITEM_TYPE_ID`) REFERENCES `inventory_item_type` (`INVENTORY_ITEM_TYPE_ID`),
  CONSTRAINT `FACILITY_FCTYP` FOREIGN KEY (`FACILITY_TYPE_ID`) REFERENCES `facility_type` (`FACILITY_TYPE_ID`),
  CONSTRAINT `FACILITY_GEOPT` FOREIGN KEY (`GEO_POINT_ID`) REFERENCES `geo_point` (`GEO_POINT_ID`),
  CONSTRAINT `FACILITY_OWNER` FOREIGN KEY (`OWNER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `FACILITY_PARENT` FOREIGN KEY (`PARENT_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `FACILITY_PGRP` FOREIGN KEY (`PRIMARY_FACILITY_GROUP_ID`) REFERENCES `facility_group` (`FACILITY_GROUP_ID`),
  CONSTRAINT `FACILITY_SUOM` FOREIGN KEY (`FACILITY_SIZE_UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_assoc_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_assoc_type` (
  `FACILITY_ASSOC_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ASSOC_TYPE_ID`),
  key `FCT_ASC_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FCT_ASC_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_attribute` (
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`ATTR_NAME`),
  KEY `FACILITY_ATTR` (`FACILITY_ID`),
  key `prt_FCT_ATT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_FCT_ATT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FACILITY_ATTR` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_calendar`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_calendar` (
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CALENDAR_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_CALENDAR_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`CALENDAR_ID`,`FACILITY_CALENDAR_TYPE_ID`,`FROM_DATE`),
  KEY `FACILITY_CAL_FAC` (`FACILITY_ID`),
  KEY `FACILITY_CAL_TYPE` (`FACILITY_CALENDAR_TYPE_ID`),
  key `prt_FCT_CLR_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_FCT_CLR_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FACILITY_CAL_FAC` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `FACILITY_CAL_TYPE` FOREIGN KEY (`FACILITY_CALENDAR_TYPE_ID`) REFERENCES `facility_calendar_type` (`FACILITY_CALENDAR_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_calendar_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_calendar_type` (
  `FACILITY_CALENDAR_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_CALENDAR_TYPE_ID`),
  key `FCT_CLR_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FCT_CLR_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_carrier_shipment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_carrier_shipment` (
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`SHIPMENT_METHOD_TYPE_ID`),
  KEY `FACILITY_CSH_PTY` (`PARTY_ID`),
  KEY `FACILITY_CSH_FAC` (`FACILITY_ID`),
  KEY `FACILITY_CSH_STP` (`SHIPMENT_METHOD_TYPE_ID`),
  KEY `FACILITY_CSH_CSM` (`SHIPMENT_METHOD_TYPE_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  key `FCT_CRR_SHT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FCT_CRR_SHT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FACILITY_CSH_CSM` FOREIGN KEY (`SHIPMENT_METHOD_TYPE_ID`, `PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `carrier_shipment_method` (`SHIPMENT_METHOD_TYPE_ID`, `PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `FACILITY_CSH_FAC` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `FACILITY_CSH_PTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `FACILITY_CSH_STP` FOREIGN KEY (`SHIPMENT_METHOD_TYPE_ID`) REFERENCES `shipment_method_type` (`SHIPMENT_METHOD_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_contact_mech` (
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `EXTENSION` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`CONTACT_MECH_ID`,`FROM_DATE`),
  KEY `FACIL_CMECH_FACIL` (`FACILITY_ID`),
  KEY `FACIL_CMECH_CMECH` (`CONTACT_MECH_ID`),
  key `FCT_CNT_MCH_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FCT_CNT_MCH_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FACIL_CMECH_CMECH` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `FACIL_CMECH_FACIL` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_contact_mech_purpose`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_contact_mech_purpose` (
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_PURPOSE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`CONTACT_MECH_ID`,`CONTACT_MECH_PURPOSE_TYPE_ID`,`FROM_DATE`),
  KEY `FACIL_CMPRP_TYPE` (`CONTACT_MECH_PURPOSE_TYPE_ID`),
  KEY `FACIL_CMPRP_FACIL` (`FACILITY_ID`),
  KEY `FACIL_CMPRP_CMECH` (`CONTACT_MECH_ID`),
  key `CNT_MCH_PRS_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CNT_MCH_PRS_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FACIL_CMPRP_CMECH` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `FACIL_CMPRP_FACIL` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `FACIL_CMPRP_TYPE` FOREIGN KEY (`CONTACT_MECH_PURPOSE_TYPE_ID`) REFERENCES `contact_mech_purpose_type` (`CONTACT_MECH_PURPOSE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_group` (
  `FACILITY_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_GROUP_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIMARY_PARENT_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_GROUP_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_GROUP_ID`),
  KEY `FACILITY_GP_TYPE` (`FACILITY_GROUP_TYPE_ID`),
  KEY `FACILITY_GP_PGRP` (`PRIMARY_PARENT_GROUP_ID`),
  key `prt_FCT_GRP_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_FCT_GRP_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FACILITY_GP_PGRP` FOREIGN KEY (`PRIMARY_PARENT_GROUP_ID`) REFERENCES `facility_group` (`FACILITY_GROUP_ID`),
  CONSTRAINT `FACILITY_GP_TYPE` FOREIGN KEY (`FACILITY_GROUP_TYPE_ID`) REFERENCES `facility_group_type` (`FACILITY_GROUP_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_group_member`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_group_member` (
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`FACILITY_GROUP_ID`,`FROM_DATE`),
  KEY `FACILITY_MEM_FAC` (`FACILITY_ID`),
  KEY `FACILITY_MEM_FGRP` (`FACILITY_GROUP_ID`),
  key `FCT_GRP_MMR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FCT_GRP_MMR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FACILITY_MEM_FAC` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `FACILITY_MEM_FGRP` FOREIGN KEY (`FACILITY_GROUP_ID`) REFERENCES `facility_group` (`FACILITY_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_group_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_group_role` (
  `FACILITY_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_GROUP_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `FGROUP_RLE_FGRP` (`FACILITY_GROUP_ID`),
  KEY `FGROUP_RLE_PTRLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  key `FCT_GRP_RL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FCT_GRP_RL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FGROUP_RLE_FGRP` FOREIGN KEY (`FACILITY_GROUP_ID`) REFERENCES `facility_group` (`FACILITY_GROUP_ID`),
  CONSTRAINT `FGROUP_RLE_PTRLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_group_rollup`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_group_rollup` (
  `FACILITY_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_FACILITY_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_GROUP_ID`,`PARENT_FACILITY_GROUP_ID`,`FROM_DATE`),
  KEY `FGRP_FRLP_CURRENT` (`FACILITY_GROUP_ID`),
  KEY `FGRP_FRLP_PARENT` (`PARENT_FACILITY_GROUP_ID`),
  key `FCT_GRP_RLP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FCT_GRP_RLP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FGRP_FRLP_CURRENT` FOREIGN KEY (`FACILITY_GROUP_ID`) REFERENCES `facility_group` (`FACILITY_GROUP_ID`),
  CONSTRAINT `FGRP_FRLP_PARENT` FOREIGN KEY (`PARENT_FACILITY_GROUP_ID`) REFERENCES `facility_group` (`FACILITY_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_group_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_group_type` (
  `FACILITY_GROUP_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_GROUP_TYPE_ID`),
  key `FCT_GRP_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FCT_GRP_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_location`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_location` (
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOCATION_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOCATION_TYPE_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AREA_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AISLE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SECTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LEVEL_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `POSITION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_POINT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`LOCATION_SEQ_ID`),
  KEY `FACILITY_LOC_FAC` (`FACILITY_ID`),
  KEY `FACILITY_LOC_TENM` (`LOCATION_TYPE_ENUM_ID`),
  KEY `FACILITY_LOC_GEOPT` (`GEO_POINT_ID`),
  key `prt_FCT_LCN_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_FCT_LCN_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FACILITY_LOC_FAC` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `FACILITY_LOC_GEOPT` FOREIGN KEY (`GEO_POINT_ID`) REFERENCES `geo_point` (`GEO_POINT_ID`),
  CONSTRAINT `FACILITY_LOC_TENM` FOREIGN KEY (`LOCATION_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_location_geo_point`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_location_geo_point` (
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOCATION_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_POINT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`LOCATION_SEQ_ID`,`GEO_POINT_ID`,`FROM_DATE`),
  KEY `FACLOCGEOPT_FACLOC` (`FACILITY_ID`,`LOCATION_SEQ_ID`),
  KEY `FACLOCGEOPT_GEOPT` (`GEO_POINT_ID`),
  key `FCT_LCN_G_PNT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FCT_LCN_G_PNT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FACLOCGEOPT_FACLOC` FOREIGN KEY (`FACILITY_ID`, `LOCATION_SEQ_ID`) REFERENCES `facility_location` (`FACILITY_ID`, `LOCATION_SEQ_ID`),
  CONSTRAINT `FACLOCGEOPT_GEOPT` FOREIGN KEY (`GEO_POINT_ID`) REFERENCES `geo_point` (`GEO_POINT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_party` (
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`FROM_DATE`),
  KEY `FACILITY_RLE_FACI` (`FACILITY_ID`),
  KEY `FACILITY_RLE_PRT` (`PARTY_ID`),
  KEY `FACILITY_RLE_ROL` (`ROLE_TYPE_ID`),
  KEY `FACILITY_PRTY_ROLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  key `prt_FCT_PRT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_FCT_PRT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FACILITY_PRTY_ROLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `FACILITY_RLE_FACI` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `FACILITY_RLE_PRT` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `FACILITY_RLE_ROL` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_type` (
  `FACILITY_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_TYPE_ID`),
  KEY `FACILITY_TYPEPAR` (`PARENT_TYPE_ID`),
  key `prt_FCT_TP_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_FCT_TP_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FACILITY_TYPEPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `facility_type` (`FACILITY_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_type_attr` (
  `FACILITY_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_TYPE_ID`,`ATTR_NAME`),
  KEY `FACILITY_TPAT_FT` (`FACILITY_TYPE_ID`),
  key `FCT_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FCT_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `FACILITY_TPAT_FT` FOREIGN KEY (`FACILITY_TYPE_ID`) REFERENCES `facility_type` (`FACILITY_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `good_identification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `good_identification` (
  `GOOD_IDENTIFICATION_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ID_VALUE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`GOOD_IDENTIFICATION_TYPE_ID`,`PRODUCT_ID`),
  KEY `GOOD_ID_TYPE` (`GOOD_IDENTIFICATION_TYPE_ID`),
  KEY `GOOD_ID_PRODICT` (`PRODUCT_ID`),
  key `prt_GD_IDNTN_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_GD_IDNTN_TXS` (`CREATED_TX_STAMP`),
  KEY `GOOD_ID_VALIDX` (`ID_VALUE`),
  CONSTRAINT `GOOD_ID_PRODICT` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `GOOD_ID_TYPE` FOREIGN KEY (`GOOD_IDENTIFICATION_TYPE_ID`) REFERENCES `good_identification_type` (`GOOD_IDENTIFICATION_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `good_identification_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `good_identification_type` (
  `GOOD_IDENTIFICATION_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`GOOD_IDENTIFICATION_TYPE_ID`),
  KEY `GOOD_ID_TYPE_PAR` (`PARENT_TYPE_ID`),
  key `prt_GD_IDN_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_GD_IDN_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `GOOD_ID_TYPE_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `good_identification_type` (`GOOD_IDENTIFICATION_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventory_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_item` (
  `INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVENTORY_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OWNER_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DATETIME_RECEIVED` datetime(3) DEFAULT NULL,
  `DATETIME_MANUFACTURED` datetime(3) DEFAULT NULL,
  `EXPIRE_DATE` datetime(3) DEFAULT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTAINER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BIN_NUMBER` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOCATION_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY_ON_HAND_TOTAL` decimal(18,6) DEFAULT NULL,
  `AVAILABLE_TO_PROMISE_TOTAL` decimal(18,6) DEFAULT NULL,
  `ACCOUNTING_QUANTITY_TOTAL` decimal(18,6) DEFAULT NULL,
  `SERIAL_NUMBER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SOFT_IDENTIFIER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACTIVATION_NUMBER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACTIVATION_VALID_THRU` datetime(3) DEFAULT NULL,
  `UNIT_COST` decimal(18,6) DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIXED_ASSET_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVENTORY_ITEM_ID`),
  UNIQUE KEY `INVITEM_SOFID` (`SOFT_IDENTIFIER`),
  UNIQUE KEY `INVITEM_ACTNM` (`ACTIVATION_NUMBER`),
  KEY `INV_ITEM_TYPE` (`INVENTORY_ITEM_TYPE_ID`),
  KEY `INV_ITEM_PRODUCT` (`PRODUCT_ID`),
  KEY `INV_ITEM_PARTY` (`PARTY_ID`),
  KEY `INV_ITEM_OWNPARTY` (`OWNER_PARTY_ID`),
  KEY `INV_ITEM_STTSITM` (`STATUS_ID`),
  KEY `INV_ITEM_FACILITY` (`FACILITY_ID`),
  KEY `INV_ITEM_CONTAINER` (`CONTAINER_ID`),
  KEY `INV_ITEM_LOT` (`LOT_ID`),
  KEY `INV_ITEM_UOM` (`UOM_ID`),
  KEY `INV_ITEM_CUOM` (`CURRENCY_UOM_ID`),
  KEY `IYIM_FAST` (`FIXED_ASSET_ID`),
  key `prt_INR_ITM_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_INR_ITM_TXCS` (`CREATED_TX_STAMP`),
  KEY `INV_ITEM_SN` (`SERIAL_NUMBER`),
  CONSTRAINT `INV_ITEM_CONTAINER` FOREIGN KEY (`CONTAINER_ID`) REFERENCES `container` (`CONTAINER_ID`),
  CONSTRAINT `INV_ITEM_CUOM` FOREIGN KEY (`CURRENCY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `INV_ITEM_FACILITY` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `INV_ITEM_LOT` FOREIGN KEY (`LOT_ID`) REFERENCES `lot` (`LOT_ID`),
  CONSTRAINT `INV_ITEM_OWNPARTY` FOREIGN KEY (`OWNER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `INV_ITEM_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `INV_ITEM_PRODUCT` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `INV_ITEM_STTSITM` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `INV_ITEM_TYPE` FOREIGN KEY (`INVENTORY_ITEM_TYPE_ID`) REFERENCES `inventory_item_type` (`INVENTORY_ITEM_TYPE_ID`),
  CONSTRAINT `INV_ITEM_UOM` FOREIGN KEY (`UOM_ID`) REFERENCES `uom` (`UOM_ID`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventory_item_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_item_attribute` (
  `INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVENTORY_ITEM_ID`,`ATTR_NAME`),
  KEY `INV_ITEM_ATTR` (`INVENTORY_ITEM_ID`),
  key `INR_ITM_ATT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `INR_ITM_ATT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `INV_ITEM_ATTR` FOREIGN KEY (`INVENTORY_ITEM_ID`) REFERENCES `inventory_item` (`INVENTORY_ITEM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventory_item_detail`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_item_detail` (
  `INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVENTORY_ITEM_DETAIL_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `EFFECTIVE_DATE` datetime(3) DEFAULT NULL,
  `QUANTITY_ON_HAND_DIFF` decimal(18,6) DEFAULT NULL,
  `AVAILABLE_TO_PROMISE_DIFF` decimal(18,6) DEFAULT NULL,
  `ACCOUNTING_QUANTITY_DIFF` decimal(18,6) DEFAULT NULL,
  `UNIT_COST` decimal(18,6) DEFAULT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIXED_ASSET_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MAINT_HIST_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ITEM_ISSUANCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECEIPT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PHYSICAL_INVENTORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REASON_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVENTORY_ITEM_ID`,`INVENTORY_ITEM_DETAIL_SEQ_ID`),
  KEY `INV_ITDTL_INVIT` (`INVENTORY_ITEM_ID`),
  KEY `INV_ITDTL_WEFF` (`WORK_EFFORT_ID`),
  KEY `INV_ITDTL_FAMNT` (`FIXED_ASSET_ID`,`MAINT_HIST_SEQ_ID`),
  KEY `INV_ITDTL_ITMIS` (`ITEM_ISSUANCE_ID`),
  KEY `INV_ITDTL_SHRCT` (`RECEIPT_ID`),
  KEY `INV_ITDTL_PHINV` (`PHYSICAL_INVENTORY_ID`),
  KEY `INV_ITDTL_REAS` (`REASON_ENUM_ID`),
  key `INR_ITM_DTL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `INR_ITM_DTL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `INV_ITDTL_INVIT` FOREIGN KEY (`INVENTORY_ITEM_ID`) REFERENCES `inventory_item` (`INVENTORY_ITEM_ID`),
  CONSTRAINT `INV_ITDTL_ITMIS` FOREIGN KEY (`ITEM_ISSUANCE_ID`) REFERENCES `item_issuance` (`ITEM_ISSUANCE_ID`),
  CONSTRAINT `INV_ITDTL_PHINV` FOREIGN KEY (`PHYSICAL_INVENTORY_ID`) REFERENCES `physical_inventory` (`PHYSICAL_INVENTORY_ID`),
  CONSTRAINT `INV_ITDTL_REAS` FOREIGN KEY (`REASON_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `INV_ITDTL_SHRCT` FOREIGN KEY (`RECEIPT_ID`) REFERENCES `shipment_receipt` (`RECEIPT_ID`),
  CONSTRAINT `INV_ITDTL_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventory_item_label`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_item_label` (
  `INVENTORY_ITEM_LABEL_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVENTORY_ITEM_LABEL_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVENTORY_ITEM_LABEL_ID`),
  KEY `INV_ITLA_TYPE` (`INVENTORY_ITEM_LABEL_TYPE_ID`),
  key `INR_ITM_LBL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `INR_ITM_LBL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `INV_ITLA_TYPE` FOREIGN KEY (`INVENTORY_ITEM_LABEL_TYPE_ID`) REFERENCES `inventory_item_label_type` (`INVENTORY_ITEM_LABEL_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventory_item_label_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_item_label_appl` (
  `INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVENTORY_ITEM_LABEL_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVENTORY_ITEM_LABEL_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVENTORY_ITEM_ID`,`INVENTORY_ITEM_LABEL_TYPE_ID`),
  KEY `INV_ITLAP_ITEM` (`INVENTORY_ITEM_ID`),
  KEY `INV_ITLAP_TYPE` (`INVENTORY_ITEM_LABEL_TYPE_ID`),
  KEY `INV_ITLAP_LAB` (`INVENTORY_ITEM_LABEL_ID`),
  key `ITM_LBL_APL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ITM_LBL_APL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `INV_ITLAP_ITEM` FOREIGN KEY (`INVENTORY_ITEM_ID`) REFERENCES `inventory_item` (`INVENTORY_ITEM_ID`),
  CONSTRAINT `INV_ITLAP_LAB` FOREIGN KEY (`INVENTORY_ITEM_LABEL_ID`) REFERENCES `inventory_item_label` (`INVENTORY_ITEM_LABEL_ID`),
  CONSTRAINT `INV_ITLAP_TYPE` FOREIGN KEY (`INVENTORY_ITEM_LABEL_TYPE_ID`) REFERENCES `inventory_item_label_type` (`INVENTORY_ITEM_LABEL_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventory_item_label_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_item_label_type` (
  `INVENTORY_ITEM_LABEL_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVENTORY_ITEM_LABEL_TYPE_ID`),
  KEY `INV_ITLT_TYPPAR` (`PARENT_TYPE_ID`),
  key `ITM_LBL_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ITM_LBL_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `INV_ITLT_TYPPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `inventory_item_label_type` (`INVENTORY_ITEM_LABEL_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventory_item_status`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_item_status` (
  `INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_DATETIME` datetime(3) NOT NULL,
  `STATUS_END_DATETIME` datetime(3) DEFAULT NULL,
  `CHANGE_BY_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OWNER_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVENTORY_ITEM_ID`,`STATUS_ID`,`STATUS_DATETIME`),
  KEY `INV_ITEM_STTS_II` (`INVENTORY_ITEM_ID`),
  KEY `INV_ITEM_STTS_SI` (`STATUS_ID`),
  KEY `INV_ITEM_STTS_USER` (`CHANGE_BY_USER_LOGIN_ID`),
  key `INR_ITM_STS_TP` (`LAST_UPDATED_TX_STAMP`),
  key `INR_ITM_STS_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `INV_ITEM_STTS_II` FOREIGN KEY (`INVENTORY_ITEM_ID`) REFERENCES `inventory_item` (`INVENTORY_ITEM_ID`),
  CONSTRAINT `INV_ITEM_STTS_SI` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `INV_ITEM_STTS_USER` FOREIGN KEY (`CHANGE_BY_USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventory_item_temp_res`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_item_temp_res` (
  `VISIT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `RESERVED_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`VISIT_ID`,`PRODUCT_ID`,`PRODUCT_STORE_ID`),
  KEY `INV_ITEM_TR_PROD` (`PRODUCT_ID`),
  KEY `INV_ITEM_TR_PRDS` (`PRODUCT_STORE_ID`),
  key `ITM_TMP_RS_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ITM_TMP_RS_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `INV_ITEM_TR_PRDS` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `INV_ITEM_TR_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventory_item_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_item_type` (
  `INVENTORY_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVENTORY_ITEM_TYPE_ID`),
  KEY `INV_ITEM_TYPPAR` (`PARENT_TYPE_ID`),
  key `INR_ITM_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `INR_ITM_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `INV_ITEM_TYPPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `inventory_item_type` (`INVENTORY_ITEM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventory_item_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_item_type_attr` (
  `INVENTORY_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVENTORY_ITEM_TYPE_ID`,`ATTR_NAME`),
  KEY `INV_ITEM_TYP_ATTR` (`INVENTORY_ITEM_TYPE_ID`),
  key `ITM_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ITM_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `INV_ITEM_TYP_ATTR` FOREIGN KEY (`INVENTORY_ITEM_TYPE_ID`) REFERENCES `inventory_item_type` (`INVENTORY_ITEM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventory_item_variance`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_item_variance` (
  `INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PHYSICAL_INVENTORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VARIANCE_REASON_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AVAILABLE_TO_PROMISE_VAR` decimal(18,6) DEFAULT NULL,
  `QUANTITY_ON_HAND_VAR` decimal(18,6) DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVENTORY_ITEM_ID`,`PHYSICAL_INVENTORY_ID`),
  KEY `INV_ITEM_VAR_PINV` (`PHYSICAL_INVENTORY_ID`),
  KEY `INV_ITEM_VAR_RSN` (`VARIANCE_REASON_ID`),
  KEY `INV_ITEM_VAR_ITEM` (`INVENTORY_ITEM_ID`),
  key `INR_ITM_VRC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `INR_ITM_VRC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `INV_ITEM_VAR_ITEM` FOREIGN KEY (`INVENTORY_ITEM_ID`) REFERENCES `inventory_item` (`INVENTORY_ITEM_ID`),
  CONSTRAINT `INV_ITEM_VAR_PINV` FOREIGN KEY (`PHYSICAL_INVENTORY_ID`) REFERENCES `physical_inventory` (`PHYSICAL_INVENTORY_ID`),
  CONSTRAINT `INV_ITEM_VAR_RSN` FOREIGN KEY (`VARIANCE_REASON_ID`) REFERENCES `variance_reason` (`VARIANCE_REASON_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventory_transfer`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_transfer` (
  `INVENTORY_TRANSFER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOCATION_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTAINER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOCATION_SEQ_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTAINER_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ITEM_ISSUANCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEND_DATE` datetime(3) DEFAULT NULL,
  `RECEIVE_DATE` datetime(3) DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVENTORY_TRANSFER_ID`),
  KEY `INV_XFER_ITEM` (`INVENTORY_ITEM_ID`),
  KEY `INV_XFER_STTS` (`STATUS_ID`),
  KEY `INV_XFER_FAC` (`FACILITY_ID`),
  KEY `INV_XFER_CONT` (`CONTAINER_ID`),
  KEY `INV_XFER_TFAC` (`FACILITY_ID_TO`),
  KEY `INV_XFER_TCNT` (`CONTAINER_ID_TO`),
  KEY `INV_XFER_ISSU` (`ITEM_ISSUANCE_ID`),
  key `prt_INR_TRR_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_INR_TRR_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `INV_XFER_CONT` FOREIGN KEY (`CONTAINER_ID`) REFERENCES `container` (`CONTAINER_ID`),
  CONSTRAINT `INV_XFER_FAC` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `INV_XFER_ISSU` FOREIGN KEY (`ITEM_ISSUANCE_ID`) REFERENCES `item_issuance` (`ITEM_ISSUANCE_ID`),
  CONSTRAINT `INV_XFER_ITEM` FOREIGN KEY (`INVENTORY_ITEM_ID`) REFERENCES `inventory_item` (`INVENTORY_ITEM_ID`),
  CONSTRAINT `INV_XFER_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `INV_XFER_TCNT` FOREIGN KEY (`CONTAINER_ID_TO`) REFERENCES `container` (`CONTAINER_ID`),
  CONSTRAINT `INV_XFER_TFAC` FOREIGN KEY (`FACILITY_ID_TO`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lot`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lot` (
  `LOT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CREATION_DATE` datetime(3) DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `EXPIRATION_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`LOT_ID`),
  key `prdct_LT_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `prdct_LT_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `market_interest`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `market_interest` (
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_CLASSIFICATION_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`,`PARTY_CLASSIFICATION_GROUP_ID`,`FROM_DATE`),
  KEY `MARKET_INT_PCAT` (`PRODUCT_CATEGORY_ID`),
  KEY `MARKET_INT_PCGRP` (`PARTY_CLASSIFICATION_GROUP_ID`),
  key `prt_MRT_INT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_MRT_INT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `MARKET_INT_PCAT` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `MARKET_INT_PCGRP` FOREIGN KEY (`PARTY_CLASSIFICATION_GROUP_ID`) REFERENCES `party_classification_group` (`PARTY_CLASSIFICATION_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `physical_inventory`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `physical_inventory` (
  `PHYSICAL_INVENTORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PHYSICAL_INVENTORY_DATE` datetime(3) DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GENERAL_COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PHYSICAL_INVENTORY_ID`),
  key `prt_PHL_INR_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PHL_INR_TXCS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prod_catalog`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_catalog` (
  `PROD_CATALOG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CATALOG_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USE_QUICK_ADD` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STYLE_SHEET` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HEADER_LOGO` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_PATH_PREFIX` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TEMPLATE_PATH_PREFIX` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VIEW_ALLOW_PERM_REQD` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PURCHASE_ALLOW_PERM_REQD` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PROD_CATALOG_ID`),
  key `prt_PRD_CTG_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRD_CTG_TXCS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prod_catalog_category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_catalog_category` (
  `PROD_CATALOG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PROD_CATALOG_CATEGORY_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PROD_CATALOG_ID`,`PRODUCT_CATEGORY_ID`,`PROD_CATALOG_CATEGORY_TYPE_ID`,`FROM_DATE`),
  KEY `PROD_CC_CATALOG` (`PROD_CATALOG_ID`),
  KEY `PROD_CC_CATEGORY` (`PRODUCT_CATEGORY_ID`),
  KEY `PROD_CC_TYPE` (`PROD_CATALOG_CATEGORY_TYPE_ID`),
  key `PRD_CTG_CTR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRD_CTG_CTR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_CC_CATALOG` FOREIGN KEY (`PROD_CATALOG_ID`) REFERENCES `prod_catalog` (`PROD_CATALOG_ID`),
  CONSTRAINT `PROD_CC_CATEGORY` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `PROD_CC_TYPE` FOREIGN KEY (`PROD_CATALOG_CATEGORY_TYPE_ID`) REFERENCES `prod_catalog_category_type` (`PROD_CATALOG_CATEGORY_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prod_catalog_category_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_catalog_category_type` (
  `PROD_CATALOG_CATEGORY_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PROD_CATALOG_CATEGORY_TYPE_ID`),
  KEY `PROD_PCCT_TYPEPAR` (`PARENT_TYPE_ID`),
  key `CTG_CTR_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CTG_CTR_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_PCCT_TYPEPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `prod_catalog_category_type` (`PROD_CATALOG_CATEGORY_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prod_catalog_inv_facility`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_catalog_inv_facility` (
  `PROD_CATALOG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PROD_CATALOG_ID`,`FACILITY_ID`,`FROM_DATE`),
  KEY `PROD_CIF_CATALOG` (`PROD_CATALOG_ID`),
  KEY `PROD_CIF_FACILITY` (`FACILITY_ID`),
  key `CTG_INV_FCT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CTG_INV_FCT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_CIF_CATALOG` FOREIGN KEY (`PROD_CATALOG_ID`) REFERENCES `prod_catalog` (`PROD_CATALOG_ID`),
  CONSTRAINT `PROD_CIF_FACILITY` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prod_catalog_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_catalog_role` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PROD_CATALOG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`ROLE_TYPE_ID`,`PROD_CATALOG_ID`,`FROM_DATE`),
  KEY `PCATRLE_PTYRLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `PCATRLE_CATALOG` (`PROD_CATALOG_ID`),
  key `PRD_CTG_RL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRD_CTG_RL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PCATRLE_CATALOG` FOREIGN KEY (`PROD_CATALOG_ID`) REFERENCES `prod_catalog` (`PROD_CATALOG_ID`),
  CONSTRAINT `PCATRLE_PTYRLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prod_promo_code_contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_promo_code_contact_mech` (
  `PRODUCT_PROMO_CODE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PROMO_CODE_ID`,`CONTACT_MECH_ID`),
  KEY `PROD_PRCDE_PCD` (`PRODUCT_PROMO_CODE_ID`),
  KEY `PROD_PRCDE_CM` (`CONTACT_MECH_ID`),
  key `CD_CNT_MCH_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CD_CNT_MCH_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_PRCDE_CM` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `PROD_PRCDE_PCD` FOREIGN KEY (`PRODUCT_PROMO_CODE_ID`) REFERENCES `product_promo_code` (`PRODUCT_PROMO_CODE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIMARY_PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INTRODUCTION_DATE` datetime(3) DEFAULT NULL,
  `RELEASE_DATE` datetime(3) DEFAULT NULL,
  `SUPPORT_DISCONTINUATION_DATE` datetime(3) DEFAULT NULL,
  `SALES_DISCONTINUATION_DATE` datetime(3) DEFAULT NULL,
  `SALES_DISC_WHEN_NOT_AVAIL` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INTERNAL_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BRAND_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LONG_DESCRIPTION` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `PRICE_DETAIL_TEXT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SMALL_IMAGE_URL` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MEDIUM_IMAGE_URL` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LARGE_IMAGE_URL` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DETAIL_IMAGE_URL` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGINAL_IMAGE_URL` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DETAIL_SCREEN` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVENTORY_MESSAGE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVENTORY_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIRE_INVENTORY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY_INCLUDED` decimal(18,6) DEFAULT NULL,
  `PIECES_INCLUDED` decimal(20,0) DEFAULT NULL,
  `REQUIRE_AMOUNT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIXED_AMOUNT` decimal(18,2) DEFAULT NULL,
  `AMOUNT_UOM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WEIGHT_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPPING_WEIGHT` decimal(18,6) DEFAULT NULL,
  `PRODUCT_WEIGHT` decimal(18,6) DEFAULT NULL,
  `HEIGHT_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_HEIGHT` decimal(18,6) DEFAULT NULL,
  `SHIPPING_HEIGHT` decimal(18,6) DEFAULT NULL,
  `WIDTH_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_WIDTH` decimal(18,6) DEFAULT NULL,
  `SHIPPING_WIDTH` decimal(18,6) DEFAULT NULL,
  `DEPTH_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_DEPTH` decimal(18,6) DEFAULT NULL,
  `SHIPPING_DEPTH` decimal(18,6) DEFAULT NULL,
  `DIAMETER_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_DIAMETER` decimal(18,6) DEFAULT NULL,
  `PRODUCT_RATING` decimal(18,6) DEFAULT NULL,
  `RATING_TYPE_ENUM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURNABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TAXABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHARGE_SHIPPING` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTO_CREATE_KEYWORDS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INCLUDE_IN_PROMOTIONS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_VIRTUAL` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_VARIANT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VIRTUAL_VARIANT_METHOD_ENUM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIREMENT_METHOD_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BILL_OF_MATERIAL_LEVEL` decimal(20,0) DEFAULT NULL,
  `RESERV_MAX_PERSONS` decimal(18,6) DEFAULT NULL,
  `RESERV2ND_P_P_PERC` decimal(18,6) DEFAULT NULL,
  `RESERV_NTH_P_P_PERC` decimal(18,6) DEFAULT NULL,
  `CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IN_SHIPPING_BOX` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_SHIPMENT_BOX_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOT_ID_FILLED_IN` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_DECIMAL_QUANTITY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`),
  KEY `PROD_TYPE` (`PRODUCT_TYPE_ID`),
  KEY `PROD_PRIMARY_CAT` (`PRIMARY_PRODUCT_CATEGORY_ID`),
  KEY `PROD_FACILITY` (`FACILITY_ID`),
  KEY `PROD_QUANT_UOM` (`QUANTITY_UOM_ID`),
  KEY `PROD_AMOUNT_UOMT` (`AMOUNT_UOM_TYPE_ID`),
  KEY `PROD_WEIGHT_UOM` (`WEIGHT_UOM_ID`),
  KEY `PROD_HEIGHT_UOM` (`HEIGHT_UOM_ID`),
  KEY `PROD_WIDTH_UOM` (`WIDTH_UOM_ID`),
  KEY `PROD_DEPTH_UOM` (`DEPTH_UOM_ID`),
  KEY `PROD_DIAMTR_UOM` (`DIAMETER_UOM_ID`),
  KEY `PROD_VVMETHOD_ENUM` (`VIRTUAL_VARIANT_METHOD_ENUM`),
  KEY `PROD_RATE_ENUM` (`RATING_TYPE_ENUM`),
  KEY `PROD_RQMT_ENUM` (`REQUIREMENT_METHOD_ENUM_ID`),
  KEY `PROD_ORG_GEO` (`ORIGIN_GEO_ID`),
  KEY `PROD_CB_USERLOGIN` (`CREATED_BY_USER_LOGIN`),
  KEY `PROD_LMB_USERLOGIN` (`LAST_MODIFIED_BY_USER_LOGIN`),
  KEY `PROD_SHBX_TYPE` (`DEFAULT_SHIPMENT_BOX_TYPE_ID`),
  KEY `PROD_INV_ITEM_TYPE` (`INVENTORY_ITEM_TYPE_ID`),
  key `prdt_PRDT_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `prdt_PRDT_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_AMOUNT_UOMT` FOREIGN KEY (`AMOUNT_UOM_TYPE_ID`) REFERENCES `uom_type` (`UOM_TYPE_ID`),
  CONSTRAINT `PROD_CB_USERLOGIN` FOREIGN KEY (`CREATED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PROD_DEPTH_UOM` FOREIGN KEY (`DEPTH_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PROD_DIAMTR_UOM` FOREIGN KEY (`DIAMETER_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PROD_FACILITY` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `PROD_HEIGHT_UOM` FOREIGN KEY (`HEIGHT_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PROD_INV_ITEM_TYPE` FOREIGN KEY (`INVENTORY_ITEM_TYPE_ID`) REFERENCES `inventory_item_type` (`INVENTORY_ITEM_TYPE_ID`),
  CONSTRAINT `PROD_LMB_USERLOGIN` FOREIGN KEY (`LAST_MODIFIED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PROD_ORG_GEO` FOREIGN KEY (`ORIGIN_GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `PROD_PRIMARY_CAT` FOREIGN KEY (`PRIMARY_PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `PROD_QUANT_UOM` FOREIGN KEY (`QUANTITY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PROD_RATE_ENUM` FOREIGN KEY (`RATING_TYPE_ENUM`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PROD_RQMT_ENUM` FOREIGN KEY (`REQUIREMENT_METHOD_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PROD_SHBX_TYPE` FOREIGN KEY (`DEFAULT_SHIPMENT_BOX_TYPE_ID`) REFERENCES `shipment_box_type` (`SHIPMENT_BOX_TYPE_ID`),
  CONSTRAINT `PROD_TYPE` FOREIGN KEY (`PRODUCT_TYPE_ID`) REFERENCES `product_type` (`PRODUCT_TYPE_ID`),
  CONSTRAINT `PROD_VVMETHOD_ENUM` FOREIGN KEY (`VIRTUAL_VARIANT_METHOD_ENUM`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PROD_WEIGHT_UOM` FOREIGN KEY (`WEIGHT_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PROD_WIDTH_UOM` FOREIGN KEY (`WIDTH_UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_assoc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_assoc` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ASSOC_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `REASON` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `SCRAP_FACTOR` decimal(18,6) DEFAULT NULL,
  `INSTRUCTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROUTING_WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ESTIMATE_CALC_METHOD` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECURRENCE_INFO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`PRODUCT_ID_TO`,`PRODUCT_ASSOC_TYPE_ID`,`FROM_DATE`),
  KEY `PROD_ASSOC_TYPE` (`PRODUCT_ASSOC_TYPE_ID`),
  KEY `PROD_ASSOC_MPROD` (`PRODUCT_ID`),
  KEY `PROD_ASSOC_APROD` (`PRODUCT_ID_TO`),
  KEY `PROD_ASSOC_RTWE` (`ROUTING_WORK_EFFORT_ID`),
  KEY `PROD_ASSOC_CUSM` (`ESTIMATE_CALC_METHOD`),
  KEY `PROD_ASSOC_RECINFO` (`RECURRENCE_INFO_ID`),
  key `prt_PRT_ASC_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_ASC_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_ASSOC_APROD` FOREIGN KEY (`PRODUCT_ID_TO`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `PROD_ASSOC_CUSM` FOREIGN KEY (`ESTIMATE_CALC_METHOD`) REFERENCES `custom_method` (`CUSTOM_METHOD_ID`),
  CONSTRAINT `PROD_ASSOC_MPROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `PROD_ASSOC_RECINFO` FOREIGN KEY (`RECURRENCE_INFO_ID`) REFERENCES `recurrence_info` (`RECURRENCE_INFO_ID`),
  CONSTRAINT `PROD_ASSOC_RTWE` FOREIGN KEY (`ROUTING_WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`),
  CONSTRAINT `PROD_ASSOC_TYPE` FOREIGN KEY (`PRODUCT_ASSOC_TYPE_ID`) REFERENCES `product_assoc_type` (`PRODUCT_ASSOC_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_assoc_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_assoc_type` (
  `PRODUCT_ASSOC_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ASSOC_TYPE_ID`),
  KEY `PROD_ASSOC_TYPEPAR` (`PARENT_TYPE_ID`),
  key `PRT_ASC_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_ASC_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_ASSOC_TYPEPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `product_assoc_type` (`PRODUCT_ASSOC_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_attribute` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_TYPE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`ATTR_NAME`),
  KEY `PROD_ATTR` (`PRODUCT_ID`),
  key `prt_PRT_ATT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_ATT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_ATTR` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_calculated_info`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_calculated_info` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TOTAL_QUANTITY_ORDERED` decimal(18,6) DEFAULT NULL,
  `TOTAL_TIMES_VIEWED` decimal(20,0) DEFAULT NULL,
  `AVERAGE_CUSTOMER_RATING` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`),
  KEY `PRODCI_PROD` (`PRODUCT_ID`),
  key `PRT_CLD_INF_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CLD_INF_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRODCI_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category` (
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_CATEGORY_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIMARY_PARENT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CATEGORY_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LONG_DESCRIPTION` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `CATEGORY_IMAGE_URL` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LINK_ONE_IMAGE_URL` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LINK_TWO_IMAGE_URL` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DETAIL_SCREEN` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHOW_IN_SELECT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`),
  KEY `PROD_CTGRY_TYPE` (`PRODUCT_CATEGORY_TYPE_ID`),
  KEY `PROD_CTGRY_PARENT` (`PRIMARY_PARENT_CATEGORY_ID`),
  key `prt_PRT_CTR_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_CTR_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_CTGRY_PARENT` FOREIGN KEY (`PRIMARY_PARENT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `PROD_CTGRY_TYPE` FOREIGN KEY (`PRODUCT_CATEGORY_TYPE_ID`) REFERENCES `product_category_type` (`PRODUCT_CATEGORY_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_attribute` (
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`,`ATTR_NAME`),
  KEY `PROD_CTGRY_ATTR` (`PRODUCT_CATEGORY_ID`),
  key `PRT_CTR_ATT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CTR_ATT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_CTGRY_ATTR` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_content_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_content_type` (
  `PROD_CAT_CONTENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PROD_CAT_CONTENT_TYPE_ID`),
  KEY `PRDCATCNT_TYP_PAR` (`PARENT_TYPE_ID`),
  key `CTR_CNT_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CTR_CNT_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDCATCNT_TYP_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `product_category_content_type` (`PROD_CAT_CONTENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_gl_account`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_gl_account` (
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORGANIZATION_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GL_ACCOUNT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GL_ACCOUNT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`,`ORGANIZATION_PARTY_ID`,`GL_ACCOUNT_TYPE_ID`),
  KEY `PRD_CT_GLACT_PCAT` (`PRODUCT_CATEGORY_ID`),
  KEY `PRD_CT_GLACT_PRTY` (`ORGANIZATION_PARTY_ID`),
  KEY `PRD_CT_GLACT_TYPE` (`GL_ACCOUNT_TYPE_ID`),
  KEY `PRD_CT_GLACT_GLACT` (`GL_ACCOUNT_ID`),
  key `CTR_GL_ACT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CTR_GL_ACT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRD_CT_GLACT_PCAT` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `PRD_CT_GLACT_PRTY` FOREIGN KEY (`ORGANIZATION_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_link`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_link` (
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LINK_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `TITLE_TEXT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DETAIL_TEXT` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `IMAGE_URL` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IMAGE_TWO_URL` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LINK_TYPE_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LINK_INFO` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DETAIL_SUB_SCREEN` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`,`LINK_SEQ_ID`,`FROM_DATE`),
  KEY `PROD_CLNK_CATEGORY` (`PRODUCT_CATEGORY_ID`),
  KEY `PROD_CLNK_LKTPENM` (`LINK_TYPE_ENUM_ID`),
  key `PRT_CTR_LNK_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CTR_LNK_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_CLNK_CATEGORY` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `PROD_CLNK_LKTPENM` FOREIGN KEY (`LINK_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_member`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_member` (
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`,`PRODUCT_ID`,`FROM_DATE`),
  KEY `PROD_CMBR_PRODUCT` (`PRODUCT_ID`),
  KEY `PROD_CMBR_CATEGORY` (`PRODUCT_CATEGORY_ID`),
  key `PRT_CTR_MMR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CTR_MMR_TS` (`CREATED_TX_STAMP`),
  KEY `PRD_CMBR_PCT` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `PROD_CMBR_CATEGORY` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `PROD_CMBR_PRODUCT` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_role` (
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`FROM_DATE`),
  KEY `PROD_CRLE_PTYRLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `PROD_CRLE_CATEGORY` (`PRODUCT_CATEGORY_ID`),
  key `PRT_CTR_RL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CTR_RL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_CRLE_CATEGORY` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `PROD_CRLE_PTYRLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_rollup`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_rollup` (
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`,`PARENT_PRODUCT_CATEGORY_ID`,`FROM_DATE`),
  KEY `PROD_CRLP_CURRENT` (`PRODUCT_CATEGORY_ID`),
  KEY `PROD_CRLP_PARENT` (`PARENT_PRODUCT_CATEGORY_ID`),
  key `PRT_CTR_RLP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CTR_RLP_TS` (`CREATED_TX_STAMP`),
  KEY `PRDCR_PARPC` (`PARENT_PRODUCT_CATEGORY_ID`),
  CONSTRAINT `PROD_CRLP_CURRENT` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `PROD_CRLP_PARENT` FOREIGN KEY (`PARENT_PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_type` (
  `PRODUCT_CATEGORY_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_TYPE_ID`),
  KEY `PROD_CTGRY_TYPEPAR` (`PARENT_TYPE_ID`),
  key `PRT_CTR_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CTR_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_CTGRY_TYPEPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `product_category_type` (`PRODUCT_CATEGORY_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_type_attr` (
  `PRODUCT_CATEGORY_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_TYPE_ID`,`ATTR_NAME`),
  KEY `PROD_CTGRY_TATTR` (`PRODUCT_CATEGORY_TYPE_ID`),
  key `CTR_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CTR_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_CTGRY_TATTR` FOREIGN KEY (`PRODUCT_CATEGORY_TYPE_ID`) REFERENCES `product_category_type` (`PRODUCT_CATEGORY_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_config` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONFIG_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LONG_DESCRIPTION` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `CONFIG_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_CONFIG_OPTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `IS_MANDATORY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`CONFIG_ITEM_ID`,`SEQUENCE_NUM`,`FROM_DATE`),
  KEY `PROD_CONF_PROD` (`PRODUCT_ID`),
  KEY `PROD_CONF_ITEM` (`CONFIG_ITEM_ID`),
  key `prt_PRT_CNG_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_CNG_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_CONF_ITEM` FOREIGN KEY (`CONFIG_ITEM_ID`) REFERENCES `product_config_item` (`CONFIG_ITEM_ID`),
  CONSTRAINT `PROD_CONF_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_config_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_config_config` (
  `CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONFIG_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) NOT NULL,
  `CONFIG_OPTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONFIG_ID`,`CONFIG_ITEM_ID`,`CONFIG_OPTION_ID`,`SEQUENCE_NUM`),
  KEY `PROD_CONFC_ITEM` (`CONFIG_ITEM_ID`),
  KEY `PROD_CONFC_OPTN` (`CONFIG_ITEM_ID`,`CONFIG_OPTION_ID`),
  key `PRT_CNG_CNG_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CNG_CNG_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_CONFC_ITEM` FOREIGN KEY (`CONFIG_ITEM_ID`) REFERENCES `product_config_item` (`CONFIG_ITEM_ID`),
  CONSTRAINT `PROD_CONFC_OPTN` FOREIGN KEY (`CONFIG_ITEM_ID`, `CONFIG_OPTION_ID`) REFERENCES `product_config_option` (`CONFIG_ITEM_ID`, `CONFIG_OPTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_config_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_config_item` (
  `CONFIG_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONFIG_ITEM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONFIG_ITEM_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LONG_DESCRIPTION` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `IMAGE_URL` varchar(2000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONFIG_ITEM_ID`),
  key `PRT_CNG_ITM_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CNG_ITM_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_config_option`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_config_option` (
  `CONFIG_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONFIG_OPTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `CONFIG_OPTION_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONFIG_ITEM_ID`,`CONFIG_OPTION_ID`),
  KEY `PROD_OPTN_ITEM` (`CONFIG_ITEM_ID`),
  key `PRT_CNG_OPN_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CNG_OPN_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_OPTN_ITEM` FOREIGN KEY (`CONFIG_ITEM_ID`) REFERENCES `product_config_item` (`CONFIG_ITEM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_config_option_iactn`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_config_option_iactn` (
  `CONFIG_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONFIG_OPTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONFIG_ITEM_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONFIG_OPTION_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) NOT NULL,
  `CONFIG_IACTN_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONFIG_ITEM_ID`,`CONFIG_OPTION_ID`,`CONFIG_ITEM_ID_TO`,`CONFIG_OPTION_ID_TO`,`SEQUENCE_NUM`),
  KEY `PROD_OPTIA_ITEM` (`CONFIG_ITEM_ID`),
  KEY `PROD_OPTIA_OPTN` (`CONFIG_ITEM_ID`,`CONFIG_OPTION_ID`),
  KEY `PROD_OPTIA_ITMT` (`CONFIG_ITEM_ID_TO`),
  KEY `PROD_OPTIA_OPTT` (`CONFIG_ITEM_ID_TO`,`CONFIG_OPTION_ID_TO`),
  key `CNG_OPN_ICN_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CNG_OPN_ICN_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_OPTIA_ITEM` FOREIGN KEY (`CONFIG_ITEM_ID`) REFERENCES `product_config_item` (`CONFIG_ITEM_ID`),
  CONSTRAINT `PROD_OPTIA_ITMT` FOREIGN KEY (`CONFIG_ITEM_ID_TO`) REFERENCES `product_config_item` (`CONFIG_ITEM_ID`),
  CONSTRAINT `PROD_OPTIA_OPTN` FOREIGN KEY (`CONFIG_ITEM_ID`, `CONFIG_OPTION_ID`) REFERENCES `product_config_option` (`CONFIG_ITEM_ID`, `CONFIG_OPTION_ID`),
  CONSTRAINT `PROD_OPTIA_OPTT` FOREIGN KEY (`CONFIG_ITEM_ID_TO`, `CONFIG_OPTION_ID_TO`) REFERENCES `product_config_option` (`CONFIG_ITEM_ID`, `CONFIG_OPTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_config_product`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_config_product` (
  `CONFIG_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONFIG_OPTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONFIG_ITEM_ID`,`CONFIG_OPTION_ID`,`PRODUCT_ID`),
  KEY `PROD_CONFP_ITEM` (`CONFIG_ITEM_ID`),
  KEY `PROD_CONFP_OPTN` (`CONFIG_ITEM_ID`,`CONFIG_OPTION_ID`),
  KEY `PROD_CONFP_PROD` (`PRODUCT_ID`),
  key `PRT_CNG_PRT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CNG_PRT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_CONFP_ITEM` FOREIGN KEY (`CONFIG_ITEM_ID`) REFERENCES `product_config_item` (`CONFIG_ITEM_ID`),
  CONSTRAINT `PROD_CONFP_OPTN` FOREIGN KEY (`CONFIG_ITEM_ID`, `CONFIG_OPTION_ID`) REFERENCES `product_config_option` (`CONFIG_ITEM_ID`, `CONFIG_OPTION_ID`),
  CONSTRAINT `PROD_CONFP_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_config_stats`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_config_stats` (
  `CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `NUM_OF_CONFS` decimal(20,0) DEFAULT NULL,
  `CONFIG_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONFIG_ID`,`PRODUCT_ID`),
  KEY `PROD_CONFS_PROD` (`PRODUCT_ID`),
  key `PRT_CNG_STS_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CNG_STS_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_CONFS_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_content_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_content_type` (
  `PRODUCT_CONTENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CONTENT_TYPE_ID`),
  KEY `PRDCT_TYP_PARENT` (`PARENT_TYPE_ID`),
  key `PRT_CNT_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_CNT_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDCT_TYP_PARENT` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `product_content_type` (`PRODUCT_CONTENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_cost_component_calc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_cost_component_calc` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COST_COMPONENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COST_COMPONENT_CALC_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`COST_COMPONENT_TYPE_ID`,`FROM_DATE`),
  KEY `PR_COS_COMPCALC` (`PRODUCT_ID`),
  KEY `PR_COS_CCT` (`COST_COMPONENT_TYPE_ID`),
  KEY `PR_COS_CCC` (`COST_COMPONENT_CALC_ID`),
  key `CST_CMT_CLC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CST_CMT_CLC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PR_COS_CCC` FOREIGN KEY (`COST_COMPONENT_CALC_ID`) REFERENCES `cost_component_calc` (`COST_COMPONENT_CALC_ID`),
  CONSTRAINT `PR_COS_CCT` FOREIGN KEY (`COST_COMPONENT_TYPE_ID`) REFERENCES `cost_component_type` (`COST_COMPONENT_TYPE_ID`),
  CONSTRAINT `PR_COS_COMPCALC` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_facility`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_facility` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MINIMUM_STOCK` decimal(18,6) DEFAULT NULL,
  `REORDER_QUANTITY` decimal(18,6) DEFAULT NULL,
  `DAYS_TO_SHIP` decimal(20,0) DEFAULT NULL,
  `REPLENISH_METHOD_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_INVENTORY_COUNT` decimal(18,6) DEFAULT NULL,
  `REQUIREMENT_METHOD_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`FACILITY_ID`),
  KEY `PROD_FAC_PROD` (`PRODUCT_ID`),
  KEY `PROD_FAC_FAC` (`FACILITY_ID`),
  KEY `PROD_FAC_REQ` (`REQUIREMENT_METHOD_ENUM_ID`),
  KEY `PROD_FAC_REP` (`REPLENISH_METHOD_ENUM_ID`),
  key `prt_PRT_FCT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_FCT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_FAC_FAC` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `PROD_FAC_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `PROD_FAC_REP` FOREIGN KEY (`REPLENISH_METHOD_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PROD_FAC_REQ` FOREIGN KEY (`REQUIREMENT_METHOD_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_facility_assoc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_facility_assoc` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ASSOC_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `TRANSIT_TIME` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`FACILITY_ID`,`FACILITY_ID_TO`,`FACILITY_ASSOC_TYPE_ID`,`FROM_DATE`),
  KEY `PRFACASSOC_PRO` (`PRODUCT_ID`),
  KEY `PRFACASSOC_FAC` (`FACILITY_ID`),
  KEY `PRFACASSOC_FACTO` (`FACILITY_ID_TO`),
  KEY `PRFACASSOC_TYPE` (`FACILITY_ASSOC_TYPE_ID`),
  key `PRT_FCT_ASC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_FCT_ASC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRFACASSOC_FAC` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `PRFACASSOC_FACTO` FOREIGN KEY (`FACILITY_ID_TO`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `PRFACASSOC_PRO` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `PRFACASSOC_TYPE` FOREIGN KEY (`FACILITY_ASSOC_TYPE_ID`) REFERENCES `facility_assoc_type` (`FACILITY_ASSOC_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_facility_location`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_facility_location` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOCATION_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MINIMUM_STOCK` decimal(18,6) DEFAULT NULL,
  `MOVE_QUANTITY` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`FACILITY_ID`,`LOCATION_SEQ_ID`),
  KEY `PROD_FCL_PROD` (`PRODUCT_ID`),
  KEY `PROD_FCL_FCL` (`FACILITY_ID`,`LOCATION_SEQ_ID`),
  key `PRT_FCT_LCN_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_FCT_LCN_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_FCL_FCL` FOREIGN KEY (`FACILITY_ID`, `LOCATION_SEQ_ID`) REFERENCES `facility_location` (`FACILITY_ID`, `LOCATION_SEQ_ID`),
  CONSTRAINT `PROD_FCL_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature` (
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_FEATURE_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NUMBER_SPECIFIED` decimal(18,6) DEFAULT NULL,
  `DEFAULT_AMOUNT` decimal(18,2) DEFAULT NULL,
  `DEFAULT_SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `ABBREV` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ID_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_FEATURE_ID`),
  KEY `PROD_FEAT_CATEGORY` (`PRODUCT_FEATURE_CATEGORY_ID`),
  KEY `PROD_FEAT_TYPE` (`PRODUCT_FEATURE_TYPE_ID`),
  KEY `PROD_FEAT_UOM` (`UOM_ID`),
  key `prt_PRT_FTR_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_FTR_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_FEAT_CATEGORY` FOREIGN KEY (`PRODUCT_FEATURE_CATEGORY_ID`) REFERENCES `product_feature_category` (`PRODUCT_FEATURE_CATEGORY_ID`),
  CONSTRAINT `PROD_FEAT_TYPE` FOREIGN KEY (`PRODUCT_FEATURE_TYPE_ID`) REFERENCES `product_feature_type` (`PRODUCT_FEATURE_TYPE_ID`),
  CONSTRAINT `PROD_FEAT_UOM` FOREIGN KEY (`UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_appl` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_APPL_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `AMOUNT` decimal(18,2) DEFAULT NULL,
  `RECURRING_AMOUNT` decimal(18,2) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`PRODUCT_FEATURE_ID`,`FROM_DATE`),
  KEY `PROD_FAPPL_TYPE` (`PRODUCT_FEATURE_APPL_TYPE_ID`),
  KEY `PROD_FAPPL_PRODUCT` (`PRODUCT_ID`),
  KEY `PROD_FAPPL_FEATURE` (`PRODUCT_FEATURE_ID`),
  key `PRT_FTR_APL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_FTR_APL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_FAPPL_FEATURE` FOREIGN KEY (`PRODUCT_FEATURE_ID`) REFERENCES `product_feature` (`PRODUCT_FEATURE_ID`),
  CONSTRAINT `PROD_FAPPL_PRODUCT` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `PROD_FAPPL_TYPE` FOREIGN KEY (`PRODUCT_FEATURE_APPL_TYPE_ID`) REFERENCES `product_feature_appl_type` (`PRODUCT_FEATURE_APPL_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_appl_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_appl_attr` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`PRODUCT_FEATURE_ID`,`FROM_DATE`,`ATTR_NAME`),
  KEY `PROD_FAPPA_PRODUCT` (`PRODUCT_ID`),
  KEY `PROD_FAPPA_FEATURE` (`PRODUCT_FEATURE_ID`),
  KEY `PROD_FAPPA_FEATAPP` (`PRODUCT_ID`,`PRODUCT_FEATURE_ID`,`FROM_DATE`),
  key `FTR_APL_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FTR_APL_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_FAPPA_FEATAPP` FOREIGN KEY (`PRODUCT_ID`, `PRODUCT_FEATURE_ID`, `FROM_DATE`) REFERENCES `product_feature_appl` (`PRODUCT_ID`, `PRODUCT_FEATURE_ID`, `FROM_DATE`),
  CONSTRAINT `PROD_FAPPA_FEATURE` FOREIGN KEY (`PRODUCT_FEATURE_ID`) REFERENCES `product_feature` (`PRODUCT_FEATURE_ID`),
  CONSTRAINT `PROD_FAPPA_PRODUCT` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_appl_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_appl_type` (
  `PRODUCT_FEATURE_APPL_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_FEATURE_APPL_TYPE_ID`),
  KEY `PROD_FAPPL_TYPPAR` (`PARENT_TYPE_ID`),
  key `FTR_APL_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FTR_APL_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_FAPPL_TYPPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `product_feature_appl_type` (`PRODUCT_FEATURE_APPL_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_cat_grp_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_cat_grp_appl` (
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`,`PRODUCT_FEATURE_GROUP_ID`,`FROM_DATE`),
  KEY `PROD_FCGAPL_CAT` (`PRODUCT_CATEGORY_ID`),
  KEY `PROD_FCGAPL_FGRP` (`PRODUCT_FEATURE_GROUP_ID`),
  key `CT_GRP_APL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CT_GRP_APL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_FCGAPL_CAT` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `PROD_FCGAPL_FGRP` FOREIGN KEY (`PRODUCT_FEATURE_GROUP_ID`) REFERENCES `product_feature_group` (`PRODUCT_FEATURE_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_category` (
  `PRODUCT_FEATURE_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_FEATURE_CATEGORY_ID`),
  KEY `PROD_FEAT_CAT_PAR` (`PARENT_CATEGORY_ID`),
  key `PRT_FTR_CTR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_FTR_CTR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_FEAT_CAT_PAR` FOREIGN KEY (`PARENT_CATEGORY_ID`) REFERENCES `product_feature_category` (`PRODUCT_FEATURE_CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_category_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_category_appl` (
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`,`PRODUCT_FEATURE_CATEGORY_ID`,`FROM_DATE`),
  KEY `PROD_FCAPPL_CAT` (`PRODUCT_CATEGORY_ID`),
  KEY `PROD_FCAPPL_FCAT` (`PRODUCT_FEATURE_CATEGORY_ID`),
  key `FTR_CTR_APL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FTR_CTR_APL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_FCAPPL_CAT` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `PROD_FCAPPL_FCAT` FOREIGN KEY (`PRODUCT_FEATURE_CATEGORY_ID`) REFERENCES `product_feature_category` (`PRODUCT_FEATURE_CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_group` (
  `PRODUCT_FEATURE_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_FEATURE_GROUP_ID`),
  key `PRT_FTR_GRP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_FTR_GRP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_group_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_group_appl` (
  `PRODUCT_FEATURE_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_FEATURE_GROUP_ID`,`PRODUCT_FEATURE_ID`,`FROM_DATE`),
  KEY `PROD_FGAPP_PRODUCT` (`PRODUCT_FEATURE_GROUP_ID`),
  KEY `PROD_FGAPP_FEATURE` (`PRODUCT_FEATURE_ID`),
  key `FTR_GRP_APL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FTR_GRP_APL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_FGAPP_FEATURE` FOREIGN KEY (`PRODUCT_FEATURE_ID`) REFERENCES `product_feature` (`PRODUCT_FEATURE_ID`),
  CONSTRAINT `PROD_FGAPP_PRODUCT` FOREIGN KEY (`PRODUCT_FEATURE_GROUP_ID`) REFERENCES `product_feature_group` (`PRODUCT_FEATURE_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_iactn`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_iactn` (
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_IACTN_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_FEATURE_ID`,`PRODUCT_FEATURE_ID_TO`),
  KEY `PROD_FICTN_TYPE` (`PRODUCT_FEATURE_IACTN_TYPE_ID`),
  KEY `PROD_FICTN_MFEAT` (`PRODUCT_FEATURE_ID`),
  KEY `PROD_FICTN_AFEAT` (`PRODUCT_FEATURE_ID_TO`),
  key `PRT_FTR_ICN_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_FTR_ICN_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_FICTN_AFEAT` FOREIGN KEY (`PRODUCT_FEATURE_ID_TO`) REFERENCES `product_feature` (`PRODUCT_FEATURE_ID`),
  CONSTRAINT `PROD_FICTN_MFEAT` FOREIGN KEY (`PRODUCT_FEATURE_ID`) REFERENCES `product_feature` (`PRODUCT_FEATURE_ID`),
  CONSTRAINT `PROD_FICTN_TYPE` FOREIGN KEY (`PRODUCT_FEATURE_IACTN_TYPE_ID`) REFERENCES `product_feature_iactn_type` (`PRODUCT_FEATURE_IACTN_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_iactn_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_iactn_type` (
  `PRODUCT_FEATURE_IACTN_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_FEATURE_IACTN_TYPE_ID`),
  KEY `PROD_FICTN_TYPPAR` (`PARENT_TYPE_ID`),
  key `FTR_ICN_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FTR_ICN_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_FICTN_TYPPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `product_feature_iactn_type` (`PRODUCT_FEATURE_IACTN_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_price`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_price` (
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PRICE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `PRICE` decimal(18,3) DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_FEATURE_ID`,`PRODUCT_PRICE_TYPE_ID`,`CURRENCY_UOM_ID`,`FROM_DATE`),
  KEY `PROD_F_PRICE_TYPE` (`PRODUCT_PRICE_TYPE_ID`),
  KEY `PROD_F_PRICE_CUOM` (`CURRENCY_UOM_ID`),
  KEY `PROD_F_PRICE_CBUL` (`CREATED_BY_USER_LOGIN`),
  KEY `PROD_F_PRICE_LMBUL` (`LAST_MODIFIED_BY_USER_LOGIN`),
  key `PRT_FTR_PRC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_FTR_PRC_TS` (`CREATED_TX_STAMP`),
  KEY `PRD_FT_PRC_GENLKP` (`PRODUCT_FEATURE_ID`,`CURRENCY_UOM_ID`),
  CONSTRAINT `PROD_F_PRICE_CBUL` FOREIGN KEY (`CREATED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PROD_F_PRICE_CUOM` FOREIGN KEY (`CURRENCY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PROD_F_PRICE_LMBUL` FOREIGN KEY (`LAST_MODIFIED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PROD_F_PRICE_TYPE` FOREIGN KEY (`PRODUCT_PRICE_TYPE_ID`) REFERENCES `product_price_type` (`PRODUCT_PRICE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_type` (
  `PRODUCT_FEATURE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_FEATURE_TYPE_ID`),
  KEY `PROD_FEAT_TYPPAR` (`PARENT_TYPE_ID`),
  key `PRT_FTR_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_FTR_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_FEAT_TYPPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `product_feature_type` (`PRODUCT_FEATURE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_geo`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_geo` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_GEO_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`GEO_ID`),
  KEY `PRDGEO_PRODUCT` (`PRODUCT_ID`),
  KEY `PRDGEO_GEO` (`GEO_ID`),
  KEY `PRDGEO_ENUM` (`PRODUCT_GEO_ENUM_ID`),
  key `prdt_PRT_G_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `prdt_PRT_G_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDGEO_ENUM` FOREIGN KEY (`PRODUCT_GEO_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PRDGEO_GEO` FOREIGN KEY (`GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `PRDGEO_PRODUCT` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_gl_account`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_gl_account` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORGANIZATION_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GL_ACCOUNT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GL_ACCOUNT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`ORGANIZATION_PARTY_ID`,`GL_ACCOUNT_TYPE_ID`),
  KEY `PROD_GLACT_PROD` (`PRODUCT_ID`),
  KEY `PROD_GLACT_PARTY` (`ORGANIZATION_PARTY_ID`),
  KEY `PROD_GLACT_TYPE` (`GL_ACCOUNT_TYPE_ID`),
  KEY `PROD_GLACT_GLACT` (`GL_ACCOUNT_ID`),
  key `PRT_GL_ACT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_GL_ACT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_GLACT_PARTY` FOREIGN KEY (`ORGANIZATION_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `PROD_GLACT_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_group_order`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_group_order` (
  `GROUP_ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQ_ORDER_QTY` decimal(18,6) DEFAULT NULL,
  `SOLD_ORDER_QTY` decimal(18,6) DEFAULT NULL,
  `JOB_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`GROUP_ORDER_ID`),
  KEY `PROD_GROUP_ORDER` (`PRODUCT_ID`),
  KEY `GROUP_ORDER_STATUS` (`STATUS_ID`),
  KEY `GROUP_ORDER_JOB` (`JOB_ID`),
  key `PRT_GRP_ORR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_GRP_ORR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `GROUP_ORDER_JOB` FOREIGN KEY (`JOB_ID`) REFERENCES `job_sandbox` (`JOB_ID`),
  CONSTRAINT `GROUP_ORDER_STATUS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `PROD_GROUP_ORDER` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_keyword`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_keyword` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `KEYWORD` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `KEYWORD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RELEVANCY_WEIGHT` decimal(20,0) DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`KEYWORD`,`KEYWORD_TYPE_ID`),
  KEY `PROD_KWD_PROD_NEW` (`PRODUCT_ID`),
  KEY `PROD_KWD_TYPE` (`KEYWORD_TYPE_ID`),
  KEY `PROD_KWD_STTS` (`STATUS_ID`),
  key `prt_PRT_KWD_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_KWD_TXCS` (`CREATED_TX_STAMP`),
  KEY `PROD_KWD_KWD_NEW` (`KEYWORD`),
  CONSTRAINT `PROD_KWD_PROD_NEW` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `PROD_KWD_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `PROD_KWD_TYPE` FOREIGN KEY (`KEYWORD_TYPE_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_maint`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_maint` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_MAINT_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_MAINT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MAINT_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MAINT_TEMPLATE_WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INTERVAL_QUANTITY` decimal(18,6) DEFAULT NULL,
  `INTERVAL_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INTERVAL_METER_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REPEAT_COUNT` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`PRODUCT_MAINT_SEQ_ID`),
  KEY `PRODMNT_PROD` (`PRODUCT_ID`),
  KEY `PRODMNT_MNTTYP` (`PRODUCT_MAINT_TYPE_ID`),
  KEY `PRODMNT_TPLHWE` (`MAINT_TEMPLATE_WORK_EFFORT_ID`),
  KEY `PRODMNT_INTUOM` (`INTERVAL_UOM_ID`),
  KEY `PRODMNT_PDMTTYP` (`INTERVAL_METER_TYPE_ID`),
  key `prt_PRT_MNT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_MNT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRODMNT_INTUOM` FOREIGN KEY (`INTERVAL_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PRODMNT_MNTTYP` FOREIGN KEY (`PRODUCT_MAINT_TYPE_ID`) REFERENCES `product_maint_type` (`PRODUCT_MAINT_TYPE_ID`),
  CONSTRAINT `PRODMNT_PDMTTYP` FOREIGN KEY (`INTERVAL_METER_TYPE_ID`) REFERENCES `product_meter_type` (`PRODUCT_METER_TYPE_ID`),
  CONSTRAINT `PRODMNT_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `PRODMNT_TPLHWE` FOREIGN KEY (`MAINT_TEMPLATE_WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_maint_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_maint_type` (
  `PRODUCT_MAINT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_MAINT_TYPE_ID`),
  KEY `PRODMNT_TYPE_PAR` (`PARENT_TYPE_ID`),
  key `PRT_MNT_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_MNT_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRODMNT_TYPE_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `product_maint_type` (`PRODUCT_MAINT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_meter`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_meter` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_METER_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `METER_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `METER_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`PRODUCT_METER_TYPE_ID`),
  KEY `PRODMTR_PROD` (`PRODUCT_ID`),
  KEY `PRODMTR_MTRTYP` (`PRODUCT_METER_TYPE_ID`),
  KEY `PRODMTR_MTRUOM` (`METER_UOM_ID`),
  key `prt_PRT_MTR_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_MTR_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRODMTR_MTRTYP` FOREIGN KEY (`PRODUCT_METER_TYPE_ID`) REFERENCES `product_meter_type` (`PRODUCT_METER_TYPE_ID`),
  CONSTRAINT `PRODMTR_MTRUOM` FOREIGN KEY (`METER_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PRODMTR_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_meter_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_meter_type` (
  `PRODUCT_METER_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_METER_TYPE_ID`),
  KEY `PRODMTRTP_DUOM` (`DEFAULT_UOM_ID`),
  key `PRT_MTR_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_MTR_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRODMTRTP_DUOM` FOREIGN KEY (`DEFAULT_UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_payment_method_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_payment_method_type` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PAYMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PRICE_PURPOSE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`PAYMENT_METHOD_TYPE_ID`,`PRODUCT_PRICE_PURPOSE_ID`,`FROM_DATE`),
  KEY `PROD_PMT_PROD` (`PRODUCT_ID`),
  KEY `PROD_PMT_PMT` (`PAYMENT_METHOD_TYPE_ID`),
  KEY `PROD_PMT_PPRP` (`PRODUCT_PRICE_PURPOSE_ID`),
  key `PMT_MTD_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PMT_MTD_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_PMT_PMT` FOREIGN KEY (`PAYMENT_METHOD_TYPE_ID`) REFERENCES `payment_method_type` (`PAYMENT_METHOD_TYPE_ID`),
  CONSTRAINT `PROD_PMT_PPRP` FOREIGN KEY (`PRODUCT_PRICE_PURPOSE_ID`) REFERENCES `product_price_purpose` (`PRODUCT_PRICE_PURPOSE_ID`),
  CONSTRAINT `PROD_PMT_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_price`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_price` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PRICE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PRICE_PURPOSE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_STORE_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `PRICE` decimal(18,3) DEFAULT NULL,
  `TERM_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOM_PRICE_CALC_SERVICE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRICE_WITHOUT_TAX` decimal(18,3) DEFAULT NULL,
  `PRICE_WITH_TAX` decimal(18,3) DEFAULT NULL,
  `TAX_AMOUNT` decimal(18,3) DEFAULT NULL,
  `TAX_PERCENTAGE` decimal(18,6) DEFAULT NULL,
  `TAX_AUTH_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TAX_AUTH_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TAX_IN_PRICE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`PRODUCT_PRICE_TYPE_ID`,`PRODUCT_PRICE_PURPOSE_ID`,`CURRENCY_UOM_ID`,`PRODUCT_STORE_GROUP_ID`,`FROM_DATE`),
  KEY `PROD_PRICE_PROD` (`PRODUCT_ID`),
  KEY `PROD_PRICE_TYPE` (`PRODUCT_PRICE_TYPE_ID`),
  KEY `PROD_PRICE_PURP` (`PRODUCT_PRICE_PURPOSE_ID`),
  KEY `PROD_PRICE_CUOM` (`CURRENCY_UOM_ID`),
  KEY `PROD_PRICE_TUOM` (`TERM_UOM_ID`),
  KEY `PROD_PRICE_PSTG` (`PRODUCT_STORE_GROUP_ID`),
  KEY `PROD_PRICE_CMET` (`CUSTOM_PRICE_CALC_SERVICE`),
  KEY `PROD_PRC_TAXPTY` (`TAX_AUTH_PARTY_ID`),
  KEY `PROD_PRC_TAXGEO` (`TAX_AUTH_GEO_ID`),
  KEY `PROD_PRICE_CBUL` (`CREATED_BY_USER_LOGIN`),
  KEY `PROD_PRICE_LMBUL` (`LAST_MODIFIED_BY_USER_LOGIN`),
  key `prt_PRT_PRC_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_PRC_TXCS` (`CREATED_TX_STAMP`),
  KEY `PRD_PRC_GENLKP` (`PRODUCT_ID`,`PRODUCT_PRICE_PURPOSE_ID`,`CURRENCY_UOM_ID`,`PRODUCT_STORE_GROUP_ID`),
  CONSTRAINT `PROD_PRC_TAXGEO` FOREIGN KEY (`TAX_AUTH_GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `PROD_PRC_TAXPTY` FOREIGN KEY (`TAX_AUTH_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `PROD_PRICE_CBUL` FOREIGN KEY (`CREATED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PROD_PRICE_CMET` FOREIGN KEY (`CUSTOM_PRICE_CALC_SERVICE`) REFERENCES `custom_method` (`CUSTOM_METHOD_ID`),
  CONSTRAINT `PROD_PRICE_CUOM` FOREIGN KEY (`CURRENCY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PROD_PRICE_LMBUL` FOREIGN KEY (`LAST_MODIFIED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PROD_PRICE_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `PROD_PRICE_PSTG` FOREIGN KEY (`PRODUCT_STORE_GROUP_ID`) REFERENCES `product_store_group` (`PRODUCT_STORE_GROUP_ID`),
  CONSTRAINT `PROD_PRICE_PURP` FOREIGN KEY (`PRODUCT_PRICE_PURPOSE_ID`) REFERENCES `product_price_purpose` (`PRODUCT_PRICE_PURPOSE_ID`),
  CONSTRAINT `PROD_PRICE_TUOM` FOREIGN KEY (`TERM_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PROD_PRICE_TYPE` FOREIGN KEY (`PRODUCT_PRICE_TYPE_ID`) REFERENCES `product_price_type` (`PRODUCT_PRICE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_price_action`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_price_action` (
  `PRODUCT_PRICE_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PRICE_ACTION_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PRICE_ACTION_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AMOUNT` decimal(18,6) DEFAULT NULL,
  `RATE_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PRICE_RULE_ID`,`PRODUCT_PRICE_ACTION_SEQ_ID`),
  KEY `PROD_PCACT_TYPE` (`PRODUCT_PRICE_ACTION_TYPE_ID`),
  KEY `PROD_PCACT_RL` (`PRODUCT_PRICE_RULE_ID`),
  key `PRT_PRC_ACN_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRC_ACN_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_PCACT_RL` FOREIGN KEY (`PRODUCT_PRICE_RULE_ID`) REFERENCES `product_price_rule` (`PRODUCT_PRICE_RULE_ID`),
  CONSTRAINT `PROD_PCACT_TYPE` FOREIGN KEY (`PRODUCT_PRICE_ACTION_TYPE_ID`) REFERENCES `product_price_action_type` (`PRODUCT_PRICE_ACTION_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_price_action_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_price_action_type` (
  `PRODUCT_PRICE_ACTION_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PRICE_ACTION_TYPE_ID`),
  key `PRC_ACN_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRC_ACN_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_price_auto_notice`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_price_auto_notice` (
  `PRODUCT_PRICE_NOTICE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RUN_DATE` datetime(3) DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PRICE_NOTICE_ID`),
  key `PRC_AT_NTC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRC_AT_NTC_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_price_change`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_price_change` (
  `PRODUCT_PRICE_CHANGE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PRICE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PRICE_PURPOSE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `PRICE` decimal(18,2) DEFAULT NULL,
  `OLD_PRICE` decimal(18,2) DEFAULT NULL,
  `CHANGED_DATE` datetime(3) DEFAULT NULL,
  `CHANGED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PRICE_CHANGE_ID`),
  KEY `PROD_PRCHNG_CHUL` (`CHANGED_BY_USER_LOGIN`),
  key `PRT_PRC_CHG_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRC_CHG_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_PRCHNG_CHUL` FOREIGN KEY (`CHANGED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_price_cond`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_price_cond` (
  `PRODUCT_PRICE_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PRICE_COND_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INPUT_PARAM_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OPERATOR_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COND_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PRICE_RULE_ID`,`PRODUCT_PRICE_COND_SEQ_ID`),
  KEY `PROD_PCCOND_RULE` (`PRODUCT_PRICE_RULE_ID`),
  KEY `PROD_PCCOND_INENUM` (`INPUT_PARAM_ENUM_ID`),
  KEY `PROD_PCCOND_OPENUM` (`OPERATOR_ENUM_ID`),
  key `PRT_PRC_CND_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRC_CND_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_PCCOND_INENUM` FOREIGN KEY (`INPUT_PARAM_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PROD_PCCOND_OPENUM` FOREIGN KEY (`OPERATOR_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PROD_PCCOND_RULE` FOREIGN KEY (`PRODUCT_PRICE_RULE_ID`) REFERENCES `product_price_rule` (`PRODUCT_PRICE_RULE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_price_purpose`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_price_purpose` (
  `PRODUCT_PRICE_PURPOSE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PRICE_PURPOSE_ID`),
  key `PRT_PRC_PRS_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRC_PRS_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_price_rule`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_price_rule` (
  `PRODUCT_PRICE_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RULE_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_SALE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PRICE_RULE_ID`),
  key `PRT_PRC_RL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRC_RL_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_price_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_price_type` (
  `PRODUCT_PRICE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PRICE_TYPE_ID`),
  key `PRT_PRC_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRC_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_promo`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_promo` (
  `PRODUCT_PROMO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PROMO_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PROMO_TEXT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_ENTERED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHOW_TO_CUSTOMER` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIRE_CODE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USE_LIMIT_PER_ORDER` decimal(20,0) DEFAULT NULL,
  `USE_LIMIT_PER_CUSTOMER` decimal(20,0) DEFAULT NULL,
  `USE_LIMIT_PER_PROMOTION` decimal(20,0) DEFAULT NULL,
  `BILLBACK_FACTOR` decimal(18,6) DEFAULT NULL,
  `OVERRIDE_ORG_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PROMO_ID`),
  KEY `PROD_PRMO_OPA` (`OVERRIDE_ORG_PARTY_ID`),
  KEY `PROD_PRMO_CUL` (`CREATED_BY_USER_LOGIN`),
  KEY `PROD_PRMO_LMCUL` (`LAST_MODIFIED_BY_USER_LOGIN`),
  key `prt_PRT_PRM_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_PRM_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_PRMO_CUL` FOREIGN KEY (`CREATED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PROD_PRMO_LMCUL` FOREIGN KEY (`LAST_MODIFIED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PROD_PRMO_OPA` FOREIGN KEY (`OVERRIDE_ORG_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_promo_action`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_promo_action` (
  `PRODUCT_PROMO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_ACTION_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_ACTION_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOM_METHOD_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ADJUSTMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `AMOUNT` decimal(18,6) DEFAULT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USE_CART_QUANTITY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PROMO_ID`,`PRODUCT_PROMO_RULE_ID`,`PRODUCT_PROMO_ACTION_SEQ_ID`),
  KEY `PROD_PRACT_ENUM` (`PRODUCT_PROMO_ACTION_ENUM_ID`),
  KEY `PROD_PRACT_CMET` (`CUSTOM_METHOD_ID`),
  KEY `PROD_PRACT_PR` (`PRODUCT_PROMO_ID`),
  KEY `PROD_PRACT_RL` (`PRODUCT_PROMO_ID`,`PRODUCT_PROMO_RULE_ID`),
  KEY `PROD_PRACT_OATYPE` (`ORDER_ADJUSTMENT_TYPE_ID`),
  key `PRT_PRM_ACN_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRM_ACN_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_PRACT_CMET` FOREIGN KEY (`CUSTOM_METHOD_ID`) REFERENCES `custom_method` (`CUSTOM_METHOD_ID`),
  CONSTRAINT `PROD_PRACT_ENUM` FOREIGN KEY (`PRODUCT_PROMO_ACTION_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PROD_PRACT_OATYPE` FOREIGN KEY (`ORDER_ADJUSTMENT_TYPE_ID`) REFERENCES `order_adjustment_type` (`ORDER_ADJUSTMENT_TYPE_ID`),
  CONSTRAINT `PROD_PRACT_PR` FOREIGN KEY (`PRODUCT_PROMO_ID`) REFERENCES `product_promo` (`PRODUCT_PROMO_ID`),
  CONSTRAINT `PROD_PRACT_RL` FOREIGN KEY (`PRODUCT_PROMO_ID`, `PRODUCT_PROMO_RULE_ID`) REFERENCES `product_promo_rule` (`PRODUCT_PROMO_ID`, `PRODUCT_PROMO_RULE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_promo_category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_promo_category` (
  `PRODUCT_PROMO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_ACTION_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_COND_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AND_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_APPL_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INCLUDE_SUB_CATEGORIES` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PROMO_ID`,`PRODUCT_PROMO_RULE_ID`,`PRODUCT_PROMO_ACTION_SEQ_ID`,`PRODUCT_PROMO_COND_SEQ_ID`,`PRODUCT_CATEGORY_ID`,`AND_GROUP_ID`),
  KEY `PROD_PRCAT_PROMO` (`PRODUCT_PROMO_ID`),
  KEY `PROD_PRCAT_PRCAT` (`PRODUCT_CATEGORY_ID`),
  KEY `PROD_PRCAT_ENUM` (`PRODUCT_PROMO_APPL_ENUM_ID`),
  key `PRT_PRM_CTR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRM_CTR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_PRCAT_ENUM` FOREIGN KEY (`PRODUCT_PROMO_APPL_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PROD_PRCAT_PRCAT` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `PROD_PRCAT_PROMO` FOREIGN KEY (`PRODUCT_PROMO_ID`) REFERENCES `product_promo` (`PRODUCT_PROMO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_promo_code`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_promo_code` (
  `PRODUCT_PROMO_CODE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_ENTERED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIRE_EMAIL_OR_PARTY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USE_LIMIT_PER_CODE` decimal(20,0) DEFAULT NULL,
  `USE_LIMIT_PER_CUSTOMER` decimal(20,0) DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PROMO_CODE_ID`),
  KEY `PROD_PRCOD_PROMO` (`PRODUCT_PROMO_ID`),
  KEY `PROD_PRCOD_CUL` (`CREATED_BY_USER_LOGIN`),
  KEY `PROD_PRCOD_LMCUL` (`LAST_MODIFIED_BY_USER_LOGIN`),
  key `PRT_PRM_CD_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRM_CD_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_PRCOD_CUL` FOREIGN KEY (`CREATED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PROD_PRCOD_LMCUL` FOREIGN KEY (`LAST_MODIFIED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PROD_PRCOD_PROMO` FOREIGN KEY (`PRODUCT_PROMO_ID`) REFERENCES `product_promo` (`PRODUCT_PROMO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_promo_code_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_promo_code_party` (
  `PRODUCT_PROMO_CODE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PROMO_CODE_ID`,`PARTY_ID`),
  KEY `PROD_PRCDP_PCD` (`PRODUCT_PROMO_CODE_ID`),
  KEY `PROD_PRCDP_PRTY` (`PARTY_ID`),
  key `PRM_CD_PRT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRM_CD_PRT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_PRCDP_PCD` FOREIGN KEY (`PRODUCT_PROMO_CODE_ID`) REFERENCES `product_promo_code` (`PRODUCT_PROMO_CODE_ID`),
  CONSTRAINT `PROD_PRCDP_PRTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_promo_cond`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_promo_cond` (
  `PRODUCT_PROMO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_COND_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CUSTOM_METHOD_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INPUT_PARAM_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OPERATOR_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COND_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OTHER_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PROMO_ID`,`PRODUCT_PROMO_RULE_ID`,`PRODUCT_PROMO_COND_SEQ_ID`),
  KEY `PROD_PRCOND_PROMO` (`PRODUCT_PROMO_ID`),
  KEY `PROD_PRCOND_RULE` (`PRODUCT_PROMO_ID`,`PRODUCT_PROMO_RULE_ID`),
  KEY `PROD_PRCOND_CMETH` (`CUSTOM_METHOD_ID`),
  KEY `PROD_PRCOND_INENUM` (`INPUT_PARAM_ENUM_ID`),
  KEY `PROD_PRCOND_OPENUM` (`OPERATOR_ENUM_ID`),
  key `PRT_PRM_CND_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRM_CND_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_PRCOND_CMETH` FOREIGN KEY (`CUSTOM_METHOD_ID`) REFERENCES `custom_method` (`CUSTOM_METHOD_ID`),
  CONSTRAINT `PROD_PRCOND_INENUM` FOREIGN KEY (`INPUT_PARAM_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PROD_PRCOND_OPENUM` FOREIGN KEY (`OPERATOR_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PROD_PRCOND_PROMO` FOREIGN KEY (`PRODUCT_PROMO_ID`) REFERENCES `product_promo` (`PRODUCT_PROMO_ID`),
  CONSTRAINT `PROD_PRCOND_RULE` FOREIGN KEY (`PRODUCT_PROMO_ID`, `PRODUCT_PROMO_RULE_ID`) REFERENCES `product_promo_rule` (`PRODUCT_PROMO_ID`, `PRODUCT_PROMO_RULE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_promo_product`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_promo_product` (
  `PRODUCT_PROMO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_ACTION_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_COND_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_APPL_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PROMO_ID`,`PRODUCT_PROMO_RULE_ID`,`PRODUCT_PROMO_ACTION_SEQ_ID`,`PRODUCT_PROMO_COND_SEQ_ID`,`PRODUCT_ID`),
  KEY `PROD_PRPRD_PROMO` (`PRODUCT_PROMO_ID`),
  KEY `PROD_PRPRD_PROD` (`PRODUCT_ID`),
  KEY `PROD_PRPRD_ENUM` (`PRODUCT_PROMO_APPL_ENUM_ID`),
  key `PRT_PRM_PRT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRM_PRT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_PRPRD_ENUM` FOREIGN KEY (`PRODUCT_PROMO_APPL_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PROD_PRPRD_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `PROD_PRPRD_PROMO` FOREIGN KEY (`PRODUCT_PROMO_ID`) REFERENCES `product_promo` (`PRODUCT_PROMO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_promo_rule`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_promo_rule` (
  `PRODUCT_PROMO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RULE_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PROMO_ID`,`PRODUCT_PROMO_RULE_ID`),
  KEY `PROD_PRRLE_PROMO` (`PRODUCT_PROMO_ID`),
  key `PRT_PRM_RL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRM_RL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_PRRLE_PROMO` FOREIGN KEY (`PRODUCT_PROMO_ID`) REFERENCES `product_promo` (`PRODUCT_PROMO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_promo_use`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_promo_use` (
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PROMO_SEQUENCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PROMO_CODE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TOTAL_DISCOUNT_AMOUNT` decimal(18,2) DEFAULT NULL,
  `QUANTITY_LEFT_IN_ACTIONS` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`PROMO_SEQUENCE_ID`),
  KEY `PROD_PRUSE_PROMO` (`PRODUCT_PROMO_ID`),
  KEY `PROD_PRUSE_CODE` (`PRODUCT_PROMO_CODE_ID`),
  KEY `PROD_PRUSE_ORDR` (`ORDER_ID`),
  KEY `PROD_PRUSE_PTY` (`PARTY_ID`),
  key `PRT_PRM_US_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_PRM_US_TS` (`CREATED_TX_STAMP`),
  KEY `PRODPRUSE_PRMPTY` (`PRODUCT_PROMO_ID`,`PARTY_ID`),
  KEY `PRODPRUSE_PCDPTY` (`PRODUCT_PROMO_CODE_ID`,`PARTY_ID`),
  CONSTRAINT `PROD_PRUSE_CODE` FOREIGN KEY (`PRODUCT_PROMO_CODE_ID`) REFERENCES `product_promo_code` (`PRODUCT_PROMO_CODE_ID`),
  CONSTRAINT `PROD_PRUSE_ORDR` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `PROD_PRUSE_PROMO` FOREIGN KEY (`PRODUCT_PROMO_ID`) REFERENCES `product_promo` (`PRODUCT_PROMO_ID`),
  CONSTRAINT `PROD_PRUSE_PTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_review`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_review` (
  `PRODUCT_REVIEW_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `POSTED_ANONYMOUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `POSTED_DATE_TIME` datetime(3) DEFAULT NULL,
  `PRODUCT_RATING` decimal(18,6) DEFAULT NULL,
  `PRODUCT_REVIEW` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_REVIEW_ID`),
  KEY `PROD_REVIEW_PRDSTR` (`PRODUCT_STORE_ID`),
  KEY `PROD_REVIEW_PROD` (`PRODUCT_ID`),
  KEY `PROD_REVIEW_ULH` (`USER_LOGIN_ID`),
  KEY `PROD_REVIEW_STTS` (`STATUS_ID`),
  key `prt_PRT_RVW_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_RVW_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_REVIEW_PRDSTR` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `PROD_REVIEW_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `PROD_REVIEW_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `PROD_REVIEW_ULH` FOREIGN KEY (`USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_role` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`FROM_DATE`),
  KEY `PROD_RLE_PTYRLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `PROD_RLE_PRODUCT` (`PRODUCT_ID`),
  key `prt_PRT_RL_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_RL_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_RLE_PRODUCT` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `PROD_RLE_PTYRLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_search_constraint`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_search_constraint` (
  `PRODUCT_SEARCH_RESULT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONSTRAINT_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONSTRAINT_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INFO_STRING` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INCLUDE_SUB_CATEGORIES` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_AND` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ANY_PREFIX` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ANY_SUFFIX` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REMOVE_STEMS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOW_VALUE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HIGH_VALUE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_SEARCH_RESULT_ID`,`CONSTRAINT_SEQ_ID`),
  KEY `PROD_SCHRSI_RES` (`PRODUCT_SEARCH_RESULT_ID`),
  key `PRT_SRH_CNT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_SRH_CNT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_SCHRSI_RES` FOREIGN KEY (`PRODUCT_SEARCH_RESULT_ID`) REFERENCES `product_search_result` (`PRODUCT_SEARCH_RESULT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_search_result`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_search_result` (
  `PRODUCT_SEARCH_RESULT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VISIT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_BY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_ASCENDING` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NUM_RESULTS` decimal(20,0) DEFAULT NULL,
  `SECONDS_TOTAL` double DEFAULT NULL,
  `SEARCH_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_SEARCH_RESULT_ID`),
  key `PRT_SRH_RST_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_SRH_RST_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store` (
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRIMARY_STORE_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STORE_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMPANY_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TITLE` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUBTITLE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PAY_TO_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DAYS_TO_CANCEL_NON_PAY` decimal(20,0) DEFAULT NULL,
  `MANUAL_AUTH_IS_CAPTURE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRORATE_SHIPPING` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRORATE_TAXES` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VIEW_CART_ON_ADD` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTO_SAVE_CART` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTO_APPROVE_REVIEWS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_DEMO_STORE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_IMMEDIATELY_FULFILLED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVENTORY_FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ONE_INVENTORY_FACILITY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHECK_INVENTORY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESERVE_INVENTORY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESERVE_ORDER_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIRE_INVENTORY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BALANCE_RES_ON_ORDER_CREATION` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIREMENT_METHOD_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_NUMBER_PREFIX` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_LOCALE_STRING` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_TIME_ZONE_STRING` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_SALES_CHANNEL_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOW_PASSWORD` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXPLODE_ORDER_ITEMS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHECK_GC_BALANCE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETRY_FAILED_AUTHS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HEADER_APPROVED_STATUS` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ITEM_APPROVED_STATUS` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DIGITAL_ITEM_APPROVED_STATUS` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HEADER_DECLINED_STATUS` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ITEM_DECLINED_STATUS` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HEADER_CANCEL_STATUS` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ITEM_CANCEL_STATUS` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTH_DECLINED_MESSAGE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTH_FRAUD_MESSAGE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTH_ERROR_MESSAGE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VISUAL_THEME_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STORE_CREDIT_ACCOUNT_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USE_PRIMARY_EMAIL_USERNAME` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIRE_CUSTOMER_ROLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTO_INVOICE_DIGITAL_ITEMS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQ_SHIP_ADDR_FOR_DIG_ITEMS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHOW_CHECKOUT_GIFT_OPTIONS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SELECT_PAYMENT_TYPE_PER_ITEM` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHOW_PRICES_WITH_VAT_TAX` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHOW_TAX_IS_EXEMPT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VAT_TAX_AUTH_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VAT_TAX_AUTH_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENABLE_AUTO_SUGGESTION_LIST` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENABLE_DIG_PROD_UPLOAD` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PROD_SEARCH_EXCLUDE_VARIANTS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DIG_PROD_UPLOAD_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTO_ORDER_CC_TRY_EXP` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTO_ORDER_CC_TRY_OTHER_CARDS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTO_ORDER_CC_TRY_LATER_NSF` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTO_ORDER_CC_TRY_LATER_MAX` decimal(20,0) DEFAULT NULL,
  `STORE_CREDIT_VALID_DAYS` decimal(20,0) DEFAULT NULL,
  `AUTO_APPROVE_INVOICE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTO_APPROVE_ORDER` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIP_IF_CAPTURE_FAILS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SET_OWNER_UPON_ISSUANCE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQ_RETURN_INVENTORY_RECEIVE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ADD_TO_CART_REMOVE_INCOMPAT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ADD_TO_CART_REPLACE_UPSELL` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SPLIT_PAY_PREF_PER_SHP_GRP` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MANAGED_BY_LOT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHOW_OUT_OF_STOCK_PRODUCTS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_DECIMAL_QUANTITY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOW_COMMENT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOCATE_INVENTORY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`),
  KEY `PROD_STR_PRSTRGP` (`PRIMARY_STORE_GROUP_ID`),
  KEY `PROD_STR_FACILITY` (`INVENTORY_FACILITY_ID`),
  KEY `PROD_STR_RORDENUM` (`RESERVE_ORDER_ENUM_ID`),
  KEY `PROD_STR_RQMTENUM` (`REQUIREMENT_METHOD_ENUM_ID`),
  KEY `PROD_STR_PAYTOPTY` (`PAY_TO_PARTY_ID`),
  KEY `PROD_STR_CURUOM` (`DEFAULT_CURRENCY_UOM_ID`),
  KEY `PROD_STR_SALECHN` (`DEFAULT_SALES_CHANNEL_ENUM_ID`),
  KEY `PROD_STR_HAPSTS` (`HEADER_APPROVED_STATUS`),
  KEY `PROD_STR_IAPSTS` (`ITEM_APPROVED_STATUS`),
  KEY `PROD_STR_DIAPSTS` (`DIGITAL_ITEM_APPROVED_STATUS`),
  KEY `PROD_STR_HDCSTS` (`HEADER_DECLINED_STATUS`),
  KEY `PROD_STR_IDCSTS` (`ITEM_DECLINED_STATUS`),
  KEY `PROD_STR_HCNSTS` (`HEADER_CANCEL_STATUS`),
  KEY `PROD_STR_ICNSTS` (`ITEM_CANCEL_STATUS`),
  KEY `PROD_STR_VATTXA` (`VAT_TAX_AUTH_GEO_ID`,`VAT_TAX_AUTH_PARTY_ID`),
  KEY `PROD_STR_STRCRDACT` (`STORE_CREDIT_ACCOUNT_ENUM_ID`),
  key `prt_PRT_STR_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_STR_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_STR_CURUOM` FOREIGN KEY (`DEFAULT_CURRENCY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PROD_STR_DIAPSTS` FOREIGN KEY (`DIGITAL_ITEM_APPROVED_STATUS`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `PROD_STR_FACILITY` FOREIGN KEY (`INVENTORY_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `PROD_STR_HAPSTS` FOREIGN KEY (`HEADER_APPROVED_STATUS`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `PROD_STR_HCNSTS` FOREIGN KEY (`HEADER_CANCEL_STATUS`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `PROD_STR_HDCSTS` FOREIGN KEY (`HEADER_DECLINED_STATUS`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `PROD_STR_IAPSTS` FOREIGN KEY (`ITEM_APPROVED_STATUS`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `PROD_STR_ICNSTS` FOREIGN KEY (`ITEM_CANCEL_STATUS`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `PROD_STR_IDCSTS` FOREIGN KEY (`ITEM_DECLINED_STATUS`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `PROD_STR_PAYTOPTY` FOREIGN KEY (`PAY_TO_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `PROD_STR_PRSTRGP` FOREIGN KEY (`PRIMARY_STORE_GROUP_ID`) REFERENCES `product_store_group` (`PRODUCT_STORE_GROUP_ID`),
  CONSTRAINT `PROD_STR_RORDENUM` FOREIGN KEY (`RESERVE_ORDER_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PROD_STR_RQMTENUM` FOREIGN KEY (`REQUIREMENT_METHOD_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PROD_STR_SALECHN` FOREIGN KEY (`DEFAULT_SALES_CHANNEL_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PROD_STR_STRCRDACT` FOREIGN KEY (`STORE_CREDIT_ACCOUNT_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_catalog`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_catalog` (
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PROD_CATALOG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`PROD_CATALOG_ID`,`FROM_DATE`),
  KEY `PS_CAT_PRDSTR` (`PRODUCT_STORE_ID`),
  KEY `PS_CAT_CATALOG` (`PROD_CATALOG_ID`),
  key `PRT_STR_CTG_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_STR_CTG_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PS_CAT_CATALOG` FOREIGN KEY (`PROD_CATALOG_ID`) REFERENCES `prod_catalog` (`PROD_CATALOG_ID`),
  CONSTRAINT `PS_CAT_PRDSTR` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_email_setting`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_email_setting` (
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `EMAIL_TYPE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `BODY_SCREEN_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `XSLFO_ATTACH_SCREEN_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_ADDRESS` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CC_ADDRESS` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BCC_ADDRESS` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUBJECT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_TYPE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`EMAIL_TYPE`),
  KEY `PRDSTREM_PRDS` (`PRODUCT_STORE_ID`),
  KEY `PRDSTREM_ENUM` (`EMAIL_TYPE`),
  key `STR_EML_STG_TP` (`LAST_UPDATED_TX_STAMP`),
  key `STR_EML_STG_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDSTREM_ENUM` FOREIGN KEY (`EMAIL_TYPE`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PRDSTREM_PRDS` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_facility`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_facility` (
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`FACILITY_ID`,`FROM_DATE`),
  KEY `PRDSTRFAC_PRDS` (`PRODUCT_STORE_ID`),
  KEY `PRDSTRFAC_FAC` (`FACILITY_ID`),
  key `PRT_STR_FCT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_STR_FCT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDSTRFAC_FAC` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `PRDSTRFAC_PRDS` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_group` (
  `PRODUCT_STORE_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_STORE_GROUP_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIMARY_PARENT_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_GROUP_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_GROUP_ID`),
  KEY `PRDSTR_GP_TYPE` (`PRODUCT_STORE_GROUP_TYPE_ID`),
  KEY `PRDSTR_GP_PGRP` (`PRIMARY_PARENT_GROUP_ID`),
  key `PRT_STR_GRP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_STR_GRP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDSTR_GP_PGRP` FOREIGN KEY (`PRIMARY_PARENT_GROUP_ID`) REFERENCES `product_store_group` (`PRODUCT_STORE_GROUP_ID`),
  CONSTRAINT `PRDSTR_GP_TYPE` FOREIGN KEY (`PRODUCT_STORE_GROUP_TYPE_ID`) REFERENCES `product_store_group_type` (`PRODUCT_STORE_GROUP_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_group_member`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_group_member` (
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_STORE_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`PRODUCT_STORE_GROUP_ID`,`FROM_DATE`),
  KEY `PRDSTR_MEM_PRDSTR` (`PRODUCT_STORE_ID`),
  KEY `PRDSTR_MEM_PSGRP` (`PRODUCT_STORE_GROUP_ID`),
  key `STR_GRP_MMR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `STR_GRP_MMR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDSTR_MEM_PRDSTR` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `PRDSTR_MEM_PSGRP` FOREIGN KEY (`PRODUCT_STORE_GROUP_ID`) REFERENCES `product_store_group` (`PRODUCT_STORE_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_group_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_group_role` (
  `PRODUCT_STORE_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_GROUP_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `PSGRP_RLE_PSGP` (`PRODUCT_STORE_GROUP_ID`),
  KEY `PSGRP_RLE_PTRLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  key `STR_GRP_RL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `STR_GRP_RL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PSGRP_RLE_PSGP` FOREIGN KEY (`PRODUCT_STORE_GROUP_ID`) REFERENCES `product_store_group` (`PRODUCT_STORE_GROUP_ID`),
  CONSTRAINT `PSGRP_RLE_PTRLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_group_rollup`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_group_rollup` (
  `PRODUCT_STORE_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_GROUP_ID`,`PARENT_GROUP_ID`,`FROM_DATE`),
  KEY `PSGRP_RLP_CURRENT` (`PRODUCT_STORE_GROUP_ID`),
  KEY `PSGRP_RLP_PARENT` (`PARENT_GROUP_ID`),
  key `STR_GRP_RLP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `STR_GRP_RLP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PSGRP_RLP_CURRENT` FOREIGN KEY (`PRODUCT_STORE_GROUP_ID`) REFERENCES `product_store_group` (`PRODUCT_STORE_GROUP_ID`),
  CONSTRAINT `PSGRP_RLP_PARENT` FOREIGN KEY (`PARENT_GROUP_ID`) REFERENCES `product_store_group` (`PRODUCT_STORE_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_group_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_group_type` (
  `PRODUCT_STORE_GROUP_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_GROUP_TYPE_ID`),
  key `STR_GRP_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `STR_GRP_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_keyword_ovrd`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_keyword_ovrd` (
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `KEYWORD` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `TARGET` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TARGET_TYPE_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`KEYWORD`,`FROM_DATE`),
  KEY `PRDSTRKWO_PRDS` (`PRODUCT_STORE_ID`),
  KEY `PRDSTRKWO_ENM` (`TARGET_TYPE_ENUM_ID`),
  key `STR_KWD_OVD_TP` (`LAST_UPDATED_TX_STAMP`),
  key `STR_KWD_OVD_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDSTRKWO_ENM` FOREIGN KEY (`TARGET_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PRDSTRKWO_PRDS` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_payment_setting`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_payment_setting` (
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PAYMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PAYMENT_SERVICE_TYPE_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PAYMENT_SERVICE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PAYMENT_CUSTOM_METHOD_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PAYMENT_GATEWAY_CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PAYMENT_PROPERTIES_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `APPLY_TO_ALL_PRODUCTS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`PAYMENT_METHOD_TYPE_ID`,`PAYMENT_SERVICE_TYPE_ENUM_ID`),
  KEY `PRDS_PS_PRDS` (`PRODUCT_STORE_ID`),
  KEY `PRDS_PS_PMNTTP` (`PAYMENT_METHOD_TYPE_ID`),
  KEY `PRDS_PS_ENUM` (`PAYMENT_SERVICE_TYPE_ENUM_ID`),
  KEY `PRDS_PS_PGC` (`PAYMENT_GATEWAY_CONFIG_ID`),
  KEY `PRDS_PS_CUS_MET` (`PAYMENT_CUSTOM_METHOD_ID`),
  key `STR_PMT_STG_TP` (`LAST_UPDATED_TX_STAMP`),
  key `STR_PMT_STG_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDS_PS_CUS_MET` FOREIGN KEY (`PAYMENT_CUSTOM_METHOD_ID`) REFERENCES `custom_method` (`CUSTOM_METHOD_ID`),
  CONSTRAINT `PRDS_PS_ENUM` FOREIGN KEY (`PAYMENT_SERVICE_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PRDS_PS_PMNTTP` FOREIGN KEY (`PAYMENT_METHOD_TYPE_ID`) REFERENCES `payment_method_type` (`PAYMENT_METHOD_TYPE_ID`),
  CONSTRAINT `PRDS_PS_PRDS` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_promo_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_promo_appl` (
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PROMO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `MANUAL_ONLY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`PRODUCT_PROMO_ID`,`FROM_DATE`),
  KEY `PRDSTRPRMO_PRDS` (`PRODUCT_STORE_ID`),
  KEY `PRDSTRPRMO_PRMO` (`PRODUCT_PROMO_ID`),
  key `STR_PRM_APL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `STR_PRM_APL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDSTRPRMO_PRDS` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `PRDSTRPRMO_PRMO` FOREIGN KEY (`PRODUCT_PROMO_ID`) REFERENCES `product_promo` (`PRODUCT_PROMO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_role` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`ROLE_TYPE_ID`,`PRODUCT_STORE_ID`,`FROM_DATE`),
  KEY `PRDSTRRLE_PRLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `PRDSTRRLE_PRDS` (`PRODUCT_STORE_ID`),
  key `PRT_STR_RL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_STR_RL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDSTRRLE_PRDS` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `PRDSTRRLE_PRLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_shipment_meth`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_shipment_meth` (
  `PRODUCT_STORE_SHIP_METH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMPANY_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MIN_WEIGHT` decimal(18,6) DEFAULT NULL,
  `MAX_WEIGHT` decimal(18,6) DEFAULT NULL,
  `MIN_SIZE` decimal(18,6) DEFAULT NULL,
  `MAX_SIZE` decimal(18,6) DEFAULT NULL,
  `MIN_TOTAL` decimal(18,2) DEFAULT NULL,
  `MAX_TOTAL` decimal(18,2) DEFAULT NULL,
  `ALLOW_USPS_ADDR` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIRE_USPS_ADDR` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOW_COMPANY_ADDR` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIRE_COMPANY_ADDR` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INCLUDE_NO_CHARGE_ITEMS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INCLUDE_FEATURE_GROUP` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXCLUDE_FEATURE_GROUP` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INCLUDE_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXCLUDE_GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONFIG_PROPS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_CUSTOM_METHOD_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_GATEWAY_CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUMBER` decimal(20,0) DEFAULT NULL,
  `ALLOWANCE_PERCENT` decimal(18,6) DEFAULT NULL,
  `MINIMUM_PRICE` decimal(18,2) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_SHIP_METH_ID`),
  KEY `SHIPMENTMETHODTYPE` (`SHIPMENT_METHOD_TYPE_ID`),
  KEY `PRDS_SM_SGC` (`SHIPMENT_GATEWAY_CONFIG_ID`),
  KEY `PRDS_SM_CUS_MET` (`SHIPMENT_CUSTOM_METHOD_ID`),
  key `STR_SHT_MTH_TP` (`LAST_UPDATED_TX_STAMP`),
  key `STR_SHT_MTH_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDS_SM_CUS_MET` FOREIGN KEY (`SHIPMENT_CUSTOM_METHOD_ID`) REFERENCES `custom_method` (`CUSTOM_METHOD_ID`),
  CONSTRAINT `PRDS_SM_SGC` FOREIGN KEY (`SHIPMENT_GATEWAY_CONFIG_ID`) REFERENCES `shipment_gateway_config` (`SHIPMENT_GATEWAY_CONFIG_ID`),
  CONSTRAINT `SHIPMENTMETHODTYPE` FOREIGN KEY (`SHIPMENT_METHOD_TYPE_ID`) REFERENCES `shipment_method_type` (`SHIPMENT_METHOD_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_telecom_setting`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_telecom_setting` (
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TELECOM_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TELECOM_MSG_TYPE_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TELECOM_CUSTOM_METHOD_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TELECOM_GATEWAY_CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`TELECOM_METHOD_TYPE_ID`,`TELECOM_MSG_TYPE_ENUM_ID`),
  KEY `PRDS_TS_PRDS` (`PRODUCT_STORE_ID`),
  KEY `PRDS_TS_TELTP` (`TELECOM_METHOD_TYPE_ID`),
  KEY `PRDS_TS_ENUM` (`TELECOM_MSG_TYPE_ENUM_ID`),
  KEY `PRDS_TS_PGC` (`TELECOM_GATEWAY_CONFIG_ID`),
  KEY `PRDS_TS_CUS_MET` (`TELECOM_CUSTOM_METHOD_ID`),
  key `STR_TLM_STG_TP` (`LAST_UPDATED_TX_STAMP`),
  key `STR_TLM_STG_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDS_TS_CUS_MET` FOREIGN KEY (`TELECOM_CUSTOM_METHOD_ID`) REFERENCES `custom_method` (`CUSTOM_METHOD_ID`),
  CONSTRAINT `PRDS_TS_ENUM` FOREIGN KEY (`TELECOM_MSG_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PRDS_TS_PGC` FOREIGN KEY (`TELECOM_GATEWAY_CONFIG_ID`) REFERENCES `telecom_gateway_config` (`TELECOM_GATEWAY_CONFIG_ID`),
  CONSTRAINT `PRDS_TS_PRDS` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `PRDS_TS_TELTP` FOREIGN KEY (`TELECOM_METHOD_TYPE_ID`) REFERENCES `telecom_method_type` (`TELECOM_METHOD_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_vendor_payment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_vendor_payment` (
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VENDOR_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PAYMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CREDIT_CARD_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`VENDOR_PARTY_ID`,`PAYMENT_METHOD_TYPE_ID`,`CREDIT_CARD_ENUM_ID`),
  KEY `PRDSTRVPM_PRDS` (`PRODUCT_STORE_ID`),
  KEY `PRDSTRVPM_VPTY` (`VENDOR_PARTY_ID`),
  KEY `PRDSTRVPM_PMMT` (`PAYMENT_METHOD_TYPE_ID`),
  KEY `PRDSTRVPM_CCEN` (`CREDIT_CARD_ENUM_ID`),
  key `STR_VNR_PMT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `STR_VNR_PMT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDSTRVPM_CCEN` FOREIGN KEY (`CREDIT_CARD_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `PRDSTRVPM_PMMT` FOREIGN KEY (`PAYMENT_METHOD_TYPE_ID`) REFERENCES `payment_method_type` (`PAYMENT_METHOD_TYPE_ID`),
  CONSTRAINT `PRDSTRVPM_PRDS` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `PRDSTRVPM_VPTY` FOREIGN KEY (`VENDOR_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_vendor_shipment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_vendor_shipment` (
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VENDOR_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CARRIER_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`VENDOR_PARTY_ID`,`SHIPMENT_METHOD_TYPE_ID`,`CARRIER_PARTY_ID`),
  KEY `PRDSTRVSH_PRDS` (`PRODUCT_STORE_ID`),
  KEY `PRDSTRVSH_VPTY` (`VENDOR_PARTY_ID`),
  KEY `PRDSTRVSH_SHMT` (`SHIPMENT_METHOD_TYPE_ID`),
  KEY `PRDSTRVSH_CPTY` (`CARRIER_PARTY_ID`),
  key `STR_VNR_SHT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `STR_VNR_SHT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PRDSTRVSH_CPTY` FOREIGN KEY (`CARRIER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `PRDSTRVSH_PRDS` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `PRDSTRVSH_SHMT` FOREIGN KEY (`SHIPMENT_METHOD_TYPE_ID`) REFERENCES `shipment_method_type` (`SHIPMENT_METHOD_TYPE_ID`),
  CONSTRAINT `PRDSTRVSH_VPTY` FOREIGN KEY (`VENDOR_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_subscription_resource`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_subscription_resource` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SUBSCRIPTION_RESOURCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `PURCHASE_FROM_DATE` datetime(3) DEFAULT NULL,
  `PURCHASE_THRU_DATE` datetime(3) DEFAULT NULL,
  `MAX_LIFE_TIME` decimal(20,0) DEFAULT NULL,
  `MAX_LIFE_TIME_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AVAILABLE_TIME` decimal(20,0) DEFAULT NULL,
  `AVAILABLE_TIME_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USE_COUNT_LIMIT` decimal(20,0) DEFAULT NULL,
  `USE_TIME` decimal(20,0) DEFAULT NULL,
  `USE_TIME_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USE_ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTOMATIC_EXTEND` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CANCL_AUTM_EXT_TIME` decimal(20,0) DEFAULT NULL,
  `CANCL_AUTM_EXT_TIME_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GRACE_PERIOD_ON_EXPIRY` decimal(20,0) DEFAULT NULL,
  `GRACE_PERIOD_ON_EXPIRY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`SUBSCRIPTION_RESOURCE_ID`,`FROM_DATE`),
  KEY `PROD_SBRS_PROD` (`PRODUCT_ID`),
  KEY `PROD_SBRS_SBRS` (`SUBSCRIPTION_RESOURCE_ID`),
  KEY `PROD_SBRS_URT` (`USE_ROLE_TYPE_ID`),
  KEY `PROD_SBRS_UTU` (`USE_TIME_UOM_ID`),
  KEY `PROD_SBRS_CTU` (`CANCL_AUTM_EXT_TIME_UOM_ID`),
  KEY `PROD_SBRS_ATU` (`AVAILABLE_TIME_UOM_ID`),
  KEY `PROD_SBRS_MTU` (`MAX_LIFE_TIME_UOM_ID`),
  KEY `PROD_SBRS_GTU` (`GRACE_PERIOD_ON_EXPIRY_UOM_ID`),
  key `PRT_SBN_RSC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_SBN_RSC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_SBRS_ATU` FOREIGN KEY (`AVAILABLE_TIME_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PROD_SBRS_CTU` FOREIGN KEY (`CANCL_AUTM_EXT_TIME_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PROD_SBRS_GTU` FOREIGN KEY (`GRACE_PERIOD_ON_EXPIRY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PROD_SBRS_MTU` FOREIGN KEY (`MAX_LIFE_TIME_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `PROD_SBRS_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `PROD_SBRS_SBRS` FOREIGN KEY (`SUBSCRIPTION_RESOURCE_ID`) REFERENCES `subscription_resource` (`SUBSCRIPTION_RESOURCE_ID`),
  CONSTRAINT `PROD_SBRS_URT` FOREIGN KEY (`USE_ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`),
  CONSTRAINT `PROD_SBRS_UTU` FOREIGN KEY (`USE_TIME_UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_type` (
  `PRODUCT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_PHYSICAL` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_DIGITAL` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_TYPE_ID`),
  KEY `PROD_TYPE_PARENT` (`PARENT_TYPE_ID`),
  key `prt_PRT_TP_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_PRT_TP_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_TYPE_PARENT` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `product_type` (`PRODUCT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_type_attr` (
  `PRODUCT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_TYPE_ID`,`ATTR_NAME`),
  KEY `PROD_TYPE_ATTR` (`PRODUCT_TYPE_ID`),
  key `PRT_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `PRT_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_TYPE_ATTR` FOREIGN KEY (`PRODUCT_TYPE_ID`) REFERENCES `product_type` (`PRODUCT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quantity_break`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quantity_break` (
  `QUANTITY_BREAK_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUANTITY_BREAK_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_QUANTITY` decimal(18,6) DEFAULT NULL,
  `THRU_QUANTITY` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`QUANTITY_BREAK_ID`),
  KEY `QUANT_BRK_TYPE` (`QUANTITY_BREAK_TYPE_ID`),
  key `prt_QNT_BRK_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_QNT_BRK_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `QUANT_BRK_TYPE` FOREIGN KEY (`QUANTITY_BREAK_TYPE_ID`) REFERENCES `quantity_break_type` (`QUANTITY_BREAK_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quantity_break_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quantity_break_type` (
  `QUANTITY_BREAK_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`QUANTITY_BREAK_TYPE_ID`),
  key `QNT_BRK_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `QNT_BRK_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reorder_guideline`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reorder_guideline` (
  `REORDER_GUIDELINE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `REORDER_QUANTITY` decimal(18,6) DEFAULT NULL,
  `REORDER_LEVEL` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`REORDER_GUIDELINE_ID`),
  KEY `REORDER_GD_PROD` (`PRODUCT_ID`),
  KEY `REORDER_GD_PARTY` (`PARTY_ID`),
  KEY `REORDER_GD_FAC` (`FACILITY_ID`),
  KEY `REORDER_GD_GEO` (`GEO_ID`),
  key `prt_RRR_GDN_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_RRR_GDN_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `REORDER_GD_FAC` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `REORDER_GD_GEO` FOREIGN KEY (`GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `REORDER_GD_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `REORDER_GD_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sale_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_type` (
  `SALE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SALE_TYPE_ID`),
  key `prdt_SL_TP_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `prdt_SL_TP_TXCRS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subscription`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscription` (
  `SUBSCRIPTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUBSCRIPTION_RESOURCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMUNICATION_EVENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGINATED_FROM_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGINATED_FROM_ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_NEED_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NEED_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_CATEGORY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUBSCRIPTION_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXTERNAL_SUBSCRIPTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `PURCHASE_FROM_DATE` datetime(3) DEFAULT NULL,
  `PURCHASE_THRU_DATE` datetime(3) DEFAULT NULL,
  `MAX_LIFE_TIME` decimal(20,0) DEFAULT NULL,
  `MAX_LIFE_TIME_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AVAILABLE_TIME` decimal(20,0) DEFAULT NULL,
  `AVAILABLE_TIME_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USE_COUNT_LIMIT` decimal(20,0) DEFAULT NULL,
  `USE_TIME` decimal(20,0) DEFAULT NULL,
  `USE_TIME_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTOMATIC_EXTEND` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CANCL_AUTM_EXT_TIME` decimal(20,0) DEFAULT NULL,
  `CANCL_AUTM_EXT_TIME_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GRACE_PERIOD_ON_EXPIRY` decimal(20,0) DEFAULT NULL,
  `GRACE_PERIOD_ON_EXPIRY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXPIRATION_COMPLETED_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SUBSCRIPTION_ID`),
  KEY `SUBSC_SRESRC` (`SUBSCRIPTION_RESOURCE_ID`),
  KEY `SUBSC_CONT_MECH` (`CONTACT_MECH_ID`),
  KEY `SUBSC_PARTY` (`PARTY_ID`),
  KEY `SUBSC_UTU` (`USE_TIME_UOM_ID`),
  KEY `SUBSC_CTU` (`CANCL_AUTM_EXT_TIME_UOM_ID`),
  KEY `SUBSC_ATU` (`AVAILABLE_TIME_UOM_ID`),
  KEY `SUBSC_MTU` (`MAX_LIFE_TIME_UOM_ID`),
  KEY `SUBSC_ROLE_TYPE` (`ROLE_TYPE_ID`),
  KEY `SUBSC_OPARTY` (`ORIGINATED_FROM_PARTY_ID`),
  KEY `SUBSC_OROLE_TYPE` (`ORIGINATED_FROM_ROLE_TYPE_ID`),
  KEY `SUBSC_NEED_TYPE` (`NEED_TYPE_ID`),
  KEY `SUBSC_ORDERITM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `SUBSC_PRODUCT` (`PRODUCT_ID`),
  KEY `SUBSC_PROD_CAT` (`PRODUCT_CATEGORY_ID`),
  KEY `SUBSC_INV_ITM` (`INVENTORY_ITEM_ID`),
  KEY `SUBSC_TO_TYPE` (`SUBSCRIPTION_TYPE_ID`),
  KEY `SUBSC_GTU` (`GRACE_PERIOD_ON_EXPIRY_UOM_ID`),
  key `prt_SBSCRN_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_SBSCRN_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SUBSC_ATU` FOREIGN KEY (`AVAILABLE_TIME_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SUBSC_CONT_MECH` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `SUBSC_CTU` FOREIGN KEY (`CANCL_AUTM_EXT_TIME_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SUBSC_GTU` FOREIGN KEY (`GRACE_PERIOD_ON_EXPIRY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SUBSC_INV_ITM` FOREIGN KEY (`INVENTORY_ITEM_ID`) REFERENCES `inventory_item` (`INVENTORY_ITEM_ID`),
  CONSTRAINT `SUBSC_MTU` FOREIGN KEY (`MAX_LIFE_TIME_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SUBSC_NEED_TYPE` FOREIGN KEY (`NEED_TYPE_ID`) REFERENCES `need_type` (`NEED_TYPE_ID`),
  CONSTRAINT `SUBSC_OPARTY` FOREIGN KEY (`ORIGINATED_FROM_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `SUBSC_ORDERITM` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `SUBSC_OROLE_TYPE` FOREIGN KEY (`ORIGINATED_FROM_ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`),
  CONSTRAINT `SUBSC_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `SUBSC_PROD_CAT` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `SUBSC_PRODUCT` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `SUBSC_ROLE_TYPE` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`),
  CONSTRAINT `SUBSC_SRESRC` FOREIGN KEY (`SUBSCRIPTION_RESOURCE_ID`) REFERENCES `subscription_resource` (`SUBSCRIPTION_RESOURCE_ID`),
  CONSTRAINT `SUBSC_TO_TYPE` FOREIGN KEY (`SUBSCRIPTION_TYPE_ID`) REFERENCES `subscription_type` (`SUBSCRIPTION_TYPE_ID`),
  CONSTRAINT `SUBSC_UTU` FOREIGN KEY (`USE_TIME_UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subscription_activity`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscription_activity` (
  `SUBSCRIPTION_ACTIVITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DATE_SENT` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SUBSCRIPTION_ACTIVITY_ID`),
  key `prt_SBSN_ACT_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_SBSN_ACT_TXS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subscription_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscription_attribute` (
  `SUBSCRIPTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SUBSCRIPTION_ID`,`ATTR_NAME`),
  KEY `SUBSC_ATTR` (`SUBSCRIPTION_ID`),
  key `prt_SBSN_ATT_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_SBSN_ATT_TXS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SUBSC_ATTR` FOREIGN KEY (`SUBSCRIPTION_ID`) REFERENCES `subscription` (`SUBSCRIPTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subscription_comm_event`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscription_comm_event` (
  `SUBSCRIPTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COMMUNICATION_EVENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SUBSCRIPTION_ID`,`COMMUNICATION_EVENT_ID`),
  KEY `SUBSC_COM_EVENT` (`COMMUNICATION_EVENT_ID`),
  KEY `SUBSC_SUBSC` (`SUBSCRIPTION_ID`),
  key `SBN_CMM_EVT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SBN_CMM_EVT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SUBSC_COM_EVENT` FOREIGN KEY (`COMMUNICATION_EVENT_ID`) REFERENCES `communication_event` (`COMMUNICATION_EVENT_ID`),
  CONSTRAINT `SUBSC_SUBSC` FOREIGN KEY (`SUBSCRIPTION_ID`) REFERENCES `subscription` (`SUBSCRIPTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subscription_fulfillment_piece`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscription_fulfillment_piece` (
  `SUBSCRIPTION_ACTIVITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SUBSCRIPTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SUBSCRIPTION_ACTIVITY_ID`,`SUBSCRIPTION_ID`),
  KEY `SUBSC_FP` (`SUBSCRIPTION_ID`),
  KEY `SUBSC_FP_ACT` (`SUBSCRIPTION_ACTIVITY_ID`),
  key `SBN_FLT_PC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SBN_FLT_PC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SUBSC_FP` FOREIGN KEY (`SUBSCRIPTION_ID`) REFERENCES `subscription` (`SUBSCRIPTION_ID`),
  CONSTRAINT `SUBSC_FP_ACT` FOREIGN KEY (`SUBSCRIPTION_ACTIVITY_ID`) REFERENCES `subscription_activity` (`SUBSCRIPTION_ACTIVITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subscription_resource`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscription_resource` (
  `SUBSCRIPTION_RESOURCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_RESOURCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WEB_SITE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVICE_NAME_ON_EXPIRY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SUBSCRIPTION_RESOURCE_ID`),
  KEY `SUBSC_RES_PARENT` (`PARENT_RESOURCE_ID`),
  KEY `SUBSC_RES_CNTNT` (`CONTENT_ID`),
  KEY `SUBSC_RES_WBSITE` (`WEB_SITE_ID`),
  key `prt_SBSN_RSC_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_SBSN_RSC_TXS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SUBSC_RES_PARENT` FOREIGN KEY (`PARENT_RESOURCE_ID`) REFERENCES `subscription_resource` (`SUBSCRIPTION_RESOURCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subscription_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscription_type` (
  `SUBSCRIPTION_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SUBSCRIPTION_TYPE_ID`),
  KEY `SUBSC_TYPE_PARENT` (`PARENT_TYPE_ID`),
  key `prt_SBSCN_TP_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_SBSCN_TP_TXS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SUBSC_TYPE_PARENT` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `subscription_type` (`SUBSCRIPTION_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subscription_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscription_type_attr` (
  `SUBSCRIPTION_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SUBSCRIPTION_TYPE_ID`,`ATTR_NAME`),
  KEY `SUBSC_TYPE_ATTR` (`SUBSCRIPTION_TYPE_ID`),
  key `SBN_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SBN_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SUBSC_TYPE_ATTR` FOREIGN KEY (`SUBSCRIPTION_TYPE_ID`) REFERENCES `subscription_type` (`SUBSCRIPTION_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `supplier_pref_order`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_pref_order` (
  `SUPPLIER_PREF_ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SUPPLIER_PREF_ORDER_ID`),
  key `SPR_PRF_ORR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SPR_PRF_ORR_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `supplier_product`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_product` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AVAILABLE_FROM_DATE` datetime(3) NOT NULL,
  `AVAILABLE_THRU_DATE` datetime(3) DEFAULT NULL,
  `SUPPLIER_PREF_ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUPPLIER_RATING_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STANDARD_LEAD_TIME_DAYS` decimal(18,6) DEFAULT NULL,
  `MINIMUM_ORDER_QUANTITY` decimal(18,6) NOT NULL,
  `ORDER_QTY_INCREMENTS` decimal(18,6) DEFAULT NULL,
  `UNITS_INCLUDED` decimal(18,6) DEFAULT NULL,
  `QUANTITY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AGREEMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AGREEMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_PRICE` decimal(18,3) DEFAULT NULL,
  `SHIPPING_PRICE` decimal(18,3) DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SUPPLIER_PRODUCT_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUPPLIER_PRODUCT_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CAN_DROP_SHIP` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`PARTY_ID`,`CURRENCY_UOM_ID`,`MINIMUM_ORDER_QUANTITY`,`AVAILABLE_FROM_DATE`),
  KEY `SUPPL_PROD_PROD` (`PRODUCT_ID`),
  KEY `SUPPL_PROD_PARTY` (`PARTY_ID`),
  KEY `SUPPL_PROD_SPORD` (`SUPPLIER_PREF_ORDER_ID`),
  KEY `SUPPL_PROD_SRTPE` (`SUPPLIER_RATING_TYPE_ID`),
  KEY `SUPPL_PROD_CUOM` (`CURRENCY_UOM_ID`),
  KEY `SUPPL_PROD_QUOM` (`QUANTITY_UOM_ID`),
  KEY `SUPPL_PROD_AGRIT` (`AGREEMENT_ID`,`AGREEMENT_ITEM_SEQ_ID`),
  key `prt_SPR_PRT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_SPR_PRT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SUPPL_PROD_AGRIT` FOREIGN KEY (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`) REFERENCES `agreement_item` (`AGREEMENT_ID`, `AGREEMENT_ITEM_SEQ_ID`),
  CONSTRAINT `SUPPL_PROD_CUOM` FOREIGN KEY (`CURRENCY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SUPPL_PROD_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `SUPPL_PROD_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `SUPPL_PROD_QUOM` FOREIGN KEY (`QUANTITY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SUPPL_PROD_SPORD` FOREIGN KEY (`SUPPLIER_PREF_ORDER_ID`) REFERENCES `supplier_pref_order` (`SUPPLIER_PREF_ORDER_ID`),
  CONSTRAINT `SUPPL_PROD_SRTPE` FOREIGN KEY (`SUPPLIER_RATING_TYPE_ID`) REFERENCES `supplier_rating_type` (`SUPPLIER_RATING_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `supplier_product_feature`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_product_feature` (
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ID_CODE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`PRODUCT_FEATURE_ID`),
  KEY `SUPPL_FEAT_PARTY` (`PARTY_ID`),
  KEY `SUPPL_FEAT_FEAT` (`PRODUCT_FEATURE_ID`),
  KEY `SUPPL_FEAT_UOM` (`UOM_ID`),
  key `SPR_PRT_FTR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SPR_PRT_FTR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SUPPL_FEAT_FEAT` FOREIGN KEY (`PRODUCT_FEATURE_ID`) REFERENCES `product_feature` (`PRODUCT_FEATURE_ID`),
  CONSTRAINT `SUPPL_FEAT_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `SUPPL_FEAT_UOM` FOREIGN KEY (`UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `supplier_rating_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_rating_type` (
  `SUPPLIER_RATING_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SUPPLIER_RATING_TYPE_ID`),
  key `SPR_RTG_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SPR_RTG_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `variance_reason`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `variance_reason` (
  `VARIANCE_REASON_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`VARIANCE_REASON_ID`),
  key `prt_VRC_RSN_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_VRC_RSN_TXCS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vendor_product`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendor_product` (
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VENDOR_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_STORE_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`VENDOR_PARTY_ID`,`PRODUCT_STORE_GROUP_ID`),
  KEY `VENDPROD_PROD` (`PRODUCT_ID`),
  KEY `VENDPROD_VPTY` (`VENDOR_PARTY_ID`),
  KEY `VENDPROD_PSGRP` (`PRODUCT_STORE_GROUP_ID`),
  key `prt_VNR_PRT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `prt_VNR_PRT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `VENDPROD_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `VENDPROD_PSGRP` FOREIGN KEY (`PRODUCT_STORE_GROUP_ID`) REFERENCES `product_store_group` (`PRODUCT_STORE_GROUP_ID`),
  CONSTRAINT `VENDPROD_VPTY` FOREIGN KEY (`VENDOR_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `carrier_shipment_box_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrier_shipment_box_type` (
  `SHIPMENT_BOX_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PACKAGING_TYPE_CODE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OVERSIZE_CODE` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_BOX_TYPE_ID`,`PARTY_ID`),
  KEY `CARR_SHBX_TYPE` (`SHIPMENT_BOX_TYPE_ID`),
  KEY `CARR_SHBX_PARTY` (`PARTY_ID`),
  key `CRR_SHT_BX_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CRR_SHT_BX_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CARR_SHBX_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `CARR_SHBX_TYPE` FOREIGN KEY (`SHIPMENT_BOX_TYPE_ID`) REFERENCES `shipment_box_type` (`SHIPMENT_BOX_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `carrier_shipment_method`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrier_shipment_method` (
  `SHIPMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUMBER` decimal(20,0) DEFAULT NULL,
  `CARRIER_SERVICE_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_METHOD_TYPE_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `CARR_SHMETH_TYPE` (`SHIPMENT_METHOD_TYPE_ID`),
  KEY `CARR_SHMETH_PARTY` (`PARTY_ID`),
  KEY `CARR_SHMETH_PROLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  key `CRR_SHT_MTD_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CRR_SHT_MTD_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `CARR_SHMETH_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `CARR_SHMETH_PROLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `CARR_SHMETH_TYPE` FOREIGN KEY (`SHIPMENT_METHOD_TYPE_ID`) REFERENCES `shipment_method_type` (`SHIPMENT_METHOD_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `delivery`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery` (
  `DELIVERY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORIGIN_FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEST_FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACTUAL_START_DATE` datetime(3) DEFAULT NULL,
  `ACTUAL_ARRIVAL_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_START_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_ARRIVAL_DATE` datetime(3) DEFAULT NULL,
  `FIXED_ASSET_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `START_MILEAGE` decimal(18,6) DEFAULT NULL,
  `END_MILEAGE` decimal(18,6) DEFAULT NULL,
  `FUEL_USED` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DELIVERY_ID`),
  KEY `DELIV_FXAS` (`FIXED_ASSET_ID`),
  KEY `DELIV_OFAC` (`ORIGIN_FACILITY_ID`),
  KEY `DELIV_DFAC` (`DEST_FACILITY_ID`),
  key `shpmt_DLR_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  key `shpmt_DLR_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `DELIV_DFAC` FOREIGN KEY (`DEST_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `DELIV_OFAC` FOREIGN KEY (`ORIGIN_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_issuance`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_issuance` (
  `ITEM_ISSUANCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIXED_ASSET_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MAINT_HIST_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ISSUED_DATE_TIME` datetime(3) DEFAULT NULL,
  `ISSUED_BY_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `CANCEL_QUANTITY` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ITEM_ISSUANCE_ID`),
  KEY `ITEM_ISS_INVITM` (`INVENTORY_ITEM_ID`),
  KEY `ITEM_ISS_SHITM` (`SHIPMENT_ID`,`SHIPMENT_ITEM_SEQ_ID`),
  KEY `ITEM_ISS_FAMNT` (`FIXED_ASSET_ID`,`MAINT_HIST_SEQ_ID`),
  KEY `ITEM_ISS_ORITM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `ITEM_ISS_IBUL` (`ISSUED_BY_USER_LOGIN_ID`),
  key `sht_ITM_ISC_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `sht_ITM_ISC_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ITEM_ISS_IBUL` FOREIGN KEY (`ISSUED_BY_USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `ITEM_ISS_INVITM` FOREIGN KEY (`INVENTORY_ITEM_ID`) REFERENCES `inventory_item` (`INVENTORY_ITEM_ID`),
  CONSTRAINT `ITEM_ISS_ORITM` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `ITEM_ISS_SHITM` FOREIGN KEY (`SHIPMENT_ID`, `SHIPMENT_ITEM_SEQ_ID`) REFERENCES `shipment_item` (`SHIPMENT_ID`, `SHIPMENT_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_issuance_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_issuance_role` (
  `ITEM_ISSUANCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ITEM_ISSUANCE_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `ITEM_ISSRL_ITMIS` (`ITEM_ISSUANCE_ID`),
  KEY `ITEM_ISSRL_PTY` (`PARTY_ID`),
  KEY `ITEM_ISSRL_PTRL` (`PARTY_ID`,`ROLE_TYPE_ID`),
  key `ITM_ISC_RL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ITM_ISC_RL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ITEM_ISSRL_ITMIS` FOREIGN KEY (`ITEM_ISSUANCE_ID`) REFERENCES `item_issuance` (`ITEM_ISSUANCE_ID`),
  CONSTRAINT `ITEM_ISSRL_PTRL` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `ITEM_ISSRL_PTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `picklist`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `picklist` (
  `PICKLIST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PICKLIST_DATE` datetime(3) DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PICKLIST_ID`),
  KEY `PICKLST_FLTY` (`FACILITY_ID`),
  KEY `PICKLST_SMTP` (`SHIPMENT_METHOD_TYPE_ID`),
  KEY `PICKLST_STTS` (`STATUS_ID`),
  key `shpmt_PCKT_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `shpmt_PCKT_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PICKLST_FLTY` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `PICKLST_SMTP` FOREIGN KEY (`SHIPMENT_METHOD_TYPE_ID`) REFERENCES `shipment_method_type` (`SHIPMENT_METHOD_TYPE_ID`),
  CONSTRAINT `PICKLST_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `picklist_bin`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `picklist_bin` (
  `PICKLIST_BIN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PICKLIST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BIN_LOCATION_NUMBER` decimal(20,0) DEFAULT NULL,
  `PRIMARY_ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIMARY_SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PICKLIST_BIN_ID`),
  KEY `PCKLST_BIN_PKLT` (`PICKLIST_ID`),
  KEY `PCKLST_BIN_OISG` (`PRIMARY_ORDER_ID`,`PRIMARY_SHIP_GROUP_SEQ_ID`),
  key `shpt_PCT_BN_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `shpt_PCT_BN_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PCKLST_BIN_OISG` FOREIGN KEY (`PRIMARY_ORDER_ID`, `PRIMARY_SHIP_GROUP_SEQ_ID`) REFERENCES `order_item_ship_group` (`ORDER_ID`, `SHIP_GROUP_SEQ_ID`),
  CONSTRAINT `PCKLST_BIN_PKLT` FOREIGN KEY (`PICKLIST_ID`) REFERENCES `picklist` (`PICKLIST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `picklist_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `picklist_item` (
  `PICKLIST_BIN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ITEM_STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PICKLIST_BIN_ID`,`ORDER_ID`,`ORDER_ITEM_SEQ_ID`,`SHIP_GROUP_SEQ_ID`,`INVENTORY_ITEM_ID`),
  KEY `PCKLST_ITM_BIN` (`PICKLIST_BIN_ID`),
  KEY `PCKLST_ITM_OISG` (`ORDER_ID`,`SHIP_GROUP_SEQ_ID`),
  KEY `PCKLST_ITM_ODIT` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `PICKLST_ITM_STTS` (`ITEM_STATUS_ID`),
  KEY `PCKLST_ITM_INV` (`INVENTORY_ITEM_ID`),
  key `sht_PCT_ITM_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `sht_PCT_ITM_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PCKLST_ITM_BIN` FOREIGN KEY (`PICKLIST_BIN_ID`) REFERENCES `picklist_bin` (`PICKLIST_BIN_ID`),
  CONSTRAINT `PCKLST_ITM_INV` FOREIGN KEY (`INVENTORY_ITEM_ID`) REFERENCES `inventory_item` (`INVENTORY_ITEM_ID`),
  CONSTRAINT `PCKLST_ITM_ODIT` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `PCKLST_ITM_OISG` FOREIGN KEY (`ORDER_ID`, `SHIP_GROUP_SEQ_ID`) REFERENCES `order_item_ship_group` (`ORDER_ID`, `SHIP_GROUP_SEQ_ID`),
  CONSTRAINT `PICKLST_ITM_STTS` FOREIGN KEY (`ITEM_STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `picklist_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `picklist_role` (
  `PICKLIST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PICKLIST_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`FROM_DATE`),
  KEY `PCKLST_RLE_PKLT` (`PICKLIST_ID`),
  KEY `PCKLST_RLE_PRLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `PCKLST_RLE_CBUL` (`CREATED_BY_USER_LOGIN`),
  KEY `PCKLST_RLE_LMUL` (`LAST_MODIFIED_BY_USER_LOGIN`),
  key `shpt_PCT_RL_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `shpt_PCT_RL_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PCKLST_RLE_CBUL` FOREIGN KEY (`CREATED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PCKLST_RLE_LMUL` FOREIGN KEY (`LAST_MODIFIED_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PCKLST_RLE_PKLT` FOREIGN KEY (`PICKLIST_ID`) REFERENCES `picklist` (`PICKLIST_ID`),
  CONSTRAINT `PCKLST_RLE_PRLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `picklist_status`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `picklist_status` (
  `PICKLIST_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_DATE` datetime(3) NOT NULL,
  `CHANGE_BY_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PICKLIST_ID`,`STATUS_DATE`),
  KEY `PCKLST_STST_PKLT` (`PICKLIST_ID`),
  KEY `PCKLST_STST_CUL` (`CHANGE_BY_USER_LOGIN_ID`),
  KEY `PCKLST_STST_FSI` (`STATUS_ID`),
  KEY `PCKLST_STST_TSI` (`STATUS_ID_TO`),
  key `sht_PCT_STS_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `sht_PCT_STS_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PCKLST_STST_CUL` FOREIGN KEY (`CHANGE_BY_USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `PCKLST_STST_FSI` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `PCKLST_STST_PKLT` FOREIGN KEY (`PICKLIST_ID`) REFERENCES `picklist` (`PICKLIST_ID`),
  CONSTRAINT `PCKLST_STST_TSI` FOREIGN KEY (`STATUS_ID_TO`) REFERENCES `status_item` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rejection_reason`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rejection_reason` (
  `REJECTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`REJECTION_ID`),
  key `sht_RJN_RSN_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `sht_RJN_RSN_TXCS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment` (
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIMARY_ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIMARY_RETURN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIMARY_SHIP_GROUP_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PICKLIST_BIN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ESTIMATED_READY_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_SHIP_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_SHIP_WORK_EFF_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ESTIMATED_ARRIVAL_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_ARRIVAL_WORK_EFF_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LATEST_CANCEL_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_SHIP_COST` decimal(18,2) DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HANDLING_INSTRUCTIONS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESTINATION_FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_TELECOM_NUMBER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESTINATION_CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESTINATION_TELECOM_NUMBER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ADDITIONAL_SHIPPING_CHARGE` decimal(18,2) DEFAULT NULL,
  `ADDTL_SHIPPING_CHARGE_DESC` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`),
  KEY `SHPMNT_TYPE` (`SHIPMENT_TYPE_ID`),
  KEY `SHPMNT_STTS` (`STATUS_ID`),
  KEY `SHPMNT_ESHWEFF` (`ESTIMATED_SHIP_WORK_EFF_ID`),
  KEY `SHPMNT_EARRWEFF` (`ESTIMATED_ARRIVAL_WORK_EFF_ID`),
  KEY `SHPMNT_CUOM` (`CURRENCY_UOM_ID`),
  KEY `SHPMNT_OFAC` (`ORIGIN_FACILITY_ID`),
  KEY `SHPMNT_DFAC` (`DESTINATION_FACILITY_ID`),
  KEY `SHPMNT_OPAD` (`ORIGIN_CONTACT_MECH_ID`),
  KEY `SHPMNT_OTCN` (`ORIGIN_TELECOM_NUMBER_ID`),
  KEY `SHPMNT_DPAD` (`DESTINATION_CONTACT_MECH_ID`),
  KEY `SHPMNT_DTCN` (`DESTINATION_TELECOM_NUMBER_ID`),
  KEY `SHPMNT_PODR` (`PRIMARY_ORDER_ID`),
  KEY `SHPMNT_PRTNHDR` (`PRIMARY_RETURN_ID`),
  KEY `SHPMNT_PKLSTBIN` (`PICKLIST_BIN_ID`),
  KEY `SHPMNT_PRTYTO` (`PARTY_ID_TO`),
  KEY `SHPMNT_PRTYFM` (`PARTY_ID_FROM`),
  key `shpmt_SHPT_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `shpmt_SHPT_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHPMNT_CUOM` FOREIGN KEY (`CURRENCY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SHPMNT_DFAC` FOREIGN KEY (`DESTINATION_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `SHPMNT_DPAD` FOREIGN KEY (`DESTINATION_CONTACT_MECH_ID`) REFERENCES `postal_address` (`CONTACT_MECH_ID`),
  CONSTRAINT `SHPMNT_DTCN` FOREIGN KEY (`DESTINATION_TELECOM_NUMBER_ID`) REFERENCES `telecom_number` (`CONTACT_MECH_ID`),
  CONSTRAINT `SHPMNT_EARRWEFF` FOREIGN KEY (`ESTIMATED_ARRIVAL_WORK_EFF_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`),
  CONSTRAINT `SHPMNT_ESHWEFF` FOREIGN KEY (`ESTIMATED_SHIP_WORK_EFF_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`),
  CONSTRAINT `SHPMNT_OFAC` FOREIGN KEY (`ORIGIN_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `SHPMNT_OPAD` FOREIGN KEY (`ORIGIN_CONTACT_MECH_ID`) REFERENCES `postal_address` (`CONTACT_MECH_ID`),
  CONSTRAINT `SHPMNT_OTCN` FOREIGN KEY (`ORIGIN_TELECOM_NUMBER_ID`) REFERENCES `telecom_number` (`CONTACT_MECH_ID`),
  CONSTRAINT `SHPMNT_PKLSTBIN` FOREIGN KEY (`PICKLIST_BIN_ID`) REFERENCES `picklist_bin` (`PICKLIST_BIN_ID`),
  CONSTRAINT `SHPMNT_PODR` FOREIGN KEY (`PRIMARY_ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `SHPMNT_PRTNHDR` FOREIGN KEY (`PRIMARY_RETURN_ID`) REFERENCES `return_header` (`RETURN_ID`),
  CONSTRAINT `SHPMNT_PRTYFM` FOREIGN KEY (`PARTY_ID_FROM`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `SHPMNT_PRTYTO` FOREIGN KEY (`PARTY_ID_TO`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `SHPMNT_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `SHPMNT_TYPE` FOREIGN KEY (`SHIPMENT_TYPE_ID`) REFERENCES `shipment_type` (`SHIPMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_attribute` (
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`ATTR_NAME`),
  KEY `SHPMNT_ATTR` (`SHIPMENT_ID`),
  key `sht_SHT_ATT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `sht_SHT_ATT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHPMNT_ATTR` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_box_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_box_type` (
  `SHIPMENT_BOX_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DIMENSION_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BOX_LENGTH` decimal(18,6) DEFAULT NULL,
  `BOX_WIDTH` decimal(18,6) DEFAULT NULL,
  `BOX_HEIGHT` decimal(18,6) DEFAULT NULL,
  `WEIGHT_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BOX_WEIGHT` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_BOX_TYPE_ID`),
  KEY `SHMT_BXTP_DUOM` (`DIMENSION_UOM_ID`),
  KEY `SHMT_BXTP_WUOM` (`WEIGHT_UOM_ID`),
  key `sht_SHT_BX_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `sht_SHT_BX_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHMT_BXTP_DUOM` FOREIGN KEY (`DIMENSION_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SHMT_BXTP_WUOM` FOREIGN KEY (`WEIGHT_UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_contact_mech` (
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_CONTACT_MECH_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`SHIPMENT_CONTACT_MECH_TYPE_ID`),
  KEY `SHPMT_CMECH` (`SHIPMENT_ID`),
  KEY `SHPMT_CMECH_CM` (`CONTACT_MECH_ID`),
  KEY `SHPMT_CMECH_TYPE` (`SHIPMENT_CONTACT_MECH_TYPE_ID`),
  key `SHT_CNT_MCH_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_CNT_MCH_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHPMT_CMECH` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`),
  CONSTRAINT `SHPMT_CMECH_CM` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `SHPMT_CMECH_TYPE` FOREIGN KEY (`SHIPMENT_CONTACT_MECH_TYPE_ID`) REFERENCES `shipment_contact_mech_type` (`SHIPMENT_CONTACT_MECH_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_contact_mech_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_contact_mech_type` (
  `SHIPMENT_CONTACT_MECH_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_CONTACT_MECH_TYPE_ID`),
  key `CNT_MCH_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `CNT_MCH_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_cost_estimate`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_cost_estimate` (
  `SHIPMENT_COST_ESTIMATE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_SHIP_METH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WEIGHT_BREAK_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WEIGHT_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WEIGHT_UNIT_PRICE` decimal(18,2) DEFAULT NULL,
  `QUANTITY_BREAK_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY_UNIT_PRICE` decimal(18,2) DEFAULT NULL,
  `PRICE_BREAK_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRICE_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRICE_UNIT_PRICE` decimal(18,2) DEFAULT NULL,
  `ORDER_FLAT_PRICE` decimal(18,2) DEFAULT NULL,
  `ORDER_PRICE_PERCENT` decimal(18,6) DEFAULT NULL,
  `ORDER_ITEM_FLAT_PRICE` decimal(18,2) DEFAULT NULL,
  `SHIPPING_PRICE_PERCENT` decimal(18,6) DEFAULT NULL,
  `PRODUCT_FEATURE_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OVERSIZE_UNIT` decimal(18,6) DEFAULT NULL,
  `OVERSIZE_PRICE` decimal(18,2) DEFAULT NULL,
  `FEATURE_PERCENT` decimal(18,6) DEFAULT NULL,
  `FEATURE_PRICE` decimal(18,2) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_COST_ESTIMATE_ID`),
  KEY `SHPMNT_CE_CSHMTH` (`SHIPMENT_METHOD_TYPE_ID`,`CARRIER_PARTY_ID`,`CARRIER_ROLE_TYPE_ID`),
  KEY `SHPMNT_PS_SH_METH` (`PRODUCT_STORE_SHIP_METH_ID`),
  KEY `SHPMNT_CE_PARTY` (`PARTY_ID`),
  KEY `SHPMNT_CE_ROLET` (`ROLE_TYPE_ID`),
  KEY `SHPMNT_CE_WUOM` (`WEIGHT_UOM_ID`),
  KEY `SHPMNT_CE_QUOM` (`QUANTITY_UOM_ID`),
  KEY `SHPMNT_CE_PUOM` (`PRICE_UOM_ID`),
  KEY `SHPMNT_CE_TGEO` (`GEO_ID_TO`),
  KEY `SHPMNT_CE_FGEO` (`GEO_ID_FROM`),
  KEY `SHPMNT_CE_WHT_QB` (`WEIGHT_BREAK_ID`),
  KEY `SHPMNT_CE_QNT_QB` (`QUANTITY_BREAK_ID`),
  KEY `SHPMNT_CE_PRC_QB` (`PRICE_BREAK_ID`),
  key `SHT_CST_EST_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_CST_EST_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHPMNT_CE_CSHMTH` FOREIGN KEY (`SHIPMENT_METHOD_TYPE_ID`, `CARRIER_PARTY_ID`, `CARRIER_ROLE_TYPE_ID`) REFERENCES `carrier_shipment_method` (`SHIPMENT_METHOD_TYPE_ID`, `PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `SHPMNT_CE_FGEO` FOREIGN KEY (`GEO_ID_FROM`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `SHPMNT_CE_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `SHPMNT_CE_PRC_QB` FOREIGN KEY (`PRICE_BREAK_ID`) REFERENCES `quantity_break` (`QUANTITY_BREAK_ID`),
  CONSTRAINT `SHPMNT_CE_PUOM` FOREIGN KEY (`PRICE_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SHPMNT_CE_QNT_QB` FOREIGN KEY (`QUANTITY_BREAK_ID`) REFERENCES `quantity_break` (`QUANTITY_BREAK_ID`),
  CONSTRAINT `SHPMNT_CE_QUOM` FOREIGN KEY (`QUANTITY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SHPMNT_CE_ROLET` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`),
  CONSTRAINT `SHPMNT_CE_TGEO` FOREIGN KEY (`GEO_ID_TO`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `SHPMNT_CE_WHT_QB` FOREIGN KEY (`WEIGHT_BREAK_ID`) REFERENCES `quantity_break` (`QUANTITY_BREAK_ID`),
  CONSTRAINT `SHPMNT_CE_WUOM` FOREIGN KEY (`WEIGHT_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SHPMNT_PS_SH_METH` FOREIGN KEY (`PRODUCT_STORE_SHIP_METH_ID`) REFERENCES `product_store_shipment_meth` (`PRODUCT_STORE_SHIP_METH_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_gateway_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_gateway_config` (
  `SHIPMENT_GATEWAY_CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_GATEWAY_CONF_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_GATEWAY_CONFIG_ID`),
  KEY `SGC_SGCT` (`SHIPMENT_GATEWAY_CONF_TYPE_ID`),
  key `SHT_GTW_CNG_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_GTW_CNG_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SGC_SGCT` FOREIGN KEY (`SHIPMENT_GATEWAY_CONF_TYPE_ID`) REFERENCES `shipment_gateway_config_type` (`SHIPMENT_GATEWAY_CONF_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_gateway_config_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_gateway_config_type` (
  `SHIPMENT_GATEWAY_CONF_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_GATEWAY_CONF_TYPE_ID`),
  KEY `SGCT_PAR` (`PARENT_TYPE_ID`),
  key `GTW_CNG_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `GTW_CNG_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SGCT_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `shipment_gateway_config_type` (`SHIPMENT_GATEWAY_CONF_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_gateway_dhl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_gateway_dhl` (
  `SHIPMENT_GATEWAY_CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONNECT_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONNECT_TIMEOUT` decimal(20,0) DEFAULT NULL,
  `HEAD_VERSION` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HEAD_ACTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCESS_USER_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCESS_PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCESS_ACCOUNT_NBR` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCESS_SHIPPING_KEY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LABEL_IMAGE_FORMAT` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RATE_ESTIMATE_TEMPLATE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_GATEWAY_CONFIG_ID`),
  KEY `SGDHL_SGC` (`SHIPMENT_GATEWAY_CONFIG_ID`),
  key `SHT_GTW_DHL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_GTW_DHL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SGDHL_SGC` FOREIGN KEY (`SHIPMENT_GATEWAY_CONFIG_ID`) REFERENCES `shipment_gateway_config` (`SHIPMENT_GATEWAY_CONFIG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_gateway_fedex`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_gateway_fedex` (
  `SHIPMENT_GATEWAY_CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONNECT_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONNECT_SOAP_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONNECT_TIMEOUT` decimal(20,0) DEFAULT NULL,
  `ACCESS_ACCOUNT_NBR` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCESS_METER_NUMBER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCESS_USER_KEY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCESS_USER_PWD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LABEL_IMAGE_TYPE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_DROPOFF_TYPE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_PACKAGING_TYPE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TEMPLATE_SHIPMENT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TEMPLATE_SUBSCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RATE_ESTIMATE_TEMPLATE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_GATEWAY_CONFIG_ID`),
  KEY `SGFED_SGC` (`SHIPMENT_GATEWAY_CONFIG_ID`),
  key `SHT_GTW_FDX_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_GTW_FDX_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SGFED_SGC` FOREIGN KEY (`SHIPMENT_GATEWAY_CONFIG_ID`) REFERENCES `shipment_gateway_config` (`SHIPMENT_GATEWAY_CONFIG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_gateway_ups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_gateway_ups` (
  `SHIPMENT_GATEWAY_CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONNECT_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONNECT_TIMEOUT` decimal(20,0) DEFAULT NULL,
  `SHIPPER_NUMBER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BILL_SHIPPER_ACCOUNT_NUMBER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCESS_LICENSE_NUMBER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCESS_USER_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCESS_PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SAVE_CERT_INFO` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SAVE_CERT_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPPER_PICKUP_TYPE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOMER_CLASSIFICATION` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MAX_ESTIMATE_WEIGHT` decimal(18,6) DEFAULT NULL,
  `MIN_ESTIMATE_WEIGHT` decimal(18,6) DEFAULT NULL,
  `COD_ALLOW_COD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COD_SURCHARGE_AMOUNT` decimal(18,6) DEFAULT NULL,
  `COD_SURCHARGE_CURRENCY_UOM_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COD_SURCHARGE_APPLY_TO_PACKAGE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COD_FUNDS_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_RETURN_LABEL_MEMO` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_RETURN_LABEL_SUBJECT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_GATEWAY_CONFIG_ID`),
  KEY `SGUPS_SGC` (`SHIPMENT_GATEWAY_CONFIG_ID`),
  key `SHT_GTW_UPS_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_GTW_UPS_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SGUPS_SGC` FOREIGN KEY (`SHIPMENT_GATEWAY_CONFIG_ID`) REFERENCES `shipment_gateway_config` (`SHIPMENT_GATEWAY_CONFIG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_gateway_usps`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_gateway_usps` (
  `SHIPMENT_GATEWAY_CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONNECT_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONNECT_URL_LABELS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONNECT_TIMEOUT` decimal(20,0) DEFAULT NULL,
  `ACCESS_USER_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCESS_PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MAX_ESTIMATE_WEIGHT` decimal(20,0) DEFAULT NULL,
  `TEST` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_GATEWAY_CONFIG_ID`),
  KEY `SGUSPS_SGC` (`SHIPMENT_GATEWAY_CONFIG_ID`),
  key `SHT_GTW_USS_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_GTW_USS_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SGUSPS_SGC` FOREIGN KEY (`SHIPMENT_GATEWAY_CONFIG_ID`) REFERENCES `shipment_gateway_config` (`SHIPMENT_GATEWAY_CONFIG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_item` (
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `SHIPMENT_CONTENT_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`SHIPMENT_ITEM_SEQ_ID`),
  KEY `SHPMNT_ITM_SHPMT` (`SHIPMENT_ID`),
  KEY `SHPMNT_ITM_PROD` (`PRODUCT_ID`),
  key `sht_SHT_ITM_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `sht_SHT_ITM_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHPMNT_ITM_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `SHPMNT_ITM_SHPMT` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_item_billing`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_item_billing` (
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`SHIPMENT_ITEM_SEQ_ID`,`INVOICE_ID`,`INVOICE_ITEM_SEQ_ID`),
  KEY `SHPMNT_ITBL_SPIM` (`SHIPMENT_ID`,`SHIPMENT_ITEM_SEQ_ID`),
  KEY `SHPMNT_ITBL_INIM` (`INVOICE_ID`,`INVOICE_ITEM_SEQ_ID`),
  key `SHT_ITM_BLG_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_ITM_BLG_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHPMNT_ITBL_SPIM` FOREIGN KEY (`SHIPMENT_ID`, `SHIPMENT_ITEM_SEQ_ID`) REFERENCES `shipment_item` (`SHIPMENT_ID`, `SHIPMENT_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_item_feature`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_item_feature` (
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`SHIPMENT_ITEM_SEQ_ID`,`PRODUCT_FEATURE_ID`),
  KEY `SHPMNT_ITFT_SPIM` (`SHIPMENT_ID`,`SHIPMENT_ITEM_SEQ_ID`),
  KEY `SHPMNT_ITFT_FEAT` (`PRODUCT_FEATURE_ID`),
  key `SHT_ITM_FTR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_ITM_FTR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHPMNT_ITFT_FEAT` FOREIGN KEY (`PRODUCT_FEATURE_ID`) REFERENCES `product_feature` (`PRODUCT_FEATURE_ID`),
  CONSTRAINT `SHPMNT_ITFT_SPIM` FOREIGN KEY (`SHIPMENT_ID`, `SHIPMENT_ITEM_SEQ_ID`) REFERENCES `shipment_item` (`SHIPMENT_ID`, `SHIPMENT_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_method_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_method_type` (
  `SHIPMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_METHOD_TYPE_ID`),
  key `SHT_MTD_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_MTD_TP_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_package`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_package` (
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_PACKAGE_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_BOX_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DATE_CREATED` datetime(3) DEFAULT NULL,
  `BOX_LENGTH` decimal(18,6) DEFAULT NULL,
  `BOX_HEIGHT` decimal(18,6) DEFAULT NULL,
  `BOX_WIDTH` decimal(18,6) DEFAULT NULL,
  `DIMENSION_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WEIGHT` decimal(18,6) DEFAULT NULL,
  `WEIGHT_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INSURED_VALUE` decimal(18,2) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`SHIPMENT_PACKAGE_SEQ_ID`),
  KEY `SHPKG_SHPMNT` (`SHIPMENT_ID`),
  KEY `SHPKG_BXTYP` (`SHIPMENT_BOX_TYPE_ID`),
  KEY `SHPKG_DUOM` (`DIMENSION_UOM_ID`),
  KEY `SHPKG_WUOM` (`WEIGHT_UOM_ID`),
  key `sht_SHT_PCG_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `sht_SHT_PCG_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHPKG_BXTYP` FOREIGN KEY (`SHIPMENT_BOX_TYPE_ID`) REFERENCES `shipment_box_type` (`SHIPMENT_BOX_TYPE_ID`),
  CONSTRAINT `SHPKG_DUOM` FOREIGN KEY (`DIMENSION_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SHPKG_SHPMNT` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`),
  CONSTRAINT `SHPKG_WUOM` FOREIGN KEY (`WEIGHT_UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_package_content`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_package_content` (
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_PACKAGE_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUANTITY` decimal(18,6) DEFAULT NULL,
  `SUB_PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUB_PRODUCT_QUANTITY` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`SHIPMENT_PACKAGE_SEQ_ID`,`SHIPMENT_ITEM_SEQ_ID`),
  KEY `PCK_CNTNT_SHPKG` (`SHIPMENT_ID`,`SHIPMENT_PACKAGE_SEQ_ID`),
  KEY `PCK_CNTNT_SHITM` (`SHIPMENT_ID`,`SHIPMENT_ITEM_SEQ_ID`),
  KEY `PCK_CNTNT_PROD` (`SUB_PRODUCT_ID`),
  key `SHT_PCG_CNT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_PCG_CNT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PCK_CNTNT_PROD` FOREIGN KEY (`SUB_PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `PCK_CNTNT_SHITM` FOREIGN KEY (`SHIPMENT_ID`, `SHIPMENT_ITEM_SEQ_ID`) REFERENCES `shipment_item` (`SHIPMENT_ID`, `SHIPMENT_ITEM_SEQ_ID`),
  CONSTRAINT `PCK_CNTNT_SHPKG` FOREIGN KEY (`SHIPMENT_ID`, `SHIPMENT_PACKAGE_SEQ_ID`) REFERENCES `shipment_package` (`SHIPMENT_ID`, `SHIPMENT_PACKAGE_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_package_route_seg`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_package_route_seg` (
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_PACKAGE_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_ROUTE_SEGMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TRACKING_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BOX_NUMBER` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LABEL_IMAGE` longblob,
  `LABEL_INTL_SIGN_IMAGE` longblob,
  `LABEL_HTML` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `LABEL_PRINTED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INTERNATIONAL_INVOICE` longblob,
  `PACKAGE_TRANSPORT_COST` decimal(18,2) DEFAULT NULL,
  `PACKAGE_SERVICE_COST` decimal(18,2) DEFAULT NULL,
  `PACKAGE_OTHER_COST` decimal(18,2) DEFAULT NULL,
  `COD_AMOUNT` decimal(18,2) DEFAULT NULL,
  `INSURED_AMOUNT` decimal(18,2) DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`SHIPMENT_PACKAGE_SEQ_ID`,`SHIPMENT_ROUTE_SEGMENT_ID`),
  KEY `SHPKRTSG_SHPKG` (`SHIPMENT_ID`,`SHIPMENT_PACKAGE_SEQ_ID`),
  KEY `SHPKRTSG_RTSG` (`SHIPMENT_ID`,`SHIPMENT_ROUTE_SEGMENT_ID`),
  KEY `SHPKRTSG_CUOM` (`CURRENCY_UOM_ID`),
  key `SHT_PCG_RT_SG_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_PCG_RT_SG_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHPKRTSG_CUOM` FOREIGN KEY (`CURRENCY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SHPKRTSG_RTSG` FOREIGN KEY (`SHIPMENT_ID`, `SHIPMENT_ROUTE_SEGMENT_ID`) REFERENCES `shipment_route_segment` (`SHIPMENT_ID`, `SHIPMENT_ROUTE_SEGMENT_ID`),
  CONSTRAINT `SHPKRTSG_SHPKG` FOREIGN KEY (`SHIPMENT_ID`, `SHIPMENT_PACKAGE_SEQ_ID`) REFERENCES `shipment_package` (`SHIPMENT_ID`, `SHIPMENT_PACKAGE_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_receipt`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_receipt` (
  `RECEIPT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_PACKAGE_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REJECTION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECEIVED_BY_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DATETIME_RECEIVED` datetime(3) DEFAULT NULL,
  `ITEM_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY_ACCEPTED` decimal(18,6) DEFAULT NULL,
  `QUANTITY_REJECTED` decimal(18,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RECEIPT_ID`),
  KEY `SHP_RCPT_INVITM` (`INVENTORY_ITEM_ID`),
  KEY `SHP_RCPT_PROD` (`PRODUCT_ID`),
  KEY `SHP_RCPT_SHPKG` (`SHIPMENT_ID`,`SHIPMENT_PACKAGE_SEQ_ID`),
  KEY `SHP_RCPT_ORDITM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `SHP_RCPT_REJRSN` (`REJECTION_ID`),
  KEY `SHP_RCPT_USERLGN` (`RECEIVED_BY_USER_LOGIN_ID`),
  KEY `SHP_RCPT_RETINVITM` (`RETURN_ID`,`RETURN_ITEM_SEQ_ID`),
  key `sht_SHT_RCT_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `sht_SHT_RCT_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHP_RCPT_INVITM` FOREIGN KEY (`INVENTORY_ITEM_ID`) REFERENCES `inventory_item` (`INVENTORY_ITEM_ID`),
  CONSTRAINT `SHP_RCPT_ORDITM` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `SHP_RCPT_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `SHP_RCPT_REJRSN` FOREIGN KEY (`REJECTION_ID`) REFERENCES `rejection_reason` (`REJECTION_ID`),
  CONSTRAINT `SHP_RCPT_RETINVITM` FOREIGN KEY (`RETURN_ID`, `RETURN_ITEM_SEQ_ID`) REFERENCES `return_item` (`RETURN_ID`, `RETURN_ITEM_SEQ_ID`),
  CONSTRAINT `SHP_RCPT_SHPKG` FOREIGN KEY (`SHIPMENT_ID`, `SHIPMENT_PACKAGE_SEQ_ID`) REFERENCES `shipment_package` (`SHIPMENT_ID`, `SHIPMENT_PACKAGE_SEQ_ID`),
  CONSTRAINT `SHP_RCPT_USERLGN` FOREIGN KEY (`RECEIVED_BY_USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_receipt_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_receipt_role` (
  `RECEIPT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RECEIPT_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `SHP_RCPTRL_RCPT` (`RECEIPT_ID`),
  KEY `SHP_RCPTRL_PTY` (`PARTY_ID`),
  KEY `SHP_RCPTRL_PTRL` (`PARTY_ID`,`ROLE_TYPE_ID`),
  key `SHT_RCT_RL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_RCT_RL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHP_RCPTRL_PTRL` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `SHP_RCPTRL_PTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `SHP_RCPTRL_RCPT` FOREIGN KEY (`RECEIPT_ID`) REFERENCES `shipment_receipt` (`RECEIPT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_route_segment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_route_segment` (
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_ROUTE_SEGMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DELIVERY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEST_FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_TELECOM_NUMBER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEST_CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEST_TELECOM_NUMBER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_SERVICE_STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_DELIVERY_ZONE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_RESTRICTION_CODES` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_RESTRICTION_DESC` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `BILLING_WEIGHT` decimal(18,6) DEFAULT NULL,
  `BILLING_WEIGHT_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACTUAL_TRANSPORT_COST` decimal(18,2) DEFAULT NULL,
  `ACTUAL_SERVICE_COST` decimal(18,2) DEFAULT NULL,
  `ACTUAL_OTHER_COST` decimal(18,2) DEFAULT NULL,
  `ACTUAL_COST` decimal(18,2) DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACTUAL_START_DATE` datetime(3) DEFAULT NULL,
  `ACTUAL_ARRIVAL_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_START_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_ARRIVAL_DATE` datetime(3) DEFAULT NULL,
  `TRACKING_ID_NUMBER` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRACKING_DIGEST` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `UPDATED_BY_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_DATE` datetime(3) DEFAULT NULL,
  `HOME_DELIVERY_TYPE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOME_DELIVERY_DATE` datetime(3) DEFAULT NULL,
  `THIRD_PARTY_ACCOUNT_NUMBER` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `THIRD_PARTY_POSTAL_CODE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `THIRD_PARTY_COUNTRY_GEO_CODE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `UPS_HIGH_VALUE_REPORT` longblob,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`SHIPMENT_ROUTE_SEGMENT_ID`),
  KEY `SHPMT_RTSEG_SHPMT` (`SHIPMENT_ID`),
  KEY `SHPMT_RTSEG_DEL` (`DELIVERY_ID`),
  KEY `SHPMT_RTSEG_CPTY` (`CARRIER_PARTY_ID`),
  KEY `SHPMT_RTSEG_SHMT` (`SHIPMENT_METHOD_TYPE_ID`),
  KEY `SHPMT_RTSEG_OFAC` (`ORIGIN_FACILITY_ID`),
  KEY `SHPMT_RTSEG_DFAC` (`DEST_FACILITY_ID`),
  KEY `SHPMT_RTSEG_OPAD` (`ORIGIN_CONTACT_MECH_ID`),
  KEY `SHPMT_RTSEG_OTCN` (`ORIGIN_TELECOM_NUMBER_ID`),
  KEY `SHPMT_RTSEG_DPAD` (`DEST_CONTACT_MECH_ID`),
  KEY `SHPMT_RTSEG_DTCN` (`DEST_TELECOM_NUMBER_ID`),
  KEY `SHPKRTSG_CSSTS` (`CARRIER_SERVICE_STATUS_ID`),
  KEY `SHPMT_RTSEG_CUOM` (`CURRENCY_UOM_ID`),
  KEY `SHPKRTSG_BWUOM` (`BILLING_WEIGHT_UOM_ID`),
  key `SHT_RT_SGT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_RT_SGT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHPKRTSG_BWUOM` FOREIGN KEY (`BILLING_WEIGHT_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SHPKRTSG_CSSTS` FOREIGN KEY (`CARRIER_SERVICE_STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `SHPMT_RTSEG_CPTY` FOREIGN KEY (`CARRIER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `SHPMT_RTSEG_CUOM` FOREIGN KEY (`CURRENCY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `SHPMT_RTSEG_DEL` FOREIGN KEY (`DELIVERY_ID`) REFERENCES `delivery` (`DELIVERY_ID`),
  CONSTRAINT `SHPMT_RTSEG_DFAC` FOREIGN KEY (`DEST_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `SHPMT_RTSEG_DPAD` FOREIGN KEY (`DEST_CONTACT_MECH_ID`) REFERENCES `postal_address` (`CONTACT_MECH_ID`),
  CONSTRAINT `SHPMT_RTSEG_DTCN` FOREIGN KEY (`DEST_TELECOM_NUMBER_ID`) REFERENCES `telecom_number` (`CONTACT_MECH_ID`),
  CONSTRAINT `SHPMT_RTSEG_OFAC` FOREIGN KEY (`ORIGIN_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `SHPMT_RTSEG_OPAD` FOREIGN KEY (`ORIGIN_CONTACT_MECH_ID`) REFERENCES `postal_address` (`CONTACT_MECH_ID`),
  CONSTRAINT `SHPMT_RTSEG_OTCN` FOREIGN KEY (`ORIGIN_TELECOM_NUMBER_ID`) REFERENCES `telecom_number` (`CONTACT_MECH_ID`),
  CONSTRAINT `SHPMT_RTSEG_SHMT` FOREIGN KEY (`SHIPMENT_METHOD_TYPE_ID`) REFERENCES `shipment_method_type` (`SHIPMENT_METHOD_TYPE_ID`),
  CONSTRAINT `SHPMT_RTSEG_SHPMT` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_status`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_status` (
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_DATE` datetime(3) DEFAULT NULL,
  `CHANGE_BY_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`STATUS_ID`,`SHIPMENT_ID`),
  KEY `SHPMNT_STTS_STTS` (`STATUS_ID`),
  KEY `SHPMNT_STTS_SHMT` (`SHIPMENT_ID`),
  KEY `SHPMNT_STTS_USRLGN` (`CHANGE_BY_USER_LOGIN_ID`),
  key `sht_SHT_STS_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `sht_SHT_STS_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHPMNT_STTS_SHMT` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`),
  CONSTRAINT `SHPMNT_STTS_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `SHPMNT_STTS_USRLGN` FOREIGN KEY (`CHANGE_BY_USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_time_estimate`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_time_estimate` (
  `SHIPMENT_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LEAD_TIME` decimal(18,6) DEFAULT NULL,
  `LEAD_TIME_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUMBER` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_METHOD_TYPE_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`GEO_ID_TO`,`GEO_ID_FROM`,`FROM_DATE`),
  KEY `SHIPT_EST_METHOD` (`SHIPMENT_METHOD_TYPE_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `SHIPT_EST_GEO_TO` (`GEO_ID_TO`),
  KEY `SHIPT_EST_GEO_FROM` (`GEO_ID_FROM`),
  KEY `SHIPT_EST_UOM` (`LEAD_TIME_UOM_ID`),
  key `SHT_TM_EST_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_TM_EST_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHIPT_EST_GEO_FROM` FOREIGN KEY (`GEO_ID_FROM`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `SHIPT_EST_GEO_TO` FOREIGN KEY (`GEO_ID_TO`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `SHIPT_EST_METHOD` FOREIGN KEY (`SHIPMENT_METHOD_TYPE_ID`, `PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `carrier_shipment_method` (`SHIPMENT_METHOD_TYPE_ID`, `PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `SHIPT_EST_UOM` FOREIGN KEY (`LEAD_TIME_UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_type` (
  `SHIPMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_TYPE_ID`),
  KEY `SHPMNT_TYPPAR` (`PARENT_TYPE_ID`),
  key `shpt_SHT_TP_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `shpt_SHT_TP_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHPMNT_TYPPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `shipment_type` (`SHIPMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_type_attr` (
  `SHIPMENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_TYPE_ID`,`ATTR_NAME`),
  KEY `SHPMNT_TYPATR` (`SHIPMENT_TYPE_ID`),
  key `SHT_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `SHT_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SHPMNT_TYPATR` FOREIGN KEY (`SHIPMENT_TYPE_ID`) REFERENCES `shipment_type` (`SHIPMENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `application_sandbox`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application_sandbox` (
  `APPLICATION_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `RUNTIME_DATA_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`APPLICATION_ID`),
  KEY `APP_SNDBX_WEPA` (`WORK_EFFORT_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`FROM_DATE`),
  KEY `APP_SNDBX_RNTMDTA` (`RUNTIME_DATA_ID`),
  key `wrkt_APN_SNX_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `wrkt_APN_SNX_TXS` (`CREATED_TX_STAMP`),
  CONSTRAINT `APP_SNDBX_RNTMDTA` FOREIGN KEY (`RUNTIME_DATA_ID`) REFERENCES `runtime_data` (`RUNTIME_DATA_ID`),
  CONSTRAINT `APP_SNDBX_WEPA` FOREIGN KEY (`WORK_EFFORT_ID`, `PARTY_ID`, `ROLE_TYPE_ID`, `FROM_DATE`) REFERENCES `work_effort_party_assignment` (`WORK_EFFORT_ID`, `PARTY_ID`, `ROLE_TYPE_ID`, `FROM_DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event_work_eff`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event_work_eff` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COMMUNICATION_EVENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`COMMUNICATION_EVENT_ID`),
  KEY `COMEV_WEFF_WEFF` (`WORK_EFFORT_ID`),
  KEY `COMEV_WEFF_CMEV` (`COMMUNICATION_EVENT_ID`),
  key `EVT_WRK_EFF_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EVT_WRK_EFF_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `COMEV_WEFF_CMEV` FOREIGN KEY (`COMMUNICATION_EVENT_ID`) REFERENCES `communication_event` (`COMMUNICATION_EVENT_ID`),
  CONSTRAINT `COMEV_WEFF_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `deliverable`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deliverable` (
  `DELIVERABLE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DELIVERABLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DELIVERABLE_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DELIVERABLE_ID`),
  KEY `DELIVERABLE_DLTYP` (`DELIVERABLE_TYPE_ID`),
  key `wrkft_DLVL_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `wrkft_DLVL_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `DELIVERABLE_DLTYP` FOREIGN KEY (`DELIVERABLE_TYPE_ID`) REFERENCES `deliverable_type` (`DELIVERABLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `deliverable_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deliverable_type` (
  `DELIVERABLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DELIVERABLE_TYPE_ID`),
  key `wrkt_DLL_TP_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `wrkt_DLL_TP_TXCS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time_entry`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_entry` (
  `TIME_ENTRY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `RATE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TIMESHEET_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVOICE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVOICE_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOURS` double DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `PLAN_HOURS` double DEFAULT NULL,
  PRIMARY KEY (`TIME_ENTRY_ID`),
  KEY `TIME_ENT_PRTY` (`PARTY_ID`),
  KEY `TIME_ENT_RTTP` (`RATE_TYPE_ID`),
  KEY `TIME_ENT_WEFF` (`WORK_EFFORT_ID`),
  KEY `TIME_ENT_TSHT` (`TIMESHEET_ID`),
  KEY `TIME_ENT_INVIT` (`INVOICE_ID`,`INVOICE_ITEM_SEQ_ID`),
  key `wrkt_TM_ENR_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `wrkt_TM_ENR_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `TIME_ENT_PRTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `TIME_ENT_TSHT` FOREIGN KEY (`TIMESHEET_ID`) REFERENCES `timesheet` (`TIMESHEET_ID`),
  CONSTRAINT `TIME_ENT_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `timesheet`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timesheet` (
  `TIMESHEET_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `APPROVED_BY_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`TIMESHEET_ID`),
  KEY `TIMESHEET_PRTY` (`PARTY_ID`),
  KEY `TIMESHEET_CPTY` (`CLIENT_PARTY_ID`),
  KEY `TIMESHEET_STS` (`STATUS_ID`),
  KEY `TIMESHEET_AB_UL` (`APPROVED_BY_USER_LOGIN_ID`),
  key `wrkfft_TMT_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  key `wrkfft_TMT_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `TIMESHEET_AB_UL` FOREIGN KEY (`APPROVED_BY_USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `TIMESHEET_CPTY` FOREIGN KEY (`CLIENT_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `TIMESHEET_PRTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `TIMESHEET_STS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `timesheet_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timesheet_role` (
  `TIMESHEET_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`TIMESHEET_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `TIMESHTRL_TSHT` (`TIMESHEET_ID`),
  KEY `TIMESHTRL_PRTY` (`PARTY_ID`),
  KEY `TIMESHTRL_PTRL` (`PARTY_ID`,`ROLE_TYPE_ID`),
  key `wrkt_TMT_RL_TXSP` (`LAST_UPDATED_TX_STAMP`),
  key `wrkt_TMT_RL_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `TIMESHTRL_PRTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `TIMESHTRL_PTRL` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `TIMESHTRL_TSHT` FOREIGN KEY (`TIMESHEET_ID`) REFERENCES `timesheet` (`TIMESHEET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_EFFORT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CURRENT_STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_STATUS_UPDATE` datetime(3) DEFAULT NULL,
  `WORK_EFFORT_PURPOSE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WORK_EFFORT_PARENT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SCOPE_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIORITY` decimal(20,0) DEFAULT NULL,
  `PERCENT_COMPLETE` decimal(20,0) DEFAULT NULL,
  `WORK_EFFORT_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHOW_AS_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEND_NOTIFICATION_EMAIL` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOCATION_DESC` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ESTIMATED_START_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_COMPLETION_DATE` datetime(3) DEFAULT NULL,
  `ACTUAL_START_DATE` datetime(3) DEFAULT NULL,
  `ACTUAL_COMPLETION_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_MILLI_SECONDS` double DEFAULT NULL,
  `ESTIMATED_SETUP_MILLIS` double DEFAULT NULL,
  `ESTIMATE_CALC_METHOD` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACTUAL_MILLI_SECONDS` double DEFAULT NULL,
  `ACTUAL_SETUP_MILLIS` double DEFAULT NULL,
  `TOTAL_MILLI_SECONDS_ALLOWED` double DEFAULT NULL,
  `TOTAL_MONEY_ALLOWED` decimal(18,2) DEFAULT NULL,
  `MONEY_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SPECIAL_TERMS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TIME_TRANSPARENCY` decimal(20,0) DEFAULT NULL,
  `UNIVERSAL_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SOURCE_REFERENCE_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIXED_ASSET_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INFO_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECURRENCE_INFO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TEMP_EXPR_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RUNTIME_DATA_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVICE_LOADER_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY_TO_PRODUCE` decimal(18,6) DEFAULT NULL,
  `QUANTITY_PRODUCED` decimal(18,6) DEFAULT NULL,
  `QUANTITY_REJECTED` decimal(18,6) DEFAULT NULL,
  `RESERV_PERSONS` decimal(18,6) DEFAULT NULL,
  `RESERV2ND_P_P_PERC` decimal(18,6) DEFAULT NULL,
  `RESERV_NTH_P_P_PERC` decimal(18,6) DEFAULT NULL,
  `ACCOMMODATION_MAP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCOMMODATION_SPOT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REVISION_NUMBER` decimal(20,0) DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`),
  KEY `WK_EFFRT_TYPE` (`WORK_EFFORT_TYPE_ID`),
  KEY `WK_EFFRT_PRPTYP` (`WORK_EFFORT_PURPOSE_TYPE_ID`),
  KEY `WK_EFFRT_PARENT` (`WORK_EFFORT_PARENT_ID`),
  KEY `WK_EFFRT_CURSTTS` (`CURRENT_STATUS_ID`),
  KEY `WK_EFFRT_SC_ENUM` (`SCOPE_ENUM_ID`),
  KEY `WK_EFFRT_FXDASST` (`FIXED_ASSET_ID`),
  KEY `WK_EFFRT_FACILITY` (`FACILITY_ID`),
  KEY `WK_EFFRT_MON_UOM` (`MONEY_UOM_ID`),
  KEY `WK_EFFRT_RECINFO` (`RECURRENCE_INFO_ID`),
  KEY `WK_EFFRT_TEMPEXPR` (`TEMP_EXPR_ID`),
  KEY `WK_EFFRT_RNTMDTA` (`RUNTIME_DATA_ID`),
  KEY `WK_EFFRT_NOTE` (`NOTE_ID`),
  KEY `WK_EFFRT_CUS_MET` (`ESTIMATE_CALC_METHOD`),
  KEY `WK_EFFRT_ACC_MAP` (`ACCOMMODATION_MAP_ID`),
  KEY `WK_EFFRT_ACC_SPOT` (`ACCOMMODATION_SPOT_ID`),
  key `wrkt_WRK_EFT_TXP` (`LAST_UPDATED_TX_STAMP`),
  key `wrkt_WRK_EFT_TXS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WK_EFFRT_CURSTTS` FOREIGN KEY (`CURRENT_STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `WK_EFFRT_CUS_MET` FOREIGN KEY (`ESTIMATE_CALC_METHOD`) REFERENCES `custom_method` (`CUSTOM_METHOD_ID`),
  CONSTRAINT `WK_EFFRT_FACILITY` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `WK_EFFRT_MON_UOM` FOREIGN KEY (`MONEY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `WK_EFFRT_NOTE` FOREIGN KEY (`NOTE_ID`) REFERENCES `note_data` (`NOTE_ID`),
  CONSTRAINT `WK_EFFRT_PARENT` FOREIGN KEY (`WORK_EFFORT_PARENT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`),
  CONSTRAINT `WK_EFFRT_PRPTYP` FOREIGN KEY (`WORK_EFFORT_PURPOSE_TYPE_ID`) REFERENCES `work_effort_purpose_type` (`WORK_EFFORT_PURPOSE_TYPE_ID`),
  CONSTRAINT `WK_EFFRT_RECINFO` FOREIGN KEY (`RECURRENCE_INFO_ID`) REFERENCES `recurrence_info` (`RECURRENCE_INFO_ID`),
  CONSTRAINT `WK_EFFRT_RNTMDTA` FOREIGN KEY (`RUNTIME_DATA_ID`) REFERENCES `runtime_data` (`RUNTIME_DATA_ID`),
  CONSTRAINT `WK_EFFRT_SC_ENUM` FOREIGN KEY (`SCOPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `WK_EFFRT_TEMPEXPR` FOREIGN KEY (`TEMP_EXPR_ID`) REFERENCES `temporal_expression` (`TEMP_EXPR_ID`),
  CONSTRAINT `WK_EFFRT_TYPE` FOREIGN KEY (`WORK_EFFORT_TYPE_ID`) REFERENCES `work_effort_type` (`WORK_EFFORT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_assoc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_assoc` (
  `WORK_EFFORT_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_EFFORT_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_EFFORT_ASSOC_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID_FROM`,`WORK_EFFORT_ID_TO`,`WORK_EFFORT_ASSOC_TYPE_ID`,`FROM_DATE`),
  KEY `WK_EFFRTASSC_TYP` (`WORK_EFFORT_ASSOC_TYPE_ID`),
  KEY `WK_EFFRTASSC_FWE` (`WORK_EFFORT_ID_FROM`),
  KEY `WK_EFFRTASSC_TWE` (`WORK_EFFORT_ID_TO`),
  key `WRK_EFT_ASC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `WRK_EFT_ASC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WK_EFFRTASSC_FWE` FOREIGN KEY (`WORK_EFFORT_ID_FROM`) REFERENCES `work_effort` (`WORK_EFFORT_ID`),
  CONSTRAINT `WK_EFFRTASSC_TWE` FOREIGN KEY (`WORK_EFFORT_ID_TO`) REFERENCES `work_effort` (`WORK_EFFORT_ID`),
  CONSTRAINT `WK_EFFRTASSC_TYP` FOREIGN KEY (`WORK_EFFORT_ASSOC_TYPE_ID`) REFERENCES `work_effort_assoc_type` (`WORK_EFFORT_ASSOC_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_assoc_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_assoc_attribute` (
  `WORK_EFFORT_ID_FROM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_EFFORT_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_EFFORT_ASSOC_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID_FROM`,`WORK_EFFORT_ID_TO`,`WORK_EFFORT_ASSOC_TYPE_ID`,`ATTR_NAME`),
  KEY `WK_EFFRTASSC_ATTR` (`WORK_EFFORT_ID_FROM`,`WORK_EFFORT_ID_TO`,`WORK_EFFORT_ASSOC_TYPE_ID`,`FROM_DATE`),
  key `EFT_ASC_ATT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_ASC_ATT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WK_EFFRTASSC_ATTR` FOREIGN KEY (`WORK_EFFORT_ID_FROM`, `WORK_EFFORT_ID_TO`, `WORK_EFFORT_ASSOC_TYPE_ID`, `FROM_DATE`) REFERENCES `work_effort_assoc` (`WORK_EFFORT_ID_FROM`, `WORK_EFFORT_ID_TO`, `WORK_EFFORT_ASSOC_TYPE_ID`, `FROM_DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_assoc_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_assoc_type` (
  `WORK_EFFORT_ASSOC_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ASSOC_TYPE_ID`),
  KEY `WK_EFFRTASSC_TPAR` (`PARENT_TYPE_ID`),
  key `EFT_ASC_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_ASC_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WK_EFFRTASSC_TPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `work_effort_assoc_type` (`WORK_EFFORT_ASSOC_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_assoc_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_assoc_type_attr` (
  `WORK_EFFORT_ASSOC_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ASSOC_TYPE_ID`,`ATTR_NAME`),
  KEY `WK_EFFRTASSC_TATR` (`WORK_EFFORT_ASSOC_TYPE_ID`),
  key `ASC_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `ASC_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WK_EFFRTASSC_TATR` FOREIGN KEY (`WORK_EFFORT_ASSOC_TYPE_ID`) REFERENCES `work_effort_assoc_type` (`WORK_EFFORT_ASSOC_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_attribute` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTR_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`ATTR_NAME`),
  KEY `WK_EFFRT_ATTR_WE` (`WORK_EFFORT_ID`),
  key `WRK_EFT_ATT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `WRK_EFT_ATT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WK_EFFRT_ATTR_WE` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_billing`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_billing` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ITEM_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PERCENTAGE` double DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`INVOICE_ID`,`INVOICE_ITEM_SEQ_ID`),
  KEY `WK_EFFBLNG_WEFF` (`WORK_EFFORT_ID`),
  KEY `WK_EFFBLNG_INVITM` (`INVOICE_ID`,`INVOICE_ITEM_SEQ_ID`),
  key `WRK_EFT_BLG_TP` (`LAST_UPDATED_TX_STAMP`),
  key `WRK_EFT_BLG_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WK_EFFBLNG_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_contact_mech` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`CONTACT_MECH_ID`,`FROM_DATE`),
  KEY `WKEFF_CMECH_WKEFF` (`WORK_EFFORT_ID`),
  KEY `WKEFF_CMECH_CMECH` (`CONTACT_MECH_ID`),
  key `EFT_CNT_MCH_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_CNT_MCH_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEFF_CMECH_CMECH` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `WKEFF_CMECH_WKEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_content_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_content_type` (
  `WORK_EFFORT_CONTENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_CONTENT_TYPE_ID`),
  KEY `WEFFCTP_TP_PAR` (`PARENT_TYPE_ID`),
  key `EFT_CNT_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_CNT_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WEFFCTP_TP_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `work_effort_content_type` (`WORK_EFFORT_CONTENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_cost_calc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_cost_calc` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COST_COMPONENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COST_COMPONENT_CALC_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`COST_COMPONENT_TYPE_ID`,`FROM_DATE`),
  KEY `WK_EFFRT_COS_WEF` (`WORK_EFFORT_ID`),
  KEY `WK_EFFRT_COS_CCT` (`COST_COMPONENT_TYPE_ID`),
  KEY `WK_EFFRT_COS_CCC` (`COST_COMPONENT_CALC_ID`),
  key `EFT_CST_CLC_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_CST_CLC_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WK_EFFRT_COS_CCC` FOREIGN KEY (`COST_COMPONENT_CALC_ID`) REFERENCES `cost_component_calc` (`COST_COMPONENT_CALC_ID`),
  CONSTRAINT `WK_EFFRT_COS_CCT` FOREIGN KEY (`COST_COMPONENT_TYPE_ID`) REFERENCES `cost_component_type` (`COST_COMPONENT_TYPE_ID`),
  CONSTRAINT `WK_EFFRT_COS_WEF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_deliverable_prod`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_deliverable_prod` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DELIVERABLE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`DELIVERABLE_ID`),
  KEY `WKEFF_DELPRD_WEFF` (`WORK_EFFORT_ID`),
  KEY `WKEFF_DELPRD_DEL` (`DELIVERABLE_ID`),
  key `EFT_DLL_PRD_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_DLL_PRD_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEFF_DELPRD_DEL` FOREIGN KEY (`DELIVERABLE_ID`) REFERENCES `deliverable` (`DELIVERABLE_ID`),
  CONSTRAINT `WKEFF_DELPRD_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_event_reminder`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_event_reminder` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REMINDER_DATE_TIME` datetime(3) DEFAULT NULL,
  `REPEAT_COUNT` decimal(20,0) DEFAULT NULL,
  `REPEAT_INTERVAL` decimal(20,0) DEFAULT NULL,
  `CURRENT_COUNT` decimal(20,0) DEFAULT NULL,
  `REMINDER_OFFSET` decimal(20,0) DEFAULT NULL,
  `LOCALE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TIME_ZONE_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`SEQUENCE_ID`),
  KEY `WE_EVENT_REMIND_WE` (`WORK_EFFORT_ID`),
  KEY `WE_EVENT_REMIND_CM` (`CONTACT_MECH_ID`),
  KEY `WE_EVENT_REMIND_PY` (`PARTY_ID`),
  key `EFT_EVT_RMR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_EVT_RMR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WE_EVENT_REMIND_CM` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `WE_EVENT_REMIND_PY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `WE_EVENT_REMIND_WE` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_fixed_asset_assign`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_fixed_asset_assign` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIXED_ASSET_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `AVAILABILITY_STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOCATED_COST` decimal(18,2) DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`FIXED_ASSET_ID`,`FROM_DATE`),
  KEY `WKEFF_FXDAA_WEFF` (`WORK_EFFORT_ID`),
  KEY `WKEFF_FXDAA_FXAS` (`FIXED_ASSET_ID`),
  KEY `WKEFF_FXDAA_STTS` (`STATUS_ID`),
  KEY `WKEFF_FXDAA_AVAIL` (`AVAILABILITY_STATUS_ID`),
  key `FXD_AST_ASN_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FXD_AST_ASN_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEFF_FXDAA_AVAIL` FOREIGN KEY (`AVAILABILITY_STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `WKEFF_FXDAA_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `WKEFF_FXDAA_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_fixed_asset_std`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_fixed_asset_std` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIXED_ASSET_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ESTIMATED_QUANTITY` double DEFAULT NULL,
  `ESTIMATED_DURATION` double DEFAULT NULL,
  `ESTIMATED_COST` decimal(18,2) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`FIXED_ASSET_TYPE_ID`),
  KEY `WKEFF_FASTD_WEFF` (`WORK_EFFORT_ID`),
  KEY `WKEFF_FASTD_FAT` (`FIXED_ASSET_TYPE_ID`),
  key `FXD_AST_STD_TP` (`LAST_UPDATED_TX_STAMP`),
  key `FXD_AST_STD_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEFF_FASTD_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_good_standard`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_good_standard` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WORK_EFFORT_GOOD_STD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ESTIMATED_QUANTITY` double DEFAULT NULL,
  `ESTIMATED_COST` decimal(18,2) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`PRODUCT_ID`,`WORK_EFFORT_GOOD_STD_TYPE_ID`,`FROM_DATE`),
  KEY `WKEFF_GDSTD_WEFF` (`WORK_EFFORT_ID`),
  KEY `WKEFF_GDSTD_TYPE` (`WORK_EFFORT_GOOD_STD_TYPE_ID`),
  KEY `WKEFF_GDSTD_PROD` (`PRODUCT_ID`),
  KEY `WKEFF_GDSTD_STTS` (`STATUS_ID`),
  key `EFT_GD_STD_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_GD_STD_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEFF_GDSTD_PROD` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `WKEFF_GDSTD_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `WKEFF_GDSTD_TYPE` FOREIGN KEY (`WORK_EFFORT_GOOD_STD_TYPE_ID`) REFERENCES `work_effort_good_standard_type` (`WORK_EFFORT_GOOD_STD_TYPE_ID`),
  CONSTRAINT `WKEFF_GDSTD_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_good_standard_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_good_standard_type` (
  `WORK_EFFORT_GOOD_STD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_GOOD_STD_TYPE_ID`),
  KEY `WKEFF_GDSTD_TPAR` (`PARENT_TYPE_ID`),
  key `EFT_GD_STD_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_GD_STD_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEFF_GDSTD_TPAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `work_effort_good_standard_type` (`WORK_EFFORT_GOOD_STD_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_ical_data`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_ical_data` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ICAL_DATA` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`),
  KEY `WKEFF_ICAL_DATA` (`WORK_EFFORT_ID`),
  key `EFT_ICL_DT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_ICL_DT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEFF_ICAL_DATA` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_inventory_assign`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_inventory_assign` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` double DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`INVENTORY_ITEM_ID`),
  KEY `WKEFF_INVAS_WEFF` (`WORK_EFFORT_ID`),
  KEY `WKEFF_INVAS_INVIT` (`INVENTORY_ITEM_ID`),
  KEY `WKEFF_INVAS_STTS` (`STATUS_ID`),
  key `EFT_INR_ASN_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_INR_ASN_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEFF_INVAS_INVIT` FOREIGN KEY (`INVENTORY_ITEM_ID`) REFERENCES `inventory_item` (`INVENTORY_ITEM_ID`),
  CONSTRAINT `WKEFF_INVAS_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `WKEFF_INVAS_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_inventory_produced`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_inventory_produced` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVENTORY_ITEM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`INVENTORY_ITEM_ID`),
  KEY `WKEFF_INVPD_WEFF` (`WORK_EFFORT_ID`),
  KEY `WKEFF_INVPD_INVIT` (`INVENTORY_ITEM_ID`),
  key `EFT_INR_PRD_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_INR_PRD_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEFF_INVPD_INVIT` FOREIGN KEY (`INVENTORY_ITEM_ID`) REFERENCES `inventory_item` (`INVENTORY_ITEM_ID`),
  CONSTRAINT `WKEFF_INVPD_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_keyword`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_keyword` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `KEYWORD` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RELEVANCY_WEIGHT` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`KEYWORD`),
  KEY `WEFF_KWD_WEFF` (`WORK_EFFORT_ID`),
  key `WRK_EFT_KWD_TP` (`LAST_UPDATED_TX_STAMP`),
  key `WRK_EFT_KWD_TS` (`CREATED_TX_STAMP`),
  KEY `WEFF_KWD_KWD` (`KEYWORD`),
  CONSTRAINT `WEFF_KWD_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_note`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_note` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `NOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INTERNAL_NOTE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`NOTE_ID`),
  KEY `WKEFF_NTE_WEFF` (`WORK_EFFORT_ID`),
  KEY `WKEFF_NTE_NOTE` (`NOTE_ID`),
  key `WRK_EFT_NT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `WRK_EFT_NT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEFF_NTE_NOTE` FOREIGN KEY (`NOTE_ID`) REFERENCES `note_data` (`NOTE_ID`),
  CONSTRAINT `WKEFF_NTE_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_party_assignment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_party_assignment` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `ASSIGNED_BY_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_DATE_TIME` datetime(3) DEFAULT NULL,
  `EXPECTATION_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DELEGATE_REASON_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MUST_RSVP` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AVAILABILITY_STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`FROM_DATE`),
  KEY `WKEFF_PA_WE` (`WORK_EFFORT_ID`),
  KEY `WKEFF_PA_PRTY_ROLE` (`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `WKEFF_PA_ABUSRLOG` (`ASSIGNED_BY_USER_LOGIN_ID`),
  KEY `WKEFF_PA_STTS` (`STATUS_ID`),
  KEY `WKEFF_PA_EXP_ENUM` (`EXPECTATION_ENUM_ID`),
  KEY `WKEFF_PA_DELR_ENM` (`DELEGATE_REASON_ENUM_ID`),
  KEY `WKEFF_PA_FACILITY` (`FACILITY_ID`),
  KEY `WKEFF_PA_AVSTTS` (`AVAILABILITY_STATUS_ID`),
  key `EFT_PRT_AST_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_PRT_AST_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEFF_PA_ABUSRLOG` FOREIGN KEY (`ASSIGNED_BY_USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `WKEFF_PA_AVSTTS` FOREIGN KEY (`AVAILABILITY_STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `WKEFF_PA_DELR_ENM` FOREIGN KEY (`DELEGATE_REASON_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `WKEFF_PA_EXP_ENUM` FOREIGN KEY (`EXPECTATION_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `WKEFF_PA_FACILITY` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `WKEFF_PA_PRTY_ROLE` FOREIGN KEY (`PARTY_ID`, `ROLE_TYPE_ID`) REFERENCES `party_role` (`PARTY_ID`, `ROLE_TYPE_ID`),
  CONSTRAINT `WKEFF_PA_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `WKEFF_PA_WE` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_purpose_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_purpose_type` (
  `WORK_EFFORT_PURPOSE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_PURPOSE_TYPE_ID`),
  KEY `WK_EFFRT_PTYPE_PAR` (`PARENT_TYPE_ID`),
  key `EFT_PRS_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_PRS_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WK_EFFRT_PTYPE_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `work_effort_purpose_type` (`WORK_EFFORT_PURPOSE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_review`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_review` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `REVIEW_DATE` datetime(3) NOT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `POSTED_ANONYMOUS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RATING` double DEFAULT NULL,
  `REVIEW_TEXT` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`USER_LOGIN_ID`,`REVIEW_DATE`),
  KEY `WEFF_REVIEW_WEFF` (`WORK_EFFORT_ID`),
  KEY `WEFF_REVIEW_UL` (`USER_LOGIN_ID`),
  KEY `WEFF_REVIEW_STTS` (`STATUS_ID`),
  key `WRK_EFT_RVW_TP` (`LAST_UPDATED_TX_STAMP`),
  key `WRK_EFT_RVW_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WEFF_REVIEW_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `WEFF_REVIEW_UL` FOREIGN KEY (`USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `WEFF_REVIEW_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_search_constraint`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_search_constraint` (
  `WORK_EFFORT_SEARCH_RESULT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONSTRAINT_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONSTRAINT_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INFO_STRING` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INCLUDE_SUB_WORK_EFFORTS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_AND` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ANY_PREFIX` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ANY_SUFFIX` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REMOVE_STEMS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOW_VALUE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HIGH_VALUE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_SEARCH_RESULT_ID`,`CONSTRAINT_SEQ_ID`),
  KEY `WEFF_SCHRSI_RES` (`WORK_EFFORT_SEARCH_RESULT_ID`),
  key `EFT_SRH_CNT_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_SRH_CNT_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WEFF_SCHRSI_RES` FOREIGN KEY (`WORK_EFFORT_SEARCH_RESULT_ID`) REFERENCES `work_effort_search_result` (`WORK_EFFORT_SEARCH_RESULT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_search_result`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_search_result` (
  `WORK_EFFORT_SEARCH_RESULT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VISIT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_BY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_ASCENDING` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NUM_RESULTS` decimal(20,0) DEFAULT NULL,
  `SECONDS_TOTAL` double DEFAULT NULL,
  `SEARCH_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_SEARCH_RESULT_ID`),
  key `EFT_SRH_RST_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_SRH_RST_TS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_skill_standard`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_skill_standard` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SKILL_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ESTIMATED_NUM_PEOPLE` double DEFAULT NULL,
  `ESTIMATED_DURATION` double DEFAULT NULL,
  `ESTIMATED_COST` decimal(18,2) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`SKILL_TYPE_ID`),
  KEY `WKEFF_SKLSTD_WEFF` (`WORK_EFFORT_ID`),
  KEY `WKEFF_SKLSTD_SKTP` (`SKILL_TYPE_ID`),
  key `EFT_SKL_STD_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_SKL_STD_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEFF_SKLSTD_WEFF` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_status`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_status` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_DATETIME` datetime(3) NOT NULL,
  `SET_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REASON` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`STATUS_ID`,`STATUS_DATETIME`),
  KEY `WKEFF_STTS_WE` (`WORK_EFFORT_ID`),
  KEY `WKEFF_STTS_STTS` (`STATUS_ID`),
  KEY `WKEFF_STTS_SB_UL` (`SET_BY_USER_LOGIN`),
  key `WRK_EFT_STS_TP` (`LAST_UPDATED_TX_STAMP`),
  key `WRK_EFT_STS_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEFF_STTS_SB_UL` FOREIGN KEY (`SET_BY_USER_LOGIN`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `WKEFF_STTS_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `WKEFF_STTS_WE` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_survey_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_survey_appl` (
  `WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SURVEY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_ID`,`SURVEY_ID`,`FROM_DATE`),
  KEY `WKEF_SURVAPL_SVY` (`SURVEY_ID`),
  KEY `WKEF_SURVAPL_WKE` (`WORK_EFFORT_ID`),
  KEY `WKEF_SURVAPL_PSSA` (`SURVEY_ID`),
  key `EFT_SRV_APL_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_SRV_APL_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEF_SURVAPL_PSSA` FOREIGN KEY (`SURVEY_ID`) REFERENCES `product_store_survey_appl` (`PRODUCT_STORE_SURVEY_ID`),
  CONSTRAINT `WKEF_SURVAPL_WKE` FOREIGN KEY (`WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_trans_box`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_trans_box` (
  `PROCESS_WORK_EFFORT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TO_ACTIVITY_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TRANSITION_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PROCESS_WORK_EFFORT_ID`,`TO_ACTIVITY_ID`,`TRANSITION_ID`),
  KEY `WKEFF_TXBX_WE` (`PROCESS_WORK_EFFORT_ID`),
  key `EFT_TRS_BX_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_TRS_BX_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WKEFF_TXBX_WE` FOREIGN KEY (`PROCESS_WORK_EFFORT_ID`) REFERENCES `work_effort` (`WORK_EFFORT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_type` (
  `WORK_EFFORT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_TYPE_ID`),
  KEY `WK_EFFRT_TYPE_PAR` (`PARENT_TYPE_ID`),
  key `WRK_EFT_TP_TP` (`LAST_UPDATED_TX_STAMP`),
  key `WRK_EFT_TP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WK_EFFRT_TYPE_PAR` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `work_effort_type` (`WORK_EFFORT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work_effort_type_attr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_effort_type_attr` (
  `WORK_EFFORT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTR_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WORK_EFFORT_TYPE_ID`,`ATTR_NAME`),
  KEY `WK_EFFRT_TYPE_ATR` (`WORK_EFFORT_TYPE_ID`),
  key `EFT_TP_ATR_TP` (`LAST_UPDATED_TX_STAMP`),
  key `EFT_TP_ATR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `WK_EFFRT_TYPE_ATR` FOREIGN KEY (`WORK_EFFORT_TYPE_ID`) REFERENCES `work_effort_type` (`WORK_EFFORT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_source`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_source` (
  `DATA_SOURCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DATA_SOURCE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DATA_SOURCE_ID`),
  KEY `DATA_SRC_TYP` (`DATA_SOURCE_TYPE_ID`),
  KEY `DATA_SOURCE_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `DATA_SOURCE_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `DATA_SRC_TYP` FOREIGN KEY (`DATA_SOURCE_TYPE_ID`) REFERENCES `data_source_type` (`DATA_SOURCE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_source_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_source_type` (
  `DATA_SOURCE_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DATA_SOURCE_TYPE_ID`),
  KEY `DT_SRC_TP_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `DT_SRC_TP_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_template_setting`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_template_setting` (
  `EMAIL_TEMPLATE_SETTING_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `EMAIL_TYPE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BODY_SCREEN_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `XSLFO_ATTACH_SCREEN_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_ADDRESS` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CC_ADDRESS` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BCC_ADDRESS` varchar(320) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUBJECT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_TYPE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`EMAIL_TEMPLATE_SETTING_ID`),
  KEY `EMAILSET_ENUM` (`EMAIL_TYPE`),
  KEY `EML_TMPT_STG_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  KEY `EML_TMPT_STG_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `EMAILSET_ENUM` FOREIGN KEY (`EMAIL_TYPE`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entity_audit_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entity_audit_log` (
  `AUDIT_HISTORY_SEQ_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CHANGED_ENTITY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGED_FIELD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PK_COMBINED_VALUE_TEXT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OLD_VALUE_TEXT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NEW_VALUE_TEXT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGED_DATE` datetime(3) DEFAULT NULL,
  `CHANGED_BY_INFO` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGED_SESSION_INFO` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AUDIT_HISTORY_SEQ_ID`),
  KEY `ENTT_ADT_LG_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `ENTT_ADT_LG_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entity_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entity_group` (
  `ENTITY_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENTITY_GROUP_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENTITY_GROUP_ID`),
  KEY `ENTT_GRP_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `ENTT_GRP_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entity_group_entry`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entity_group_entry` (
  `ENTITY_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENTITY_OR_PACKAGE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `APPL_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENTITY_GROUP_ID`,`ENTITY_OR_PACKAGE`),
  KEY `ENTGRP_GRP` (`ENTITY_GROUP_ID`),
  KEY `ENT_GRP_ENR_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `ENT_GRP_ENR_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ENTGRP_GRP` FOREIGN KEY (`ENTITY_GROUP_ID`) REFERENCES `entity_group` (`ENTITY_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entity_key_store`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entity_key_store` (
  `KEY_NAME` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `KEY_TEXT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`KEY_NAME`),
  KEY `ENTT_K_STR_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `ENTT_K_STR_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enumeration`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enumeration` (
  `ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENUM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENUM_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENUM_ID`),
  KEY `ENUM_TO_TYPE` (`ENUM_TYPE_ID`),
  KEY `ENUMERATION_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `ENUMERATION_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ENUM_TO_TYPE` FOREIGN KEY (`ENUM_TYPE_ID`) REFERENCES `enumeration_type` (`ENUM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enumeration_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enumeration_type` (
  `ENUM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENUM_TYPE_ID`),
  KEY `ENUM_TYPE_PARENT` (`PARENT_TYPE_ID`),
  KEY `ENMRTN_TP_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `ENMRTN_TP_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `ENUM_TYPE_PARENT` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `enumeration_type` (`ENUM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `geo`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo` (
  `GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_SEC_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ABBREVIATION` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WELL_KNOWN_TEXT` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`GEO_ID`),
  KEY `GEO_TO_TYPE` (`GEO_TYPE_ID`),
  KEY `GEO_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `GEO_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `GEO_TO_TYPE` FOREIGN KEY (`GEO_TYPE_ID`) REFERENCES `geo_type` (`GEO_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `geo_assoc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo_assoc` (
  `GEO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_ASSOC_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`GEO_ID`,`GEO_ID_TO`),
  KEY `GEO_ASSC_TO_MAIN` (`GEO_ID`),
  KEY `GEO_ASSC_TO_ASSC` (`GEO_ID_TO`),
  KEY `GEO_ASSC_TO_TYPE` (`GEO_ASSOC_TYPE_ID`),
  KEY `GEO_ASSOC_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `GEO_ASSOC_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `GEO_ASSC_TO_ASSC` FOREIGN KEY (`GEO_ID_TO`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `GEO_ASSC_TO_MAIN` FOREIGN KEY (`GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `GEO_ASSC_TO_TYPE` FOREIGN KEY (`GEO_ASSOC_TYPE_ID`) REFERENCES `geo_assoc_type` (`GEO_ASSOC_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `geo_assoc_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo_assoc_type` (
  `GEO_ASSOC_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`GEO_ASSOC_TYPE_ID`),
  KEY `G_ASSC_TP_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `G_ASSC_TP_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `geo_point`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo_point` (
  `GEO_POINT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_POINT_TYPE_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DATA_SOURCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LATITUDE` decimal(18,6) NOT NULL,
  `LONGITUDE` decimal(18,6) NOT NULL,
  `ELEVATION` decimal(18,6) DEFAULT NULL,
  `ELEVATION_UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INFORMATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`GEO_POINT_ID`),
  KEY `GEOPOINT_DTSRC` (`DATA_SOURCE_ID`),
  KEY `GEOPOINT_TYPE` (`GEO_POINT_TYPE_ENUM_ID`),
  KEY `GPT_ELEV_UOM` (`ELEVATION_UOM_ID`),
  KEY `GEO_POINT_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `GEO_POINT_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `GEOPOINT_DTSRC` FOREIGN KEY (`DATA_SOURCE_ID`) REFERENCES `data_source` (`DATA_SOURCE_ID`),
  CONSTRAINT `GEOPOINT_TYPE` FOREIGN KEY (`GEO_POINT_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `GPT_ELEV_UOM` FOREIGN KEY (`ELEVATION_UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `geo_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo_type` (
  `GEO_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`GEO_TYPE_ID`),
  KEY `GEO_TYPE_PARENT` (`PARENT_TYPE_ID`),
  KEY `GEO_TYPE_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `GEO_TYPE_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `GEO_TYPE_PARENT` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `geo_type` (`GEO_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_manager_lock`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_manager_lock` (
  `INSTANCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `REASON_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `CREATED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_MODIFIED_DATE` datetime(3) DEFAULT NULL,
  `LAST_MODIFIED_BY_USER_LOGIN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INSTANCE_ID`,`FROM_DATE`),
  KEY `JOBLK_ENUM_REAS` (`REASON_ENUM_ID`),
  KEY `JB_MNGR_LCK_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `JB_MNGR_LCK_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `JOBLK_ENUM_REAS` FOREIGN KEY (`REASON_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_sandbox`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_sandbox` (
  `JOB_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `JOB_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RUN_TIME` datetime(3) DEFAULT NULL,
  `RUN_TIME_EPOCH` decimal(20,0) DEFAULT NULL,
  `PRIORITY` decimal(20,0) DEFAULT NULL,
  `POOL_ID` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_JOB_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PREVIOUS_JOB_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVICE_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOADER_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MAX_RETRY` decimal(20,0) DEFAULT NULL,
  `CURRENT_RETRY_COUNT` decimal(20,0) DEFAULT NULL,
  `AUTH_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RUN_AS_USER` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RUNTIME_DATA_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECURRENCE_INFO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TEMP_EXPR_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CURRENT_RECURRENCE_COUNT` decimal(20,0) DEFAULT NULL,
  `MAX_RECURRENCE_COUNT` decimal(20,0) DEFAULT NULL,
  `RUN_BY_INSTANCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `START_DATE_TIME` datetime(3) DEFAULT NULL,
  `FINISH_DATE_TIME` datetime(3) DEFAULT NULL,
  `CANCEL_DATE_TIME` datetime(3) DEFAULT NULL,
  `JOB_RESULT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECURRENCE_TIME_ZONE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`JOB_ID`),
  KEY `JOB_SNDBX_RECINFO` (`RECURRENCE_INFO_ID`),
  KEY `JOB_SNDBX_TEMPEXPR` (`TEMP_EXPR_ID`),
  KEY `JOB_SNDBX_RNTMDTA` (`RUNTIME_DATA_ID`),
  KEY `JOB_SNDBX_AUSRLGN` (`AUTH_USER_LOGIN_ID`),
  KEY `JOB_SNDBX_USRLGN` (`RUN_AS_USER`),
  KEY `JOB_SNDBX_STTS` (`STATUS_ID`),
  KEY `JOB_SANDBOX_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `JOB_SANDBOX_TXCRTS` (`CREATED_TX_STAMP`),
  KEY `JOB_SNDBX_RUNSTAT` (`RUN_BY_INSTANCE_ID`,`STATUS_ID`),
  CONSTRAINT `JOB_SNDBX_AUSRLGN` FOREIGN KEY (`AUTH_USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`),
  CONSTRAINT `JOB_SNDBX_RECINFO` FOREIGN KEY (`RECURRENCE_INFO_ID`) REFERENCES `recurrence_info` (`RECURRENCE_INFO_ID`),
  CONSTRAINT `JOB_SNDBX_RNTMDTA` FOREIGN KEY (`RUNTIME_DATA_ID`) REFERENCES `runtime_data` (`RUNTIME_DATA_ID`),
  CONSTRAINT `JOB_SNDBX_STTS` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `JOB_SNDBX_TEMPEXPR` FOREIGN KEY (`TEMP_EXPR_ID`) REFERENCES `temporal_expression` (`TEMP_EXPR_ID`),
  CONSTRAINT `JOB_SNDBX_USRLGN` FOREIGN KEY (`RUN_AS_USER`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `note_data`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `note_data` (
  `NOTE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `NOTE_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NOTE_INFO` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `NOTE_DATE_TIME` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `NOTE_PARTY` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MORE_INFO_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MORE_INFO_ITEM_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MORE_INFO_ITEM_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`NOTE_ID`),
  KEY `NOTE_DATA_PTY` (`NOTE_PARTY`),
  KEY `NOTE_DATA_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `NOTE_DATA_TXCRTS` (`CREATED_TX_STAMP`),
  KEY `systemInfo` (`NOTE_NAME`),
  CONSTRAINT `NOTE_DATA_PTY` FOREIGN KEY (`NOTE_PARTY`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `period_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `period_type` (
  `PERIOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PERIOD_LENGTH` decimal(20,0) DEFAULT NULL,
  `UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PERIOD_TYPE_ID`),
  KEY `PER_TYPE_UOM` (`UOM_ID`),
  KEY `PERIOD_TYPE_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `PERIOD_TYPE_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PER_TYPE_UOM` FOREIGN KEY (`UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recurrence_info`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recurrence_info` (
  `RECURRENCE_INFO_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `START_DATE_TIME` datetime(3) DEFAULT NULL,
  `EXCEPTION_DATE_TIMES` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `RECURRENCE_DATE_TIMES` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `EXCEPTION_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECURRENCE_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECURRENCE_COUNT` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RECURRENCE_INFO_ID`),
  KEY `REC_INFO_RCRLE` (`RECURRENCE_RULE_ID`),
  KEY `REC_INFO_EX_RCRLE` (`EXCEPTION_RULE_ID`),
  KEY `RCRRNC_INF_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `RCRRNC_INF_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `REC_INFO_EX_RCRLE` FOREIGN KEY (`EXCEPTION_RULE_ID`) REFERENCES `recurrence_rule` (`RECURRENCE_RULE_ID`),
  CONSTRAINT `REC_INFO_RCRLE` FOREIGN KEY (`RECURRENCE_RULE_ID`) REFERENCES `recurrence_rule` (`RECURRENCE_RULE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recurrence_rule`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recurrence_rule` (
  `RECURRENCE_RULE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FREQUENCY` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `UNTIL_DATE_TIME` datetime(3) DEFAULT NULL,
  `COUNT_NUMBER` decimal(20,0) DEFAULT NULL,
  `INTERVAL_NUMBER` decimal(20,0) DEFAULT NULL,
  `BY_SECOND_LIST` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `BY_MINUTE_LIST` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `BY_HOUR_LIST` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `BY_DAY_LIST` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `BY_MONTH_DAY_LIST` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `BY_YEAR_DAY_LIST` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `BY_WEEK_NO_LIST` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `BY_MONTH_LIST` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `BY_SET_POS_LIST` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `WEEK_START` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `X_NAME` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RECURRENCE_RULE_ID`),
  KEY `RCRRNC_RL_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `RCRRNC_RL_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `runtime_data`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `runtime_data` (
  `RUNTIME_DATA_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RUNTIME_INFO` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RUNTIME_DATA_ID`),
  KEY `RNTM_DT_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `RNTM_DT_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `security_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `security_group` (
  `GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GROUP_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`GROUP_ID`),
  KEY `SCRT_GRP_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `SCRT_GRP_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `security_group_permission`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `security_group_permission` (
  `GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PERMISSION_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`GROUP_ID`,`PERMISSION_ID`,`FROM_DATE`),
  KEY `SEC_GRP_PERM_GRP` (`GROUP_ID`),
  KEY `SCT_GRP_PRMN_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  KEY `SCT_GRP_PRMN_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `SEC_GRP_PERM_GRP` FOREIGN KEY (`GROUP_ID`) REFERENCES `security_group` (`GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `security_permission`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `security_permission` (
  `PERMISSION_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PERMISSION_ID`),
  KEY `SCRT_PRMSSN_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `SCRT_PRMSSN_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sequence_value_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sequence_value_item` (
  `SEQ_NAME` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQ_ID` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SEQ_NAME`),
  KEY `SQNC_VL_ITM_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `SQNC_VL_ITM_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `service_semaphore`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_semaphore` (
  `SERVICE_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOCKED_BY_INSTANCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOCK_THREAD` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOCK_TIME` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SERVICE_NAME`),
  KEY `SRVC_SMPHR_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `SRVC_SMPHR_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `status_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_item` (
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_CODE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`STATUS_ID`),
  KEY `STATUS_TO_TYPE` (`STATUS_TYPE_ID`),
  KEY `STATUS_ITEM_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `STATUS_ITEM_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `STATUS_TO_TYPE` FOREIGN KEY (`STATUS_TYPE_ID`) REFERENCES `status_type` (`STATUS_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `status_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_type` (
  `STATUS_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`STATUS_TYPE_ID`),
  KEY `STATUS_TYPE_PARENT` (`PARENT_TYPE_ID`),
  KEY `STATUS_TYPE_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `STATUS_TYPE_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `STATUS_TYPE_PARENT` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `status_type` (`STATUS_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `status_valid_change`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_valid_change` (
  `STATUS_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONDITION_EXPRESSION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRANSITION_NAME` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`STATUS_ID`,`STATUS_ID_TO`),
  KEY `STATUS_CHG_MAIN` (`STATUS_ID`),
  KEY `STATUS_CHG_TO` (`STATUS_ID_TO`),
  KEY `STS_VLD_CHG_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `STS_VLD_CHG_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `STATUS_CHG_MAIN` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `STATUS_CHG_TO` FOREIGN KEY (`STATUS_ID_TO`) REFERENCES `status_item` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `system_property`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_property` (
  `SYSTEM_RESOURCE_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SYSTEM_PROPERTY_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SYSTEM_PROPERTY_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SYSTEM_RESOURCE_ID`,`SYSTEM_PROPERTY_ID`),
  KEY `SSTM_PRPRT_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `SSTM_PRPRT_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tarpitted_login_view`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarpitted_login_view` (
  `VIEW_NAME_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TARPIT_RELEASE_DATE_TIME` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`VIEW_NAME_ID`,`USER_LOGIN_ID`),
  KEY `TRPTD_LGN_VW_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  KEY `TRPTD_LGN_VW_TXCRS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `telecom_gateway_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `telecom_gateway_config` (
  `TELECOM_GATEWAY_CONFIG_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`TELECOM_GATEWAY_CONFIG_ID`),
  KEY `TLM_GTW_CNG_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `TLM_GTW_CNG_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `telecom_method_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `telecom_method_type` (
  `TELECOM_METHOD_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`TELECOM_METHOD_TYPE_ID`),
  KEY `TLCM_MTD_TP_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `TLCM_MTD_TP_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `temporal_expression`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temporal_expression` (
  `TEMP_EXPR_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TEMP_EXPR_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DATE1` datetime(3) DEFAULT NULL,
  `DATE2` datetime(3) DEFAULT NULL,
  `INTEGER1` decimal(20,0) DEFAULT NULL,
  `INTEGER2` decimal(20,0) DEFAULT NULL,
  `STRING1` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STRING2` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`TEMP_EXPR_ID`),
  KEY `TMPL_EXPRSN_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `TMPL_EXPRSN_TXCRTS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `temporal_expression_assoc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temporal_expression_assoc` (
  `FROM_TEMP_EXPR_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TO_TEMP_EXPR_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `EXPR_ASSOC_TYPE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FROM_TEMP_EXPR_ID`,`TO_TEMP_EXPR_ID`),
  KEY `TEMP_EXPR_FROM` (`FROM_TEMP_EXPR_ID`),
  KEY `TEMP_EXPR_TO` (`TO_TEMP_EXPR_ID`),
  KEY `TML_EXPRN_ASC_TXSP` (`LAST_UPDATED_TX_STAMP`),
  KEY `TML_EXPRN_ASC_TXCS` (`CREATED_TX_STAMP`),
  CONSTRAINT `TEMP_EXPR_FROM` FOREIGN KEY (`FROM_TEMP_EXPR_ID`) REFERENCES `temporal_expression` (`TEMP_EXPR_ID`),
  CONSTRAINT `TEMP_EXPR_TO` FOREIGN KEY (`TO_TEMP_EXPR_ID`) REFERENCES `temporal_expression` (`TEMP_EXPR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `third_party_login`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `third_party_login` (
  `PRODUCT_STORE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOGIN_METH_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOGIN_PROVIDER_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`LOGIN_METH_TYPE_ID`,`LOGIN_PROVIDER_ID`,`FROM_DATE`),
  KEY `PROD_STORE_LOGINS` (`PRODUCT_STORE_ID`),
  KEY `THD_PRT_LGN_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `THD_PRT_LGN_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `PROD_STORE_LOGINS` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uom`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uom` (
  `UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `UOM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ABBREVIATION` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NUMERIC_CODE` decimal(20,0) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`UOM_ID`),
  KEY `UOM_TO_TYPE` (`UOM_TYPE_ID`),
  KEY `UOM_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `UOM_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `UOM_TO_TYPE` FOREIGN KEY (`UOM_TYPE_ID`) REFERENCES `uom_type` (`UOM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uom_conversion`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uom_conversion` (
  `UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `UOM_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONVERSION_FACTOR` double DEFAULT NULL,
  `CUSTOM_METHOD_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DECIMAL_SCALE` decimal(20,0) DEFAULT NULL,
  `ROUNDING_MODE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`UOM_ID`,`UOM_ID_TO`),
  KEY `UOM_CONV_MAIN` (`UOM_ID`),
  KEY `UOM_CONV_TO` (`UOM_ID_TO`),
  KEY `UOM_CUSTOM_METHOD` (`CUSTOM_METHOD_ID`),
  KEY `UM_CNVRSN_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `UM_CNVRSN_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `UOM_CONV_MAIN` FOREIGN KEY (`UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `UOM_CONV_TO` FOREIGN KEY (`UOM_ID_TO`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `UOM_CUSTOM_METHOD` FOREIGN KEY (`CUSTOM_METHOD_ID`) REFERENCES `custom_method` (`CUSTOM_METHOD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uom_conversion_dated`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uom_conversion_dated` (
  `UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `UOM_ID_TO` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `CONVERSION_FACTOR` double DEFAULT NULL,
  `CUSTOM_METHOD_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DECIMAL_SCALE` decimal(20,0) DEFAULT NULL,
  `ROUNDING_MODE` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PURPOSE_ENUM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`UOM_ID`,`UOM_ID_TO`,`FROM_DATE`),
  KEY `DATE_UOM_CONV_MAIN` (`UOM_ID`),
  KEY `DATE_UOM_CONV_TO` (`UOM_ID_TO`),
  KEY `UOMD_CUSTOM_METHOD` (`CUSTOM_METHOD_ID`),
  KEY `UOMD_PURPOSE_ENUM` (`PURPOSE_ENUM_ID`),
  KEY `UM_CNVRN_DTD_TXSTP` (`LAST_UPDATED_TX_STAMP`),
  KEY `UM_CNVRN_DTD_TXCRS` (`CREATED_TX_STAMP`),
  CONSTRAINT `DATE_UOM_CONV_MAIN` FOREIGN KEY (`UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `DATE_UOM_CONV_TO` FOREIGN KEY (`UOM_ID_TO`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `UOMD_CUSTOM_METHOD` FOREIGN KEY (`CUSTOM_METHOD_ID`) REFERENCES `custom_method` (`CUSTOM_METHOD_ID`),
  CONSTRAINT `UOMD_PURPOSE_ENUM` FOREIGN KEY (`PURPOSE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uom_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uom_group` (
  `UOM_GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `UOM_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`UOM_GROUP_ID`,`UOM_ID`),
  KEY `UOM_GROUP_UOM` (`UOM_ID`),
  KEY `UOM_GROUP_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `UOM_GROUP_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `UOM_GROUP_UOM` FOREIGN KEY (`UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uom_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uom_type` (
  `UOM_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_TABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`UOM_TYPE_ID`),
  KEY `UOM_TYPE_PARENT` (`PARENT_TYPE_ID`),
  KEY `UOM_TYPE_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `UOM_TYPE_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `UOM_TYPE_PARENT` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `uom_type` (`UOM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `user_login`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_login` (
  `USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CURRENT_PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PASSWORD_HINT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_SYSTEM` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENABLED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_LOGGED_OUT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIRE_PASSWORD_CHANGE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_CURRENCY_UOM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_LOCALE` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_TIME_ZONE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DISABLED_DATE_TIME` datetime(3) DEFAULT NULL,
  `SUCCESSIVE_FAILED_LOGINS` decimal(20,0) DEFAULT NULL,
  `EXTERNAL_AUTH_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_LDAP_DN` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DISABLED_BY` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`USER_LOGIN_ID`),
  KEY `USER_PARTY` (`PARTY_ID`),
  KEY `USER_LOGIN_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `USER_LOGIN_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `USER_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_login_history`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_login_history` (
  `USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VISIT_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `PASSWORD_USED` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUCCESSFUL_LOGIN` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `PARTY_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  PRIMARY KEY (`USER_LOGIN_ID`,`FROM_DATE`),
  KEY `USER_LH_USER` (`USER_LOGIN_ID`),
  KEY `USER_LH_PARTY` (`PARTY_ID`),
  KEY `USR_LGN_HSR_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `USR_LGN_HSR_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `USER_LH_PARTY` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `USER_LH_USER` FOREIGN KEY (`USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_login_password_history`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_login_password_history` (
  `USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `CURRENT_PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_LOGIN_ID`,`FROM_DATE`),
  KEY `USER_LPH_USER` (`USER_LOGIN_ID`),
  KEY `USR_LGN_PSD_HSR_TP` (`LAST_UPDATED_TX_STAMP`),
  KEY `USR_LGN_PSD_HSR_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `USER_LPH_USER` FOREIGN KEY (`USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_login_security_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_login_security_group` (
  `USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GROUP_ID` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_LOGIN_ID`,`GROUP_ID`,`FROM_DATE`),
  KEY `USER_SECGRP_USER` (`USER_LOGIN_ID`),
  KEY `USER_SECGRP_GRP` (`GROUP_ID`),
  KEY `USR_LGN_SCT_GRP_TP` (`LAST_UPDATED_TX_STAMP`),
  KEY `USR_LGN_SCT_GRP_TS` (`CREATED_TX_STAMP`),
  CONSTRAINT `USER_SECGRP_GRP` FOREIGN KEY (`GROUP_ID`) REFERENCES `security_group` (`GROUP_ID`),
  CONSTRAINT `USER_SECGRP_USER` FOREIGN KEY (`USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_login_session`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_login_session` (
  `USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SAVED_DATE` datetime(3) DEFAULT NULL,
  `SESSION_DATA` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_LOGIN_ID`),
  KEY `USER_SESSION_USER` (`USER_LOGIN_ID`),
  KEY `USR_LGN_SSN_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `USR_LGN_SSN_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `USER_SESSION_USER` FOREIGN KEY (`USER_LOGIN_ID`) REFERENCES `user_login` (`USER_LOGIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_pref_group_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_pref_group_type` (
  `USER_PREF_GROUP_TYPE_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_PREF_GROUP_TYPE_ID`),
  KEY `USR_PRF_GRP_TP_TXP` (`LAST_UPDATED_TX_STAMP`),
  KEY `USR_PRF_GRP_TP_TXS` (`CREATED_TX_STAMP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_preference`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_preference` (
  `USER_LOGIN_ID` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_PREF_TYPE_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_PREF_GROUP_TYPE_ID` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_PREF_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_PREF_DATA_TYPE` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_TX_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_STAMP` datetime(3) DEFAULT NULL,
  `CREATED_TX_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_LOGIN_ID`,`USER_PREF_TYPE_ID`),
  KEY `UP_USER_GROUP_TYPE` (`USER_PREF_GROUP_TYPE_ID`),
  KEY `USR_PRFRNC_TXSTMP` (`LAST_UPDATED_TX_STAMP`),
  KEY `USR_PRFRNC_TXCRTS` (`CREATED_TX_STAMP`),
  CONSTRAINT `UP_USER_GROUP_TYPE` FOREIGN KEY (`USER_PREF_GROUP_TYPE_ID`) REFERENCES `user_pref_group_type` (`USER_PREF_GROUP_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-01-23 14:50:49
