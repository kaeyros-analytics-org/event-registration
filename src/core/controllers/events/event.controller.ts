import { NextFunction, Request, Response } from "express";
import { helpers } from "../../../utils/helpers";
import Event from "../../database/schemas/event.schemas";
import { eventService } from "./event.service";
import Email from "../../database/schemas/emails.schemas";

class EventController {

    get(req: Request, res: Response, next: NextFunction){
        res.render(`./pages/index`)
    }

    async email(req: Request, res: Response, next: NextFunction){
        const event = await Event.findOne();
        if(!event) return 'NOT FOUND'
        res.render(`./emails/event`, event)
    } 

    async list(req: Request, res: Response, next: NextFunction){
        const event = await Event.find();
        res.status(200).send(event);
    }

    async create(req: Request, res: Response, next: NextFunction){
        try{
            const data = req.body
            const event = new Event(data)
            await event.save();
            const emailSetting = await Email.find();
            if(emailSetting.length){
                for(let itemEmail of emailSetting){
                    // eventService.sendEmail(itemEmail.email, `Nouvel enregistrement à l'évènement - ${event.first_name}`, event)
                }
            }
            res.status(201).send(event);
        }
        catch(error){
            console.log('error for create event =', error);
            res.status(400).send(`Error for create event : ${error}`);
        }
    }
}

export const eventController = new EventController()