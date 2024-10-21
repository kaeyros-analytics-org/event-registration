import SalesRepresentative from "../../database/schemas/sales-representative.schemas";
import { SalesFormModel } from "../../models/sales-form.models";
import SalesForm from "../../database/schemas/sales-form.schemas";
import { NextFunction, Request, Response } from "express";
import XLSX from "xlsx";

class SalesFormService {

    async create(data: SalesFormModel): Promise<{status: number, message: any}>
    {
        try {
            const sale_representative = await SalesRepresentative.findOne({code: data.sale_representative_code})
            if(sale_representative == null || sale_representative.id !== data.sale_representative_id) return {status: 400, message: "Sale Representative Not Found"}

            const saleFormData = await SalesForm.create(data)
            return {status: 201, message: saleFormData}
            
        } catch (error) {
            console.log('error for create sale form for representative =', error);
            return {status: 400, message: `Error for create sale form for representative : ${error}`}
        }
    }

    async listByCode(code: string): Promise<{status: number, message: any}>
    {
        try {
            const sale_representative = await SalesRepresentative.findOne({code: code})
            if(sale_representative == null) return {status: 400, message: "Sale Representative Not Found"}

            const saleFormData = await SalesForm.find({sale_representative_code: code}).populate('sale_representative_id')
            return {status: 200, message: saleFormData}
            
        } catch (error) {
            console.log('error for list by code sale form for representative =', error);
            return {status: 400, message: `Error for list by code for sale form for representative : ${error}`}
        }
    }

    async update(id: string, name: string): Promise<{status: number, message: any}>
    {
        try {

            const saleFormData = await SalesForm.findByIdAndUpdate(id, {name: name})
            return {status: 200, message: saleFormData}
            
        } catch (error) {
            console.log('error for update sale form for representative =', error);
            return {status: 400, message: `Error for update sale form for representative : ${error}`}
        }
    }

    async getAll(): Promise<{status: number, message: any}>
    {
        try {

            const saleFormData = await SalesForm.find({})
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
          const saleFormData = await SalesForm.find({});
    
          const data = saleFormData.map((item) => {
            return {
                "Id du representant": item.sale_representative_id,
                "Code du representant": item.sale_representative_code,
                "Type de point de vente": item.type_of_outlet,
                "Ville": item.city,
                "Quartier": item.neighborhood,
                "Nom du point de vente": item.pos_name,
                "Nom du Propriétaire": item.owner_name,
                "Numéro de téléphone du propriétaire": item.owner_phone_number,
                "Notes de visite": item.visit_note,
                "Type de prospection": item.prospecting_type,
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

export const salesFormService = new SalesFormService();
