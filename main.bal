import ballerina/io;
import ballerina/http;
import ballerinax/postgresql.driver as _;
import ballerinax/postgresql;
import ballerina/sql;

public function main() {
    io:println("Hello, World!");
}

service /addresscheck on new http:Listener(3000) {
    resource function post addressCheck(@http:Payload User user) returns boolean|sql:Error? {
        boolean status = check checkAddress(user) ?: false;
        io:println(status);

        return status;
    }
}

public type User record {|
    string id;
    string address;
|};

 function checkAddress(User user) returns boolean|sql:Error? {
    postgresql:Client dbClient =
        check new ("pg-7902e7c7-f73b-401f-a1db-07c524deb30a-gramadb1489369037-chore.a.aivencloud.com", 
        "avnadmin", "AVNS_lqxqkt40klzjrbSwnDJ",
        "GramaUsers", 25416
    );

    

    sql:ParameterizedQuery query = `SELECT "address" FROM "user" WHERE "id"=${user.id};`;


    sql:ExecutionResult|error result = dbClient->queryRow(query);
    io:println(result);

    if (result is error) {
        return false;
    } else {
        return (string:toLowerAscii(result["address"].toString()) == string:toLowerAscii(user.address));
    }

    
}