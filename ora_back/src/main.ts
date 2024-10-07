import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

import * as dotenv from 'dotenv';
import {  ValidationPipe } from '@nestjs/common';




async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const cors = require('cors');
  app.use(cors());
  app.useGlobalPipes(new ValidationPipe({ transform: true }));
  app.enableCors({
    origin: "*", 
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    allowedHeaders: 'Content-Type,Accept,Authorization,X-XSRF-TOKEN,Cookie',
    exposedHeaders: ['Set-Cookie'],
    credentials: true,
    preflightContinue: false,
    optionsSuccessStatus: 204,
  });
  dotenv.config();
  await app.listen(4000,'0.0.0.0');
}
bootstrap();
