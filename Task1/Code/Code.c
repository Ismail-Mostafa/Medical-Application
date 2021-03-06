int sec=0;
int heart_rate=0;
int heart_rate_flag=0;
char Rx;
void interrupt()
{
 if(PIR1.TMR1IF==1)
 {
   sec++;
   if(sec==22)
   {
    heart_rate=TMR0*4;
    sec=0;
    TMR0=0;
    heart_rate_flag=1;
   }
   PIR1.TMR1IF=0;
   TMR1L=0xDB;//     3035
   TMR1H=0x0B;
 }

}

void main() {

char txt[7];  // uart string

int t;
int angel;

OPTION_REG.T0CS=1;   //Timer0 as counter


//TIMER1

T1CON=0b00110101;   //62500  *8 precsacle = 0.5 sec
TMR1L=0xDB;        //3035
TMR1H=0x0B;

//ENABLE INTERRUPT

INTCON.GIE=1;
INTCON.PEIE=1;
PIE1.TMR1IE=1;


//BLUETOOTH MODULE

uart1_init(9600);
while(1)
{



 if(uart1_data_ready())
 {
   Rx=uart1_read();
   uart1_write(Rx);
   TMR0=0;
   TMR1L=0xDB;//     3035
   TMR1H=0x0B;
 }
 if(Rx=='s')
 {
   if(heart_rate_flag==1)
   {
    uart1_write_text("Heart Rate= ");
    inttostr(heart_rate,txt);
    uart1_write_text(txt);
    uart1_write(13);

    t=adc_read(0)*0.4887;       //Temperature EQU
    inttostr(t,txt);
    uart1_write_text("Temperature= ");
    uart1_write_text(txt);
    heart_rate_flag=0;
    uart1_write(13);
    angel=((adc_read(1)-270)*1.3846);       //Temperature EQU
    inttostr(angel,txt);
    uart1_write_text("Angel= ");
    uart1_write_text(txt);
    if(angel>150||angel<30)
    {
     uart1_write_text("fall");
    }

    heart_rate_flag=0;
    uart1_write(13);
   }

  }
}

}