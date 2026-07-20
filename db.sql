-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Jul 04, 2026 at 05:05 AM
-- Server version: 8.0.44
-- PHP Version: 8.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `meril-hims`
--

-- --------------------------------------------------------

--
-- Table structure for table `abdm_care_context`
--

CREATE TABLE `abdm_care_context` (
  `id` bigint NOT NULL,
  `request_id` varchar(255) NOT NULL,
  `patient_id` bigint DEFAULT NULL,
  `abha_number` varchar(50) DEFAULT NULL,
  `care_context_ref` varchar(100) NOT NULL,
  `display` varchar(255) DEFAULT NULL,
  `link_status` varchar(50) NOT NULL DEFAULT 'PENDING',
  `error` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `abdm_care_context`
--

INSERT INTO `abdm_care_context` (`id`, `request_id`, `patient_id`, `abha_number`, `care_context_ref`, `display`, `link_status`, `error`, `created_at`, `updated_at`) VALUES
(1, '7f940400-e2a2-419f-ab27-c3ba3d8199e0', 6, '91534661642817', 'CONSULT-5', 'OPD Visit - 28 Jun 2026', 'PENDING', NULL, '2026-06-28 12:55:09', '2026-06-28 12:55:09'),
(2, '66f23fbf-424a-4b30-81ae-ae5a93781f26', 8, '91534661642817', 'CONSULT-7', 'OPD Visit - 28 Jun 2026', 'PENDING', NULL, '2026-06-28 13:05:42', '2026-06-28 13:05:42'),
(3, '66f23fbf-424a-4b30-81ae-ae5a93781f26', 8, '91534661642817', 'PRESC-7', 'Prescription - 28 Jun 2026', 'PENDING', NULL, '2026-06-28 13:05:42', '2026-06-28 13:05:42'),
(4, '66f23fbf-424a-4b30-81ae-ae5a93781f26', 8, '91534661642817', 'LAB-7', 'Lab Orders - 28 Jun 2026', 'PENDING', NULL, '2026-06-28 13:05:42', '2026-06-28 13:05:42'),
(5, '34d8d6e3-b5a2-4f92-932c-5208bd94cff0', 10, '91534661642817', 'CONSULT-9', 'OPD Visit: Fever  viral  bacterial  to investiga - 30 Jun 2026', 'PENDING', NULL, '2026-06-29 19:51:01', '2026-06-29 19:51:01'),
(6, '34d8d6e3-b5a2-4f92-932c-5208bd94cff0', 10, '91534661642817', 'PRESC-9', 'Prescription - 30 Jun 2026', 'PENDING', NULL, '2026-06-29 19:51:01', '2026-06-29 19:51:01');

-- --------------------------------------------------------

--
-- Table structure for table `abdm_consents`
--

CREATE TABLE `abdm_consents` (
  `id` bigint NOT NULL,
  `consent_id` varchar(255) NOT NULL,
  `status` varchar(50) DEFAULT NULL,
  `consent_detail` json DEFAULT NULL,
  `signature` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `consent_request_id` varchar(255) DEFAULT NULL,
  `consent_artifact_id` varchar(255) DEFAULT NULL,
  `abha_address` varchar(255) DEFAULT NULL,
  `raw_payload` json DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `abdm_consents`
--

INSERT INTO `abdm_consents` (`id`, `consent_id`, `status`, `consent_detail`, `signature`, `created_at`, `updated_at`, `consent_request_id`, `consent_artifact_id`, `abha_address`, `raw_payload`) VALUES
(1, '948cf63b-dd58-40ad-947e-6bd28d9c2cd7', 'GRANTED', NULL, NULL, '2026-06-27 23:11:49', '2026-06-27 23:11:49', NULL, '948cf63b-dd58-40ad-947e-6bd28d9c2cd7', 'selvamaryj@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"948cf63b-dd58-40ad-947e-6bd28d9c2cd7\", \"signature\": \"kYPyHF6H/sE7XNHlQ5aSbLlywQDESQFQ2MDQtE7X4hXwwgwOrkzf/IzuwkiG2mDLY+iM1h5/+gNnZbHjnUEC/EvGTVktmPBjfws8YjAZ07h7h4M9uK1sde7GAhnWAMniwBp9BiM/Y3u9yl5jYqTAvX5ah2U55ftHicv0qcVVzp8+sHxthX0ueUorAn4d1YsxU5jdZqRA5JB5cfX8AYQEBka/xtIm2JLruexeKJpgxWZ3BH4GuHMxW4p2v92S3f4MgYPTRhv+/MFV1JF99yL9TuhZsvkNXe1RwcBzO/d8gXHhaGmU36jEhmI95AgSzTadODfMzG5/xxC35IH9ddZHfA==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"selvamaryj@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"948cf63b-dd58-40ad-947e-6bd28d9c2cd7\", \"createdAt\": \"2026-06-27T23:11:49.166Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-27T23:11:48.908Z\", \"from\": \"1926-06-27T23:11:48.908Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-27T23:11:48.909Z\"}, \"careContexts\": [{\"patientReference\": \"4\", \"careContextReference\": \"BILL-2\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(2, 'ed8ba3e1-6d19-49fa-9486-bed0fd33555e', 'GRANTED', NULL, NULL, '2026-06-27 23:13:20', '2026-06-27 23:13:20', NULL, 'ed8ba3e1-6d19-49fa-9486-bed0fd33555e', 'selvamaryj@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"ed8ba3e1-6d19-49fa-9486-bed0fd33555e\", \"signature\": \"unM1FW4ZEWcCzI1BFBFJf76vd2QznP7S8O7t/bvs32jP3xVEAIlNNVGmquG6oZepagrCAFlkJPn0jkDaxsHrespYqmGzq/rJLRa0CXUNnpL8byUIxcyR3SBRKoFk0A9ga4L6QqjcZLRTV5yKa2oiWkrAEh9jp4WHAwI3GJhJALfKBfzKf1UKy6gZbZ3qpPoj00QIs7FJInCp+LI/L4hbyAb+jId7EIvdzJpFSMfMF5cKIValhasPcs0zcdu1wHK31z3Sh0U750D2bald+wI1fc7/L1hIZArJtP/+CtG1ob0ipPL3xfwDztrujzYiwAOIP8cbhQlaI0YIZEehnJwwaQ==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"selvamaryj@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"ed8ba3e1-6d19-49fa-9486-bed0fd33555e\", \"createdAt\": \"2026-06-27T23:13:20.079Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-27T23:13:19.815Z\", \"from\": \"1926-06-27T23:13:19.815Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-27T23:13:19.815Z\"}, \"careContexts\": [{\"patientReference\": \"5\", \"careContextReference\": \"BILL-5\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(3, 'f14526e1-01d4-4a4b-af8f-9d4fd25ec2e2', 'GRANTED', NULL, NULL, '2026-06-28 12:50:08', '2026-06-28 12:50:08', NULL, 'f14526e1-01d4-4a4b-af8f-9d4fd25ec2e2', 'john.doeasd123@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"f14526e1-01d4-4a4b-af8f-9d4fd25ec2e2\", \"signature\": \"K+Ukn2Qj80KJtPlZx28zzSbzIxFx7GX10dWGZkGujg0GX5vCNXGwpolkERgu+mcE1vjrcylQO2BeupPAfogvAmnYi2cLmobsWVu80n8UR/Trw/jj+GEuH0/UC00HVf0M7ruD08UihFrXiIgebtrreZqZFcqdCQwnNixqG682Kt1bXv9FojfDs3hoYt8aazE8PEonKWdNpSb1wHY12DHPnhf33IsSt1h/JpAWWh1K8iW5k808ruo5QQU+xiSYNhvvavI1CQXIvkx8jm+voJ3+zl2pXZngrZqi73lfN3jHPVa6ed2XJtb8ccbY71kcAumjQnLIHEZ6wUCDx16MIEFYkQ==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"john.doeasd123@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"f14526e1-01d4-4a4b-af8f-9d4fd25ec2e2\", \"createdAt\": \"2026-06-28T12:50:08.256Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-28T12:50:08.018Z\", \"from\": \"1926-06-28T12:50:08.018Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-28T12:50:08.018Z\"}, \"careContexts\": [{\"patientReference\": \"6\", \"careContextReference\": \"BILL-6\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(4, '01fb7348-df07-4336-9dec-a9a404628905', 'GRANTED', NULL, NULL, '2026-06-28 12:55:10', '2026-06-28 12:55:10', NULL, '01fb7348-df07-4336-9dec-a9a404628905', 'john.doeasd123@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"01fb7348-df07-4336-9dec-a9a404628905\", \"signature\": \"pySNQjxSVDzJOv9aWJHLRXyJFgk8LCX4fzXNvwLknmVEqPj3t0IEXqR59UoZqYt4SetFXumzr2/c8V1QGB5KzxhtS+DTkaE60ycjgx/BrDFdWPWqHpjIBOwlZU+id4LRu/BFENSGGJj19f6OpWC1/GmKzOxhE8pq3K8yYKflhtEP8nBxqKvuNVdsfaMWey/mfjhfk5eM4DAdhNwUBIRQXnuNYu5jWs0Mwl+Y07kUnApWzI3+t+dwKRQu7Om2k415Ph3kBdiEGFmgB7AFzMRle41mwAc2J1W1NUud1HH1mFLXJKtwxQTJdOBGMc3POtoQM/x4sQU+p3v/1ceGZeuk3Q==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"john.doeasd123@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"01fb7348-df07-4336-9dec-a9a404628905\", \"createdAt\": \"2026-06-28T12:55:10.663Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-28T12:55:10.433Z\", \"from\": \"1926-06-28T12:55:10.433Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-28T12:55:10.433Z\"}, \"careContexts\": [{\"patientReference\": \"REG-27782\", \"careContextReference\": \"CONSULT-5\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(5, '981e3ecd-7283-4aeb-b452-11690be5e6fd', 'GRANTED', NULL, NULL, '2026-06-28 12:59:18', '2026-06-28 12:59:18', NULL, '981e3ecd-7283-4aeb-b452-11690be5e6fd', 'selvamaryj@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"981e3ecd-7283-4aeb-b452-11690be5e6fd\", \"signature\": \"f1t3sl5ctOA0TzMhVUB6OJSMiOi8Ple2wGdLB/30EdRRcA6Vj98aGxo896vUDizgY8al3Oa6tDH4/wEI9xgzL/mumoR5ChGqLXo+UN/XoUAQPU2Onx3eIPRizMAwpFfXNDcvi4PLIiWlBlfxtW6tlhjXBM3krzkOUEWvSSEqLuwIVKITPEG9LD9WiZmbAJNmIsbeJ5eaKCkKc4SgqgN0V+nhcxA5/cvvha8DgWiB8yFfmyqcpUBrmqAJ+pkQ4eqE5Dlxsno94BdWRw3cTPke9motyYiVis5PsVezFbYFPDNzuC5OCHw36NLyXoowV4ZVdELQirbud1SWATffMpPR/w==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"selvamaryj@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"981e3ecd-7283-4aeb-b452-11690be5e6fd\", \"createdAt\": \"2026-06-28T12:59:18.465Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-28T12:59:18.196Z\", \"from\": \"1926-06-28T12:59:18.196Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-28T12:59:18.196Z\"}, \"careContexts\": [{\"patientReference\": \"4\", \"careContextReference\": \"BILL-2\"}, {\"patientReference\": \"5\", \"careContextReference\": \"BILL-5\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(6, 'b1e54f80-a2f4-47b1-a214-b8b00be61d3c', 'GRANTED', NULL, NULL, '2026-06-28 13:01:32', '2026-06-28 13:01:32', NULL, 'b1e54f80-a2f4-47b1-a214-b8b00be61d3c', 'john.doeasd123@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"b1e54f80-a2f4-47b1-a214-b8b00be61d3c\", \"signature\": \"cepsuLKMQ3KCqnrWx3p8FfJgkZWaKogUvfLTLrEVDA2hNMicSxLk8FY1kbb7zmGqG7hao2pCwZFG6JBwgQ3mJhzlYzbsP+YROBvFc/ivtCwsy97eMrXUJdS/zP4ZFOa5EFA7zTlAvqeO+b4JvC8MFzc5+yHEoxmhVzmjfp5cZlqOYKa3DGCYCyJXOsCoH1porhfFq6eCfgXCEzdOr2IOYTprodVDB3aNS1rKSHg9sTPsym9urAryxIWE13ozBsso8X99gQRXqYYD36Sx2w7DGrbK3P0ypb54F0YpLwZJ1Rcrh1p8W4KvRowtZTHq5RrkW2/h8uzkwUlvbMjKgn30Kw==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"john.doeasd123@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"b1e54f80-a2f4-47b1-a214-b8b00be61d3c\", \"createdAt\": \"2026-06-28T13:01:32.170Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-28T13:01:31.949Z\", \"from\": \"1926-06-28T13:01:31.949Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-28T13:01:31.949Z\"}, \"careContexts\": [{\"patientReference\": \"8\", \"careContextReference\": \"BILL-8\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(7, 'cdb3025a-f5d9-4c9c-b531-87eee0982fbc', 'GRANTED', NULL, NULL, '2026-06-28 13:03:20', '2026-06-28 13:03:20', NULL, 'cdb3025a-f5d9-4c9c-b531-87eee0982fbc', 'john.doeasd123@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"cdb3025a-f5d9-4c9c-b531-87eee0982fbc\", \"signature\": \"fUHucFn5C762rAtoPeiwlmAa+or+WuT7LcBmeQ0aNXRqIepXEzbavCfp26dETv/Gd0ZfoKEIv/jSUBxVs0lRlYTfxg+RfZvcobGSCHNRYaWisMxuQp7aJnhlyZG19jF34iaLuFmc94b4JHb5SPr41MolOsJSqdAaPu6kAC+vmnO3MSrNurXUOn8TQwtVv4R68NCBQMIvv3AvlmAJrlykGmPkBgB6tkp860IRXOTFAgoHbgNDTkudo5Gi0NMDpSw+kQS9DO1SSBneWrTjNZQmV37YQ+mHf/fFDGt99Ao3mATs6qSctUI3Lsc9sYMCChu3yN+B61/JGwV4JNXuPmuq9w==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"john.doeasd123@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"cdb3025a-f5d9-4c9c-b531-87eee0982fbc\", \"createdAt\": \"2026-06-28T13:03:20.813Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-28T13:03:20.578Z\", \"from\": \"1926-06-28T13:03:20.578Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-28T13:03:20.578Z\"}, \"careContexts\": [{\"patientReference\": \"PUID-0001\", \"careContextReference\": \"visit-ab366981-1e20-4e62-8b07-58c0d2e65ae8\"}, {\"patientReference\": \"6\", \"careContextReference\": \"BILL-6\"}, {\"patientReference\": \"REG-27782\", \"careContextReference\": \"CONSULT-5\"}, {\"patientReference\": \"8\", \"careContextReference\": \"BILL-8\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(8, 'aed1b085-97ec-4439-91ce-5d4a0085431b', 'GRANTED', NULL, NULL, '2026-06-28 13:05:42', '2026-06-28 13:05:42', NULL, 'aed1b085-97ec-4439-91ce-5d4a0085431b', 'john.doeasd123@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"aed1b085-97ec-4439-91ce-5d4a0085431b\", \"signature\": \"Z5EwY++iPE8Gr8yS+PCEH861GZarzQFd3CWiwgD2CHUrSB0gKm8PrHohJOHHiUCQcDJtZlzX+HvYUGEZT+daqurccZG4dODbX645wNwItNRsAK4V4aoeBNs+bqv2rZqxZTKH7Mf9AJ6Ag30Ox/g/w11Oj55ENSDK7wKM8IorjzVFvtir6PcULJcjF1kYCP6FKUbDjCoZGdPrSudmr8jrSN1YSNmhRa/9sqqzeBqTKqV55r5ZEtEhPESE92etxFm5EnZleridJOYgyu+roR5gwKcCWEjYsY6SCH91R70cE4xoZxr1+lSJ9a6yTgyEmQQAXB1yxMvRnbgCZn0E4XrPdg==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"john.doeasd123@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"aed1b085-97ec-4439-91ce-5d4a0085431b\", \"createdAt\": \"2026-06-28T13:05:42.922Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-28T13:05:42.703Z\", \"from\": \"1926-06-28T13:05:42.703Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-28T13:05:42.703Z\"}, \"careContexts\": [{\"patientReference\": \"REG-96979\", \"careContextReference\": \"CONSULT-7\"}, {\"patientReference\": \"REG-96979\", \"careContextReference\": \"PRESC-7\"}, {\"patientReference\": \"REG-96979\", \"careContextReference\": \"LAB-7\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(9, 'f60bd095-40bb-423f-893c-b71a3e7ff0ff', 'GRANTED', NULL, NULL, '2026-06-28 13:06:14', '2026-06-28 13:06:14', NULL, 'f60bd095-40bb-423f-893c-b71a3e7ff0ff', 'john.doeasd123@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"f60bd095-40bb-423f-893c-b71a3e7ff0ff\", \"signature\": \"rxPC8OFf7KG6VuPUtmqVyo+fYj7GiLiQ11QdGfCcN2Mbjjg8OOT9JmUDfONSGYe4M1U27PV7ybVN5LFuzKqDvib1Vmmf5AwYUtWJqG6mFaTpB0SDS6Clrr+1GlSl4OaatHaWtkI9UfMUcz6yi7Xgy7sxIJB22zmSslQjYO7CBw+yBoI3Jku2EOfIFc7tZElAQCNMvH9kjc13rl2YouL8OrSQk/TuzjqoFnNSR/OJGezJje5DATD9taFd+2FGVKjLGUQbSPxrc0/Ggwatc88Xgo5RmyU4fzgRVHn9xY0bpFbwsM4GFtrHXBNkFa1lAmshqPPTFj+Q2R7Vh6SVbD2cbQ==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"john.doeasd123@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"f60bd095-40bb-423f-893c-b71a3e7ff0ff\", \"createdAt\": \"2026-06-28T13:06:14.748Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-28T13:06:14.526Z\", \"from\": \"1926-06-28T13:06:14.526Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-28T13:06:14.526Z\"}, \"careContexts\": [{\"patientReference\": \"REG-96979\", \"careContextReference\": \"PRESC-7\"}, {\"patientReference\": \"REG-96979\", \"careContextReference\": \"CONSULT-7\"}, {\"patientReference\": \"REG-96979\", \"careContextReference\": \"LAB-7\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(10, 'd803b8ea-2757-4119-8780-726f6e165969', 'GRANTED', NULL, NULL, '2026-06-28 13:21:52', '2026-06-28 13:21:52', NULL, 'd803b8ea-2757-4119-8780-726f6e165969', 'john.doeasd123@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"d803b8ea-2757-4119-8780-726f6e165969\", \"signature\": \"S9xvrCwsUI1oHL6jDi7/98v3aHXp0KP0TQP189POw/Y/7mMTggZ7WAyZhBi9Gouj3n6O2JWqCwTYph8/bGoM0/zOXuCjK1eoVH/mTCauRBr+OuWtG+hLoSbuwtNVBcjM659DRrCR459jcVYHgrPoYdTTrEmGg6ludp4Qzf65Ztl2fDKg009ZEPqT3OBRifgCxyWESzWjmZiyFke+iSf9aP17+4WXBav6Vb4WCd8/p+xmb8yKORnBCasb6zyqoanuJb4bV/cr742xHUbUoSnzupawkBclPUtouBNiiNHBnZOW981Fs/vYwDwmsZcLjj73ikpaXdaBGQ8K9s4uiq+REQ==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"john.doeasd123@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"d803b8ea-2757-4119-8780-726f6e165969\", \"createdAt\": \"2026-06-28T13:21:52.688Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-28T13:21:52.431Z\", \"from\": \"1926-06-28T13:21:52.431Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-28T13:21:52.431Z\"}, \"careContexts\": [{\"patientReference\": \"PUID-0001\", \"careContextReference\": \"visit-ab366981-1e20-4e62-8b07-58c0d2e65ae8\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(11, '784d85dd-8253-46b2-b794-9349e97dea68', 'GRANTED', NULL, NULL, '2026-06-28 13:22:27', '2026-06-28 13:22:27', NULL, '784d85dd-8253-46b2-b794-9349e97dea68', 'john.doeasd123@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"784d85dd-8253-46b2-b794-9349e97dea68\", \"signature\": \"dCfxZL3wjtdPaMNFLWH32GcL7lRXFfMiF6E9uTnQK/OasVX1kSRw6aZDem5b2AFkFm1BNyL+EE73gsJZsMrtkCahZsZzdcxWXl+y7VjI1DjghbwFRrzi123Zr2Fbwxxj/M/5KRf5k0SmklrGsPHDxbD2kz4sJuVjUJpGgtovjrZzjT+dFsHjrSLrnQG6g++5bJPg5X7b0TZs9DJ5FJYxkZgMaRFBe3tKGgxfmar6qj/n/mu3/HKbtywShhQdEd6TUKwx+ET9P6SedAAc4s3Hu1TJ0HBEmSPnDRaa0Q/bgY8i8U76L/buNWgTW7GMJHoneZCmAgI6XOyDBL5wpqgbTA==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"john.doeasd123@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"784d85dd-8253-46b2-b794-9349e97dea68\", \"createdAt\": \"2026-06-28T13:22:26.916Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-28T13:22:26.682Z\", \"from\": \"1926-06-28T13:22:26.682Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-28T13:22:26.682Z\"}, \"careContexts\": [{\"patientReference\": \"REG-27782\", \"careContextReference\": \"CONSULT-5\"}, {\"patientReference\": \"8\", \"careContextReference\": \"BILL-8\"}, {\"patientReference\": \"6\", \"careContextReference\": \"BILL-6\"}, {\"patientReference\": \"REG-96979\", \"careContextReference\": \"LAB-7\"}, {\"patientReference\": \"REG-96979\", \"careContextReference\": \"PRESC-7\"}, {\"patientReference\": \"REG-96979\", \"careContextReference\": \"CONSULT-7\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(12, 'd7a1f005-cd2b-4b27-ae8a-6d400f0f7eab', 'GRANTED', NULL, NULL, '2026-06-29 19:25:29', '2026-06-29 19:25:29', NULL, 'd7a1f005-cd2b-4b27-ae8a-6d400f0f7eab', 'john.doeasd123@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"d7a1f005-cd2b-4b27-ae8a-6d400f0f7eab\", \"signature\": \"xgW0itGJmHj4RsyOD0s1v+l+9XBT+fbd3jweSMcXMGuXcG5eHPkr6ji0ZgZ3qAa+sBFMseDGJeXglmDyAA4BotBKqx4BdBoVHHbB1tTA3RpszGFZB7pJmqFmjLaLlCwtIWVEQNtxC+MM08LIwaCVSupqbVloVNdzChYWVE1y61iiYslYmYvd2Ib2wgfmMYNNm7g6yJizqMYxr72bFqKohXgQGwgCx6clcdmJUethhX3gLGreTZ4CFyHB/tzthoeaXmS3r2CPXXkdg45Bck7g2rPwo8p/g4GjJCYm85jvXH1ux31M43Uq3J2dvXShur8b8fJhfAyGsd28r7Z8UKpiLw==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"john.doeasd123@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"d7a1f005-cd2b-4b27-ae8a-6d400f0f7eab\", \"createdAt\": \"2026-06-29T19:25:29.641Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-29T19:25:29.428Z\", \"from\": \"1926-06-29T19:25:29.428Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-29T19:25:29.428Z\"}, \"careContexts\": [{\"patientReference\": \"10\", \"careContextReference\": \"BILL-11\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(13, '5eb8fecd-ee3a-410f-a1da-5e3eb27c2543', 'GRANTED', NULL, NULL, '2026-06-29 19:26:12', '2026-06-29 19:26:12', NULL, '5eb8fecd-ee3a-410f-a1da-5e3eb27c2543', 'john.doeasd123@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"5eb8fecd-ee3a-410f-a1da-5e3eb27c2543\", \"signature\": \"M3W/SASAiMiq/kIgGYc3Y9MF7hWFEeJZjY/SQc8I6v0rq6pqTqik/xPlA3/zO2JO/Th6ySx3hfWsiXHXwCfyrD5UXLEv4mixs5kTcfuFnX36AF6aficWdIYNwN910AKwKeiqn/rPxwmx0T1A2b6GRwqkOLh8XCE8uRporptuTwfW/MCaP1FJ0f3vfmcSm4qsluYFdBNw+gJVLRW7KVuNsQ64vfkoBucoLI5bbTT7btQEXhr4VyLUDwCShRusRmEaUoecqSpSKZEkRkh4Cj6TkaF3OhYlrnlGZ6aTWTFKxXVpbnIXkBDgYZyBmx7L5Y0QwHZE2RNSVb5pZKPfxbU0iw==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"john.doeasd123@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"5eb8fecd-ee3a-410f-a1da-5e3eb27c2543\", \"createdAt\": \"2026-06-29T19:26:12.925Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-29T19:26:12.682Z\", \"from\": \"1926-06-29T19:26:12.682Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-29T19:26:12.682Z\"}, \"careContexts\": [{\"patientReference\": \"PUID-0001\", \"careContextReference\": \"visit-ab366981-1e20-4e62-8b07-58c0d2e65ae8\"}, {\"patientReference\": \"REG-27782\", \"careContextReference\": \"CONSULT-5\"}, {\"patientReference\": \"6\", \"careContextReference\": \"BILL-6\"}, {\"patientReference\": \"REG-96979\", \"careContextReference\": \"LAB-7\"}, {\"patientReference\": \"REG-96979\", \"careContextReference\": \"PRESC-7\"}, {\"patientReference\": \"REG-96979\", \"careContextReference\": \"CONSULT-7\"}, {\"patientReference\": \"8\", \"careContextReference\": \"BILL-8\"}, {\"patientReference\": \"10\", \"careContextReference\": \"BILL-11\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(14, '11c2ffcd-481c-4bb6-9d06-d7cb180c47bd', 'GRANTED', NULL, NULL, '2026-06-29 19:51:02', '2026-06-29 19:51:02', NULL, '11c2ffcd-481c-4bb6-9d06-d7cb180c47bd', 'john.doeasd123@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"11c2ffcd-481c-4bb6-9d06-d7cb180c47bd\", \"signature\": \"i+rM6lTD81scHtlhTZuDCqgP0e90dzf7/bE8L4QYdI4CaXwEPeqBMcj+XCS2nv0l5KOfEczFtQUh1LWRKUUCyQPEDc3Ob/fiS47yKVUymeVj2LgsExVk2Fdj3/oRw+kHoU3OttRcMZAOasiRgq13RdLcc0hH8cee72239NQ1iVDaWN45m5d9odVdYH9WA6DhRUNoxUx/FZwvGcv/PHaN2B2u+os1HtU34KIpBjWmsJh5DTyA/GirepcyMYw/enBY8u3aJ1WZ+OGWiizcICKeJJtTbKDFq6M7/lbhK3nIyIuYBiW5zlzaIfIkH7mQT7KvX3z0oaaLlqOO2rJLTgRgOg==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"john.doeasd123@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"11c2ffcd-481c-4bb6-9d06-d7cb180c47bd\", \"createdAt\": \"2026-06-29T19:51:02.095Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-29T19:51:01.860Z\", \"from\": \"1926-06-29T19:51:01.860Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-29T19:51:01.860Z\"}, \"careContexts\": [{\"patientReference\": \"REG-79629\", \"careContextReference\": \"CONSULT-9\"}, {\"patientReference\": \"REG-79629\", \"careContextReference\": \"PRESC-9\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(15, '31888737-080d-431d-ac51-45404da2ed78', 'GRANTED', NULL, NULL, '2026-06-29 20:12:13', '2026-06-29 20:12:13', NULL, '31888737-080d-431d-ac51-45404da2ed78', 'john.doeasd123@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"31888737-080d-431d-ac51-45404da2ed78\", \"signature\": \"HOKZm+C+qrs6EBTTF8wBxnHZwCv5CIqlG/n0yKj6cN/tQdj1SiwcxTvE952hayeTTEoATDisV5DkM+u2f74kE69S8oGKBX2hKZyCHwi1vtD8NA8rPP7lD1UUSyEiTXe4IaaOXk35hC4pj1tRmDbSrkSEElsZlxQuxC/2PDKWrU6VrGWY7wbtkbT4/Ujgva+B7kgAi0rv0ChnfGTlzEI7ipHhFW7RHNRZX8Da3wS6IjDy3f9s/8gRHQ+1oeCdeHimnbiJ8dsM1BJCYEXGBfT/iGcbsPFIHFi2PW2TY1tstXM1Rw3iecvzpppVuJ6wmDSa9eqpqxkNGIjcASwORghWiw==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"john.doeasd123@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"31888737-080d-431d-ac51-45404da2ed78\", \"createdAt\": \"2026-06-29T20:12:13.148Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-29T20:12:12.884Z\", \"from\": \"1926-06-29T20:12:12.884Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-29T20:12:12.884Z\"}, \"careContexts\": [{\"patientReference\": \"PUID-0001\", \"careContextReference\": \"visit-ab366981-1e20-4e62-8b07-58c0d2e65ae8\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}'),
(16, '86d5e266-c9b7-49d0-bf58-48cb4b380412', 'GRANTED', NULL, NULL, '2026-06-29 20:38:27', '2026-06-29 20:38:27', NULL, '86d5e266-c9b7-49d0-bf58-48cb4b380412', 'john.doeasd123@sbx', '{\"notification\": {\"status\": \"GRANTED\", \"consentId\": \"86d5e266-c9b7-49d0-bf58-48cb4b380412\", \"signature\": \"W0y2hABdwciX0DMY/apxFq9iSiywCVH307aurrRIEJ79XtpQeIuQDQYK5HOft1Yazncj96dVi/Sr9xFzqZaby0zUZiYqiVtBC1RdQI8vKlew87Kse04uMj0V++xcwGXG2jMXqX1hSrf7tGWqw3kg+XX3X9P067qGPHlUZbJ9Iia50jnzBk4fez12P6uPXRqaleUoZlOkULDrJTf7lZ2NmVXzYbuKp3jPbpqdgxkSUMcQOiHw+LwdgtVKuzhUl8j6XammtsuzZ0w/0J2BYSwuTHrQtM1FqQGSgxYVXFBwPa1RoXBuPQFomKb8AaCcKsh4j7WyrhWcfG0zThuBVYLDDw==\", \"consentDetail\": {\"hip\": {\"id\": \"IN3310002132\"}, \"hiTypes\": [\"Prescription\", \"DiagnosticReport\", \"OPConsultation\", \"DischargeSummary\", \"ImmunizationRecord\", \"HealthDocumentRecord\", \"WellnessRecord\", \"Invoice\"], \"patient\": {\"id\": \"john.doeasd123@sbx\"}, \"purpose\": {\"code\": \"PATRQT\", \"text\": \"Self Requested\", \"refUri\": \"www.abdm.gov.in\"}, \"consentId\": \"86d5e266-c9b7-49d0-bf58-48cb4b380412\", \"createdAt\": \"2026-06-29T20:38:27.520Z\", \"permission\": {\"dateRange\": {\"to\": \"2026-06-29T20:38:27.238Z\", \"from\": \"1926-06-29T20:38:27.238Z\"}, \"frequency\": {\"unit\": \"DAY\", \"value\": 0, \"repeats\": 2}, \"accessMode\": \"VIEW\", \"dataEraseAt\": \"2126-06-29T20:38:27.238Z\"}, \"careContexts\": [{\"patientReference\": \"PUID-0001\", \"careContextReference\": \"visit-ab366981-1e20-4e62-8b07-58c0d2e65ae8\"}], \"schemaVersion\": \"v3\", \"consentManager\": {\"id\": \"sbx\"}}, \"grantAcknowledgement\": false}}');

-- --------------------------------------------------------

--
-- Table structure for table `abdm_data_requests`
--

CREATE TABLE `abdm_data_requests` (
  `id` bigint NOT NULL,
  `transaction_id` varchar(255) NOT NULL,
  `consent_id` varchar(255) DEFAULT NULL,
  `hiu_id` varchar(100) DEFAULT NULL,
  `data_push_url` varchar(500) DEFAULT NULL,
  `key_material` json DEFAULT NULL,
  `status` varchar(50) DEFAULT 'RECEIVED',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `abdm_link_requests`
--

CREATE TABLE `abdm_link_requests` (
  `id` bigint NOT NULL,
  `request_id` varchar(255) NOT NULL,
  `abha_number` varchar(50) DEFAULT NULL,
  `patient_id` bigint DEFAULT NULL,
  `link_token` text,
  `care_contexts_payload` json DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'PENDING',
  `error` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `abdm_link_requests`
--

INSERT INTO `abdm_link_requests` (`id`, `request_id`, `abha_number`, `patient_id`, `link_token`, `care_contexts_payload`, `status`, `error`, `created_at`, `updated_at`) VALUES
(1, '04efa3f3-f013-4b8a-8743-a170017f72e5', '91751562738508', 5, 'eyJhbGciOiJSUzUxMiJ9.eyJoaXBJZCI6IklOMzMxMDAwMjEzMiIsImFiaGFOdW1iZXIiOjkxNzUxNTYyNzM4NTA4LCJ0cmFuc2FjdGlvbklkIjoiNjUyZDA1ZmUtZGFlNy00YTYyLThmOGQtOGI1MGM2Y2Y4N2RmIiwiYWJoYUFkZHJlc3MiOiJzZWx2YW1hcnlqQHNieCIsInN1YiI6InNlbHZhbWFyeWpAc2J4IiwiaWF0IjoxNzgyNjAxOTk4LCJleHAiOjE3OTgzNjk5OTh9.7GEUPZi6lyGALVhNU-MilqZlvNj13ju4qf-2yViAQMS89nX3-ks22jk1qk9Rn6qCsgiaPxDUc7xKP40wdevp1UwULAXKappWnedszb0GLUUryoj_GYt5xvE7vBrdFJ0DokwpBMwPfZar_fVlMcUsqnt4c5do8hgVnbwMfgPhpw66wdpUlUSQFCqqjmFcbSJwo0jPI6kDNWDn47xYr_PuimH0onamtiXvW6mpAzWd3BNKC9TV2YMSR9WzenEFf0hwHsIWSHUv_QpLOPUjtJmPaPcfLYlsxT21e6dfRkji_8sKJTgVqb-rwfHrDvL6WBJvY2tq0btmX5nrgJOiM1DvPg', '{\"hiType\": \"OPConsultation\", \"patientRef\": 5, \"careContexts\": [{\"display\": \"Encounter Bill: BILL-MQWZ7CXF-GEB\", \"referenceNumber\": \"BILL-5\"}], \"encounterDisplay\": \"OPD Consultation - 28/06/2026\"}', 'SUCCESS', NULL, '2026-06-27 23:13:18', '2026-06-27 23:13:18'),
(2, 'bb358505-066a-4b9f-8091-8276f4b373a1', '91751562738508', 5, NULL, '{\"hiType\": \"OPConsultation\", \"patientRef\": \"REG-12324\", \"careContexts\": [{\"display\": \"OPD Visit — 28 Jun 2026\", \"referenceNumber\": \"CONSULT-4\"}, {\"display\": \"Prescription — 28 Jun 2026\", \"referenceNumber\": \"PRESC-4\"}, {\"display\": \"Lab Orders — 28 Jun 2026\", \"referenceNumber\": \"LAB-4\"}], \"encounterDisplay\": \"Selvamary J — OPD Visit\"}', 'FAILED', 'Duplicate Link token request', '2026-06-27 23:14:48', '2026-06-27 23:14:48'),
(3, 'a27b30e6-115f-41f9-99df-9fa1250d1b83', '91534661642817', 6, 'eyJhbGciOiJSUzUxMiJ9.eyJoaXBJZCI6IklOMzMxMDAwMjEzMiIsImFiaGFOdW1iZXIiOjkxNTM0NjYxNjQyODE3LCJ0cmFuc2FjdGlvbklkIjoiM2Q3NTEyODItZjg0Zi00OWQ1LTlkOTYtOTcyNzk4ZTVmZGJkIiwiYWJoYUFkZHJlc3MiOiJqb2huLmRvZWFzZDEyM0BzYngiLCJzdWIiOiJqb2huLmRvZWFzZDEyM0BzYngiLCJpYXQiOjE3ODI2NTEwMDcsImV4cCI6MTc5ODQxOTAwN30.2_Zewtuf-8IYVQhAHfBAQ9Sj6MQD6VWb75nZVrd0_AkFS_tF5Ib4wfIA6zE_fRyKAe-sg5dTnBwSpfaLTnLoIl0LrVQcGWo1RWIiT8LJCi2IhIRHMGRqfFkEDmtiw_zb_Z_7uSezkmf6qKMKN9JGqMURC_-aDOgI8sRb4akEu684Cx94lRB2CIy1bz_E9g0I2baJIBTG1ux5ecDaQmYGeTh4Mljg8bL2tCTOpP41CrIEpD-oOX_ScRJmyMXn2SHek9QOrSjEbDthmtzKjECVgjk-na1fZj_qoWM2GuDwZsEYV53trRmVeDDzsN86nk81MWkyKG5515iDIF-0-76bvA', '{\"hiType\": \"OPConsultation\", \"patientRef\": 6, \"careContexts\": [{\"display\": \"Encounter Bill: BILL-MQXSDRLP-RC5\", \"referenceNumber\": \"BILL-6\"}], \"encounterDisplay\": \"OPD Consultation - 28/06/2026\"}', 'SUCCESS', NULL, '2026-06-28 12:50:06', '2026-06-28 12:50:07'),
(4, '18e10b0d-0f60-4eb1-8dfc-94b5eb62788d', '91113301558038', 7, NULL, '{\"hiType\": \"OPConsultation\", \"patientRef\": 7, \"careContexts\": [{\"display\": \"Encounter Bill: BILL-MQXSLN4J-7Y2\", \"referenceNumber\": \"BILL-7\"}], \"encounterDisplay\": \"OPD Consultation - 28/06/2026\"}', 'FAILED', '{\"code\":\"ABDM-1207: \",\"message\":\"The information you provided does not match the details on record with Aadhaar. Please verify and provide accurate information.\"}', '2026-06-28 12:56:13', '2026-06-28 12:56:14'),
(5, 'f99acdf2-c5d0-42ec-8a37-9c442a6243c2', '91113301558038', 7, NULL, '{\"hiType\": \"OPConsultation\", \"patientRef\": \"REG-92131\", \"careContexts\": [{\"display\": \"OPD Visit - 28 Jun 2026\", \"referenceNumber\": \"CONSULT-6\"}], \"encounterDisplay\": \"Bhaskar Sekar - OPD Visit\"}', 'FAILED', 'Duplicate Link token request', '2026-06-28 12:56:51', '2026-06-28 12:56:51'),
(6, 'e6ec866d-4d8d-417a-8f41-3d73fa636e69', '91113301558038', 9, NULL, '{\"hiType\": \"OPConsultation\", \"patientRef\": 9, \"careContexts\": [{\"display\": \"Encounter Bill: BILL-MQZLUS6F-NRF\", \"referenceNumber\": \"BILL-10\"}], \"encounterDisplay\": \"OPD Consultation - 30/06/2026\"}', 'FAILED', '{\"code\":\"ABDM-1207: \",\"message\":\"The information you provided does not match the details on record with Aadhaar. Please verify and provide accurate information.\"}', '2026-06-29 19:22:55', '2026-06-29 19:22:58'),
(7, 'dd063ef3-6df1-4402-b757-04df7c332077', '91534661642817', 10, 'eyJhbGciOiJSUzUxMiJ9.eyJoaXBJZCI6IklOMzMxMDAwMjEzMiIsImFiaGFOdW1iZXIiOjkxNTM0NjYxNjQyODE3LCJ0cmFuc2FjdGlvbklkIjoiM2Q3NTEyODItZjg0Zi00OWQ1LTlkOTYtOTcyNzk4ZTVmZGJkIiwiYWJoYUFkZHJlc3MiOiJqb2huLmRvZWFzZDEyM0BzYngiLCJzdWIiOiJqb2huLmRvZWFzZDEyM0BzYngiLCJpYXQiOjE3ODI3NjExMjgsImV4cCI6MTc5ODUyOTEyOH0.Xq-Wjb8H2_ndd7d5rszT5c7CtaS-3AHnhBvc_xIDmurD7P4kq9_BLPKHB2yrKAOqR80uoX6jUY98bdgAOTtuUvpuYFLWKoJbo2RdRiB9_KUpwLx36_Qnvy9FxVa90pmabv9oZ9BBPQTZqR3JAxo1wHMbQwr5lqxG51w9meqWRUXqMvjYq4IlMpgyoCkddfXFR9ddW1daGH1sZuE-tZuzD5NzLDlFnXciShYnMaWibFwvT2jZM97nQ_PCpmJCzodtdi51Ad2HvVNWsm3INCztqRIyVflx7MQKwjQetG5nIADBRHGaD6OZnftkPuzdrGlJ_rRShexjkYb08gjkYukvvA', '{\"hiType\": \"OPConsultation\", \"patientRef\": 10, \"careContexts\": [{\"display\": \"Encounter Bill: BILL-MQZLY25Y-W85\", \"referenceNumber\": \"BILL-11\"}], \"encounterDisplay\": \"OPD Consultation - 30/06/2026\"}', 'SUCCESS', NULL, '2026-06-29 19:25:28', '2026-06-29 19:25:28'),
(8, '999d8c32-bd75-4b70-8a92-e9cc9fe87eb9', '91113301558038', 9, NULL, '{\"hiType\": \"OPConsultation\", \"patientRef\": \"REG-33719\", \"careContexts\": [{\"display\": \"OPD Visit: Fever  viral  bacterial  to investiga - 30 Jun 2026\", \"referenceNumber\": \"CONSULT-10\"}, {\"display\": \"Prescription - 30 Jun 2026\", \"referenceNumber\": \"PRESC-10\"}], \"encounterDisplay\": \"Bhaskar Sekar - OPD Visit\"}', 'FAILED', '{\"code\":\"ABDM-1207: \",\"message\":\"The information you provided does not match the details on record with Aadhaar. Please verify and provide accurate information.\"}', '2026-06-29 20:38:37', '2026-06-29 20:38:38'),
(9, 'f6611a56-30db-47f9-a584-c4224631012e', NULL, 4, NULL, '{\"hiType\": \"OPConsultation\", \"patientRef\": \"REG-87923\", \"careContexts\": [{\"display\": \"OPD Visit - 02 Jul 2026\", \"referenceNumber\": \"CONSULT-11\"}, {\"display\": \"Prescription - 02 Jul 2026\", \"referenceNumber\": \"PRESC-11\"}, {\"display\": \"Lab Orders - 02 Jul 2026\", \"referenceNumber\": \"LAB-11\"}], \"encounterDisplay\": \"Bhaskar Sekar - OPD Visit\"}', 'PENDING', NULL, '2026-07-01 23:02:26', '2026-07-01 23:02:26'),
(10, '8cf72b88-7980-4500-aae1-837afb5d0a51', '91751562738508', 5, NULL, '{\"hiType\": \"OPConsultation\", \"patientRef\": 5, \"careContexts\": [{\"display\": \"Encounter Bill: BILL-MR2PTWGH-A8U\", \"referenceNumber\": \"BILL-21\"}], \"encounterDisplay\": \"OPD Consultation - 02/07/2026\"}', 'PENDING', NULL, '2026-07-01 23:37:31', '2026-07-01 23:37:31'),
(11, '1cc28c12-5ae5-49ac-a2d2-43e3215be11a', '91113301558038', 7, NULL, '{\"hiType\": \"OPConsultation\", \"patientRef\": 7, \"careContexts\": [{\"display\": \"Encounter Bill: BILL-MR2QTZ7M-N0C\", \"referenceNumber\": \"BILL-24\"}], \"encounterDisplay\": \"OPD Consultation - 02/07/2026\"}', 'PENDING', NULL, '2026-07-02 00:05:34', '2026-07-02 00:05:34');

-- --------------------------------------------------------

--
-- Table structure for table `abdm_user_linking`
--

CREATE TABLE `abdm_user_linking` (
  `id` bigint NOT NULL,
  `transaction_id` varchar(255) NOT NULL,
  `abha_number` varchar(50) DEFAULT NULL,
  `abha_address` varchar(100) DEFAULT NULL,
  `patient_ref` varchar(100) DEFAULT NULL,
  `otp` varchar(10) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'INITIATED',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `link_ref_number` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `abdm_user_links`
--

CREATE TABLE `abdm_user_links` (
  `id` int NOT NULL,
  `abha_address` varchar(255) NOT NULL,
  `abha_number` varchar(50) DEFAULT NULL,
  `patient_id` int DEFAULT NULL,
  `reg_no` varchar(50) DEFAULT NULL,
  `care_context_ref` varchar(255) DEFAULT NULL,
  `care_context_display` varchar(255) DEFAULT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `linked_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `analyzer_connection_logs`
--

CREATE TABLE `analyzer_connection_logs` (
  `id` int NOT NULL,
  `machine_id` varchar(100) NOT NULL,
  `machine_name` varchar(200) DEFAULT NULL,
  `model` varchar(200) DEFAULT NULL,
  `lab_id` int DEFAULT NULL,
  `port` varchar(100) DEFAULT NULL,
  `event` enum('ONLINE','OFFLINE') NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `id` int NOT NULL,
  `reg_no` varchar(50) NOT NULL,
  `department` varchar(100) NOT NULL,
  `doctor` varchar(100) DEFAULT NULL,
  `doctor_id` int DEFAULT NULL,
  `priority` varchar(50) DEFAULT 'Routine',
  `appt_date` date NOT NULL,
  `appt_time` time DEFAULT NULL,
  `reason` text,
  `status` varchar(50) DEFAULT 'Scheduled',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`id`, `reg_no`, `department`, `doctor`, `doctor_id`, `priority`, `appt_date`, `appt_time`, `reason`, `status`, `created_at`) VALUES
(1, 'REG-98727', 'OPD', NULL, NULL, 'Normal', '2026-06-27', '13:52:00', 'Walk-in (Auto)', 'Scheduled', '2026-06-27 08:22:37'),
(2, 'REG-53596', 'OPD', NULL, NULL, 'Normal', '2026-06-27', '13:52:00', 'Walk-in (Auto)', 'Scheduled', '2026-06-27 08:22:37'),
(3, 'REG-40202', 'OPD', NULL, NULL, 'Normal', '2026-06-27', '23:40:00', 'Walk-in', 'Scheduled', '2026-06-27 18:10:36'),
(4, 'REG-87923', 'OPD', NULL, NULL, 'Normal', '2026-06-27', '03:16:00', 'Walk-in', 'Scheduled', '2026-06-27 21:46:11'),
(5, 'REG-12324', 'OPD', NULL, NULL, 'Normal', '2026-06-27', '04:43:00', 'Walk-in', 'Scheduled', '2026-06-27 23:13:18'),
(6, 'REG-27782', 'OPD', NULL, NULL, 'Normal', '2026-06-28', '18:20:00', 'Walk-in', 'Scheduled', '2026-06-28 12:50:06'),
(7, 'REG-92131', 'OPD', NULL, NULL, 'Normal', '2026-06-28', '18:26:00', 'Walk-in', 'Scheduled', '2026-06-28 12:56:13'),
(8, 'REG-96979', 'OPD', NULL, NULL, 'Normal', '2026-06-28', '18:31:00', 'Walk-in', 'Scheduled', '2026-06-28 13:01:30'),
(9, 'REG-98727', 'OPD', NULL, NULL, 'Normal', '2026-06-29', '22:25:00', 'Walk-in', 'Scheduled', '2026-06-29 16:55:53'),
(10, 'REG-33719', 'OPD', NULL, NULL, 'Normal', '2026-06-29', '00:52:00', 'Walk-in', 'Scheduled', '2026-06-29 19:22:55'),
(11, 'REG-79629', 'OPD', NULL, NULL, 'Normal', '2026-06-29', '00:55:00', 'Walk-in', 'Scheduled', '2026-06-29 19:25:28'),
(12, 'REG-98727', 'Laboratory', 'Dr. sandy 2', 29, 'Normal', '2026-07-01', '04:05:00', 'Walk-in', 'Scheduled', '2026-07-01 22:35:54'),
(13, 'REG-40202', 'Laboratory', 'Dr. sandy 2', 29, 'Normal', '2026-07-01', '04:19:00', 'Walk-in', 'Scheduled', '2026-07-01 22:49:04'),
(14, 'REG-87923', 'OPD', NULL, NULL, 'Normal', '2026-07-01', '04:30:00', 'Walk-in', 'Scheduled', '2026-07-01 23:00:36'),
(15, 'REG-12324', 'Cardiology', 'Dr. Sandy k', 28, 'Normal', '2026-07-01', '11:00:00', 'Walk-in', 'Scheduled', '2026-07-01 23:37:31'),
(16, 'REG-40202', 'Cardiology', 'Dr. Sandy k', 28, 'Normal', '2026-07-02', '05:15:00', 'Walk-in', 'Scheduled', '2026-07-02 00:05:13'),
(17, 'REG-92131', 'Cardiology', 'Dr. Sandy k', 28, 'Normal', '2026-07-02', '05:30:00', 'Walk-in', 'Scheduled', '2026-07-02 00:05:34'),
(18, 'REG-98727', 'Laboratory', NULL, NULL, 'Normal', '2026-07-03', '09:20:00', 'Walk-in', 'Scheduled', '2026-07-03 03:50:00');

-- --------------------------------------------------------

--
-- Table structure for table `beds`
--

CREATE TABLE `beds` (
  `id` int NOT NULL,
  `bed_number` varchar(20) NOT NULL,
  `ward_id` int NOT NULL,
  `branch_id` int NOT NULL,
  `bed_type` enum('General','Semi-Private','Private','ICU','HDU','NICU','PICU','Day Care') DEFAULT 'General',
  `status` enum('Available','Occupied','Under Maintenance','Reserved') DEFAULT 'Available',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `billing`
--

CREATE TABLE `billing` (
  `id` int NOT NULL,
  `reg_no` varchar(50) NOT NULL,
  `invoice_items` json DEFAULT NULL,
  `discount_percent` decimal(5,2) DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `billing_packages`
--

CREATE TABLE `billing_packages` (
  `id` int NOT NULL,
  `package_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `department` varchar(100) NOT NULL,
  `description` text,
  `items` json NOT NULL,
  `discount_percent` decimal(5,2) DEFAULT '0.00',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE `bills` (
  `id` int NOT NULL,
  `bill_number` varchar(50) NOT NULL,
  `patient_id` int NOT NULL,
  `patient_name` varchar(200) DEFAULT NULL,
  `patient_phone` varchar(20) DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `discount_amount` decimal(10,2) DEFAULT '0.00',
  `net_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `paid_amount` decimal(10,2) DEFAULT '0.00',
  `payment_status` enum('Pending','Partial','Paid','Cancelled') DEFAULT 'Pending',
  `payment_method` enum('Cash','Card','UPI','Insurance','Other') DEFAULT 'Cash',
  `bill_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lab_barcode` varchar(50) DEFAULT NULL,
  `lab_qr_code` text,
  `notes` text,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `branch_id` int DEFAULT '1',
  `created_by` int DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bills`
--

INSERT INTO `bills` (`id`, `bill_number`, `patient_id`, `patient_name`, `patient_phone`, `total_amount`, `discount_amount`, `net_amount`, `paid_amount`, `payment_status`, `payment_method`, `bill_date`, `lab_barcode`, `lab_qr_code`, `notes`, `status`, `created_at`, `updated_at`, `branch_id`, `created_by`) VALUES
(1, 'BILL-MQW11OUM-XFE', 1, 'Steve Jerald J B', '9025740156', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-06-27 07:17:06', NULL, NULL, NULL, 'Active', '2026-06-27 07:17:06', '2026-06-27 07:17:06', 1, 5),
(2, 'BILL-MQW39B7O-UGB', 2, 'Jeffin Mervick', '9940016368', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-06-27 08:19:01', NULL, NULL, NULL, 'Active', '2026-06-27 08:19:01', '2026-06-27 08:19:01', 1, 5),
(3, 'BILL-MQWOE2XK-2RB', 3, 'Vasanth Sandeep', '9345995944', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-06-27 18:10:36', NULL, NULL, NULL, 'Active', '2026-06-27 18:10:36', '2026-06-27 18:10:36', 1, 26),
(4, 'BILL-MQWW3BJR-1ZO', 4, 'Bhaskar Sekar', '8925386821', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-06-27 21:46:11', NULL, NULL, NULL, 'Active', '2026-06-27 21:46:11', '2026-06-27 21:46:11', 1, 5),
(5, 'BILL-MQWZ7CXF-GEB', 5, 'Selvamary J', '9940016368', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-06-27 23:13:18', NULL, NULL, NULL, 'Active', '2026-06-27 23:13:18', '2026-06-27 23:13:18', 1, 5),
(6, 'BILL-MQXSDRLP-RC5', 6, 'Steve B', '9025740156', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-06-28 12:50:06', NULL, NULL, NULL, 'Active', '2026-06-28 12:50:06', '2026-06-28 12:50:06', 1, 5),
(7, 'BILL-MQXSLN4J-7Y2', 7, 'Bhaskar Sekar', '8925386821', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-06-28 12:56:13', NULL, NULL, NULL, 'Active', '2026-06-28 12:56:13', '2026-06-28 12:56:13', 1, 5),
(8, 'BILL-MQXSSFXK-YTP', 8, 'Steve B', '9025740156', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-06-28 13:01:30', NULL, NULL, NULL, 'Active', '2026-06-28 13:01:30', '2026-06-28 13:01:30', 1, 5),
(9, 'BILL-MQZGLPNA-FCK', 1, 'Steve Jerald J B', '9025740156', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-06-29 16:55:53', NULL, NULL, NULL, 'Active', '2026-06-29 16:55:53', '2026-06-29 16:55:53', 1, 5),
(10, 'BILL-MQZLUS6F-NRF', 9, 'Bhaskar Sekar', '8925386821', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-06-29 19:22:55', NULL, NULL, NULL, 'Active', '2026-06-29 19:22:55', '2026-06-29 19:22:55', 1, 5),
(11, 'BILL-MQZLY25Y-W85', 10, 'Steve B', '9025740156', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-06-29 19:25:28', NULL, NULL, NULL, 'Active', '2026-06-29 19:25:28', '2026-06-29 19:25:28', 1, 5),
(12, 'BILL-MQZM12H4-A1D', 1, 'Steve Jerald J B', '9025740156', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-06-29 19:27:48', NULL, NULL, NULL, 'Active', '2026-06-29 19:27:48', '2026-06-29 19:27:48', 1, 26),
(13, 'BILL-MR2NMO9E-547', 1, 'Steve Jerald J B', '9025740156', 550.00, 0.00, 550.00, 550.00, 'Paid', 'Cash', '2026-07-01 22:35:54', 'LAB-UNKNOWN-COMPLETEBLOODCH-SDHG-52ZL', 'data:image/png;base64,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', NULL, 'Active', '2026-07-01 22:35:54', '2026-07-01 22:35:54', 17, 27),
(14, 'BILL-MR2O3LMO-36G', 3, 'Vasanth Sandeep', '9345995944', 550.00, 0.00, 550.00, 550.00, 'Paid', 'Cash', '2026-07-01 22:49:04', 'LAB-UNKNOWN-COMPLETEBLOODCH-LQNX-Z5BD', 'data:image/png;base64,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', NULL, 'Active', '2026-07-01 22:49:04', '2026-07-01 22:49:04', 17, 27),
(15, 'BILL-MR2OIFKJ-7TZ', 4, 'Bhaskar Sekar', '8925386821', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-07-01 23:00:36', NULL, NULL, NULL, 'Active', '2026-07-01 23:00:36', '2026-07-01 23:00:36', 17, 27),
(16, 'BILL-MR2OMYMP-5R1', 4, 'Bhaskar Sekar', '8925386821', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-07-01 23:04:07', NULL, NULL, NULL, 'Active', '2026-07-01 23:04:07', '2026-07-01 23:04:07', 17, 27),
(17, 'BILL-MR2P1ZZY-004', 1, 'Steve Jerald J B', '9025740156', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-07-01 23:15:49', NULL, NULL, NULL, 'Active', '2026-07-01 23:15:49', '2026-07-01 23:15:49', 17, 27),
(18, 'BILL-MR2P2BQD-N4A', 3, 'Vasanth Sandeep', '9345995944', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-07-01 23:16:04', NULL, NULL, NULL, 'Active', '2026-07-01 23:16:04', '2026-07-01 23:16:04', 17, 27),
(19, 'BILL-MR2PK76O-S6G', 1, 'Steve Jerald J B', '9025740156', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-07-01 23:29:58', NULL, NULL, NULL, 'Active', '2026-07-01 23:29:58', '2026-07-01 23:29:58', 17, 27),
(20, 'BILL-MR2PKGPP-LRK', 3, 'Vasanth Sandeep', '9345995944', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-07-01 23:30:10', NULL, NULL, NULL, 'Active', '2026-07-01 23:30:10', '2026-07-01 23:30:10', 17, 27),
(21, 'BILL-MR2PTWGH-A8U', 5, 'Selvamary J', '9940016368', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-07-01 23:37:31', NULL, NULL, NULL, 'Active', '2026-07-01 23:37:31', '2026-07-01 23:37:31', 17, 27),
(22, 'BILL-MR2QIOT1-S5E', 1, 'Steve Jerald J B', '9025740156', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-07-01 23:56:47', NULL, NULL, NULL, 'Active', '2026-07-01 23:56:47', '2026-07-01 23:56:47', 17, 27),
(23, 'BILL-MR2QTJ4O-0Y7', 3, 'Vasanth Sandeep', '9345995944', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-07-02 00:05:13', NULL, NULL, NULL, 'Active', '2026-07-02 00:05:13', '2026-07-02 00:05:13', 17, 27),
(24, 'BILL-MR2QTZ7M-N0C', 7, 'Bhaskar Sekar', '8925386821', 50.00, 0.00, 50.00, 50.00, 'Paid', 'Cash', '2026-07-02 00:05:34', NULL, NULL, NULL, 'Active', '2026-07-02 00:05:34', '2026-07-02 00:05:34', 17, 27),
(25, 'BILL-MR4EAGH3-0GO', 1, 'Steve Jerald J B', '9025740156', 550.00, 0.00, 550.00, 550.00, 'Paid', 'Cash', '2026-07-03 03:50:00', 'LAB-UNKNOWN-COMPLETEBLOODCH-7J4T-LI44', 'data:image/png;base64,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', NULL, 'Active', '2026-07-03 03:50:00', '2026-07-03 03:50:00', 17, 27);

-- --------------------------------------------------------

--
-- Table structure for table `bill_items`
--

CREATE TABLE `bill_items` (
  `id` int NOT NULL,
  `bill_id` int NOT NULL,
  `service_type` enum('Appointment','Laboratory','Pharmacy','Other') NOT NULL,
  `service_id` int DEFAULT NULL,
  `service_name` varchar(200) NOT NULL,
  `service_code` varchar(50) DEFAULT NULL,
  `lab_id` int DEFAULT NULL,
  `lab_barcode` varchar(100) DEFAULT NULL,
  `sample_id` varchar(50) DEFAULT NULL,
  `short_id` varchar(10) DEFAULT NULL,
  `quantity` int DEFAULT '1',
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `status` enum('Pending','Collected','In Progress','Test Done','Completed','Active','Inactive') DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `collected_by` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `bill_items`
--

INSERT INTO `bill_items` (`id`, `bill_id`, `service_type`, `service_id`, `service_name`, `service_code`, `lab_id`, `lab_barcode`, `sample_id`, `short_id`, `quantity`, `unit_price`, `total_price`, `status`, `created_at`, `updated_at`, `collected_by`) VALUES
(1, 1, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-06-27 07:17:06', '2026-06-27 07:17:06', NULL),
(2, 2, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-06-27 08:19:01', '2026-06-27 08:19:01', NULL),
(3, 3, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-06-27 18:10:36', '2026-06-27 18:10:36', NULL),
(4, 4, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-06-27 21:46:11', '2026-06-27 21:46:11', NULL),
(5, 5, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-06-27 23:13:18', '2026-06-27 23:13:18', NULL),
(6, 6, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-06-28 12:50:06', '2026-06-28 12:50:06', NULL),
(7, 7, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-06-28 12:56:13', '2026-06-28 12:56:13', NULL),
(8, 8, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-06-28 13:01:30', '2026-06-28 13:01:30', NULL),
(9, 9, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-06-29 16:55:53', '2026-06-29 16:55:53', NULL),
(10, 10, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-06-29 19:22:55', '2026-06-29 19:22:55', NULL),
(11, 11, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-06-29 19:25:28', '2026-06-29 19:25:28', NULL),
(12, 12, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-06-29 19:27:48', '2026-06-29 19:27:48', NULL),
(13, 13, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-07-01 22:35:54', '2026-07-01 22:35:54', NULL),
(14, 13, 'Laboratory', 2, 'Complete Blood Cholestrol', NULL, NULL, 'LAB-UNKNOWN-COMPLETEBLOODCH-SDHG-52ZL', 'LAB-SDR-RAM-20260701-3000', '3000', 1, 500.00, 500.00, 'Collected', '2026-07-01 22:35:54', '2026-07-01 22:54:52', 27),
(15, 14, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-07-01 22:49:04', '2026-07-01 22:49:04', NULL),
(16, 14, 'Laboratory', 2, 'Complete Blood Cholestrol', NULL, NULL, 'LAB-UNKNOWN-COMPLETEBLOODCH-LQNX-Z5BD', NULL, NULL, 1, 500.00, 500.00, 'Pending', '2026-07-01 22:49:04', '2026-07-01 22:49:04', NULL),
(17, 15, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-07-01 23:00:36', '2026-07-01 23:00:36', NULL),
(18, 16, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-07-01 23:04:07', '2026-07-01 23:04:07', NULL),
(19, 17, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-07-01 23:15:49', '2026-07-01 23:15:49', NULL),
(20, 18, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-07-01 23:16:04', '2026-07-01 23:16:04', NULL),
(21, 19, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-07-01 23:29:58', '2026-07-01 23:29:58', NULL),
(22, 20, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-07-01 23:30:10', '2026-07-01 23:30:10', NULL),
(23, 21, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-07-01 23:37:31', '2026-07-01 23:37:31', NULL),
(24, 22, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-07-01 23:56:47', '2026-07-01 23:56:47', NULL),
(25, 23, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-07-02 00:05:13', '2026-07-02 00:05:13', NULL),
(26, 24, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-07-02 00:05:34', '2026-07-02 00:05:34', NULL),
(27, 25, 'Other', NULL, 'Registration Fee', NULL, NULL, NULL, NULL, NULL, 1, 50.00, 50.00, 'Pending', '2026-07-03 03:50:00', '2026-07-03 03:50:00', NULL),
(28, 25, 'Laboratory', 2, 'Complete Blood Cholestrol', NULL, NULL, 'LAB-UNKNOWN-COMPLETEBLOODCH-7J4T-LI44', NULL, NULL, 1, 500.00, 500.00, 'Pending', '2026-07-03 03:50:00', '2026-07-03 03:50:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `blocks`
--

CREATE TABLE `blocks` (
  `id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `district_id` int NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `blocks`
--

INSERT INTO `blocks` (`id`, `name`, `district_id`, `is_active`, `created_at`) VALUES
(1, 'Ramgargh', 32, 1, '2026-07-01 17:33:06');

-- --------------------------------------------------------

--
-- Table structure for table `branches`
--

CREATE TABLE `branches` (
  `id` int NOT NULL,
  `district_id` int NOT NULL,
  `block_id` int DEFAULT NULL,
  `branch_name` varchar(255) NOT NULL,
  `category` varchar(100) DEFAULT 'General Lab',
  `facility_type` enum('PHC','CHC','UPHC','SDH','DHH','Medical College','Cancer Hub','Hospital','Clinic','Lab','Other') DEFAULT 'Other',
  `branch_level` varchar(50) DEFAULT 'Center',
  `parent_branch_id` int DEFAULT NULL,
  `hospital_code` varchar(50) NOT NULL,
  `address` text,
  `contact_number` varchar(50) DEFAULT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `branches`
--

INSERT INTO `branches` (`id`, `district_id`, `block_id`, `branch_name`, `category`, `facility_type`, `branch_level`, `parent_branch_id`, `hospital_code`, `address`, `contact_number`, `status`, `created_at`) VALUES
(1, 1, NULL, 'Ranchi Central Hub', 'General Hospital', 'Other', 'Center', NULL, 'RANC-CH', 'Kanta Toli Chowk, Purulia Rd, 10b, Purulia Rd, Kantatoli, Chowk, Ranchi, Jharkhand 834001', NULL, 'Active', '2026-04-29 07:14:28'),
(3, 35, NULL, 'Chatra Lab', 'Govt Diagnostic Lab', 'Other', 'Center', 1, 'CL', 'skjd\n', '1212312', 'Active', '2026-04-29 07:16:38'),
(5, 1, NULL, 'Sub center', 'Primary Health Center', 'Other', 'Center', 1, 'SUB', '12', '12', 'Active', '2026-04-29 07:19:16'),
(6, 1, NULL, 'single', 'Primary Health Center', 'Other', 'Center', 5, 'SINGLE', '23', '23', 'Active', '2026-04-29 07:19:43'),
(7, 44, NULL, 'sample 3', 'Community Health Center', 'Other', 'Center', 1, 'ASQ', 'q', 'q', 'Active', '2026-04-29 07:20:24'),
(8, 35, NULL, 'anakaputhur', 'Community Health Center', 'Other', 'Central', NULL, '250731', '1234567890', '', 'Active', '2026-05-07 21:09:31'),
(9, 44, NULL, 'Pallavaram', 'Community Health Center', 'Other', 'Central', NULL, 'PM', ' ', ' ', 'Active', '2026-05-07 21:09:33'),
(10, 45, NULL, 'Kumbakonam', 'Community Health Center', 'Other', 'Central', NULL, 'KNTH ', '   ', '   ', 'Active', '2026-05-07 21:09:37'),
(11, 29, NULL, 'Avadi', 'Community Health Center', 'Other', 'Central', NULL, '999', ' ', ' ', 'Active', '2026-05-07 21:09:46'),
(12, 44, NULL, 'Pammal', 'Primary Health Center', 'Other', 'Center', 9, 'PAMMAL', ' ', ' ', 'Active', '2026-05-07 21:11:46'),
(13, 29, NULL, 'Moses Street', 'Primary Health Center', 'Other', 'Center', 11, '9999', ' ', '  ', 'Active', '2026-05-07 21:11:55'),
(14, 35, NULL, 'balaji nagar', 'Primary Health Center', 'Other', 'Center', 8, '1234', 'cdvfgn', '1234567890', 'Active', '2026-05-07 21:12:00'),
(15, 45, NULL, 'pugazendhi st', 'Primary Health Center', 'Other', 'Center', 10, 'PSTC', '  ', '  ', 'Active', '2026-05-07 21:12:11'),
(16, 32, NULL, 'Ramgarh PHC', 'Primary Health Center', 'Other', 'Center', NULL, 'RAM PHC', 'C-3, Ground Floor, Durgalakshmi Appt, Revathy Flats, Anna Nagar 10th Cross Street, Pammal, Chennai-600075', '', 'Active', '2026-05-23 02:10:21'),
(17, 32, NULL, 'Sadar Ramgarh', 'District Hospital', 'Other', 'Central', NULL, 'SDR-RAM', 'C-3, Ground Floor, Durgalakshmi Appt, Revathy Flats, Anna Nagar 10th Cross Street, Pammal, Chennai-600075', '9025740156', 'Active', '2026-07-01 17:41:07');

-- --------------------------------------------------------

--
-- Table structure for table `consultations`
--

CREATE TABLE `consultations` (
  `id` int NOT NULL,
  `appointment_id` int NOT NULL,
  `patient_reg_no` varchar(50) NOT NULL,
  `doctor_id` int DEFAULT NULL,
  `vitals_json` text,
  `symptoms` text,
  `diagnosis` text,
  `prescription_json` text,
  `lab_requests_json` text,
  `doctor_notes` text,
  `consultation_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `chief_complaints` text,
  `status` enum('Pending','Completed') DEFAULT 'Pending',
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `soap_history` text,
  `soap_exam` text,
  `icd10_codes` text,
  `follow_up_date` date DEFAULT NULL,
  `patient_instructions` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `consultations`
--

INSERT INTO `consultations` (`id`, `appointment_id`, `patient_reg_no`, `doctor_id`, `vitals_json`, `symptoms`, `diagnosis`, `prescription_json`, `lab_requests_json`, `doctor_notes`, `consultation_date`, `chief_complaints`, `status`, `updated_at`, `soap_history`, `soap_exam`, `icd10_codes`, `follow_up_date`, `patient_instructions`) VALUES
(1, 1, 'REG-98727', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-27 14:53:49', NULL, 'Completed', NULL, NULL, NULL, NULL, NULL, NULL),
(2, 2, 'REG-53596', 26, NULL, 'Cough', NULL, NULL, NULL, NULL, '2026-06-27 15:49:09', 'Cough', 'Completed', '2026-06-27 15:50:40', NULL, '\nGeneral: No abnormality detected.\nCNS: No abnormality detected.', '[{\"code\":\"A00\",\"description\":\"Cholera\"}]', '2026-07-04', 'Come after 1 week'),
(3, 3, 'REG-40202', 26, NULL, 'Vomiting, Bloating, Diarrhoea', NULL, NULL, NULL, NULL, '2026-06-27 18:15:01', 'Vomiting, Bloating, Diarrhoea', 'Completed', NULL, NULL, '\nGeneral: No abnormality detected.', '[{\"code\":\"A01.0\",\"description\":\"Typhoid fever\"}]', '2026-07-04', NULL),
(4, 5, 'REG-12324', 26, NULL, 'Fever', NULL, NULL, NULL, NULL, '2026-06-27 23:14:48', 'Fever', 'Completed', NULL, NULL, '\nGeneral: No abnormality detected.', '[{\"code\":\"A01.0\",\"description\":\"Typhoid fever\"}]', '2026-07-04', NULL),
(5, 6, 'REG-27782', 5, NULL, 'Fever', NULL, NULL, NULL, NULL, '2026-06-28 12:50:40', 'Fever', 'Completed', '2026-06-28 12:55:09', NULL, '\nGeneral: No abnormality detected.', '[{\"code\":\"A01.0\",\"description\":\"Typhoid fever\"}]', '2026-07-05', NULL),
(6, 7, 'REG-92131', 5, NULL, 'Fever, Fatigue, Weakness', NULL, NULL, NULL, NULL, '2026-06-28 12:56:51', 'Fever, Fatigue, Weakness', 'Completed', NULL, NULL, '\nGeneral: No abnormality detected.\nCardiovascular: No abnormality detected.', NULL, '2026-07-05', NULL),
(7, 8, 'REG-96979', 5, NULL, 'Fever, Chills, Fatigue', NULL, NULL, NULL, NULL, '2026-06-28 13:05:41', 'Fever, Chills, Fatigue', 'Completed', NULL, NULL, '\nGeneral: No abnormality detected.\nCardiovascular: No abnormality detected.', '[{\"code\":\"A01\",\"description\":\"Typhoid and paratyphoid fevers\"}]', '2026-07-05', NULL),
(8, 9, 'REG-98727', 5, NULL, ' fever  diarrhoea  okay', 'Fever — viral / bacterial / to investigate', NULL, NULL, 'Onset: acute\nPattern: continuous / intermittent / remittent\nChills / rigors: present / absent\nAssociated: headache, body aches, cough, vomiting, diarrhoea, rash, joint pains\nNot associated: bleeding manifestations, breathlessness\nTravel history: ___\nContact: ___', '2026-06-29 16:59:01', ' fever  diarrhoea  okay', 'Completed', '2026-06-29 17:01:00', 'Onset: acute\nPattern: continuous / intermittent / remittent\nChills / rigors: present / absent\nAssociated: headache, body aches, cough, vomiting, diarrhoea, rash, joint pains\nNot associated: bleeding manifestations, breathlessness\nTravel history: ___\nContact: ___', '\nGeneral: No abnormality detected.', '[{\"code\":\"R50\",\"description\":\"Fever of unknown origin (PUO)\"},{\"code\":\"A01.0\",\"description\":\"Typhoid fever\"}]', '2026-07-06', NULL),
(9, 11, 'REG-79629', 26, NULL, 'Fever for ___ days, temperature up to ___°F', 'Fever — viral / bacterial / to investigate', NULL, NULL, 'Onset: acute\nPattern: continuous / intermittent / remittent\nChills / rigors: present / absent\nAssociated: headache, body aches, cough, vomiting, diarrhoea, rash, joint pains\nNot associated: bleeding manifestations, breathlessness\nTravel history: ___\nContact: ___', '2026-06-29 19:50:57', 'Fever for ___ days, temperature up to ___°F', 'Completed', NULL, 'Onset: acute\nPattern: continuous / intermittent / remittent\nChills / rigors: present / absent\nAssociated: headache, body aches, cough, vomiting, diarrhoea, rash, joint pains\nNot associated: bleeding manifestations, breathlessness\nTravel history: ___\nContact: ___', 'Temp: ___°F, PR: ___ bpm, BP: ___\nGeneral: febrile, no rash, no jaundice, no pallor\nLymph nodes: not enlarged\nAbdomen: no organomegaly\nChest: clear\nCNS: no neck stiffness', '[{\"code\":\"R50\",\"description\":\"Fever of unknown origin (PUO)\"}]', NULL, NULL),
(10, 10, 'REG-33719', 26, NULL, 'Fever for ___ days, temperature up to ___°F', 'Fever — viral / bacterial / to investigate', NULL, NULL, 'Onset: acute\nPattern: continuous / intermittent / remittent\nChills / rigors: present / absent\nAssociated: headache, body aches, cough, vomiting, diarrhoea, rash, joint pains\nNot associated: bleeding manifestations, breathlessness\nTravel history: ___\nContact: ___', '2026-06-29 20:38:37', 'Fever for ___ days, temperature up to ___°F', 'Completed', NULL, 'Onset: acute\nPattern: continuous / intermittent / remittent\nChills / rigors: present / absent\nAssociated: headache, body aches, cough, vomiting, diarrhoea, rash, joint pains\nNot associated: bleeding manifestations, breathlessness\nTravel history: ___\nContact: ___', 'Temp: ___°F, PR: ___ bpm, BP: ___\nGeneral: febrile, no rash, no jaundice, no pallor\nLymph nodes: not enlarged\nAbdomen: no organomegaly\nChest: clear\nCNS: no neck stiffness', '[{\"code\":\"R50\",\"description\":\"Fever of unknown origin (PUO)\"}]', NULL, NULL),
(11, 14, 'REG-87923', 28, NULL, 'Fever', NULL, NULL, NULL, NULL, '2026-07-01 23:02:26', 'Fever', 'Completed', NULL, NULL, '\nCardiovascular: No abnormality detected.', '[{\"code\":\"A01\",\"description\":\"Typhoid and paratyphoid fevers\"}]', '2026-07-08', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(20) DEFAULT NULL,
  `description` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `name`, `code`, `description`, `is_active`, `created_at`) VALUES
(1, 'General Medicine', 'GM', 'General medical services and primary care', 1, '2026-04-09 23:07:38'),
(2, 'Cardiology', 'CARD', 'Heart and cardiovascular system', 1, '2026-04-09 23:07:38'),
(3, 'Orthopedics', 'ORTHO', 'Bones, joints, and musculoskeletal system', 1, '2026-04-09 23:07:38'),
(4, 'Pediatrics', 'PEDS', 'Medical care for infants, children, and adolescents', 1, '2026-04-09 23:07:38'),
(5, 'Gynecology', 'GYN', 'Female reproductive health', 1, '2026-04-09 23:07:38'),
(6, 'Dermatology', 'DERM', 'Skin, hair, and nail conditions', 1, '2026-04-09 23:07:38'),
(7, 'Neurology', 'NEURO', 'Brain and nervous system', 1, '2026-04-09 23:07:38'),
(8, 'Radiology', 'RAD', 'Medical imaging and diagnostics', 1, '2026-04-09 23:07:38'),
(9, 'Laboratory', 'LAB', 'Clinical laboratory services', 1, '2026-04-09 23:07:38'),
(10, 'Dental', 'DENT', 'Oral health and dental care', 1, '2026-04-09 23:07:38'),
(11, 'Ophthalmology', 'OPTH', 'Eye care and vision', 1, '2026-04-09 23:07:38'),
(12, 'ENT', 'ENT', 'Ear, nose, and throat', 1, '2026-04-09 23:07:38'),
(13, 'Urology', 'URO', 'Urinary system and male reproductive organs', 1, '2026-04-09 23:07:38'),
(14, 'Oncology', 'ONCO', 'Cancer treatment and care', 1, '2026-04-09 23:07:38'),
(15, 'Psychiatry', 'PSYCH', 'Mental health and behavioral disorders', 1, '2026-04-09 23:07:38'),
(16, 'Emergency', 'ER', 'Emergency medical services', 1, '2026-04-09 23:07:38'),
(17, 'ICU', 'ICU', 'Intensive Care Unit', 1, '2026-04-09 23:07:38'),
(18, 'Surgery', 'SURG', 'Surgical services', 1, '2026-04-09 23:07:38'),
(19, 'Anesthesiology', 'ANES', 'Anesthesia and pain management', 1, '2026-04-09 23:07:38'),
(20, 'Physiotherapy', 'PHYSIO', 'Physical therapy and rehabilitation', 1, '2026-04-09 23:07:38'),
(21, 'sample', 'sa', NULL, 1, '2026-04-09 23:10:32'),
(22, 'Administration', 'ADMIN', 'Hospital and branch administration staff', 1, '2026-07-01 21:42:33'),
(23, 'Human Resources', 'HR', 'HR and payroll management staff', 1, '2026-07-01 21:42:33'),
(24, 'Management', 'MGMT', 'General management and leadership', 1, '2026-07-01 21:42:33');

-- --------------------------------------------------------

--
-- Table structure for table `digital_prescriptions`
--

CREATE TABLE `digital_prescriptions` (
  `id` int NOT NULL,
  `consultation_id` int NOT NULL,
  `medicine_name` varchar(255) NOT NULL,
  `dosage` varchar(100) DEFAULT NULL,
  `frequency` varchar(100) DEFAULT NULL,
  `duration` varchar(100) DEFAULT NULL,
  `instructions` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `route` varchar(50) DEFAULT 'Oral',
  `sig_morning` tinyint(1) DEFAULT '0',
  `sig_afternoon` tinyint(1) DEFAULT '0',
  `sig_evening` tinyint(1) DEFAULT '0',
  `sig_night` tinyint(1) DEFAULT '0',
  `stop_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `digital_prescriptions`
--

INSERT INTO `digital_prescriptions` (`id`, `consultation_id`, `medicine_name`, `dosage`, `frequency`, `duration`, `instructions`, `created_at`, `route`, `sig_morning`, `sig_afternoon`, `sig_evening`, `sig_night`, `stop_date`) VALUES
(3, 2, 'Tramadol 50mg', '50mg', 'OD', '', '', '2026-06-27 15:50:40', 'Tablet', 1, 1, 1, 1, NULL),
(4, 2, 'Paracetamol 500mg', '250mg', '', '', '', '2026-06-27 15:50:40', 'Tablet', 0, 0, 1, 0, NULL),
(5, 3, 'Paracetamol 500mg', '250mg', 'OD', '3 Days', '', '2026-06-27 18:15:01', 'Tablet', 1, 1, 0, 1, NULL),
(6, 3, 'Azithromycin 250mg', '250mg', 'TID', '7 Days', '', '2026-06-27 18:15:01', 'Tablet', 0, 1, 0, 1, NULL),
(7, 4, 'Paracetamol 500mg', '250mg', 'OD', '5 Days', '', '2026-06-27 23:14:48', 'Tablet', 1, 0, 0, 1, NULL),
(8, 7, 'Paracetamol 500mg', '250mg', '', '10 Days', '', '2026-06-28 13:05:41', 'Tablet', 1, 0, 1, 0, NULL),
(9, 7, 'Aspirin 75mg', '75mg', '', '1 Month', '', '2026-06-28 13:05:41', 'Tablet', 1, 1, 1, 0, NULL),
(12, 8, 'Paracetamol 650mg', '650mg', 'OD', '3 Days', 'After food, if temp >100°F', '2026-06-29 17:01:00', 'Tablet', 1, 0, 1, 1, NULL),
(13, 8, 'ORS Sachet', '1 sachet in 1L water', 'TID', '3 Days', 'Dissolve in 1 litre water, sip throughout day', '2026-06-29 17:01:00', 'Sachet', 1, 1, 1, 0, NULL),
(14, 9, 'Paracetamol 650mg', '650mg', 'TID', '3 Days', 'After food, if temp >100°F', '2026-06-29 19:50:57', 'Oral', 1, 1, 1, 0, NULL),
(15, 9, 'ORS Sachet', '1 sachet', 'TID', '3 Days', 'Dissolve in 1 litre water, sip throughout day', '2026-06-29 19:50:57', 'Oral', 1, 1, 1, 0, NULL),
(16, 10, 'Paracetamol 650mg', '650mg', 'TID', '3 Days', 'After food, if temp >100°F', '2026-06-29 20:38:37', 'Oral', 1, 1, 1, 0, NULL),
(17, 10, 'ORS Sachet', '1 sachet', 'TID', '3 Days', 'Dissolve in 1 litre water, sip throughout day', '2026-06-29 20:38:37', 'Oral', 1, 1, 1, 0, NULL),
(18, 11, 'Paracetamol 500mg', '250mg', 'OD', '3 Days', '', '2026-07-01 23:02:26', 'Tablet', 1, 0, 1, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `disease_surveillance`
--

CREATE TABLE `disease_surveillance` (
  `id` int NOT NULL,
  `district` varchar(100) NOT NULL,
  `disease` varchar(100) NOT NULL,
  `cases` int DEFAULT '0',
  `trend` varchar(20) DEFAULT NULL,
  `risk_level` enum('LOW','MEDIUM','HIGH') DEFAULT 'LOW',
  `recorded_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `disease_surveillance`
--

INSERT INTO `disease_surveillance` (`id`, `district`, `disease`, `cases`, `trend`, `risk_level`, `recorded_date`, `created_at`) VALUES
(1, 'Ranchi', 'Dengue', 50, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(2, 'Ranchi', 'Malaria', 88, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(3, 'Ranchi', 'Typhoid', 41, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(4, 'Ranchi', 'Cholera', 146, '+5%', 'HIGH', '2026-05-08', '2026-05-07 19:21:58'),
(5, 'Dhanbad', 'Dengue', 89, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(6, 'Dhanbad', 'Malaria', 12, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(7, 'Dhanbad', 'Typhoid', 42, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(8, 'Dhanbad', 'Cholera', 103, '+5%', 'HIGH', '2026-05-08', '2026-05-07 19:21:58'),
(9, 'Bokaro', 'Dengue', 27, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(10, 'Bokaro', 'Malaria', 23, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(11, 'Bokaro', 'Typhoid', 58, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(12, 'Bokaro', 'Cholera', 48, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(13, 'East Singhbhum', 'Dengue', 86, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(14, 'East Singhbhum', 'Malaria', 32, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(15, 'East Singhbhum', 'Typhoid', 8, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(16, 'East Singhbhum', 'Cholera', 59, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(17, 'Hazaribagh', 'Dengue', 80, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(18, 'Hazaribagh', 'Malaria', 10, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(19, 'Hazaribagh', 'Typhoid', 136, '+5%', 'HIGH', '2026-05-08', '2026-05-07 19:21:58'),
(20, 'Hazaribagh', 'Cholera', 115, '+5%', 'HIGH', '2026-05-08', '2026-05-07 19:21:58'),
(21, 'Palamu', 'Dengue', 50, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(22, 'Palamu', 'Malaria', 93, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(23, 'Palamu', 'Typhoid', 3, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(24, 'Palamu', 'Cholera', 47, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(25, 'Deoghar', 'Dengue', 110, '+5%', 'HIGH', '2026-05-08', '2026-05-07 19:21:58'),
(26, 'Deoghar', 'Malaria', 145, '+5%', 'HIGH', '2026-05-08', '2026-05-07 19:21:58'),
(27, 'Deoghar', 'Typhoid', 88, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(28, 'Deoghar', 'Cholera', 111, '+5%', 'HIGH', '2026-05-08', '2026-05-07 19:21:58'),
(29, 'Giridih', 'Dengue', 16, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(30, 'Giridih', 'Malaria', 69, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(31, 'Giridih', 'Typhoid', 40, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(32, 'Giridih', 'Cholera', 67, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(33, 'Ramgarh', 'Dengue', 83, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(34, 'Ramgarh', 'Malaria', 83, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(35, 'Ramgarh', 'Typhoid', 146, '+5%', 'HIGH', '2026-05-08', '2026-05-07 19:21:58'),
(36, 'Ramgarh', 'Cholera', 94, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(37, 'Dumka', 'Dengue', 71, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(38, 'Dumka', 'Malaria', 112, '+5%', 'HIGH', '2026-05-08', '2026-05-07 19:21:58'),
(39, 'Dumka', 'Typhoid', 59, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(40, 'Dumka', 'Cholera', 149, '+5%', 'HIGH', '2026-05-08', '2026-05-07 19:21:58'),
(41, 'Godda', 'Dengue', 136, '+5%', 'HIGH', '2026-05-08', '2026-05-07 19:21:58'),
(42, 'Godda', 'Malaria', 58, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(43, 'Godda', 'Typhoid', 20, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(44, 'Godda', 'Cholera', 93, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(45, 'Sahibganj', 'Dengue', 90, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(46, 'Sahibganj', 'Malaria', 58, '+5%', 'MEDIUM', '2026-05-08', '2026-05-07 19:21:58'),
(47, 'Sahibganj', 'Typhoid', 28, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58'),
(48, 'Sahibganj', 'Cholera', 20, '+5%', 'LOW', '2026-05-08', '2026-05-07 19:21:58');

-- --------------------------------------------------------

--
-- Table structure for table `districts`
--

CREATE TABLE `districts` (
  `id` int NOT NULL,
  `state_id` int DEFAULT '1',
  `name` varchar(100) NOT NULL,
  `state` varchar(100) DEFAULT 'Jharkhand',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `districts`
--

INSERT INTO `districts` (`id`, `state_id`, `name`, `state`, `created_at`) VALUES
(1, 1, 'Ranchi', 'Jharkhand', '2026-04-29 06:07:58'),
(26, 1, 'Dhanbad', 'Jharkhand', '2026-04-29 06:09:13'),
(27, 1, 'Bokaro', 'Jharkhand', '2026-04-29 06:09:13'),
(28, 1, 'East Singhbhum', 'Jharkhand', '2026-04-29 06:09:13'),
(29, 1, 'West Singhbhum', 'Jharkhand', '2026-04-29 06:09:13'),
(30, 1, 'Seraikela Kharsawan', 'Jharkhand', '2026-04-29 06:09:13'),
(31, 1, 'Hazaribagh', 'Jharkhand', '2026-04-29 06:09:13'),
(32, 1, 'Ramgarh', 'Jharkhand', '2026-04-29 06:09:13'),
(33, 1, 'Giridih', 'Jharkhand', '2026-04-29 06:09:13'),
(34, 1, 'Koderma', 'Jharkhand', '2026-04-29 06:09:13'),
(35, 1, 'Chatra', 'Jharkhand', '2026-04-29 06:09:13'),
(36, 1, 'Palamu', 'Jharkhand', '2026-04-29 06:09:13'),
(37, 1, 'Latehar', 'Jharkhand', '2026-04-29 06:09:13'),
(38, 1, 'Garhwa', 'Jharkhand', '2026-04-29 06:09:13'),
(39, 1, 'Lohardaga', 'Jharkhand', '2026-04-29 06:09:13'),
(40, 1, 'Gumla', 'Jharkhand', '2026-04-29 06:09:13'),
(41, 1, 'Simdega', 'Jharkhand', '2026-04-29 06:09:13'),
(42, 1, 'Khunti', 'Jharkhand', '2026-04-29 06:09:13'),
(43, 1, 'Deoghar', 'Jharkhand', '2026-04-29 06:09:13'),
(44, 1, 'Dumka', 'Jharkhand', '2026-04-29 06:09:13'),
(45, 1, 'Godda', 'Jharkhand', '2026-04-29 06:09:13'),
(46, 1, 'Jamtara', 'Jharkhand', '2026-04-29 06:09:13'),
(47, 1, 'Sahebganj', 'Jharkhand', '2026-04-29 06:09:13'),
(48, 1, 'Pakur', 'Jharkhand', '2026-04-29 06:09:13');

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `specialization` varchar(100) DEFAULT NULL,
  `experience_years` int DEFAULT NULL,
  `consultation_fee` decimal(10,2) DEFAULT '0.00',
  `availability_status` enum('Available','On Leave','In Surgery') DEFAULT 'Available',
  `bio` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`id`, `user_id`, `specialization`, `experience_years`, `consultation_fee`, `availability_status`, `bio`, `created_at`) VALUES
(1, 10, 'Emergency', 10, 200.00, 'Available', '', '2026-05-04 15:28:14'),
(2, 11, 'heart', 12, 900.00, 'Available', '', '2026-05-04 16:01:35');

-- --------------------------------------------------------

--
-- Table structure for table `doctor_lab_orders`
--

CREATE TABLE `doctor_lab_orders` (
  `id` int NOT NULL,
  `consultation_id` int NOT NULL,
  `patient_reg_no` varchar(50) NOT NULL,
  `doctor_id` int NOT NULL,
  `test_id` int NOT NULL,
  `status` enum('Pending','Billed','Collected','Completed') DEFAULT 'Pending',
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `urgency` enum('STAT','ASAP','Routine') DEFAULT 'Routine',
  `clinical_indication` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `doctor_lab_orders`
--

INSERT INTO `doctor_lab_orders` (`id`, `consultation_id`, `patient_reg_no`, `doctor_id`, `test_id`, `status`, `order_date`, `urgency`, `clinical_indication`) VALUES
(4, 2, 'REG-53596', 26, 2, 'Pending', '2026-06-27 15:50:40', 'STAT', NULL),
(5, 2, 'REG-53596', 26, 10, 'Pending', '2026-06-27 15:50:40', 'Routine', NULL),
(6, 2, 'REG-53596', 26, 14, 'Pending', '2026-06-27 15:50:40', 'ASAP', NULL),
(7, 3, 'REG-40202', 26, 11, 'Pending', '2026-06-27 18:15:01', 'Routine', NULL),
(8, 3, 'REG-40202', 26, 12, 'Pending', '2026-06-27 18:15:01', 'Routine', NULL),
(9, 4, 'REG-12324', 26, 11, 'Pending', '2026-06-27 23:14:48', 'Routine', NULL),
(10, 4, 'REG-12324', 26, 12, 'Pending', '2026-06-27 23:14:48', 'Routine', NULL),
(11, 7, 'REG-96979', 5, 2, 'Pending', '2026-06-28 13:05:41', 'Routine', NULL),
(14, 8, 'REG-98727', 5, 10, 'Pending', '2026-06-29 17:01:00', 'STAT', NULL),
(15, 8, 'REG-98727', 5, 2, 'Pending', '2026-06-29 17:01:00', 'Routine', NULL),
(16, 11, 'REG-87923', 28, 2, 'Pending', '2026-07-01 23:02:26', 'Routine', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `doctor_schedules`
--

CREATE TABLE `doctor_schedules` (
  `id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `day_of_week` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `slot_duration_mins` int DEFAULT '15',
  `is_active` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `doctor_schedules`
--

INSERT INTO `doctor_schedules` (`id`, `doctor_id`, `day_of_week`, `start_time`, `end_time`, `slot_duration_mins`, `is_active`) VALUES
(16, 1, 'Monday', '09:00:00', '22:41:00', 15, 1),
(17, 1, 'Tuesday', '09:00:00', '17:00:00', 15, 1),
(18, 1, 'Wednesday', '09:00:00', '17:00:00', 15, 1),
(19, 1, 'Thursday', '09:00:00', '17:00:00', 15, 1),
(20, 1, 'Friday', '09:00:00', '17:00:00', 15, 1);

-- --------------------------------------------------------

--
-- Table structure for table `duty_schedules`
--

CREATE TABLE `duty_schedules` (
  `id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `room_id` int NOT NULL,
  `duty_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `price` decimal(10,2) DEFAULT '0.00',
  `notes` text,
  `status` varchar(50) DEFAULT 'Scheduled',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `branch_id` int DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `duty_schedules`
--

INSERT INTO `duty_schedules` (`id`, `doctor_id`, `room_id`, `duty_date`, `start_time`, `end_time`, `price`, `notes`, `status`, `created_at`, `branch_id`) VALUES
(2, 26, 18, '2026-06-27', '04:30:00', '16:30:00', 0.00, '', 'Scheduled', '2026-06-26 23:01:56', NULL),
(3, 11, 18, '2026-06-28', '03:15:00', '15:15:00', 0.00, '', 'Scheduled', '2026-06-27 21:45:51', NULL),
(4, 11, 18, '2026-06-29', '22:24:00', '23:24:00', 0.00, '', 'Scheduled', '2026-06-29 16:54:54', NULL),
(5, 26, 18, '2026-06-29', '22:24:00', '23:25:00', 0.00, '', 'Scheduled', '2026-06-29 16:55:33', NULL),
(6, 26, 18, '2026-06-30', '00:52:00', '12:52:00', 0.00, '', 'Scheduled', '2026-06-29 19:22:45', NULL),
(7, 28, 19, '2026-07-02', '04:30:00', '16:30:00', 0.00, '', 'Scheduled', '2026-07-01 23:00:17', NULL),
(8, 29, 19, '2026-07-02', '04:33:00', '16:33:00', 0.00, '', 'Scheduled', '2026-07-01 23:03:54', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `facility_categories`
--

CREATE TABLE `facility_categories` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `facility_categories`
--

INSERT INTO `facility_categories` (`id`, `name`, `created_at`) VALUES
(1, 'Primary Health Center', '2026-04-29 06:34:22'),
(2, 'District Hospital', '2026-04-29 06:34:22'),
(3, 'Community Health Center', '2026-04-29 06:34:22'),
(4, 'Govt Diagnostic Lab', '2026-04-29 06:34:22');

-- --------------------------------------------------------

--
-- Table structure for table `goods_receipts`
--

CREATE TABLE `goods_receipts` (
  `id` int NOT NULL,
  `grn_number` varchar(50) NOT NULL,
  `po_id` int DEFAULT NULL,
  `vendor_id` int NOT NULL,
  `receipt_date` date NOT NULL,
  `invoice_number` varchar(100) DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT '0.00',
  `tax_amount` decimal(10,2) DEFAULT '0.00',
  `total_amount` decimal(10,2) DEFAULT '0.00',
  `received_by` int NOT NULL,
  `approved_by` int DEFAULT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `notes` text,
  `branch_id` int DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `goods_receipt_items`
--

CREATE TABLE `goods_receipt_items` (
  `id` int NOT NULL,
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
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `holidays`
--

CREATE TABLE `holidays` (
  `id` int NOT NULL,
  `branch_id` int DEFAULT NULL,
  `holiday_name` varchar(200) NOT NULL,
  `holiday_date` date NOT NULL,
  `holiday_type` enum('National','State','Local','Hospital') DEFAULT 'Hospital',
  `is_recurring` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hospital_settings`
--

CREATE TABLE `hospital_settings` (
  `id` int NOT NULL,
  `hospital_name` varchar(255) DEFAULT 'MERIL HIMS',
  `logo_url` longtext,
  `address` text,
  `phone` varchar(50) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `smtp_host` varchar(255) DEFAULT '',
  `smtp_port` int DEFAULT '587',
  `smtp_user` varchar(255) DEFAULT '',
  `smtp_pass` varchar(255) DEFAULT '',
  `smtp_from_name` varchar(255) DEFAULT 'HIMS Procurement',
  `registration_fee` decimal(10,2) DEFAULT '15.00',
  `abdm_hip_id` varchar(100) DEFAULT NULL,
  `abdm_facility_id` varchar(100) DEFAULT NULL,
  `abdm_bridge_url` varchar(500) DEFAULT NULL,
  `abdm_hip_status` varchar(50) DEFAULT 'NOT_REGISTERED'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hospital_settings`
--

INSERT INTO `hospital_settings` (`id`, `hospital_name`, `logo_url`, `address`, `phone`, `website`, `email`, `updated_at`, `smtp_host`, `smtp_port`, `smtp_user`, `smtp_pass`, `smtp_from_name`, `registration_fee`, `abdm_hip_id`, `abdm_facility_id`, `abdm_bridge_url`, `abdm_hip_status`) VALUES
(1, 'Rela Hospital - Multispeciality Hospital', 'data:image/webp;base64,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', 'DR. RELA INSTITUTE & MEDICAL CENTER, \n7, CLC Works Rd, Nagappa Nagar, \nChromepet, Chennai, \nTamil Nadu 600044', '9025740156', 'rela.com', 'stevejerald632@gmail.com', '2026-06-26 22:23:13', '', 587, 'stevejerald632@gmail.com', 'yifk zyee tnlk lhjz', 'Rela LIS', 50.00, 'IN3310002132', 'IN3310002132', NULL, 'ACTIVE');

-- --------------------------------------------------------

--
-- Table structure for table `infrastructure`
--

CREATE TABLE `infrastructure` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` enum('Room','Ward','Lab','Pharmacy') NOT NULL,
  `block` varchar(100) DEFAULT NULL,
  `floor` int DEFAULT NULL,
  `capacity` int DEFAULT NULL,
  `machines_count` int NOT NULL DEFAULT '1',
  `status` enum('Available','Occupied','Maintenance') DEFAULT 'Available',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `branch_id` int DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `infrastructure`
--

INSERT INTO `infrastructure` (`id`, `name`, `type`, `block`, `floor`, `capacity`, `machines_count`, `status`, `created_at`, `branch_id`) VALUES
(11, 'MAIN LAB', 'Lab', 'A', 2, NULL, 1, 'Available', '2026-05-07 21:43:42', 11),
(12, 'panimalar', 'Lab', '1', 2, NULL, 1, 'Available', '2026-05-07 21:44:33', 8),
(14, 'hello Lab', 'Lab', 'A WING', 0, NULL, 1, 'Available', '2026-05-07 21:46:17', 10),
(15, 'vanakam lab', 'Lab', 'A', 1, NULL, 1, 'Available', '2026-05-07 21:47:09', 9),
(16, 'Main', 'Lab', 'A', 0, NULL, 1, 'Available', '2026-05-08 07:07:00', 1),
(17, 'Meril', 'Lab', '', NULL, NULL, 1, 'Available', '2026-06-26 22:57:32', 1),
(18, 'rm0', 'Room', '', NULL, NULL, 1, 'Available', '2026-06-26 22:58:47', 1),
(19, 'Ward 1', 'Room', 'A', 0, NULL, 1, 'Available', '2026-07-01 23:00:03', 17);

-- --------------------------------------------------------

--
-- Table structure for table `inventory_batches`
--

CREATE TABLE `inventory_batches` (
  `id` int NOT NULL,
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
  `branch_id` int DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory_batches`
--

INSERT INTO `inventory_batches` (`id`, `item_id`, `batch_number`, `lot_number`, `manufacturing_date`, `expiry_date`, `vendor_id`, `quantity_received`, `quantity_available`, `quantity_reserved`, `quantity_damaged`, `unit_cost`, `grn_id`, `status`, `open_vial_date`, `stability_days`, `branch_id`, `created_at`, `updated_at`) VALUES
(2, 1, '123', NULL, NULL, '2026-07-16', 4, 30.00, 120.00, 0.00, 0.00, 0.00, NULL, 'Active', NULL, NULL, 1, '2026-04-29 12:34:13', '2026-04-29 12:34:13'),
(3, 1, '123', NULL, NULL, '2026-07-16', 4, 30.00, 0.00, 0.00, 0.00, 0.00, NULL, 'Active', NULL, NULL, 1, '2026-04-29 12:34:53', '2026-04-29 12:46:02'),
(4, 1, '123', NULL, NULL, '2026-07-16', 4, 30.00, 500.00, 0.00, 0.00, 0.00, NULL, 'Active', NULL, NULL, 1, '2026-04-29 12:35:20', '2026-04-30 04:29:37'),
(5, 1, '123', NULL, NULL, '2026-07-16', 4, 120.00, 120.00, 0.00, 0.00, 0.00, NULL, 'Active', NULL, NULL, 7, '2026-04-29 12:46:04', '2026-04-29 12:46:04'),
(6, 1, '123', NULL, NULL, '2026-07-16', 4, 40.00, 40.00, 0.00, 0.00, 0.00, NULL, 'Active', NULL, NULL, 5, '2026-04-29 13:43:19', '2026-04-29 13:43:19'),
(7, 8, 'LOT-101', NULL, NULL, '2026-05-28', 4, 500.00, 300.00, 0.00, 0.00, 0.00, NULL, 'Active', NULL, NULL, 1, '2026-04-30 04:58:36', '2026-05-02 04:38:19'),
(8, 8, 'LOT-101', NULL, NULL, '2026-05-28', 4, 200.00, 100.00, 0.00, 0.00, 0.00, NULL, 'Active', NULL, NULL, 3, '2026-05-02 04:38:26', '2026-05-07 12:57:08'),
(9, 8, 'LOT-101', NULL, NULL, '2026-05-28', 4, 100.00, 100.00, 0.00, 0.00, 0.00, NULL, 'Active', NULL, NULL, 7, '2026-05-07 12:57:09', '2026-05-07 12:57:09');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_items`
--

CREATE TABLE `inventory_items` (
  `id` int NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_item_master`
--

CREATE TABLE `inventory_item_master` (
  `id` int NOT NULL,
  `item_code` varchar(50) NOT NULL,
  `item_name` varchar(200) NOT NULL,
  `category` enum('Consumable','Reagent','Equipment') NOT NULL,
  `unit` varchar(50) NOT NULL,
  `min_stock_level` int DEFAULT '0',
  `reorder_level` int DEFAULT '0',
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `lead_time_days` int DEFAULT '3',
  `safety_stock_buffer` int DEFAULT '20',
  `preferred_vendor_id` int DEFAULT NULL,
  `estimated_cost` decimal(10,2) DEFAULT '0.00',
  `default_vendor_id` int DEFAULT NULL,
  `delivery_lead_time_days` int DEFAULT '3',
  `unit_price` decimal(12,2) DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory_item_master`
--

INSERT INTO `inventory_item_master` (`id`, `item_code`, `item_name`, `category`, `unit`, `min_stock_level`, `reorder_level`, `status`, `created_at`, `updated_at`, `lead_time_days`, `safety_stock_buffer`, `preferred_vendor_id`, `estimated_cost`, `default_vendor_id`, `delivery_lead_time_days`, `unit_price`) VALUES
(1, 'ITEM-001', 'Blood Diluent', 'Reagent', 'ml', 50, 300, 'Active', '2026-04-29 12:28:35', '2026-04-30 03:03:22', 3, 20, NULL, 0.00, 4, 3, 100.00),
(2, 'ITEM-002', 'Cell Lyse', 'Reagent', 'ml', 50, 200, 'Active', '2026-04-30 03:03:53', '2026-04-30 03:03:53', 3, 20, NULL, 0.00, 5, 3, 120.00),
(3, 'ITEM-003', 'Rinse', 'Reagent', 'l', 20, 100, 'Active', '2026-04-30 03:04:19', '2026-04-30 03:04:19', 3, 20, NULL, 0.00, 4, 3, 300.00),
(4, 'ITEM-004', 'Enz Cleaner', 'Reagent', 'l', 50, 150, 'Active', '2026-04-30 03:04:41', '2026-04-30 03:04:41', 3, 20, NULL, 0.00, 4, 3, 250.00),
(5, 'ITEM-005', 'PROBE CLEANER', 'Reagent', 'l', 90, 100, 'Active', '2026-04-30 03:05:07', '2026-04-30 03:05:07', 3, 20, NULL, 0.00, 4, 3, 120.00),
(6, 'ITEM-006', 'Control for CQEdge-1x3ml (L-1)', 'Reagent', 'l', 50, 100, 'Active', '2026-04-30 03:05:41', '2026-04-30 03:05:41', 3, 20, NULL, 0.00, 4, 3, 120.00),
(7, 'ITEM-007', 'Control for CQEdge-1x3ml (L-2)', 'Reagent', 'l', 50, 130, 'Active', '2026-04-30 03:06:03', '2026-04-30 03:06:03', 3, 20, NULL, 0.00, 3, 3, 120.00),
(8, 'ITEM-008', 'Control for CQEdge-1x3ml (L-3)', 'Reagent', 'l', 50, 100, 'Active', '2026-04-30 03:06:22', '2026-04-30 03:06:22', 3, 20, NULL, 0.00, 2, 3, 450.00);

-- --------------------------------------------------------

--
-- Table structure for table `inventory_payments`
--

CREATE TABLE `inventory_payments` (
  `id` int NOT NULL,
  `payment_number` varchar(100) NOT NULL,
  `vendor_id` int NOT NULL,
  `invoice_id` int NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `payment_method` enum('CASH','BANK','UPI','CHEQUE') NOT NULL,
  `reference_no` varchar(100) DEFAULT NULL,
  `paid_by` int DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory_payments`
--

INSERT INTO `inventory_payments` (`id`, `payment_number`, `vendor_id`, `invoice_id`, `amount`, `payment_method`, `reference_no`, `paid_by`, `paid_at`, `created_at`) VALUES
(1, 'PAY-20260430-001', 3, 3, 50000.00, 'CASH', '', 1, '2026-04-30 05:31:15', '2026-04-30 05:31:15'),
(2, 'PAY-20260502-001', 5, 2, 200000.00, 'BANK', '', 1, '2026-05-02 04:34:59', '2026-05-02 04:34:59');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_po_items`
--

CREATE TABLE `inventory_po_items` (
  `id` int NOT NULL,
  `po_id` int NOT NULL,
  `pr_item_id` int DEFAULT NULL,
  `item_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory_po_items`
--

INSERT INTO `inventory_po_items` (`id`, `po_id`, `pr_item_id`, `item_id`, `quantity`, `unit_price`, `subtotal`) VALUES
(1, 1, 1, 1, 20, 12.00, 240.00),
(2, 2, 2, 1, 60, 12.00, 720.00),
(3, 3, 3, 8, 120, 120.00, 14400.00),
(4, 4, 4, 5, 120, 100.00, 12000.00),
(5, 5, 5, 8, 500, 100.00, 50000.00);

-- --------------------------------------------------------

--
-- Table structure for table `inventory_pr_items`
--

CREATE TABLE `inventory_pr_items` (
  `id` int NOT NULL,
  `pr_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity` int NOT NULL,
  `remarks` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory_pr_items`
--

INSERT INTO `inventory_pr_items` (`id`, `pr_id`, `item_id`, `quantity`, `remarks`) VALUES
(1, 2, 1, 20, ''),
(2, 3, 1, 60, ''),
(3, 4, 8, 120, ''),
(4, 5, 5, 120, ''),
(5, 6, 8, 500, '');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_purchase_orders`
--

CREATE TABLE `inventory_purchase_orders` (
  `id` int NOT NULL,
  `po_number` varchar(50) NOT NULL,
  `vendor_id` int NOT NULL,
  `status` enum('DRAFT','ISSUED','COMPLETED','CANCELLED') DEFAULT 'DRAFT',
  `expected_delivery_date` date DEFAULT NULL,
  `total_amount` decimal(12,2) DEFAULT '0.00',
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `remarks` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory_purchase_orders`
--

INSERT INTO `inventory_purchase_orders` (`id`, `po_number`, `vendor_id`, `status`, `expected_delivery_date`, `total_amount`, `created_by`, `created_at`, `updated_at`, `remarks`) VALUES
(1, 'PO-20260429-001', 4, 'DRAFT', '2026-05-01', 240.00, 1, '2026-04-29 12:37:58', '2026-04-29 12:37:58', NULL),
(2, 'PO-20260429-002', 4, 'DRAFT', '2026-05-09', 720.00, 1, '2026-04-29 13:41:48', '2026-04-29 13:41:48', NULL),
(3, 'PO-20260430-001', 5, 'DRAFT', '2026-05-08', 14400.00, 1, '2026-04-30 03:47:11', '2026-04-30 03:47:11', NULL),
(4, 'PO-20260502-001', 5, 'DRAFT', '2026-05-28', 12000.00, 1, '2026-05-02 04:35:59', '2026-05-02 04:35:59', NULL),
(5, 'PO-20260507-001', 5, 'DRAFT', '2026-05-22', 50000.00, 1, '2026-05-07 12:56:22', '2026-05-07 12:56:22', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `inventory_purchase_requisitions`
--

CREATE TABLE `inventory_purchase_requisitions` (
  `id` int NOT NULL,
  `pr_number` varchar(50) NOT NULL,
  `branch_id` int NOT NULL,
  `status` enum('PENDING','APPROVED','REJECTED','PO_CREATED') DEFAULT 'PENDING',
  `requested_by` int DEFAULT NULL,
  `approved_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory_purchase_requisitions`
--

INSERT INTO `inventory_purchase_requisitions` (`id`, `pr_number`, `branch_id`, `status`, `requested_by`, `approved_by`, `created_at`, `updated_at`) VALUES
(2, 'PR-20260429-001', 1, 'PO_CREATED', 1, 1, '2026-04-29 12:37:42', '2026-04-29 12:37:58'),
(3, 'PR-20260429-002', 1, 'PO_CREATED', 1, 1, '2026-04-29 13:41:20', '2026-04-29 13:41:48'),
(4, 'PR-20260430-001', 1, 'PO_CREATED', 1, 1, '2026-04-30 03:46:55', '2026-04-30 03:47:11'),
(5, 'PR-20260502-001', 3, 'PO_CREATED', 1, 1, '2026-05-02 04:35:32', '2026-05-02 04:35:59'),
(6, 'PR-20260507-001', 3, 'PO_CREATED', 1, 1, '2026-05-07 12:56:05', '2026-05-07 12:56:22');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_purchase_suggestions`
--

CREATE TABLE `inventory_purchase_suggestions` (
  `id` int NOT NULL,
  `item_id` int NOT NULL,
  `vendor_id` int DEFAULT NULL,
  `suggested_qty` int NOT NULL,
  `estimated_cost` decimal(10,2) DEFAULT '0.00',
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_stock`
--

CREATE TABLE `inventory_stock` (
  `id` int NOT NULL,
  `item_id` int NOT NULL,
  `current_stock` decimal(10,2) NOT NULL DEFAULT '0.00',
  `available_stock` decimal(10,2) NOT NULL DEFAULT '0.00',
  `reserved_stock` decimal(10,2) NOT NULL DEFAULT '0.00',
  `consumed_stock` decimal(10,2) NOT NULL DEFAULT '0.00',
  `expired_stock` decimal(10,2) NOT NULL DEFAULT '0.00',
  `damaged_stock` decimal(10,2) NOT NULL DEFAULT '0.00',
  `department_id` int DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_stock_transfers`
--

CREATE TABLE `inventory_stock_transfers` (
  `id` int NOT NULL,
  `transfer_number` varchar(50) NOT NULL,
  `from_branch_id` int NOT NULL,
  `to_branch_id` int NOT NULL,
  `status` enum('PENDING','APPROVED','IN_TRANSIT','COMPLETED','CANCELLED') DEFAULT 'PENDING',
  `notes` text,
  `created_by` int DEFAULT NULL,
  `approved_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory_stock_transfers`
--

INSERT INTO `inventory_stock_transfers` (`id`, `transfer_number`, `from_branch_id`, `to_branch_id`, `status`, `notes`, `created_by`, `approved_by`, `created_at`, `updated_at`) VALUES
(1, 'TRF-20260429-001', 1, 7, 'COMPLETED', '', 1, 1, '2026-04-29 12:40:43', '2026-04-29 12:46:04'),
(2, 'TRF-20260429-002', 1, 5, 'COMPLETED', '', 1, 1, '2026-04-29 13:42:41', '2026-04-29 13:43:19'),
(3, 'TRF-20260502-001', 1, 3, 'COMPLETED', '', 1, 1, '2026-05-02 04:38:06', '2026-05-02 04:38:26'),
(4, 'TRF-20260507-001', 3, 7, 'COMPLETED', '', 1, 1, '2026-05-07 12:57:04', '2026-05-07 12:57:09');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_stock_transfer_items`
--

CREATE TABLE `inventory_stock_transfer_items` (
  `id` int NOT NULL,
  `transfer_id` int NOT NULL,
  `item_id` int NOT NULL,
  `batch_id` int NOT NULL,
  `quantity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory_stock_transfer_items`
--

INSERT INTO `inventory_stock_transfer_items` (`id`, `transfer_id`, `item_id`, `batch_id`, `quantity`) VALUES
(1, 1, 1, 3, 120),
(2, 2, 1, 4, 40),
(3, 3, 8, 7, 200),
(4, 4, 8, 8, 100);

-- --------------------------------------------------------

--
-- Table structure for table `inventory_supplier_invoices`
--

CREATE TABLE `inventory_supplier_invoices` (
  `id` int NOT NULL,
  `invoice_number` varchar(100) NOT NULL,
  `vendor_id` int NOT NULL,
  `po_id` int DEFAULT NULL,
  `grn_id` int DEFAULT NULL,
  `invoice_date` date NOT NULL,
  `due_date` date NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `paid_amount` decimal(12,2) DEFAULT '0.00',
  `status` enum('PENDING','PARTIAL','PAID') DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory_supplier_invoices`
--

INSERT INTO `inventory_supplier_invoices` (`id`, `invoice_number`, `vendor_id`, `po_id`, `grn_id`, `invoice_date`, `due_date`, `total_amount`, `paid_amount`, `status`, `created_at`, `updated_at`) VALUES
(1, 'IBV-20261212434', 4, NULL, NULL, '2026-04-17', '2026-05-23', 100000.00, 0.00, 'PENDING', '2026-04-30 05:29:58', '2026-04-30 05:29:58'),
(2, 'INV-12121212', 5, NULL, NULL, '2026-04-25', '2026-04-30', 200000.00, 200000.00, 'PAID', '2026-04-30 05:30:20', '2026-05-02 04:34:59'),
(3, 'IV-1292329', 3, NULL, NULL, '2026-04-30', '2026-05-02', 50000.00, 50000.00, 'PAID', '2026-04-30 05:31:04', '2026-04-30 05:31:15');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_supplier_ledger`
--

CREATE TABLE `inventory_supplier_ledger` (
  `id` int NOT NULL,
  `vendor_id` int NOT NULL,
  `type` enum('INVOICE','PAYMENT') NOT NULL,
  `reference_id` int NOT NULL,
  `debit` decimal(12,2) DEFAULT '0.00',
  `credit` decimal(12,2) DEFAULT '0.00',
  `balance` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory_supplier_ledger`
--

INSERT INTO `inventory_supplier_ledger` (`id`, `vendor_id`, `type`, `reference_id`, `debit`, `credit`, `balance`, `created_at`) VALUES
(1, 4, 'INVOICE', 1, 100000.00, 0.00, 100000.00, '2026-04-30 05:29:58'),
(2, 5, 'INVOICE', 2, 200000.00, 0.00, 200000.00, '2026-04-30 05:30:20'),
(3, 3, 'INVOICE', 3, 50000.00, 0.00, 50000.00, '2026-04-30 05:31:04'),
(4, 3, 'PAYMENT', 1, 0.00, 50000.00, 0.00, '2026-04-30 05:31:15'),
(5, 5, 'PAYMENT', 2, 0.00, 200000.00, 0.00, '2026-05-02 04:34:59');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_test_mapping`
--

CREATE TABLE `inventory_test_mapping` (
  `id` int NOT NULL,
  `test_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity_required` decimal(10,2) NOT NULL DEFAULT '1.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory_test_mapping`
--

INSERT INTO `inventory_test_mapping` (`id`, `test_id`, `item_id`, `quantity_required`) VALUES
(1, 4, 1, 5.00);

-- --------------------------------------------------------

--
-- Table structure for table `inventory_transactions`
--

CREATE TABLE `inventory_transactions` (
  `id` int NOT NULL,
  `item_id` int NOT NULL,
  `batch_id` int NOT NULL,
  `type` enum('IN','OUT','ADJUSTMENT') NOT NULL,
  `quantity` int NOT NULL,
  `reference_type` varchar(50) DEFAULT 'Manual',
  `reference_id` varchar(100) DEFAULT NULL,
  `remarks` text,
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `branch_id` int DEFAULT NULL,
  `test_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `inventory_transactions`
--

INSERT INTO `inventory_transactions` (`id`, `item_id`, `batch_id`, `type`, `quantity`, `reference_type`, `reference_id`, `remarks`, `created_by`, `created_at`, `branch_id`, `test_id`) VALUES
(1, 1, 3, 'OUT', 120, 'Transfer', 'TRF-20260429-001', 'Dispatched transfer to other branch', 1, '2026-04-29 12:46:02', 1, NULL),
(2, 1, 5, 'IN', 120, 'Transfer', 'TRF-20260429-001', 'Received transfer from other branch', 1, '2026-04-29 12:46:04', 7, NULL),
(3, 1, 4, 'OUT', 40, 'Transfer', 'TRF-20260429-002', 'Dispatched transfer to other branch', 1, '2026-04-29 13:43:03', 1, NULL),
(4, 1, 6, 'IN', 40, 'Transfer', 'TRF-20260429-002', 'Received transfer from other branch', 1, '2026-04-29 13:43:19', 5, NULL),
(5, 8, 7, 'OUT', 200, 'Transfer', 'TRF-20260502-001', 'Dispatched transfer to other branch', 1, '2026-05-02 04:38:19', 1, NULL),
(6, 8, 8, 'IN', 200, 'Transfer', 'TRF-20260502-001', 'Received transfer from other branch', 1, '2026-05-02 04:38:26', 3, NULL),
(7, 8, 8, 'OUT', 100, 'Transfer', 'TRF-20260507-001', 'Dispatched transfer to other branch', 1, '2026-05-07 12:57:08', 3, NULL),
(8, 8, 9, 'IN', 100, 'Transfer', 'TRF-20260507-001', 'Received transfer from other branch', 1, '2026-05-07 12:57:09', 7, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `lab_categories`
--

CREATE TABLE `lab_categories` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `lab_categories`
--

INSERT INTO `lab_categories` (`id`, `name`, `description`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Hematology', 'Complete blood count and related tests', 'Active', '2026-04-14 22:59:04', '2026-04-14 22:59:04'),
(2, 'Biochemistry', 'Chemical analysis of blood and body fluids', 'Active', '2026-04-14 22:59:04', '2026-04-14 22:59:04'),
(3, 'Microbiology', 'Culture and sensitivity tests', 'Active', '2026-04-14 22:59:04', '2026-04-14 22:59:04'),
(4, 'Serology', 'Antibody and antigen detection', 'Active', '2026-04-14 22:59:04', '2026-04-14 22:59:04'),
(5, 'Histopathology', 'Tissue examination', 'Active', '2026-04-14 22:59:04', '2026-04-14 22:59:04'),
(6, 'Immunology', 'Immune system tests', 'Active', '2026-04-14 22:59:04', '2026-04-14 22:59:04'),
(7, 'Endocrinology', 'Hormone tests', 'Active', '2026-04-14 22:59:04', '2026-04-14 22:59:04'),
(8, 'Toxicology', 'Drug and toxin analysis', 'Active', '2026-04-14 22:59:04', '2026-04-14 22:59:04'),
(9, 'Critical Care', 'Critical Care', 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06'),
(10, 'Clinical Pathology', 'Clinical Pathology', 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39');

-- --------------------------------------------------------

--
-- Table structure for table `lab_machines`
--

CREATE TABLE `lab_machines` (
  `id` int NOT NULL,
  `lab_id` int NOT NULL,
  `machine_id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `model` varchar(100) DEFAULT NULL,
  `manufacturer` varchar(100) DEFAULT NULL,
  `status` enum('Active','Inactive','Maintenance') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `serial_number` varchar(100) DEFAULT NULL,
  `interface_type` varchar(20) DEFAULT NULL,
  `port_ip` varchar(255) DEFAULT NULL,
  `baud_rate` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lab_sample_sequences`
--

CREATE TABLE `lab_sample_sequences` (
  `id` int NOT NULL,
  `branch_id` int NOT NULL,
  `seq_date` date NOT NULL,
  `dept_key` varchar(10) NOT NULL,
  `last_seq` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `lab_sample_sequences`
--

INSERT INTO `lab_sample_sequences` (`id`, `branch_id`, `seq_date`, `dept_key`, `last_seq`) VALUES
(1, 17, '2026-07-02', '3000', 3000);

-- --------------------------------------------------------

--
-- Table structure for table `lab_tests`
--

CREATE TABLE `lab_tests` (
  `id` int NOT NULL,
  `test_code` varchar(50) NOT NULL,
  `test_name` varchar(200) NOT NULL,
  `category_id` int NOT NULL,
  `lab_id` int DEFAULT NULL,
  `sample_type` varchar(100) NOT NULL,
  `tube_color` varchar(50) DEFAULT NULL,
  `storage_conditions` text,
  `methodology` text,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `price` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `analyzer_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `lab_tests`
--

INSERT INTO `lab_tests` (`id`, `test_code`, `test_name`, `category_id`, `lab_id`, `sample_type`, `tube_color`, `storage_conditions`, `methodology`, `status`, `price`, `created_at`, `updated_at`, `analyzer_name`) VALUES
(2, 'CBC', 'Complete Blood Cholestrol', 2, 16, 'Blood', 'Purple', '', '', 'Active', 500.00, '2026-05-10 02:56:13', '2026-05-10 02:56:13', 'CelQuant Edge'),
(4, 'KFT', 'Kidney Function Test', 2, 16, 'Blood', 'Purple', '', '', 'Active', 200.00, '2026-05-10 05:45:03', '2026-05-10 05:45:03', 'CliniQuant Micro'),
(5, 'ELYTES', 'Electrolyte Panel', 2, NULL, 'Serum / Plasma', NULL, NULL, NULL, 'Active', NULL, '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'HDC-Lyte Plus'),
(6, 'SE', 'Serum Electrolytes', 2, NULL, 'Serum', NULL, NULL, NULL, 'Active', NULL, '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'HDC-Lyte Plus'),
(7, 'ELCA', 'Electrolyte with iCa', 2, NULL, 'Whole Blood / Serum', NULL, NULL, NULL, 'Active', 200.00, '2026-05-23 01:58:06', '2026-05-23 09:53:25', 'HDC-Lyte Plus'),
(8, 'ICA', 'Ionized Calcium', 2, NULL, 'Whole Blood', NULL, NULL, NULL, 'Active', NULL, '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'HDC-Lyte Plus'),
(9, 'LI', 'Serum Lithium', 2, NULL, 'Serum', NULL, NULL, NULL, 'Active', NULL, '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'HDC-Lyte Plus'),
(10, 'BGE', 'Blood Gas Electrolytes', 9, NULL, 'Arterial Blood', NULL, NULL, NULL, 'Active', NULL, '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'HDC-Lyte Plus'),
(11, 'URM', 'Urine Routine & Microscopy (URM)', 10, 1, 'Urine', NULL, NULL, NULL, 'Active', NULL, '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'LAURA Smart'),
(12, 'URE', 'Urine Routine Examination (URE)', 10, 1, 'Urine', NULL, NULL, NULL, 'Active', 400.00, '2026-05-23 06:48:39', '2026-05-23 07:00:20', 'LAURA Smart'),
(13, 'UTI', 'UTI Screening', 10, 1, 'Urine', NULL, NULL, NULL, 'Active', NULL, '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'LAURA Smart'),
(14, 'DUS', 'Diabetes Urine Screening', 10, 1, 'Urine', NULL, NULL, NULL, 'Active', NULL, '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'LAURA Smart'),
(15, 'KIDNEY', 'Kidney Screening', 10, 1, 'Urine', NULL, NULL, NULL, 'Active', NULL, '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'LAURA Smart'),
(16, 'LIVER', 'Liver Screening', 10, 1, 'Urine', NULL, NULL, NULL, 'Active', NULL, '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'LAURA Smart'),
(17, 'UNM-534337', 'Analyzer Auto-Test', 1, NULL, 'Serum', NULL, NULL, NULL, 'Active', 0.00, '2026-05-23 18:05:34', '2026-05-23 18:05:34', NULL),
(18, 'URES', 'urine Routune', 2, NULL, 'Urine', '', '', '', 'Active', 100.00, '2026-06-11 05:21:49', '2026-06-11 05:21:49', 'LAURA Smart');

-- --------------------------------------------------------

--
-- Table structure for table `lab_test_parameters`
--

CREATE TABLE `lab_test_parameters` (
  `id` int NOT NULL,
  `test_id` int NOT NULL,
  `parameter_code` varchar(10) DEFAULT NULL,
  `parameter_name` varchar(200) NOT NULL,
  `parameter_unit` varchar(50) DEFAULT NULL,
  `result_type` enum('numeric','text','select') DEFAULT 'numeric',
  `min_value` decimal(10,2) DEFAULT NULL,
  `max_value` decimal(10,2) DEFAULT NULL,
  `men_min_value` decimal(10,2) DEFAULT NULL,
  `men_max_value` decimal(10,2) DEFAULT NULL,
  `women_min_value` decimal(10,2) DEFAULT NULL,
  `women_max_value` decimal(10,2) DEFAULT NULL,
  `kids_min_value` decimal(10,2) DEFAULT NULL,
  `kids_max_value` decimal(10,2) DEFAULT NULL,
  `use_demographic_ranges` tinyint(1) DEFAULT '0',
  `display_order` int DEFAULT '0',
  `is_calculated` tinyint(1) DEFAULT '0',
  `formula` text,
  `options` text,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `machine_parameter_code` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `lab_test_parameters`
--

INSERT INTO `lab_test_parameters` (`id`, `test_id`, `parameter_code`, `parameter_name`, `parameter_unit`, `result_type`, `min_value`, `max_value`, `men_min_value`, `men_max_value`, `women_min_value`, `women_max_value`, `kids_min_value`, `kids_max_value`, `use_demographic_ranges`, `display_order`, `is_calculated`, `formula`, `options`, `status`, `created_at`, `updated_at`, `machine_parameter_code`) VALUES
(1, 1, NULL, 'UREA', 'mg/dL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-03 14:30:51', '2026-05-03 14:30:51', '12'),
(2, 1, NULL, 'URIC-ACID', 'mg/dL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-03 14:30:51', '2026-05-03 14:30:51', '13'),
(3, 1, NULL, 'CREAT', 'mg/dL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2, 0, NULL, NULL, 'Active', '2026-05-03 14:30:51', '2026-05-03 14:30:51', '19'),
(4, 2, NULL, 'WBC', '10^3/µL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '6690-2'),
(5, 2, NULL, 'RBC', '10^6/µL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '789-8'),
(6, 2, NULL, 'HGB', 'g/dL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '718-7'),
(7, 2, NULL, 'MCHC', 'g/dL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '786-4'),
(8, 2, NULL, 'MCH', 'pg', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 4, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '785-6'),
(9, 2, NULL, 'HCT', '%', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 5, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '4544-3'),
(10, 2, NULL, 'RDW-CV', '%', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 6, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '788-0'),
(11, 2, NULL, 'RDW-SD', 'fL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 7, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '70-5'),
(12, 2, NULL, 'PLT', '10^3/µL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 8, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '777-3'),
(13, 2, NULL, 'PCT', '%', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 9, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '10002'),
(14, 2, NULL, 'PDW', 'fL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 10, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '32207-3'),
(15, 2, NULL, 'MPV', 'fL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 11, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '32623-1'),
(16, 2, NULL, 'Lymph#', '10^3/µL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 12, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '731-0'),
(17, 2, NULL, 'Lymph%', '%', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 13, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '736-9'),
(18, 2, NULL, 'Mid#', '10^3/µL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 14, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '10027'),
(19, 2, NULL, 'Gran%', '%', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 15, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '10030'),
(20, 2, NULL, 'Gran#', '10^3/µL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 16, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '10028'),
(21, 2, NULL, 'Mid%', '%', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 17, 0, NULL, NULL, 'Active', '2026-05-03 15:28:23', '2026-05-03 15:28:23', '10029'),
(22, 1, NULL, 'URIC-ACID', 'mg/dL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-10 02:55:38', '2026-05-10 02:55:38', '13'),
(23, 1, NULL, 'CREAT', 'mg/dL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-10 02:55:38', '2026-05-10 02:55:38', '19'),
(24, 2, NULL, 'WBC', '10^3/µL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-10 02:56:13', '2026-05-10 02:56:13', '6690-2'),
(25, 2, NULL, 'RBC', '10^6/µL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-10 02:56:13', '2026-05-10 02:56:13', '789-8'),
(26, 2, NULL, 'HGB', 'g/dL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2, 0, NULL, NULL, 'Active', '2026-05-10 02:56:13', '2026-05-10 02:56:13', '718-7'),
(27, 2, NULL, 'HCT', '%', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 0, NULL, NULL, 'Active', '2026-05-10 02:56:13', '2026-05-10 02:56:13', '4544-3'),
(28, 2, NULL, 'MCH', 'pg', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 4, 0, NULL, NULL, 'Active', '2026-05-10 02:56:13', '2026-05-10 02:56:13', '785-6'),
(29, 2, NULL, 'MCHC', 'g/dL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 5, 0, NULL, NULL, 'Active', '2026-05-10 02:56:13', '2026-05-10 02:56:13', '786-4'),
(30, 2, NULL, 'RDW-CV', '%', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 6, 0, NULL, NULL, 'Active', '2026-05-10 02:56:13', '2026-05-10 02:56:13', '788-0'),
(31, 2, NULL, 'RDW-SD', 'fL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 7, 0, NULL, NULL, 'Active', '2026-05-10 02:56:13', '2026-05-10 02:56:13', '70-5'),
(32, 2, NULL, 'PLT', '10^3/µL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 8, 0, NULL, NULL, 'Active', '2026-05-10 02:56:13', '2026-05-10 02:56:13', '777-3'),
(33, 2, NULL, 'MPV', 'fL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 9, 0, NULL, NULL, 'Active', '2026-05-10 02:56:13', '2026-05-10 02:56:13', '32623-1'),
(34, 2, NULL, 'PDW', 'fL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 10, 0, NULL, NULL, 'Active', '2026-05-10 02:56:13', '2026-05-10 02:56:13', '32207-3'),
(35, 2, NULL, 'PCT', '%', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 11, 0, NULL, NULL, 'Active', '2026-05-10 02:56:13', '2026-05-10 02:56:13', '10002'),
(36, 2, NULL, 'Lymph#', '10^3/µL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 12, 0, NULL, NULL, 'Active', '2026-05-10 02:56:13', '2026-05-10 02:56:13', '731-0'),
(37, 2, NULL, 'Lymph%', '%', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 13, 0, NULL, NULL, 'Active', '2026-05-10 02:56:13', '2026-05-10 02:56:13', '736-9'),
(38, 4, NULL, 'URIC-ACID', 'mg/dL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-10 05:45:03', '2026-05-10 05:45:03', '13'),
(39, 4, NULL, 'CREAT', 'mg/dL', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-10 05:45:03', '2026-05-10 05:45:03', '19'),
(40, 5, 'NA', 'Sodium', 'mmol/L', 'numeric', 135.00, 145.00, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'Na'),
(41, 5, 'K', 'Potassium', 'mmol/L', 'numeric', 3.50, 5.50, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'K'),
(42, 5, 'CL', 'Chloride', 'mmol/L', 'numeric', 98.00, 107.00, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'Cl'),
(43, 6, 'NA', 'Sodium', 'mmol/L', 'numeric', 135.00, 145.00, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'Na'),
(44, 6, 'K', 'Potassium', 'mmol/L', 'numeric', 3.50, 5.50, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'K'),
(45, 6, 'CL', 'Chloride', 'mmol/L', 'numeric', 98.00, 107.00, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'Cl'),
(46, 7, 'NA', 'Sodium', 'mmol/L', 'numeric', 135.00, 145.00, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'Na'),
(47, 7, 'K', 'Potassium', 'mmol/L', 'numeric', 3.50, 5.50, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'K'),
(48, 7, 'CL', 'Chloride', 'mmol/L', 'numeric', 98.00, 107.00, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'Cl'),
(49, 7, 'ICA', 'Ionized Calcium', 'mmol/L', 'numeric', 1.10, 1.35, NULL, NULL, NULL, NULL, NULL, NULL, 0, 4, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'iCa'),
(50, 8, 'ICA', 'Ionized Calcium', 'mmol/L', 'numeric', 1.10, 1.35, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'iCa'),
(51, 9, 'LI', 'Lithium', 'mmol/L', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'Li'),
(52, 10, 'PH', 'pH', 'pH', 'numeric', 7.35, 7.45, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'pH'),
(53, 10, 'NA', 'Sodium', 'mmol/L', 'numeric', 135.00, 145.00, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'Na'),
(54, 10, 'K', 'Potassium', 'mmol/L', 'numeric', 3.50, 5.50, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'K'),
(55, 10, 'CL', 'Chloride', 'mmol/L', 'numeric', 98.00, 107.00, NULL, NULL, NULL, NULL, NULL, NULL, 0, 4, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'Cl'),
(56, 10, 'ICA', 'Ionized Calcium', 'mmol/L', 'numeric', 1.10, 1.35, NULL, NULL, NULL, NULL, NULL, NULL, 0, 5, 0, NULL, NULL, 'Active', '2026-05-23 01:58:06', '2026-05-23 01:58:06', 'iCa'),
(57, 11, 'GLU', 'Glucose', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'GLU'),
(58, 11, 'BIL', 'Bilirubin', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'BIL'),
(59, 11, 'KET', 'Ketone', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'KET'),
(60, 11, 'SG', 'Specific Gravity', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 4, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'SG'),
(61, 11, 'BLD', 'Blood', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 5, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'BLD'),
(62, 11, 'PH', 'pH', 'pH', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 6, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'pH'),
(63, 11, 'PRO', 'Protein', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 7, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'PRO'),
(64, 11, 'UBG', 'Urobilinogen', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 8, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'UBG'),
(65, 11, 'NIT', 'Nitrite', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 9, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'NIT'),
(66, 11, 'LEU', 'Leukocytes', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 10, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'LEU'),
(67, 12, 'SG', 'Specific Gravity', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'SG'),
(68, 12, 'LEU', 'Leukocytes', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'LEU'),
(69, 12, 'NIT', 'Nitrite', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'NIT'),
(70, 12, 'PH', 'pH', 'pH', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 4, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'pH'),
(71, 12, 'PRO', 'Protein', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 5, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'PRO'),
(72, 12, 'GLU', 'Glucose', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 6, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'GLU'),
(73, 12, 'KET', 'Ketone', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 7, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'KET'),
(74, 12, 'UBG', 'Urobilinogen', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 8, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'UBG'),
(75, 12, 'BIL', 'Bilirubin', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 9, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'BIL'),
(76, 12, 'BLD', 'Blood', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 10, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'BLD'),
(77, 13, 'LEU', 'Leukocytes', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'LEU'),
(78, 13, 'NIT', 'Nitrite', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'NIT'),
(79, 14, 'GLU', 'Glucose', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'GLU'),
(80, 14, 'KET', 'Ketone', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'KET'),
(81, 15, 'PRO', 'Protein', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'PRO'),
(82, 15, 'SG', 'Specific Gravity', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'SG'),
(83, 15, 'BLD', 'Blood', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'BLD'),
(84, 16, 'UBG', 'Urobilinogen', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'UBG'),
(85, 16, 'BIL', 'Bilirubin', '', 'numeric', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 2, 0, NULL, NULL, 'Active', '2026-05-23 06:48:39', '2026-05-23 06:48:39', 'BIL');

-- --------------------------------------------------------

--
-- Table structure for table `lab_test_result`
--

CREATE TABLE `lab_test_result` (
  `id` int NOT NULL,
  `bill_item_id` int DEFAULT NULL,
  `patient_id` int DEFAULT NULL,
  `sample_id` varchar(50) NOT NULL,
  `machine_no` varchar(50) DEFAULT NULL,
  `test_id` int DEFAULT NULL,
  `test_name` varchar(200) DEFAULT NULL,
  `results_json` json NOT NULL,
  `tested_by` int DEFAULT NULL,
  `verified_by` int DEFAULT NULL,
  `tested_at` timestamp NULL DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `notes` text,
  `status` enum('Pending','Test Done','Verified','Approved') DEFAULT 'Pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `branch_id` int DEFAULT '1',
  `approved_by` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `id` int NOT NULL,
  `reg_no` varchar(50) NOT NULL,
  `reg_date` date NOT NULL,
  `is_new_born` tinyint(1) DEFAULT '0',
  `photo_base64` longtext,
  `title` varchar(20) DEFAULT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) NOT NULL,
  `dob` date DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `aadhar_number` varchar(50) DEFAULT NULL,
  `abha_id` varchar(50) DEFAULT NULL,
  `abha_address` varchar(255) DEFAULT NULL,
  `marital_status` varchar(50) DEFAULT NULL,
  `occupation` varchar(100) DEFAULT NULL,
  `language` varchar(50) DEFAULT NULL,
  `education_level` varchar(100) DEFAULT NULL,
  `religion` varchar(50) DEFAULT NULL,
  `citizen` varchar(50) DEFAULT NULL,
  `email_id` varchar(100) DEFAULT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `file_required` tinyint(1) DEFAULT '0',
  `address` varchar(255) DEFAULT NULL,
  `suburb` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `postal_code` varchar(50) DEFAULT NULL,
  `postal_address_check` tinyint(1) DEFAULT '0',
  `kin_same_address` tinyint(1) DEFAULT '0',
  `kin_name` varchar(100) DEFAULT NULL,
  `kin_relation` varchar(50) DEFAULT NULL,
  `kin_telephone` varchar(20) DEFAULT NULL,
  `kin_address` varchar(255) DEFAULT NULL,
  `kin_suburb` varchar(100) DEFAULT NULL,
  `kin_city` varchar(100) DEFAULT NULL,
  `kin_country` varchar(50) DEFAULT NULL,
  `kin_code` varchar(50) DEFAULT NULL,
  `payer_type` varchar(100) DEFAULT NULL,
  `insurance_provider` varchar(100) DEFAULT NULL,
  `policy_number` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `branch_id` int DEFAULT '1',
  `phr_address` varchar(100) DEFAULT NULL,
  `abdm_txn_id` varchar(100) DEFAULT NULL,
  `aadhaar_verified` tinyint(1) DEFAULT '0',
  `mobile_verified` tinyint(1) DEFAULT '0',
  `abha_token` text,
  `abha_x_token` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`id`, `reg_no`, `reg_date`, `is_new_born`, `photo_base64`, `title`, `first_name`, `middle_name`, `last_name`, `dob`, `gender`, `aadhar_number`, `abha_id`, `abha_address`, `marital_status`, `occupation`, `language`, `education_level`, `religion`, `citizen`, `email_id`, `telephone`, `file_required`, `address`, `suburb`, `city`, `country`, `postal_code`, `postal_address_check`, `kin_same_address`, `kin_name`, `kin_relation`, `kin_telephone`, `kin_address`, `kin_suburb`, `kin_city`, `kin_country`, `kin_code`, `payer_type`, `insurance_provider`, `policy_number`, `created_at`, `branch_id`, `phr_address`, `abdm_txn_id`, `aadhaar_verified`, `mobile_verified`, `abha_token`, `abha_x_token`) VALUES
(1, 'REG-98727', '2026-06-27', 0, NULL, '', 'Steve', '', 'Jerald J B', '2005-10-16', 'Male', NULL, NULL, NULL, '', '', '', '', '', '', '', '9025740156', 0, '', '', '', '', '', 0, 0, '', '', '', '', '', '', '', '', '', '', '', '2026-06-27 06:59:05', 1, NULL, NULL, 0, 0, NULL, NULL),
(2, 'REG-53596', '2026-06-27', 0, NULL, '', 'Jeffin', '', 'Mervick', '2005-10-16', 'Male', NULL, NULL, NULL, '', '', '', '', '', '', '', '9940016368', 0, '', '', '', '', '', 0, 0, '', '', '', '', '', '', '', '', '', '', '', '2026-06-27 08:18:55', 1, NULL, NULL, 0, 0, NULL, NULL),
(3, 'REG-40202', '2026-06-27', 0, NULL, '', 'Vasanth', '', 'Sandeep', '2005-12-07', 'Male', NULL, NULL, NULL, '', '', '', '', '', '', '', '9345995944', 0, '', '', '', '', '', 0, 0, '', '', '', '', '', '', '', '', '', '', '', '2026-06-27 18:10:30', 1, NULL, NULL, 0, 0, NULL, NULL),
(4, 'REG-87923', '2026-06-27', 0, NULL, '', 'Bhaskar', '', 'Sekar', '1979-06-25', 'Male', NULL, NULL, 'bhaskarsekar@sbx', '', '', '', '', '', '', '', '8925386821', 0, '', '', '', '', '', 0, 0, '', '', '', '', '', '', '', '', '', '', '', '2026-06-27 21:45:13', 1, NULL, NULL, 0, 0, NULL, NULL),
(5, 'REG-12324', '2026-06-27', 0, 'data:image/jpeg;base64,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', '', 'Selvamary', '', 'J', '1980-01-17', 'Female', NULL, '91-7515-6273-8508', 'selvamaryj@sbx', '', '', '', '', '', 'India', '', '9940016368', 0, 'C3 Ground Floor Revathy Flats Durgalakshmi Apts, 10th Cross Street Anna Nagar, Pammal, Pammal, Kancheepuram, Tamil Nadu', '', 'CHENGALPATTU', 'India', '600075', 0, 0, '', '', '', '', '', '', '', '', '', '', '', '2026-06-27 23:13:08', 1, NULL, NULL, 0, 0, NULL, 'eyJhbGciOiJSUzUxMiJ9.eyJpc0t5Y1ZlcmlmaWVkIjp0cnVlLCJ1dGNUaW1lc3RhbXAiOiIyMDI2LTA2LTI3VDIzOjEzOjAxLjY1OTYxNjQyOFoiLCJzdWIiOiI5MS03NTE1LTYyNzMtODUwOCIsImF1dGhfdHlwZSI6Ik9UUF9BVVRIX1ZFUklGWSIsImNsaWVudElkIjoiYWJoYS1wcm9maWxlLWFwcC1hcGkiLCJhY2NvdW50VHlwZSI6InN0YW5kYXJkIiwiZ2VuX3NvdXJjZSI6Im1vYmlsZV9vdHAiLCJtb2JpbGUiOiI5OTQwMDE2MzY4IiwidHlwIjoiVHJhbnNhY3Rpb24iLCJhcGlfdmVyc2lvbiI6InYzIiwic3lzdGVtIjoiQUJIQS1OIiwiYWJoYU51bWJlciI6IjkxLTc1MTUtNjI3My04NTA4IiwicHJlZmVycmVkQWJoYUFkZHJlc3MiOiJzZWx2YW1hcnlqQHNieCIsImJhYWxfYWJoYSI6Im5vIiwiZXhwIjoxNzgyNjAzNzgxLCJpYXQiOjE3ODI2MDE5ODEsInR4bklkIjoiNGMxZWY3ZGYtYjFlZC00OTRkLThmMzUtZmNlNGY5ODlkZDRiIn0.G78WdjaE1KEdcfGkC0UKJXPe16M_4K_RFTf3-qXbMiljPtpgGrEZUNIk8bisNK15cCtvEn5XQmm814qlK4md2YnCY-cTjoCuyFL9qQ3iDLwT3m8VvRP8kZc_Z7d2tQO1zbyzvsDhSl2x1jH_-T0lNUxnn2TT1FXfRjGzJ1Zv0FwHOf2YcsMcQpmKBhATzt-whM92DEfqjCU0X8KI7lEwB2_CjgRr4PtpCxPSASms9kQ8MV_IYrsQ73a1-UCrG3vjLSemGeax1pH1f78rNYo-Gwy2Ehyd8y7RikWC_97rNgAQNNtlQ2j0bxeVhSv_VQl5JIHHjD_AFuPTaDkuSa_QkAZPNvAF8EY3T_cWIGNKK5UkkvPtxyi2QVlbAwYuyeloaWr3Pj6uaH98lTIDdS3IWxrotcu3cdbHMeUUWhIiDs6h-Nt3CrgDfQU4lIwpXP59eyUXalIqeMI6qQzXgtHLjVwWz8bBhnlkb7bjWY7RcfCCJFgWUnghirVTTx8jIfJpdWICLZeowWRcgbJQrtjjWp0CVf7t4IQTfq1x_Pxz2g_2bJ8QfNe-I59liQRcF42IcKD_oStv7oWKAyCTr8JuqapRfjd1TOINnmC_TfZjJ2KukQ8CJ5vN26PJPBL-JwIiSJHeotRky_IPU5HRbw5fs2ToeD1gd17t301DN3B19F4'),
(6, 'REG-27782', '2026-06-28', 0, 'data:image/jpeg;base64,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', '', 'Steve', 'Jerald J', 'B', '2005-10-16', 'Male', NULL, '91-5346-6164-2817', 'john.doeasd123@sbx', '', '', '', '', '', 'India', 'stevejerald2@poxiatechnologies.com', '9025740156', 0, 'C3 Ground Floor Revathi Flats Durgalakshmi Appt, Anna Nagar 10th Cross Street, Sai Bala Supermarket, Pammal, Pammal, Kancheepuram, Tamil Nadu', '', 'CHENGALPATTU', 'India', '600075', 0, 0, '', '', '', '', '', '', '', '', '', '', '', '2026-06-28 12:49:59', 1, NULL, NULL, 0, 0, NULL, 'eyJhbGciOiJSUzUxMiJ9.eyJpc0t5Y1ZlcmlmaWVkIjp0cnVlLCJ1dGNUaW1lc3RhbXAiOiIyMDI2LTA2LTI4VDEyOjQ5OjUwLjg4NjU3MjIyNloiLCJzdWIiOiI5MS01MzQ2LTYxNjQtMjgxNyIsImF1dGhfdHlwZSI6Ik9UUF9BVVRIX1ZFUklGWSIsImNsaWVudElkIjoiYWJoYS1wcm9maWxlLWFwcC1hcGkiLCJhY2NvdW50VHlwZSI6InN0YW5kYXJkIiwiZ2VuX3NvdXJjZSI6Im1vYmlsZV9vdHAiLCJtb2JpbGUiOiI5MDI1NzQwMTU2IiwidHlwIjoiVHJhbnNhY3Rpb24iLCJhcGlfdmVyc2lvbiI6InYzIiwic3lzdGVtIjoiQUJIQS1OIiwiYWJoYU51bWJlciI6IjkxLTUzNDYtNjE2NC0yODE3IiwicHJlZmVycmVkQWJoYUFkZHJlc3MiOiJqb2huLmRvZWFzZDEyM0BzYngiLCJiYWFsX2FiaGEiOiJubyIsImV4cCI6MTc4MjY1Mjc5MCwiaWF0IjoxNzgyNjUwOTkwLCJ0eG5JZCI6IjA0YmFkMjFhLTI0M2YtNGZmYS1iMzRlLWFkYTExNmMxNjc5ZSJ9.X_qf2S0-_hFDZSDNXxsOXo_12OrQtiWu-AWMRP7vpyyITXZArMPoDmG6eq0-5jHY7DlJYKVYSdiwQLnf-ngd-IzHnGz74dx9pB4wYLgfgP-IxiEkZcSgInsKb2xu3yMZ9CiVt2K0HYNgpDForlyR9b_Vebw2MjUHtw8Lm5pIEW8Y5LJ8JW7Q5tB2X9usDm1MI5A86_zVCD4Z7-YUJAXUY0EGehA-EKFKAA_r9-AX65rJebaWSrHMqqK9qLVgk6lA6179zuJN4R62Hpz4l-gbWw9Nr-qH_uhs-yqFmUXlQC-FCHIFeKsO3D5j9swThBrm3BJ68j_b2F41ykqUlhFoxuRLDmkDZ4R3DmN-Qd4XP5B38bIAmtO-TfSNoLxk83yO6rOm7iice_Z7p2OJLlvG_-W2KDVZ6ebch7fRZcnL0fMz1vHoyDjGpyDd52Ani3m1E9xfYVyV8Epa-26Wb8_Hm-S5YmA-ctA9Fwv82e28s2nBapuKV6lxGbs-9MwFSAThY9B9u6c75Y_ZvRotAuZVlkfp1cu-QylDdjZ_NpuJbzHLbIW2VfiWyWA9hRzrvkYx8Ybhw5UgLCYA8lQimFjDF8WEpELupw9VXcXoQZWOIKn_hyhHFKvTTdts2wdEBrfxniGOQW-g13G0bxUnKistOQwac-V1x1Ilee2L6KmsGmA'),
(7, 'REG-92131', '2026-06-28', 0, 'data:image/jpeg;base64,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', '', 'Bhaskar', '', 'Sekar', '1979-06-25', 'Male', NULL, '91-1133-0155-8038', 'bhaskarsekar@sbx', '', '', '', '', '', 'India', '', '8925386821', 0, 'C3 Ground Floor Revathy Flat Durgalakshmi Apts, 10th Cross Street Anna Nagar, Pammal, Pammal, Kancheepuram, Tamil Nadu', '', 'CHENGALPATTU', 'India', '600075', 0, 0, '', '', '', '', '', '', '', '', '', '', '', '2026-06-28 12:56:02', 1, NULL, NULL, 0, 0, NULL, 'eyJhbGciOiJSUzUxMiJ9.eyJpc0t5Y1ZlcmlmaWVkIjp0cnVlLCJ1dGNUaW1lc3RhbXAiOiIyMDI2LTA2LTI4VDEyOjU1OjQ2LjU2NjM3NjUwNVoiLCJzdWIiOiI5MS0xMTMzLTAxNTUtODAzOCIsImF1dGhfdHlwZSI6Ik9UUF9BVVRIX1ZFUklGWSIsImNsaWVudElkIjoiYWJoYS1wcm9maWxlLWFwcC1hcGkiLCJhY2NvdW50VHlwZSI6InN0YW5kYXJkIiwiZ2VuX3NvdXJjZSI6Im1vYmlsZV9vdHAiLCJtb2JpbGUiOiI4OTI1Mzg2ODIxIiwidHlwIjoiVHJhbnNhY3Rpb24iLCJhcGlfdmVyc2lvbiI6InYzIiwic3lzdGVtIjoiQUJIQS1OIiwiYWJoYU51bWJlciI6IjkxLTExMzMtMDE1NS04MDM4IiwicHJlZmVycmVkQWJoYUFkZHJlc3MiOiJiaGFza2Fyc2VrYXJAc2J4IiwiYmFhbF9hYmhhIjoibm8iLCJleHAiOjE3ODI2NTMxNDYsImlhdCI6MTc4MjY1MTM0NiwidHhuSWQiOiIzN2M2YTRkMC1lZDNlLTQ1NzUtYmRjMS1lOGFhNmFmY2U5YjMifQ.hkAVYiIz7G-3dYOgnFXXdJO_FtHKv-1GmlWVeHghDJ0AAXybfPfu6uJoNnxLjJpAavkOd2YkQcxbyj87S-7XJ5Tkbdsu8o8vVpapPGYAEWZBLhqx2ysRCaavoChaGKMhobIhoH8e0ceNyX1F2FVjB7Nst3o64m0wulgkptd-kWetCTCrmx7fDvF0grg0jgXPvK68f8iquHLDeGWO-9P9lsGWu3JaGcyLy9xzbjzE_bBq2x_lna1au31x_8K3hHWS0yaRBudDpPHhZ2ZQ0XTcNdG4AYQ0o_riy5VKgb4bjreKZhnP2xycDTDLXH27vDhpt8zqUwRVLr_oADPUpmr4SeTnjG6nYZoLqyr9TzER-nTR6cs1DyDg2FEYGoroWfTI7W7AihCvhmj_donPa2B8VUerylTcEfsWsg6ZPi_hKG4UQOBQnhc7L8uLAZDpxoR-6XVaZiHZsJxkfIh6TZ8Vyxgba4TiDrGpzrgtQDFeYLAH_YF2UGciFRR2Vb4o83B9VkAQnTRgESue8YYcXz4ybShYm-kd4v0BbH7U9Z2tSNV2UI2c3B5-XcWmQXPRwDWyXWd7xvwUKoPbDEveBYJpYdwuguxUHDlw11nW-t4Hi7OIu2cDRO92nMYR6fGN_Ya881pOuCEnTvU1c9aak0II4U6bXvc5uTUjyTKgdJlvTGE'),
(8, 'REG-96979', '2026-06-28', 0, 'data:image/jpeg;base64,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', '', 'Steve', 'Jerald J', 'B', '2005-10-16', 'Male', NULL, '91-5346-6164-2817', 'john.doeasd123@sbx', '', '', '', '', '', 'India', 'stevejerald2@poxiatechnologies.com', '9025740156', 0, 'C3 Ground Floor Revathi Flats Durgalakshmi Appt, Anna Nagar 10th Cross Street, Sai Bala Supermarket, Pammal, Pammal, Kancheepuram, Tamil Nadu', '', 'CHENGALPATTU', 'India', '600075', 0, 0, '', '', '', '', '', '', '', '', '', '', '', '2026-06-28 13:01:24', 1, NULL, NULL, 0, 0, NULL, 'eyJhbGciOiJSUzUxMiJ9.eyJpc0t5Y1ZlcmlmaWVkIjp0cnVlLCJ1dGNUaW1lc3RhbXAiOiIyMDI2LTA2LTI4VDEzOjAxOjE2Ljg4NTQ1MTYzNVoiLCJzdWIiOiI5MS01MzQ2LTYxNjQtMjgxNyIsImF1dGhfdHlwZSI6Ik9UUF9BVVRIX1ZFUklGWSIsImNsaWVudElkIjoiYWJoYS1wcm9maWxlLWFwcC1hcGkiLCJhY2NvdW50VHlwZSI6InN0YW5kYXJkIiwiZ2VuX3NvdXJjZSI6Im1vYmlsZV9vdHAiLCJtb2JpbGUiOiI5MDI1NzQwMTU2IiwidHlwIjoiVHJhbnNhY3Rpb24iLCJhcGlfdmVyc2lvbiI6InYzIiwic3lzdGVtIjoiQUJIQS1OIiwiYWJoYU51bWJlciI6IjkxLTUzNDYtNjE2NC0yODE3IiwicHJlZmVycmVkQWJoYUFkZHJlc3MiOiJqb2huLmRvZWFzZDEyM0BzYngiLCJiYWFsX2FiaGEiOiJubyIsImV4cCI6MTc4MjY1MzQ3NiwiaWF0IjoxNzgyNjUxNjc2LCJ0eG5JZCI6IjlmMjk1MmYzLTZkYjUtNGVlNC04YjY1LTEwMWQyOWZhOGU3ZSJ9.DNU3Ir36yATILWxzyD7Kt_0aLODHSLbka3YqF6HoBb66GCteM-hHPn71vLY8QPsYFv2T68hvEE1CFOtg88eDmuSNgKZWhE13aXjVPfvS85WLNbF-RGC4tccIHG0LaNNoerw6yiXHd3x1DKO-56gceAblWGmAjEoSEQqw-hDP-ZgxOxn45HelCX34o4r6z4MHmOgp0Z3qnNMvwjtTC0h38rNX7UvdwwAAjEi6TaBhsBLFU36XSu97J0iRC0ROV9D7PxVwr3oRkt8Hi_hDbMq75Xr86lHwIw0GzovX5m3B4vooQvIrORZ7rPREXpO9vrewA1OmwVTu7JGObRz78wsgjCoHbKMLQ5RAguqUXBVERX8jEB4PILahW3y811kkqWbaVPZPfYjefH2EK9WB_0xGV1rtKUNHRgtXZOzBHy1rBVPu5PN1KLi-hesmjl6YO1SWJylLJ3cYhL5F6Ffxw9c5m5MkKe6dLpKjiM_onu2_WHV4AEdBXeCbVePPH0ghYsBvMGfo294t3lJpoCK4jQLwALn3i6f-yOILg1hQqMZDBbEJ1t-s1VjKuDc5Zd2l0e3pEz1-7-2w919pizVFFJS3A--hyExI9xnAh4kKoEbC1kWHrr71CUq3vby4ecSWlunG2dHnJaHlla1EY3Cl3yUqovJ8dwvAkGElZvvQbh0Qurw'),
(9, 'REG-33719', '2026-06-29', 0, 'data:image/jpeg;base64,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', '', 'Bhaskar', '', 'Sekar', '1979-06-25', 'Male', NULL, '91-1133-0155-8038', 'bhaskarsekar@sbx', '', '', '', '', '', 'India', '', '8925386821', 0, 'C3 Ground Floor Revathy Flat Durgalakshmi Apts, 10th Cross Street Anna Nagar, Pammal, Pammal, Kancheepuram, Tamil Nadu', '', 'CHENGALPATTU', 'India', '600075', 0, 0, '', '', '', '', '', '', '', '', '', '', '', '2026-06-29 19:22:10', 1, NULL, NULL, 0, 0, NULL, 'eyJhbGciOiJSUzUxMiJ9.eyJpc0t5Y1ZlcmlmaWVkIjp0cnVlLCJ1dGNUaW1lc3RhbXAiOiIyMDI2LTA2LTI5VDE5OjIxOjU1LjE2NTQ3MDYwOVoiLCJzdWIiOiI5MS0xMTMzLTAxNTUtODAzOCIsImF1dGhfdHlwZSI6Ik9UUF9BVVRIX1ZFUklGWSIsImNsaWVudElkIjoiYWJoYS1wcm9maWxlLWFwcC1hcGkiLCJhY2NvdW50VHlwZSI6InN0YW5kYXJkIiwiZ2VuX3NvdXJjZSI6Im1vYmlsZV9vdHAiLCJtb2JpbGUiOiI4OTI1Mzg2ODIxIiwidHlwIjoiVHJhbnNhY3Rpb24iLCJhcGlfdmVyc2lvbiI6InYzIiwic3lzdGVtIjoiQUJIQS1OIiwiYWJoYU51bWJlciI6IjkxLTExMzMtMDE1NS04MDM4IiwicHJlZmVycmVkQWJoYUFkZHJlc3MiOiJiaGFza2Fyc2VrYXJAc2J4IiwiYmFhbF9hYmhhIjoibm8iLCJleHAiOjE3ODI3NjI3MTUsImlhdCI6MTc4Mjc2MDkxNSwidHhuSWQiOiIxNTU1ZmE0Zi00ZmZhLTQ1ZDctYTdlYi0wMzI2ODA2ZTM4N2YifQ.JcmUb0GdYPR3imf_o8BOUvcB58DcLYCZK-YTipjlLkj52zTnrcOJIBZrRexueYGKwtvacgszWpfUDS5Sjh1Osncvm67rg13bf-yh_VMIPU8BgaMobx4Nik29ISj6UBrBIPx0Sh3mtGZ75CXrHuIVaGTbrOjgQpsBFgXTKHGlCMDHfwPcLFTNuwABq2ow4jpzjmmWJVoygKvf7pPWFdJNemi-ApwcRJVIota_ZeVXB4mJKH6qAFaYQ569Ht8-MEAaqH94HxVU8OxLZW1JRzHaioQJdQs4jw_sQ94aosz3YpDSHiZmQVhQcWIhhb2D7mW1aXBBxIf_KLyVtpbsuRct6pCsIz1wc55V7KMSayLinAtZ6O__Xwt1hINecutpjnZCvQp60VqEdsGjJMcAW87IpBOQYjgFePGZoWq3oZ1zB77QQzaewLN-9ZI_JXJdoxtm1m0DUOi8-CWM4GfHW_7ltdj3pE9U9EXgFG2oHjgDN7EXZz2lJ5IuSMtxMs74n07vVXbakDntdX6cYzYK7DAjJI0hxQPWdCXe_ZZHQreGtJtuMsvwImgU1Ol_wbYQmpU_G5iI2DAq5tYk_cet_n-5kAEVfgbvFuyViiAnYujJwU-oWJwXL1odvBlOgI2LdLf0U-2O1-vCE5IlqEMA7kaxsvEZ9ZjeTwuSvNzXNPAH_2M');
INSERT INTO `patients` (`id`, `reg_no`, `reg_date`, `is_new_born`, `photo_base64`, `title`, `first_name`, `middle_name`, `last_name`, `dob`, `gender`, `aadhar_number`, `abha_id`, `abha_address`, `marital_status`, `occupation`, `language`, `education_level`, `religion`, `citizen`, `email_id`, `telephone`, `file_required`, `address`, `suburb`, `city`, `country`, `postal_code`, `postal_address_check`, `kin_same_address`, `kin_name`, `kin_relation`, `kin_telephone`, `kin_address`, `kin_suburb`, `kin_city`, `kin_country`, `kin_code`, `payer_type`, `insurance_provider`, `policy_number`, `created_at`, `branch_id`, `phr_address`, `abdm_txn_id`, `aadhaar_verified`, `mobile_verified`, `abha_token`, `abha_x_token`) VALUES
(10, 'REG-79629', '2026-06-29', 0, 'data:image/jpeg;base64,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', '', 'Steve', 'Jerald J', 'B', '2005-10-16', 'Male', NULL, '91-5346-6164-2817', 'john.doeasd123@sbx', '', '', '', '', '', 'India', 'stevejerald2@poxiatechnologies.com', '9025740156', 0, 'C3 Ground Floor Revathi Flats Durgalakshmi Appt, Anna Nagar 10th Cross Street, Sai Bala Supermarket, Pammal, Pammal, Kancheepuram, Tamil Nadu', '', 'CHENGALPATTU', 'India', '600075', 0, 0, '', '', '', '', '', '', '', '', '', '', '', '2026-06-29 19:25:21', 1, NULL, NULL, 0, 0, NULL, 'eyJhbGciOiJSUzUxMiJ9.eyJpc0t5Y1ZlcmlmaWVkIjp0cnVlLCJ1dGNUaW1lc3RhbXAiOiIyMDI2LTA2LTI5VDE5OjI1OjE4LjIyMzM1MjMwNVoiLCJzdWIiOiI5MS01MzQ2LTYxNjQtMjgxNyIsImF1dGhfdHlwZSI6Ik9UUF9BVVRIX1ZFUklGWSIsImNsaWVudElkIjoiYWJoYS1wcm9maWxlLWFwcC1hcGkiLCJhY2NvdW50VHlwZSI6InN0YW5kYXJkIiwiZ2VuX3NvdXJjZSI6Im1vYmlsZV9vdHAiLCJtb2JpbGUiOiI5MDI1NzQwMTU2IiwidHlwIjoiVHJhbnNhY3Rpb24iLCJhcGlfdmVyc2lvbiI6InYzIiwic3lzdGVtIjoiQUJIQS1OIiwiYWJoYU51bWJlciI6IjkxLTUzNDYtNjE2NC0yODE3IiwicHJlZmVycmVkQWJoYUFkZHJlc3MiOiJqb2huLmRvZWFzZDEyM0BzYngiLCJiYWFsX2FiaGEiOiJubyIsImV4cCI6MTc4Mjc2MjkxOCwiaWF0IjoxNzgyNzYxMTE4LCJ0eG5JZCI6IjlkNDc4OTA4LWVmZGMtNDExNy1iYjY4LWQ4YTIwNjBkZmZmZiJ9.DgIonwjWof2LBOoeeFMZhXKq8d3p8UQvsZqLFdRb1GqJOeWfNgfC3BqkKmYGB4N0TYcQsYMkgVbjVn8Ad_bznSERKQx8Mw0Fh0V22X9n4-G-JPM9OEldO2FmMBQfr0tfniM-orQ94BSZ3g2Pihd7nMJvdTFYA0LWAJklkhDFK1fh-GKCraLsl6ad7CQLFGAATDIrDFoq8PppMLsdAS3grtatCe98E9ClBs3gNcfJOtU74qGrZjLpSNRZdIaYj6ysXnDvVL0CuTwZITXO5U_mhYzbi08xcHOML7DHWjdRpguikfDxobhF167E1gI53K6eoTRa6SZCRMXrkwEm2cx0YqrF7UFUDeIGv1xvDyeyfphE90zFIHkG6N7OfAhvosXpjiZPcmvsLjXSRflNPH4jKjTXPRa_RWIws07eo1VSH-SDQwH2JBwZsHhCWlBGsNEtPhEkbvHNLXcZmcyPee2Zx1kHMxWqA7rI69OglEVe7jFFx1iqVRSpFjfq-H-t-2piKyb7C-IO91W6dTZJPXE2tXpMzbQBBABVo-v-S-s0sxNBD_zZjlMsnGsFy8SMWVM0bZkAvWPdu3rQjI_ktq0-xqOx3EePeyobNGMfuFmnS0elf1hF13o90zqJtvFVESLb3acaVwT_DUsXyRYtvsi7TUqF_O68jNYDE1T3ljX9tlg');

-- --------------------------------------------------------

--
-- Table structure for table `prescriptions`
--

CREATE TABLE `prescriptions` (
  `id` int NOT NULL,
  `barcode_id` varchar(50) NOT NULL,
  `patient_name` varchar(255) DEFAULT NULL,
  `abha_id` varchar(50) DEFAULT NULL,
  `age` int DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `doctor_name` varchar(255) DEFAULT NULL,
  `image_path` varchar(500) DEFAULT NULL,
  `raw_ocr_text` text,
  `ai_json` json DEFAULT NULL,
  `status` enum('pending','verified','processed','failed') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prescription_barcodes`
--

CREATE TABLE `prescription_barcodes` (
  `id` int NOT NULL,
  `barcode_id` varchar(50) NOT NULL,
  `status` enum('unused','assigned','verified','cancelled') DEFAULT 'unused',
  `generated_by` int DEFAULT NULL,
  `generated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `used_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `prescription_barcodes`
--

INSERT INTO `prescription_barcodes` (`id`, `barcode_id`, `status`, `generated_by`, `generated_at`, `used_at`) VALUES
(1, 'RX-JH-2026-000001', 'assigned', 5, '2026-05-12 03:17:37', '2026-05-12 03:18:27'),
(2, 'RX-JH-2026-000002', 'unused', 5, '2026-05-12 03:17:37', NULL),
(3, 'RX-JH-2026-000003', 'assigned', 5, '2026-05-12 03:17:37', '2026-05-12 03:27:55'),
(4, 'RX-JH-2026-000004', 'unused', 5, '2026-05-12 03:17:37', NULL),
(5, 'RX-JH-2026-000005', 'unused', 5, '2026-05-12 03:17:37', NULL),
(6, 'RX-JH-2026-000006', 'unused', 5, '2026-05-12 03:17:37', NULL),
(7, 'RX-JH-2026-000007', 'unused', 5, '2026-05-12 03:17:37', NULL),
(8, 'RX-JH-2026-000008', 'unused', 5, '2026-05-12 03:17:37', NULL),
(9, 'RX-JH-2026-000009', 'unused', 5, '2026-05-12 03:17:37', NULL),
(10, 'RX-JH-2026-000010', 'unused', 5, '2026-05-12 03:17:37', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `prescription_medicines`
--

CREATE TABLE `prescription_medicines` (
  `id` int NOT NULL,
  `prescription_id` int DEFAULT NULL,
  `medicine_name` varchar(255) DEFAULT NULL,
  `dosage` varchar(100) DEFAULT NULL,
  `confidence` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prescription_templates`
--

CREATE TABLE `prescription_templates` (
  `id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `template_name` varchar(255) NOT NULL,
  `medicines` json NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prescription_tests`
--

CREATE TABLE `prescription_tests` (
  `id` int NOT NULL,
  `prescription_id` int DEFAULT NULL,
  `test_code` varchar(50) DEFAULT NULL,
  `test_name` varchar(255) DEFAULT NULL,
  `confidence` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_orders`
--

CREATE TABLE `purchase_orders` (
  `id` int NOT NULL,
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
  `branch_id` int DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order_items`
--

CREATE TABLE `purchase_order_items` (
  `id` int NOT NULL,
  `po_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity_ordered` decimal(10,2) NOT NULL,
  `quantity_received` decimal(10,2) DEFAULT '0.00',
  `quantity_damaged` decimal(10,2) DEFAULT '0.00',
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_requisitions`
--

CREATE TABLE `purchase_requisitions` (
  `id` int NOT NULL,
  `pr_number` varchar(50) NOT NULL,
  `department_id` int DEFAULT NULL,
  `requested_by` int NOT NULL,
  `request_date` date NOT NULL,
  `required_date` date DEFAULT NULL,
  `priority` enum('Low','Normal','High','Urgent') DEFAULT 'Normal',
  `total_amount` decimal(10,2) DEFAULT '0.00',
  `status` enum('Draft','Submitted','Approved','Rejected','Converted to PO') DEFAULT 'Draft',
  `notes` text,
  `branch_id` int DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_requisition_items`
--

CREATE TABLE `purchase_requisition_items` (
  `id` int NOT NULL,
  `pr_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity_requested` decimal(10,2) NOT NULL,
  `quantity_approved` decimal(10,2) DEFAULT NULL,
  `unit_price` decimal(10,2) DEFAULT NULL,
  `total_price` decimal(10,2) DEFAULT NULL,
  `notes` text,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sample_containers`
--

CREATE TABLE `sample_containers` (
  `id` int NOT NULL,
  `container_name` varchar(100) NOT NULL,
  `tube_color` varchar(50) DEFAULT NULL,
  `volume_ml` decimal(5,2) DEFAULT NULL,
  `additives` text,
  `storage_temperature` varchar(50) DEFAULT NULL,
  `special_instructions` text,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `sample_containers`
--

INSERT INTO `sample_containers` (`id`, `container_name`, `tube_color`, `volume_ml`, `additives`, `storage_temperature`, `special_instructions`, `status`, `created_at`) VALUES
(1, 'EDTA Tube', 'Purple', 3.00, 'EDTA (K2/K3)', '2-8°C', NULL, 'Active', '2026-04-14 22:59:04'),
(2, 'Clot Activator Tube', 'Red', 5.00, 'Clot activator', 'Room Temperature', NULL, 'Active', '2026-04-14 22:59:04'),
(3, 'Heparin Tube', 'Green', 5.00, 'Lithium Heparin', '2-8°C', NULL, 'Active', '2026-04-14 22:59:04'),
(4, 'Fluoride Tube', 'Grey', 2.00, 'Sodium Fluoride', '2-8°C', NULL, 'Active', '2026-04-14 22:59:04'),
(5, 'Citrate Tube', 'Blue', 2.70, 'Sodium Citrate', '2-8°C', NULL, 'Active', '2026-04-14 22:59:04'),
(6, 'Plain Tube', 'No color', 10.00, 'No additives', 'Room Temperature', NULL, 'Active', '2026-04-14 22:59:04'),
(7, 'EDTA Tube', 'Lavender Top', 5.00, '', '', '', 'Active', '2026-04-15 09:33:11');

-- --------------------------------------------------------

--
-- Table structure for table `sample_types`
--

CREATE TABLE `sample_types` (
  `id` int NOT NULL,
  `type_name` varchar(100) NOT NULL,
  `description` text,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `sample_types`
--

INSERT INTO `sample_types` (`id`, `type_name`, `description`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Blood', 'Whole blood sample', 'Active', '2026-04-15 03:17:06', '2026-04-15 03:17:06'),
(2, 'Serum', 'Blood serum sample', 'Active', '2026-04-15 03:17:06', '2026-04-15 03:17:06'),
(3, 'Plasma', 'Blood plasma sample', 'Active', '2026-04-15 03:17:06', '2026-04-15 03:17:06'),
(4, 'Urine', 'Urine sample', 'Active', '2026-04-15 03:17:06', '2026-04-15 03:17:06'),
(5, 'Stool', 'Stool sample', 'Active', '2026-04-15 03:17:06', '2026-04-15 03:17:06'),
(6, 'CSF', 'Cerebrospinal fluid', 'Active', '2026-04-15 03:17:06', '2026-04-15 03:17:06'),
(7, 'Saliva', 'Saliva sample', 'Active', '2026-04-15 03:17:06', '2026-04-15 03:17:06'),
(8, 'Tissue', 'Biopsy tissue sample', 'Active', '2026-04-15 03:17:06', '2026-04-15 03:17:06'),
(9, 'Swab', 'Nasal/throat swab', 'Active', '2026-04-15 03:17:06', '2026-04-15 03:17:06'),
(10, 'Sputum', 'Sputum sample', 'Active', '2026-04-15 03:17:06', '2026-04-15 03:17:06');

-- --------------------------------------------------------

--
-- Table structure for table `specialties`
--

CREATE TABLE `specialties` (
  `id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `code` varchar(20) DEFAULT NULL,
  `description` text,
  `is_active` tinyint(1) DEFAULT '1',
  `branch_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `specialties`
--

INSERT INTO `specialties` (`id`, `name`, `code`, `description`, `is_active`, `branch_id`, `created_at`) VALUES
(1, 'General Medicine', 'GM', NULL, 1, NULL, '2026-07-01 17:15:14'),
(2, 'Surgery', 'SUR', NULL, 1, NULL, '2026-07-01 17:15:14'),
(3, 'Gynaecology & Obstetrics', 'GYNOB', NULL, 1, NULL, '2026-07-01 17:15:14'),
(4, 'Paediatrics', 'PED', NULL, 1, NULL, '2026-07-01 17:15:14'),
(5, 'Orthopaedics', 'ORTH', NULL, 1, NULL, '2026-07-01 17:15:14'),
(6, 'ENT', 'ENT', NULL, 1, NULL, '2026-07-01 17:15:14'),
(7, 'Ophthalmology', 'OPTH', NULL, 1, NULL, '2026-07-01 17:15:14'),
(8, 'Dermatology', 'DERM', NULL, 1, NULL, '2026-07-01 17:15:14'),
(9, 'Psychiatry', 'PSY', NULL, 1, NULL, '2026-07-01 17:15:14'),
(10, 'Radiology', 'RAD', NULL, 1, NULL, '2026-07-01 17:15:14'),
(11, 'Anaesthesia', 'ANES', NULL, 1, NULL, '2026-07-01 17:15:14'),
(12, 'Pathology', 'PATH', NULL, 1, NULL, '2026-07-01 17:15:14'),
(13, 'Cardiology', 'CARD', NULL, 1, NULL, '2026-07-01 17:15:14'),
(14, 'Neurology', 'NEURO', NULL, 1, NULL, '2026-07-01 17:15:14'),
(15, 'Oncology', 'ONCO', NULL, 1, NULL, '2026-07-01 17:15:14');

-- --------------------------------------------------------

--
-- Table structure for table `states`
--

CREATE TABLE `states` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(10) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `states`
--

INSERT INTO `states` (`id`, `name`, `code`, `is_active`, `created_at`) VALUES
(1, 'Jharkhand', 'JH', 1, '2026-07-01 17:15:14'),
(2, 'Odisha', 'OD', 1, '2026-07-01 17:15:14');

-- --------------------------------------------------------

--
-- Table structure for table `stock_transfers`
--

CREATE TABLE `stock_transfers` (
  `id` int NOT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stock_transfer_items`
--

CREATE TABLE `stock_transfer_items` (
  `id` int NOT NULL,
  `transfer_id` int NOT NULL,
  `item_id` int NOT NULL,
  `batch_id` int DEFAULT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `received_quantity` decimal(10,2) DEFAULT '0.00',
  `damaged_quantity` decimal(10,2) DEFAULT '0.00',
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` varchar(20) NOT NULL,
  `department` varchar(50) DEFAULT NULL,
  `staff_id` varchar(50) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `branch_id` int DEFAULT '1',
  `role_level` enum('Central','Sub-Central','Branch') DEFAULT 'Branch'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `phone`, `role`, `department`, `staff_id`, `password`, `created_at`, `branch_id`, `role_level`) VALUES
(1, 'Central', 'Head', 'central@mail.com', NULL, 'admin', 'cardiology', NULL, '$2a$10$HdUurOEbxJ2bZqOeWEK1S.Acw4ECU8YArfiWAVLw9AJ/dHwUae0Bm', '2026-04-29 07:14:28', 1, 'Central'),
(2, 'Sample', '1', 'Sub@mail.com', NULL, 'admin', 'emergency', NULL, '$2a$10$sDM5o3b9BYraHBEnyavqz.EY4mrujspYCJDAfDk8c7Pnq54tDEEHe', '2026-04-29 07:21:08', 5, 'Sub-Central'),
(3, 'single', 'user', 'single@mail.com', NULL, 'admin', 'administration', NULL, '$2a$10$VT8IujIwfvVCNPI8iBuVheULrUbrvf0DAhyEEdc7VjbonC2bkg4qK', '2026-04-29 07:22:00', 6, 'Sub-Central'),
(4, 'sample 3', '3', '3@mail.com', NULL, 'admin', 'emergency', NULL, '$2a$10$H8wuaXJITKSk6.PJdG9fy.AapqBngY9Imc6tXDTqL3R9YbXFs2Z/u', '2026-04-29 07:23:40', 7, 'Sub-Central'),
(5, 'Steve', 'Jerald', 'steve@mail.com', NULL, 'admin', 'emergency', NULL, '$2a$10$lcND.gb.tCOcQRJkXYnoZ.wsDv2ngz4JzE9cG0Qo4Yan/VPWt8bq2', '2026-04-29 11:45:36', 1, 'Central'),
(6, 'as', 'as', 'jewame2218@hacknapp.com', NULL, 'admin', 'emergency', NULL, '$2a$10$O.kJ8IhwIUWWhxB8FsEF2OnolxAbhsgAZnd6ZtWCKjPjrdlz/YXb2', '2026-04-29 11:50:07', 3, 'Sub-Central'),
(7, 'lab', 'tech', 'lab-tech@mail.com', NULL, 'lab_tech', 'emergency', NULL, '$2a$10$8KF7DpqmuSvgQUg76PNG6.ZnHO1HF8C.ufWwMWdcmd/U/9dT9DlMq', '2026-04-30 02:14:45', 1, 'Branch'),
(8, 'Lab', 'Doc', 'lab-doc@mail.com', NULL, 'lab_doctor', 'emergency', NULL, '$2a$10$Ui7bz/VFazJ46G9b3WX1s.r7llktHQtNNq2p9llHPKuTAWhbRcCMW', '2026-04-30 02:19:55', 1, 'Branch'),
(9, 'Recp', 'user', 'recp@mail.com', NULL, 'receptionist', 'emergency', NULL, '$2a$10$1pK39ZM9jdITBwv7IR7ryeGVxT0067bSOu9zArMAWE.UInOiJEmei', '2026-04-30 02:21:39', 1, 'Branch'),
(10, 'sam', 'issac', 'doc@mail.com', NULL, 'Doctor', 'Emergency', 'DOC-5271', 'password123', '2026-05-04 15:28:14', 1, 'Branch'),
(11, 'main', 'doc', 'hello@mail.com', NULL, 'Doctor', 'Cardiology', 'DOC-4839', 'password123', '2026-05-04 16:01:35', 1, 'Branch'),
(12, 'Kavya', 'Raman', 'kavya.raman.pallavaram.hr@testmail.com', NULL, 'receptionist', 'emergency', NULL, '$2a$10$MuwLtft3BWWKukgJpju88ufu1ChyYJ6GSosIT3UcWu/IhJcpnuxSK', '2026-05-07 21:18:01', 9, 'Branch'),
(13, 'Arvind', 'Rajan', 'arvind.rajan@knthgodda.in', NULL, 'receptionist', 'radiology', NULL, '$2a$10$GvREf7GcW0.Zv7giWUT9M.yHv1Tv9trmJMeOCbq/D9mkIoFd5ahVW', '2026-05-07 21:18:06', 10, 'Branch'),
(14, 'Priya', 'Sharma', 'priya.sharma.wsb@jhhealth.in', NULL, 'receptionist', 'cardiology', NULL, '$2a$10$4t8bX4B4fAK3LCeItnNDB.BOxeds8qR18aX9sbz5YcTNwVUusw252', '2026-05-07 21:18:08', 11, 'Branch'),
(15, 'Priya', 'Sharma', 'reception.anakaputhur@chc.test', NULL, 'receptionist', 'orthopedics', NULL, '$2a$10$26pCshXtm38P2ed6IY3YP.0dxp1Cay57muK.8dXEFj8xpHAmyk1ZS', '2026-05-07 21:18:16', 8, 'Branch'),
(16, 'ghjvh', 'bjb', 'labtech.anakaputhur@chc.test', NULL, 'lab_tech', 'administration', NULL, '$2a$10$VY0gDsGZoLFvPi74aCYrDumEdPs6unc6TiTpiyzblkdg2/oBgeFw6', '2026-05-07 21:28:21', 8, 'Branch'),
(17, 'bj', 'v', 'john@mail.com', NULL, 'lab_tech', 'orthopedics', NULL, '$2a$10$sYJBNQ/UUKhFX3wZ4iWQm.kydWU9fJ5k//Q7oSzpkoRvCDRECsXYu', '2026-05-07 21:30:28', 8, 'Branch'),
(18, 'Ravi', 'Kumar', 'ravi.kumar.lab.wsb@jhhealth.in', NULL, 'lab_tech', 'cardiology', NULL, '$2a$10$PkxOJAv4LwreckSLYAlNpeD.Kd7ccK8IfrkVN5NX8eYr6LLp8Z8SK', '2026-05-07 21:31:14', 11, 'Branch'),
(19, 'Priya', 'Kannan', 'priya.kannan@knthlab.in', NULL, 'lab_tech', 'radiology', NULL, '$2a$10$E2on7tuQn2GObrm7vulQ7OK3xDkj2bENkJZm0kJL47q0z/QPeNmTG', '2026-05-07 21:32:37', 10, 'Branch'),
(20, 'Pallavarm', 'Admin', 'pallavaram@ad,in.com', NULL, 'admin', 'emergency', NULL, '$2a$10$Z2gHer13KhFIm3Rt5d/Ri.zytcCRs3J7S.NE/6dXo3Uk7uW0/zDay', '2026-05-07 21:35:33', 9, 'Sub-Central'),
(21, 'SIBYLL', 'DOMINIC', 'avadi@admin.com', NULL, 'admin', 'cardiology', NULL, '$2a$10$y58A3ezDsqA9dDnHnoWtRuz.bb.EhNAZKj82MIV8iyVWx2T5qjJqu', '2026-05-07 21:35:49', 11, 'Sub-Central'),
(22, 'anagai', 'hha', 'anakaputhur@mail.com', NULL, 'admin', 'administration', NULL, '$2a$10$OULGl6ROSzOmPYJUV8biQOk9buzbh4Kcao8E9d8jHoB18SnLGA2nC', '2026-05-07 21:35:51', 8, 'Sub-Central'),
(23, 'pallavaram', 'admin', 'pallavaram@admin.com', NULL, 'admin', 'radiology', NULL, '$2a$10$dM8TJRiIeZfo8hXHySHLTuRyGSm4l/XPe/QSkIR6fV9HiX.Om9ePa', '2026-05-07 21:36:27', 9, 'Sub-Central'),
(24, 'Kumbakonam', 'Admin', 'kmb@admin.com', NULL, 'admin', 'radiology', NULL, '$2a$10$4xwPZsswT8RVxwuMrF8BSeyrKkNFo.xnrk46tq/UxyosmsC3HWzju', '2026-05-07 21:36:53', 10, 'Sub-Central'),
(25, 'ram', 'ghar', 'ram@mail.com', NULL, 'lab_tech', 'cardiology', NULL, '$2a$10$rrI1YE5TYsfQOAue44gG2u1P4KfzM1KC8ZxVRrHp9nYBoz0oUv7n6', '2026-05-23 02:13:29', 16, 'Branch'),
(26, 'Jeffin', 'Mervick', 'jeffin@mail.com', '08754035291', 'Doctor', 'Emergency', 'STF-5705', '$2a$10$gNM03oCTMY082rZTTcg7sOveOOXHUnLEFh4UsPYCJ2bxzkYQNwqaK', '2026-06-26 22:55:14', 1, 'Branch'),
(27, 'Thir', 'Shan', 'thir@mail.com', '9345995944', 'Admin', 'Administration', 'STF-9990', '$2a$10$nLKSye2dOYu2DATw9Ps38uuf6frU1zDKvqc1I.XrTCzGn.sLJRPmy', '2026-07-01 21:50:40', 17, 'Branch'),
(28, 'Sandy', 'k', 'sandy@mail.com', '9345995944', 'Doctor', 'Cardiology', 'STF-6143', '$2a$10$N1bSBwCmjgnRYkbP2mGBBOe4bBEtOcYyLPZcx2vrPoNmN7IGaHvLS', '2026-07-01 22:59:24', 17, 'Branch'),
(29, 'sandy', '2', 'sandy2@mail.com', '9025740156', 'Doctor', 'Anesthesiology', 'STF-4437', '$2a$10$PS6LNXxVTghBw4xNi2qgm.HOgnry/oBb3UzWMIFXi63g4V95XCbyu', '2026-07-01 23:03:27', 17, 'Branch'),
(30, 'Paramash', 'senthil', 'param@mail.com', NULL, 'Lab Technician', 'Laboratory', 'STF-7755', '$2a$10$YujXjZu4z5cn8gDnkXphG.I.4C2THitgsUqc16VFVWH9jJFPLppaK', '2026-07-03 04:06:48', 17, 'Branch'),
(31, 'lab', 'doc', 'labdoc@mail.com', NULL, 'Lab Head', 'Laboratory', 'STF-8543', '$2a$10$PYwoQSUE7nbUHQcz/2T1n.qbRRO/eXmessvh0.WsD62CzTBuQ0Aou', '2026-07-03 04:07:10', 17, 'Branch'),
(32, 'lab', 'admin', 'labadmin@mail.com', NULL, 'Lab Admin', 'Laboratory', 'STF-1358', '$2a$10$wRGOXwLqnKZ2fo.cf2/PgunLE7dIhcjbzU3aC2lQJcH1nQg9UCW2a', '2026-07-03 04:07:29', 17, 'Branch');

-- --------------------------------------------------------

--
-- Table structure for table `vendors`
--

CREATE TABLE `vendors` (
  `id` int NOT NULL,
  `vendor_code` varchar(50) NOT NULL,
  `vendor_name` varchar(200) NOT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text,
  `tax_id` varchar(50) DEFAULT NULL,
  `payment_terms` varchar(100) DEFAULT NULL,
  `lead_time_days` int DEFAULT '7',
  `bank_name` varchar(100) DEFAULT NULL,
  `account_number` varchar(100) DEFAULT NULL,
  `ifsc_code` varchar(50) DEFAULT NULL,
  `status` enum('Active','Inactive','Blacklisted') DEFAULT 'Active',
  `rating` decimal(3,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `vendors`
--

INSERT INTO `vendors` (`id`, `vendor_code`, `vendor_name`, `contact_person`, `phone`, `email`, `address`, `tax_id`, `payment_terms`, `lead_time_days`, `bank_name`, `account_number`, `ifsc_code`, `status`, `rating`, `created_at`, `updated_at`) VALUES
(1, 'IVND001', 'Acme Corp', 'John Doe', '1234567890', 'john@acme.com', '123 Acme Way, City', '', '', 7, '', '', '', 'Active', 0.00, '2026-04-19 14:21:25', '2026-04-19 14:21:25'),
(2, 'IVND002', 'JB', 'Steve', '9025740156', 'steve632@gmail.com', 'C-3, Ground Floor, Durgalakshmi Appt, Revathy Flats, Anna Nagar 10th Cross Street, Pammal, Chennai-600075\n', '89812', '', 7, 'indian Bank', '12982939b 239', 'IDID', 'Active', 0.00, '2026-04-19 14:22:16', '2026-04-19 14:22:16'),
(3, 'IVND003', 'Senthil Enterprises', 'Paramesh', '9952746925', 'paramashsenthil7@gmail.com', 'C-3, Pammal', '134 12111', '', 7, 'Indian Bank', '1212112', 'IDFC', 'Active', 0.00, '2026-04-20 08:56:14', '2026-04-20 13:02:11'),
(4, 'IVND004', 'JB Dealers', 'Bhaskar S', '8925386821', 'bhaskar.sekar@merillife.com', 'C-3, Ground Floor, Durgalakshmi Appt, Revathy Flats, Anna Nagar 10th Cross Street, Pammal, Chennai-600075', '1212121', '', 7, 'Indian Bank', '121', '112', 'Active', 0.00, '2026-04-20 09:25:22', '2026-04-20 09:36:42'),
(5, 'IVND005', 'Dominic Surgicals', 'Sibyll', '7810027381', 'sibylldominic@gmail.com', 'C-3, Ground Floor, Durgalakshmi Appt, Revathy Flats, Anna Nagar 10th Cross Street, Pammal, Chennai-600075', '12111', '', 7, 'Indian Bank', '1200 1289', 'IDFC', 'Active', 0.00, '2026-04-20 09:48:16', '2026-04-20 09:48:16');

-- --------------------------------------------------------

--
-- Table structure for table `vitals`
--

CREATE TABLE `vitals` (
  `id` int NOT NULL,
  `consultation_id` int NOT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `bp_systolic` int DEFAULT NULL,
  `bp_diastolic` int DEFAULT NULL,
  `pulse` int DEFAULT NULL,
  `temperature` decimal(5,2) DEFAULT NULL,
  `spo2` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `vitals`
--

INSERT INTO `vitals` (`id`, `consultation_id`, `height`, `weight`, `bp_systolic`, `bp_diastolic`, `pulse`, `temperature`, `spo2`, `created_at`) VALUES
(1, 1, 160.00, 80.00, 120, 80, 121, 90.00, 99, '2026-06-27 14:53:49'),
(2, 2, 160.00, 80.00, 120, 80, 122, 98.00, 112, '2026-06-27 15:49:09'),
(3, 3, 173.00, 74.00, 120, 80, 122, 97.00, 99, '2026-06-27 18:15:01'),
(4, 4, 180.00, 76.00, 120, 80, 112, 98.00, 99, '2026-06-27 23:14:48'),
(5, 7, 170.00, 89.00, 120, 80, 122, 98.00, 99, '2026-06-28 13:05:41'),
(6, 8, 160.00, 90.00, 120, 80, 121, 98.00, 99, '2026-06-29 16:59:01');

-- --------------------------------------------------------

--
-- Table structure for table `working_hours`
--

CREATE TABLE `working_hours` (
  `id` int NOT NULL,
  `branch_id` int NOT NULL,
  `department_id` int DEFAULT NULL,
  `day_of_week` tinyint NOT NULL,
  `open_time` time NOT NULL DEFAULT '09:00:00',
  `close_time` time NOT NULL DEFAULT '17:00:00',
  `is_closed` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `abdm_care_context`
--
ALTER TABLE `abdm_care_context`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_request_id` (`request_id`),
  ADD KEY `idx_abha_number` (`abha_number`),
  ADD KEY `idx_patient_id` (`patient_id`),
  ADD KEY `idx_care_context_ref` (`care_context_ref`);

--
-- Indexes for table `abdm_consents`
--
ALTER TABLE `abdm_consents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_consent_id` (`consent_id`);

--
-- Indexes for table `abdm_data_requests`
--
ALTER TABLE `abdm_data_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_transaction_id` (`transaction_id`),
  ADD KEY `idx_consent_id` (`consent_id`);

--
-- Indexes for table `abdm_link_requests`
--
ALTER TABLE `abdm_link_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_request_id` (`request_id`),
  ADD KEY `idx_abha_number` (`abha_number`),
  ADD KEY `idx_patient_id` (`patient_id`);

--
-- Indexes for table `abdm_user_linking`
--
ALTER TABLE `abdm_user_linking`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_transaction_id` (`transaction_id`),
  ADD KEY `idx_link_ref` (`link_ref_number`);

--
-- Indexes for table `abdm_user_links`
--
ALTER TABLE `abdm_user_links`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_abha_address` (`abha_address`),
  ADD KEY `idx_patient_id` (`patient_id`);

--
-- Indexes for table `analyzer_connection_logs`
--
ALTER TABLE `analyzer_connection_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_machine_id` (`machine_id`),
  ADD KEY `idx_lab_id` (`lab_id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reg_no` (`reg_no`);

--
-- Indexes for table `beds`
--
ALTER TABLE `beds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_bed_ward` (`bed_number`,`ward_id`);

--
-- Indexes for table `billing`
--
ALTER TABLE `billing`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reg_no` (`reg_no`);

--
-- Indexes for table `billing_packages`
--
ALTER TABLE `billing_packages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `package_id` (`package_id`);

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `bill_number` (`bill_number`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `payment_status` (`payment_status`),
  ADD KEY `fk_bill_branch` (`branch_id`);

--
-- Indexes for table `bill_items`
--
ALTER TABLE `bill_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bill_id` (`bill_id`),
  ADD KEY `lab_id` (`lab_id`),
  ADD KEY `sample_id` (`sample_id`);

--
-- Indexes for table `blocks`
--
ALTER TABLE `blocks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_block_district` (`name`,`district_id`);

--
-- Indexes for table `branches`
--
ALTER TABLE `branches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `hospital_code` (`hospital_code`),
  ADD KEY `district_id` (`district_id`);

--
-- Indexes for table `consultations`
--
ALTER TABLE `consultations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `appointment_id` (`appointment_id`),
  ADD KEY `patient_reg_no` (`patient_reg_no`),
  ADD KEY `doctor_id` (`doctor_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `digital_prescriptions`
--
ALTER TABLE `digital_prescriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `consultation_id` (`consultation_id`);

--
-- Indexes for table `disease_surveillance`
--
ALTER TABLE `disease_surveillance`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `districts`
--
ALTER TABLE `districts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `doctor_lab_orders`
--
ALTER TABLE `doctor_lab_orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `patient_reg_no` (`patient_reg_no`),
  ADD KEY `test_id` (`test_id`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `doctor_schedules`
--
ALTER TABLE `doctor_schedules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `duty_schedules`
--
ALTER TABLE `duty_schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `doctor_id` (`doctor_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `facility_categories`
--
ALTER TABLE `facility_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `goods_receipts`
--
ALTER TABLE `goods_receipts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `grn_number` (`grn_number`),
  ADD KEY `po_id` (`po_id`),
  ADD KEY `vendor_id` (`vendor_id`),
  ADD KEY `received_by` (`received_by`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `status` (`status`),
  ADD KEY `branch_id` (`branch_id`);

--
-- Indexes for table `goods_receipt_items`
--
ALTER TABLE `goods_receipt_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `grn_id` (`grn_id`);

--
-- Indexes for table `holidays`
--
ALTER TABLE `holidays`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hospital_settings`
--
ALTER TABLE `hospital_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `infrastructure`
--
ALTER TABLE `infrastructure`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_infra_branch` (`branch_id`);

--
-- Indexes for table `inventory_batches`
--
ALTER TABLE `inventory_batches`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vendor_id` (`vendor_id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `batch_number` (`batch_number`),
  ADD KEY `expiry_date` (`expiry_date`),
  ADD KEY `status` (`status`),
  ADD KEY `branch_id` (`branch_id`);

--
-- Indexes for table `inventory_items`
--
ALTER TABLE `inventory_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `item_code` (`item_code`),
  ADD KEY `category` (`category`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `inventory_item_master`
--
ALTER TABLE `inventory_item_master`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `item_code` (`item_code`),
  ADD KEY `fk_item_vendor` (`preferred_vendor_id`);

--
-- Indexes for table `inventory_payments`
--
ALTER TABLE `inventory_payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `payment_number` (`payment_number`),
  ADD KEY `vendor_id` (`vendor_id`),
  ADD KEY `invoice_id` (`invoice_id`);

--
-- Indexes for table `inventory_po_items`
--
ALTER TABLE `inventory_po_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `po_id` (`po_id`),
  ADD KEY `pr_item_id` (`pr_item_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `inventory_pr_items`
--
ALTER TABLE `inventory_pr_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pr_id` (`pr_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `inventory_purchase_orders`
--
ALTER TABLE `inventory_purchase_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `po_number` (`po_number`),
  ADD KEY `vendor_id` (`vendor_id`);

--
-- Indexes for table `inventory_purchase_requisitions`
--
ALTER TABLE `inventory_purchase_requisitions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pr_number` (`pr_number`),
  ADD KEY `fk_inventory_purchase_requisitions_branch_id_branches` (`branch_id`);

--
-- Indexes for table `inventory_purchase_suggestions`
--
ALTER TABLE `inventory_purchase_suggestions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `vendor_id` (`vendor_id`);

--
-- Indexes for table `inventory_stock`
--
ALTER TABLE `inventory_stock`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_item_dept` (`item_id`,`department_id`),
  ADD KEY `department_id` (`department_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `inventory_stock_transfers`
--
ALTER TABLE `inventory_stock_transfers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transfer_number` (`transfer_number`),
  ADD KEY `fk_inventory_stock_transfers_from_branch_id_branches` (`from_branch_id`),
  ADD KEY `fk_inventory_stock_transfers_to_branch_id_branches` (`to_branch_id`);

--
-- Indexes for table `inventory_stock_transfer_items`
--
ALTER TABLE `inventory_stock_transfer_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transfer_id` (`transfer_id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `batch_id` (`batch_id`);

--
-- Indexes for table `inventory_supplier_invoices`
--
ALTER TABLE `inventory_supplier_invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoice_number` (`invoice_number`),
  ADD KEY `vendor_id` (`vendor_id`);

--
-- Indexes for table `inventory_supplier_ledger`
--
ALTER TABLE `inventory_supplier_ledger`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vendor_id` (`vendor_id`);

--
-- Indexes for table `inventory_test_mapping`
--
ALTER TABLE `inventory_test_mapping`
  ADD PRIMARY KEY (`id`),
  ADD KEY `test_id` (`test_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `batch_id` (`batch_id`),
  ADD KEY `fk_inv_trans_test` (`test_id`),
  ADD KEY `fk_inventory_trans_branch` (`branch_id`);

--
-- Indexes for table `lab_categories`
--
ALTER TABLE `lab_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `lab_machines`
--
ALTER TABLE `lab_machines`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_machine_id` (`lab_id`,`machine_id`),
  ADD UNIQUE KEY `serial_number` (`serial_number`),
  ADD KEY `lab_id` (`lab_id`);

--
-- Indexes for table `lab_sample_sequences`
--
ALTER TABLE `lab_sample_sequences`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_seq` (`branch_id`,`seq_date`,`dept_key`);

--
-- Indexes for table `lab_tests`
--
ALTER TABLE `lab_tests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `test_code` (`test_code`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `lab_id` (`lab_id`);

--
-- Indexes for table `lab_test_parameters`
--
ALTER TABLE `lab_test_parameters`
  ADD PRIMARY KEY (`id`),
  ADD KEY `test_id` (`test_id`);

--
-- Indexes for table `lab_test_result`
--
ALTER TABLE `lab_test_result`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bill_item_id` (`bill_item_id`),
  ADD KEY `sample_id` (`sample_id`),
  ADD KEY `machine_no` (`machine_no`),
  ADD KEY `patient_id` (`patient_id`),
  ADD KEY `fk_lab_result_branch` (`branch_id`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reg_no` (`reg_no`),
  ADD KEY `fk_patient_branch` (`branch_id`);

--
-- Indexes for table `prescriptions`
--
ALTER TABLE `prescriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `barcode_id` (`barcode_id`);

--
-- Indexes for table `prescription_barcodes`
--
ALTER TABLE `prescription_barcodes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `barcode_id` (`barcode_id`),
  ADD KEY `generated_by` (`generated_by`);

--
-- Indexes for table `prescription_medicines`
--
ALTER TABLE `prescription_medicines`
  ADD PRIMARY KEY (`id`),
  ADD KEY `prescription_id` (`prescription_id`);

--
-- Indexes for table `prescription_templates`
--
ALTER TABLE `prescription_templates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_doctor_id` (`doctor_id`);

--
-- Indexes for table `prescription_tests`
--
ALTER TABLE `prescription_tests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `prescription_id` (`prescription_id`);

--
-- Indexes for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `po_number` (`po_number`),
  ADD KEY `pr_id` (`pr_id`),
  ADD KEY `vendor_id` (`vendor_id`),
  ADD KEY `delivery_location` (`delivery_location`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `status` (`status`),
  ADD KEY `branch_id` (`branch_id`);

--
-- Indexes for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `po_id` (`po_id`);

--
-- Indexes for table `purchase_requisitions`
--
ALTER TABLE `purchase_requisitions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pr_number` (`pr_number`),
  ADD KEY `requested_by` (`requested_by`),
  ADD KEY `department_id` (`department_id`),
  ADD KEY `status` (`status`),
  ADD KEY `branch_id` (`branch_id`);

--
-- Indexes for table `purchase_requisition_items`
--
ALTER TABLE `purchase_requisition_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `pr_id` (`pr_id`);

--
-- Indexes for table `sample_containers`
--
ALTER TABLE `sample_containers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sample_types`
--
ALTER TABLE `sample_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `type_name` (`type_name`);

--
-- Indexes for table `specialties`
--
ALTER TABLE `specialties`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_specialty_code` (`code`);

--
-- Indexes for table `states`
--
ALTER TABLE `states`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_state_name` (`name`),
  ADD UNIQUE KEY `uq_state_code` (`code`);

--
-- Indexes for table `stock_transfers`
--
ALTER TABLE `stock_transfers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transfer_number` (`transfer_number`),
  ADD KEY `from_department` (`from_department`),
  ADD KEY `to_department` (`to_department`),
  ADD KEY `requested_by` (`requested_by`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `received_by` (`received_by`);

--
-- Indexes for table `stock_transfer_items`
--
ALTER TABLE `stock_transfer_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `batch_id` (`batch_id`),
  ADD KEY `transfer_id` (`transfer_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_user_branch` (`branch_id`);

--
-- Indexes for table `vendors`
--
ALTER TABLE `vendors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `vendor_code` (`vendor_code`);

--
-- Indexes for table `vitals`
--
ALTER TABLE `vitals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `consultation_id` (`consultation_id`);

--
-- Indexes for table `working_hours`
--
ALTER TABLE `working_hours`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_wh` (`branch_id`,`department_id`,`day_of_week`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `abdm_care_context`
--
ALTER TABLE `abdm_care_context`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `abdm_consents`
--
ALTER TABLE `abdm_consents`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `abdm_data_requests`
--
ALTER TABLE `abdm_data_requests`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `abdm_link_requests`
--
ALTER TABLE `abdm_link_requests`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `abdm_user_linking`
--
ALTER TABLE `abdm_user_linking`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `abdm_user_links`
--
ALTER TABLE `abdm_user_links`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `analyzer_connection_logs`
--
ALTER TABLE `analyzer_connection_logs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `beds`
--
ALTER TABLE `beds`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `billing`
--
ALTER TABLE `billing`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `billing_packages`
--
ALTER TABLE `billing_packages`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `bill_items`
--
ALTER TABLE `bill_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `blocks`
--
ALTER TABLE `blocks`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `branches`
--
ALTER TABLE `branches`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `consultations`
--
ALTER TABLE `consultations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `digital_prescriptions`
--
ALTER TABLE `digital_prescriptions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `disease_surveillance`
--
ALTER TABLE `disease_surveillance`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `districts`
--
ALTER TABLE `districts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `doctor_lab_orders`
--
ALTER TABLE `doctor_lab_orders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `doctor_schedules`
--
ALTER TABLE `doctor_schedules`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `duty_schedules`
--
ALTER TABLE `duty_schedules`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `facility_categories`
--
ALTER TABLE `facility_categories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `goods_receipts`
--
ALTER TABLE `goods_receipts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `goods_receipt_items`
--
ALTER TABLE `goods_receipt_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `holidays`
--
ALTER TABLE `holidays`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hospital_settings`
--
ALTER TABLE `hospital_settings`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `infrastructure`
--
ALTER TABLE `infrastructure`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `inventory_batches`
--
ALTER TABLE `inventory_batches`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `inventory_items`
--
ALTER TABLE `inventory_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_item_master`
--
ALTER TABLE `inventory_item_master`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `inventory_payments`
--
ALTER TABLE `inventory_payments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `inventory_po_items`
--
ALTER TABLE `inventory_po_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `inventory_pr_items`
--
ALTER TABLE `inventory_pr_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `inventory_purchase_orders`
--
ALTER TABLE `inventory_purchase_orders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `inventory_purchase_requisitions`
--
ALTER TABLE `inventory_purchase_requisitions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `inventory_purchase_suggestions`
--
ALTER TABLE `inventory_purchase_suggestions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_stock`
--
ALTER TABLE `inventory_stock`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_stock_transfers`
--
ALTER TABLE `inventory_stock_transfers`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `inventory_stock_transfer_items`
--
ALTER TABLE `inventory_stock_transfer_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `inventory_supplier_invoices`
--
ALTER TABLE `inventory_supplier_invoices`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `inventory_supplier_ledger`
--
ALTER TABLE `inventory_supplier_ledger`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `inventory_test_mapping`
--
ALTER TABLE `inventory_test_mapping`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `lab_categories`
--
ALTER TABLE `lab_categories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `lab_machines`
--
ALTER TABLE `lab_machines`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lab_sample_sequences`
--
ALTER TABLE `lab_sample_sequences`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `lab_tests`
--
ALTER TABLE `lab_tests`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `lab_test_parameters`
--
ALTER TABLE `lab_test_parameters`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=86;

--
-- AUTO_INCREMENT for table `lab_test_result`
--
ALTER TABLE `lab_test_result`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `prescriptions`
--
ALTER TABLE `prescriptions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `prescription_barcodes`
--
ALTER TABLE `prescription_barcodes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `prescription_medicines`
--
ALTER TABLE `prescription_medicines`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `prescription_templates`
--
ALTER TABLE `prescription_templates`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `prescription_tests`
--
ALTER TABLE `prescription_tests`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `purchase_requisitions`
--
ALTER TABLE `purchase_requisitions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `purchase_requisition_items`
--
ALTER TABLE `purchase_requisition_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sample_containers`
--
ALTER TABLE `sample_containers`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `sample_types`
--
ALTER TABLE `sample_types`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `specialties`
--
ALTER TABLE `specialties`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `states`
--
ALTER TABLE `states`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `stock_transfers`
--
ALTER TABLE `stock_transfers`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stock_transfer_items`
--
ALTER TABLE `stock_transfer_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `vendors`
--
ALTER TABLE `vendors`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `vitals`
--
ALTER TABLE `vitals`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `working_hours`
--
ALTER TABLE `working_hours`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`reg_no`) REFERENCES `patients` (`reg_no`) ON DELETE CASCADE;

--
-- Constraints for table `billing`
--
ALTER TABLE `billing`
  ADD CONSTRAINT `billing_ibfk_1` FOREIGN KEY (`reg_no`) REFERENCES `patients` (`reg_no`) ON DELETE CASCADE;

--
-- Constraints for table `branches`
--
ALTER TABLE `branches`
  ADD CONSTRAINT `branches_ibfk_1` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`);

--
-- Constraints for table `digital_prescriptions`
--
ALTER TABLE `digital_prescriptions`
  ADD CONSTRAINT `digital_prescriptions_ibfk_1` FOREIGN KEY (`consultation_id`) REFERENCES `consultations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `goods_receipts`
--
ALTER TABLE `goods_receipts`
  ADD CONSTRAINT `fk_grn_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `goods_receipts_ibfk_1` FOREIGN KEY (`po_id`) REFERENCES `purchase_orders` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `goods_receipts_ibfk_2` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `goods_receipts_ibfk_3` FOREIGN KEY (`received_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `goods_receipts_ibfk_4` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `goods_receipt_items`
--
ALTER TABLE `goods_receipt_items`
  ADD CONSTRAINT `goods_receipt_items_ibfk_1` FOREIGN KEY (`grn_id`) REFERENCES `goods_receipts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `goods_receipt_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `infrastructure`
--
ALTER TABLE `infrastructure`
  ADD CONSTRAINT `fk_infra_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`);

--
-- Constraints for table `inventory_batches`
--
ALTER TABLE `inventory_batches`
  ADD CONSTRAINT `fk_inventory_batch_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_inventory_batches_item` FOREIGN KEY (`item_id`) REFERENCES `inventory_item_master` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inventory_batches_ibfk_2` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `inventory_item_master`
--
ALTER TABLE `inventory_item_master`
  ADD CONSTRAINT `fk_item_vendor` FOREIGN KEY (`preferred_vendor_id`) REFERENCES `vendors` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `inventory_payments`
--
ALTER TABLE `inventory_payments`
  ADD CONSTRAINT `inventory_payments_ibfk_1` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `inventory_payments_ibfk_2` FOREIGN KEY (`invoice_id`) REFERENCES `inventory_supplier_invoices` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `inventory_po_items`
--
ALTER TABLE `inventory_po_items`
  ADD CONSTRAINT `inventory_po_items_ibfk_1` FOREIGN KEY (`po_id`) REFERENCES `inventory_purchase_orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inventory_po_items_ibfk_2` FOREIGN KEY (`pr_item_id`) REFERENCES `inventory_pr_items` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `inventory_po_items_ibfk_3` FOREIGN KEY (`item_id`) REFERENCES `inventory_item_master` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `inventory_pr_items`
--
ALTER TABLE `inventory_pr_items`
  ADD CONSTRAINT `inventory_pr_items_ibfk_1` FOREIGN KEY (`pr_id`) REFERENCES `inventory_purchase_requisitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inventory_pr_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `inventory_item_master` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `inventory_purchase_orders`
--
ALTER TABLE `inventory_purchase_orders`
  ADD CONSTRAINT `inventory_purchase_orders_ibfk_1` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `inventory_purchase_requisitions`
--
ALTER TABLE `inventory_purchase_requisitions`
  ADD CONSTRAINT `fk_inventory_purchase_requisitions_branch_id_branches` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `inventory_purchase_suggestions`
--
ALTER TABLE `inventory_purchase_suggestions`
  ADD CONSTRAINT `inventory_purchase_suggestions_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `inventory_item_master` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inventory_purchase_suggestions_ibfk_2` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `inventory_stock`
--
ALTER TABLE `inventory_stock`
  ADD CONSTRAINT `fk_inventory_stock_department_id_branches` FOREIGN KEY (`department_id`) REFERENCES `branches` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `inventory_stock_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `inventory_stock_transfers`
--
ALTER TABLE `inventory_stock_transfers`
  ADD CONSTRAINT `fk_inventory_stock_transfers_from_branch_id_branches` FOREIGN KEY (`from_branch_id`) REFERENCES `branches` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_inventory_stock_transfers_to_branch_id_branches` FOREIGN KEY (`to_branch_id`) REFERENCES `branches` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `inventory_stock_transfer_items`
--
ALTER TABLE `inventory_stock_transfer_items`
  ADD CONSTRAINT `inventory_stock_transfer_items_ibfk_1` FOREIGN KEY (`transfer_id`) REFERENCES `inventory_stock_transfers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inventory_stock_transfer_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `inventory_item_master` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `inventory_stock_transfer_items_ibfk_3` FOREIGN KEY (`batch_id`) REFERENCES `inventory_batches` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `inventory_supplier_invoices`
--
ALTER TABLE `inventory_supplier_invoices`
  ADD CONSTRAINT `inventory_supplier_invoices_ibfk_1` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `inventory_supplier_ledger`
--
ALTER TABLE `inventory_supplier_ledger`
  ADD CONSTRAINT `inventory_supplier_ledger_ibfk_1` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `inventory_test_mapping`
--
ALTER TABLE `inventory_test_mapping`
  ADD CONSTRAINT `inventory_test_mapping_ibfk_1` FOREIGN KEY (`test_id`) REFERENCES `lab_tests` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inventory_test_mapping_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `inventory_item_master` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  ADD CONSTRAINT `fk_inv_trans_test` FOREIGN KEY (`test_id`) REFERENCES `lab_tests` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_inventory_trans_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `inventory_transactions_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `inventory_item_master` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `inventory_transactions_ibfk_2` FOREIGN KEY (`batch_id`) REFERENCES `inventory_batches` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `lab_machines`
--
ALTER TABLE `lab_machines`
  ADD CONSTRAINT `fk_lab_machines_infra` FOREIGN KEY (`lab_id`) REFERENCES `infrastructure` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `lab_test_result`
--
ALTER TABLE `lab_test_result`
  ADD CONSTRAINT `fk_lab_result_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`);

--
-- Constraints for table `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `fk_patient_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`);

--
-- Constraints for table `prescription_barcodes`
--
ALTER TABLE `prescription_barcodes`
  ADD CONSTRAINT `prescription_barcodes_ibfk_1` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `prescription_medicines`
--
ALTER TABLE `prescription_medicines`
  ADD CONSTRAINT `prescription_medicines_ibfk_1` FOREIGN KEY (`prescription_id`) REFERENCES `prescriptions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `prescription_tests`
--
ALTER TABLE `prescription_tests`
  ADD CONSTRAINT `prescription_tests_ibfk_1` FOREIGN KEY (`prescription_id`) REFERENCES `prescriptions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD CONSTRAINT `fk_po_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_purchase_orders_delivery_location_branches` FOREIGN KEY (`delivery_location`) REFERENCES `branches` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `purchase_orders_ibfk_1` FOREIGN KEY (`pr_id`) REFERENCES `purchase_requisitions` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `purchase_orders_ibfk_2` FOREIGN KEY (`vendor_id`) REFERENCES `vendors` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `purchase_orders_ibfk_4` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  ADD CONSTRAINT `purchase_order_items_ibfk_1` FOREIGN KEY (`po_id`) REFERENCES `purchase_orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchase_order_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `purchase_requisitions`
--
ALTER TABLE `purchase_requisitions`
  ADD CONSTRAINT `fk_pr_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_purchase_requisitions_department_id_branches` FOREIGN KEY (`department_id`) REFERENCES `branches` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `purchase_requisitions_ibfk_1` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `purchase_requisition_items`
--
ALTER TABLE `purchase_requisition_items`
  ADD CONSTRAINT `purchase_requisition_items_ibfk_1` FOREIGN KEY (`pr_id`) REFERENCES `purchase_requisitions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchase_requisition_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `stock_transfers`
--
ALTER TABLE `stock_transfers`
  ADD CONSTRAINT `fk_stock_transfers_from_department_branches` FOREIGN KEY (`from_department`) REFERENCES `branches` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_stock_transfers_to_department_branches` FOREIGN KEY (`to_department`) REFERENCES `branches` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `stock_transfers_ibfk_3` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `stock_transfers_ibfk_4` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `stock_transfers_ibfk_5` FOREIGN KEY (`received_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `stock_transfer_items`
--
ALTER TABLE `stock_transfer_items`
  ADD CONSTRAINT `stock_transfer_items_ibfk_1` FOREIGN KEY (`transfer_id`) REFERENCES `stock_transfers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `stock_transfer_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `stock_transfer_items_ibfk_3` FOREIGN KEY (`batch_id`) REFERENCES `inventory_batches` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_user_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`);

--
-- Constraints for table `vitals`
--
ALTER TABLE `vitals`
  ADD CONSTRAINT `vitals_ibfk_1` FOREIGN KEY (`consultation_id`) REFERENCES `consultations` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
