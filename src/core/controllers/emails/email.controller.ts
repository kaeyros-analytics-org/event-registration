import { NextFunction, Request, Response } from "express";
import Email from "../../database/schemas/emails.schemas";

class EmailController {

    get(req: Request, res: Response, next: NextFunction){
        res.render(`./pages/index`)
    }

    async email(req: Request, res: Response, next: NextFunction){
        const event = await Email.findOne();
        if(!event) return 'NOT FOUND'
        res.render(`./emails/event`, event)
    } 

    async list(req: Request, res: Response, next: NextFunction){
        const email = await Email.find();
        res.status(200).send(email);
    }

    async create(req: Request, res: Response, next: NextFunction){
        try {
            const data = req.body
            const email = new Email(data)
            await email.save();
            res.status(201).send(email);

        } catch(error){
            console.log('error for create email settings =', error);
            res.status(400).send(`Error for email settings : ${error}`);
        }
        
    }

    async update(req: Request, res: Response, next: NextFunction){
        try {
            const data = req.body
            const { id } = req.params
            const email = await Email.findByIdAndUpdate(id, data)
            res.status(201).send(email);
        } catch(error){
            console.log('error for create email settings =', error);
            res.status(400).send(`Error for email settings : ${error}`);
        }        
    }

    async delete(req: Request, res: Response, next: NextFunction){
        try {
            const { id } = req.params
            await Email.findByIdAndDelete(id)
            res.status(201).send("Deleted");
        } catch(error){
            console.log('error for create email settings =', error);
            res.status(400).send(`Error for email settings : ${error}`);
        }
    }
}

export const emailController = new EmailController()