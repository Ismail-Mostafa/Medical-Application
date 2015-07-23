void main() {
int heart;
int flag=0;
int rate=0;
uart_init(9600);

while(1)
{

 heart=adc_read(0);
 if(heart>200&&flag==0)
 {
  rate++;
  flag=1;
 }
 else


}





}