import { NextFunction, Request, Response } from "express";
import { helpers } from "../../../utils/helpers";
import Event from "../../database/schemas/event.schemas";
import { eventService } from "./event.service";
import Email from "../../database/schemas/emails.schemas";

class EventController {

    get(req: Request, res: Response, next: NextFunction){
        const { promotion, collaborate } = req.query
        console.log(promotion)
        console.log(collaborate);
        
        // res.send(req.query)
        res.render(`./pages/index`, {promotion: promotion =='true'? 'true': 'false', collaborate_name: collaborate == undefined ? '': collaborate})
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
            console.log('data ==', data);
            
            data.is_promotion = data.is_promotion =='true'? true: false
            // return res.status(200).json(data)
            const event = new Event(data)
            await event.save();
            const emailSetting = await Email.find();
            const listEvent = await Event.find();
            eventService.sendEmail('brice.tchakouna@kaeyros-analytics.com', `Nouvel enregistrement à l'évènement - Event SMB`, event, listEvent.length)
            if(emailSetting.length){
                for(let itemEmail of emailSetting){
                    eventService.sendEmail(itemEmail.email, `Nouvel enregistrement à l'évènement - Event SMB`, event, listEvent.length)
                }
            }
            res.status(201).send(event);
        }
        catch(error){
            console.log('error for create event =', error);
            res.status(400).send(`Error for create event : ${error}`);
        }
    }

    async download(req: Request, res: Response, next: NextFunction){
        try {
            return await eventService.downloadDataExcel(req, res, next)
        } catch (error) {
            console.log('error for download event =', error);
            res.status(400).send(`Error for download event : ${error}`);
        }
    }
}

export const eventController = new EventController()