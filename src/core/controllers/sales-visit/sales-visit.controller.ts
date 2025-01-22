import { NextFunction, Request, Response } from "express";
import { salesVisitService } from "./sales-visit.service";
import { salesRepresentativeService } from "../sales-representative/sale-representative.service";

class SalesVisitController {

    async get(req: Request, res: Response, next: NextFunction){       
        // res.send(req.query)
        res.render(`./pages/form_index`)
    } 

    async getForm(req: Request, res: Response, next: NextFunction){
        const { code } = req.params
        console.log('code =', code)

        const sale_representative = await salesRepresentativeService.getByCode(code);

        if(sale_representative.status != 200) return res.status(400).send(sale_representative.message)

        if(sale_representative.message == null) return res.status(400).send("Sale Representative Not Found")

        const countPerDay = await salesVisitService.countSaleVisit(code);

        if(countPerDay.status != 200) return res.status(400).send(countPerDay.message)

        const date = new Date();
        const year = date.getFullYear();
        const month = date.getMonth() + 1;
        const day = date.getDate();
        const sale_representative_date = `${day.toString().padStart(2, '0')}-${month.toString().padStart(2, '0')}-${year}`
        
        // res.send(req.query)
        res.render(`./pages/index_visit`, {sale_representative_code: code, 
            sale_representative_id: sale_representative.message.id, 
            sale_representative_name: sale_representative.message.name, sale_representative_count: countPerDay.message,
            sale_representative_date
        })
    } 

    async list(req: Request, res: Response, next: NextFunction){
        const sales = await salesVisitService.getAll();
        res.status(sales.status).send(sales.message);
    }

    async listByCode(req: Request, res: Response, next: NextFunction){
        const { code } = req.params

        if(code == null) return res.status(400).send("Code Not Found")
        const sales = await salesVisitService.listByCode(code);
        res.status(sales.status).send(sales.message);
    }

    async searchByCompany(req: Request, res: Response, next: NextFunction){
        const q = req.query.q as string

        if(!q) return res.status(400).send("search Not Found")
        const sales = await salesVisitService.searchFormVisit(q);
        res.status(sales.status).send(sales.message);
    }

    async regularCityWithLongitudeAndLatitude(req: Request, res: Response, next: NextFunction){
        await salesVisitService.regularCityWithLongitudeAndLatitude();
        res.status(200).send('Ok');
    }

    async create(req: Request, res: Response, next: NextFunction){
        try{
            const data = req.body
            console.log('data ==', data);

            const sales = await salesVisitService.create(data)
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
            const sales = await salesVisitService.update(id, data)
            res.status(sales.status).send(sales.message);
        }
        catch(error){
            console.log('error for update form data sales =', error);
            res.status(400).send(`Error for update form data sales : ${error}`);
        }
    }

    async download(req: Request, res: Response, next: NextFunction){
        try {
            return await salesVisitService.downloadDataExcel(req, res, next)
        } catch (error) {
            console.log('error for download form data sales =', error);
            res.status(400).send(`Error for download form data sales : ${error}`);
        }
    }
}

export const salesVisitController = new SalesVisitController()