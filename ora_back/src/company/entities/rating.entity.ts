import { User } from "src/auth/entities/user.entity";
import { Column, CreateDateColumn, DeleteDateColumn, Entity, ManyToOne, OneToOne, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { Company } from "./company.entity";

@Entity()
export class Rating{
    @PrimaryGeneratedColumn()
    id : number

    @ManyToOne(() => User, (User) => User.rating)
    user: User

    @ManyToOne(() => Company, (Company)=>Company.rating)
    company : Company

    @Column()
    user_rating : number

    @CreateDateColumn()
    created_at: Date;

    @UpdateDateColumn()
    updated_at :Date

    @DeleteDateColumn()
    deleted_at : Date
}