
--
-- Table structure for table `goods_receipt_items`
--

DROP TABLE IF EXISTS `goods_receipt_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goods_receipt_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `grn_id` int NOT NULL,
  `po_item_id` int DEFAULT NULL,
  `item_id` int NOT NULL,
  `quantity_received` decimal(10,2) NOT NULL,
  `quantity_damaged` decimal(10,2) DEFAULT '0.00',
  `unit_cost` decimal(10,2) NOT NULL,
  `total_cost` decimal(10,2) NOT NULL,
  `batch_number` varchar(100) DEFAULT NULL,
  `lot_number` varchar(100) DEFAULT NULL,
  `manufacturing_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `po_item_id` (`po_item_id`),
  KEY `item_id` (`item_id`),
  KEY `grn_id` (`grn_id`),
  CONSTRAINT `goods_receipt_items_ibfk_1` FOREIGN KEY (`grn_id`) REFERENCES `goods_receipts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `goods_receipt_items_ibfk_2` FOREIGN KEY (`po_item_id`) REFERENCES `purchase_order_items` (`id`) ON DELETE SET NULL,
  CONSTRAINT `goods_receipt_items_ibfk_3` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goods_receipt_items`
--

LOCK TABLES `goods_receipt_items` WRITE;
/*!40000 ALTER TABLE `goods_receipt_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `goods_receipt_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goods_receipts`
--

DROP TABLE IF EXISTS `goods_receipts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goods_receipts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `grn_number` varchar(50) NOT NULL,
  `po_id` int DEFAULT NULL,
  `vendor_id` int NOT NULL,
  `receipt_date` date NOT NULL,
  `invoice_number` varchar(100) DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tax_amount` decimal(10,2) DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `received_by` int NOT NULL,
  `approved_by` int DEFAULT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `grn_number` (`grn_number`),
  KEY `po_id` (`po_id`),
  KEY `vendor_id` (`vendor_id`),
  KEY `received_by` (`received_by`),
  KEY `approved_by` (`approved_by`),
  KEY `status` (`status`),
  CONSTRAINT `goods_receipts_ibfk_1` FOREIGN KEY (`po_id`) REFERENCES `purchase_orders` (`id`) ON DELETE SET NULL,
  CONSTRAINT `goods_receipts_ibfk_2` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `goods_receipts_ibfk_3` FOREIGN KEY (`received_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `goods_receipts_ibfk_4` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


LOCK TABLES `infrastructure` WRITE;
/*!40000 ALTER TABLE `infrastructure` DISABLE KEYS */;
INSERT INTO `infrastructure` VALUES (3,'RM-001','Room','A Block',0,0,1,'Available','2026-04-08 02:37:03'),(4,'RM-002','Room','A Block',0,0,1,'Available','2026-04-08 02:37:16'),(5,'Main Lab','Lab','A Block',0,NULL,1,'Available','2026-04-15 17:07:48'),(6,'Block Lab','Lab','Block B',1,NULL,1,'Available','2026-04-15 17:22:21'),(7,'Emergency Lab','Lab','Block C',1,NULL,1,'Available','2026-04-17 11:46:45');
/*!40000 ALTER TABLE `infrastructure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_batches`
--

DROP TABLE IF EXISTS `inventory_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_batches` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_id` int NOT NULL,
  `batch_number` varchar(100) NOT NULL,
  `lot_number` varchar(100) DEFAULT NULL,
  `manufacturing_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `vendor_id` int DEFAULT NULL,
  `quantity_received` decimal(10,2) NOT NULL DEFAULT '0.00',
  `quantity_available` decimal(10,2) NOT NULL DEFAULT '0.00',
  `quantity_reserved` decimal(10,2) NOT NULL DEFAULT '0.00',
  `quantity_damaged` decimal(10,2) NOT NULL DEFAULT '0.00',
  `unit_cost` decimal(10,2) NOT NULL DEFAULT '0.00',
  `grn_id` int DEFAULT NULL,
  `status` enum('Active','Quarantine','Expired','Empty') DEFAULT 'Active',
  `open_vial_date` date DEFAULT NULL,
  `stability_days` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `vendor_id` (`vendor_id`),
  KEY `item_id` (`item_id`),
  KEY `batch_number` (`batch_number`),
  KEY `expiry_date` (`expiry_date`),
  KEY `status` (`status`),
  CONSTRAINT `inventory_batches_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inventory_batches_ibfk_2` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_batches`
--

LOCK TABLES `inventory_batches` WRITE;
/*!40000 ALTER TABLE `inventory_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_consumption_logs`
--

DROP TABLE IF EXISTS `inventory_consumption_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_consumption_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `test_result_id` int NOT NULL,
  `bill_item_id` int NOT NULL,
  `sample_id` varchar(50) NOT NULL,
  `item_id` int NOT NULL,
  `batch_id` int DEFAULT NULL,
  `quantity_consumed` decimal(10,3) NOT NULL,
  `consumed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `consumed_by` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bill_item_id` (`bill_item_id`),
  KEY `item_id` (`item_id`),
  KEY `batch_id` (`batch_id`),
  KEY `consumed_by` (`consumed_by`),
  KEY `test_result_id` (`test_result_id`),
  KEY `sample_id` (`sample_id`),
  KEY `consumed_at` (`consumed_at`),
  CONSTRAINT `inventory_consumption_logs_ibfk_1` FOREIGN KEY (`test_result_id`) REFERENCES `lab_test_result` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inventory_consumption_logs_ibfk_2` FOREIGN KEY (`bill_item_id`) REFERENCES `bill_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inventory_consumption_logs_ibfk_3` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `inventory_consumption_logs_ibfk_4` FOREIGN KEY (`batch_id`) REFERENCES `inventory_batches` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inventory_consumption_logs_ibfk_5` FOREIGN KEY (`consumed_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_consumption_logs`
--

LOCK TABLES `inventory_consumption_logs` WRITE;
/*!40000 ALTER TABLE `inventory_consumption_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_consumption_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_items`
--

DROP TABLE IF EXISTS `inventory_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_code` varchar(50) NOT NULL,
  `item_name` varchar(200) NOT NULL,
  `category` enum('Reagents','Consumables','Test Kits','Calibrators','Controls','Glassware','General Lab Supplies') NOT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `manufacturer` varchar(200) DEFAULT NULL,
  `unit` enum('ml','liter','test','box','pack','piece','mg','g','kg') NOT NULL,
  `min_stock_level` decimal(10,2) NOT NULL DEFAULT '0.00',
  `reorder_level` decimal(10,2) NOT NULL DEFAULT '0.00',
  `storage_condition` varchar(200) DEFAULT NULL,
  `cost_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `selling_cost` decimal(10,2) NOT NULL DEFAULT '0.00',
  `expiry_required` tinyint(1) DEFAULT '0',
  `lot_tracking` tinyint(1) DEFAULT '0',
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `item_code` (`item_code`),
  KEY `category` (`category`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_items`
--

LOCK TABLES `inventory_items` WRITE;
/*!40000 ALTER TABLE `inventory_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_stock`
--

DROP TABLE IF EXISTS `inventory_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_id` int NOT NULL,
  `current_stock` decimal(10,2) NOT NULL DEFAULT '0.00',
  `available_stock` decimal(10,2) NOT NULL DEFAULT '0.00',
  `reserved_stock` decimal(10,2) NOT NULL DEFAULT '0.00',
  `consumed_stock` decimal(10,2) NOT NULL DEFAULT '0.00',
  `expired_stock` decimal(10,2) NOT NULL DEFAULT '0.00',
  `damaged_stock` decimal(10,2) NOT NULL DEFAULT '0.00',
  `department_id` int DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_item_dept` (`item_id`,`department_id`),
  KEY `department_id` (`department_id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `inventory_stock_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inventory_stock_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `infrastructure` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_stock`
--

LOCK TABLES `inventory_stock` WRITE;
/*!40000 ALTER TABLE `inventory_stock` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_transactions`
--

DROP TABLE IF EXISTS `inventory_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transaction_type` enum('Stock In','Stock Out','Adjustment','Transfer','Return','Consumption') NOT NULL,
  `item_id` int NOT NULL,
  `batch_id` int DEFAULT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `unit_cost` decimal(10,2) DEFAULT NULL,
  `reference_type` enum('GRN','PO','PR','Test','Adjustment','Transfer','Return','Manual') DEFAULT NULL,
  `reference_id` int DEFAULT NULL,
  `from_department` int DEFAULT NULL,
  `to_department` int DEFAULT NULL,
  `performed_by` int NOT NULL,
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `batch_id` (`batch_id`),
  KEY `from_department` (`from_department`),
  KEY `to_department` (`to_department`),
  KEY `performed_by` (`performed_by`),
  KEY `item_id` (`item_id`),
  KEY `transaction_type` (`transaction_type`),
  KEY `created_at` (`created_at`),
  CONSTRAINT `inventory_transactions_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `inventory_transactions_ibfk_2` FOREIGN KEY (`batch_id`) REFERENCES `inventory_batches` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inventory_transactions_ibfk_3` FOREIGN KEY (`from_department`) REFERENCES `infrastructure` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inventory_transactions_ibfk_4` FOREIGN KEY (`to_department`) REFERENCES `infrastructure` (`id`) ON DELETE SET NULL,
  CONSTRAINT `inventory_transactions_ibfk_5` FOREIGN KEY (`performed_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_transactions`
--

LOCK TABLES `inventory_transactions` WRITE;
/*!40000 ALTER TABLE `inventory_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lab_categories`
--

--
-- Table structure for table `lab_machines`
--

DROP TABLE IF EXISTS `lab_machines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lab_machines` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lab_id` int NOT NULL,
  `machine_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `model` varchar(100) DEFAULT NULL,
  `manufacturer` varchar(100) DEFAULT NULL,
  `status` enum('Active','Inactive','Maintenance') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_machine_id` (`lab_id`,`machine_id`),
  KEY `lab_id` (`lab_id`),
  CONSTRAINT `lab_machines_ibfk_1` FOREIGN KEY (`lab_id`) REFERENCES `infrastructure` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lab_machines`
--

LOCK TABLES `lab_machines` WRITE;
/*!40000 ALTER TABLE `lab_machines` DISABLE KEYS */;
INSERT INTO `lab_machines` VALUES (1,4,'ANAL-001','A','Cliniquant Micro','Meril','Active','2026-04-17 01:43:07','2026-04-17 01:43:07'),(2,6,'123','A','q2`','qwqw','Active','2026-04-17 02:09:15','2026-04-17 02:09:15');


--
-- Table structure for table `lab_test_parameters`
--


--
-- Table structure for table `purchase_order_items`
--

DROP TABLE IF EXISTS `purchase_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `po_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity_ordered` decimal(10,2) NOT NULL,
  `quantity_received` decimal(10,2) DEFAULT '0.00',
  `quantity_damaged` decimal(10,2) DEFAULT '0.00',
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  KEY `po_id` (`po_id`),
  CONSTRAINT `purchase_order_items_ibfk_1` FOREIGN KEY (`po_id`) REFERENCES `purchase_orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `purchase_order_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order_items`
--

LOCK TABLES `purchase_order_items` WRITE;
/*!40000 ALTER TABLE `purchase_order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_orders`
--

DROP TABLE IF EXISTS `purchase_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `po_number` varchar(50) NOT NULL,
  `pr_id` int DEFAULT NULL,
  `vendor_id` int NOT NULL,
  `order_date` date NOT NULL,
  `expected_delivery` date DEFAULT NULL,
  `delivery_location` int DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tax_amount` decimal(10,2) DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `terms_conditions` text,
  `status` enum('Draft','Sent','Partially Received','Fully Received','Cancelled') DEFAULT 'Draft',
  `created_by` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `po_number` (`po_number`),
  KEY `pr_id` (`pr_id`),
  KEY `vendor_id` (`vendor_id`),
  KEY `delivery_location` (`delivery_location`),
  KEY `created_by` (`created_by`),
  KEY `status` (`status`),
  CONSTRAINT `purchase_orders_ibfk_1` FOREIGN KEY (`pr_id`) REFERENCES `purchase_requisitions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `purchase_orders_ibfk_2` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `purchase_orders_ibfk_3` FOREIGN KEY (`delivery_location`) REFERENCES `infrastructure` (`id`) ON DELETE SET NULL,
  CONSTRAINT `purchase_orders_ibfk_4` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `purchase_requisition_items`
--

DROP TABLE IF EXISTS `purchase_requisition_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_requisition_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pr_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity_requested` decimal(10,2) NOT NULL,
  `quantity_approved` decimal(10,2) DEFAULT NULL,
  `unit_price` decimal(10,2) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `notes` text,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  KEY `pr_id` (`pr_id`),
  CONSTRAINT `purchase_requisition_items_ibfk_1` FOREIGN KEY (`pr_id`) REFERENCES `purchase_requisitions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `purchase_requisition_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_requisition_items`
--

LOCK TABLES `purchase_requisition_items` WRITE;
/*!40000 ALTER TABLE `purchase_requisition_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_requisition_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_requisitions`
--

DROP TABLE IF EXISTS `purchase_requisitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_requisitions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pr_number` varchar(50) NOT NULL,
  `department_id` int DEFAULT NULL,
  `requested_by` int NOT NULL,
  `request_date` date NOT NULL,
  `required_date` date DEFAULT NULL,
  `priority` enum('Low','Normal','High','Urgent') DEFAULT 'Normal',
  `total_amount` decimal(10,2) DEFAULT '0.00',
  `status` enum('Draft','Submitted','Approved','Rejected','Converted to PO') DEFAULT 'Draft',
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pr_number` (`pr_number`),
  KEY `requested_by` (`requested_by`),
  KEY `department_id` (`department_id`),
  KEY `status` (`status`),
  CONSTRAINT `purchase_requisitions_ibfk_1` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `purchase_requisitions_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `infrastructure` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_requisitions`
--

LOCK TABLES `purchase_requisitions` WRITE;
/*!40000 ALTER TABLE `purchase_requisitions` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_requisitions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reagent_test_mapping`
--

DROP TABLE IF EXISTS `reagent_test_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reagent_test_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `test_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity_per_test` decimal(10,3) NOT NULL,
  `unit` enum('ml','liter','test','box','pack','piece','mg','g','kg') NOT NULL,
  `notes` text,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_test_item` (`test_id`,`item_id`),
  KEY `test_id` (`test_id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `reagent_test_mapping_ibfk_1` FOREIGN KEY (`test_id`) REFERENCES `lab_tests` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reagent_test_mapping_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;




DROP TABLE IF EXISTS `stock_transfer_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_transfer_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transfer_id` int NOT NULL,
  `item_id` int NOT NULL,
  `batch_id` int DEFAULT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `received_quantity` decimal(10,2) DEFAULT '0.00',
  `damaged_quantity` decimal(10,2) DEFAULT '0.00',
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  KEY `batch_id` (`batch_id`),
  KEY `transfer_id` (`transfer_id`),
  CONSTRAINT `stock_transfer_items_ibfk_1` FOREIGN KEY (`transfer_id`) REFERENCES `stock_transfers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `stock_transfer_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `stock_transfer_items_ibfk_3` FOREIGN KEY (`batch_id`) REFERENCES `inventory_batches` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_transfer_items`
--

LOCK TABLES `stock_transfer_items` WRITE;
/*!40000 ALTER TABLE `stock_transfer_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_transfer_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_transfers`
--

DROP TABLE IF EXISTS `stock_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_transfers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transfer_number` varchar(50) NOT NULL,
  `from_department` int NOT NULL,
  `to_department` int NOT NULL,
  `transfer_date` date NOT NULL,
  `status` enum('Pending','In Transit','Received','Cancelled') DEFAULT 'Pending',
  `requested_by` int NOT NULL,
  `approved_by` int DEFAULT NULL,
  `received_by` int DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transfer_number` (`transfer_number`),
  KEY `from_department` (`from_department`),
  KEY `to_department` (`to_department`),
  KEY `requested_by` (`requested_by`),
  KEY `approved_by` (`approved_by`),
  KEY `received_by` (`received_by`),
  CONSTRAINT `stock_transfers_ibfk_1` FOREIGN KEY (`from_department`) REFERENCES `infrastructure` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `stock_transfers_ibfk_2` FOREIGN KEY (`to_department`) REFERENCES `infrastructure` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `stock_transfers_ibfk_3` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `stock_transfers_ibfk_4` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `stock_transfers_ibfk_5` FOREIGN KEY (`received_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_transfers`
--

LOCK TABLES `stock_transfers` WRITE;
/*!40000 ALTER TABLE `stock_transfers` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_transfers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;


LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Steve','Jerald','steve@mail.com','+91 9025740156','doctor','emergency','HMS-101','$2a$10$20lfC0bP8gMKqh8k4s4b7e93gwZxJbpevxLGkNeK7kLodt5T6s8sq','2026-04-07 04:28:20'),(2,'Vasanth','Sandeep','sandeep@mail.com','','Doctor','Emergency','STF-3988','$2a$10$9ciPdoYrFucePOQ6Rp5/Puw4IIfnOxYbhJuaNx77.b5Sux6djVv6a','2026-04-07 09:07:36');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;


LOCK TABLES `vendors` WRITE;
/*!40000 ALTER TABLE `vendors` DISABLE KEYS */;
INSERT INTO `vendors` VALUES (1,'VEN001','Default Vendor','Admin','0000000000','vendor@hims.com','Default Address',NULL,NULL,7,'Active','2026-04-18 07:08:17','2026-04-18 07:08:17');
/*!40000 ALTER TABLE `vendors` ENABLE KEYS */;
UNLOCK TABLES;
/
