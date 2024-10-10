
import { Res } from "@nestjs/common";
import { Company } from "src/company/entities/company.entity";
import { Rating } from "src/company/entities/rating.entity";
import { Reservation } from "src/company/entities/reservation.entity";
import { AfterLoad, BeforeInsert, BeforeUpdate, Column, CreateDateColumn, DeleteDateColumn, Entity, OneToMany, PrimaryColumn, PrimaryGeneratedColumn } from "typeorm";


@Entity()
export class User {
    @PrimaryGeneratedColumn()
    id: number

    @OneToMany(()=>Rating, (Rating) => Rating.user)
    rating : Rating

    @OneToMany(()=>Company, (Company) => Company.user)
    company:Company

    @OneToMany(() => Reservation, (Reservation) =>Reservation.user)
    reservation: Reservation

    @Column()
    nickname: string

    @Column({nullable : true})
    age: number

    @Column({nullable : true})
    gender: string

    @Column()
    email: string

    @Column({nullable : true})
    password: string

    // @Column()
    // address: string

    @Column()
    join_path : string

    @Column({nullable : true})
    phone_number: string

    @Column()
    authority: string

    @CreateDateColumn()
    created_at: Date;

    @DeleteDateColumn()
    deleted_at : Date
}
