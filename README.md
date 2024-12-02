# ADF_Snow_SFDC_Datalake
Azure Data Factory (AFF) Template: Salesforce to Snowflake Metadata Driven Data Lake

5 Minute Demo - https://www.youtube.com/watch?v=mI89lLFwSdQ
<br/>30 Minute End to End configuration (coming soon!)

<h2>Pre-Install ADF Requirements</h2>
<h3>SALESFORCE</h3>
You will need a Salesforce linked service
https://learn.microsoft.com/en-us/azure/data-factory/connector-salesforce?tabs=data-factory#create-a-linked-service-to-salesforce-using-ui

You will need Salesforce username, password and user token
https://help.salesforce.com/s/articleView?id=sf.user_security_token.htm&language=en_US&type=5


<h3>SNOWFLAKE</h3>
You will need a Snowflake linked service
https://learn.microsoft.com/en-us/azure/data-factory/connector-snowflake?tabs=data-factory#create-a-linked-service-to-snowflake-using-ui

When you create your linked service, you will want to ensure the ADF system user has a role that has been granted the following following privileges on the database you are using for this project. This following code will execte when you provide the database name and role name.
<code>
GRANT CREATE EXTERNAL TABLE ON FUTURE SCHEMAS IN DATABASE <db_name> TO ROLE <role_name>;
GRANT CREATE SCHEMA ON DATABASE <db_name> TO ROLE <role_name>;
GRANT CREATE STAGE ON FUTURE SCHEMAS IN DATABASE <db_name> TO ROLE <role_name>;
GRANT CREATE TABLE ON FUTURE SCHEMAS IN DATABASE <db_name> TO ROLE <role_name>;
GRANT CREATE TEMPORARY TABLE ON FUTURE SCHEMAS IN DATABASE <db_name> TO ROLE <role_name>;
GRANT CREATE VIEW ON FUTURE SCHEMAS IN DATABASE <db_name> TO ROLE <role_name>;
GRANT INSERT ON FUTURE TABLES IN DATABASE <db_name> TO ROLE <role_name>;
GRANT READ ON FUTURE STAGES IN DATABASE <db_name> TO ROLE <role_name>;
GRANT SELECT ON FUTURE TABLES IN DATABASE <db_name> TO ROLE <role_name>;
GRANT SELECT ON FUTURE VIEWS IN DATABASE <db_name> TO ROLE <role_name>;
GRANT TRUNCATE ON FUTURE TABLES IN DATABASE <db_name> TO ROLE <role_name>;
GRANT UPDATE ON FUTURE TABLES IN DATABASE <db_name> TO ROLE <role_name>;
GRANT USAGE ON FUTURE FUNCTIONS IN DATABASE <db_name> TO ROLE <role_name>;
GRANT USAGE ON FUTURE PROCEDURES IN DATABASE <db_name> TO ROLE <role_name>;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE <db_name> TO ROLE <role_name>;
GRANT USAGE ON FUTURE STAGES IN DATABASE <db_name> TO ROLE <role_name>;
GRANT WRITE ON FUTURE STAGES IN DATABASE <db_name> TO ROLE <role_name>;
  </code>

Once you have tested, we recommend setting a security/network policy for this newly created system user:
https://datatoolspro.com/tutorials/snowflake-user-network-policy/

<h3>Blob Storage with Shared access signature (SAS) based Authentication</h3>
You will need a blob storage container linked service configured with Shared access signature
<br/>
1 Shared access signature authentication configuration
https://docs.snowflake.com/en/user-guide/data-load-azure-config#option-2-generating-a-sas-token
<br/>
2. Create a SAS Linked Service in ADF
https://learn.microsoft.com/en-us/azure/data-factory/connector-azure-blob-storage?tabs=data-factory#create-an-azure-blob-storage-linked-service-using-ui

<h2>ADF Template Install Directions</h2>
<ol><li>Download the Zip Template file labeled "Data Tools Pro 1 Click Data Lake"</li>
<li>Open Azure Data Factory</li>
<li>Click "+" Button Next to Pipelines</li>
<li>Click Add from Template</li>
<li>Select the downloaded zip file from your desktop</li>
<li>Follow the Template Prompts to select your Salesforce, Snowflake, and Blob storage linked services</li>
<li>Select the canvas and click parameters</li>
<li>Fill in the parameters for DatabaseName, Schemaname, and optional prompts for creating a new schema or using an existing schema.</li></ol>

<h2>Usage</h2>
When you configure the template you will configure the following ADF parameters
<br/><h4>SinkSalesforceObjects</h4>
Comma seperared lists of Salesforce objects. This list is case sensitive and should match your Salesforce organization's Object API Names. When Snowflake tables are created, they are converted to case insisitive (upper case).

<br/><h4>DatabaseName<h4>
Your Snowflake Database where your schema and stage tables will be created and populated with data.

<br/><h4>SchemaName<h4>
Snowflake schema name where you will stage and create your Salesforce data lake.

<br/><h4>ConfigureEnvironment <h4>
Will run the congiguration steps which completes the following:
Installs 2 stored procedures called "ADFMAPPINGFROMSFDCMETADATA" and "DDLFROMMETADATA" 
Adds a log table called "LOGTABLE"
Adds a meta data table called "SFDC_METADATA_STAGE_TEMP" and "SFDC_METADATA_STAGE"

<br/><h4>CreateNewSchema<h4>
This function will generate a brand new schema in your database to insert and create your data lake. This will require elevated permissions to create a schema on an existing databse in your Snowflake account.
<br>Accepted values:</br>
"yes" Will append new fields in your source table
"no" Will ignore new fields in your source table

<br/><h4>AppendFields </h4>
This function will append new fields to your meta data if they are added to your source table.
<br>Accepted values:</br>
"yes" Will append new fields in your source table
"no" Will ignore new fields in your source table

<br/><h4>SnowErrorHandling </h4>
When copying data to Snowfake, we have enabled error handling. 
<br/> Accepted string values:<br/>
"CONTINUE"  Will ignore errors and insert only valid records in your data set.
"SKIP_FILE" Will the intire file resulting in 0 records inserted.
"ABORT_STATEMENT": Will fail the pipeline

<br/><h4>RecordLimit<h4>
Record limit was designed to help with testing and debugging to reduce the size of your object queries.
<br/>Accepted string value: "LIMIT 1000000" 

<h4>VersionNumber</h4>
VersionNumber is set for development purposes. We recommend not updating this parameter to conflict with backwards compatibility.
