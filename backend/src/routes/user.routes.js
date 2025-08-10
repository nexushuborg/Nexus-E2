import express from "express"
import { Router} from 'express'
import { body } from "express-validator";
const router = Router();
import { registerUser } from "../controllers/user.controller.js"
import { loginUser } from "../controllers/user.controller.js";
import {getUserProfile} from "../controllers/user.controller.js";
import {authUser} from '../middlewares/auth.middleware.js'
import { logoutUser } from "../controllers/user.controller.js";

router.post('/register',[body('email').isEmail().withMessage('Email must be a valid email address'),
    body('password').isLength({min:6}).withMessage('password must be 6 characters long')],registerUser)

router.post('/login',[body('email').isEmail().withMessage('Email must be a valid email address'),
    body('password').isLength({min:6}).withMessage('password must be 6 characters long')],loginUser)

router.get('/profile',authUser,getUserProfile)
router.get('/logout',authUser,logoutUser)
export default router