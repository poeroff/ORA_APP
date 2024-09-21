import { Module } from '@nestjs/common';
import { CompanyService } from './company.service';
import { CompanyController } from './company.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Company } from './entities/company.entity';
import { Shop_menu } from './entities/shop_menu.entity';
import { Tag } from './entities/tag.entity';
import { Rating } from './entities/rating.entity';
import { Reservation } from './entities/reservation.entity';

@Module({
  imports : [TypeOrmModule.forFeature([Company,Shop_menu,Tag,Rating,Reservation])],
  controllers: [CompanyController],
  providers: [CompanyService],
})
export class CompanyModule {}
