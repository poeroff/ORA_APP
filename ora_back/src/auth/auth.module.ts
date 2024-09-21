import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { Medical_requiremetns } from './entities/medical_requirements.entity';

@Module({
  imports : [TypeOrmModule.forFeature([User, Medical_requiremetns])],
  controllers: [AuthController],
  providers: [AuthService],
})
export class AuthModule {}
