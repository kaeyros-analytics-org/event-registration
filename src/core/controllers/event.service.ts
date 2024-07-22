import nodemailer from 'nodemailer';

class EventService {

    async sendEmail(to: string, subject: string, text: string){
        // Create transporter object using SMTP transport
        let transporter = nodemailer.createTransport({
            // host: 'smtp-mail.outlook.com',
            // port: 587,
            // secure: false, 
            service: 'gmail',
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS,
            },
        });

        // Email options
        let mailOptions = {
            from: process.env.EMAIL_USER,
            to: to,
            subject: subject,
            text: text,
        };

        // Send email
        try {
            let info = await transporter.sendMail(mailOptions);
            return true;
            // res.status(200).send({ message: 'Email sent', info: info });
        } catch (error) {
            console.log('error == ', error);
            
            return false;
            // res.status(500).send({ message: 'Error sending email', error: error });
        }
    }
}

export const eventService = new EventService()