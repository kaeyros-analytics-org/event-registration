// const express = require('express');
// const chatController = require('../controllers/chatController');
// const authController = require('../controllers/authController');
// const { protect } = require('../middleware/authMiddleware');

import express, { NextFunction, Request, Response } from 'express';
import { eventController } from './core/controllers/event.controller';
const router = express.Router();

router.get('/', (req: Request, res: Response, next: NextFunction) => eventController.get(req, res, next));
router.get('/events/list', (req: Request, res: Response, next: NextFunction) => eventController.list(req, res, next));
router.post('/', (req: Request, res: Response, next: NextFunction) => eventController.create(req, res, next));

export default router;
