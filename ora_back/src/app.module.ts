import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './auth/entities/user.entity';
import { TimeModule } from './time/time.module';




@Module({
  imports: [ 
    TypeOrmModule.forRoot({
    type: 'mysql',
    host: 'youtube.cygahsyhplsd.ap-northeast-2.rds.amazonaws.com',
    port: 3306,
    username: 'admin',
    password: 'wqdsdsf123',
    database: 'ORA',
    entities: [User],
    charset: 'utf8mb4',
    synchronize: true,
    timezone : "+09:00"
  }),AuthModule, TimeModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
