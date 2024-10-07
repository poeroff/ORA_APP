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
import { Rating } from './company/entities/rating.entity';
import { Reservation } from './company/entities/reservation.entity';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { Atmosphere } from './company/entities/atmosphere.entity';
import { Type } from './company/entities/type.entity';






@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true}),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule], useFactory: (configService: ConfigService) => ({
        type: 'mysql' as const ,
        host: configService.get<string>('DB_HOST'),
        port: configService.get<number>('DB_PORT'),
        username: configService.get<string>('DB_USERNAME'),
        password: configService.get<string>('DB_PASSWORD'),
        database: configService.get<string>('DB_DATABASE'),
        entities: [User, Medical_requiremetns, Shop_menu, Company, Type, Rating, Reservation, Atmosphere],
        charset: 'utf8mb4',
        synchronize: true,
        timezone: "+09:00"
      }), inject: [ConfigService],
    })
    , AuthModule, CompanyModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule { }
