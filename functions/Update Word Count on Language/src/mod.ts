import { Query } from "https://deno.land/x/appwrite@6.0.0/mod.ts";
import { sdk } from "./deps.ts";

interface Language {
    count: number,
    name: string,
    userId: string,
    $id: string
    $collectionId: string, 
    $databaseId: string, 
    $createdAt: string, 
    $updatedAt: string, 
    $permissions: string[]
}

export default async function (req: any, res: any) {
    const client = new sdk.Client();

    // You can remove services you don't use
    const database = new sdk.Databases(client);

    if (!req.variables['APPWRITE_FUNCTION_ENDPOINT'] || !req.variables['APPWRITE_FUNCTION_API_KEY']) {
        console.warn("Environment variables are not set. Function cannot use Appwrite SDK.");
    } else {
        client
        .setEndpoint(req.variables['APPWRITE_FUNCTION_ENDPOINT'] as string)
        .setProject(req.variables['APPWRITE_FUNCTION_PROJECT_ID'] as string)
        .setKey(req.variables['APPWRITE_FUNCTION_API_KEY'] as string);
    }

    const data = JSON.parse(req.variables["APPWRITE_FUNCTION_EVENT_DATA"]);
    const documents = await database.listDocuments<Language>("632a31e4b3c3abd8c82e", "632a31f2b3bda4bfea4c", [Query.equal("$id", data["language_id"])]);
    
    const lang = documents.documents[0];

    lang.count += 1;

    await database.updateDocument("632a31e4b3c3abd8c82e", "632a31f2b3bda4bfea4c", data["language_id"], {
        "name": lang.name,
        "userId": lang.userId,
        "count": lang.count
    });
       
    res.send("test");
}