(OBJECTNAME VARCHAR, EXCLUDE VARCHAR) RETURNS VARCHAR LANGUAGE JAVASCRIPT AS $$
var current_database_result = snowflake.execute({
    sqlText: "SELECT CURRENT_DATABASE()"
});
current_database_result.next();
var current_database_value = current_database_result.getColumnValue(1);
var current_schema_result = snowflake.execute({
    sqlText: "SELECT CURRENT_SCHEMA()"
});
current_schema_result.next();
var current_schema_value = current_schema_result.getColumnValue(1);
var metadata_table = current_database_value + "." + current_schema_value + ".SFDC_METADATA_STAGE";
var sql_command = "SELECT OBJECTNAME, QUALIFIEDAPINAME, VALUETYPEID, LENGTH FROM " + metadata_table + " WHERE OBJECTNAME = '" + OBJECTNAME + "'";
if (EXCLUDE !== null && EXCLUDE !== '') {
    sql_command += " AND QUALIFIEDAPINAME NOT IN ('" + EXCLUDE.replace(/,/g, "','") + "')";
}
var result = snowflake.execute({
    sqlText: sql_command
});
var column_names = [];
var column_types = [];
while (result.next()) {
    column_names.push(result.getColumnValue("QUALIFIEDAPINAME"));
    var valuetype = result.getColumnValue("VALUETYPEID");
    var length = result.getColumnValue("LENGTH");
    if (valuetype == "id") {
        column_types.push("VARCHAR(" + length + ")");
    } else if (valuetype == "string") {
        column_types.push("VARCHAR(" + length + ")");
    } else if (valuetype == "boolean") {
        column_types.push("BOOLEAN");
    } else if (valuetype == "double") {
        column_types.push("FLOAT");
    } else if (valuetype == "integer") {
        column_types.push("INT");
    } else if (valuetype == "datetime") {
        column_types.push("TIMESTAMP_NTZ");
    } else if (valuetype == "date") {
        column_types.push("DATE");
    } else {
        column_types.push("VARCHAR(255)");
    }
}
var DDL = "CREATE OR REPLACE TABLE " + current_database_value + "." + current_schema_value + "." + OBJECTNAME + " (\n";
for (var i = 0; i < column_names.length; i++) {
    DDL += "  \"" + column_names[i] + "\" " + column_types[i] + ",\n";
}
DDL = DDL.slice(0, -2) + "\n);";
return DDL;
$$;