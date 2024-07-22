import { NextFunction, Request, Response } from "express";
import { helpers } from "../../utils/helpers";
import Event from "../database/schemas/event.schemas";
import { eventService } from "./event.service";

class EventController {

    get(req: Request, res: Response, next: NextFunction){
        res.render(`./pages/index`)
    }

    async list(req: Request, res: Response, next: NextFunction){
        const event = await Event.find();
        res.status(200).send(event);
    }

    async create(req: Request, res: Response, next: NextFunction){
        const data = req.body
        const event = new Event(data)
        await event.save();
        // const data
        eventService.sendEmail(event.email, `Event Registration : ${event.first_name}`, 'test Hello content!')
        res.status(201).send(event);
    }
}

export const eventController = new EventController()