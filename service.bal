import ballerina/sql;
import ballerina/io;
 function checkAddress(User user) returns boolean|sql:Error? {

    sql:ParameterizedQuery query = `SELECT "address" FROM "user" WHERE "id"=${user.nic};`;

    sql:ExecutionResult|error result = dbQuery(query);
    io:println(result);

    if (result is error) {
        return false;
    } else {
        return (string:toLowerAscii(result["address"].toString()) == string:toLowerAscii(user.address));
    }

    
}

function updateStatus(StatusEntry entry) returns string| error {
    sql:ParameterizedQuery query= `INSERT INTO "status" ("user_id", "id_check_status", "address_check_status", "police_check_status")
VALUES ('${entry.nic}', ${entry.idCheckStatus}, ${entry.addressCheckStatus}, ${entry.policeCheckStatus});`;

    io:println(query);
    sql:ExecutionResult|error result = dbQuery(query);
    io:println(result);

    if(result is error) {
        return result;
    } else {
        return "Successfully updated!";
    }

}