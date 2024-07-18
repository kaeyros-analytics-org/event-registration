import path from "path"

class Helpers{

    getView(filename: string){
        return path.join(__dirname,  '..', 'views', `${filename}.html`)
    }
}

export const helpers = new Helpers()