import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { Company } from "./company.entity";

@Entity()
export class Type{
    @PrimaryGeneratedColumn()
    id : number

    @ManyToOne(() => Company, (Company) => Company.type)
    company: Company

    @Column({nullable : true})
    first_type : string

    @Column({nullable : true})
    second_type : string

    @Column({nullable : true})
    three_type : string

    @Column({nullable : true})
    four_type : string

    @Column({nullable : true})
    five_type : string
    
} 