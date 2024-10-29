import { User } from "src/auth/entities/user.entity";
import { Column, CreateDateColumn, DeleteDateColumn, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { Company } from "./company.entity";

@Entity()
export class Reservation{
    @PrimaryGeneratedColumn()
    id : number

    @ManyToOne(() => User, (User) => User.reservation)
    user: User

    @ManyToOne(() => Company , (Company) => Company.reservation)
    company : Company

    // @Column()
    // date : Date

    @CreateDateColumn()
    created_at: Date

    @DeleteDateColumn()
    deleted_at : Date


}