sbit dht22 at rb0_bit;    // dht22 connected to RB0

int time;
char x;
int int_flag;

unsigned short int packet[40];
unsigned short int index=0;

int num=36;
int ff=0;

int temp;
int humidity;

void start()
{
 dht22=0;
 trisb0_bit=0; // rb0 output
 delay_ms(5);
 trisb0_bit=1;  // rb0 input
 dht22=1;
 INTCON2.INTEDG0=0; // interrupt with falling edge
 INTCON.INT0IE=1;    // Enable interrupt
}

void conv_data()
{
unsigned int temp1=0;
unsigned int temp2=0;
int j;

for(j=0;j<16;j++)
{
 if(packet[j+2]>60&&packet[j+2]<80)   // one
 {
  temp1=temp1|(1<<(15-j));
 }
  else if(packet[j+2]>0&&packet[j+2]<40)    //zero
 {
  temp1=temp1|(0<<(15-j));
 }
}

for(j=0;j<16;j++)
{
 if(packet[j+18]>60&&packet[j+18]<80)
 {
  temp2=temp2|(1<<(15-j));
 }
  else if(packet[j+18]>0&&packet[j+18]<40)
 {
  temp2=temp2|(0<<(15-j));
 }
}


temp=temp2;
humidity=temp1;

}



void interrupt()
{
 if(INTCON.INT0IF==1)
 {
   if(ff==1&&dht22==0)   // falling interrupt
   {
   packet[index] = TMR0L;
   index++;
   ff=0;
   INTCON2.INTEDG0=1;
   }
   if(dht22==1)  // rising interrupt
   {
   ff=1;
   INTCON2.INTEDG0=0;
   TMR0L=0;               //timer 0 = 0
   }

   INTCON.INT0IF=0;
 }


}


void main() {
char send[4];
char send2[7];
int i;
INTCON=0b11000000; // RB0 interrupt when humditiy send data
T0CON = 0b11000001; //page 105  timer 0 count every 1 u sec 8bit mode
trisb0_bit=1; //RB0 input
INTCON2.INTEDG0=0;   //interrupt at falling edge
uart1_init(9600);
T1CON=1010
  while(1)
  {
   if(uart1_data_ready())
   {
    x=uart1_read();
    if(x=='1')
    {
     start();
    }
   }
  if(index>=num)
  {
   INTCON.INT0IE=0;   // stop interrupt
   index=0;
   conv_data();
   uart1_write_text("temp=");
   inttostr(temp,send2);
   uart1_write_text(send2);
   uart1_write(13);          //new line
   uart1_write_text("humidity=");
   inttostr(humidity,send2);
   uart1_write_text(send2);
   uart1_write(13);
  }

  }


}