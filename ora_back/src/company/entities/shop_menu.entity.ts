import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { Company } from "./company.entity";

@Entity()
export class Shop_menu{
    @PrimaryGeneratedColumn()
    id : bigint

    @ManyToOne(() =>  Company)
    company : Company

    @Column()
    menu_name : string

    @Column()
    price : number



}