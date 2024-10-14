import { Document } from "mongoose";

export type EventModel = {
    company_name: string;
    type_of_business: string;
    promoter_name: string;
    opening_time: string;
    phone_number_whatsapp: string;
    is_promotion: boolean;
    location: string;
    latitude?: string;
    longitude?: string;
  };
    
    // Interface Mongoose pour le modèle de Users
  export interface EventDoc extends Document, EventModel {
    createdAt: Date;
    updatedAt: Date;
  }