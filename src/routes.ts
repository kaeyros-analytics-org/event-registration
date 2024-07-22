// const express = require('express');
// const chatController = require('../controllers/chatController');
// const authController = require('../controllers/authController');
// const { protect } = require('../middleware/authMiddleware');

import express, { NextFunction, Request, Response } from 'express';
import { eventController } from './core/controllers/events/event.controller';
import { emailController } from './core/controllers/emails/email.controller';
const router = express.Router();

router.get('/', (req: Request, res: Response, next: NextFunction) => eventController.get(req, res, next));
router.get('/emails', (req: Request, res: Response, next: NextFunction) => emailController.list(req, res, next));
router.patch('/emails/update/:id', (req: Request, res: Response, next: NextFunction) => emailController.update(req, res, next));
router.post('/emails/create', (req: Request, res: Response, next: NextFunction) => emailController.create(req, res, next));
router.delete('/emails/delete/:id', (req: Request, res: Response, next: NextFunction) => emailController.delete(req, res, next));
router.get('/email', (req: Request, res: Response, next: NextFunction) => eventController.email(req, res, next));
router.get('/events/list', (req: Request, res: Response, next: NextFunction) => eventController.list(req, res, next));
router.post('/', (req: Request, res: Response, next: NextFunction) => eventController.create(req, res, next));

export default router;
