import nodemailer from "nodemailer";
import ejs from "ejs";
import path from "path";
import { EventDoc, EventModel } from "../../models/events.models";
import Event from "../../database/schemas/event.schemas";
import XLSX from "xlsx";
import { NextFunction, Request, Response } from "express";
import { SalesRepresentativeModel } from "../../models/sales-representative.models";
import SalesRepresentative from "../../database/schemas/sales-representative.schemas";
import { helpers } from "../../../utils/helpers";

class SalesRepresentativeService {

    async create(data: SalesRepresentativeModel, hostname: string|undefined): Promise<{status: number, message: any}>
    {
        try {

            let code =  helpers.generateUniqueId('KA-', 6);

            while(await SalesRepresentative.findOne({code: code})){code =  helpers.generateUniqueId('KA-', 6);}
            const dataSale = {
                name: data.name,
                code: code,
            }
            const existName = await SalesRepresentative.findOne({name: dataSale.name})
            if(existName) {
                const newSaleData = existName.toObject();
                const dataWithLink = {
                    ...newSaleData,
                    status: 200,
                    link: hostname ?`${hostname.startsWith('localhost')? 'http': 'https'}://${hostname}/${existName.code}`: `${helpers.getBaseUrl()}/${existName.code}`
                }

                return {status: 200, message: dataWithLink}
            }
            const saleData = await SalesRepresentative.create(dataSale)
            const newSaleData = saleData.toObject();
            const dataWithLink = {
                ...newSaleData,
                status: 201,
                link: hostname ?`${hostname.startsWith('localhost')? 'http': 'https'}://${hostname}/${saleData.code}`: `${helpers.getBaseUrl()}/${saleData.code}`
            }
            return {status: 201, message: dataWithLink}
            
        } catch (error) {
            console.log('error for create sale representative =', error);
            return {status: 400, message: `Error for create sale representative : ${error}`}
        }
    }

    async update(id: string, name: string): Promise<{status: number, message: any}>
    {
        try {

            const saleData = await SalesRepresentative.findByIdAndUpdate(id, {name: name})
            return {status: 200, message: saleData}
            
        } catch (error) {
            console.log('error for update sale representative =', error);
            return {status: 400, message: `Error for update sale representative : ${error}`}
        }
    }

    async getAll(): Promise<{status: number, message: any}>
    {
        try {

            const saleData = await SalesRepresentative.find({})
            return {status: 200, message: saleData}
            
        } catch (error) {
            console.log('error for get all sale representative =', error);
            return {status: 400, message: `Error for get all sale representative : ${error}`}
        }
    }

    async getById(id: string): Promise<{status: number, message: any}>
    {
        try {

            const saleData = await SalesRepresentative.findOne({id})
            return {status: 200, message: saleData}
            
        } catch (error) {
            console.log('error for get by id sale representative =', error);
            return {status: 400, message: `Error for get by id sale representative : ${error}`}
        }
    }

    async getByCodeWithLink(code: string, hostname: string|undefined): Promise<{status: number, message: any}>
    {
        try {
            console.log('code 22 =', code);

            const saleData = await SalesRepresentative.findOne({code})
            console.log('saleData =', saleData);
            
            if(saleData == null) return {status: 400, message: {message: "Sale Representative Not Found"}}
            console.log('saleData =', saleData);

            const saleFormData = saleData.toObject()

            console.log('hostname');
            
            
            const dataWithLink = {
                ...saleFormData,
                link: hostname ?`${hostname.startsWith('localhost')? 'http': 'https'}://${hostname}/${saleData.code}`: `${helpers.getBaseUrl()}/${saleData.code}`
            }
            return {status: 200, message: dataWithLink}
            
        } catch (error) {
            console.log('error for get by code sale representative =', error);
            return {status: 400, message: `Error for get by code sale representative : ${error}`}
        }
    }

    async getByCode(code: string): Promise<{status: number, message: any}>
    {
        try {

            const saleData = await SalesRepresentative.findOne({code})
            return {status: 200, message: saleData}
            
        } catch (error) {
            console.log('error for get by code sale representative =', error);
            return {status: 400, message: `Error for get by code sale representative : ${error}`}
        }
    }
}

export const salesRepresentativeService = new SalesRepresentativeService();
