import ballerina/io;
import ballerina/http;
import ballerinax/postgresql.driver as _;
import ballerinax/postgresql;
import ballerina/sql;

public function main() {

}

service /addresscheck on new http:Listener(3000) {
    resource function post addressCheck(@http:Payload User user, http:Caller caller) returns error?{

        http:Response response = new;

        boolean isValidNIC = validateNic(user.id);
        if (!isValidNIC) {
            response.statusCode = 400;
            response.setPayload({status:"Error",description: "Invalid NIC"});
            check caller->respond(response);
            return;
        }

        boolean status = check checkAddress(user) ?: false;
        io:println(status);

        response.statusCode = 200;
        if (status) {
            response.setPayload({status: "Success", description: "Address is checked!"});
        } else {
            response.setPayload({ status: "Error", description: "Address is not tallied!"});
        }
        
        check caller->respond(response);
        return;
    }
}

public type User record {|
    string id;
    string address;
|};

 function checkAddress(User user) returns boolean|sql:Error? {
    postgresql:Client dbClient =
        check new ("pg-7902e7c7-f73b-401f-a1db-07c524deb30a-gramadb1173796818-chore.a.aivencloud.com", 
        "avnadmin", "AVNS_9-DvxwnPEN4UQCo6gHA",
        "GramaDatabase", 25416
    );

    sql:ParameterizedQuery query = `SELECT "address" FROM "user" WHERE "id"=${user.id};`;


    sql:ExecutionResult|error result = dbClient->queryRow(query);
    io:println(result);

    check dbClient.close();

    if (result is error) {
        return false;
    } else {
        return (string:toLowerAscii(result["address"].toString()) == string:toLowerAscii(user.address));
    }

    
}

function validateNic(string nic) returns boolean {
    boolean isValid = false;
    string:RegExp nicRegex = re`^[0-9]{9}[vVxX]$`;
    string:RegExp nicRegex2 = re`^[0-9]{12}$`;

    if (nic.matches(nicRegex)) {
        isValid = true;
    }
    else if (nic.matches(nicRegex2)) {
        isValid = true;
    }
    return isValid;
}