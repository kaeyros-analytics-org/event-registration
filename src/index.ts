import dotenv from 'dotenv';
import connectDB from './core/database/connection';
import express, { NextFunction, Request, Response } from 'express';
import { createServer } from "http";
import cors from 'cors';
import router from './routes';
import fs from 'fs'
import path from 'path';

dotenv.config();
console.log(process.env.DATABASE_URL_DEV);

connectDB();

export const app = express();
const port = process.env.PORT || 3000;

app.set('view engine', 'ejs')

app.use(
  cors({
    origin: "*",
    credentials: true,
  })
);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const httpServer = createServer(app);

const publicDir = path.join(__dirname, '..', 'public');
if (!fs.existsSync(publicDir)) {
  fs.mkdirSync(publicDir);
}

// app.get('/', (req: Request, res: Response) => {console.log('App start xx');return res.send('App startx')});

app.use('/', router);
app.use(express.static(publicDir));

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});