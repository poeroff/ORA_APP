import { Column, Entity, JoinColumn, OneToOne, PrimaryGeneratedColumn } from "typeorm";
import { User } from "./user.entity";

@Entity()
export class Medical_requiremetns{
    @PrimaryGeneratedColumn()
    id : bigint
    
    @OneToOne(() => User, {onDelete :"CASCADE"})
    @JoinColumn({ name: "userId" })
    user_id : User;

    @Column()
    height : number

    @Column()
    weight : number




}