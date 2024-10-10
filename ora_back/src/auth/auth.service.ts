import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CreateAuthDto } from './dto/create-auth.dto';
import { UpdateAuthDto } from './dto/update-auth.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { Repository } from 'typeorm';

@Injectable()
export class AuthService {
  constructor(@InjectRepository(User) private readonly userRepository : Repository<User>){}
  
  async Kakaocreate(email: string, nickname: string,authority:string) {
    try{
      const DUPLICATE_EMAIL = await this.userRepository.findOne({where : {email}});
      if(DUPLICATE_EMAIL){
        return { status: 200, message: '이미 존재하는 이메일입니다.'}
      }
      const createuser = await this.userRepository.create({email : email , nickname : nickname,authority:authority,join_path :"카카오"});
      await this.userRepository.save(createuser);
      return { status: 200, message: '계정 생성 완료'}
    }
    catch (error) {
      throw new HttpException('사용자 생성 중 오류가 발생했습니다.', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }


  findAll() {
    return `This action returns all auth`;
  }

  findOne(id: number) {
    return `This action returns a #${id} auth`;
  }

  update(id: number, updateAuthDto: UpdateAuthDto) {
    return `This action updates a #${id} auth`;
  }

  remove(id: number) {
    return `This action removes a #${id} auth`;
  }
}
