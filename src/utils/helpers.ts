import path from "path"
import os from "os";

class Helpers{

    getView(filename: string){
        return path.join(__dirname,  '..', 'views', `${filename}.html`)
    }

    generateUniqueId(start: string, length = 6) {
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        let result = start;
        for (let i = 0; i < length; i++) {
            const randomIndex = Math.floor(Math.random() * chars.length);
            result += chars[randomIndex];
        }
        return result;
    }

    getBaseUrl() {
        const hostname = os.hostname();
        return `https://${hostname}`
    }
}

export const helpers = new Helpers()