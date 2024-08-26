import nodemailer from 'nodemailer';
import ejs from 'ejs';
import path from 'path';
import { EventDoc, EventModel } from '../../models/events.models';
import Event from '../../database/schemas/event.schemas';
import XLSX from 'xlsx';
import { NextFunction, Request, Response } from 'express';


class EventService{

    async sendEmail(to: string, subject: string, data: EventModel, nb_participant: number ){
        const hostSTMP = process.env.EMAIL_HOST;
        const STMPport = process.env.EMAIL_PORT || 465;
        const STMPsecure = process.env.EMAIL_IS_SECURE || false;
        console.log('process.env.EMAIL_IS_SECURE ==', STMPsecure);
        console.log('process.env.EMAIL_IS_SECURE ==', STMPsecure);
        
        console.log('secure ==', Boolean(STMPsecure));

        const dataEmail = {
            first_name: data.first_name,
            last_name: data.last_name,
            company_name: data.company_name,
            sector_of_activity: data.sector_of_activity,
            district: data.district,
            poste: data.poste,
            email: data?.email ?? '',
            phone_number_whatsapp: data.phone_number_whatsapp,
            creneau: data.creneau,
            nb_participant: nb_participant,
            is_promotion: data.is_promotion ? 'Oui': 'Non',
            collaborate_name: data.collaborate_name
        }

        const html= await ejs.renderFile(path.join(__dirname,`../../../../views/emails/event.ejs`), dataEmail);
        
        // Create transporter object using SMTP transport
        let transporter = nodemailer.createTransport({
            // service: 'Outlook365', // or any other email service
            host: hostSTMP,
            port: Number(STMPport),
            secure: false,
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS,
            },
            tls: {
                ciphers:'SSLv3'
            }
        });

        // Email options
        let mailOptions = {
            from: process.env.EMAIL_USER,
            to: to,
            subject: subject,
            html: html,
        };

        // Send email
        try {
            let info = await transporter.sendMail(mailOptions);
            console.log('info send ==', info);
            
            return true
            // res.status(200).send({ message: 'Email sent', info: info });
        } catch (error) {
            console.log('error for send mail', error);
            return false;
            // res.status(500).send({ message: 'Error sending email', error: error });
        }
    }

    async downloadDataExcel(req: Request, res: Response, next: NextFunction): Promise<any>
    {
        try {
            const event = await Event.find();

            const data = event.map(item => {
                return {
                    first_name: item.first_name,
                    last_name: item.last_name,
                    company_name: item.company_name,
                    poste: item.poste,
                    email: item.email,
                    sector_of_activity: item.sector_of_activity,
                    district: item.district,
                    phone_number_whatsapp: item.phone_number_whatsapp,
                    is_promotion: item.is_promotion ? 'true': 'false',
                    creneau: item.creneau,
                    latitude: item.latitude,
                    longitude: item.longitude,
                    collaborate_name: item.collaborate_name
                }
            })

            // Créer un nouveau classeur
            const workbook = XLSX.utils.book_new();

            // Convertir les données en feuille de calcul
            const worksheet = XLSX.utils.json_to_sheet(data);

            // Ajouter la feuille de calcul au classeur
            XLSX.utils.book_append_sheet(workbook, worksheet, 'event');

            // Générer un fichier Excel en mémoire
            const excelBuffer = XLSX.write(workbook, { type: 'buffer', bookType: 'xlsx' });

            // Définir les en-têtes HTTP pour télécharger le fichier
            res.setHeader('Content-Disposition', 'attachment; filename="data.xlsx"');
            res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

            // Envoyer le fichier Excel au client
            res.send(excelBuffer);
        } catch (error) {
            console.error(`Erreur lors du telechargement des datas ${error}`)
        }
    }
}

export const eventService = new EventService();