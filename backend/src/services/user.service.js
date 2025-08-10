import userModel from "../models/user.model.js"

export const createUser = async ({firstname,lastname,email,password,regnumber}) => {
    if(!firstname || !email || !password || !regnumber){
        throw new Error("All fields are required");
    }

    const user = await userModel.create({fullname:{
        firstname,
        lastname
    },email,
    password,
    regnumber});

    return user;
}

