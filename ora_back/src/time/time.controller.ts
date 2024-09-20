import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { TimeService } from './time.service';
import { CreateTimeDto } from './dto/create-time.dto';
import { UpdateTimeDto } from './dto/update-time.dto';

@Controller('time')
export class TimeController {
  constructor(private readonly timeService: TimeService) {}

  @Get('now')
  getNow() {
    return this.timeService.getCurrentKoreanTime();
  }
}
