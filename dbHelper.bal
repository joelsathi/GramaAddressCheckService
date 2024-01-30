import ballerina/sql;
import ballerinax/postgresql;


// Configurable parameters for the PostgreSQL database connection.
configurable string host = ?;
configurable string username = ?;
configurable string db = ?;
configurable string password = ?;
configurable int port = ?;


# Function to execute a parameterized SQL query and return a single row result or an error.
# 
# + query - sql query to execute
# + return - An error if the query execution fails, otherwise, the result of the query.
function dbQueryRow(sql:ParameterizedQuery query) returns error|sql:ExecutionResult {
    // Creating a new PostgreSQL client with the provided connection parameters and a connection pool.
    postgresql:Client dbClient = check new (host, username, password,
    db, port, connectionPool = {maxOpenConnections: 5});

    sql:ExecutionResult|error result = dbClient->queryRow(query);

    // Closing the database client to release resources after the query execution.
    check dbClient.close();

    return result;
};



// function dbExecute(sql:ParameterizedQuery query) returns error|sql:ExecutionResult {
//     postgresql:Client dbClient = check new (host, username, password,
//     db, port, connectionPool = {maxOpenConnections: 5});

//     sql:ExecutionResult|error result = dbClient->execute(query);

//     check dbClient.close();

//     return result;
// };

function dbQuery(sql:ParameterizedQuery query) returns stream<AddressRecord, sql:Error?>|error {
    postgresql:Client dbClient = check new (host, username, password,
    db, port, connectionPool = {maxOpenConnections: 5});

    stream<AddressRecord, sql:Error?> result = dbClient->query(query);

    check dbClient.close();

    return result;
};

