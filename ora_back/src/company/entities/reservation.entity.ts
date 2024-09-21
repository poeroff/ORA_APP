import { User } from "src/auth/entities/user.entity";
import { Column, CreateDateColumn, DeleteDateColumn, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { Company } from "./company.entity";

@Entity()
export class Reservation{
    @PrimaryGeneratedColumn()
    id : bigint

    @ManyToOne(() => User, (User) => User.reservation_id)
    user_id : User

    @ManyToOne(() => Company , (Company) => Company.reservation_id)
    company : Company

    @Column()
    date : Date

    @CreateDateColumn()
    created_at: Date

    @DeleteDateColumn()
    deleted_at : Date


}