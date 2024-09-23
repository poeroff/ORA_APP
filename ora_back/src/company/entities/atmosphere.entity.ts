import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { Company } from "./company.entity";

@Entity()
export class Atmosphere{
    @PrimaryGeneratedColumn()
    id : number

    @ManyToOne(()=>Company, (Company)=>Company.atmosphere)
    company : Company

    @Column({nullable : true})
    first_atmosphere : string

    @Column({nullable : true})
    second_atmosphere : string

    @Column({nullable : true})
    three_atmosphere : string

    @Column({nullable : true})
    four_atmosphere : string

    @Column({nullable : true})
    five_atmosphere : string
}