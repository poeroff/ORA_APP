import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateCompanyDto } from './dto/create-company.dto';
import { UpdateCompanyDto } from './dto/update-company.dto';
import { Company } from './entities/company.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Atmosphere } from './entities/atmosphere.entity';
import { Shop_menu } from './entities/shop_menu.entity';
import { Type } from './entities/type.entity';
import { User } from 'src/auth/entities/user.entity';
import { Reservation } from './entities/reservation.entity';

@Injectable()
export class CompanyService {
  constructor(@InjectRepository(Company) private readonly companyRepository : Repository<Company>,
              @InjectRepository(Atmosphere) private readonly atmosphereRepository : Repository<Atmosphere>,
              @InjectRepository(Shop_menu) private readonly shopmenuRepository : Repository<Shop_menu>,
              @InjectRepository(Type) private readonly typeRepository : Repository<Type>,
              @InjectRepository(Reservation) private readonly reservationRepository : Repository<Reservation>,
              @InjectRepository(User) private readonly userRepository : Repository<User>){}

  create(createCompanyDto: CreateCompanyDto) {
    return 'This action adds a new company';
  }

  async findall_company() {
    const company = await this.companyRepository.find({
      relations: ["atmosphere", "shop_menu", "type"]
    });

    const removeNullValues = (obj: any) => {
      if (Array.isArray(obj)) {
        return obj.map(item => removeNullValues(item)).filter(item => Object.keys(item).length > 0);
      }
      
      if (typeof obj !== 'object' || obj === null) {
        return obj;
      }
      
      return Object.fromEntries(
        Object.entries(obj)
          .filter(([_, v]) => v != null)
          .map(([k, v]) => [k, removeNullValues(v)])
      );
    };
    
    const processedCompany = removeNullValues(company);
    console.log(processedCompany)
   

    return processedCompany;
  }

  async find_company(id: number) {
    const company = await this.companyRepository.findOne({where : {id : +id},relations:["atmosphere","shop_menu","type"]})

    const removeNullValues = (obj: any) => {
      if (Array.isArray(obj)) {
        return obj.map(item => removeNullValues(item)).filter(item => Object.keys(item).length > 0);
      }
      
      if (typeof obj !== 'object' || obj === null) {
        return obj;
      }
      
      return Object.fromEntries(
        Object.entries(obj)
          .filter(([_, v]) => v != null)
          .map(([k, v]) => [k, removeNullValues(v)])
      );
    };
    
    const processedCompany = removeNullValues(company);

    return processedCompany;


    
  }
 async reservation_company(id : number,email: string){
  const user = await this.userRepository.findOne({where : {email}});
  if(!user){
    throw new NotFoundException("일치하는 유저가 없습니다.");
  }
  const compnay = await this.companyRepository.findOne({where : {id : id}})
  if(!user){
    throw new NotFoundException("일치하는 업체가 없습니다.");
  }
  
  const reservation = await this.reservationRepository.create({user : user, company: compnay});
  return await this.reservationRepository.save(reservation);
  



    
  }
  

  update(id: number, updateCompanyDto: UpdateCompanyDto) {
    return `This action updates a #${id} company`;
  }

  remove(id: number) {
    return `This action removes a #${id} company`;
  }
}
