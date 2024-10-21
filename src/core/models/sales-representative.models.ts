import { Document } from "mongoose";

export type SalesRepresentativeModel = {
    name: string;
    code?: string;
  };
    
    // Interface Mongoose pour le modèle de SalesRepresentative
  export interface SalesRepresentativeDoc extends Document, SalesRepresentativeModel {
    createdAt: Date;
    updatedAt: Date;
  }