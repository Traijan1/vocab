import { Query } from "https://deno.land/x/appwrite@6.0.0/mod.ts";
import { sdk } from "./deps.ts";

/*
  'req' variable has:
    'headers' - object with request headers
    'payload' - request body data as a string
    'variables' - object with function variables

  'res' variable has:
    'send(text, status)' - function to return text response. Status code defaults to 200
    'json(obj, status)' - function to return JSON response. Status code defaults to 200
  
  If an error is thrown, a response with code 500 will be returned.
*/

interface Word {
    language_id: string,
    mother_tongue: string,
    foreign_language: string,
    type: string,
    second_reading: string,
    difficulty: string,
    next_shown: Date,
    streak: number,
    $id: string
    $collectionId: string, 
    $databaseId: string, 
    $createdAt: string, 
    $updatedAt: string, 
    $permissions: string[]
}

export default async function (req: any, res: any) {
    const client = new sdk.Client();
    const database = new sdk.Databases(client);

    if (!req.variables['APPWRITE_FUNCTION_ENDPOINT'] || !req.variables['APPWRITE_FUNCTION_API_KEY']) {
        console.warn("Environment variables are not set. Function cannot use Appwrite SDK.");
    } else {
        client
        .setEndpoint(req.variables['APPWRITE_FUNCTION_ENDPOINT'] as string)
        .setProject(req.variables['APPWRITE_FUNCTION_PROJECT_ID'] as string)
        .setKey(req.variables['APPWRITE_FUNCTION_API_KEY'] as string);
    }

    const data = (req.variables["APPWRITE_FUNCTION_DATA"] as string).split(";");
    const databaseData = await database.listDocuments<Word>("632a31e4b3c3abd8c82e", "6335c25f2911b6f34739", [
        Query.equal("$id", data[0])
    ]);
    
    const document = databaseData.documents[0];

    if(data[1].toLowerCase() == "true") 
        document.streak += 1;
    else 
        document.streak = 0;

    // 1800000 = 30 Minutes
    // 86400000 = 1 Day

    const dayMilliseconds = 86400000 / 2;

    const toAdd = new Date(new Date().getTime() + 
            new Date(dayMilliseconds * document.streak - (document.streak == 0 ? 300000 : 0)).getTime());

    await database.updateDocument(document.$databaseId, document.$collectionId, document.$id, {
        "streak": document.streak,
        "next_shown": toAdd
    });
}

// https://en.wikipedia.org/wiki/SuperMemo#Description_of_SM-2_algorithm