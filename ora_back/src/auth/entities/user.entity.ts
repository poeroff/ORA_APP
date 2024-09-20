import { TimeService } from "src/time/time.service";
import { AfterLoad, BeforeInsert, BeforeUpdate, Column, CreateDateColumn, DeleteDateColumn, Entity, PrimaryColumn, PrimaryGeneratedColumn } from "typeorm";


@Entity()
export class User {
    @PrimaryGeneratedColumn()
    id: bigint

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
