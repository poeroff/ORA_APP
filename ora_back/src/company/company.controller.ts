import { Controller, Get, Post, Body, Patch, Param, Delete, BadRequestException } from '@nestjs/common';
import { CompanyService } from './company.service';
import { CreateCompanyDto } from './dto/create-company.dto';
import { UpdateCompanyDto } from './dto/update-company.dto';

@Controller('company')
export class CompanyController {
  constructor(private readonly companyService: CompanyService) {}

  @Post()
  create(@Body() createCompanyDto: CreateCompanyDto) {
    return this.companyService.create(createCompanyDto);
  }


  // 모든 업체 가져오기
  @Get()
  async findall_company() {
    return await this.companyService.findall_company();
  }
  //업체 예약 서비스
  @Post(':id')
  reservation_company(@Param('id') id: string, @Body() body: { email: string; }) {
    const { email } = body
    return this.companyService.reservation_company(+id,email);
  }

  //유저 업체 예약 확인 서비스
  @Post("/today/reservation")
  today_reservation(@Body() body: { email: string }){
    const { email } = body
    return this.companyService.today_reservation(email);
  }
  

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateCompanyDto: UpdateCompanyDto) {
    return this.companyService.update(+id, updateCompanyDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.companyService.remove(+id);
  }
}
