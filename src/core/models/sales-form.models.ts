import { Document } from "mongoose";

export type SalesFormModel = {
    sale_representative_id: string;
    sale_representative_code: string;
    type_of_outlet: string;
    city: string;
    neighborhood: string;
    pos_name: string;
    owner_name: string;
    owner_phone_number: number;
    visit_note: string;
    prospecting_type: string;
    customer_decision: string;
    repere: string;
    customer_status: string;
    crm: string;
    estimate_ca: number;
    ca_kaeyros: number
    category: string;
    type_of_business: string;
    latitude: string;
    longitude: string;
  };
    
    // Interface Mongoose pour le modèle de Users
  export interface SalesFormDoc extends Document, SalesFormModel {
    createdAt: Date;
    updatedAt: Date;
  }