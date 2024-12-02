# ADF_Snow_SFDC_Datalake
Azure Data Factory (AFF) Template: Salesforce to Snowflake Metadata Driven Data Lake

5 Minute Demo - https://www.youtube.com/watch?v=mI89lLFwSdQ
<br/>30 Minute End to End configuration (coming soon!)

<h2>Pre-Install ADF Requirements</h2>
<h3>SALESFORCE</h3>
You will need a Salesforce linked service


You will need Salesforce username, password and user token generated via connected app configuration. This will require Salesforce elevated permissions. We have created a step by step tutorial to streamline the process and ensure it is setup properly.
<br/>DataTools Pro Step by Step Tutorial: https://datatoolspro.com/tutorials/azure-data-factory-for-salesforce/
<br/>More info from Salesforce: https://help.salesforce.com/s/articleView?id=sf.user_security_token.htm&language=en_US&type=5
<br/>More info from Azure DataFactory: https://learn.microsoft.com/en-us/azure/data-factory/connector-salesforce?tabs=data-factory#create-a-linked-service-to-salesforce-using-ui


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

<h2>ADF Template Install Directions</h2> <ol> <li>Download the ZIP template file labeled **"Data Tools Pro 1-Click Data Lake"**.</li> <li>Open **Azure Data Factory**.</li> <li>Click the **"+"** button next to Pipelines.</li> <li>Click **Add from Template**.</li> <li>Select the downloaded ZIP file from your desktop.</li> <li>Follow the template prompts to select your Salesforce, Snowflake, and Blob storage linked services.</li> <li>Select the canvas and click **Parameters**.</li> <li>Fill in the parameters for **DatabaseName**, **SchemaName**, and optional prompts for creating a new schema or using an existing schema.</li> </ol> <h2>Usage</h2> When you configure the template, you will set the following ADF parameters:
<br/><h4>SinkSalesforceObjects</h4> Comma-separated list of Salesforce objects. This list is case-sensitive and should match your Salesforce organization's Object API Names. When Snowflake tables are created, they are converted to case-insensitive (UPPER CASE).

<br/><h4>DatabaseName</h4> The Snowflake database where your schema and stage tables will be created and populated with data.

<br/><h4>SchemaName</h4> The Snowflake schema name where you will stage and create your Salesforce data lake.

<br/><h4>ConfigureEnvironment</h4> Runs the configuration steps to complete the following:

<ul> <li>Installs two stored procedures: **"ADFMAPPINGFROMSFDCMETADATA"** and **"DDLFROMMETADATA"**.</li> <li>Adds a log table called **"LOGTABLE"**.</li> <li>Adds two metadata tables: **"SFDC_METADATA_STAGE_TEMP"** and **"SFDC_METADATA_STAGE"**.</li> </ul>
<br/><h4>CreateNewSchema</h4> This function generates a new schema in your database for inserting and creating your data lake. This requires elevated permissions to create a schema in your Snowflake account. <br>Accepted values:</br>

<ul> <li>**"yes"** - Creates a new schema.</li> <li>**"no"** - Uses an existing schema.</li> </ul>
<br/><h4>AppendFields</h4> This function appends new fields to your metadata if they are added to your source table. <br>Accepted values:</br>

<ul> <li>**"yes"** - Appends new fields in your source table.</li> <li>**"no"** - Ignores new fields in your source table.</li> </ul>
<br/><h4>SnowErrorHandling</h4> When copying data to Snowflake, error handling is enabled. <br>Accepted string values:</br>

<ul> <li>**"CONTINUE"** - Ignores errors and inserts only valid records in your dataset.</li> <li>**"SKIP_FILE"** - Skips the entire file, resulting in 0 records being inserted.</li> <li>**"ABORT_STATEMENT"** - Fails the pipeline.</li> </ul>
<br/><h4>RecordLimit</h4> Record limit helps with testing and debugging by reducing the size of your object queries. <br>Accepted string value:</br> "LIMIT 1000000"

<br/><h4>VersionNumber</h4> The version number is set for development purposes. We recommend not updating this parameter to avoid conflicts with backward compatibility.
