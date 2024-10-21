import { NextFunction, Request, Response } from "express";
import { salesFormService } from "./sales-form.service";
import { salesRepresentativeService } from "../sales-representative/sale-representative.service";

class SalesFormController {

    async get(req: Request, res: Response, next: NextFunction){
        const { code } = req.params
        console.log('code =', code)

        const sale_representative = await salesRepresentativeService.getByCode(code);

        if(sale_representative.status != 200) return res.status(400).send(sale_representative.message)

        if(sale_representative.message == null) return res.status(400).send("Sale Representative Not Found")
        
        // res.send(req.query)
        res.render(`./pages/index`, {sale_representative_code: code, 
            sale_representative_id: sale_representative.message.id, 
            sale_representative_name: sale_representative.message.name})
    } 

    async list(req: Request, res: Response, next: NextFunction){
        const sales = await salesFormService.getAll();
        res.status(sales.status).send(sales.message);
    }

    async listByCode(req: Request, res: Response, next: NextFunction){
        const { code } = req.params

        if(code == null) return res.status(400).send("Code Not Found")
        const sales = await salesFormService.listByCode(code);
        res.status(sales.status).send(sales.message);
    }

    async create(req: Request, res: Response, next: NextFunction){
        try{
            const data = req.body
            console.log('data ==', data);

            const sales = await salesFormService.create(data)
            res.status(sales.status).send(sales.message);
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
            const sales = await salesFormService.update(id, data)
            res.status(sales.status).send(sales.message);
        }
        catch(error){
            console.log('error for update form data sales =', error);
            res.status(400).send(`Error for update form data sales : ${error}`);
        }
    }

    async download(req: Request, res: Response, next: NextFunction){
        try {
            return await salesFormService.downloadDataExcel(req, res, next)
        } catch (error) {
            console.log('error for download form data sales =', error);
            res.status(400).send(`Error for download form data sales : ${error}`);
        }
    }
}

export const salesFormController = new SalesFormController()