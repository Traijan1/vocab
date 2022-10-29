import { sdk } from "./deps.ts";
import { readCSV } from "https://deno.land/x/csv/mod.ts";

interface Word {
    mother_tongue: string,
    foreign_language: string,
    type: string,
    second_reading: string,
    difficulty: string,
    next_shown: Date,
    language_id: string
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

    const csv = req.variables["APPWRITE_FUNCTION_DATA"] as string;
    const data = parseCsv(csv);

    for(const word of data) {
        await database.createDocument("632a31e4b3c3abd8c82e", "6335c25f2911b6f34739", "unique()", word);
    }
}

function parseCsv(data: string): Word[] {
    const array: Word[] = [];
    const lines = data.split("\n");
    lines.shift();

    for(const line of lines) {
        const lineSplit = line.split(",");

        array.push({
            mother_tongue: lineSplit[0],
            foreign_language: lineSplit[1],
            type: lineSplit[5],
            second_reading: lineSplit[2],
            difficulty: lineSplit[4],
            next_shown: new Date(),
            language_id: "632a32a51affd47a0de6"
        })
    }

    return array;
}