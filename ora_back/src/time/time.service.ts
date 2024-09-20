import { Injectable } from '@nestjs/common';
import { CreateTimeDto } from './dto/create-time.dto';
import { UpdateTimeDto } from './dto/update-time.dto';
import moment from 'moment-timezone';

@Injectable()
export class TimeService {
  private readonly KOREA_TIMEZONE = 'Asia/Seoul';

  getCurrentKoreanTime(): Date {
    
    return moment().tz(this.KOREA_TIMEZONE).toDate();
    
  }

  formatToKoreanTime(date: Date): string {
    return moment(date).tz(this.KOREA_TIMEZONE).format('YYYY-MM-DD HH:mm:ss');
  }

  convertToKoreanTime(date: Date): Date {
    return moment(date).tz(this.KOREA_TIMEZONE).toDate();
  }
}
