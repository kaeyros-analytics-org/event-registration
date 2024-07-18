import { NextFunction, Request, Response } from "express";
import { helpers } from "../../utils/helpers";
import Event from "../database/schemas/event.schemas";

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
        res.status(201).send(event);
    }
}

export const eventController = new EventController()