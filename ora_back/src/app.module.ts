import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './auth/entities/user.entity';

import { Medical_requiremetns } from './auth/entities/medical_requirements.entity';
import { CompanyModule } from './company/company.module';
import { Shop_menu } from './company/entities/shop_menu.entity';
import { Company } from './company/entities/company.entity';
import { Tag } from './company/entities/tag.entity';
import { Rating } from './company/entities/rating.entity';
import { Reservation } from './company/entities/reservation.entity';




@Module({
  imports: [ 
    TypeOrmModule.forRoot({
    type: 'mysql',
    host: 'youtube.cygahsyhplsd.ap-northeast-2.rds.amazonaws.com',
    port: 3306,
    username: 'admin',
    password: 'wqdsdsf123',
    database: 'ORA',
    entities: [User, Medical_requiremetns,Shop_menu,Company,Tag,Rating,Reservation],
    charset: 'utf8mb4',
    synchronize: true,
    timezone : "+09:00"
  }),AuthModule, CompanyModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
