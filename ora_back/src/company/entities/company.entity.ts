import { User } from "src/auth/entities/user.entity";
import { Column, Entity, JoinColumn, ManyToOne, OneToMany, OneToOne, PrimaryGeneratedColumn } from "typeorm";
import {  Type } from "./type.entity";
import { Shop_menu } from "./shop_menu.entity";
import { Rating } from "./rating.entity";
import { Reservation } from "./reservation.entity";
import { Atmosphere } from "./atmosphere.entity";


@Entity()
export class Company {
    @PrimaryGeneratedColumn()
    id : number

    @ManyToOne(() => User, (User)=>User.company,{onDelete:"CASCADE"})
    user: User

    @OneToMany(()=>Type, (Type) => Type.company)
    type: Type

    @OneToMany(()=>Shop_menu, (Shop_menu) => Shop_menu.company)
    shop_menu : Shop_menu

    @OneToMany(() => Reservation,(Reservation) => Reservation)
    reservation: Reservation

    @OneToMany(() => Rating, (Rating) => Rating.company)
    rating : Rating

    @OneToMany(()=>Atmosphere, (Atmosphere) => Atmosphere.company)
    atmosphere : Atmosphere;

    @Column()
    name: string

    @Column()
    location : string

    @Column({default: 0})
    total_rating : number

}
 