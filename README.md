# adf_snow_sfdc_datalake
Azure Data Factory Template: Salesforce to Snowflake Metadata Driven Data Lake

5 Minute Demo - https://www.youtube.com/watch?v=mI89lLFwSdQ

<h2>Pre-Install ADF Requirements</h2>
<h3>SALESFORCE</h3>
You will need a Salesforce linked service
https://learn.microsoft.com/en-us/azure/data-factory/connector-salesforce?tabs=data-factory#create-a-linked-service-to-salesforce-using-ui

You will need Salesforce username, password and user token
https://help.salesforce.com/s/articleView?id=sf.user_security_token.htm&language=en_US&type=5


<h3>SNOWFLAKE</h3>
You will need a Snowflake linked service
https://learn.microsoft.com/en-us/azure/data-factory/connector-snowflake?tabs=data-factory#create-a-linked-service-to-snowflake-using-ui

When you create your linked service, you will want to cretae a system user with a role that has the following privileges:
CREATE EXTERNAL TABLE - FUTURE SCHEMA
CREATE MASKING POLICY - FUTURE SCHEMA
CREATE SCHEMA
CREATE STAGE - FUTURE SCHEMA
CREATE TABLE - FUTURE SCHEMA
CREATE TEMPORARY TABLE - FUTURE SCHEMA
CREATE VIEW - FUTURE SCHEMA
INSERT - FUTURE TABLE
READ - FUTURE STAGE
SELECT - FUTURE TABLE
SELECT - FUTURE VIEW
TRUNCATE - FUTURE TABLE
UPDATE - FUTURE TABLE
USAGE
USAGE - FUTURE FUNCTION
USAGE - FUTURE PROCEDURE
USAGE - FUTURE SCHEMA
USAGE - FUTURE STAGE
WRITE - FUTURE STAGE

Once you have tested, we recommend setting a security/network policy for this newly created system user:
https://datatoolspro.com/tutorials/snowflake-user-network-policy/

<h3>Blob Storage with Shared access signature (SAS) based Authentication</h3>
You will need a blob storage container linked service configured with Shared access signature
1 Shared access signature authentication configuration
https://docs.snowflake.com/en/user-guide/data-load-azure-config#option-2-generating-a-sas-token

2. Create a SAS Linked Service in ADF
https://learn.microsoft.com/en-us/azure/data-factory/connector-azure-blob-storage?tabs=data-factory#create-an-azure-blob-storage-linked-service-using-ui

<h2>ADF Template Install Directions</h2>
1. Download the Zip Template file labeled "Data Tools Pro 1 Click Data Lake"
2. Open Azure Data Factory
3. Click "+" Button Next to Pipelines
4. Click Add from Template
5. Select the downloaded zip file from your desktop
6. Follow the Template Prompts to select your Salesforce, Snowflake, and Blob storage linked services
7. Select the canvas and click parameters
8. Fill in the parameters for DatabaseName, Schemaname, and optional prompts for creating a new schema or using an existing schema.
