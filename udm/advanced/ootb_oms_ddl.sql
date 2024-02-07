-- MySQL dump 10.13  Distrib 8.2.0, for macos14.0 (arm64)
--
-- Host: localhost    Database: ootb_oms
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
-- Table structure for table `app_instance`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_instance` (
  `APP_INSTANCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INSTANCE_IMAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INSTANCE_HOST_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DATABASE_HOST_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOST_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INSTANCE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INSTANCE_UUID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INIT_COMMAND` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `JSON_CONFIG` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NETWORK_MODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`APP_INSTANCE_ID`),
  KEY `IDXAppInstanceInstanceImage` (`INSTANCE_IMAGE_ID`),
  KEY `IDXAppInstanceInstanceHost` (`INSTANCE_HOST_ID`),
  KEY `IDXAppInstanceDatabaseHost` (`DATABASE_HOST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `app_instance_env`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_instance_env` (
  `APP_INSTANCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENV_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENV_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`APP_INSTANCE_ID`,`ENV_NAME`),
  KEY `IDXAppInstanceEnvAppInstance` (`APP_INSTANCE_ID`),
  CONSTRAINT `app_instance_env_ibfk_1` FOREIGN KEY (`APP_INSTANCE_ID`) REFERENCES `app_instance` (`APP_INSTANCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `app_instance_host_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_instance_host_config` (
  `APP_INSTANCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `HOST_CONFIG_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `HOST_CONFIG_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TYPE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`APP_INSTANCE_ID`,`HOST_CONFIG_NAME`),
  KEY `IDXAppInstanceHostConfigAppInstance` (`APP_INSTANCE_ID`),
  CONSTRAINT `app_instance_host_config_ibfk_1` FOREIGN KEY (`APP_INSTANCE_ID`) REFERENCES `app_instance` (`APP_INSTANCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `app_instance_link`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_instance_link` (
  `APP_INSTANCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INSTANCE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ALIAS_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`APP_INSTANCE_ID`,`INSTANCE_NAME`),
  KEY `IDXAppInstanceLinkAppInstance` (`APP_INSTANCE_ID`),
  CONSTRAINT `app_instance_link_ibfk_1` FOREIGN KEY (`APP_INSTANCE_ID`) REFERENCES `app_instance` (`APP_INSTANCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `app_instance_volume`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_instance_volume` (
  `APP_INSTANCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MOUNT_POINT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VOLUME_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`APP_INSTANCE_ID`,`MOUNT_POINT`),
  KEY `IDXAppInstanceVolumeAppInstanc` (`APP_INSTANCE_ID`),
  CONSTRAINT `app_instance_volume_ibfk_1` FOREIGN KEY (`APP_INSTANCE_ID`) REFERENCES `app_instance` (`APP_INSTANCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `artifact_authz`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artifact_authz` (
  `ARTIFACT_AUTHZ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ARTIFACT_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTHZ_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTHZ_ACTION_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTHZ_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ARTIFACT_AUTHZ_ID`),
  KEY `IDXArtifactAuthzUserGroup` (`USER_GROUP_ID`),
  KEY `IDXArtifactAuthzArtifactGroup` (`ARTIFACT_GROUP_ID`),
  KEY `IDXArtifactAuthzAuthzTypeEnumeration` (`AUTHZ_TYPE_ENUM_ID`),
  KEY `IDXArtifactAuthzAuthzActionEnumeration` (`AUTHZ_ACTION_ENUM_ID`),
  CONSTRAINT `artifact_authz_ibfk_1` FOREIGN KEY (`AUTHZ_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `artifact_authz_ibfk_2` FOREIGN KEY (`AUTHZ_ACTION_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `artifact_authz_failure`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artifact_authz_failure` (
  `FAILURE_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ARTIFACT_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ARTIFACT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTHZ_ACTION_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FAILURE_DATE` datetime(3) DEFAULT NULL,
  `IS_DENY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FAILURE_ID`),
  KEY `IDXArtifactAuthzFailureATypeEnumeration` (`ARTIFACT_TYPE_ENUM_ID`),
  KEY `IDXArtifactAuthzFailureAuthzActionEnumeration` (`AUTHZ_ACTION_ENUM_ID`),
  CONSTRAINT `artifact_authz_failure_ibfk_1` FOREIGN KEY (`ARTIFACT_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `artifact_authz_failure_ibfk_2` FOREIGN KEY (`AUTHZ_ACTION_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `artifact_authz_filter`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artifact_authz_filter` (
  `ARTIFACT_AUTHZ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENTITY_FILTER_SET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `APPLY_COND` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ARTIFACT_AUTHZ_ID`,`ENTITY_FILTER_SET_ID`),
  KEY `IDXArtifactAuthzFilterArtifactAuthz` (`ARTIFACT_AUTHZ_ID`),
  KEY `IDXArtifactAuthzFilterEntityFilterSet` (`ENTITY_FILTER_SET_ID`),
  CONSTRAINT `artifact_authz_filter_ibfk_1` FOREIGN KEY (`ARTIFACT_AUTHZ_ID`) REFERENCES `artifact_authz` (`ARTIFACT_AUTHZ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `artifact_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artifact_group` (
  `ARTIFACT_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ARTIFACT_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `artifact_group_member`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artifact_group_member` (
  `ARTIFACT_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ARTIFACT_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ARTIFACT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `NAME_IS_PATTERN` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INHERIT_AUTHZ` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FILTER_MAP` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ARTIFACT_GROUP_ID`,`ARTIFACT_NAME`,`ARTIFACT_TYPE_ENUM_ID`),
  KEY `IDXArtifactGroupMemberArtifactGroup` (`ARTIFACT_GROUP_ID`),
  KEY `IDXArtifactGroupMemberATypeEnumeration` (`ARTIFACT_TYPE_ENUM_ID`),
  CONSTRAINT `artifact_group_member_ibfk_1` FOREIGN KEY (`ARTIFACT_GROUP_ID`) REFERENCES `artifact_group` (`ARTIFACT_GROUP_ID`),
  CONSTRAINT `artifact_group_member_ibfk_2` FOREIGN KEY (`ARTIFACT_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `artifact_hit`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artifact_hit` (
  `HIT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VISIT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ARTIFACT_TYPE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ARTIFACT_SUB_TYPE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ARTIFACT_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARAMETER_STRING` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `START_DATE_TIME` datetime(3) DEFAULT NULL,
  `RUNNING_TIME_MILLIS` decimal(32,12) DEFAULT NULL,
  `IS_SLOW_HIT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OUTPUT_SIZE` decimal(20,0) DEFAULT NULL,
  `WAS_ERROR` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ERROR_MESSAGE` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUEST_URL` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REFERRER_URL` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVER_IP_ADDRESS` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVER_HOST_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`HIT_ID`),
  KEY `ARTIFACT_HIT_VST` (`VISIT_ID`),
  KEY `ARTIFACT_HIT_USR` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `artifact_hit_bin`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artifact_hit_bin` (
  `HIT_BIN_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ARTIFACT_TYPE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ARTIFACT_SUB_TYPE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ARTIFACT_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVER_IP_ADDRESS` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVER_HOST_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BIN_START_DATE_TIME` datetime(3) DEFAULT NULL,
  `BIN_END_DATE_TIME` datetime(3) DEFAULT NULL,
  `HIT_COUNT` decimal(20,0) DEFAULT NULL,
  `TOTAL_TIME_MILLIS` decimal(26,6) DEFAULT NULL,
  `TOTAL_SQUARED_TIME` decimal(26,6) DEFAULT NULL,
  `MIN_TIME_MILLIS` decimal(26,6) DEFAULT NULL,
  `MAX_TIME_MILLIS` decimal(26,6) DEFAULT NULL,
  `SLOW_HIT_COUNT` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`HIT_BIN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `artifact_tarpit`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artifact_tarpit` (
  `USER_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ARTIFACT_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MAX_HITS_COUNT` decimal(20,0) DEFAULT NULL,
  `MAX_HITS_DURATION` decimal(20,0) DEFAULT NULL,
  `TARPIT_DURATION` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_GROUP_ID`,`ARTIFACT_GROUP_ID`),
  KEY `IDXArtifactTarpitUserGroup` (`USER_GROUP_ID`),
  KEY `IDXArtifactTarpitArtifactGroup` (`ARTIFACT_GROUP_ID`),
  CONSTRAINT `artifact_tarpit_ibfk_1` FOREIGN KEY (`ARTIFACT_GROUP_ID`) REFERENCES `artifact_group` (`ARTIFACT_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `artifact_tarpit_lock`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artifact_tarpit_lock` (
  `ARTIFACT_TARPIT_LOCK_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ARTIFACT_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ARTIFACT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RELEASE_DATE_TIME` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ARTIFACT_TARPIT_LOCK_ID`),
  KEY `IDXArtifactTarpitLockATypeEnumeration` (`ARTIFACT_TYPE_ENUM_ID`),
  CONSTRAINT `artifact_tarpit_lock_ibfk_1` FOREIGN KEY (`ARTIFACT_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset` (
  `ASSET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_ASSET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASSET_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLASS_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OWNER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASSET_POOL_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_QUANTITY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY_ON_HAND_TOTAL` decimal(26,6) DEFAULT NULL,
  `AVAILABLE_TO_PROMISE_TOTAL` decimal(26,6) DEFAULT NULL,
  `ORIGINAL_QUANTITY` decimal(26,6) DEFAULT NULL,
  `ORIGINAL_QUANTITY_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASSET_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERIAL_NUMBER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SOFT_IDENTIFIER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACTIVATION_NUMBER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACTIVATION_VALID_THRU` datetime(3) DEFAULT NULL,
  `RECEIVED_DATE` datetime(3) DEFAULT NULL,
  `ACQUIRED_DATE` datetime(3) DEFAULT NULL,
  `MANUFACTURED_DATE` datetime(3) DEFAULT NULL,
  `EXPECTED_END_OF_LIFE` date DEFAULT NULL,
  `ACTUAL_END_OF_LIFE` date DEFAULT NULL,
  `CAPACITY` decimal(26,6) DEFAULT NULL,
  `CAPACITY_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOCATION_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTAINER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_BOX_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_POINT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACQUIRE_ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACQUIRE_ORDER_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACQUIRE_SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACQUIRE_COST` decimal(24,4) DEFAULT NULL,
  `ACQUIRE_COST_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SALVAGE_VALUE` decimal(24,4) DEFAULT NULL,
  `DEPRECIATION` decimal(24,4) DEFAULT NULL,
  `DEPRECIATION_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `YEAR_BEGIN_DEPRECIATION` decimal(24,4) DEFAULT NULL,
  `TAX_DEPRECIATION` decimal(24,4) DEFAULT NULL,
  `TAX_DEPRECIATION_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ASSET_ID`),
  KEY `ASSET_SN` (`SERIAL_NUMBER`),
  KEY `ASSET_PdStFacAtp` (`PRODUCT_ID`,`STATUS_ID`,`FACILITY_ID`,`AVAILABLE_TO_PROMISE_TOTAL`),
  KEY `IDXAssetParentA` (`PARENT_ASSET_ID`),
  KEY `IDXAssetATypeEnumeration` (`ASSET_TYPE_ENUM_ID`),
  KEY `IDXAssetAClassEnumeration` (`CLASS_ENUM_ID`),
  KEY `IDXAssetAStatusItem` (`STATUS_ID`),
  KEY `IDXAssetOwnerParty` (`OWNER_PARTY_ID`),
  KEY `IDXAssetAssetPool` (`ASSET_POOL_ID`),
  KEY `IDXAssetProduct` (`PRODUCT_ID`),
  KEY `IDXAssetOriginalQuantityUom` (`ORIGINAL_QUANTITY_UOM_ID`),
  KEY `IDXAssetOriginFacility` (`ORIGIN_FACILITY_ID`),
  KEY `IDXAssetFacility` (`FACILITY_ID`),
  KEY `IDXAssetContainer` (`CONTAINER_ID`),
  KEY `IDXAssetShipmentBoxType` (`SHIPMENT_BOX_TYPE_ID`),
  KEY `IDXAssetLo` (`LOT_ID`),
  KEY `IDXAssetGeoPoint` (`GEO_POINT_ID`),
  KEY `IDXAssetAcquireOrderItem` (`ACQUIRE_ORDER_ID`,`ACQUIRE_ORDER_ITEM_SEQ_ID`),
  KEY `IDXAssetAcquireShipment` (`ACQUIRE_SHIPMENT_ID`),
  KEY `IDXAssetAcquireCostUom` (`ACQUIRE_COST_UOM_ID`),
  KEY `IDXAssetDepreciationTypeEnumeration` (`DEPRECIATION_TYPE_ENUM_ID`),
  KEY `IDXAssetTaxDepreciationTypeEnumeration` (`TAX_DEPRECIATION_TYPE_ENUM_ID`),
  CONSTRAINT `asset_ibfk_1` FOREIGN KEY (`PARENT_ASSET_ID`) REFERENCES `asset` (`ASSET_ID`),
  CONSTRAINT `asset_ibfk_2` FOREIGN KEY (`OWNER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `asset_ibfk_3` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `asset_ibfk_4` FOREIGN KEY (`ORIGIN_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `asset_ibfk_5` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `asset_ibfk_6` FOREIGN KEY (`ACQUIRE_ORDER_ID`, `ACQUIRE_ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_detail`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_detail` (
  `ASSET_DETAIL_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ASSET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EFFECTIVE_DATE` datetime(3) DEFAULT NULL,
  `QUANTITY_ON_HAND_DIFF` decimal(26,6) DEFAULT NULL,
  `AVAILABLE_TO_PROMISE_DIFF` decimal(26,6) DEFAULT NULL,
  `UNIT_COST` decimal(26,6) DEFAULT NULL,
  `ASSET_RESERVATION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OTHER_ASSET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASSET_ISSUANCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASSET_RECEIPT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PHYSICAL_INVENTORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PHYSICAL_INVENTORY_COUNT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VARIANCE_REASON_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCTG_TRANS_RESULT_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ASSET_DETAIL_ID`),
  KEY `AST_DET_EFF_DATE` (`EFFECTIVE_DATE`),
  KEY `IDXAssetDetailAsset` (`ASSET_ID`),
  KEY `IDXAssetDetailOtherAsset` (`OTHER_ASSET_ID`),
  KEY `IDXAssetDetailShipment` (`SHIPMENT_ID`),
  KEY `IDXAssetDetailProduct` (`PRODUCT_ID`),
  KEY `IDXAssetDetailOrderItem` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `IDXAssetDetailReturnItem` (`RETURN_ID`,`RETURN_ITEM_SEQ_ID`),
  KEY `IDXAssetDetailAssetIssuance` (`ASSET_ISSUANCE_ID`),
  KEY `IDXAssetDetailAssetReceipt` (`ASSET_RECEIPT_ID`),
  KEY `IDXAssetDetailPhysicalInventory` (`PHYSICAL_INVENTORY_ID`),
  KEY `IDXAssetDetailPhysicalInventoryCount` (`PHYSICAL_INVENTORY_COUNT_ID`),
  KEY `IDXAssetDetailInventoryVarianceReasonEnumeration` (`VARIANCE_REASON_ENUM_ID`),
  KEY `IDXAssetDetailAcctgTransResultEnumeration` (`ACCTG_TRANS_RESULT_ENUM_ID`),
  CONSTRAINT `asset_detail_ibfk_1` FOREIGN KEY (`ASSET_ID`) REFERENCES `asset` (`ASSET_ID`),
  CONSTRAINT `asset_detail_ibfk_2` FOREIGN KEY (`OTHER_ASSET_ID`) REFERENCES `asset` (`ASSET_ID`),
  CONSTRAINT `asset_detail_ibfk_3` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `asset_detail_ibfk_4` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `asset_detail_ibfk_5` FOREIGN KEY (`RETURN_ID`, `RETURN_ITEM_SEQ_ID`) REFERENCES `return_item` (`RETURN_ID`, `RETURN_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_identification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_identification` (
  `ASSET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `IDENTIFICATION_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ID_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ASSET_ID`,`IDENTIFICATION_TYPE_ENUM_ID`),
  KEY `IDXAssetIdentificationAsset` (`ASSET_ID`),
  KEY `IDXAssetIdentificationAITypeEnumer` (`IDENTIFICATION_TYPE_ENUM_ID`),
  CONSTRAINT `asset_identification_ibfk_1` FOREIGN KEY (`ASSET_ID`) REFERENCES `asset` (`ASSET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_issuance`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_issuance` (
  `ASSET_ISSUANCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ASSET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASSET_RESERVATION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ITEM_SOURCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ISSUED_BY_USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ISSUED_DATE` datetime(3) DEFAULT NULL,
  `QUANTITY` decimal(26,6) DEFAULT NULL,
  `QUANTITY_CANCELLED` decimal(26,6) DEFAULT NULL,
  `ACCTG_TRANS_RESULT_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ASSET_ISSUANCE_ID`),
  KEY `ASSET_ISS_SHPPRD` (`SHIPMENT_ID`,`PRODUCT_ID`),
  KEY `IDXAssetIssuanceAsset` (`ASSET_ID`),
  KEY `IDXAssetIssuanceOrderItem` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `IDXAssetIssuanceShipment` (`SHIPMENT_ID`),
  KEY `IDXAssetIssuanceShipmentItemSource` (`SHIPMENT_ITEM_SOURCE_ID`),
  KEY `IDXAssetIssuanceReturnItem` (`RETURN_ID`,`RETURN_ITEM_SEQ_ID`),
  KEY `IDXAssetIssuanceProduct` (`PRODUCT_ID`),
  KEY `IDXAssetIssuanceFacility` (`FACILITY_ID`),
  KEY `IDXAssetIssuanceIssuedByUserAccount` (`ISSUED_BY_USER_ID`),
  KEY `IDXAssetIssuanceAcctgTransResultEnumeration` (`ACCTG_TRANS_RESULT_ENUM_ID`),
  CONSTRAINT `asset_issuance_ibfk_1` FOREIGN KEY (`ASSET_ID`) REFERENCES `asset` (`ASSET_ID`),
  CONSTRAINT `asset_issuance_ibfk_2` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `asset_issuance_ibfk_3` FOREIGN KEY (`RETURN_ID`, `RETURN_ITEM_SEQ_ID`) REFERENCES `return_item` (`RETURN_ID`, `RETURN_ITEM_SEQ_ID`),
  CONSTRAINT `asset_issuance_ibfk_4` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `asset_issuance_ibfk_5` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_issuance_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_issuance_party` (
  `ASSET_ISSUANCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ASSET_ISSUANCE_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `IDXAssetIssuancePartyAssetIssuance` (`ASSET_ISSUANCE_ID`),
  KEY `IDXAssetIssuancePartyP` (`PARTY_ID`),
  KEY `IDXAssetIssuancePartyRoleType` (`ROLE_TYPE_ID`),
  CONSTRAINT `asset_issuance_party_ibfk_1` FOREIGN KEY (`ASSET_ISSUANCE_ID`) REFERENCES `asset_issuance` (`ASSET_ISSUANCE_ID`),
  CONSTRAINT `asset_issuance_party_ibfk_2` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `asset_issuance_party_ibfk_3` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_party_assignment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_party_assignment` (
  `ASSET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `ALLOCATED_DATE` datetime(3) DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ASSET_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`FROM_DATE`),
  KEY `IDXAssetPartyAssignmentParty` (`PARTY_ID`),
  KEY `IDXAssetPartyAssignmentRoleType` (`ROLE_TYPE_ID`),
  KEY `IDXAssetPartyAssignmentAsse` (`ASSET_ID`),
  KEY `IDXAssetPartyAssignmentStatusItem` (`STATUS_ID`),
  CONSTRAINT `asset_party_assignment_ibfk_1` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `asset_party_assignment_ibfk_2` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`),
  CONSTRAINT `asset_party_assignment_ibfk_3` FOREIGN KEY (`ASSET_ID`) REFERENCES `asset` (`ASSET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_pool`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_pool` (
  `ASSET_POOL_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PSEUDO_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OWNER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ASSET_POOL_ID`),
  UNIQUE KEY `ASSET_POOL_PSEUDO` (`PSEUDO_ID`,`OWNER_PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_pool_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_pool_party` (
  `ASSET_POOL_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ASSET_POOL_ID`,`PARTY_ID`),
  KEY `IDXAssetPoolPartyAssetPool` (`ASSET_POOL_ID`),
  KEY `IDXAssetPoolPartyP` (`PARTY_ID`),
  KEY `IDXAssetPoolPartyRoleType` (`ROLE_TYPE_ID`),
  CONSTRAINT `asset_pool_party_ibfk_1` FOREIGN KEY (`ASSET_POOL_ID`) REFERENCES `asset_pool` (`ASSET_POOL_ID`),
  CONSTRAINT `asset_pool_party_ibfk_2` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `asset_pool_party_ibfk_3` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_pool_store`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_pool_store` (
  `ASSET_POOL_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ASSET_POOL_ID`,`PRODUCT_STORE_ID`),
  KEY `IDXAssetPoolStoreAssetPool` (`ASSET_POOL_ID`),
  KEY `IDXAssetPoolStoreProductS` (`PRODUCT_STORE_ID`),
  CONSTRAINT `asset_pool_store_ibfk_1` FOREIGN KEY (`ASSET_POOL_ID`) REFERENCES `asset_pool` (`ASSET_POOL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_receipt`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_receipt` (
  `ASSET_RECEIPT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ASSET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ITEM_SOURCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_PACKAGE_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECEIVED_BY_USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECEIVED_DATE` datetime(3) DEFAULT NULL,
  `ITEM_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY_ACCEPTED` decimal(26,6) DEFAULT NULL,
  `QUANTITY_REJECTED` decimal(26,6) DEFAULT NULL,
  `REJECTION_REASON_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCTG_TRANS_RESULT_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ASSET_RECEIPT_ID`),
  KEY `ASSET_REC_ORDID` (`ORDER_ID`),
  KEY `ASSET_REC_SHPPRD` (`SHIPMENT_ID`,`PRODUCT_ID`),
  KEY `IDXAssetReceiptAsse` (`ASSET_ID`),
  KEY `IDXAssetReceiptProduc` (`PRODUCT_ID`),
  KEY `IDXAssetReceiptOrderItem` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `IDXAssetReceiptShipmen` (`SHIPMENT_ID`),
  KEY `IDXAssetReceiptShipmentItemSource` (`SHIPMENT_ITEM_SOURCE_ID`),
  KEY `IDXAssetReceiptReturnItem` (`RETURN_ID`,`RETURN_ITEM_SEQ_ID`),
  KEY `IDXAssetReceiptReceivedByUserAccoun` (`RECEIVED_BY_USER_ID`),
  KEY `IDXAssetReceiptRejectionReasonEnumeration` (`REJECTION_REASON_ENUM_ID`),
  KEY `IDXAssetReceiptAcctgTransResultEnumeration` (`ACCTG_TRANS_RESULT_ENUM_ID`),
  CONSTRAINT `asset_receipt_ibfk_1` FOREIGN KEY (`ASSET_ID`) REFERENCES `asset` (`ASSET_ID`),
  CONSTRAINT `asset_receipt_ibfk_2` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `asset_receipt_ibfk_3` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `asset_receipt_ibfk_4` FOREIGN KEY (`RETURN_ID`, `RETURN_ITEM_SEQ_ID`) REFERENCES `return_item` (`RETURN_ID`, `RETURN_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_reservation`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_reservation` (
  `ASSET_RESERVATION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ASSET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESERVATION_ORDER_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(26,6) DEFAULT NULL,
  `QUANTITY_NOT_AVAILABLE` decimal(26,6) DEFAULT NULL,
  `QUANTITY_NOT_ISSUED` decimal(26,6) DEFAULT NULL,
  `RESERVED_DATE` datetime(3) DEFAULT NULL,
  `ORIGINAL_PROMISED_DATE` datetime(3) DEFAULT NULL,
  `CURRENT_PROMISED_DATE` datetime(3) DEFAULT NULL,
  `PRIORITY` decimal(20,0) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ASSET_RESERVATION_ID`),
  KEY `IDXAssetReservationAsset` (`ASSET_ID`),
  KEY `IDXAssetReservationProduct` (`PRODUCT_ID`),
  KEY `IDXAssetReservationOrderItem` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `IDXAssetReservationAROrderEnumer` (`RESERVATION_ORDER_ENUM_ID`),
  CONSTRAINT `asset_reservation_ibfk_1` FOREIGN KEY (`ASSET_ID`) REFERENCES `asset` (`ASSET_ID`),
  CONSTRAINT `asset_reservation_ibfk_2` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `asset_reservation_ibfk_3` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bar`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bar` (
  `BAR_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FOO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BAR_RANK` decimal(20,0) DEFAULT NULL,
  `BAR_SCORE` decimal(26,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`BAR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `carrier_shipment_box_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrier_shipment_box_type` (
  `CARRIER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_BOX_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PACKAGING_TYPE_CODE` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OVERSIZE_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CARRIER_PARTY_ID`,`SHIPMENT_BOX_TYPE_ID`),
  KEY `IDXCarrierShipmentBoxTypeSBT` (`SHIPMENT_BOX_TYPE_ID`),
  KEY `IDXCarrierShipmentBoxTypeCParty` (`CARRIER_PARTY_ID`),
  CONSTRAINT `carrier_shipment_box_type_ibfk_1` FOREIGN KEY (`SHIPMENT_BOX_TYPE_ID`) REFERENCES `shipment_box_type` (`SHIPMENT_BOX_TYPE_ID`),
  CONSTRAINT `carrier_shipment_box_type_ibfk_2` FOREIGN KEY (`CARRIER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `carrier_shipment_method`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carrier_shipment_method` (
  `CARRIER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_METHOD_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `CARRIER_SERVICE_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SCA_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GATEWAY_SERVICE_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CARRIER_PARTY_ID`,`SHIPMENT_METHOD_ENUM_ID`),
  KEY `IDXCarrierShipmentMethodCParty` (`CARRIER_PARTY_ID`),
  KEY `IDXCarrierShipmentMethodShipmentMethodEnumeration` (`SHIPMENT_METHOD_ENUM_ID`),
  CONSTRAINT `carrier_shipment_method_ibfk_1` FOREIGN KEY (`CARRIER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event` (
  `COMMUNICATION_EVENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COMMUNICATION_EVENT_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTACT_MECH_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_COMM_EVENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROOT_COMM_EVENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENTRY_DATE` datetime(3) DEFAULT NULL,
  `DATETIME_STARTED` datetime(3) DEFAULT NULL,
  `DATETIME_ENDED` datetime(3) DEFAULT NULL,
  `SUBJECT` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_TYPE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BODY` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `NOTE` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REASON_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COMMUNICATION_EVENT_ID`),
  KEY `COMMEVT_TP_ST_CET` (`TO_PARTY_ID`,`STATUS_ID`,`COMMUNICATION_EVENT_TYPE_ID`),
  KEY `IDXCommunicationEventCommunicationEventType` (`COMMUNICATION_EVENT_TYPE_ID`),
  KEY `IDXCommunicationEventCntactMechTypeEnumeration` (`CONTACT_MECH_TYPE_ENUM_ID`),
  KEY `IDXCommunicationEventCEStatusItem` (`STATUS_ID`),
  KEY `IDXCommunicationEventParentCE` (`PARENT_COMM_EVENT_ID`),
  KEY `IDXCommunicationEventRootCE` (`ROOT_COMM_EVENT_ID`),
  KEY `IDXCommunicationEventFromContactMech` (`FROM_CONTACT_MECH_ID`),
  KEY `IDXCommunicationEventToContactMech` (`TO_CONTACT_MECH_ID`),
  KEY `IDXCommunicationEventFromParty` (`FROM_PARTY_ID`),
  KEY `IDXCommunicationEventFromRoleType` (`FROM_ROLE_TYPE_ID`),
  KEY `IDXCommunicationEventToParty` (`TO_PARTY_ID`),
  KEY `IDXCommunicationEventToRoleType` (`TO_ROLE_TYPE_ID`),
  KEY `IDXCommunicationEventCEReasonEnumeration` (`REASON_ENUM_ID`),
  CONSTRAINT `communication_event_ibfk_1` FOREIGN KEY (`PARENT_COMM_EVENT_ID`) REFERENCES `communication_event` (`COMMUNICATION_EVENT_ID`),
  CONSTRAINT `communication_event_ibfk_2` FOREIGN KEY (`ROOT_COMM_EVENT_ID`) REFERENCES `communication_event` (`COMMUNICATION_EVENT_ID`),
  CONSTRAINT `communication_event_ibfk_3` FOREIGN KEY (`FROM_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `communication_event_ibfk_4` FOREIGN KEY (`FROM_ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`),
  CONSTRAINT `communication_event_ibfk_5` FOREIGN KEY (`TO_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `communication_event_ibfk_6` FOREIGN KEY (`TO_ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event_content`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event_content` (
  `COMMUNICATION_EVENT_CONTENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COMMUNICATION_EVENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_DATE` datetime(3) DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COMMUNICATION_EVENT_CONTENT_ID`),
  KEY `IDXCommunicationEventContentUserAccou` (`USER_ID`),
  KEY `IDXCommunicationEventContentCContentTypeEnumeration` (`CONTENT_TYPE_ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event_party` (
  `COMMUNICATION_EVENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COMMUNICATION_EVENT_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `IDXCommunicationEventPartyCommunicationEvent` (`COMMUNICATION_EVENT_ID`),
  KEY `IDXCommunicationEventPartyP` (`PARTY_ID`),
  KEY `IDXCommunicationEventPartyRoleType` (`ROLE_TYPE_ID`),
  KEY `IDXCommunicationEventPartyContactMech` (`CONTACT_MECH_ID`),
  KEY `IDXCommunicationEventPartyCEPStatusItem` (`STATUS_ID`),
  CONSTRAINT `communication_event_party_ibfk_1` FOREIGN KEY (`COMMUNICATION_EVENT_ID`) REFERENCES `communication_event` (`COMMUNICATION_EVENT_ID`),
  CONSTRAINT `communication_event_party_ibfk_2` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `communication_event_party_ibfk_3` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event_product`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event_product` (
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COMMUNICATION_EVENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`COMMUNICATION_EVENT_ID`),
  KEY `IDXCommunicationEventProductP` (`PRODUCT_ID`),
  KEY `IDXCommunicationEventProductCommunicationEven` (`COMMUNICATION_EVENT_ID`),
  CONSTRAINT `communication_event_product_ibfk_1` FOREIGN KEY (`COMMUNICATION_EVENT_ID`) REFERENCES `communication_event` (`COMMUNICATION_EVENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event_purpose`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event_purpose` (
  `COMMUNICATION_EVENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PURPOSE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COMMUNICATION_EVENT_ID`,`PURPOSE_ENUM_ID`),
  KEY `IDXCommunicationEventPurposeCommunicationEvent` (`COMMUNICATION_EVENT_ID`),
  KEY `IDXCommunicationEventPurposeCPurposeEnumeration` (`PURPOSE_ENUM_ID`),
  CONSTRAINT `communication_event_purpose_ibfk_1` FOREIGN KEY (`COMMUNICATION_EVENT_ID`) REFERENCES `communication_event` (`COMMUNICATION_EVENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `communication_event_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communication_event_type` (
  `COMMUNICATION_EVENT_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTACT_MECH_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`COMMUNICATION_EVENT_TYPE_ID`),
  KEY `IDXCommunicationEventTypeParentCET` (`PARENT_TYPE_ID`),
  KEY `IDXCommunicationEventTypeCntactMechTypeEnumeration` (`CONTACT_MECH_TYPE_ENUM_ID`),
  CONSTRAINT `communication_event_type_ibfk_1` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `communication_event_type` (`COMMUNICATION_EVENT_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_mech` (
  `CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DATA_SOURCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INFO_STRING` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GATEWAY_CIM_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRUST_LEVEL_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VALIDATE_MESSAGE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REPLACES_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_ID`),
  KEY `CMECH_INFO_STRING` (`INFO_STRING`),
  KEY `CMECH_REPL_CMECH` (`REPLACES_CONTACT_MECH_ID`),
  KEY `IDXContactMechCMTypeEnumeration` (`CONTACT_MECH_TYPE_ENUM_ID`),
  KEY `IDXContactMechDataSource` (`DATA_SOURCE_ID`),
  KEY `IDXContactMechCPaymentTrustLevelEnumeration` (`TRUST_LEVEL_ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contact_mech_purpose`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_mech_purpose` (
  `CONTACT_MECH_PURPOSE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_PURPOSE_ID`),
  KEY `IDXContactMechPurposeCMTypeEnumeration` (`CONTACT_MECH_TYPE_ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `container`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `container` (
  `CONTAINER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SERIAL_NUMBER` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTAINER_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXTERNAL_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOCATION_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_POINT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTAINER_ID`),
  KEY `CONTNR_SER_NUM` (`SERIAL_NUMBER`),
  KEY `IDXContainerCTypeEnumeration` (`CONTAINER_TYPE_ENUM_ID`),
  KEY `IDXContainerFacility` (`FACILITY_ID`),
  CONSTRAINT `container_ibfk_1` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `currency_dimension`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currency_dimension` (
  `DIMENSION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CURRENCY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DIMENSION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_document`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_document` (
  `DATA_DOCUMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DOCUMENT_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DOCUMENT_TITLE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INDEX_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIMARY_ENTITY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MANUAL_DATA_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MANUAL_MAPPING_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DATA_DOCUMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_document_condition`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_document_condition` (
  `DATA_DOCUMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONDITION_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_NAME_ALIAS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OPERATOR` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIELD_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_FIELD_NAME_ALIAS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `POST_QUERY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DATA_DOCUMENT_ID`,`CONDITION_SEQ_ID`),
  KEY `IDXDataDocumentConditionDataDocument` (`DATA_DOCUMENT_ID`),
  CONSTRAINT `data_document_condition_ibfk_1` FOREIGN KEY (`DATA_DOCUMENT_ID`) REFERENCES `data_document` (`DATA_DOCUMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_document_field`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_document_field` (
  `DATA_DOCUMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIELD_NAME_ALIAS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIELD_TYPE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SORTABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_DISPLAY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FUNCTION_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DATA_DOCUMENT_ID`,`FIELD_SEQ_ID`),
  KEY `IDXDataDocumentFieldDataDocument` (`DATA_DOCUMENT_ID`),
  CONSTRAINT `data_document_field_ibfk_1` FOREIGN KEY (`DATA_DOCUMENT_ID`) REFERENCES `data_document` (`DATA_DOCUMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_document_link`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_document_link` (
  `DATA_DOCUMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LINK_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LINK_SET` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LABEL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LINK_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `URL_TYPE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LINK_CONDITION` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DATA_DOCUMENT_ID`,`LINK_SEQ_ID`),
  KEY `IDXDataDocumentLinkDataDocument` (`DATA_DOCUMENT_ID`),
  CONSTRAINT `data_document_link_ibfk_1` FOREIGN KEY (`DATA_DOCUMENT_ID`) REFERENCES `data_document` (`DATA_DOCUMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_document_rel_alias`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_document_rel_alias` (
  `DATA_DOCUMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RELATIONSHIP_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DOCUMENT_ALIAS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DATA_DOCUMENT_ID`,`RELATIONSHIP_NAME`),
  KEY `IDXDataDocumentRelAliasDataDocument` (`DATA_DOCUMENT_ID`),
  CONSTRAINT `data_document_rel_alias_ibfk_1` FOREIGN KEY (`DATA_DOCUMENT_ID`) REFERENCES `data_document` (`DATA_DOCUMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_document_user_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_document_user_group` (
  `DATA_DOCUMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DATA_DOCUMENT_ID`,`USER_GROUP_ID`),
  KEY `IDXDataDocumentUserGroupDataDocument` (`DATA_DOCUMENT_ID`),
  KEY `IDXDataDocumentUserGroupUG` (`USER_GROUP_ID`),
  CONSTRAINT `data_document_user_group_ibfk_1` FOREIGN KEY (`DATA_DOCUMENT_ID`) REFERENCES `data_document` (`DATA_DOCUMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_feed`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_feed` (
  `DATA_FEED_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DATA_FEED_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INDEX_ON_START_EMPTY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FEED_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FEED_RECEIVE_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FEED_DELETE_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_FEED_STAMP` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DATA_FEED_ID`),
  KEY `IDXDataFeedDFTypeEnumeration` (`DATA_FEED_TYPE_ENUM_ID`),
  CONSTRAINT `data_feed_ibfk_1` FOREIGN KEY (`DATA_FEED_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_feed_document`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_feed_document` (
  `DATA_FEED_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DATA_DOCUMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DATA_FEED_ID`,`DATA_DOCUMENT_ID`),
  KEY `IDXDataFeedDocumentDataFeed` (`DATA_FEED_ID`),
  KEY `IDXDataFeedDocumentDataD` (`DATA_DOCUMENT_ID`),
  CONSTRAINT `data_feed_document_ibfk_1` FOREIGN KEY (`DATA_FEED_ID`) REFERENCES `data_feed` (`DATA_FEED_ID`),
  CONSTRAINT `data_feed_document_ibfk_2` FOREIGN KEY (`DATA_DOCUMENT_ID`) REFERENCES `data_document` (`DATA_DOCUMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_source`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data_source` (
  `DATA_SOURCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DATA_SOURCE_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DATA_SOURCE_ID`),
  KEY `IDXDataSourceDSTypeEnumeration` (`DATA_SOURCE_TYPE_ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `database_host`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `database_host` (
  `DATABASE_HOST_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DATABASE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOST_ADDRESS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOST_PORT` decimal(20,0) DEFAULT NULL,
  `INSTANCE_ADDRESS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ADMIN_USER` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ADMIN_PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DATABASE_HOST_ID`),
  KEY `IDXDatabaseHostDatabaseType` (`DATABASE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `database_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `database_type` (
  `DATABASE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONF_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATE_SERVICE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHECK_SERVICE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DATABASE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `date_day_dimension`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `date_day_dimension` (
  `DIMENSION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DATE_VALUE` date DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DAY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DAY_OF_MONTH` decimal(20,0) DEFAULT NULL,
  `DAY_OF_YEAR` decimal(20,0) DEFAULT NULL,
  `MONTH_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MONTH_OF_YEAR` decimal(20,0) DEFAULT NULL,
  `YEAR_NAME` decimal(20,0) DEFAULT NULL,
  `WEEK_OF_MONTH` decimal(20,0) DEFAULT NULL,
  `WEEK_OF_YEAR` decimal(20,0) DEFAULT NULL,
  `YEAR_MONTH_DAY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `YEAR_AND_MONTH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_WEEK_END` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DIMENSION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_form`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_form` (
  `FORM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PURPOSE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_LIST_FORM` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MODIFY_XML_SCREEN_FORM` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_TEMPLATE_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACRO_FORM_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_FONT_SIZE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_FONT_FAMILY` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_CONTAINER_WIDTH` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_CONTAINER_HEIGHT` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_REPEAT_COUNT` decimal(20,0) DEFAULT NULL,
  `PRINT_REPEAT_NEW_PAGE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_ID`),
  KEY `IDXDbFormDFPurposeEnumeration` (`PURPOSE_ENUM_ID`),
  CONSTRAINT `db_form_ibfk_1` FOREIGN KEY (`PURPOSE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_form_field`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_form_field` (
  `FORM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `THE_CONDITION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENTRY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TITLE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TOOLTIP` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIELD_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAYOUT_SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `IS_REQUIRED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_PAGE_NUMBER` decimal(20,0) DEFAULT NULL,
  `PRINT_TOP` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_LEFT` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_BOTTOM` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_RIGHT` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_WIDTH` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_HEIGHT` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_TEXT_ALIGN` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_VERTICAL_ALIGN` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_FONT_SIZE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRINT_FONT_FAMILY` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_ID`,`FIELD_NAME`),
  KEY `IDXDbFormFieldDbForm` (`FORM_ID`),
  KEY `IDXDbFormFieldDFFTypeEnumeration` (`FIELD_TYPE_ENUM_ID`),
  CONSTRAINT `db_form_field_ibfk_1` FOREIGN KEY (`FORM_ID`) REFERENCES `db_form` (`FORM_ID`),
  CONSTRAINT `db_form_field_ibfk_2` FOREIGN KEY (`FIELD_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_form_field_attribute`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_form_field_attribute` (
  `FORM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTRIBUTE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_ID`,`FIELD_NAME`,`ATTRIBUTE_NAME`),
  KEY `IDXDbFormFieldAttributeDbFormField` (`FORM_ID`,`FIELD_NAME`),
  CONSTRAINT `db_form_field_attribute_ibfk_1` FOREIGN KEY (`FORM_ID`, `FIELD_NAME`) REFERENCES `db_form_field` (`FORM_ID`, `FIELD_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_form_field_ent_opts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_form_field_ent_opts` (
  `FORM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) NOT NULL,
  `ENTITY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TEXT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_ID`,`FIELD_NAME`,`SEQUENCE_NUM`),
  KEY `IDXDbFormFieldEntOptsDbFormField` (`FORM_ID`,`FIELD_NAME`),
  CONSTRAINT `db_form_field_ent_opts_ibfk_1` FOREIGN KEY (`FORM_ID`, `FIELD_NAME`) REFERENCES `db_form_field` (`FORM_ID`, `FIELD_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_form_field_ent_opts_cond`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_form_field_ent_opts_cond` (
  `FORM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) NOT NULL,
  `ENTITY_FIELD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_ID`,`FIELD_NAME`,`SEQUENCE_NUM`,`ENTITY_FIELD_NAME`),
  KEY `IDXDbFormFieldEntOptsCondDbFormFieldEntOpts` (`FORM_ID`,`FIELD_NAME`,`SEQUENCE_NUM`),
  CONSTRAINT `db_form_field_ent_opts_cond_ibfk_1` FOREIGN KEY (`FORM_ID`, `FIELD_NAME`, `SEQUENCE_NUM`) REFERENCES `db_form_field_ent_opts` (`FORM_ID`, `FIELD_NAME`, `SEQUENCE_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_form_field_ent_opts_order`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_form_field_ent_opts_order` (
  `FORM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) NOT NULL,
  `ORDER_SEQUENCE_NUM` decimal(20,0) NOT NULL,
  `ENTITY_FIELD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_ID`,`FIELD_NAME`,`SEQUENCE_NUM`,`ORDER_SEQUENCE_NUM`),
  KEY `IDXDbFormFieldEntOptsOrderDbFormFieldEntOpts` (`FORM_ID`,`FIELD_NAME`,`SEQUENCE_NUM`),
  CONSTRAINT `db_form_field_ent_opts_order_ibfk_1` FOREIGN KEY (`FORM_ID`, `FIELD_NAME`, `SEQUENCE_NUM`) REFERENCES `db_form_field_ent_opts` (`FORM_ID`, `FIELD_NAME`, `SEQUENCE_NUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_form_field_option`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_form_field_option` (
  `FORM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) NOT NULL,
  `KEY_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TEXT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_ID`,`FIELD_NAME`,`SEQUENCE_NUM`),
  KEY `IDXDbFormFieldOptionDbFormField` (`FORM_ID`,`FIELD_NAME`),
  CONSTRAINT `db_form_field_option_ibfk_1` FOREIGN KEY (`FORM_ID`, `FIELD_NAME`) REFERENCES `db_form_field` (`FORM_ID`, `FIELD_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_form_user_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_form_user_group` (
  `FORM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_ID`,`USER_GROUP_ID`),
  KEY `IDXDbFormUserGroupDbForm` (`FORM_ID`),
  KEY `IDXDbFormUserGroupUG` (`USER_GROUP_ID`),
  CONSTRAINT `db_form_user_group_ibfk_1` FOREIGN KEY (`FORM_ID`) REFERENCES `db_form` (`FORM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_resource`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_resource` (
  `RESOURCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_RESOURCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FILENAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_FILE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RESOURCE_ID`),
  UNIQUE KEY `DB_RES_PAR_FN` (`PARENT_RESOURCE_ID`,`FILENAME`),
  KEY `DB_RES_PARENT` (`PARENT_RESOURCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_resource_file`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_resource_file` (
  `RESOURCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MIME_TYPE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VERSION_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROOT_VERSION_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FILE_DATA` longblob,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RESOURCE_ID`),
  KEY `IDXDbResourceFileDbResourc` (`RESOURCE_ID`),
  CONSTRAINT `db_resource_file_ibfk_1` FOREIGN KEY (`RESOURCE_ID`) REFERENCES `db_resource` (`RESOURCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_resource_file_history`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_resource_file_history` (
  `RESOURCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VERSION_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PREVIOUS_VERSION_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VERSION_DATE` datetime(3) DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_DIFF` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FILE_DATA` longblob,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RESOURCE_ID`,`VERSION_NAME`),
  KEY `IDXDbResourceFileHistoryDbResourceFile` (`RESOURCE_ID`),
  CONSTRAINT `db_resource_file_history_ibfk_1` FOREIGN KEY (`RESOURCE_ID`) REFERENCES `db_resource_file` (`RESOURCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_view_entity`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_view_entity` (
  `DB_VIEW_ENTITY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PACKAGE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CACHE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_DATA_VIEW` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DB_VIEW_ENTITY_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_view_entity_alias`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_view_entity_alias` (
  `DB_VIEW_ENTITY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_ALIAS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENTITY_ALIAS` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIELD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FUNCTION_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DB_VIEW_ENTITY_NAME`,`FIELD_ALIAS`),
  KEY `IDXDbViewEntityAliasDbViewEntity` (`DB_VIEW_ENTITY_NAME`),
  KEY `IDXDbViewEntityAliasDbViewEntityMember` (`DB_VIEW_ENTITY_NAME`,`ENTITY_ALIAS`),
  CONSTRAINT `db_view_entity_alias_ibfk_1` FOREIGN KEY (`DB_VIEW_ENTITY_NAME`) REFERENCES `db_view_entity` (`DB_VIEW_ENTITY_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_view_entity_key_map`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_view_entity_key_map` (
  `DB_VIEW_ENTITY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `JOIN_FROM_ALIAS` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENTITY_ALIAS` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RELATED_FIELD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DB_VIEW_ENTITY_NAME`,`JOIN_FROM_ALIAS`,`ENTITY_ALIAS`,`FIELD_NAME`),
  KEY `IDXDbViewEntityKeyMapDbViewEntity` (`DB_VIEW_ENTITY_NAME`),
  KEY `IDXDbViewEntityKeyMapDbViewEntityMember` (`DB_VIEW_ENTITY_NAME`,`ENTITY_ALIAS`),
  CONSTRAINT `db_view_entity_key_map_ibfk_1` FOREIGN KEY (`DB_VIEW_ENTITY_NAME`) REFERENCES `db_view_entity` (`DB_VIEW_ENTITY_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db_view_entity_member`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `db_view_entity_member` (
  `DB_VIEW_ENTITY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENTITY_ALIAS` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENTITY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `JOIN_FROM_ALIAS` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `JOIN_OPTIONAL` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DB_VIEW_ENTITY_NAME`,`ENTITY_ALIAS`),
  KEY `IDXDbViewEntityMemberDbViewEntity` (`DB_VIEW_ENTITY_NAME`),
  KEY `IDXDbViewEntityMemberJoinFromDVEM` (`DB_VIEW_ENTITY_NAME`,`JOIN_FROM_ALIAS`),
  CONSTRAINT `db_view_entity_member_ibfk_1` FOREIGN KEY (`DB_VIEW_ENTITY_NAME`) REFERENCES `db_view_entity` (`DB_VIEW_ENTITY_NAME`),
  CONSTRAINT `db_view_entity_member_ibfk_2` FOREIGN KEY (`DB_VIEW_ENTITY_NAME`, `JOIN_FROM_ALIAS`) REFERENCES `db_view_entity_member` (`DB_VIEW_ENTITY_NAME`, `ENTITY_ALIAS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `delivery`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery` (
  `DELIVERY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORIGIN_FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEST_FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACTUAL_START_DATE` datetime(3) DEFAULT NULL,
  `ACTUAL_ARRIVAL_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_START_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_ARRIVAL_DATE` datetime(3) DEFAULT NULL,
  `ASSET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `START_MILEAGE` decimal(26,6) DEFAULT NULL,
  `END_MILEAGE` decimal(26,6) DEFAULT NULL,
  `FUEL_USED` decimal(26,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DELIVERY_ID`),
  KEY `IDXDeliveryAsset` (`ASSET_ID`),
  KEY `IDXDeliveryOriginFacilit` (`ORIGIN_FACILITY_ID`),
  KEY `IDXDeliveryDstFacilit` (`DEST_FACILITY_ID`),
  CONSTRAINT `delivery_ibfk_1` FOREIGN KEY (`ASSET_ID`) REFERENCES `asset` (`ASSET_ID`),
  CONSTRAINT `delivery_ibfk_2` FOREIGN KEY (`ORIGIN_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `delivery_ibfk_3` FOREIGN KEY (`DEST_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_message`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_message` (
  `EMAIL_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROOT_EMAIL_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_EMAIL_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SENT_DATE` datetime(3) DEFAULT NULL,
  `RECEIVED_DATE` datetime(3) DEFAULT NULL,
  `SUBJECT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BODY` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `BODY_TEXT` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `HEADERS_STRING` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `FROM_ADDRESS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_ADDRESSES` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CC_ADDRESSES` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BCC_ADDRESSES` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_TYPE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MESSAGE_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_TEMPLATE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_SERVER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`EMAIL_MESSAGE_ID`),
  KEY `EMAIL_MSG_ID` (`MESSAGE_ID`),
  KEY `IDXEmailMessageEMStatusItem` (`STATUS_ID`),
  KEY `IDXEmailMessageETypeEnumeration` (`EMAIL_TYPE_ENUM_ID`),
  KEY `IDXEmailMessageRootEM` (`ROOT_EMAIL_MESSAGE_ID`),
  KEY `IDXEmailMessageParentEM` (`PARENT_EMAIL_MESSAGE_ID`),
  KEY `IDXEmailMessageFromUserAccount` (`FROM_USER_ID`),
  KEY `IDXEmailMessageToUserAccount` (`TO_USER_ID`),
  KEY `IDXEmailMessageEmailTemplate` (`EMAIL_TEMPLATE_ID`),
  KEY `IDXEmailMessageEmailServer` (`EMAIL_SERVER_ID`),
  CONSTRAINT `email_message_ibfk_1` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `email_message_ibfk_2` FOREIGN KEY (`EMAIL_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `email_message_ibfk_3` FOREIGN KEY (`ROOT_EMAIL_MESSAGE_ID`) REFERENCES `email_message` (`EMAIL_MESSAGE_ID`),
  CONSTRAINT `email_message_ibfk_4` FOREIGN KEY (`PARENT_EMAIL_MESSAGE_ID`) REFERENCES `email_message` (`EMAIL_MESSAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_server`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_server` (
  `EMAIL_SERVER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SMTP_HOST` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SMTP_PORT` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SMTP_START_TLS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SMTP_SSL` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STORE_HOST` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STORE_PORT` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STORE_PROTOCOL` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STORE_FOLDER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STORE_DELETE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STORE_MARK_SEEN` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STORE_SKIP_SEEN` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MAIL_USERNAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MAIL_PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOWED_TO_DOMAINS` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`EMAIL_SERVER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_template`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_template` (
  `EMAIL_TEMPLATE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_SERVER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_ADDRESS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REPLY_TO_ADDRESSES` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BOUNCE_ADDRESS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CC_ADDRESSES` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BCC_ADDRESSES` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUBJECT` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BODY_SCREEN_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WEBAPP_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WEB_HOST_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEND_PARTIAL` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`EMAIL_TEMPLATE_ID`),
  KEY `IDXEmailTemplateEmailServer` (`EMAIL_SERVER_ID`),
  KEY `IDXEmailTemplateETypeEnumeration` (`EMAIL_TYPE_ENUM_ID`),
  CONSTRAINT `email_template_ibfk_1` FOREIGN KEY (`EMAIL_SERVER_ID`) REFERENCES `email_server` (`EMAIL_SERVER_ID`),
  CONSTRAINT `email_template_ibfk_2` FOREIGN KEY (`EMAIL_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_template_attachment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_template_attachment` (
  `EMAIL_TEMPLATE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FILE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ATTACHMENT_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SCREEN_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SCREEN_RENDER_MODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FOR_EACH_IN` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTACHMENT_CONDITION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`EMAIL_TEMPLATE_ID`,`FILE_NAME`),
  KEY `IDXEmailTemplateAttachmentEmailTemplate` (`EMAIL_TEMPLATE_ID`),
  CONSTRAINT `email_template_attachment_ibfk_1` FOREIGN KEY (`EMAIL_TEMPLATE_ID`) REFERENCES `email_template` (`EMAIL_TEMPLATE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entity_audit_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entity_audit_log` (
  `AUDIT_HISTORY_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CHANGED_ENTITY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGED_FIELD_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PK_PRIMARY_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PK_SECONDARY_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PK_REST_COMBINED_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OLD_VALUE_TEXT` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NEW_VALUE_TEXT` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGE_REASON` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGED_DATE` datetime(3) DEFAULT NULL,
  `CHANGED_BY_USER_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGED_IN_VISIT_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ARTIFACT_STACK` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`AUDIT_HISTORY_SEQ_ID`),
  KEY `ENTAUDLOG_FLD1PK` (`CHANGED_ENTITY_NAME`,`CHANGED_FIELD_NAME`,`PK_PRIMARY_VALUE`),
  KEY `ENTAUDLOG_ENTPKPR` (`CHANGED_ENTITY_NAME`,`PK_PRIMARY_VALUE`),
  KEY `ENTAUDLOG_PKPRIM` (`PK_PRIMARY_VALUE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entity_filter`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entity_filter` (
  `ENTITY_FILTER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENTITY_FILTER_SET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENTITY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FILTER_MAP` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMPARISON_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `JOIN_OR` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENTITY_FILTER_ID`),
  KEY `IDXEntityFilterEntityFilterSet` (`ENTITY_FILTER_SET_ID`),
  KEY `IDXEntityFilterComparisonOperatorEnumeration` (`COMPARISON_ENUM_ID`),
  CONSTRAINT `entity_filter_ibfk_1` FOREIGN KEY (`COMPARISON_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entity_filter_set`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entity_filter_set` (
  `ENTITY_FILTER_SET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `APPLY_COND` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOW_MISSING_ALIAS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENTITY_FILTER_SET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entity_sync`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entity_sync` (
  `ENTITY_SYNC_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_START_DATE` datetime(3) DEFAULT NULL,
  `LAST_SUCCESSFUL_SYNC_TIME` datetime(3) DEFAULT NULL,
  `SYNC_SPLIT_MILLIS` decimal(20,0) DEFAULT NULL,
  `RECORD_THRESHOLD` decimal(20,0) DEFAULT NULL,
  `DELAY_BUFFER_MILLIS` decimal(20,0) DEFAULT NULL,
  `TARGET_SERVER_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TARGET_USERNAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TARGET_PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TARGET_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `KEEP_REMOVE_INFO_HOURS` decimal(26,6) DEFAULT NULL,
  `FOR_PULL` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENTITY_SYNC_ID`),
  KEY `IDXEntitySyncESStatusItem` (`STATUS_ID`),
  CONSTRAINT `entity_sync_ibfk_1` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entity_sync_artifact`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entity_sync_artifact` (
  `ENTITY_SYNC_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ARTIFACT_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `APPL_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEPENDENTS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENTITY_SYNC_ID`,`ARTIFACT_GROUP_ID`),
  KEY `IDXEntitySyncArtifactEntitySync` (`ENTITY_SYNC_ID`),
  KEY `IDXEntitySyncArtifactArtifactGroup` (`ARTIFACT_GROUP_ID`),
  KEY `IDXEntitySyncArtifactESAApplEnumeration` (`APPL_ENUM_ID`),
  CONSTRAINT `entity_sync_artifact_ibfk_1` FOREIGN KEY (`ENTITY_SYNC_ID`) REFERENCES `entity_sync` (`ENTITY_SYNC_ID`),
  CONSTRAINT `entity_sync_artifact_ibfk_2` FOREIGN KEY (`APPL_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entity_sync_history`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entity_sync_history` (
  `ENTITY_SYNC_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `START_DATE` datetime(3) NOT NULL,
  `FINISH_DATE` datetime(3) DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXCLUSIVE_FROM_TIME` datetime(3) DEFAULT NULL,
  `INCLUSIVE_THRU_TIME` datetime(3) DEFAULT NULL,
  `RECORDS_STORED` decimal(20,0) DEFAULT NULL,
  `TO_REMOVE_DELETED` decimal(20,0) DEFAULT NULL,
  `TO_REMOVE_ALREADY_DELETED` decimal(20,0) DEFAULT NULL,
  `RUNNING_TIME_MILLIS` decimal(20,0) DEFAULT NULL,
  `ERROR_MESSAGE` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENTITY_SYNC_ID`,`START_DATE`),
  KEY `IDXEntitySyncHistoryEntitySync` (`ENTITY_SYNC_ID`),
  KEY `IDXEntitySyncHistoryESStatusItem` (`STATUS_ID`),
  CONSTRAINT `entity_sync_history_ibfk_1` FOREIGN KEY (`ENTITY_SYNC_ID`) REFERENCES `entity_sync` (`ENTITY_SYNC_ID`),
  CONSTRAINT `entity_sync_history_ibfk_2` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entity_sync_remove`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entity_sync_remove` (
  `ENTITY_SYNC_REMOVE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENTITY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRIMARY_KEY_REMOVED` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENTITY_SYNC_REMOVE_ID`,`ENTITY_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enum_group_member`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enum_group_member` (
  `ENUM_GROUP_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `MEMBER_INFO` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENUM_GROUP_ENUM_ID`,`ENUM_ID`),
  KEY `IDXEnumGroupMemberEGEnumeration` (`ENUM_GROUP_ENUM_ID`),
  KEY `IDXEnumGroupMemberEnumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enumeration`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enumeration` (
  `ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENUM_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENUM_CODE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OPTION_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OPTION_INDICATOR` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RELATED_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RELATED_ENUM_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_FLOW_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENUM_ID`),
  KEY `IDXEnumerationEnumerationType` (`ENUM_TYPE_ID`),
  KEY `IDXEnumerationStatusFlow` (`STATUS_FLOW_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enumeration_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enumeration_type` (
  `ENUM_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENUM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility` (
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PSEUDO_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OWNER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_SIZE` decimal(26,6) DEFAULT NULL,
  `FACILITY_SIZE_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OPENED_DATE` datetime(3) DEFAULT NULL,
  `CLOSED_DATE` datetime(3) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_POINT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COUNTY_GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATE_GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASSET_ALLOW_OTHER_OWNER` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASSET_ALLOW_ISSUE_OVER_QOH` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASSET_INVENTORY_LOC_REQUIRE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_DAYS_TO_SHIP` decimal(20,0) DEFAULT NULL,
  `EXTERNAL_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`),
  UNIQUE KEY `FACILITY_ID_PSEUDO` (`PSEUDO_ID`),
  KEY `IDXFacilityFTypeEnumeration` (`FACILITY_TYPE_ENUM_ID`),
  KEY `IDXFacilityParentF` (`PARENT_FACILITY_ID`),
  KEY `IDXFacilityFStatusItem` (`STATUS_ID`),
  KEY `IDXFacilityOwnerPar` (`OWNER_PARTY_ID`),
  KEY `IDXFacilityFSizeUom` (`FACILITY_SIZE_UOM_ID`),
  KEY `IDXFacilityGeo` (`GEO_ID`),
  KEY `IDXFacilityGeoPoint` (`GEO_POINT_ID`),
  KEY `IDXFacilityCountyGeo` (`COUNTY_GEO_ID`),
  KEY `IDXFacilityStateGeo` (`STATE_GEO_ID`),
  CONSTRAINT `facility_ibfk_1` FOREIGN KEY (`PARENT_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_box_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_box_type` (
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_BOX_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`SHIPMENT_BOX_TYPE_ID`),
  KEY `IDXFacilityBoxTypeFacility` (`FACILITY_ID`),
  KEY `IDXFacilityBoxTypeShipmentBT` (`SHIPMENT_BOX_TYPE_ID`),
  CONSTRAINT `facility_box_type_ibfk_1` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_certification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_certification` (
  `FACILITY_CERTIFICATION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CERTIFICATION_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` date DEFAULT NULL,
  `THRU_DATE` date DEFAULT NULL,
  `CONTACT_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUDITOR_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUDITOR_ORG_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUDIT_START_DATE` datetime(3) DEFAULT NULL,
  `AUDIT_END_DATE` datetime(3) DEFAULT NULL,
  `AUDIT_SCORE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CERT_REGISTRATION_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OTHER_CERT_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DOCUMENT_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_CERTIFICATION_ID`),
  KEY `IDXFacilityCertificationFacility` (`FACILITY_ID`),
  KEY `IDXFacilityCertificationFCTypeEnumer` (`CERTIFICATION_TYPE_ENUM_ID`),
  KEY `IDXFacilityCertificationContactParty` (`CONTACT_PARTY_ID`),
  KEY `IDXFacilityCertificationAuditorParty` (`AUDITOR_PARTY_ID`),
  KEY `IDXFacilityCertificationAuditorOrgParty` (`AUDITOR_ORG_PARTY_ID`),
  CONSTRAINT `facility_certification_ibfk_1` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_contact_mech` (
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_PURPOSE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `EXTENSION` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`CONTACT_MECH_ID`,`CONTACT_MECH_PURPOSE_ID`,`FROM_DATE`),
  KEY `IDXFacilityContactMechFacility` (`FACILITY_ID`),
  KEY `IDXFacilityContactMechCM` (`CONTACT_MECH_ID`),
  KEY `IDXFacilityContactMechContactMechPurpose` (`CONTACT_MECH_PURPOSE_ID`),
  CONSTRAINT `facility_contact_mech_ibfk_1` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_content`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_content` (
  `FACILITY_CONTENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_CONTENT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_CONTENT_ID`),
  KEY `IDXFacilityContentFacility` (`FACILITY_ID`),
  KEY `IDXFacilityContentFCTypeEnumeration` (`FACILITY_CONTENT_TYPE_ENUM_ID`),
  CONSTRAINT `facility_content_ibfk_1` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_group` (
  `FACILITY_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_GROUP_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_GROUP_ID`),
  KEY `IDXFacilityGroupParentFG` (`PARENT_GROUP_ID`),
  KEY `IDXFacilityGroupFGTypeEnumeration` (`FACILITY_GROUP_TYPE_ENUM_ID`),
  CONSTRAINT `facility_group_ibfk_1` FOREIGN KEY (`PARENT_GROUP_ID`) REFERENCES `facility_group` (`FACILITY_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_group_member`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_group_member` (
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`FACILITY_GROUP_ID`,`FROM_DATE`),
  KEY `IDXFacilityGroupMemberFacility` (`FACILITY_ID`),
  KEY `IDXFacilityGroupMemberFacilityGroup` (`FACILITY_GROUP_ID`),
  CONSTRAINT `facility_group_member_ibfk_1` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `facility_group_member_ibfk_2` FOREIGN KEY (`FACILITY_GROUP_ID`) REFERENCES `facility_group` (`FACILITY_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_group_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_group_party` (
  `FACILITY_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_GROUP_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `IDXFacilityGroupPartyFacilityGroup` (`FACILITY_GROUP_ID`),
  KEY `IDXFacilityGroupPartyP` (`PARTY_ID`),
  KEY `IDXFacilityGroupPartyRoleType` (`ROLE_TYPE_ID`),
  CONSTRAINT `facility_group_party_ibfk_1` FOREIGN KEY (`FACILITY_GROUP_ID`) REFERENCES `facility_group` (`FACILITY_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_location`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_location` (
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOCATION_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOCATION_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AREA_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AISLE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SECTION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LEVEL_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `POSITION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_POINT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CAPACITY` decimal(26,6) DEFAULT NULL,
  `CAPACITY_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`LOCATION_SEQ_ID`),
  KEY `IDXFacilityLocationFacility` (`FACILITY_ID`),
  KEY `IDXFacilityLocationFLTypeEnumer` (`LOCATION_TYPE_ENUM_ID`),
  KEY `IDXFacilityLocationGeoPoint` (`GEO_POINT_ID`),
  KEY `IDXFacilityLocationCapacityUom` (`CAPACITY_UOM_ID`),
  CONSTRAINT `facility_location_ibfk_1` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_location_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_location_type` (
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOCATION_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `AUTO_STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`LOCATION_TYPE_ENUM_ID`),
  KEY `IDXFacilityLocationTypeFacility` (`FACILITY_ID`),
  KEY `IDXFacilityLocationTypeFLTEnumeration` (`LOCATION_TYPE_ENUM_ID`),
  KEY `IDXFacilityLocationTypeAssetStatusItem` (`AUTO_STATUS_ID`),
  CONSTRAINT `facility_location_type_ibfk_1` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_note`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_note` (
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `NOTE_DATE` datetime(3) NOT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NOTE_TEXT` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`NOTE_DATE`),
  KEY `IDXFacilityNoteFacility` (`FACILITY_ID`),
  KEY `IDXFacilityNoteUserAccount` (`USER_ID`),
  CONSTRAINT `facility_note_ibfk_1` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_party` (
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`FROM_DATE`),
  KEY `IDXFacilityPartyFacili` (`FACILITY_ID`),
  KEY `IDXFacilityPartyP` (`PARTY_ID`),
  KEY `IDXFacilityPartyRoleType` (`ROLE_TYPE_ID`),
  CONSTRAINT `facility_party_ibfk_1` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `facility_printer`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility_printer` (
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRINTER_PURPOSE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `NETWORK_PRINTER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACILITY_ID`,`PRINTER_PURPOSE_ENUM_ID`),
  KEY `IDXFacilityPrinterFacility` (`FACILITY_ID`),
  KEY `IDXFacilityPrinterPrinterPurposeEnumeration` (`PRINTER_PURPOSE_ENUM_ID`),
  KEY `IDXFacilityPrinterNetworkP` (`NETWORK_PRINTER_ID`),
  CONSTRAINT `facility_printer_ibfk_1` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `foo`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `foo` (
  `FOO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FOO_TEXT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FOO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `form_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_config` (
  `FORM_CONFIG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FORM_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONFIG_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_CONFIG_ID`),
  KEY `IDXFormConfigFCTypeEnumeration` (`CONFIG_TYPE_ENUM_ID`),
  CONSTRAINT `form_config_ibfk_1` FOREIGN KEY (`CONFIG_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `form_config_field`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_config_field` (
  `FORM_CONFIG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `POSITION_INDEX` decimal(20,0) DEFAULT NULL,
  `POSITION_SEQUENCE` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_CONFIG_ID`,`FIELD_NAME`),
  KEY `IDXFormConfigFieldFormConfig` (`FORM_CONFIG_ID`),
  CONSTRAINT `form_config_field_ibfk_1` FOREIGN KEY (`FORM_CONFIG_ID`) REFERENCES `form_config` (`FORM_CONFIG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `form_config_user`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_config_user` (
  `FORM_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FORM_CONFIG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_LOCATION`,`USER_ID`),
  KEY `IDXFormConfigUserFormConfig` (`FORM_CONFIG_ID`),
  CONSTRAINT `form_config_user_ibfk_1` FOREIGN KEY (`FORM_CONFIG_ID`) REFERENCES `form_config` (`FORM_CONFIG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `form_config_user_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_config_user_group` (
  `FORM_CONFIG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_CONFIG_ID`,`USER_GROUP_ID`),
  KEY `IDXFormConfigUserGroupFormConfig` (`FORM_CONFIG_ID`),
  KEY `IDXFormConfigUserGroupUG` (`USER_GROUP_ID`),
  CONSTRAINT `form_config_user_group_ibfk_1` FOREIGN KEY (`FORM_CONFIG_ID`) REFERENCES `form_config` (`FORM_CONFIG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `form_config_user_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_config_user_type` (
  `FORM_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONFIG_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FORM_CONFIG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_LOCATION`,`USER_ID`,`CONFIG_TYPE_ENUM_ID`),
  KEY `IDXFormConfigUserTypeFCTypeEnumeration` (`CONFIG_TYPE_ENUM_ID`),
  KEY `IDXFormConfigUserTypeFormConfig` (`FORM_CONFIG_ID`),
  CONSTRAINT `form_config_user_type_ibfk_1` FOREIGN KEY (`CONFIG_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `form_config_user_type_ibfk_2` FOREIGN KEY (`FORM_CONFIG_ID`) REFERENCES `form_config` (`FORM_CONFIG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `form_list_find`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_list_find` (
  `FORM_LIST_FIND_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FORM_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_BY_FIELD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FORM_CONFIG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_LIST_FIND_ID`),
  KEY `IDXFormListFindFormConfig` (`FORM_CONFIG_ID`),
  CONSTRAINT `form_list_find_ibfk_1` FOREIGN KEY (`FORM_CONFIG_ID`) REFERENCES `form_config` (`FORM_CONFIG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `form_list_find_field`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_list_find_field` (
  `FORM_LIST_FIND_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIELD_OPERATOR` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIELD_NOT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIELD_IGNORE_CASE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIELD_FROM` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIELD_THRU` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIELD_PERIOD` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIELD_PER_OFFSET` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_LIST_FIND_ID`,`FIELD_NAME`),
  KEY `IDXFormListFindFieldFormListFin` (`FORM_LIST_FIND_ID`),
  CONSTRAINT `form_list_find_field_ibfk_1` FOREIGN KEY (`FORM_LIST_FIND_ID`) REFERENCES `form_list_find` (`FORM_LIST_FIND_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `form_list_find_user`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_list_find_user` (
  `FORM_LIST_FIND_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_LIST_FIND_ID`,`USER_ID`),
  KEY `IDXFormListFindUserFormListFind` (`FORM_LIST_FIND_ID`),
  CONSTRAINT `form_list_find_user_ibfk_1` FOREIGN KEY (`FORM_LIST_FIND_ID`) REFERENCES `form_list_find` (`FORM_LIST_FIND_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `form_list_find_user_default`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_list_find_user_default` (
  `SCREEN_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FORM_LIST_FIND_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SCREEN_LOCATION`,`USER_ID`),
  KEY `IDXFormListFindUserDefaultFormListFind` (`FORM_LIST_FIND_ID`),
  CONSTRAINT `form_list_find_user_default_ibfk_1` FOREIGN KEY (`FORM_LIST_FIND_ID`) REFERENCES `form_list_find` (`FORM_LIST_FIND_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `form_list_find_user_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_list_find_user_group` (
  `FORM_LIST_FIND_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_LIST_FIND_ID`,`USER_GROUP_ID`),
  KEY `IDXFormListFindUserGroupFormListFind` (`FORM_LIST_FIND_ID`),
  KEY `IDXFormListFindUserGroupUG` (`USER_GROUP_ID`),
  CONSTRAINT `form_list_find_user_group_ibfk_1` FOREIGN KEY (`FORM_LIST_FIND_ID`) REFERENCES `form_list_find` (`FORM_LIST_FIND_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `form_response`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_response` (
  `FORM_RESPONSE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FORM_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FORM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESPONSE_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_RESPONSE_ID`),
  KEY `IDXFormResponseDbForm` (`FORM_ID`),
  KEY `IDXFormResponseUserAccount` (`USER_ID`),
  CONSTRAINT `form_response_ibfk_1` FOREIGN KEY (`FORM_ID`) REFERENCES `db_form` (`FORM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `form_response_answer`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `form_response_answer` (
  `FORM_RESPONSE_ANSWER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FORM_RESPONSE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FORM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIELD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `VALUE_TEXT` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FORM_RESPONSE_ANSWER_ID`),
  KEY `IDXFormResponseAnswerFormResponse` (`FORM_RESPONSE_ID`),
  KEY `IDXFormResponseAnswerDbForm` (`FORM_ID`),
  CONSTRAINT `form_response_answer_ibfk_1` FOREIGN KEY (`FORM_RESPONSE_ID`) REFERENCES `form_response` (`FORM_RESPONSE_ID`),
  CONSTRAINT `form_response_answer_ibfk_2` FOREIGN KEY (`FORM_ID`) REFERENCES `db_form` (`FORM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `geo`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo` (
  `GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_NAME_LOCAL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_CODE_ALPHA2` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_CODE_ALPHA3` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_CODE_NUMERIC` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WELL_KNOWN_TEXT` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`GEO_ID`),
  KEY `IDXGeoGTypeEnumeration` (`GEO_TYPE_ENUM_ID`),
  CONSTRAINT `geo_ibfk_1` FOREIGN KEY (`GEO_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `geo_assoc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo_assoc` (
  `GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TO_GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_ASSOC_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`GEO_ID`,`TO_GEO_ID`),
  KEY `IDXGeoAssocMainGeo` (`GEO_ID`),
  KEY `IDXGeoAssocAssocGeo` (`TO_GEO_ID`),
  KEY `IDXGeoAssocGATypeEnumeration` (`GEO_ASSOC_TYPE_ENUM_ID`),
  CONSTRAINT `geo_assoc_ibfk_1` FOREIGN KEY (`GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `geo_assoc_ibfk_2` FOREIGN KEY (`TO_GEO_ID`) REFERENCES `geo` (`GEO_ID`),
  CONSTRAINT `geo_assoc_ibfk_3` FOREIGN KEY (`GEO_ASSOC_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `geo_point`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo_point` (
  `GEO_POINT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_POINT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DATA_SOURCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LATITUDE` decimal(32,12) DEFAULT NULL,
  `LONGITUDE` decimal(32,12) DEFAULT NULL,
  `ELEVATION` decimal(32,12) DEFAULT NULL,
  `ELEVATION_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INFORMATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`GEO_POINT_ID`),
  KEY `IDXGeoPointGPTypeEnumeration` (`GEO_POINT_TYPE_ENUM_ID`),
  KEY `IDXGeoPointDataSource` (`DATA_SOURCE_ID`),
  KEY `IDXGeoPointElevationUom` (`ELEVATION_UOM_ID`),
  CONSTRAINT `geo_point_ibfk_1` FOREIGN KEY (`GEO_POINT_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `geo_point_ibfk_2` FOREIGN KEY (`DATA_SOURCE_ID`) REFERENCES `data_source` (`DATA_SOURCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance_host`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instance_host` (
  `INSTANCE_HOST_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `HOST_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOST_PROTOCOL` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOST_ADDRESS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ADMIN_PORT` decimal(20,0) DEFAULT NULL,
  `USERNAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INSTANCE_HOST_ID`),
  KEY `IDXInstanceHostInstanceHostType` (`HOST_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance_host_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instance_host_type` (
  `HOST_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INIT_SERVICE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `START_SERVICE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STOP_SERVICE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REMOVE_SERVICE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHECK_SERVICE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`HOST_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance_image`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instance_image` (
  `INSTANCE_IMAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `IMAGE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOST_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IMAGE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REGISTRY_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USERNAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_ADDRESS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTH_TOKEN_CMD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INSTANCE_IMAGE_ID`),
  KEY `IDXInstanceImageInstanceImageType` (`IMAGE_TYPE_ID`),
  KEY `IDXInstanceImageInstanceHostType` (`HOST_TYPE_ID`),
  CONSTRAINT `instance_image_ibfk_1` FOREIGN KEY (`HOST_TYPE_ID`) REFERENCES `instance_host_type` (`HOST_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance_image_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instance_image_type` (
  `IMAGE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_INIT_COMMAND` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_NETWORK_MODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`IMAGE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance_image_type_env`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instance_image_type_env` (
  `IMAGE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENV_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENV_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`IMAGE_TYPE_ID`,`ENV_NAME`),
  KEY `IDXInstanceImageTypeEnvInstanceImageType` (`IMAGE_TYPE_ID`),
  CONSTRAINT `instance_image_type_env_ibfk_1` FOREIGN KEY (`IMAGE_TYPE_ID`) REFERENCES `instance_image_type` (`IMAGE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance_image_type_host_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instance_image_type_host_config` (
  `IMAGE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `HOST_CONFIG_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `HOST_CONFIG_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TYPE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`IMAGE_TYPE_ID`,`HOST_CONFIG_NAME`),
  KEY `IDXInstanceImageTypeHostConfigInstanceImageType` (`IMAGE_TYPE_ID`),
  CONSTRAINT `instance_image_type_host_config_ibfk_1` FOREIGN KEY (`IMAGE_TYPE_ID`) REFERENCES `instance_image_type` (`IMAGE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance_image_type_link`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instance_image_type_link` (
  `IMAGE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INSTANCE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ALIAS_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`IMAGE_TYPE_ID`,`INSTANCE_NAME`),
  KEY `IDXInstanceImageTypeLinkInstanceImageType` (`IMAGE_TYPE_ID`),
  CONSTRAINT `instance_image_type_link_ibfk_1` FOREIGN KEY (`IMAGE_TYPE_ID`) REFERENCES `instance_image_type` (`IMAGE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instance_image_type_volume`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `instance_image_type_volume` (
  `IMAGE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MOUNT_POINT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VOLUME_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`IMAGE_TYPE_ID`,`MOUNT_POINT`),
  KEY `IDXInstanceImageTypeVolumeInstanceImageTyp` (`IMAGE_TYPE_ID`),
  CONSTRAINT `instance_image_type_volume_ibfk_1` FOREIGN KEY (`IMAGE_TYPE_ID`) REFERENCES `instance_image_type` (`IMAGE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `INVOICE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BILLING_ACCOUNT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVOICE_DATE` datetime(3) DEFAULT NULL,
  `DUE_DATE` datetime(3) DEFAULT NULL,
  `PAID_DATE` datetime(3) DEFAULT NULL,
  `INVOICE_MESSAGE` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REFERENCE_NUMBER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OTHER_PARTY_ORDER_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OVERRIDE_ORG_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_RELATIONSHIP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCTG_TRANS_RESULT_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SYSTEM_MESSAGE_REMOTE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXTERNAL_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVOICE_TOTAL` decimal(24,4) DEFAULT NULL,
  `APPLIED_PAYMENTS_TOTAL` decimal(24,4) DEFAULT NULL,
  `UNPAID_TOTAL` decimal(24,4) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVOICE_ID`),
  KEY `INVOICE_EXTERNAL` (`EXTERNAL_ID`),
  KEY `INVOICE_ORIGIN` (`ORIGIN_ID`),
  KEY `IDXInvoiceITypeEnumeration` (`INVOICE_TYPE_ENUM_ID`),
  KEY `IDXInvoiceFromParty` (`FROM_PARTY_ID`),
  KEY `IDXInvoiceToParty` (`TO_PARTY_ID`),
  KEY `IDXInvoiceIStatusItem` (`STATUS_ID`),
  KEY `IDXInvoiceCurrencyUom` (`CURRENCY_UOM_ID`),
  KEY `IDXInvoiceOverrideOrgParty` (`OVERRIDE_ORG_PARTY_ID`),
  KEY `IDXInvoiceProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXInvoiceAcctgTransResultEnumeration` (`ACCTG_TRANS_RESULT_ENUM_ID`),
  KEY `IDXInvoiceSystemMessageRemote` (`SYSTEM_MESSAGE_REMOTE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice_contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_contact_mech` (
  `INVOICE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_PURPOSE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVOICE_ID`,`CONTACT_MECH_PURPOSE_ID`,`CONTACT_MECH_ID`),
  KEY `IDXInvoiceContactMechInvoice` (`INVOICE_ID`),
  KEY `IDXInvoiceContactMechContactMechPurpose` (`CONTACT_MECH_PURPOSE_ID`),
  KEY `IDXInvoiceContactMechCM` (`CONTACT_MECH_ID`),
  CONSTRAINT `invoice_contact_mech_ibfk_1` FOREIGN KEY (`INVOICE_ID`) REFERENCES `invoice` (`INVOICE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice_content`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_content` (
  `INVOICE_CONTENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_DATE` datetime(3) DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVOICE_CONTENT_ID`),
  KEY `IDXInvoiceContentInvoice` (`INVOICE_ID`),
  KEY `IDXInvoiceContentICTypeEnumeration` (`CONTENT_TYPE_ENUM_ID`),
  CONSTRAINT `invoice_content_ibfk_1` FOREIGN KEY (`INVOICE_ID`) REFERENCES `invoice` (`INVOICE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice_email_message`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_email_message` (
  `INVOICE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `EMAIL_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVOICE_ID`,`EMAIL_MESSAGE_ID`),
  KEY `IDXInvoiceEmailMessageInvoic` (`INVOICE_ID`),
  KEY `IDXInvoiceEmailMessageEM` (`EMAIL_MESSAGE_ID`),
  CONSTRAINT `invoice_email_message_ibfk_1` FOREIGN KEY (`INVOICE_ID`) REFERENCES `invoice` (`INVOICE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_item` (
  `INVOICE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ITEM_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OVERRIDE_GL_ACCOUNT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASSET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OTHER_PARTY_PRODUCT_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_INVOICE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_INVOICE_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TAXABLE_FLAG` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(26,6) DEFAULT NULL,
  `QUANTITY_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AMOUNT` decimal(25,5) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ITEM_DATE` datetime(3) DEFAULT NULL,
  `IS_ADJUSTMENT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BILL_THRU_VENDOR_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BILL_THRU_VENDOR_REF` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVOICE_ID`,`INVOICE_ITEM_SEQ_ID`),
  KEY `IDXInvoiceItemInvoice` (`INVOICE_ID`),
  KEY `IDXInvoiceItemItemTypeEnumeration` (`ITEM_TYPE_ENUM_ID`),
  KEY `IDXInvoiceItemAsset` (`ASSET_ID`),
  KEY `IDXInvoiceItemProduct` (`PRODUCT_ID`),
  KEY `IDXInvoiceItemOtherParentII` (`PARENT_INVOICE_ID`,`PARENT_INVOICE_ITEM_SEQ_ID`),
  KEY `IDXInvoiceItemQuantityUo` (`QUANTITY_UOM_ID`),
  CONSTRAINT `invoice_item_ibfk_1` FOREIGN KEY (`INVOICE_ID`) REFERENCES `invoice` (`INVOICE_ID`),
  CONSTRAINT `invoice_item_ibfk_2` FOREIGN KEY (`PARENT_INVOICE_ID`, `PARENT_INVOICE_ITEM_SEQ_ID`) REFERENCES `invoice_item` (`INVOICE_ID`, `INVOICE_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice_item_assoc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_item_assoc` (
  `INVOICE_ITEM_ASSOC_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVOICE_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_INVOICE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_INVOICE_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVOICE_ITEM_ASSOC_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `FROM_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(26,6) DEFAULT NULL,
  `AMOUNT` decimal(24,4) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVOICE_ITEM_ASSOC_ID`),
  KEY `IDXInvoiceItemAssocIIATypeEnumeration` (`INVOICE_ITEM_ASSOC_TYPE_ENUM_ID`),
  KEY `IDXInvoiceItemAssocInvoiceItem` (`INVOICE_ID`,`INVOICE_ITEM_SEQ_ID`),
  KEY `IDXInvoiceItemAssocToInvoiceItem` (`TO_INVOICE_ID`,`TO_INVOICE_ITEM_SEQ_ID`),
  KEY `IDXInvoiceItemAssocFromParty` (`FROM_PARTY_ID`),
  KEY `IDXInvoiceItemAssocToParty` (`TO_PARTY_ID`),
  CONSTRAINT `invoice_item_assoc_ibfk_1` FOREIGN KEY (`INVOICE_ID`, `INVOICE_ITEM_SEQ_ID`) REFERENCES `invoice_item` (`INVOICE_ID`, `INVOICE_ITEM_SEQ_ID`),
  CONSTRAINT `invoice_item_assoc_ibfk_2` FOREIGN KEY (`TO_INVOICE_ID`, `TO_INVOICE_ITEM_SEQ_ID`) REFERENCES `invoice_item` (`INVOICE_ID`, `INVOICE_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice_item_detail`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_item_detail` (
  `INVOICE_ITEM_DETAIL_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `INVOICE_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASSET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(26,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVOICE_ITEM_DETAIL_ID`),
  KEY `IDXInvoiceItemDetailInvoiceItem` (`INVOICE_ID`,`INVOICE_ITEM_SEQ_ID`),
  KEY `IDXInvoiceItemDetailFacility` (`FACILITY_ID`),
  KEY `IDXInvoiceItemDetailAsset` (`ASSET_ID`),
  KEY `IDXInvoiceItemDetailParty` (`PARTY_ID`),
  CONSTRAINT `invoice_item_detail_ibfk_1` FOREIGN KEY (`INVOICE_ID`, `INVOICE_ITEM_SEQ_ID`) REFERENCES `invoice_item` (`INVOICE_ID`, `INVOICE_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_party` (
  `INVOICE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVOICE_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `IDXInvoicePartyInvoice` (`INVOICE_ID`),
  KEY `IDXInvoicePartyP` (`PARTY_ID`),
  KEY `IDXInvoicePartyRoleType` (`ROLE_TYPE_ID`),
  CONSTRAINT `invoice_party_ibfk_1` FOREIGN KEY (`INVOICE_ID`) REFERENCES `invoice` (`INVOICE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice_system_message`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_system_message` (
  `INVOICE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SYSTEM_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `EXTERNAL_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INVOICE_ID`,`SYSTEM_MESSAGE_ID`),
  KEY `IDXInvoiceSystemMessageInvoic` (`INVOICE_ID`),
  KEY `IDXInvoiceSystemMessageSM` (`SYSTEM_MESSAGE_ID`),
  CONSTRAINT `invoice_system_message_ibfk_1` FOREIGN KEY (`INVOICE_ID`) REFERENCES `invoice` (`INVOICE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `localized_entity_field`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `localized_entity_field` (
  `ENTITY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FIELD_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PK_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOCALE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOCALIZED` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ENTITY_NAME`,`FIELD_NAME`,`PK_VALUE`,`LOCALE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `localized_message`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `localized_message` (
  `ORIGINAL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOCALE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOCALIZED` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORIGINAL`,`LOCALE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lot`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lot` (
  `LOT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MFG_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOT_NUMBER` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(26,6) DEFAULT NULL,
  `MANUFACTURED_DATE` datetime(3) DEFAULT NULL,
  `EXPIRATION_DATE` date DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`LOT_ID`),
  UNIQUE KEY `LOT_MFG_ID_LOT` (`MFG_PARTY_ID`,`LOT_NUMBER`),
  KEY `IDXLotMfgParty` (`MFG_PARTY_ID`),
  CONSTRAINT `lot_ibfk_1` FOREIGN KEY (`MFG_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `network_printer`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `network_printer` (
  `NETWORK_PRINTER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SERVER_HOST` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVER_PORT` decimal(20,0) DEFAULT NULL,
  `PRINTER_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASSET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`NETWORK_PRINTER_ID`),
  KEY `IDXNetworkPrinterAsset` (`ASSET_ID`),
  CONSTRAINT `network_printer_ibfk_1` FOREIGN KEY (`ASSET_ID`) REFERENCES `asset` (`ASSET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notification_message`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_message` (
  `NOTIFICATION_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TOPIC` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUB_TOPIC` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SENT_DATE` datetime(3) DEFAULT NULL,
  `MESSAGE_JSON` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `TITLE_TEXT` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LINK_TEXT` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TYPE_STRING` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHOW_ALERT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`NOTIFICATION_MESSAGE_ID`),
  KEY `IDXNotificationMessageUserGroup` (`USER_GROUP_ID`),
  CONSTRAINT `notification_message_ibfk_1` FOREIGN KEY (`USER_GROUP_ID`) REFERENCES `user_group` (`USER_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notification_message_user`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_message_user` (
  `NOTIFICATION_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SENT_DATE` datetime(3) DEFAULT NULL,
  `VIEWED_DATE` datetime(3) DEFAULT NULL,
  `EMAIL_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`NOTIFICATION_MESSAGE_ID`,`USER_ID`),
  KEY `NOTMSGUSR_UID_VD` (`USER_ID`,`VIEWED_DATE`),
  KEY `IDXNotificationMessageUserNotificationMessage` (`NOTIFICATION_MESSAGE_ID`),
  KEY `IDXNotificationMessageUserEmailMessage` (`EMAIL_MESSAGE_ID`),
  CONSTRAINT `notification_message_user_ibfk_1` FOREIGN KEY (`NOTIFICATION_MESSAGE_ID`) REFERENCES `notification_message` (`NOTIFICATION_MESSAGE_ID`),
  CONSTRAINT `notification_message_user_ibfk_2` FOREIGN KEY (`EMAIL_MESSAGE_ID`) REFERENCES `email_message` (`EMAIL_MESSAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notification_topic`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_topic` (
  `TOPIC` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TITLE_TEMPLATE` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ERROR_TITLE_TEMPLATE` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LINK_TEMPLATE` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TYPE_STRING` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHOW_ALERT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALERT_NO_AUTO_HIDE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PERSIST_ON_SEND` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_PRIVATE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECEIVE_NOTIFICATIONS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_NOTIFICATIONS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_TEMPLATE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_MESSAGE_SAVE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`TOPIC`),
  KEY `IDXNotificationTopicEmailTemplate` (`EMAIL_TEMPLATE_ID`),
  CONSTRAINT `notification_topic_ibfk_1` FOREIGN KEY (`EMAIL_TEMPLATE_ID`) REFERENCES `email_template` (`EMAIL_TEMPLATE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notification_topic_user`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_topic_user` (
  `TOPIC` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RECEIVE_NOTIFICATIONS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALL_NOTIFICATIONS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_NOTIFICATIONS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`TOPIC`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_communication_event`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_communication_event` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COMMUNICATION_EVENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`COMMUNICATION_EVENT_ID`),
  KEY `IDXOrderCommunicationEventOrderHeader` (`ORDER_ID`),
  KEY `IDXOrderCommunicationEventCE` (`COMMUNICATION_EVENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_content`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_content` (
  `ORDER_CONTENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_CONTENT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_DATE` datetime(3) DEFAULT NULL,
  `VIEWED_DATE` datetime(3) DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_CONTENT_ID`),
  KEY `IDXOrderContentOCTypeEnumeration` (`ORDER_CONTENT_TYPE_ENUM_ID`),
  KEY `IDXOrderContentOrderHeader` (`ORDER_ID`),
  KEY `IDXOrderContentParty` (`PARTY_ID`),
  KEY `IDXOrderContentRoleType` (`ROLE_TYPE_ID`),
  KEY `IDXOrderContentUserAccou` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_decision`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_decision` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DECISION_DATE` datetime(3) NOT NULL,
  `DECISION_BY_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVALIDATED_DATE` datetime(3) DEFAULT NULL,
  `APPROVED_AMOUNT` decimal(26,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`DECISION_DATE`),
  KEY `IDXOrderDecisionOrderHeader` (`ORDER_ID`),
  KEY `IDXOrderDecisionDecisionByParty` (`DECISION_BY_PARTY_ID`),
  KEY `IDXOrderDecisionOHeaderStatusItem` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_decision_reason`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_decision_reason` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DECISION_DATE` datetime(3) NOT NULL,
  `DECISION_REASON_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`DECISION_DATE`,`DECISION_REASON_ENUM_ID`),
  KEY `IDXOrderDecisionReasonOrderHeader` (`ORDER_ID`),
  KEY `IDXOrderDecisionReasonOrderDecisi` (`ORDER_ID`,`DECISION_DATE`),
  KEY `IDXOrderDecisionReasonODREnumerati` (`DECISION_REASON_ENUM_ID`),
  CONSTRAINT `order_decision_reason_ibfk_1` FOREIGN KEY (`ORDER_ID`, `DECISION_DATE`) REFERENCES `order_decision` (`ORDER_ID`, `DECISION_DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_email_message`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_email_message` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `EMAIL_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_REVISION` decimal(20,0) DEFAULT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`EMAIL_MESSAGE_ID`),
  KEY `IDXOrderEmailMessageOrderHeader` (`ORDER_ID`),
  KEY `IDXOrderEmailMessageEM` (`EMAIL_MESSAGE_ID`),
  KEY `IDXOrderEmailMessageParty` (`PARTY_ID`),
  KEY `IDXOrderEmailMessageRoleTyp` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_header`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_header` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENTRY_DATE` datetime(3) DEFAULT NULL,
  `PLACED_DATE` datetime(3) DEFAULT NULL,
  `APPROVED_DATE` datetime(3) DEFAULT NULL,
  `COMPLETED_DATE` datetime(3) DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PROCESSING_STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_REVISION` decimal(20,0) DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BILLING_ACCOUNT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SALES_CHANNEL_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TERMINAL_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DISPLAY_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXTERNAL_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXTERNAL_REVISION` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SYNC_STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SYSTEM_MESSAGE_REMOTE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VISIT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENTERED_BY_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECUR_CRON_EXPRESSION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_ORDERED_DATE` datetime(3) DEFAULT NULL,
  `RECUR_AUTO_INVOICE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REMAINING_SUB_TOTAL` decimal(24,4) DEFAULT NULL,
  `GRAND_TOTAL` decimal(24,4) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`),
  KEY `ORDERDISP_ID_IDX` (`DISPLAY_ID`),
  KEY `ORDEREXT_ID_IDX` (`EXTERNAL_ID`),
  KEY `ORDERORIG_ID_IDX` (`ORIGIN_ID`),
  KEY `IDXOrderHeaderOHStatusItem` (`STATUS_ID`),
  KEY `IDXOrderHeaderOProcessingStatusItem` (`PROCESSING_STATUS_ID`),
  KEY `IDXOrderHeaderCurrencyUom` (`CURRENCY_UOM_ID`),
  KEY `IDXOrderHeaderProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXOrderHeaderSalesChannelEnumeration` (`SALES_CHANNEL_ENUM_ID`),
  KEY `IDXOrderHeaderSyncStatusItem` (`SYNC_STATUS_ID`),
  KEY `IDXOrderHeaderSystemMessageRemote` (`SYSTEM_MESSAGE_REMOTE_ID`),
  KEY `IDXOrderHeaderVisit` (`VISIT_ID`),
  KEY `IDXOrderHeaderEnteredByParty` (`ENTERED_BY_PARTY_ID`),
  KEY `IDXOrderHeaderParentOH` (`PARENT_ORDER_ID`),
  CONSTRAINT `order_header_ibfk_1` FOREIGN KEY (`PARENT_ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_PART_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ITEM_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_FEATURE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OTHER_PARTY_PRODUCT_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PARAMETER_SET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ITEM_DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(26,6) DEFAULT NULL,
  `QUANTITY_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY_CANCELLED` decimal(26,6) DEFAULT NULL,
  `SELECTED_AMOUNT` decimal(26,6) DEFAULT NULL,
  `PRIORITY` decimal(20,0) DEFAULT NULL,
  `REQUIRED_BY_DATE` datetime(3) DEFAULT NULL,
  `UNIT_AMOUNT` decimal(25,5) DEFAULT NULL,
  `UNIT_LIST_PRICE` decimal(25,5) DEFAULT NULL,
  `IS_MODIFIED_PRICE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STANDARD_COST` decimal(25,5) DEFAULT NULL,
  `EXTERNAL_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_ASSET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PRICE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_CATEGORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_PROMO` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PROMO_QUANTITY` decimal(26,6) DEFAULT NULL,
  `PROMO_TIMES_USED` decimal(26,6) DEFAULT NULL,
  `PROMO_CODE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PROMO_CODE_TEXT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OVERRIDE_GL_ACCOUNT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SOURCE_REFERENCE_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SOURCE_PERCENTAGE` decimal(26,6) DEFAULT NULL,
  `AMOUNT_ALREADY_INCLUDED` decimal(25,5) DEFAULT NULL,
  `EXEMPT_AMOUNT` decimal(24,4) DEFAULT NULL,
  `CUSTOMER_REFERENCE_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `ORDITMEXT_ID_IDX` (`EXTERNAL_ITEM_SEQ_ID`),
  KEY `IDXOrderItemOrderHeader` (`ORDER_ID`),
  KEY `IDXOrderItemItemTypeEnumeration` (`ITEM_TYPE_ENUM_ID`),
  KEY `IDXOrderItemOrderPart` (`ORDER_ID`,`ORDER_PART_SEQ_ID`),
  KEY `IDXOrderItemProduct` (`PRODUCT_ID`),
  KEY `IDXOrderItemProductFeature` (`PRODUCT_FEATURE_ID`),
  KEY `IDXOrderItemProductParameterSet` (`PRODUCT_PARAMETER_SET_ID`),
  KEY `IDXOrderItemQuantityUo` (`QUANTITY_UOM_ID`),
  KEY `IDXOrderItemFromAsset` (`FROM_ASSET_ID`),
  KEY `IDXOrderItemProductPrice` (`PRODUCT_PRICE_ID`),
  KEY `IDXOrderItemProductCategory` (`PRODUCT_CATEGORY_ID`),
  KEY `IDXOrderItemProductStorePromoCode` (`PROMO_CODE_ID`),
  CONSTRAINT `order_item_ibfk_1` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_form_response`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_form_response` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FORM_RESPONSE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`,`FORM_RESPONSE_ID`),
  KEY `IDXOrderItemFormResponseOrderItem` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `IDXOrderItemFormResponseFR` (`FORM_RESPONSE_ID`),
  KEY `IDXOrderItemFormResponseParty` (`PARTY_ID`),
  KEY `IDXOrderItemFormResponseRoleTyp` (`ROLE_TYPE_ID`),
  CONSTRAINT `order_item_form_response_ibfk_1` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_item_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_party` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `IDXOrderItemPartyOrderItem` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `IDXOrderItemPartyP` (`PARTY_ID`),
  KEY `IDXOrderItemPartyRoleType` (`ROLE_TYPE_ID`),
  CONSTRAINT `order_item_party_ibfk_1` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_note`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_note` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `NOTE_DATE` datetime(3) NOT NULL,
  `NOTE_TEXT` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INTERNAL_NOTE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`NOTE_DATE`),
  KEY `IDXOrderNoteOrderHeader` (`ORDER_ID`),
  KEY `IDXOrderNoteUserAccount` (`USER_ID`),
  CONSTRAINT `order_note_ibfk_1` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_part`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_part` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_PART_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_PART_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PART_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VENDOR_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOMER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OTHER_PARTY_ORDER_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OTHER_PARTY_ORDER_DATE` datetime(3) DEFAULT NULL,
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_METHOD_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRADE_TERM_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `POSTAL_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TELECOM_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRACKING_NUMBER` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPPING_INSTRUCTIONS` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MAY_SPLIT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SIGNATURE_REQUIRED_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GIFT_MESSAGE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_GIFT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_NEW_CUSTOMER` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PART_TOTAL` decimal(24,4) DEFAULT NULL,
  `PRIORITY` decimal(20,0) DEFAULT NULL,
  `SHIP_AFTER_DATE` datetime(3) DEFAULT NULL,
  `SHIP_BEFORE_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_SHIP_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_DELIVERY_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_PICK_UP_DATE` datetime(3) DEFAULT NULL,
  `VALID_FROM_DATE` datetime(3) DEFAULT NULL,
  `VALID_THRU_DATE` datetime(3) DEFAULT NULL,
  `AUTO_CANCEL_DATE` datetime(3) DEFAULT NULL,
  `DONT_CANCEL_SET_DATE` datetime(3) DEFAULT NULL,
  `DONT_CANCEL_SET_USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DISABLE_PROMOTIONS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DISABLE_SHIPPING_CALC` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DISABLE_TAX_CALC` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESERVATION_AUTO_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_PART_SEQ_ID`),
  KEY `ORDPTOPTY_ID_IDX` (`OTHER_PARTY_ORDER_ID`),
  KEY `IDXOrderPartOrderHeader` (`ORDER_ID`),
  KEY `IDXOrderPartParentOP` (`ORDER_ID`,`PARENT_PART_SEQ_ID`),
  KEY `IDXOrderPartOHeaderStatusItem` (`STATUS_ID`),
  KEY `IDXOrderPartVendorParty` (`VENDOR_PARTY_ID`),
  KEY `IDXOrderPartCustomerParty` (`CUSTOMER_PARTY_ID`),
  KEY `IDXOrderPartFacility` (`FACILITY_ID`),
  KEY `IDXOrderPartCarrierParty` (`CARRIER_PARTY_ID`),
  KEY `IDXOrderPartShipmentMethodEnumeration` (`SHIPMENT_METHOD_ENUM_ID`),
  KEY `IDXOrderPartTermTypeEnumeration` (`TRADE_TERM_ENUM_ID`),
  KEY `IDXOrderPartPostalContactMech` (`POSTAL_CONTACT_MECH_ID`),
  KEY `IDXOrderPartPostalAddress` (`POSTAL_CONTACT_MECH_ID`),
  KEY `IDXOrderPartTelecomContactMech` (`TELECOM_CONTACT_MECH_ID`),
  KEY `IDXOrderPartTelecomNumber` (`TELECOM_CONTACT_MECH_ID`),
  KEY `IDXOrderPartSignatureRequiredEnumeration` (`SIGNATURE_REQUIRED_ENUM_ID`),
  KEY `IDXOrderPartAssetReservationAutoEnumeration` (`RESERVATION_AUTO_ENUM_ID`),
  CONSTRAINT `order_part_ibfk_1` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `order_part_ibfk_2` FOREIGN KEY (`ORDER_ID`, `PARENT_PART_SEQ_ID`) REFERENCES `order_part` (`ORDER_ID`, `ORDER_PART_SEQ_ID`),
  CONSTRAINT `order_part_ibfk_3` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_part_contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_part_contact_mech` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_PART_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_PURPOSE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_PART_SEQ_ID`,`CONTACT_MECH_PURPOSE_ID`,`CONTACT_MECH_ID`),
  KEY `IDXOrderPartContactMechOrderPart` (`ORDER_ID`,`ORDER_PART_SEQ_ID`),
  KEY `IDXOrderPartContactMechContactMechPurpose` (`CONTACT_MECH_PURPOSE_ID`),
  KEY `IDXOrderPartContactMechCM` (`CONTACT_MECH_ID`),
  CONSTRAINT `order_part_contact_mech_ibfk_1` FOREIGN KEY (`ORDER_ID`, `ORDER_PART_SEQ_ID`) REFERENCES `order_part` (`ORDER_ID`, `ORDER_PART_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_part_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_part_party` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORDER_PART_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`ORDER_PART_SEQ_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `IDXOrderPartPartyOrderPart` (`ORDER_ID`,`ORDER_PART_SEQ_ID`),
  KEY `IDXOrderPartPartyP` (`PARTY_ID`),
  KEY `IDXOrderPartPartyRoleType` (`ROLE_TYPE_ID`),
  CONSTRAINT `order_part_party_ibfk_1` FOREIGN KEY (`ORDER_ID`, `ORDER_PART_SEQ_ID`) REFERENCES `order_part` (`ORDER_ID`, `ORDER_PART_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_promo_code`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_promo_code` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PROMO_CODE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`PROMO_CODE_ID`),
  KEY `IDXOrderPromoCodeOrderHeader` (`ORDER_ID`),
  KEY `IDXOrderPromoCodeProductStorePromoCode` (`PROMO_CODE_ID`),
  CONSTRAINT `order_promo_code_ibfk_1` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_service_job_run`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_service_job_run` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `JOB_RUN_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`JOB_RUN_ID`),
  KEY `IDXOrderServiceJobRunOrderHeader` (`ORDER_ID`),
  KEY `IDXOrderServiceJobRunSJR` (`JOB_RUN_ID`),
  CONSTRAINT `order_service_job_run_ibfk_1` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_system_message`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_system_message` (
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SYSTEM_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `EXTERNAL_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DISPLAY_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ORDER_ID`,`SYSTEM_MESSAGE_ID`),
  KEY `IDXOrderSystemMessageOrderHeader` (`ORDER_ID`),
  KEY `IDXOrderSystemMessageSM` (`SYSTEM_MESSAGE_ID`),
  CONSTRAINT `order_system_message_ibfk_1` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organization` (
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ORGANIZATION_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OFFICE_SITE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ANNUAL_REVENUE` decimal(24,4) DEFAULT NULL,
  `NUM_EMPLOYEES` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`),
  KEY `PTY_ORG_NAME_IDX` (`ORGANIZATION_NAME`),
  KEY `IDXOrganizationParty` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party` (
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PSEUDO_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DISABLED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOMER_STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OWNER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXTERNAL_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DATA_SOURCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GATEWAY_CIM_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPPING_INSTRUCTIONS` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_DUPLICATES` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_DUP_CHECK_DATE` datetime(3) DEFAULT NULL,
  `MERGED_TO_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`),
  UNIQUE KEY `PARTY_ID_PSEUDO` (`PSEUDO_ID`,`OWNER_PARTY_ID`),
  KEY `PARTY_ID_EXT` (`EXTERNAL_ID`),
  KEY `PARTY_ID_MERGETO` (`MERGED_TO_PARTY_ID`),
  KEY `IDXPartyPTypeEnumeration` (`PARTY_TYPE_ENUM_ID`),
  KEY `IDXPartyCustomerStatusStatusItem` (`CUSTOMER_STATUS_ID`),
  KEY `IDXPartyOwnerP` (`OWNER_PARTY_ID`),
  KEY `IDXPartyDataSource` (`DATA_SOURCE_ID`),
  CONSTRAINT `party_ibfk_1` FOREIGN KEY (`OWNER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_carrier_account`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_carrier_account` (
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CARRIER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `ACCOUNT_NUMBER` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`CARRIER_PARTY_ID`,`FROM_DATE`),
  KEY `IDXPartyCarrierAccountParty` (`PARTY_ID`),
  KEY `IDXPartyCarrierAccountCarrierParty` (`CARRIER_PARTY_ID`),
  CONSTRAINT `party_carrier_account_ibfk_1` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `party_carrier_account_ibfk_2` FOREIGN KEY (`CARRIER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_classification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_classification` (
  `PARTY_CLASSIFICATION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CLASSIFICATION_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_CLASSIFICATION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STANDARD_CODE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_CLASSIFICATION_ID`),
  KEY `IDXPartyClassificationPCTypeEnumer` (`CLASSIFICATION_TYPE_ENUM_ID`),
  KEY `IDXPartyClassificationPentPC` (`PARENT_CLASSIFICATION_ID`),
  CONSTRAINT `party_classification_ibfk_1` FOREIGN KEY (`PARENT_CLASSIFICATION_ID`) REFERENCES `party_classification` (`PARTY_CLASSIFICATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_classification_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_classification_appl` (
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_CLASSIFICATION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`PARTY_CLASSIFICATION_ID`,`FROM_DATE`),
  KEY `IDXPartyClassificationApplParty` (`PARTY_ID`),
  KEY `IDXPartyClassificationApplPartyClassification` (`PARTY_CLASSIFICATION_ID`),
  CONSTRAINT `party_classification_appl_ibfk_1` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `party_classification_appl_ibfk_2` FOREIGN KEY (`PARTY_CLASSIFICATION_ID`) REFERENCES `party_classification` (`PARTY_CLASSIFICATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_contact_mech` (
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_PURPOSE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `EXTENSION` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOW_SOLICITATION` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USED_SINCE` date DEFAULT NULL,
  `USED_UNTIL` date DEFAULT NULL,
  `VERIFY_CODE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VERIFY_CODE_DATE` datetime(3) DEFAULT NULL,
  `VERIFY_CODE_ATTEMPTS` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`CONTACT_MECH_ID`,`CONTACT_MECH_PURPOSE_ID`,`FROM_DATE`),
  KEY `IDXPartyContactMechParty` (`PARTY_ID`),
  KEY `IDXPartyContactMechCM` (`CONTACT_MECH_ID`),
  KEY `IDXPartyContactMechContactMechPurpose` (`CONTACT_MECH_PURPOSE_ID`),
  CONSTRAINT `party_contact_mech_ibfk_1` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `party_contact_mech_ibfk_2` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `party_contact_mech_ibfk_3` FOREIGN KEY (`CONTACT_MECH_PURPOSE_ID`) REFERENCES `contact_mech_purpose` (`CONTACT_MECH_PURPOSE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_content`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_content` (
  `PARTY_CONTENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_CONTENT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_DATE` datetime(3) DEFAULT NULL,
  `VIEWED_DATE` datetime(3) DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGINAL_PARTY_CONTENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_CONTENT_ID`),
  KEY `IDXPartyContentParty` (`PARTY_ID`),
  KEY `IDXPartyContentPCTypeEnumeration` (`PARTY_CONTENT_TYPE_ENUM_ID`),
  KEY `IDXPartyContentPIdTypeEnumeration` (`PARTY_ID_TYPE_ENUM_ID`),
  KEY `IDXPartyContentOriginalPC` (`ORIGINAL_PARTY_CONTENT_ID`),
  CONSTRAINT `party_content_ibfk_1` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `party_content_ibfk_2` FOREIGN KEY (`ORIGINAL_PARTY_CONTENT_ID`) REFERENCES `party_content` (`PARTY_CONTENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_dimension`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_dimension` (
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `UOM_DIMENSION_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DIMENSION_DATE` datetime(3) NOT NULL,
  `VALUE` decimal(26,6) DEFAULT NULL,
  `UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`UOM_DIMENSION_TYPE_ID`,`DIMENSION_DATE`),
  KEY `IDXPartyDimensionParty` (`PARTY_ID`),
  KEY `IDXPartyDimensionUomDimensionType` (`UOM_DIMENSION_TYPE_ID`),
  KEY `IDXPartyDimensionUom` (`UOM_ID`),
  CONSTRAINT `party_dimension_ibfk_1` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_geo_point`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_geo_point` (
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_POINT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`GEO_POINT_ID`,`FROM_DATE`),
  KEY `IDXPartyGeoPointParty` (`PARTY_ID`),
  KEY `IDXPartyGeoPointGP` (`GEO_POINT_ID`),
  CONSTRAINT `party_geo_point_ibfk_1` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_identification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_identification` (
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ID_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ISSUED_BY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ISSUED_BY_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXPIRE_DATE` date DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`PARTY_ID_TYPE_ENUM_ID`),
  KEY `PARTY_ID_VALUE` (`ID_VALUE`),
  KEY `IDXPartyIdentificationPITypeEnumer` (`PARTY_ID_TYPE_ENUM_ID`),
  KEY `IDXPartyIdentificationParty` (`PARTY_ID`),
  KEY `IDXPartyIdentificationIssuedByParty` (`ISSUED_BY_PARTY_ID`),
  CONSTRAINT `party_identification_ibfk_1` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `party_identification_ibfk_2` FOREIGN KEY (`ISSUED_BY_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_note`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_note` (
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `NOTE_DATE` datetime(3) NOT NULL,
  `NOTE_TEXT` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INTERNAL_NOTE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`NOTE_DATE`),
  KEY `IDXPartyNoteParty` (`PARTY_ID`),
  KEY `IDXPartyNoteUserAccount` (`USER_ID`),
  CONSTRAINT `party_note_ibfk_1` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_relationship`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_relationship` (
  `PARTY_RELATIONSHIP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RELATIONSHIP_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RELATIONSHIP_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_RELATIONSHIP_ID`),
  KEY `IDXPartyRelationshipPRTypeEnumeration` (`RELATIONSHIP_TYPE_ENUM_ID`),
  KEY `IDXPartyRelationshipFromParty` (`FROM_PARTY_ID`),
  KEY `IDXPartyRelationshipFromRoleType` (`FROM_ROLE_TYPE_ID`),
  KEY `IDXPartyRelationshipToParty` (`TO_PARTY_ID`),
  KEY `IDXPartyRelationshipToRoleType` (`TO_ROLE_TYPE_ID`),
  KEY `IDXPartyRelationshipPRStatusItem` (`STATUS_ID`),
  CONSTRAINT `party_relationship_ibfk_1` FOREIGN KEY (`FROM_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `party_relationship_ibfk_2` FOREIGN KEY (`TO_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_relationship_setting`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_relationship_setting` (
  `PARTY_RELATIONSHIP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_SETTING_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SETTING_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_RELATIONSHIP_ID`,`PARTY_SETTING_TYPE_ID`),
  KEY `IDXPartyRelationshipSettingPartyRelationship` (`PARTY_RELATIONSHIP_ID`),
  KEY `IDXPartyRelationshipSettingPartySettingType` (`PARTY_SETTING_TYPE_ID`),
  CONSTRAINT `party_relationship_setting_ibfk_1` FOREIGN KEY (`PARTY_RELATIONSHIP_ID`) REFERENCES `party_relationship` (`PARTY_RELATIONSHIP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_role` (
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `IDXPartyRoleParty` (`PARTY_ID`),
  KEY `IDXPartyRoleRoleTyp` (`ROLE_TYPE_ID`),
  CONSTRAINT `party_role_ibfk_1` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_setting`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_setting` (
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_SETTING_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SETTING_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`PARTY_SETTING_TYPE_ID`),
  KEY `IDXPartySettingParty` (`PARTY_ID`),
  KEY `IDXPartySettingPartySettingType` (`PARTY_SETTING_TYPE_ID`),
  CONSTRAINT `party_setting_ibfk_1` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_setting_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_setting_type` (
  `PARTY_SETTING_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VALID_REGEXP` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENUM_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_SETTING_TYPE_ID`),
  KEY `IDXPartySettingTypeEnumerationT` (`ENUM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_setting_type_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_setting_type_role` (
  `PARTY_SETTING_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_SETTING_TYPE_ID`,`ROLE_TYPE_ID`),
  KEY `IDXPartySettingTypeRolePartySettingTyp` (`PARTY_SETTING_TYPE_ID`),
  KEY `IDXPartySettingTypeRoleRoleTyp` (`ROLE_TYPE_ID`),
  CONSTRAINT `party_setting_type_role_ibfk_1` FOREIGN KEY (`PARTY_SETTING_TYPE_ID`) REFERENCES `party_setting_type` (`PARTY_SETTING_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `party_system_message`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `party_system_message` (
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SYSTEM_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`,`SYSTEM_MESSAGE_ID`),
  KEY `IDXPartySystemMessageParty` (`PARTY_ID`),
  KEY `IDXPartySystemMessageSM` (`SYSTEM_MESSAGE_ID`),
  KEY `IDXPartySystemMessagePIdTypeEnumeration` (`PARTY_ID_TYPE_ENUM_ID`),
  CONSTRAINT `party_system_message_ibfk_1` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `person`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person` (
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SALUTATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FIRST_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MIDDLE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PERSONAL_TITLE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUFFIX` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NICKNAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GENDER` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BIRTH_DATE` date DEFAULT NULL,
  `DECEASED_DATE` date DEFAULT NULL,
  `HEIGHT` decimal(32,12) DEFAULT NULL,
  `WEIGHT` decimal(32,12) DEFAULT NULL,
  `MOTHERS_MAIDEN_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MARITAL_STATUS_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMPLOYMENT_STATUS_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESIDENCE_STATUS_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OCCUPATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PARTY_ID`),
  KEY `FIRST_NAME_IDX` (`FIRST_NAME`),
  KEY `LAST_NAME_IDX` (`LAST_NAME`),
  KEY `IDXPersonParty` (`PARTY_ID`),
  KEY `IDXPersonMaritalStatusEnumeration` (`MARITAL_STATUS_ENUM_ID`),
  KEY `IDXPersonEmploymentStatusEnumeration` (`EMPLOYMENT_STATUS_ENUM_ID`),
  KEY `IDXPersonResidenceStatusEnumeration` (`RESIDENCE_STATUS_ENUM_ID`),
  CONSTRAINT `person_ibfk_1` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `physical_inventory`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `physical_inventory` (
  `PHYSICAL_INVENTORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PHYSICAL_INVENTORY_DATE` datetime(3) DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PHYSICAL_INVENTORY_ID`),
  KEY `IDXPhysicalInventoryPart` (`PARTY_ID`),
  KEY `IDXphysicalInventoryStatusId` (`STATUS_ID`),
  KEY `IDXPhysicalInventoryFacilit` (`FACILITY_ID`),
  CONSTRAINT `physical_inventory_ibfk_1` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `physical_inventory_ibfk_2` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `physical_inventory_count`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `physical_inventory_count` (
  `PHYSICAL_INVENTORY_COUNT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PHYSICAL_INVENTORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOCATION_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COUNT_DATE` datetime(3) DEFAULT NULL,
  `QUANTITY_ON_HAND` decimal(26,6) DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PHYSICAL_INVENTORY_COUNT_ID`),
  KEY `IDXPhysicalInventoryCountPhysicalInventory` (`PHYSICAL_INVENTORY_ID`),
  KEY `IDXPhysicalInventoryCountFacility` (`FACILITY_ID`),
  KEY `IDXPhysicalInventoryCountProduc` (`PRODUCT_ID`),
  KEY `IDXPhysicalInventoryCountLo` (`LOT_ID`),
  CONSTRAINT `physical_inventory_count_ibfk_1` FOREIGN KEY (`PHYSICAL_INVENTORY_ID`) REFERENCES `physical_inventory` (`PHYSICAL_INVENTORY_ID`),
  CONSTRAINT `physical_inventory_count_ibfk_2` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `physical_inventory_count_ibfk_3` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `physical_inventory_count_ibfk_4` FOREIGN KEY (`LOT_ID`) REFERENCES `lot` (`LOT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `postal_address`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `postal_address` (
  `CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TO_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ATTN_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ADDRESS1` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ADDRESS2` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `UNIT_NUMBER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DIRECTIONS` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CITY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CITY_GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SCHOOL_DISTRICT_GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COUNTY_GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATE_PROVINCE_GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COUNTRY_GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `POSTAL_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `POSTAL_CODE_EXT` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `POSTAL_CODE_GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GEO_POINT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMERCIAL` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACCESS_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TELECOM_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIP_GATEWAY_ADDRESS_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_ID`),
  KEY `CITY_IDX` (`CITY`),
  KEY `POSTAL_CODE_IDX` (`POSTAL_CODE`),
  KEY `IDXPostalAddressContactMech` (`CONTACT_MECH_ID`),
  KEY `IDXPostalAddressCityGeo` (`CITY_GEO_ID`),
  KEY `IDXPostalAddressSchoolDistrictGeo` (`SCHOOL_DISTRICT_GEO_ID`),
  KEY `IDXPostalAddressCountyGeo` (`COUNTY_GEO_ID`),
  KEY `IDXPostalAddressStateProvinceGeo` (`STATE_PROVINCE_GEO_ID`),
  KEY `IDXPostalAddressCountryGeo` (`COUNTRY_GEO_ID`),
  KEY `IDXPostalAddressPCodeGeo` (`POSTAL_CODE_GEO_ID`),
  KEY `IDXPostalAddressGeoPoint` (`GEO_POINT_ID`),
  KEY `IDXPostalAddressTelecomTelecomNumber` (`TELECOM_CONTACT_MECH_ID`),
  KEY `IDXPostalAddressEmailContactMech` (`EMAIL_CONTACT_MECH_ID`),
  CONSTRAINT `postal_address_ibfk_1` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`),
  CONSTRAINT `postal_address_ibfk_2` FOREIGN KEY (`EMAIL_CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `print_job`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `print_job` (
  `PRINT_JOB_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `ERROR_MESSAGE` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NETWORK_PRINTER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USERNAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `JOB_ID` decimal(20,0) DEFAULT NULL,
  `JOB_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COPIES` decimal(20,0) DEFAULT NULL,
  `DUPLEX` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PAGE_RANGES` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_TYPE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DOCUMENT` longblob,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRINT_JOB_ID`),
  KEY `IDXPrintJobNetworkPrinter` (`NETWORK_PRINTER_ID`),
  KEY `IDXPrintJobPJStatusItem` (`STATUS_ID`),
  CONSTRAINT `print_job_ibfk_1` FOREIGN KEY (`NETWORK_PRINTER_ID`) REFERENCES `network_printer` (`NETWORK_PRINTER_ID`),
  CONSTRAINT `print_job_ibfk_2` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PSEUDO_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_CLASS_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASSET_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASSET_CLASS_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OWNER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SALES_INTRODUCTION_DATE` datetime(3) DEFAULT NULL,
  `SALES_DISCONTINUATION_DATE` datetime(3) DEFAULT NULL,
  `SALES_DISC_WHEN_NOT_AVAIL` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUPPORT_DISCONTINUATION_DATE` datetime(3) DEFAULT NULL,
  `REQUIRE_INVENTORY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHARGE_SHIPPING` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SIGNATURE_REQUIRED_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPPING_INSURANCE_REQD` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IN_SHIPPING_BOX` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_SHIPMENT_BOX_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TAXABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TAX_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURNABLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AMOUNT_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AMOUNT_FIXED` decimal(26,6) DEFAULT NULL,
  `AMOUNT_REQUIRE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`),
  UNIQUE KEY `PRODUCT_ID_PSEUDO` (`PSEUDO_ID`,`OWNER_PARTY_ID`),
  KEY `IDXProductPTypeEnumeration` (`PRODUCT_TYPE_ENUM_ID`),
  KEY `IDXProductPClassEnumeration` (`PRODUCT_CLASS_ENUM_ID`),
  KEY `IDXProductAssetTypeEnumeration` (`ASSET_TYPE_ENUM_ID`),
  KEY `IDXProductAssetClassEnumeration` (`ASSET_CLASS_ENUM_ID`),
  KEY `IDXProductPStatusItem` (`STATUS_ID`),
  KEY `IDXProductOwnerParty` (`OWNER_PARTY_ID`),
  KEY `IDXProductOriginGeo` (`ORIGIN_GEO_ID`),
  KEY `IDXProductSignatureRequiredEnumeration` (`SIGNATURE_REQUIRED_ENUM_ID`),
  KEY `IDXProductDefaultShipmentBoxType` (`DEFAULT_SHIPMENT_BOX_TYPE_ID`),
  KEY `IDXProductAmountUom` (`AMOUNT_UOM_ID`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`OWNER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_assoc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_assoc` (
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TO_PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ASSOC_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `REASON` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(26,6) DEFAULT NULL,
  `SCRAP_FACTOR` decimal(26,6) DEFAULT NULL,
  `INSTRUCTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`TO_PRODUCT_ID`,`PRODUCT_ASSOC_TYPE_ENUM_ID`,`FROM_DATE`),
  KEY `IDXProductAssocPATypeEnumeration` (`PRODUCT_ASSOC_TYPE_ENUM_ID`),
  KEY `IDXProductAssocProduct` (`PRODUCT_ID`),
  KEY `IDXProductAssocToProduct` (`TO_PRODUCT_ID`),
  CONSTRAINT `product_assoc_ibfk_1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `product_assoc_ibfk_2` FOREIGN KEY (`TO_PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_calculated_info`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_calculated_info` (
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TOTAL_QUANTITY_ORDERED` decimal(26,6) DEFAULT NULL,
  `TOTAL_TIMES_VIEWED` decimal(20,0) DEFAULT NULL,
  `AVERAGE_CUSTOMER_RATING` decimal(26,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`),
  KEY `IDXProductCalculatedInfoProduct` (`PRODUCT_ID`),
  CONSTRAINT `product_calculated_info_ibfk_1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category` (
  `PRODUCT_CATEGORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PSEUDO_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_CATEGORY_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CATEGORY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `OWNER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`),
  UNIQUE KEY `CATEGORY_ID_PSEUDO` (`PSEUDO_ID`,`OWNER_PARTY_ID`),
  KEY `IDXProductCategoryPCTypeEnumeration` (`PRODUCT_CATEGORY_TYPE_ENUM_ID`),
  KEY `IDXProductCategoryOwnerPart` (`OWNER_PARTY_ID`),
  CONSTRAINT `product_category_ibfk_1` FOREIGN KEY (`OWNER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_content`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_content` (
  `PRODUCT_CATEGORY_CONTENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_CATEGORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CATEGORY_CONTENT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LOCALE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_CONTENT_ID`),
  KEY `PRDCAT_CNT_CTTP` (`PRODUCT_CATEGORY_ID`,`CATEGORY_CONTENT_TYPE_ENUM_ID`),
  KEY `IDXProductCategoryContentProductCategory` (`PRODUCT_CATEGORY_ID`),
  KEY `IDXProductCategoryContentPCCTypeEnumeration` (`CATEGORY_CONTENT_TYPE_ENUM_ID`),
  KEY `IDXProductCategoryContentProductStore` (`PRODUCT_STORE_ID`),
  CONSTRAINT `product_category_content_ibfk_1` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_feat_grp_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_feat_grp_appl` (
  `PRODUCT_CATEGORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `APPL_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`,`PRODUCT_FEATURE_GROUP_ID`,`FROM_DATE`),
  KEY `IDXProductCategoryFeatGrpApplProductCategory` (`PRODUCT_CATEGORY_ID`),
  KEY `IDXProductCategoryFeatGrpApplProductFeatureGroup` (`PRODUCT_FEATURE_GROUP_ID`),
  KEY `IDXProductCategoryFeatGrpApplPFeatureApplTypeEnumeration` (`APPL_TYPE_ENUM_ID`),
  CONSTRAINT `product_category_feat_grp_appl_ibfk_1` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_ident`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_ident` (
  `PRODUCT_CATEGORY_IDENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_CATEGORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IDENT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ID_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_IDENT_ID`),
  KEY `PRODUCT_CAT_STR_ID_VAL` (`ID_VALUE`),
  KEY `IDXProductCategoryIdentPCITypeEnumeration` (`IDENT_TYPE_ENUM_ID`),
  KEY `IDXProductCategoryIdentProductCategory` (`PRODUCT_CATEGORY_ID`),
  KEY `IDXProductCategoryIdentProductStore` (`PRODUCT_STORE_ID`),
  CONSTRAINT `product_category_ident_ibfk_1` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_member`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_member` (
  `PRODUCT_CATEGORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `QUANTITY` decimal(26,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`,`PRODUCT_ID`,`FROM_DATE`),
  KEY `PRD_CMBR_PCT` (`PRODUCT_CATEGORY_ID`),
  KEY `IDXProductCategoryMemberProduct` (`PRODUCT_ID`),
  KEY `IDXProductCategoryMemberProductCategory` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `product_category_member_ibfk_1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `product_category_member_ibfk_2` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_party` (
  `PRODUCT_CATEGORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`FROM_DATE`),
  KEY `IDXProductCategoryPartyProductCategor` (`PRODUCT_CATEGORY_ID`),
  KEY `IDXProductCategoryPartyP` (`PARTY_ID`),
  KEY `IDXProductCategoryPartyRoleType` (`ROLE_TYPE_ID`),
  CONSTRAINT `product_category_party_ibfk_1` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `product_category_party_ibfk_2` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `product_category_party_ibfk_3` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_category_rollup`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_rollup` (
  `PRODUCT_CATEGORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_PRODUCT_CATEGORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CATEGORY_ID`,`PARENT_PRODUCT_CATEGORY_ID`,`FROM_DATE`),
  KEY `PRDCR_PARPC` (`PARENT_PRODUCT_CATEGORY_ID`),
  KEY `IDXProductCategoryRollupProductCategory` (`PRODUCT_CATEGORY_ID`),
  KEY `IDXProductCategoryRollupParentProductCategory` (`PARENT_PRODUCT_CATEGORY_ID`),
  CONSTRAINT `product_category_rollup_ibfk_1` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`),
  CONSTRAINT `product_category_rollup_ibfk_2` FOREIGN KEY (`PARENT_PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_class_content`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_class_content` (
  `PRODUCT_CLASS_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_CONTENT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CLASS_ENUM_ID`,`PRODUCT_CONTENT_TYPE_ENUM_ID`),
  KEY `IDXProductClassContentPCEnumeration` (`PRODUCT_CLASS_ENUM_ID`),
  KEY `IDXProductClassContentPContentTypeEnumeration` (`PRODUCT_CONTENT_TYPE_ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_class_feature`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_class_feature` (
  `PRODUCT_CLASS_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CLASS_ENUM_ID`,`PRODUCT_FEATURE_TYPE_ENUM_ID`),
  KEY `IDXProductClassFeaturePCEnumeration` (`PRODUCT_CLASS_ENUM_ID`),
  KEY `IDXProductClassFeaturePFeatureTypeEnumeration` (`PRODUCT_FEATURE_TYPE_ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_class_feature_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_class_feature_group` (
  `PRODUCT_CLASS_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CLASS_ENUM_ID`,`PRODUCT_FEATURE_GROUP_ID`),
  KEY `IDXProductClassFeatureGroupPCEnumeration` (`PRODUCT_CLASS_ENUM_ID`),
  KEY `IDXProductClassFeatureGroupProductFG` (`PRODUCT_FEATURE_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_class_uom_dimension`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_class_uom_dimension` (
  `PRODUCT_CLASS_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `UOM_DIMENSION_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CLASS_ENUM_ID`,`UOM_DIMENSION_TYPE_ID`),
  KEY `IDXProductClassUomDimensionPCEnumerat` (`PRODUCT_CLASS_ENUM_ID`),
  KEY `IDXProductClassUomDimensionUomDimensionType` (`UOM_DIMENSION_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_content`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_content` (
  `PRODUCT_CONTENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTENT_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_CONTENT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOCALE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_FEATURE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `DESCRIPTION` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_CONTENT_ID`),
  KEY `IDXProductContentProduc` (`PRODUCT_ID`),
  KEY `IDXProductContentPCTypeEnumeration` (`PRODUCT_CONTENT_TYPE_ENUM_ID`),
  KEY `IDXProductContentProductFeature` (`PRODUCT_FEATURE_ID`),
  KEY `IDXProductContentProductStore` (`PRODUCT_STORE_ID`),
  CONSTRAINT `product_content_ibfk_1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_db_form`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_db_form` (
  `PRODUCT_DB_FORM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FORM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FORM_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_DB_FORM_ID`),
  KEY `IDXProductDbFormProduct` (`PRODUCT_ID`),
  KEY `IDXProductDbFormDF` (`FORM_ID`),
  KEY `IDXProductDbFormPFormTypeEnumeration` (`PRODUCT_FORM_TYPE_ENUM_ID`),
  KEY `IDXProductDbFormRoleType` (`ROLE_TYPE_ID`),
  CONSTRAINT `product_db_form_ibfk_1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `product_db_form_ibfk_2` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_dimension`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_dimension` (
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DIMENSION_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VALUE` decimal(26,6) DEFAULT NULL,
  `VALUE_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`DIMENSION_TYPE_ID`),
  KEY `IDXProductDimensionProduct` (`PRODUCT_ID`),
  KEY `IDXProductDimensionProductDimensionType` (`DIMENSION_TYPE_ID`),
  KEY `IDXProductDimensionValueUom` (`VALUE_UOM_ID`),
  CONSTRAINT `product_dimension_ibfk_1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_dimension_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_dimension_type` (
  `DIMENSION_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `UOM_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`DIMENSION_TYPE_ID`),
  KEY `IDXProductDimensionTypeUomTypeEnumeration` (`UOM_TYPE_ENUM_ID`),
  KEY `IDXProductDimensionTypeDefaultUom` (`DEFAULT_UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_facility`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_facility` (
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MINIMUM_STOCK` decimal(26,6) DEFAULT NULL,
  `REORDER_QUANTITY` decimal(26,6) DEFAULT NULL,
  `DAYS_TO_SHIP` decimal(20,0) DEFAULT NULL,
  `LAST_INVENTORY_COUNT` decimal(26,6) DEFAULT NULL,
  `COMPUTED_LAST_INVENTORY_COUNT` decimal(26,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`FACILITY_ID`),
  KEY `IDXProductFacilityProduct` (`PRODUCT_ID`),
  KEY `IDXProductFacilityF` (`FACILITY_ID`),
  CONSTRAINT `product_facility_ibfk_1` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_facility_location`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_facility_location` (
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOCATION_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MINIMUM_STOCK` decimal(26,6) DEFAULT NULL,
  `MOVE_QUANTITY` decimal(26,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`FACILITY_ID`,`LOCATION_SEQ_ID`),
  KEY `IDXProductFacilityLocationProduct` (`PRODUCT_ID`),
  KEY `IDXProductFacilityLocationFL` (`FACILITY_ID`,`LOCATION_SEQ_ID`),
  CONSTRAINT `product_facility_location_ibfk_1` FOREIGN KEY (`FACILITY_ID`, `LOCATION_SEQ_ID`) REFERENCES `facility_location` (`FACILITY_ID`, `LOCATION_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature` (
  `PRODUCT_FEATURE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NUMBER_SPECIFIED` decimal(26,6) DEFAULT NULL,
  `NUMBER_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_AMOUNT` decimal(24,4) DEFAULT NULL,
  `DEFAULT_SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `ABBREV` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ID_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OWNER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NUMBER_PER_PALLET` decimal(26,6) DEFAULT NULL,
  `PER_PALLET_TIER` decimal(26,6) DEFAULT NULL,
  `TIERS_PER_PALLET` decimal(26,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_FEATURE_ID`),
  KEY `IDXProductFeaturePFTypeEnumeration` (`PRODUCT_FEATURE_TYPE_ENUM_ID`),
  KEY `IDXProductFeatureNumberUom` (`NUMBER_UOM_ID`),
  KEY `IDXProductFeatureOwnerParty` (`OWNER_PARTY_ID`),
  CONSTRAINT `product_feature_ibfk_1` FOREIGN KEY (`OWNER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_appl` (
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `APPL_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `AMOUNT` decimal(26,6) DEFAULT NULL,
  `RECURRING_AMOUNT` decimal(26,6) DEFAULT NULL,
  `FEATURE_PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`PRODUCT_FEATURE_ID`,`FROM_DATE`),
  KEY `PRODFTAP_PID_PFID` (`PRODUCT_ID`,`PRODUCT_FEATURE_ID`),
  KEY `IDXProductFeatureApplProduct` (`PRODUCT_ID`),
  KEY `IDXProductFeatureApplProductFeature` (`PRODUCT_FEATURE_ID`),
  KEY `IDXProductFeatureApplPFATypeEnumeration` (`APPL_TYPE_ENUM_ID`),
  KEY `IDXProductFeatureApplFeatureProduct` (`FEATURE_PRODUCT_ID`),
  CONSTRAINT `product_feature_appl_ibfk_1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `product_feature_appl_ibfk_2` FOREIGN KEY (`PRODUCT_FEATURE_ID`) REFERENCES `product_feature` (`PRODUCT_FEATURE_ID`),
  CONSTRAINT `product_feature_appl_ibfk_3` FOREIGN KEY (`FEATURE_PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_group` (
  `PRODUCT_FEATURE_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_FEATURE_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_group_appl`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_group_appl` (
  `PRODUCT_FEATURE_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_FEATURE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_FEATURE_GROUP_ID`,`PRODUCT_FEATURE_ID`,`FROM_DATE`),
  KEY `IDXProductFeatureGroupApplProductFeatureGroup` (`PRODUCT_FEATURE_GROUP_ID`),
  KEY `IDXProductFeatureGroupApplProductFeature` (`PRODUCT_FEATURE_ID`),
  CONSTRAINT `product_feature_group_appl_ibfk_1` FOREIGN KEY (`PRODUCT_FEATURE_GROUP_ID`) REFERENCES `product_feature_group` (`PRODUCT_FEATURE_GROUP_ID`),
  CONSTRAINT `product_feature_group_appl_ibfk_2` FOREIGN KEY (`PRODUCT_FEATURE_ID`) REFERENCES `product_feature` (`PRODUCT_FEATURE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_feature_iactn`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_feature_iactn` (
  `PRODUCT_FEATURE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TO_PRODUCT_FEATURE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `IACTN_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(26,6) DEFAULT NULL,
  `AMOUNT` decimal(26,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_FEATURE_ID`,`TO_PRODUCT_FEATURE_ID`),
  KEY `IDXProductFeatureIactnPFITypeEnumeratio` (`IACTN_TYPE_ENUM_ID`),
  KEY `IDXProductFeatureIactnProductFeature` (`PRODUCT_FEATURE_ID`),
  KEY `IDXProductFeatureIactnToProductFeature` (`TO_PRODUCT_FEATURE_ID`),
  CONSTRAINT `product_feature_iactn_ibfk_1` FOREIGN KEY (`PRODUCT_FEATURE_ID`) REFERENCES `product_feature` (`PRODUCT_FEATURE_ID`),
  CONSTRAINT `product_feature_iactn_ibfk_2` FOREIGN KEY (`TO_PRODUCT_FEATURE_ID`) REFERENCES `product_feature` (`PRODUCT_FEATURE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_geo`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_geo` (
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_GEO_PURPOSE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`GEO_ID`),
  KEY `IDXProductGeoProduct` (`PRODUCT_ID`),
  KEY `IDXProductGeoG` (`GEO_ID`),
  KEY `IDXProductGeoPGPurposeEnumeration` (`PRODUCT_GEO_PURPOSE_ENUM_ID`),
  CONSTRAINT `product_geo_ibfk_1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_identification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_identification` (
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ID_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`PRODUCT_ID_TYPE_ENUM_ID`),
  KEY `PRODUCT_ID_VALUE` (`ID_VALUE`),
  KEY `IDXProductIdentificationPITypeEnumer` (`PRODUCT_ID_TYPE_ENUM_ID`),
  KEY `IDXProductIdentificationProduct` (`PRODUCT_ID`),
  CONSTRAINT `product_identification_ibfk_1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_other_identification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_other_identification` (
  `PRODUCT_OTHER_IDENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ID_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_OTHER_IDENT_ID`),
  KEY `PRODUCT_STR_ID_VAL` (`ID_VALUE`),
  KEY `IDXProductOtherIdentificationPIdentificationTypeEnumer` (`PRODUCT_ID_TYPE_ENUM_ID`),
  KEY `IDXProductOtherIdentificationProduct` (`PRODUCT_ID`),
  KEY `IDXProductOtherIdentificationProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXProductOtherIdentificationParentProduct` (`PARENT_PRODUCT_ID`),
  CONSTRAINT `product_other_identification_ibfk_1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `product_other_identification_ibfk_2` FOREIGN KEY (`PARENT_PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_parameter`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_parameter` (
  `PRODUCT_PARAMETER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `UOM_DIMENSION_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PARAMETER_ID`),
  KEY `IDXProductParameterUomDimensionType` (`UOM_DIMENSION_TYPE_ID`),
  KEY `IDXProductParameterPIdentificationTypeEnumeration` (`PRODUCT_ID_TYPE_ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_parameter_option`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_parameter_option` (
  `PRODUCT_PARAMETER_OPTION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PARAMETER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_UOM_DIMENSION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_OTHER_IDENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARAMETER_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PARAMETER_OPTION_ID`),
  KEY `IDXProductParameterOptionProductParameter` (`PRODUCT_PARAMETER_ID`),
  KEY `IDXProductParameterOptionProduct` (`PRODUCT_ID`),
  KEY `IDXProductParameterOptionProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXProductParameterOptionProductUomDimens` (`PRODUCT_UOM_DIMENSION_ID`),
  KEY `IDXProductParameterOptionProductOtherIdentification` (`PRODUCT_OTHER_IDENT_ID`),
  CONSTRAINT `product_parameter_option_ibfk_1` FOREIGN KEY (`PRODUCT_PARAMETER_ID`) REFERENCES `product_parameter` (`PRODUCT_PARAMETER_ID`),
  CONSTRAINT `product_parameter_option_ibfk_2` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `product_parameter_option_ibfk_3` FOREIGN KEY (`PRODUCT_OTHER_IDENT_ID`) REFERENCES `product_other_identification` (`PRODUCT_OTHER_IDENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_parameter_product`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_parameter_product` (
  `PRODUCT_PARAMETER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PARAMETER_ID`,`PRODUCT_ID`),
  KEY `IDXProductParameterProductProductParameter` (`PRODUCT_PARAMETER_ID`),
  KEY `IDXProductParameterProductP` (`PRODUCT_ID`),
  CONSTRAINT `product_parameter_product_ibfk_1` FOREIGN KEY (`PRODUCT_PARAMETER_ID`) REFERENCES `product_parameter` (`PRODUCT_PARAMETER_ID`),
  CONSTRAINT `product_parameter_product_ibfk_2` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_parameter_set`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_parameter_set` (
  `PRODUCT_PARAMETER_SET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOMER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PARAMETER_SET_ID`),
  KEY `IDXProductParameterSetProduc` (`PRODUCT_ID`),
  KEY `IDXProductParameterSetCustomerParty` (`CUSTOMER_PARTY_ID`),
  CONSTRAINT `product_parameter_set_ibfk_1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `product_parameter_set_ibfk_2` FOREIGN KEY (`CUSTOMER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_parameter_value`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_parameter_value` (
  `PRODUCT_PARAMETER_VALUE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PARAMETER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_PARAMETER_SET_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MARKET_SEGMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_PARAMETER_OPTION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARAMETER_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PARAMETER_VALUE_ID`),
  KEY `IDXProductParameterValueProductParameterSet` (`PRODUCT_PARAMETER_SET_ID`),
  KEY `IDXProductParameterValueProductParameter` (`PRODUCT_PARAMETER_ID`),
  KEY `IDXProductParameterValueProductParameterOption` (`PRODUCT_PARAMETER_OPTION_ID`),
  KEY `IDXProductParameterValueUom` (`UOM_ID`),
  CONSTRAINT `product_parameter_value_ibfk_1` FOREIGN KEY (`PRODUCT_PARAMETER_SET_ID`) REFERENCES `product_parameter_set` (`PRODUCT_PARAMETER_SET_ID`),
  CONSTRAINT `product_parameter_value_ibfk_2` FOREIGN KEY (`PRODUCT_PARAMETER_ID`) REFERENCES `product_parameter` (`PRODUCT_PARAMETER_ID`),
  CONSTRAINT `product_parameter_value_ibfk_3` FOREIGN KEY (`PRODUCT_PARAMETER_OPTION_ID`) REFERENCES `product_parameter_option` (`PRODUCT_PARAMETER_OPTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_party` (
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `COMMENTS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OTHER_PARTY_ITEM_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OTHER_PARTY_ITEM_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`FROM_DATE`),
  KEY `IDXProductPartyProduct` (`PRODUCT_ID`),
  KEY `IDXProductPartyP` (`PARTY_ID`),
  KEY `IDXProductPartyRoleType` (`ROLE_TYPE_ID`),
  CONSTRAINT `product_party_ibfk_1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `product_party_ibfk_2` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `product_party_ibfk_3` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_price`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_price` (
  `PRODUCT_PRICE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VENDOR_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOMER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRICE_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRICE_PURPOSE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `MIN_QUANTITY` decimal(26,6) DEFAULT NULL,
  `PRICE` decimal(25,5) DEFAULT NULL,
  `PRICE_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TERM_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TAX_IN_PRICE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TAX_AMOUNT` decimal(25,5) DEFAULT NULL,
  `TAX_PERCENTAGE` decimal(26,6) DEFAULT NULL,
  `OTHER_PARTY_ITEM_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OTHER_PARTY_ITEM_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMMENTS` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY_INCREMENT` decimal(26,6) DEFAULT NULL,
  `QUANTITY_INCLUDED` decimal(26,6) DEFAULT NULL,
  `QUANTITY_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PREFERRED_ORDER_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUPPLIER_RATING_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STANDARD_LEAD_TIME_DAYS` decimal(26,6) DEFAULT NULL,
  `CAN_DROP_SHIP` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_PRICE_ID`),
  KEY `IDXProductPriceProduct` (`PRODUCT_ID`),
  KEY `IDXProductPricePPTypeEnumeration` (`PRICE_TYPE_ENUM_ID`),
  KEY `IDXProductPricePPPurposeEnumeration` (`PRICE_PURPOSE_ENUM_ID`),
  KEY `IDXProductPricePiceUom` (`PRICE_UOM_ID`),
  KEY `IDXProductPriceTermUom` (`TERM_UOM_ID`),
  KEY `IDXProductPriceProductStor` (`PRODUCT_STORE_ID`),
  KEY `IDXProductPriceSupplierPreferredOrderEnumeration` (`PREFERRED_ORDER_ENUM_ID`),
  KEY `IDXProductPriceSupplierRatingTypeEnumeration` (`SUPPLIER_RATING_TYPE_ENUM_ID`),
  KEY `IDXProductPriceQuantityUom` (`QUANTITY_UOM_ID`),
  CONSTRAINT `product_price_ibfk_1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_price_modify`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_price_modify` (
  `PRICE_MODIFY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SERVICE_REGISTER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRICE_MODIFY_ID`),
  KEY `IDXProductPriceModifyServiceRegister` (`SERVICE_REGISTER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_price_modify_parameter`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_price_modify_parameter` (
  `PRICE_MODIFY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARAMETER_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARAMETER_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRICE_MODIFY_ID`,`PARAMETER_NAME`),
  KEY `IDXProductPriceModifyParameterProductPriceModify` (`PRICE_MODIFY_ID`),
  CONSTRAINT `product_price_modify_parameter_ibfk_1` FOREIGN KEY (`PRICE_MODIFY_ID`) REFERENCES `product_price_modify` (`PRICE_MODIFY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store` (
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STORE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORGANIZATION_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVENTORY_FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESERVATION_ORDER_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESERVATION_AUTO_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIRE_INVENTORY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_DISABLE_PROMOTIONS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_DISABLE_SHIPPING_CALC` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_DISABLE_TAX_CALC` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_POSTAL_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MARKUP_ORDER_SHIP_LABELS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MARKUP_SHIPMENT_SHIP_LABELS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ANY_CARRIER_METHOD` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INSURANCE_PACKAGE_THRESHOLD` decimal(24,4) DEFAULT NULL,
  `AUTO_APPROVE_DELAY` decimal(20,0) DEFAULT NULL,
  `STORE_DOMAIN` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PROFILE_URL_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_DATA_DOCUMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BLOG_DATA_DOCUMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_DATA_DOCUMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_LOCALE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_CURRENCY_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_SALES_CHANNEL_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIRE_CUSTOMER_ROLE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SYSTEM_MESSAGE_REMOTE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`),
  KEY `IDXProductStoreOrganizationParty` (`ORGANIZATION_PARTY_ID`),
  KEY `IDXProductStoreInventoryFacility` (`INVENTORY_FACILITY_ID`),
  KEY `IDXProductStoreAssetReservationOrderEnumeration` (`RESERVATION_ORDER_ENUM_ID`),
  KEY `IDXProductStoreAssetReservationAutoEnumeration` (`RESERVATION_AUTO_ENUM_ID`),
  KEY `IDXProductStoreReturnPostalAddress` (`RETURN_POSTAL_CONTACT_MECH_ID`),
  KEY `IDXProductStoreContentDataDocument` (`CONTENT_DATA_DOCUMENT_ID`),
  KEY `IDXProductStoreBlogDataDocument` (`BLOG_DATA_DOCUMENT_ID`),
  KEY `IDXProductStorePDataDocument` (`PRODUCT_DATA_DOCUMENT_ID`),
  KEY `IDXProductStoreDefaultCurrencyUom` (`DEFAULT_CURRENCY_UOM_ID`),
  KEY `IDXProductStoreDefaultSalesChannelEnumeration` (`DEFAULT_SALES_CHANNEL_ENUM_ID`),
  KEY `IDXProductStoreSystemMessageRemote` (`SYSTEM_MESSAGE_REMOTE_ID`),
  CONSTRAINT `product_store_ibfk_1` FOREIGN KEY (`ORGANIZATION_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `product_store_ibfk_2` FOREIGN KEY (`INVENTORY_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `product_store_ibfk_3` FOREIGN KEY (`RETURN_POSTAL_CONTACT_MECH_ID`) REFERENCES `postal_address` (`CONTACT_MECH_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_approve`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_approve` (
  `STORE_APPROVE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVICE_REGISTER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`STORE_APPROVE_ID`),
  KEY `IDXProductStoreApproveProductStor` (`PRODUCT_STORE_ID`),
  KEY `IDXProductStoreApproveServiceRegister` (`SERVICE_REGISTER_ID`),
  CONSTRAINT `product_store_approve_ibfk_1` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_approve_param`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_approve_param` (
  `STORE_APPROVE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARAMETER_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARAMETER_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`STORE_APPROVE_ID`,`PARAMETER_NAME`),
  KEY `IDXProductStoreApproveParamProductStoreApprove` (`STORE_APPROVE_ID`),
  CONSTRAINT `product_store_approve_param_ibfk_1` FOREIGN KEY (`STORE_APPROVE_ID`) REFERENCES `product_store_approve` (`STORE_APPROVE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_category` (
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_CATEGORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STORE_CATEGORY_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`PRODUCT_CATEGORY_ID`,`STORE_CATEGORY_TYPE_ENUM_ID`,`FROM_DATE`),
  KEY `IDXProductStoreCategoryProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXProductStoreCategoryProductC` (`PRODUCT_CATEGORY_ID`),
  KEY `IDXProductStoreCategoryPSCTypeEnumeration` (`STORE_CATEGORY_TYPE_ENUM_ID`),
  CONSTRAINT `product_store_category_ibfk_1` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `product_store_category_ibfk_2` FOREIGN KEY (`PRODUCT_CATEGORY_ID`) REFERENCES `product_category` (`PRODUCT_CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_data_document`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_data_document` (
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DATA_DOCUMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`TYPE_ENUM_ID`),
  KEY `IDXProductStoreDataDocumentProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXProductStoreDataDocumentDD` (`DATA_DOCUMENT_ID`),
  KEY `IDXProductStoreDataDocumentStoreDataDocumentTypeEnumeration` (`TYPE_ENUM_ID`),
  CONSTRAINT `product_store_data_document_ibfk_1` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_email`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_email` (
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `EMAIL_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `EMAIL_TEMPLATE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HEADER_IMAGE_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DETAIL_LINK_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WEB_ORDER_BCC` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`EMAIL_TYPE_ENUM_ID`,`FROM_DATE`),
  KEY `IDXProductStoreEmailProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXProductStoreEmailPSETypeEnumeration` (`EMAIL_TYPE_ENUM_ID`),
  KEY `IDXProductStoreEmailEmailTemplate` (`EMAIL_TEMPLATE_ID`),
  CONSTRAINT `product_store_email_ibfk_1` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_facility`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_facility` (
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`FACILITY_ID`,`FROM_DATE`),
  KEY `IDXProductStoreFacilityProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXProductStoreFacilityF` (`FACILITY_ID`),
  CONSTRAINT `product_store_facility_ibfk_1` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `product_store_facility_ibfk_2` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_group` (
  `PRODUCT_STORE_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STORE_GROUP_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_GROUP_ID`),
  KEY `IDXProductStoreGroupPSGTypeEnumeration` (`STORE_GROUP_TYPE_ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_group_member`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_group_member` (
  `PRODUCT_STORE_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_GROUP_ID`,`PRODUCT_STORE_ID`,`FROM_DATE`),
  KEY `IDXProductStoreGroupMemberProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXProductStoreGroupMemberProductStoreGroup` (`PRODUCT_STORE_GROUP_ID`),
  CONSTRAINT `product_store_group_member_ibfk_1` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `product_store_group_member_ibfk_2` FOREIGN KEY (`PRODUCT_STORE_GROUP_ID`) REFERENCES `product_store_group` (`PRODUCT_STORE_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_group_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_group_party` (
  `PRODUCT_STORE_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_GROUP_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`FROM_DATE`),
  KEY `IDXProductStoreGroupPartyProductStoreGroup` (`PRODUCT_STORE_GROUP_ID`),
  KEY `IDXProductStoreGroupPartyP` (`PARTY_ID`),
  KEY `IDXProductStoreGroupPartyRoleType` (`ROLE_TYPE_ID`),
  CONSTRAINT `product_store_group_party_ibfk_1` FOREIGN KEY (`PRODUCT_STORE_GROUP_ID`) REFERENCES `product_store_group` (`PRODUCT_STORE_GROUP_ID`),
  CONSTRAINT `product_store_group_party_ibfk_2` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `product_store_group_party_ibfk_3` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_party` (
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`PARTY_ID`,`ROLE_TYPE_ID`,`FROM_DATE`),
  KEY `IDXProductStorePartyProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXProductStorePartyP` (`PARTY_ID`),
  KEY `IDXProductStorePartyRoleType` (`ROLE_TYPE_ID`),
  CONSTRAINT `product_store_party_ibfk_1` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `product_store_party_ibfk_2` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `product_store_party_ibfk_3` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_product`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_product` (
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SIGNATURE_REQUIRED_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`PRODUCT_ID`),
  KEY `IDXProductStoreProductProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXProductStoreProductP` (`PRODUCT_ID`),
  KEY `IDXProductStoreProductSignatureRequiredEnumeration` (`SIGNATURE_REQUIRED_ENUM_ID`),
  CONSTRAINT `product_store_product_ibfk_1` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `product_store_product_ibfk_2` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_promo_code`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_promo_code` (
  `PROMO_CODE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PROMO_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `USE_LIMIT_PER_CODE` decimal(20,0) DEFAULT NULL,
  `USE_LIMIT_PER_CUSTOMER` decimal(20,0) DEFAULT NULL,
  `USER_ENTERED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIRE_PARTY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PROMO_CODE_ID`),
  UNIQUE KEY `PSTR_PROMO_CODE` (`PROMO_CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_promo_code_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_promo_code_party` (
  `PROMO_CODE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PROMO_CODE_ID`,`PARTY_ID`),
  KEY `IDXProductStorePromoCodePartyProductStorePromoCode` (`PROMO_CODE_ID`),
  KEY `IDXProductStorePromoCodePartyP` (`PARTY_ID`),
  CONSTRAINT `product_store_promo_code_party_ibfk_1` FOREIGN KEY (`PROMO_CODE_ID`) REFERENCES `product_store_promo_code` (`PROMO_CODE_ID`),
  CONSTRAINT `product_store_promo_code_party_ibfk_2` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_setting`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_setting` (
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SETTING_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SETTING_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`SETTING_TYPE_ENUM_ID`,`FROM_DATE`),
  KEY `IDXProductStoreSettingProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXProductStoreSettingPSSTypeEnumeration` (`SETTING_TYPE_ENUM_ID`),
  CONSTRAINT `product_store_setting_ibfk_1` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_ship_option`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_ship_option` (
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CARRIER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_METHOD_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `MARKUP_PERCENT` decimal(26,6) DEFAULT NULL,
  `MARKUP_AMOUNT` decimal(24,4) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`CARRIER_PARTY_ID`,`SHIPMENT_METHOD_ENUM_ID`),
  KEY `IDXProductStoreShipOptionProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXProductStoreShipOptionCarrierParty` (`CARRIER_PARTY_ID`),
  KEY `IDXProductStoreShipOptionShipmentMethodEnumera` (`SHIPMENT_METHOD_ENUM_ID`),
  CONSTRAINT `product_store_ship_option_ibfk_1` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `product_store_ship_option_ibfk_2` FOREIGN KEY (`CARRIER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_store_shipping_gateway`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store_shipping_gateway` (
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CARRIER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPPING_GATEWAY_CONFIG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BILLING_TYPE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BILLING_ACCOUNT` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BILLING_ZIP` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BILLING_COUNTRY` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INSURANCE_PERCENT` decimal(26,6) DEFAULT NULL,
  `DEFAULT_TRADE_TERM_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOMS_CONTENTS_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOMS_NON_DELIVERY_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_STORE_ID`,`CARRIER_PARTY_ID`),
  KEY `IDXProductStoreShippingGatewayProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXProductStoreShippingGatewayCarrierPart` (`CARRIER_PARTY_ID`),
  KEY `IDXProductStoreShippingGatewayShippingGatewayConfig` (`SHIPPING_GATEWAY_CONFIG_ID`),
  KEY `IDXProductStoreShippingGatewayTermTypeEnumeration` (`DEFAULT_TRADE_TERM_ENUM_ID`),
  CONSTRAINT `product_store_shipping_gateway_ibfk_1` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `product_store_shipping_gateway_ibfk_2` FOREIGN KEY (`CARRIER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_uom_dimension`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_uom_dimension` (
  `PRODUCT_UOM_DIMENSION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `UOM_DIMENSION_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VALUE` decimal(26,6) DEFAULT NULL,
  `UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`PRODUCT_UOM_DIMENSION_ID`),
  KEY `IDXProductUomDimensionProduct` (`PRODUCT_ID`),
  KEY `IDXProductUomDimensionUomDimensionType` (`UOM_DIMENSION_TYPE_ID`),
  KEY `IDXProductUomDimensionUom` (`UOM_ID`),
  CONSTRAINT `product_uom_dimension_ibfk_1` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_contact_mech` (
  `RETURN_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_PURPOSE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ID`,`CONTACT_MECH_PURPOSE_ID`,`CONTACT_MECH_ID`),
  KEY `IDXReturnContactMechReturnHeader` (`RETURN_ID`),
  KEY `IDXReturnContactMechCM` (`CONTACT_MECH_ID`),
  KEY `IDXReturnContactMechContactMechPurpose` (`CONTACT_MECH_PURPOSE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_header`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_header` (
  `RETURN_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOMER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VENDOR_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USE_SINGLE_REFUND_PAYMENT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ENTRY_DATE` datetime(3) DEFAULT NULL,
  `POSTAL_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TELECOM_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_METHOD_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUPPLIER_RMA_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VISIT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SYSTEM_MESSAGE_REMOTE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DISPLAY_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXTERNAL_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ID`),
  KEY `RETURN_DISPLAY` (`DISPLAY_ID`),
  KEY `RETURN_EXTERNAL` (`EXTERNAL_ID`),
  KEY `RETURN_ORIGIN` (`ORIGIN_ID`),
  KEY `IDXReturnHeaderRStatusItem` (`STATUS_ID`),
  KEY `IDXReturnHeaderCustomerParty` (`CUSTOMER_PARTY_ID`),
  KEY `IDXReturnHeaderVendorParty` (`VENDOR_PARTY_ID`),
  KEY `IDXReturnHeaderPostalContactMech` (`POSTAL_CONTACT_MECH_ID`),
  KEY `IDXReturnHeaderPostalAddress` (`POSTAL_CONTACT_MECH_ID`),
  KEY `IDXReturnHeaderTelecomContactMech` (`TELECOM_CONTACT_MECH_ID`),
  KEY `IDXReturnHeaderFacility` (`FACILITY_ID`),
  KEY `IDXReturnHeaderShipmentMethodEnumeration` (`SHIPMENT_METHOD_ENUM_ID`),
  KEY `IDXReturnHeaderCarrierParty` (`CARRIER_PARTY_ID`),
  KEY `IDXReturnHeaderCurrencyUom` (`CURRENCY_UOM_ID`),
  KEY `IDXReturnHeaderVisit` (`VISIT_ID`),
  KEY `IDXReturnHeaderSystemMessageRemote` (`SYSTEM_MESSAGE_REMOTE_ID`),
  CONSTRAINT `return_header_ibfk_1` FOREIGN KEY (`FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_item` (
  `RETURN_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RETURN_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_REASON_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_RESPONSE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESPONSE_IMMEDIATE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ITEM_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REPLACEMENT_PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVENTORY_STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_QUANTITY` decimal(26,6) DEFAULT NULL,
  `RECEIVED_QUANTITY` decimal(26,6) DEFAULT NULL,
  `RETURN_PRICE` decimal(24,4) DEFAULT NULL,
  `RESPONSE_AMOUNT` decimal(24,4) DEFAULT NULL,
  `EXTERNAL_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESPONSE_DATE` datetime(3) DEFAULT NULL,
  `REPLACEMENT_ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ID`,`RETURN_ITEM_SEQ_ID`),
  KEY `RTN_ITM_BYORDITM` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `IDXReturnItemReturnHeader` (`RETURN_ID`),
  KEY `IDXReturnItemRReasonEnumeration` (`RETURN_REASON_ENUM_ID`),
  KEY `IDXReturnItemRResponseEnumeration` (`RETURN_RESPONSE_ENUM_ID`),
  KEY `IDXReturnItemItemTypeEnumeration` (`ITEM_TYPE_ENUM_ID`),
  KEY `IDXReturnItemOrderI` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `IDXReturnItemStatusI` (`STATUS_ID`),
  KEY `IDXReturnItemInventoryStatusI` (`INVENTORY_STATUS_ID`),
  KEY `IDXReturnItemProduct` (`PRODUCT_ID`),
  KEY `IDXReturnItemRplacementProduct` (`REPLACEMENT_PRODUCT_ID`),
  KEY `IDXReturnItemRplacementOrderHeader` (`REPLACEMENT_ORDER_ID`),
  CONSTRAINT `return_item_ibfk_1` FOREIGN KEY (`RETURN_ID`) REFERENCES `return_header` (`RETURN_ID`),
  CONSTRAINT `return_item_ibfk_2` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `return_item_ibfk_3` FOREIGN KEY (`REPLACEMENT_ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `return_system_message`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `return_system_message` (
  `RETURN_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SYSTEM_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `EXTERNAL_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DISPLAY_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`RETURN_ID`,`SYSTEM_MESSAGE_ID`),
  KEY `IDXReturnSystemMessageReturnHeader` (`RETURN_ID`),
  KEY `IDXReturnSystemMessageSM` (`SYSTEM_MESSAGE_ID`),
  CONSTRAINT `return_system_message_ibfk_1` FOREIGN KEY (`RETURN_ID`) REFERENCES `return_header` (`RETURN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_group_member`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_group_member` (
  `ROLE_GROUP_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ROLE_GROUP_ENUM_ID`,`ROLE_TYPE_ID`),
  KEY `IDXRoleGroupMemberRGEnumeration` (`ROLE_GROUP_ENUM_ID`),
  KEY `IDXRoleGroupMemberRoleType` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_type` (
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ROLE_TYPE_ID`),
  KEY `IDXRoleTypeParentRT` (`PARENT_TYPE_ID`),
  CONSTRAINT `role_type_ibfk_1` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `screen_document`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screen_document` (
  `SCREEN_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DOC_INDEX` decimal(20,0) NOT NULL,
  `LOCALE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DOC_TITLE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DOC_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SCREEN_LOCATION`,`DOC_INDEX`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `screen_path_alias`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screen_path_alias` (
  `ALIAS_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SCREEN_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`ALIAS_PATH`,`FROM_DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `screen_scheduled`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screen_scheduled` (
  `SCREEN_SCHEDULED_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SCREEN_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FORM_LIST_FIND_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RENDER_MODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NO_RESULTS_ABORT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CRON_EXPRESSION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `SAVE_TO_LOCATION` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_TEMPLATE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_SUBJECT` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SCREEN_SCHEDULED_ID`),
  KEY `IDXScreenScheduledFormListFin` (`FORM_LIST_FIND_ID`),
  KEY `IDXScreenScheduledEmailTemplate` (`EMAIL_TEMPLATE_ID`),
  KEY `IDXScreenScheduledUserAccount` (`USER_ID`),
  KEY `IDXScreenScheduledUserGroup` (`USER_GROUP_ID`),
  CONSTRAINT `screen_scheduled_ibfk_1` FOREIGN KEY (`EMAIL_TEMPLATE_ID`) REFERENCES `email_template` (`EMAIL_TEMPLATE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `screen_scheduled_lock`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screen_scheduled_lock` (
  `SCREEN_SCHEDULED_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_RUN_TIME` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SCREEN_SCHEDULED_ID`),
  KEY `IDXScreenScheduledLockScreenScheduled` (`SCREEN_SCHEDULED_ID`),
  CONSTRAINT `screen_scheduled_lock_ibfk_1` FOREIGN KEY (`SCREEN_SCHEDULED_ID`) REFERENCES `screen_scheduled` (`SCREEN_SCHEDULED_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `screen_theme`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screen_theme` (
  `SCREEN_THEME_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SCREEN_THEME_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SCREEN_THEME_ID`),
  KEY `IDXScreenThemeSTTypeEnumeration` (`SCREEN_THEME_TYPE_ENUM_ID`),
  CONSTRAINT `screen_theme_ibfk_1` FOREIGN KEY (`SCREEN_THEME_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `screen_theme_icon`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screen_theme_icon` (
  `SCREEN_THEME_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TEXT_PATTERN` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ICON_CLASS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SCREEN_THEME_ID`,`TEXT_PATTERN`),
  KEY `IDXScreenThemeIconScreenTheme` (`SCREEN_THEME_ID`),
  CONSTRAINT `screen_theme_icon_ibfk_1` FOREIGN KEY (`SCREEN_THEME_ID`) REFERENCES `screen_theme` (`SCREEN_THEME_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `screen_theme_resource`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `screen_theme_resource` (
  `SCREEN_THEME_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) NOT NULL,
  `RESOURCE_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESOURCE_VALUE` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SCREEN_THEME_ID`,`SEQUENCE_NUM`),
  KEY `IDXScreenThemeResourceScreenThem` (`SCREEN_THEME_ID`),
  KEY `IDXScreenThemeResourceSTRTypeEnumeration` (`RESOURCE_TYPE_ENUM_ID`),
  CONSTRAINT `screen_theme_resource_ibfk_1` FOREIGN KEY (`SCREEN_THEME_ID`) REFERENCES `screen_theme` (`SCREEN_THEME_ID`),
  CONSTRAINT `screen_theme_resource_ibfk_2` FOREIGN KEY (`RESOURCE_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sequence_value_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sequence_value_item` (
  `SEQ_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQ_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SEQ_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_job`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_job` (
  `JOB_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRANSACTION_TIMEOUT` decimal(20,0) DEFAULT NULL,
  `TOPIC` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOCAL_ONLY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CRON_EXPRESSION` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `REPEAT_COUNT` decimal(20,0) DEFAULT NULL,
  `PAUSED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXPIRE_LOCK_TIME` decimal(20,0) DEFAULT NULL,
  `MIN_RETRY_TIME` decimal(20,0) DEFAULT NULL,
  `PRIORITY` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`JOB_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_job_parameter`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_job_parameter` (
  `JOB_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARAMETER_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARAMETER_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`JOB_NAME`,`PARAMETER_NAME`),
  KEY `IDXServiceJobParameterServiceJob` (`JOB_NAME`),
  CONSTRAINT `service_job_parameter_ibfk_1` FOREIGN KEY (`JOB_NAME`) REFERENCES `service_job` (`JOB_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_job_run`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_job_run` (
  `JOB_RUN_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `JOB_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARAMETERS` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESULTS` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `MESSAGES` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_ERROR` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ERRORS` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOST_ADDRESS` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOST_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RUN_THREAD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `START_TIME` datetime(3) DEFAULT NULL,
  `END_TIME` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`JOB_RUN_ID`),
  KEY `SVC_JOBRUN_NAME` (`JOB_NAME`),
  KEY `IDXServiceJobRunServiceJob` (`JOB_NAME`),
  CONSTRAINT `service_job_run_ibfk_1` FOREIGN KEY (`JOB_NAME`) REFERENCES `service_job` (`JOB_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_job_run_lock`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_job_run_lock` (
  `JOB_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `JOB_RUN_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_RUN_TIME` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`JOB_NAME`),
  KEY `IDXServiceJobRunLockServiceJob` (`JOB_NAME`),
  KEY `IDXServiceJobRunLockServiceJobRun` (`JOB_RUN_ID`),
  CONSTRAINT `service_job_run_lock_ibfk_1` FOREIGN KEY (`JOB_NAME`) REFERENCES `service_job` (`JOB_NAME`),
  CONSTRAINT `service_job_run_lock_ibfk_2` FOREIGN KEY (`JOB_RUN_ID`) REFERENCES `service_job_run` (`JOB_RUN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_job_user`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_job_user` (
  `JOB_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RECEIVE_NOTIFICATIONS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`JOB_NAME`,`USER_ID`),
  KEY `IDXServiceJobUserServiceJob` (`JOB_NAME`),
  CONSTRAINT `service_job_user_ibfk_1` FOREIGN KEY (`JOB_NAME`) REFERENCES `service_job` (`JOB_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_parameter_semaphore`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_parameter_semaphore` (
  `SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARAMETER_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LOCK_THREAD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOCK_TIME` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SERVICE_NAME`,`PARAMETER_VALUE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_register`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_register` (
  `SERVICE_REGISTER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SERVICE_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONFIG_PARAMETERS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SERVICE_REGISTER_ID`),
  KEY `IDXServiceRegisterSRTypeEnumeration` (`SERVICE_TYPE_ENUM_ID`),
  CONSTRAINT `service_register_ibfk_1` FOREIGN KEY (`SERVICE_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment` (
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BIN_LOCATION_NUMBER` decimal(20,0) DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIORITY` decimal(20,0) DEFAULT NULL,
  `ENTRY_DATE` datetime(3) DEFAULT NULL,
  `SHIP_AFTER_DATE` datetime(3) DEFAULT NULL,
  `SHIP_BEFORE_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_READY_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_SHIP_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_ARRIVAL_DATE` datetime(3) DEFAULT NULL,
  `LATEST_CANCEL_DATE` datetime(3) DEFAULT NULL,
  `PACKED_DATE` datetime(3) DEFAULT NULL,
  `PICK_CONTAINER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ESTIMATED_SHIP_COST` decimal(24,4) DEFAULT NULL,
  `COST_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ADDTL_SHIPPING_CHARGE` decimal(24,4) DEFAULT NULL,
  `ADDTL_SHIPPING_CHARGE_DESC` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SIGNATURE_REQUIRED_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HANDLING_INSTRUCTIONS` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `OTHER_PARTY_ORDER_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SYSTEM_MESSAGE_REMOTE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXTERNAL_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`),
  KEY `SHIPMENT_EXTERNAL` (`EXTERNAL_ID`),
  KEY `SHIPMENT_ORIGIN` (`ORIGIN_ID`),
  KEY `IDXShipmentSTypeEnumeration` (`SHIPMENT_TYPE_ENUM_ID`),
  KEY `IDXShipmentSStatusItem` (`STATUS_ID`),
  KEY `IDXShipmentFromParty` (`FROM_PARTY_ID`),
  KEY `IDXShipmentToParty` (`TO_PARTY_ID`),
  KEY `IDXShipmentProductStore` (`PRODUCT_STORE_ID`),
  KEY `IDXShipmentPickContainer` (`PICK_CONTAINER_ID`),
  KEY `IDXShipmentCostUom` (`COST_UOM_ID`),
  KEY `IDXShipmentSignatureRequiredEnumeration` (`SIGNATURE_REQUIRED_ENUM_ID`),
  KEY `IDXShipmentSystemMessageRemote` (`SYSTEM_MESSAGE_REMOTE_ID`),
  CONSTRAINT `shipment_ibfk_1` FOREIGN KEY (`FROM_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `shipment_ibfk_2` FOREIGN KEY (`TO_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `shipment_ibfk_3` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`),
  CONSTRAINT `shipment_ibfk_4` FOREIGN KEY (`PICK_CONTAINER_ID`) REFERENCES `container` (`CONTAINER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_box_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_box_type` (
  `SHIPMENT_BOX_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PSEUDO_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DIMENSION_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BOX_LENGTH` decimal(26,6) DEFAULT NULL,
  `BOX_WIDTH` decimal(26,6) DEFAULT NULL,
  `BOX_HEIGHT` decimal(26,6) DEFAULT NULL,
  `WEIGHT_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BOX_WEIGHT` decimal(26,6) DEFAULT NULL,
  `DEFAULT_GROSS_WEIGHT` decimal(26,6) DEFAULT NULL,
  `CAPACITY_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `BOX_CAPACITY` decimal(26,6) DEFAULT NULL,
  `GATEWAY_BOX_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_BOX_TYPE_ID`),
  UNIQUE KEY `SH_BOX_TYPE_PSEUDO` (`PSEUDO_ID`),
  KEY `IDXShipmentBoxTypeDimensionUom` (`DIMENSION_UOM_ID`),
  KEY `IDXShipmentBoxTypeWeightUom` (`WEIGHT_UOM_ID`),
  KEY `IDXShipmentBoxTypeCapacityUom` (`CAPACITY_UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_contact_mech`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_contact_mech` (
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_PURPOSE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`CONTACT_MECH_PURPOSE_ID`),
  KEY `IDXShipmentContactMechShipment` (`SHIPMENT_ID`),
  KEY `IDXShipmentContactMechContactMechPurpose` (`CONTACT_MECH_PURPOSE_ID`),
  KEY `IDXShipmentContactMechCM` (`CONTACT_MECH_ID`),
  CONSTRAINT `shipment_contact_mech_ibfk_1` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`),
  CONSTRAINT `shipment_contact_mech_ibfk_2` FOREIGN KEY (`CONTACT_MECH_PURPOSE_ID`) REFERENCES `contact_mech_purpose` (`CONTACT_MECH_PURPOSE_ID`),
  CONSTRAINT `shipment_contact_mech_ibfk_3` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_content`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_content` (
  `SHIPMENT_CONTENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_CONTENT_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_PACKAGE_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ROUTE_SEGMENT_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_DATE` datetime(3) DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_CONTENT_ID`),
  KEY `IDXShipmentContentSCTypeEnumeration` (`SHIPMENT_CONTENT_TYPE_ENUM_ID`),
  KEY `IDXShipmentContentShipm` (`SHIPMENT_ID`),
  KEY `IDXShipmentContentProduc` (`PRODUCT_ID`),
  KEY `IDXShipmentContentUserAccou` (`USER_ID`),
  CONSTRAINT `shipment_content_ibfk_1` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`),
  CONSTRAINT `shipment_content_ibfk_2` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_email_message`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_email_message` (
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `EMAIL_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`EMAIL_MESSAGE_ID`),
  KEY `IDXShipmentEmailMessageShipment` (`SHIPMENT_ID`),
  KEY `IDXShipmentEmailMessageEM` (`EMAIL_MESSAGE_ID`),
  CONSTRAINT `shipment_email_message_ibfk_1` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_item` (
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUANTITY` decimal(26,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`PRODUCT_ID`),
  KEY `IDXShipmentItemShipment` (`SHIPMENT_ID`),
  KEY `IDXShipmentItemProduct` (`PRODUCT_ID`),
  CONSTRAINT `shipment_item_ibfk_1` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`),
  CONSTRAINT `shipment_item_ibfk_2` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_item_source`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_item_source` (
  `SHIPMENT_ITEM_SOURCE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `BIN_LOCATION_NUMBER` decimal(20,0) DEFAULT NULL,
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ITEM_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `QUANTITY` decimal(26,6) DEFAULT NULL,
  `QUANTITY_NOT_HANDLED` decimal(26,6) DEFAULT NULL,
  `QUANTITY_PICKED` decimal(26,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ITEM_SOURCE_ID`),
  KEY `SHIP_ITSRC_SHIPID` (`SHIPMENT_ID`),
  KEY `IDXShipmentItemSourceShipmentItem` (`SHIPMENT_ID`,`PRODUCT_ID`),
  KEY `IDXShipmentItemSourceProduct` (`PRODUCT_ID`),
  KEY `IDXShipmentItemSourceOrderItem` (`ORDER_ID`,`ORDER_ITEM_SEQ_ID`),
  KEY `IDXShipmentItemSourceReturnHeader` (`RETURN_ID`),
  KEY `IDXShipmentItemSourceSISStatusItem` (`STATUS_ID`),
  CONSTRAINT `shipment_item_source_ibfk_1` FOREIGN KEY (`SHIPMENT_ID`, `PRODUCT_ID`) REFERENCES `shipment_item` (`SHIPMENT_ID`, `PRODUCT_ID`),
  CONSTRAINT `shipment_item_source_ibfk_2` FOREIGN KEY (`PRODUCT_ID`) REFERENCES `product` (`PRODUCT_ID`),
  CONSTRAINT `shipment_item_source_ibfk_3` FOREIGN KEY (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`) REFERENCES `order_item` (`ORDER_ID`, `ORDER_ITEM_SEQ_ID`),
  CONSTRAINT `shipment_item_source_ibfk_4` FOREIGN KEY (`RETURN_ID`) REFERENCES `return_header` (`RETURN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_package`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_package` (
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_PACKAGE_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_BOX_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WEIGHT` decimal(26,6) DEFAULT NULL,
  `WEIGHT_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GATEWAY_PACKAGE_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`SHIPMENT_PACKAGE_SEQ_ID`),
  KEY `IDXShipmentPackageShipment` (`SHIPMENT_ID`),
  KEY `IDXShipmentPackageShipmentBoxTyp` (`SHIPMENT_BOX_TYPE_ID`),
  KEY `IDXShipmentPackageWeightUom` (`WEIGHT_UOM_ID`),
  CONSTRAINT `shipment_package_ibfk_1` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`),
  CONSTRAINT `shipment_package_ibfk_2` FOREIGN KEY (`SHIPMENT_BOX_TYPE_ID`) REFERENCES `shipment_box_type` (`SHIPMENT_BOX_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_package_content`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_package_content` (
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_PACKAGE_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PRODUCT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `QUANTITY` decimal(26,6) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`SHIPMENT_PACKAGE_SEQ_ID`,`PRODUCT_ID`),
  KEY `IDXShipmentPackageContentShipmentPackage` (`SHIPMENT_ID`,`SHIPMENT_PACKAGE_SEQ_ID`),
  KEY `IDXShipmentPackageContentShipmentItem` (`SHIPMENT_ID`,`PRODUCT_ID`),
  CONSTRAINT `shipment_package_content_ibfk_1` FOREIGN KEY (`SHIPMENT_ID`, `SHIPMENT_PACKAGE_SEQ_ID`) REFERENCES `shipment_package` (`SHIPMENT_ID`, `SHIPMENT_PACKAGE_SEQ_ID`),
  CONSTRAINT `shipment_package_content_ibfk_2` FOREIGN KEY (`SHIPMENT_ID`, `PRODUCT_ID`) REFERENCES `shipment_item` (`SHIPMENT_ID`, `PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_package_route_seg`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_package_route_seg` (
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_PACKAGE_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_ROUTE_SEGMENT_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TRACKING_CODE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRACKING_URL` varchar(1023) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRACKING_STATUS_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRACKING_SUB_STATUS` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRACKING_STATUS_DATE` datetime(3) DEFAULT NULL,
  `TRACKING_ETA` datetime(3) DEFAULT NULL,
  `TRACKING_ORIG_ETA` datetime(3) DEFAULT NULL,
  `BOX_NUMBER` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LABEL_DATE` datetime(3) DEFAULT NULL,
  `LABEL_URL` varchar(1023) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LABEL_IMAGE` longblob,
  `LABEL_INTL_SIGN_IMAGE` longblob,
  `LABEL_HTML` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `LABEL_PRINTED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INTERNATIONAL_INVOICE` longblob,
  `INTERNATIONAL_INVOICE_URL` varchar(1023) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GATEWAY_STATUS` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GATEWAY_MESSAGE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GATEWAY_LABEL_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GATEWAY_RATE_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GATEWAY_REFUND_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GATEWAY_REFUND_STATUS` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_TRACKING_CODE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_TRACKING_URL` varchar(1023) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_TRACKING_STATUS_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_TRACKING_SUB_STATUS` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_TRACKING_STATUS_DATE` datetime(3) DEFAULT NULL,
  `RETURN_LABEL_DATE` datetime(3) DEFAULT NULL,
  `RETURN_LABEL_URL` varchar(1023) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_LABEL_IMAGE` longblob,
  `RETURN_INTL_INVOICE_URL` varchar(1023) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_GATEWAY_STATUS` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_GATEWAY_MESSAGE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_GATEWAY_LABEL_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_GATEWAY_RATE_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_GATEWAY_REFUND_STATUS` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_ESTIMATED_AMOUNT` decimal(24,4) DEFAULT NULL,
  `RETURN_BASE_AMOUNT` decimal(24,4) DEFAULT NULL,
  `RETURN_ACTUAL_AMOUNT` decimal(24,4) DEFAULT NULL,
  `ESTIMATED_AMOUNT` decimal(24,4) DEFAULT NULL,
  `BASE_AMOUNT` decimal(24,4) DEFAULT NULL,
  `ACTUAL_AMOUNT` decimal(24,4) DEFAULT NULL,
  `PACKAGE_TRANSPORT_AMOUNT` decimal(24,4) DEFAULT NULL,
  `PACKAGE_SERVICE_AMOUNT` decimal(24,4) DEFAULT NULL,
  `PACKAGE_OTHER_AMOUNT` decimal(24,4) DEFAULT NULL,
  `COD_AMOUNT` decimal(24,4) DEFAULT NULL,
  `INSURANCE_AMOUNT` decimal(24,4) DEFAULT NULL,
  `INSURED_AMOUNT` decimal(24,4) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`SHIPMENT_PACKAGE_SEQ_ID`,`SHIPMENT_ROUTE_SEGMENT_SEQ_ID`),
  KEY `SHIP_PKRTSG_SHIPID` (`SHIPMENT_ID`),
  KEY `SHIP_PKRTSG_TRKCODE` (`TRACKING_CODE`),
  KEY `SHIP_PKRTSG_GTLBL` (`GATEWAY_LABEL_ID`),
  KEY `SHIP_PKRTSG_RTTRKCD` (`RETURN_TRACKING_CODE`),
  KEY `SHIP_PKRTSG_RTGTLBL` (`RETURN_GATEWAY_LABEL_ID`),
  KEY `IDXShipmentPackageRouteSegShipmentPackage` (`SHIPMENT_ID`,`SHIPMENT_PACKAGE_SEQ_ID`),
  KEY `IDXShipmentPackageRouteSegShipmentRouteSegment` (`SHIPMENT_ID`,`SHIPMENT_ROUTE_SEGMENT_SEQ_ID`),
  KEY `IDXShipmentPackageRouteSegSTrackingStatusEnumeration` (`TRACKING_STATUS_ENUM_ID`),
  KEY `IDXShipmentPackageRouteSegReturnTrackingStatusEnumeration` (`RETURN_TRACKING_STATUS_ENUM_ID`),
  CONSTRAINT `shipment_package_route_seg_ibfk_1` FOREIGN KEY (`SHIPMENT_ID`, `SHIPMENT_PACKAGE_SEQ_ID`) REFERENCES `shipment_package` (`SHIPMENT_ID`, `SHIPMENT_PACKAGE_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_party`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_party` (
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ROLE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`PARTY_ID`,`ROLE_TYPE_ID`),
  KEY `IDXShipmentPartyShipment` (`SHIPMENT_ID`),
  KEY `IDXShipmentPartyP` (`PARTY_ID`),
  KEY `IDXShipmentPartyRoleType` (`ROLE_TYPE_ID`),
  CONSTRAINT `shipment_party_ibfk_1` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`),
  CONSTRAINT `shipment_party_ibfk_2` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `shipment_party_ibfk_3` FOREIGN KEY (`ROLE_TYPE_ID`) REFERENCES `role_type` (`ROLE_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_route_segment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_route_segment` (
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_ROUTE_SEGMENT_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DELIVERY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPPING_GATEWAY_CONFIG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_POSTAL_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_TELECOM_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RETURN_POSTAL_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESTINATION_FACILITY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEST_POSTAL_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEST_TELECOM_CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_METHOD_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRADE_TERM_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOMS_CERTIFY` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOMS_CERTIFY_SIGNER` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOMS_CONTENTS_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CUSTOMS_NON_DELIVERY_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_DELIVERY_ZONE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_RESTRICTION_CODES` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CARRIER_RESTRICTION_DESC` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `BILLING_WEIGHT` decimal(26,6) DEFAULT NULL,
  `BILLING_WEIGHT_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACTUAL_TRANSPORT_COST` decimal(24,4) DEFAULT NULL,
  `ACTUAL_SERVICE_COST` decimal(24,4) DEFAULT NULL,
  `ACTUAL_OTHER_COST` decimal(24,4) DEFAULT NULL,
  `ACTUAL_COST` decimal(24,4) DEFAULT NULL,
  `COST_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACTUAL_START_DATE` datetime(3) DEFAULT NULL,
  `ACTUAL_ARRIVAL_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_START_DATE` datetime(3) DEFAULT NULL,
  `ESTIMATED_ARRIVAL_DATE` datetime(3) DEFAULT NULL,
  `MASTER_TRACKING_CODE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MASTER_TRACKING_URL` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOME_DELIVERY_TYPE` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HOME_DELIVERY_DATE` datetime(3) DEFAULT NULL,
  `THIRD_PARTY_ACCOUNT_NUMBER` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `THIRD_PARTY_POSTAL_CODE` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `THIRD_PARTY_COUNTRY_GEO_CODE` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HIGH_VALUE_REPORT` longblob,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`SHIPMENT_ROUTE_SEGMENT_SEQ_ID`),
  KEY `IDXShipmentRouteSegmentShip` (`SHIPMENT_ID`),
  KEY `IDXShipmentRouteSegmentDelivery` (`DELIVERY_ID`),
  KEY `IDXShipmentRouteSegmentShippingGatewayConfig` (`SHIPPING_GATEWAY_CONFIG_ID`),
  KEY `IDXShipmentRouteSegmentCarrierParty` (`CARRIER_PARTY_ID`),
  KEY `IDXShipmentRouteSegmentSMethodEnumeration` (`SHIPMENT_METHOD_ENUM_ID`),
  KEY `IDXShipmentRouteSegmentTermTypeEnumeration` (`TRADE_TERM_ENUM_ID`),
  KEY `IDXShipmentRouteSegmentCustomsContentsEnumeration` (`CUSTOMS_CONTENTS_ENUM_ID`),
  KEY `IDXShipmentRouteSegmentCustomsNonDeliveryEnumeration` (`CUSTOMS_NON_DELIVERY_ENUM_ID`),
  KEY `IDXShipmentRouteSegmentOriginFacility` (`ORIGIN_FACILITY_ID`),
  KEY `IDXShipmentRouteSegmentOriginPostalAddress` (`ORIGIN_POSTAL_CONTACT_MECH_ID`),
  KEY `IDXShipmentRouteSegmentOriginTelecomNumber` (`ORIGIN_TELECOM_CONTACT_MECH_ID`),
  KEY `IDXShipmentRouteSegmentReturnPostalAddress` (`RETURN_POSTAL_CONTACT_MECH_ID`),
  KEY `IDXShipmentRouteSegmentDestinationFacility` (`DESTINATION_FACILITY_ID`),
  KEY `IDXShipmentRouteSegmentDestinationPostalAddress` (`DEST_POSTAL_CONTACT_MECH_ID`),
  KEY `IDXShipmentRouteSegmentDestinationTelecomNumber` (`DEST_TELECOM_CONTACT_MECH_ID`),
  KEY `IDXShipmentRouteSegmentSRSStatusItem` (`STATUS_ID`),
  KEY `IDXShipmentRouteSegmentCostUom` (`COST_UOM_ID`),
  KEY `IDXShipmentRouteSegmentBillingWeightUom` (`BILLING_WEIGHT_UOM_ID`),
  CONSTRAINT `shipment_route_segment_ibfk_1` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`),
  CONSTRAINT `shipment_route_segment_ibfk_2` FOREIGN KEY (`CARRIER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`),
  CONSTRAINT `shipment_route_segment_ibfk_3` FOREIGN KEY (`ORIGIN_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `shipment_route_segment_ibfk_4` FOREIGN KEY (`ORIGIN_POSTAL_CONTACT_MECH_ID`) REFERENCES `postal_address` (`CONTACT_MECH_ID`),
  CONSTRAINT `shipment_route_segment_ibfk_5` FOREIGN KEY (`ORIGIN_TELECOM_CONTACT_MECH_ID`) REFERENCES `telecom_number` (`CONTACT_MECH_ID`),
  CONSTRAINT `shipment_route_segment_ibfk_6` FOREIGN KEY (`RETURN_POSTAL_CONTACT_MECH_ID`) REFERENCES `postal_address` (`CONTACT_MECH_ID`),
  CONSTRAINT `shipment_route_segment_ibfk_7` FOREIGN KEY (`DESTINATION_FACILITY_ID`) REFERENCES `facility` (`FACILITY_ID`),
  CONSTRAINT `shipment_route_segment_ibfk_8` FOREIGN KEY (`DEST_POSTAL_CONTACT_MECH_ID`) REFERENCES `postal_address` (`CONTACT_MECH_ID`),
  CONSTRAINT `shipment_route_segment_ibfk_9` FOREIGN KEY (`DEST_TELECOM_CONTACT_MECH_ID`) REFERENCES `telecom_number` (`CONTACT_MECH_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipment_system_message`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_system_message` (
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SYSTEM_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `EXTERNAL_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORIGIN_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPMENT_ID`,`SYSTEM_MESSAGE_ID`),
  KEY `IDXShipmentSystemMessageShipment` (`SHIPMENT_ID`),
  KEY `IDXShipmentSystemMessageSM` (`SYSTEM_MESSAGE_ID`),
  CONSTRAINT `shipment_system_message_ibfk_1` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipping_gateway_box_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipping_gateway_box_type` (
  `SHIPPING_GATEWAY_CONFIG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_BOX_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GATEWAY_BOX_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPPING_GATEWAY_CONFIG_ID`,`SHIPMENT_BOX_TYPE_ID`),
  KEY `IDXShippingGatewayBoxTypeShippingGatewayConfig` (`SHIPPING_GATEWAY_CONFIG_ID`),
  KEY `IDXShippingGatewayBoxTypeShipmentBT` (`SHIPMENT_BOX_TYPE_ID`),
  CONSTRAINT `shipping_gateway_box_type_ibfk_1` FOREIGN KEY (`SHIPMENT_BOX_TYPE_ID`) REFERENCES `shipment_box_type` (`SHIPMENT_BOX_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipping_gateway_carrier`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipping_gateway_carrier` (
  `SHIPPING_GATEWAY_CONFIG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CARRIER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GATEWAY_ACCOUNT_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPPING_GATEWAY_CONFIG_ID`,`CARRIER_PARTY_ID`),
  KEY `IDXShippingGatewayCarrierShippingGatewayConfig` (`SHIPPING_GATEWAY_CONFIG_ID`),
  KEY `IDXShippingGatewayCarrierCarrierParty` (`CARRIER_PARTY_ID`),
  CONSTRAINT `shipping_gateway_carrier_ibfk_1` FOREIGN KEY (`CARRIER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipping_gateway_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipping_gateway_config` (
  `SHIPPING_GATEWAY_CONFIG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPPING_GATEWAY_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GET_ORDER_RATE_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GET_SHIPPING_RATES_BULK_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GET_AUTO_PACKAGE_INFO_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GET_RATE_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUEST_LABELS_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REFUND_LABELS_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRACK_LABELS_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `VALIDATE_ADDRESS_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPPING_GATEWAY_CONFIG_ID`),
  KEY `IDXShippingGatewayConfigSGTypeEnumeration` (`SHIPPING_GATEWAY_TYPE_ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipping_gateway_method`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipping_gateway_method` (
  `SHIPPING_GATEWAY_CONFIG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CARRIER_PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SHIPMENT_METHOD_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `GATEWAY_SERVICE_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPPING_GATEWAY_CONFIG_ID`,`CARRIER_PARTY_ID`,`SHIPMENT_METHOD_ENUM_ID`),
  KEY `IDXShippingGatewayMethodShippingGatewayConfig` (`SHIPPING_GATEWAY_CONFIG_ID`),
  KEY `IDXShippingGatewayMethodCarrierParty` (`CARRIER_PARTY_ID`),
  KEY `IDXShippingGatewayMethodSmentMethodEnumeration` (`SHIPMENT_METHOD_ENUM_ID`),
  CONSTRAINT `shipping_gateway_method_ibfk_1` FOREIGN KEY (`SHIPPING_GATEWAY_CONFIG_ID`) REFERENCES `shipping_gateway_config` (`SHIPPING_GATEWAY_CONFIG_ID`),
  CONSTRAINT `shipping_gateway_method_ibfk_2` FOREIGN KEY (`CARRIER_PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shipping_gateway_option`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipping_gateway_option` (
  `SHIPPING_GATEWAY_CONFIG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `OPTION_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `OPTION_VALUE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SHIPPING_GATEWAY_CONFIG_ID`,`OPTION_ENUM_ID`),
  KEY `IDXShippingGatewayOptionShippingGatewayConfig` (`SHIPPING_GATEWAY_CONFIG_ID`),
  KEY `IDXShippingGatewayOptionSGOEnumera` (`OPTION_ENUM_ID`),
  CONSTRAINT `shipping_gateway_option_ibfk_1` FOREIGN KEY (`SHIPPING_GATEWAY_CONFIG_ID`) REFERENCES `shipping_gateway_config` (`SHIPPING_GATEWAY_CONFIG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `status_flow`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_flow` (
  `STATUS_FLOW_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`STATUS_FLOW_ID`),
  KEY `IDXStatusFlowStatusType` (`STATUS_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `status_flow_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_flow_item` (
  `STATUS_FLOW_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `IS_INITIAL` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`STATUS_FLOW_ID`,`STATUS_ID`),
  KEY `IDXStatusFlowItemStatusFlow` (`STATUS_FLOW_ID`),
  KEY `IDXStatusFlowItemStatusI` (`STATUS_ID`),
  CONSTRAINT `status_flow_item_ibfk_1` FOREIGN KEY (`STATUS_FLOW_ID`) REFERENCES `status_flow` (`STATUS_FLOW_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `status_flow_transition`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_flow_transition` (
  `STATUS_FLOW_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TO_STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TRANSITION_SEQUENCE` decimal(20,0) DEFAULT NULL,
  `TRANSITION_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONDITION_EXPRESSION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_PERMISSION_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`STATUS_FLOW_ID`,`STATUS_ID`,`TO_STATUS_ID`),
  KEY `IDXStatusFlowTransitionStatusFlow` (`STATUS_FLOW_ID`),
  KEY `IDXStatusFlowTransitionStatusItem` (`STATUS_ID`),
  KEY `IDXStatusFlowTransitionToStatusItem` (`TO_STATUS_ID`),
  CONSTRAINT `status_flow_transition_ibfk_1` FOREIGN KEY (`STATUS_FLOW_ID`) REFERENCES `status_flow` (`STATUS_FLOW_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `status_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_item` (
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `STATUS_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_CODE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`STATUS_ID`),
  KEY `IDXStatusItemStatusType` (`STATUS_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `status_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_type` (
  `STATUS_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PARENT_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`STATUS_TYPE_ID`),
  KEY `IDXStatusTypeParentST` (`PARENT_TYPE_ID`),
  CONSTRAINT `status_type_ibfk_1` FOREIGN KEY (`PARENT_TYPE_ID`) REFERENCES `status_type` (`STATUS_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subscreens_default`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscreens_default` (
  `SCREEN_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DEFAULT_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CONDITION_EXPRESSION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUBSCREEN_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SCREEN_LOCATION`,`DEFAULT_SEQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subscreens_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscreens_item` (
  `SCREEN_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SUBSCREEN_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SUBSCREEN_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MENU_TITLE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MENU_INDEX` decimal(20,0) DEFAULT NULL,
  `MENU_INCLUDE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MAKE_DEFAULT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NO_SUB_PATH` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SCREEN_LOCATION`,`SUBSCREEN_NAME`,`USER_GROUP_ID`),
  KEY `IDXSubscreensItemUserGroup` (`USER_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `system_message`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_message` (
  `SYSTEM_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SYSTEM_MESSAGE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SYSTEM_MESSAGE_REMOTE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IS_OUTGOING` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INIT_DATE` datetime(3) DEFAULT NULL,
  `PROCESSED_DATE` datetime(3) DEFAULT NULL,
  `LAST_ATTEMPT_DATE` datetime(3) DEFAULT NULL,
  `FAIL_COUNT` decimal(20,0) DEFAULT NULL,
  `PARENT_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACK_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REMOTE_MESSAGE_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MESSAGE_TEXT` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `SENDER_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECEIVER_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MESSAGE_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MESSAGE_DATE` datetime(3) DEFAULT NULL,
  `DOC_TYPE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DOC_SUB_TYPE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DOC_CONTROL` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DOC_SUB_CONTROL` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DOC_VERSION` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TRIGGER_VISIT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INVOICE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_PART_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ORDER_REVISION` decimal(20,0) DEFAULT NULL,
  `RETURN_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHIPMENT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SYSTEM_MESSAGE_ID`),
  KEY `SYS_MSG_MSGID` (`MESSAGE_ID`),
  KEY `SYS_MSG_RMSGID` (`REMOTE_MESSAGE_ID`),
  KEY `IDXSystemMessageSystemMessageType` (`SYSTEM_MESSAGE_TYPE_ID`),
  KEY `IDXSystemMessageSystemMessageRemote` (`SYSTEM_MESSAGE_REMOTE_ID`),
  KEY `IDXSystemMessageSMStatusItem` (`STATUS_ID`),
  KEY `IDXSystemMessageParentSM` (`PARENT_MESSAGE_ID`),
  KEY `IDXSystemMessageAckSM` (`ACK_MESSAGE_ID`),
  KEY `IDXSystemMessageTriggerVisit` (`TRIGGER_VISIT_ID`),
  KEY `IDXSystemMessageInvoic` (`INVOICE_ID`),
  KEY `IDXSystemMessageOrderHeader` (`ORDER_ID`),
  KEY `IDXSystemMessageReturnHeader` (`RETURN_ID`),
  KEY `IDXSystemMessageShipment` (`SHIPMENT_ID`),
  CONSTRAINT `system_message_ibfk_1` FOREIGN KEY (`STATUS_ID`) REFERENCES `status_item` (`STATUS_ID`),
  CONSTRAINT `system_message_ibfk_2` FOREIGN KEY (`PARENT_MESSAGE_ID`) REFERENCES `system_message` (`SYSTEM_MESSAGE_ID`),
  CONSTRAINT `system_message_ibfk_3` FOREIGN KEY (`ACK_MESSAGE_ID`) REFERENCES `system_message` (`SYSTEM_MESSAGE_ID`),
  CONSTRAINT `system_message_ibfk_4` FOREIGN KEY (`TRIGGER_VISIT_ID`) REFERENCES `visit` (`VISIT_ID`),
  CONSTRAINT `system_message_ibfk_5` FOREIGN KEY (`INVOICE_ID`) REFERENCES `invoice` (`INVOICE_ID`),
  CONSTRAINT `system_message_ibfk_6` FOREIGN KEY (`ORDER_ID`) REFERENCES `order_header` (`ORDER_ID`),
  CONSTRAINT `system_message_ibfk_7` FOREIGN KEY (`RETURN_ID`) REFERENCES `return_header` (`RETURN_ID`),
  CONSTRAINT `system_message_ibfk_8` FOREIGN KEY (`SHIPMENT_ID`) REFERENCES `shipment` (`SHIPMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `system_message_enum_map`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_message_enum_map` (
  `SYSTEM_MESSAGE_REMOTE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `MAPPED_VALUE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SYSTEM_MESSAGE_REMOTE_ID`,`ENUM_ID`),
  KEY `IDXSystemMessageEnumMapSystemMessageRemote` (`SYSTEM_MESSAGE_REMOTE_ID`),
  KEY `IDXSystemMessageEnumMapEnumeration` (`ENUM_ID`),
  CONSTRAINT `system_message_enum_map_ibfk_1` FOREIGN KEY (`ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `system_message_error`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_message_error` (
  `SYSTEM_MESSAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ERROR_DATE` datetime(3) NOT NULL,
  `ATTEMPTED_STATUS_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ERROR_TEXT` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SYSTEM_MESSAGE_ID`,`ERROR_DATE`),
  KEY `IDXSystemMessageErrorSystemMessage` (`SYSTEM_MESSAGE_ID`),
  CONSTRAINT `system_message_error_ibfk_1` FOREIGN KEY (`SYSTEM_MESSAGE_ID`) REFERENCES `system_message` (`SYSTEM_MESSAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `system_message_remote`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_message_remote` (
  `SYSTEM_MESSAGE_REMOTE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEND_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECEIVE_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REMOTE_CHARSET` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REMOTE_ATTRIBUTES` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEND_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USERNAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PUBLIC_KEY` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRIVATE_KEY` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REMOTE_PUBLIC_KEY` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SHARED_SECRET` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEND_SHARED_SECRET` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTH_HEADER_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `MESSAGE_AUTH_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEND_AUTH_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SYSTEM_MESSAGE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INTERNAL_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INTERNAL_ID_TYPE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INTERNAL_APP_CODE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REMOTE_ID` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REMOTE_ID_TYPE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REMOTE_APP_CODE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ACK_REQUESTED` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USAGE_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEGMENT_TERMINATOR` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ELEMENT_SEPARATOR` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `COMPONENT_DELIMITER` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ESCAPE_CHARACTER` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRE_AUTH_MESSAGE_REMOTE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCT_STORE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SYSTEM_MESSAGE_REMOTE_ID`),
  KEY `IDXSystemMessageRemoteSMAuthTypeEnumeration` (`MESSAGE_AUTH_ENUM_ID`),
  KEY `IDXSystemMessageRemoteSendMessageAuthTypeEnumeration` (`SEND_AUTH_ENUM_ID`),
  KEY `IDXSystemMessageRemoteSystemMessageTyp` (`SYSTEM_MESSAGE_TYPE_ID`),
  KEY `IDXSystemMessageRemotePreAuthSMR` (`PRE_AUTH_MESSAGE_REMOTE_ID`),
  KEY `IDXSystemMessageRemoteProductStor` (`PRODUCT_STORE_ID`),
  CONSTRAINT `system_message_remote_ibfk_1` FOREIGN KEY (`MESSAGE_AUTH_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `system_message_remote_ibfk_2` FOREIGN KEY (`SEND_AUTH_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `system_message_remote_ibfk_3` FOREIGN KEY (`PRE_AUTH_MESSAGE_REMOTE_ID`) REFERENCES `system_message_remote` (`SYSTEM_MESSAGE_REMOTE_ID`),
  CONSTRAINT `system_message_remote_ibfk_4` FOREIGN KEY (`PRODUCT_STORE_ID`) REFERENCES `product_store` (`PRODUCT_STORE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `system_message_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_message_type` (
  `SYSTEM_MESSAGE_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCE_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONSUME_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCE_ACK_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PRODUCE_ACK_ON_CONSUMED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEND_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECEIVE_SERVICE_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTENT_TYPE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECEIVE_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECEIVE_FILE_PATTERN` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECEIVE_RESPONSE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RECEIVE_MOVE_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEND_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`SYSTEM_MESSAGE_TYPE_ID`),
  KEY `IDXSystemMessageTypeMessageReceiveResponseEnumeration` (`RECEIVE_RESPONSE_ENUM_ID`),
  CONSTRAINT `system_message_type_ibfk_1` FOREIGN KEY (`RECEIVE_RESPONSE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `telecom_number`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `telecom_number` (
  `CONTACT_MECH_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `COUNTRY_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AREA_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CONTACT_NUMBER` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ASK_FOR_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`CONTACT_MECH_ID`),
  KEY `AREA_CONTACT_IDX` (`AREA_CODE`,`CONTACT_NUMBER`),
  KEY `IDXTelecomNumberContactMech` (`CONTACT_MECH_ID`),
  CONSTRAINT `telecom_number_ibfk_1` FOREIGN KEY (`CONTACT_MECH_ID`) REFERENCES `contact_mech` (`CONTACT_MECH_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_entity`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_entity` (
  `TEST_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `TEST_MEDIUM` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TEST_LONG` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TEST_INDICATOR` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TEST_DATE` date DEFAULT NULL,
  `TEST_DATE_TIME` datetime(3) DEFAULT NULL,
  `TEST_TIME` time DEFAULT NULL,
  `TEST_NUMBER_INTEGER` decimal(20,0) DEFAULT NULL,
  `TEST_NUMBER_DECIMAL` decimal(26,6) DEFAULT NULL,
  `TEST_NUMBER_FLOAT` decimal(32,12) DEFAULT NULL,
  `TEST_CURRENCY_AMOUNT` decimal(24,4) DEFAULT NULL,
  `TEST_CURRENCY_PRECISE` decimal(25,5) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`TEST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_int_pk`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_int_pk` (
  `INT_ID` decimal(20,0) NOT NULL,
  `TEST_MEDIUM` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`INT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uom`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uom` (
  `UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `UOM_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ABBREVIATION` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FRACTION_DIGITS` decimal(20,0) DEFAULT NULL,
  `SYMBOL` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`UOM_ID`),
  KEY `IDXUomUTypeEnumeration` (`UOM_TYPE_ENUM_ID`),
  CONSTRAINT `uom_ibfk_1` FOREIGN KEY (`UOM_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uom_conversion`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uom_conversion` (
  `UOM_CONVERSION_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TO_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `CONVERSION_FACTOR` decimal(32,12) DEFAULT NULL,
  `CONVERSION_OFFSET` decimal(26,6) DEFAULT NULL,
  `PURPOSE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`UOM_CONVERSION_ID`),
  KEY `IDXUomConversionUom` (`UOM_ID`),
  KEY `IDXUomConversionToUom` (`TO_UOM_ID`),
  KEY `IDXUomConversionUCPurposeEnumerat` (`PURPOSE_ENUM_ID`),
  CONSTRAINT `uom_conversion_ibfk_1` FOREIGN KEY (`UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `uom_conversion_ibfk_2` FOREIGN KEY (`TO_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `uom_conversion_ibfk_3` FOREIGN KEY (`PURPOSE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uom_dim_type_group_member`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uom_dim_type_group_member` (
  `UOM_DIM_TYPE_GROUP_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `UOM_DIMENSION_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`UOM_DIM_TYPE_GROUP_ENUM_ID`,`UOM_DIMENSION_TYPE_ID`),
  KEY `IDXUomDimTypeGroupMemberUDTGEnumeration` (`UOM_DIM_TYPE_GROUP_ENUM_ID`),
  KEY `IDXUomDimTypeGroupMemberUomDimensionType` (`UOM_DIMENSION_TYPE_ID`),
  CONSTRAINT `uom_dim_type_group_member_ibfk_1` FOREIGN KEY (`UOM_DIM_TYPE_GROUP_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uom_dimension_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uom_dimension_type` (
  `UOM_DIMENSION_TYPE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `UOM_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DEFAULT_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`UOM_DIMENSION_TYPE_ID`),
  KEY `IDXUomDimensionTypeUTypeEnumeration` (`UOM_TYPE_ENUM_ID`),
  KEY `IDXUomDimensionTypeDefaultUom` (`DEFAULT_UOM_ID`),
  CONSTRAINT `uom_dimension_type_ibfk_1` FOREIGN KEY (`UOM_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `uom_dimension_type_ibfk_2` FOREIGN KEY (`DEFAULT_UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `uom_group_member`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uom_group_member` (
  `UOM_GROUP_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`UOM_GROUP_ENUM_ID`,`UOM_ID`),
  KEY `IDXUomGroupMemberUGEnumeration` (`UOM_GROUP_ENUM_ID`),
  KEY `IDXUomGroupMemberUom` (`UOM_ID`),
  CONSTRAINT `uom_group_member_ibfk_1` FOREIGN KEY (`UOM_GROUP_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `uom_group_member_ibfk_2` FOREIGN KEY (`UOM_ID`) REFERENCES `uom` (`UOM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_account`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_account` (
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USERNAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_FULL_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CURRENT_PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESET_PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PASSWORD_SALT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PASSWORD_HASH_TYPE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PASSWORD_BASE64` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PASSWORD_SET_DATE` datetime(3) DEFAULT NULL,
  `PASSWORD_HINT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PUBLIC_KEY` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `HAS_LOGGED_OUT` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DISABLED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DISABLED_DATE_TIME` datetime(3) DEFAULT NULL,
  `TERMINATE_DATE` datetime(3) DEFAULT NULL,
  `SUCCESSIVE_FAILED_LOGINS` decimal(20,0) DEFAULT NULL,
  `REQUIRE_PASSWORD_CHANGE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CURRENCY_UOM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LOCALE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TIME_ZONE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EXTERNAL_USER_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `EMAIL_ADDRESS` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IP_ALLOWED` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARTY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_ID`),
  UNIQUE KEY `USERACCT_USERNAME` (`USERNAME`),
  UNIQUE KEY `USERACCT_EMAILADDR` (`EMAIL_ADDRESS`),
  KEY `IDXUserAccountCurrencyUom` (`CURRENCY_UOM_ID`),
  KEY `IDXUserAccountParty` (`PARTY_ID`),
  CONSTRAINT `user_account_ibfk_1` FOREIGN KEY (`CURRENCY_UOM_ID`) REFERENCES `uom` (`UOM_ID`),
  CONSTRAINT `user_account_ibfk_2` FOREIGN KEY (`PARTY_ID`) REFERENCES `party` (`PARTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_authc_factor`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_authc_factor` (
  `FACTOR_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_FACTOR_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FACTOR_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `FACTOR_OPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `NEEDS_VALIDATION` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`FACTOR_ID`),
  KEY `IDXUserAuthcFactorUAFTypeEnumeration` (`FACTOR_TYPE_ENUM_ID`),
  CONSTRAINT `user_authc_factor_ibfk_1` FOREIGN KEY (`FACTOR_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_group` (
  `USER_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GROUP_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `IP_ALLOWED` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `REQUIRE_AUTHC_FACTOR` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_GROUP_ID`),
  KEY `IDXUserGroupUGTypeEnumeration` (`GROUP_TYPE_ENUM_ID`),
  CONSTRAINT `user_group_ibfk_1` FOREIGN KEY (`GROUP_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_group_member`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_group_member` (
  `USER_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_GROUP_ID`,`USER_ID`,`FROM_DATE`),
  KEY `IDXUserGroupMemberUserGroup` (`USER_GROUP_ID`),
  CONSTRAINT `user_group_member_ibfk_1` FOREIGN KEY (`USER_GROUP_ID`) REFERENCES `user_group` (`USER_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_group_permission`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_group_permission` (
  `USER_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_PERMISSION_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_GROUP_ID`,`USER_PERMISSION_ID`,`FROM_DATE`),
  KEY `IDXUserGroupPermissionUserGroup` (`USER_GROUP_ID`),
  CONSTRAINT `user_group_permission_ibfk_1` FOREIGN KEY (`USER_GROUP_ID`) REFERENCES `user_group` (`USER_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_group_preference`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_group_preference` (
  `USER_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PREFERENCE_KEY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PREFERENCE_VALUE` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `GROUP_PRIORITY` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_GROUP_ID`,`PREFERENCE_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_group_screen_theme`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_group_screen_theme` (
  `USER_GROUP_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SCREEN_THEME_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SCREEN_THEME_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_GROUP_ID`,`SCREEN_THEME_TYPE_ENUM_ID`),
  KEY `IDXUserGroupScreenThemeScreenThemeTypeEnumeration` (`SCREEN_THEME_TYPE_ENUM_ID`),
  KEY `IDXUserGroupScreenThemeST` (`SCREEN_THEME_ID`),
  CONSTRAINT `user_group_screen_theme_ibfk_1` FOREIGN KEY (`SCREEN_THEME_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `user_group_screen_theme_ibfk_2` FOREIGN KEY (`SCREEN_THEME_ID`) REFERENCES `screen_theme` (`SCREEN_THEME_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_login_history`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_login_history` (
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `VISIT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PASSWORD_USED` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUCCESSFUL_LOGIN` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_ID`,`FROM_DATE`),
  KEY `IDXUserLoginHistoryVisit` (`VISIT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_login_key`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_login_key` (
  `LOGIN_KEY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`LOGIN_KEY`),
  KEY `IDXUserLoginKeyUserAccount` (`USER_ID`),
  CONSTRAINT `user_login_key_ibfk_1` FOREIGN KEY (`USER_ID`) REFERENCES `user_account` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_password_history`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_password_history` (
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) NOT NULL,
  `PASSWORD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PASSWORD_SALT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PASSWORD_HASH_TYPE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_ID`,`FROM_DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_permission`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_permission` (
  `USER_PERMISSION_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_PERMISSION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_preference`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_preference` (
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PREFERENCE_KEY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `PREFERENCE_VALUE` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_ID`,`PREFERENCE_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_screen_theme`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_screen_theme` (
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SCREEN_THEME_TYPE_ENUM_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SCREEN_THEME_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`USER_ID`,`SCREEN_THEME_TYPE_ENUM_ID`),
  KEY `IDXUserScreenThemeScreenThemeTypeEnumeration` (`SCREEN_THEME_TYPE_ENUM_ID`),
  KEY `IDXUserScreenThemeST` (`SCREEN_THEME_ID`),
  CONSTRAINT `user_screen_theme_ibfk_1` FOREIGN KEY (`SCREEN_THEME_TYPE_ENUM_ID`) REFERENCES `enumeration` (`ENUM_ID`),
  CONSTRAINT `user_screen_theme_ibfk_2` FOREIGN KEY (`SCREEN_THEME_ID`) REFERENCES `screen_theme` (`SCREEN_THEME_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `visit`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visit` (
  `VISIT_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `VISITOR_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_CREATED` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SESSION_ID` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVER_IP_ADDRESS` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SERVER_HOST_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `WEBAPP_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INITIAL_LOCALE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INITIAL_REQUEST` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INITIAL_REFERRER` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `INITIAL_USER_AGENT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_IP_ADDRESS` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_HOST_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_USER` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_IP_ISP_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_IP_POSTAL_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_IP_CITY` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_IP_METRO_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_IP_REGION_CODE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_IP_REGION_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_IP_STATE_PROV_GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_IP_COUNTRY_GEO_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_IP_LATITUDE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_IP_LONGITUDE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CLIENT_IP_TIME_ZONE` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`VISIT_ID`),
  KEY `VISIT_USER_ACC` (`USER_ID`),
  KEY `VISIT_VISITOR` (`VISITOR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `visitor`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visitor` (
  `VISITOR_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CREATED_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`VISITOR_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wiki_blog`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wiki_blog` (
  `WIKI_BLOG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WIKI_PAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `TITLE` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `AUTHOR` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SUMMARY` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PUBLISH_DATE` datetime(3) DEFAULT NULL,
  `META_KEYWORDS` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `META_DESCRIPTION` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SMALL_IMAGE_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WIKI_BLOG_ID`),
  KEY `IDXWikiBlogWikiPage` (`WIKI_PAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wiki_blog_category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wiki_blog_category` (
  `WIKI_PAGE_CATEGORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WIKI_BLOG_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `SENT_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WIKI_PAGE_CATEGORY_ID`,`WIKI_BLOG_ID`),
  KEY `IDXWikiBlogCategoryWikiPageC` (`WIKI_PAGE_CATEGORY_ID`),
  KEY `IDXWikiBlogCategoryWikiBlog` (`WIKI_BLOG_ID`),
  CONSTRAINT `wiki_blog_category_ibfk_1` FOREIGN KEY (`WIKI_BLOG_ID`) REFERENCES `wiki_blog` (`WIKI_BLOG_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wiki_page`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wiki_page` (
  `WIKI_PAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WIKI_SPACE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PAGE_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PARENT_WIKI_PAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SEQUENCE_NUM` decimal(20,0) DEFAULT NULL,
  `CREATED_BY_USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PUBLISHED_VERSION_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESTRICT_VIEW` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESTRICT_UPDATE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WIKI_PAGE_ID`),
  UNIQUE KEY `WIKIPAGE_SPCPTH` (`WIKI_SPACE_ID`,`PAGE_PATH`),
  KEY `IDXWikiPageWikiSpace` (`WIKI_SPACE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wiki_page_alias`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wiki_page_alias` (
  `WIKI_SPACE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ALIAS_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WIKI_PAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WIKI_SPACE_ID`,`ALIAS_PATH`),
  KEY `IDXWikiPageAliasWikiSpace` (`WIKI_SPACE_ID`),
  KEY `IDXWikiPageAliasWikiPage` (`WIKI_PAGE_ID`),
  CONSTRAINT `wiki_page_alias_ibfk_1` FOREIGN KEY (`WIKI_PAGE_ID`) REFERENCES `wiki_page` (`WIKI_PAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wiki_page_category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wiki_page_category` (
  `WIKI_PAGE_CATEGORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `CATEGORY_NAME` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WIKI_PAGE_CATEGORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wiki_page_category_member`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wiki_page_category_member` (
  `WIKI_PAGE_CATEGORY_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `WIKI_PAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `FROM_DATE` datetime(3) DEFAULT NULL,
  `THRU_DATE` datetime(3) DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WIKI_PAGE_CATEGORY_ID`,`WIKI_PAGE_ID`),
  KEY `IDXWikiPageCategoryMemberWikiPageCategory` (`WIKI_PAGE_CATEGORY_ID`),
  KEY `IDXWikiPageCategoryMemberWikiPage` (`WIKI_PAGE_ID`),
  CONSTRAINT `wiki_page_category_member_ibfk_1` FOREIGN KEY (`WIKI_PAGE_CATEGORY_ID`) REFERENCES `wiki_page_category` (`WIKI_PAGE_CATEGORY_ID`),
  CONSTRAINT `wiki_page_category_member_ibfk_2` FOREIGN KEY (`WIKI_PAGE_ID`) REFERENCES `wiki_page` (`WIKI_PAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wiki_page_history`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wiki_page_history` (
  `WIKI_PAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `HISTORY_SEQ_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `OLD_PAGE_PATH` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `CHANGE_DATE_TIME` datetime(3) DEFAULT NULL,
  `VERSION_NAME` varchar(63) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WIKI_PAGE_ID`,`HISTORY_SEQ_ID`),
  KEY `IDXWikiPageHistoryWikiPage` (`WIKI_PAGE_ID`),
  CONSTRAINT `wiki_page_history_ibfk_1` FOREIGN KEY (`WIKI_PAGE_ID`) REFERENCES `wiki_page` (`WIKI_PAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wiki_page_user`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wiki_page_user` (
  `WIKI_PAGE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RECEIVE_NOTIFICATIONS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOW_VIEW` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOW_UPDATE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WIKI_PAGE_ID`,`USER_ID`),
  KEY `IDXWikiPageUserWikiPage` (`WIKI_PAGE_ID`),
  CONSTRAINT `wiki_page_user_ibfk_1` FOREIGN KEY (`WIKI_PAGE_ID`) REFERENCES `wiki_page` (`WIKI_PAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wiki_space`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wiki_space` (
  `WIKI_SPACE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `DESCRIPTION` varchar(4095) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ROOT_PAGE_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `DECORATOR_SCREEN_LOCATION` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PUBLIC_PAGE_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PUBLIC_ATTACHMENT_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `PUBLIC_BLOG_URL` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESTRICT_VIEW` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `RESTRICT_UPDATE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOW_ANY_HTML` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `SCREEN_THEME_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WIKI_SPACE_ID`),
  KEY `IDXWikiSpaceScreenTheme` (`SCREEN_THEME_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wiki_space_user`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wiki_space_user` (
  `WIKI_SPACE_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `USER_ID` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `RECEIVE_NOTIFICATIONS` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOW_ADMIN` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOW_VIEW` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `ALLOW_UPDATE` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `LAST_UPDATED_STAMP` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`WIKI_SPACE_ID`,`USER_ID`),
  KEY `IDXWikiSpaceUserWikiSpace` (`WIKI_SPACE_ID`),
  CONSTRAINT `wiki_space_user_ibfk_1` FOREIGN KEY (`WIKI_SPACE_ID`) REFERENCES `wiki_space` (`WIKI_SPACE_ID`)
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

-- Dump completed on 2024-01-23 18:32:41
