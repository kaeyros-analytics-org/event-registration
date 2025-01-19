import SalesRepresentative from "../../database/schemas/sales-representative.schemas";
import { SalesFormModel } from "../../models/sales-form.models";
import SalesForm from "../../database/schemas/sales-form.schemas";
import { NextFunction, Request, Response } from "express";
import XLSX from "xlsx";
import { SalesVisitModel } from "../../models/sales-visit.models";
import SalesVisit from "../../database/schemas/sales-visit.schemas";

class SalesVisitService {

    async create(data: SalesVisitModel): Promise<{status: number, message: any}>
    {
        try {
            const sale_representative = await SalesRepresentative.findOne({code: data.sale_representative_code})
            if(sale_representative == null || sale_representative.id !== data.sale_representative_id) return {status: 400, message: "Sale Representative Not Found"}

            const saleVisitData = await SalesVisit.create(data)
            return {status: 201, message: saleVisitData}
            
        } catch (error) {
            console.log('error for create sale visit for representative =', error);
            return {status: 400, message: `Error for create sale visit for representative : ${error}`}
        }
    }

    async countSaleVisit(sale_representative_code: string): Promise<{status: number, message: any}>
    {
        try {
            // Récupère la date du jour (minuit)
            const startOfDay = new Date();
            startOfDay.setUTCHours(0, 0, 0, 0);

            // Récupère la date de fin de journée (23:59:59)
            const endOfDay = new Date();
            endOfDay.setUTCHours(23, 59, 59, 999);

            // Compte les enregistrements dans la plage de la journée
            const count = await SalesVisit.countDocuments({
                sale_representative_code: sale_representative_code,
                createdAt: {
                    $gte: startOfDay,
                    $lte: endOfDay,
                },
            });

            return {status: 200, message: count};
            
        } catch (error) {
            console.log('error for count sale visit for representative =', error);
            return {status: 400, message: `error count sale visit for representative: ${error}`};
        }
    }

    async listByCode(code: string): Promise<{status: number, message: any}>
    {
        try {
            const sale_representative = await SalesRepresentative.findOne({code: code})
            if(sale_representative == null) return {status: 400, message: "Sale Representative Not Found"}

            const saleVisitData = await SalesVisit.find({sale_representative_code: code}).populate('sale_representative_id')
            return {status: 200, message: saleVisitData}
            
        } catch (error) {
            console.log('error for list by code sale form for representative =', error);
            return {status: 400, message: `Error for list by code for sale form for representative : ${error}`}
        }
    }

    async update(id: string, name: string): Promise<{status: number, message: any}>
    {
        try {

            const saleFormData = await SalesVisit.findByIdAndUpdate(id, {name: name})
            return {status: 200, message: saleFormData}
            
        } catch (error) {
            console.log('error for update sale form for representative =', error);
            return {status: 400, message: `Error for update sale form for representative : ${error}`}
        }
    }

    async getAll(): Promise<{status: number, message: any}>
    {
        try {

            const saleFormData = await SalesVisit.find({})
            return {status: 200, message: saleFormData}
            
        } catch (error) {
            console.log('error for get all sale representative =', error);
            return {status: 400, message: `Error for get all sale representative : ${error}`}
        }
    }

    async downloadDataExcel(
        req: Request,
        res: Response,
        next: NextFunction
      ): Promise<any> {
        try {
          const saleFormData = await SalesVisit.find({}).populate('sale_representative_id');
    
          const data = saleFormData.map((item: any) => {
            return {
                "Id du representant": item.sale_representative_id.id,
                "Code du representant": item.sale_representative_code,
                "Nom du representant": item.sale_representative_id.name,
                "Nom du client": item.customer_name,
                "Nom du business": item.business_name,
                "Contact": item.contact,
                "Type du business": item.type_of_business,
                "Addresse": item.address,
                "Objectif de la visite": item.visit_objective,
                "Realisation": item.visit_note,
                "Commentaire": item.prospecting_type,
                "Visite effectuée ? prochaine action !": item.visit_carried_out,
                latitude: item.latitude,
                longitude: item.longitude,
            };
            // return {
            //     sale_representative_id: item.sale_representative_id,
            //     sale_representative_code: item.sale_representative_code,
            //     type_of_outlet: item.type_of_outlet,
            //     city: item.city,
            //     neighborhood: item.neighborhood,
            //     pos_name: item.pos_name,
            //     owner_name: item.owner_name,
            //     owner_phone_number: item.owner_phone_number,
            //     visit_note: item.visit_note,
            //     prospecting_type: item.prospecting_type,
            //     latitude: item.latitude,
            //     longitude: item.longitude,
            // };
          });
    
          // Créer un nouveau classeur
          const workbook = XLSX.utils.book_new();
    
          // Convertir les données en feuille de calcul
          const worksheet = XLSX.utils.json_to_sheet(data);
    
          // Ajouter la feuille de calcul au classeur
          XLSX.utils.book_append_sheet(workbook, worksheet, "event");
    
          // Générer un fichier Excel en mémoire
          const excelBuffer = XLSX.write(workbook, {
            type: "buffer",
            bookType: "xlsx",
          });
    
          // Définir les en-têtes HTTP pour télécharger le fichier
          res.setHeader("Content-Disposition", 'attachment; filename="sale_form_data.xlsx"');
          res.setHeader(
            "Content-Type",
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
          );
    
          // Envoyer le fichier Excel au client
          res.send(excelBuffer);
        } catch (error) {
          console.error(`Erreur lors du telechargement des datas ${error}`);
        }
      }
}

export const salesVisitService = new SalesVisitService();
