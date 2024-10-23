import { NextFunction, Request, Response } from "express";
import { salesRepresentativeService } from "./sale-representative.service";

class SalesRepresentativeController {

    get(req: Request, res: Response, next: NextFunction){
        const { promotion, collaborate } = req.query
        console.log(promotion)
        console.log(collaborate);
        
        // res.send(req.query)
        res.render(`./pages/form_representative_index`)
    } 

    async check(req: Request, res: Response, next: NextFunction){
        const { code } = req.params
        console.log('code 11 =', code);
        console.log('req.params =', req.params);
        
        
        const hostname = req.headers.host;
        const sales = await salesRepresentativeService.getByCodeWithLink(code, hostname);

        // res.send(req.query)
        res.status(sales.status).json(sales.message);
    } 

    async list(req: Request, res: Response, next: NextFunction){
        const sales = await salesRepresentativeService.getAll();
        res.status(sales.status).send(sales.message);
    }

    async create(req: Request, res: Response, next: NextFunction){
        try{
            const data = req.body
            console.log('data ==', data);

            const hostname = req.headers.host;

            const event = await salesRepresentativeService.create(data, hostname)
            res.status(event.status).send(event.message);
        }
        catch(error){
            console.log('error for create event =', error);
            res.status(400).send(`Error for create event : ${error}`);
        }
    }

    async update(req: Request, res: Response, next: NextFunction){
        try{
            const data = req.body
            const { id } = req.params
            const event = await salesRepresentativeService.update(id, data)
            res.status(201).send(event);
        }
        catch(error){
            console.log('error for update event =', error);
            res.status(400).send(`Error for update event : ${error}`);
        }
    }
}

export const salesRepresentativeController = new SalesRepresentativeController()