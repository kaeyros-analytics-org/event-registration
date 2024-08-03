import nodemailer from 'nodemailer';
import ejs from 'ejs';
import path from 'path';
import { EventModel } from '../../models/events.models';

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
            poste: data.poste,
            email: data.email,
            phone_number_whatsapp: data.phone_number_whatsapp,
            creneau: data.creneau,
            nb_participant: nb_participant,
            is_promotion: data.is_promotion ? 'Oui': 'Non'
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
}

export const eventService = new EventService();