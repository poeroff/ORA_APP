
import { Res } from "@nestjs/common";
import { Rating } from "src/company/entities/rating.entity";
import { Reservation } from "src/company/entities/reservation.entity";
import { AfterLoad, BeforeInsert, BeforeUpdate, Column, CreateDateColumn, DeleteDateColumn, Entity, OneToMany, PrimaryColumn, PrimaryGeneratedColumn } from "typeorm";


@Entity()
export class User {
    @PrimaryGeneratedColumn()
    id: bigint

    @OneToMany(()=>Rating, (Rating) => Rating.user_id)
    rating : Rating

    @OneToMany(() => Reservation, (Reservation) =>Reservation.user_id)
    reservation_id : Reservation

    @Column()
    nickname: string

    @Column()
    age: number

    @Column()
    gender: string

    @Column()
    email: string

    @Column()
    password: string

    @Column()
    address: string

    @Column()
    phone_number: string

    @Column()
    authority: string

    @CreateDateColumn()
    created_at: Date;

    @DeleteDateColumn()
    deleted_at : Date
}
