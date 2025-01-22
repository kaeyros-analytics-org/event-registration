import { Document } from "mongoose";

export type SalesVisitModel = {
    sale_representative_id: string;
    sale_representative_code: string;
    customer_name: string;
    business_name: string;
    contact: string;
    category: string;
    city: string
    type_of_business: string;
    address: string;
    customer_status: string;
    visit_objective: string;
    zone: string;
    achievement: string;
    comment: string;
    visit_carried_out: string;
    latitude: string;
    longitude: string;
  };
    
    // Interface Mongoose pour le modèle de Users
  export interface SalesVisitDoc extends Document, SalesVisitModel {
    createdAt: Date;
    updatedAt: Date;
  }