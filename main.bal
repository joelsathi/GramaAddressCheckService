import ballerina/io;
import ballerina/http;
import ballerinax/postgresql.driver as _;

public function main() {

}

service / on new http:Listener(3000) {
    resource function post addressCheck(@http:Payload User user, http:Caller caller) returns error?{

        http:Response response = new;

        boolean isValidNIC = validateNic(user.nic);
        if (!isValidNIC) {
            response.statusCode = 200;
            response.setPayload({status:"Error",description: "Invalid NIC"});
            check caller->respond(response);
            return;
        }

        boolean status = check checkAddress(user) ?: false;
        io:println(status);

        response.statusCode = 200;
        if (status) {
            response.setPayload({status: 2, description: "Address is checked!"});
        } else {
            response.setPayload({ status: 1, description: "Address is not tallied!"});
        }
        
        check caller->respond(response);
        return;
    }

    // resource function post updateStatus(@http:Payload StatusEntry entry, http:Caller caller)returns error? {
    //     http:Response response = new;
    //     string|error res = updateStatus(entry);

        
    //     if(res is error) {
    //         response.statusCode = 200;
    //         response.setPayload({status: "Error", description: "Something went wrong! please try again after some time"});
    //     } else {
    //         response.statusCode = 201;
    //        response.setPayload({status: "Success", description: res});
    //     }

    //     check caller->respond(response);
        
    // }

    // resource function post getStatus(@http:Payload Nic nic, http:Caller caller) returns error? {
    //     io:println("running: ", nic.nic);
    //     http:Response response = new;
    //     json[] result = check getStatusHistory(nic.nic);

    //     response.statusCode = 200;
       
    //     json respObj = {"result": result};
        
    //     response.setHeader("Content-Type", "application/json");
    //     response.setPayload(respObj);

    //     check caller->respond(response.getJsonPayload());
    // }

    
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