import { User } from "src/auth/entities/user.entity";
import { Column, Entity, JoinColumn, OneToMany, OneToOne, PrimaryGeneratedColumn } from "typeorm";
import { Tag } from "./tag.entity";
import { Shop_menu } from "./shop_menu.entity";
import { Rating } from "./rating.entity";
import { Reservation } from "./reservation.entity";

@Entity()
export class Company {
    @PrimaryGeneratedColumn()
    id : bigint

    @OneToOne(() => User, {onDelete:"CASCADE"})
    @JoinColumn({ name: "userId" })
    user_id : User

    @OneToMany(()=>Tag, (Tag) => Tag.company_id)
    tag_id : Tag

    @OneToMany(()=>Shop_menu, (Shop_menu) => Shop_menu.company)
    shop_id : Shop_menu

    @OneToMany(() => Reservation,(Reservation) => Reservation)
    reservation_id : Reservation

    @OneToMany(() => Rating, (Rating) => Rating.company)
    rating : Rating

    @Column()
    place : string

    @Column()
    category : string




}
 