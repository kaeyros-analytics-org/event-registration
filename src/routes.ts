// const express = require('express');
// const chatController = require('../controllers/chatController');
// const authController = require('../controllers/authController');
// const { protect } = require('../middleware/authMiddleware');

import express, { NextFunction, Request, Response } from 'express';
import { eventController } from './core/controllers/events/event.controller';
import { emailController } from './core/controllers/emails/email.controller';
import { salesFormController } from './core/controllers/sales-form/sales-form.controller';
import { salesRepresentativeController } from './core/controllers/sales-representative/sale-representative.controller';
const router = express.Router();

router.get('/', (req: Request, res: Response, next: NextFunction) => salesFormController.get(req, res, next));
router.get('/emails', (req: Request, res: Response, next: NextFunction) => emailController.list(req, res, next));
router.patch('/emails/update/:id', (req: Request, res: Response, next: NextFunction) => emailController.update(req, res, next));
router.post('/emails/create', (req: Request, res: Response, next: NextFunction) => emailController.create(req, res, next));
router.delete('/emails/delete/:id', (req: Request, res: Response, next: NextFunction) => emailController.delete(req, res, next));
// router.get('/email', (req: Request, res: Response, next: NextFunction) => eventController.email(req, res, next));
// router.get('/events/list', (req: Request, res: Response, next: NextFunction) => eventController.list(req, res, next));
// router.get('/events/list/download', (req: Request, res: Response, next: NextFunction) => eventController.download(req, res, next));
router.post('/', (req: Request, res: Response, next: NextFunction) => salesFormController.create(req, res, next));
router.get('/sales-representative/form', (req: Request, res: Response, next: NextFunction) => salesRepresentativeController.get(req, res, next));

router.get('/sales-representative', (req: Request, res: Response, next: NextFunction) => salesRepresentativeController.list(req, res, next));
router.post('/sales-representative/create', (req: Request, res: Response, next: NextFunction) => salesRepresentativeController.create(req, res, next));
router.patch('/sales-representative/update/:id', (req: Request, res: Response, next: NextFunction) => salesRepresentativeController.update(req, res, next));

router.get('/:code', (req: Request, res: Response, next: NextFunction) => salesFormController.get(req, res, next));
router.get('/sales-form/list', (req: Request, res: Response, next: NextFunction) => salesFormController.list(req, res, next));
router.get('/sales-form/list-by-code/:code', (req: Request, res: Response, next: NextFunction) => salesFormController.listByCode(req, res, next));
router.get('/sales-form/download', (req: Request, res: Response, next: NextFunction) => salesFormController.download(req, res, next));
router.post('/sales-form/create', (req: Request, res: Response, next: NextFunction) => salesFormController.create(req, res, next));
router.patch('/sales-form/update/:id', (req: Request, res: Response, next: NextFunction) => salesFormController.update(req, res, next));


export default router;
