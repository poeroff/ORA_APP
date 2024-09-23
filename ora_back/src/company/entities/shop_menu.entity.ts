import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { Company } from "./company.entity";

@Entity()
export class Shop_menu{
    @PrimaryGeneratedColumn()
    id : number

    @ManyToOne(() =>  Company)
    company : Company

    @Column()
    item : string

    @Column()
    price : number



}