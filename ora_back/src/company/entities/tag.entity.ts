import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { Company } from "./company.entity";

@Entity()
export class Tag{
    @PrimaryGeneratedColumn()
    id : bigint

    @ManyToOne(() => Company, (Company) => Company.tag)
    company: Company

    @Column({nullable : true})
    first_tag : string

    @Column({nullable : true})
    second_tag : string

    @Column({nullable : true})
    three_tag : string

    @Column({nullable : true})
    four_tag : string

    @Column({nullable : true})
    five_tag : string
    
} 